#!/usr/bin/env python3
"""Taint-simplify the linear call-next setup at the crypto VM dispatcher."""

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
SETUP_START = 0x180C43FDD
SETUP_END = 0x180C441AA


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
INPUT_LABELS = {"OUTPUT", "KID", "KEYMAT", "CONTEXT", "PLAINTEXT"}


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--runtime-bugland", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    blob = args.runtime_bugland.read_bytes()
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    md.detail = True
    instructions = list(
        md.disasm(
            blob[SETUP_START - BUGLAND_BASE : SETUP_END - BUGLAND_BASE],
            SETUP_START,
        )
    )
    if not instructions or instructions[-1].address != 0x180C441A8:
        raise ValueError("linear setup did not end at expected pop r9")

    def register_name(register_id: int) -> str:
        name = md.reg_name(register_id)
        return REGISTER_ALIAS.get(name, name)

    registers = {register: {f"ENTRY_{register.upper()}"} for register in GPRS}
    registers["rcx"] = {"OUTPUT"}
    registers["rdx"] = {"KID"}
    registers["r8"] = {"KEYMAT"}
    registers["r9"] = {"CONTEXT"}
    # State at 0x180c43fdd from the separately verified VM prologue.
    stack_pointer = -0x20
    memory = {
        -0x20: set(),
        -0x18: {"ENTRY_RFLAGS"},
        -0x10: set(),
        -0x08: set(),
        0x00: {"RETURN"},
        0x28: {"PLAINTEXT"},
    }
    external_tainted_accesses = []

    def read_operand(operand, rsp_override=None):
        rsp = stack_pointer if rsp_override is None else rsp_override
        if operand.type == X86_OP_REG:
            return set(registers[register_name(operand.reg)])
        if operand.type == X86_OP_IMM:
            return set()
        if operand.type == X86_OP_MEM:
            if (
                operand.mem.base
                and register_name(operand.mem.base) == "rsp"
                and operand.mem.index == 0
            ):
                return set(memory.get(rsp + operand.mem.disp, set()))
            address_taint = set()
            if operand.mem.base:
                address_taint |= registers.get(register_name(operand.mem.base), set())
            if operand.mem.index:
                address_taint |= registers.get(register_name(operand.mem.index), set())
            input_address_taint = sorted(address_taint & INPUT_LABELS)
            if input_address_taint:
                external_tainted_accesses.append(
                    {"kind": "read", "address_taint": input_address_taint}
                )
            return {f"DEREF({label})" for label in address_taint}
        raise ValueError("unsupported source")

    def write_operand(operand, taint, rsp_override=None, union=False):
        rsp = stack_pointer if rsp_override is None else rsp_override
        if operand.type == X86_OP_REG:
            register = register_name(operand.reg)
            registers[register] = (
                registers.get(register, set()) | taint if union else set(taint)
            )
            return
        if operand.type == X86_OP_MEM:
            if (
                operand.mem.base
                and register_name(operand.mem.base) == "rsp"
                and operand.mem.index == 0
            ):
                address = rsp + operand.mem.disp
                memory[address] = memory.get(address, set()) | taint if union else set(taint)
                return
            address_taint = set()
            if operand.mem.base:
                address_taint |= registers.get(register_name(operand.mem.base), set())
            if operand.mem.index:
                address_taint |= registers.get(register_name(operand.mem.index), set())
            interesting = sorted((address_taint | taint) & INPUT_LABELS)
            if interesting:
                external_tainted_accesses.append(
                    {
                        "kind": "write",
                        "address_taint": sorted(address_taint & INPUT_LABELS),
                        "value_taint": sorted(taint & INPUT_LABELS),
                    }
                )
            return
        raise ValueError("unsupported destination")

    for instruction in instructions:
        mnemonic = instruction.mnemonic
        operands = instruction.operands
        if mnemonic == "call":
            if operands[0].type != X86_OP_IMM or operands[0].imm != instruction.address + 5:
                raise ValueError("setup call is not the expected call-next idiom")
            stack_pointer -= 8
            memory[stack_pointer] = set()
        elif mnemonic == "push":
            taint = read_operand(operands[0])
            stack_pointer -= 8
            memory[stack_pointer] = taint
        elif mnemonic == "pop":
            taint = set(memory.get(stack_pointer, set()))
            stack_pointer += 8
            write_operand(operands[0], taint, stack_pointer)
        elif mnemonic in ("mov", "movabs"):
            write_operand(operands[0], read_operand(operands[1]))
        elif (
            mnemonic in ("add", "sub")
            and operands[0].type == X86_OP_REG
            and register_name(operands[0].reg) == "rsp"
            and operands[1].type == X86_OP_IMM
        ):
            stack_pointer += operands[1].imm if mnemonic == "add" else -operands[1].imm
        elif mnemonic in ("add", "sub", "xor", "and", "or"):
            write_operand(operands[0], read_operand(operands[1]), union=True)
        elif mnemonic in ("inc", "dec", "not", "neg", "shl", "shr"):
            # Unary/constant transforms preserve taint.
            pass
        else:
            raise ValueError(
                f"unsupported instruction {instruction.address:#x}: "
                f"{mnemonic} {instruction.op_str}"
            )

    register_taints = {
        register: sorted(taint & INPUT_LABELS)
        for register, taint in registers.items()
        if taint & INPUT_LABELS
    }
    stack_taints = {
        f"entry_rsp{address:+#x}": sorted(taint & INPUT_LABELS)
        for address, taint in sorted(memory.items())
        if taint & INPUT_LABELS
    }
    expected_register_taints = {"r8": ["OUTPUT"], "rdx": ["KID"]}
    expected_stack_taints = {
        "entry_rsp-0x98": ["KEYMAT"],
        "entry_rsp-0x90": ["CONTEXT"],
        "entry_rsp-0x30": ["KID"],
        "entry_rsp+0x28": ["PLAINTEXT"],
    }
    if register_taints != expected_register_taints:
        raise ValueError(f"unexpected final argument register taints: {register_taints}")
    for slot, expected in expected_stack_taints.items():
        if stack_taints.get(slot) != expected:
            raise ValueError(f"unexpected taint at {slot}: {stack_taints.get(slot)}")
    if external_tainted_accesses:
        raise ValueError(f"unexpected object dereference/store: {external_tainted_accesses}")

    result = {
        "schema": "maxhook.vm.setup-taint/v1",
        "range": [hex(SETUP_START), hex(SETUP_END)],
        "instruction_count": len(instructions),
        "entry_rsp_relative_at_start": -0x20,
        "entry_rsp_relative_at_end": stack_pointer,
        "call_next_verified": True,
        "final_argument_register_taints": register_taints,
        "final_argument_stack_taints": stack_taints,
        "input_objects_dereferenced_in_range": False,
        "semantic_summary": {
            "output": "R8",
            "kid": "RDX and [ENTRY_RSP-0x30]",
            "key_material": "[ENTRY_RSP-0x98]",
            "context": "[ENTRY_RSP-0x90]",
            "plaintext": "[ENTRY_RSP+0x28]",
        },
        "inputs": {"runtime_bugland_sha256": sha256_file(args.runtime_bugland)},
    }
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(f"wrote {args.output.resolve()}")
    print(
        f"instructions={len(instructions)} end_rsp={stack_pointer:#x} "
        f"register_taints={register_taints}"
    )
    print(f"stack_taints={stack_taints}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
