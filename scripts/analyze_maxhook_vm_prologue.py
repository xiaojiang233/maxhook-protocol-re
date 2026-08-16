#!/usr/bin/env python3
"""Symbolically simplify the MaxHook crypto VM entry prologue."""

from __future__ import annotations

import argparse
import hashlib
import json
import sys
from pathlib import Path

LOCAL_DEPS = Path(__file__).resolve().with_name(".pydeps")
if LOCAL_DEPS.is_dir():
    sys.path.insert(0, str(LOCAL_DEPS))

from capstone import CS_ARCH_X86, CS_MODE_64, Cs  # noqa: E402
from capstone.x86_const import X86_OP_IMM, X86_OP_MEM, X86_OP_REG  # noqa: E402


BUGLAND_BASE = 0x180980000
PROLOGUE_START = 0x181523001
PROLOGUE_END = 0x18152315D
DISPATCHER = 0x180C43FDD
MASK64 = (1 << 64) - 1


REGISTER_FAMILIES = {
    "rax": ("rax", "eax", "ax", "al", "ah"),
    "rbx": ("rbx", "ebx", "bx", "bl", "bh"),
    "rcx": ("rcx", "ecx", "cx", "cl", "ch"),
    "rdx": ("rdx", "edx", "dx", "dl", "dh"),
    "rsi": ("rsi", "esi", "si", "sil"),
    "rdi": ("rdi", "edi", "di", "dil"),
    "rbp": ("rbp", "ebp", "bp", "bpl"),
    "rsp": ("rsp", "esp", "sp", "spl"),
}
for number in range(8, 16):
    REGISTER_FAMILIES[f"r{number}"] = (
        f"r{number}",
        f"r{number}d",
        f"r{number}w",
        f"r{number}b",
    )
REGISTER_ALIAS = {
    alias: full for full, aliases in REGISTER_FAMILIES.items() for alias in aliases
}
GPRS = [
    "rax",
    "rbx",
    "rcx",
    "rdx",
    "rsi",
    "rdi",
    "rbp",
    "r8",
    "r9",
    "r10",
    "r11",
    "r12",
    "r13",
    "r14",
    "r15",
]


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def display(value) -> str:
    return hex(value) if isinstance(value, int) else value


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--runtime-bugland", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    blob = args.runtime_bugland.read_bytes()
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    md.detail = True
    start_offset = PROLOGUE_START - BUGLAND_BASE
    end_offset = PROLOGUE_END - BUGLAND_BASE
    instructions = list(md.disasm(blob[start_offset:end_offset], PROLOGUE_START))
    if not instructions or instructions[-1].address != 0x181523158:
        raise ValueError("prologue disassembly did not end at the expected jump")

    registers = {register: f"ENTRY_{register.upper()}" for register in GPRS}
    stack_pointer = 0
    memory = {
        offset: f"ENTRY_STACK[{offset:+#x}]"
        for offset in range(-0x100, 0x101, 8)
    }
    trace = []

    def register_name(register_id: int) -> str:
        name = md.reg_name(register_id)
        return REGISTER_ALIAS.get(name, name)

    def read_operand(operand, rsp_override=None):
        rsp = stack_pointer if rsp_override is None else rsp_override
        if operand.type == X86_OP_REG:
            return registers[register_name(operand.reg)]
        if operand.type == X86_OP_IMM:
            return operand.imm & MASK64
        if (
            operand.type == X86_OP_MEM
            and register_name(operand.mem.base) == "rsp"
            and operand.mem.index == 0
        ):
            address = rsp + operand.mem.disp
            return memory.get(address, f"MEM[{address:+#x}]")
        raise ValueError("unsupported source operand")

    def write_operand(operand, value, rsp_override=None):
        rsp = stack_pointer if rsp_override is None else rsp_override
        if operand.type == X86_OP_REG:
            registers[register_name(operand.reg)] = value
            return
        if (
            operand.type == X86_OP_MEM
            and register_name(operand.mem.base) == "rsp"
            and operand.mem.index == 0
        ):
            memory[rsp + operand.mem.disp] = value
            return
        raise ValueError("unsupported destination operand")

    for instruction in instructions:
        mnemonic = instruction.mnemonic
        operands = instruction.operands
        before_rsp = stack_pointer
        if mnemonic == "pushfq":
            stack_pointer -= 8
            memory[stack_pointer] = "ENTRY_RFLAGS"
        elif mnemonic == "push":
            value = read_operand(operands[0])
            stack_pointer -= 8
            memory[stack_pointer] = value
        elif mnemonic == "pop":
            value = memory.get(stack_pointer, f"MEM[{stack_pointer:+#x}]")
            stack_pointer += 8
            # x86 POP r/m using RSP computes the effective destination address
            # after incrementing RSP.
            write_operand(operands[0], value, stack_pointer)
        elif mnemonic in ("mov", "movabs"):
            write_operand(operands[0], read_operand(operands[1]))
        elif (
            mnemonic in ("add", "sub")
            and operands[0].type == X86_OP_REG
            and register_name(operands[0].reg) == "rsp"
            and operands[1].type == X86_OP_IMM
        ):
            delta = operands[1].imm if mnemonic == "add" else -operands[1].imm
            stack_pointer += delta
        elif mnemonic in ("shr", "xor") and operands[0].type == X86_OP_REG:
            register = register_name(operands[0].reg)
            left = registers[register]
            right = read_operand(operands[1])
            if isinstance(left, int) and isinstance(right, int):
                registers[register] = (
                    left >> right if mnemonic == "shr" else (left ^ right) & MASK64
                )
            else:
                operator = ">>" if mnemonic == "shr" else "^"
                registers[register] = f"({display(left)} {operator} {display(right)})"
        elif mnemonic == "jmp":
            if operands[0].type != X86_OP_IMM or operands[0].imm != DISPATCHER:
                raise ValueError("unexpected prologue jump target")
        else:
            raise ValueError(
                f"unsupported instruction {instruction.address:#x}: "
                f"{mnemonic} {instruction.op_str}"
            )
        trace.append(
            {
                "address": hex(instruction.address),
                "instruction": f"{mnemonic} {instruction.op_str}".strip(),
                "rsp_before": before_rsp,
                "rsp_after": stack_pointer,
            }
        )

    final_registers = {register: display(value) for register, value in registers.items()}
    preserved = {
        register: value == f"ENTRY_{register.upper()}"
        for register, value in registers.items()
    }
    stack_slots = []
    for address in range(stack_pointer, 0x31, 8):
        stack_slots.append(
            {
                "dispatcher_rsp_offset": hex(address - stack_pointer),
                "entry_rsp_offset": hex(address),
                "value": display(memory.get(address, f"MEM[{address:+#x}]")),
            }
        )
    result = {
        "schema": "maxhook.vm.prologue-symbolic/v1",
        "range": [hex(PROLOGUE_START), hex(PROLOGUE_END)],
        "dispatcher": hex(DISPATCHER),
        "instruction_count": len(instructions),
        "dispatcher_rsp_minus_entry_rsp": stack_pointer,
        "all_gprs_preserved": all(preserved.values()),
        "preserved_registers": preserved,
        "final_registers": final_registers,
        "dispatcher_stack": stack_slots,
        "abi_taint_origins": {
            "output_object": "RCX",
            "kid_string_object": "RDX",
            "key_material_string_object": "R8",
            "context_object": "R9",
            "plaintext_string_object_at_entry": "[ENTRY_RSP+0x28]",
            "plaintext_string_object_at_dispatcher": "[DISPATCHER_RSP+0x48]",
        },
        "trace": trace,
        "inputs": {"runtime_bugland_sha256": sha256_file(args.runtime_bugland)},
    }
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(f"wrote {args.output.resolve()}")
    print(
        f"instructions={len(instructions)} rsp_delta={stack_pointer:#x} "
        f"all_gprs_preserved={all(preserved.values())}"
    )
    for slot in stack_slots[:5]:
        print(
            f"dispatcher_rsp+{slot['dispatcher_rsp_offset']} = {slot['value']}"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
