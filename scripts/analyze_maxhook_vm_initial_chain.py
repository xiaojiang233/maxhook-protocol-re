#!/usr/bin/env python3
"""Statically prove the MaxHook crypto VM context and initial dispatch chain."""

from __future__ import annotations

import argparse
import hashlib
import json
import struct
import sys
from pathlib import Path

LOCAL_DEPS = Path(__file__).resolve().with_name(".pydeps")
if LOCAL_DEPS.is_dir():
    sys.path.insert(0, str(LOCAL_DEPS))

from capstone import CS_ARCH_X86, CS_MODE_64, Cs  # noqa: E402
from capstone.x86_const import X86_OP_IMM, X86_OP_REG  # noqa: E402


IMAGE_BASE = 0x180000000
BUGLAND_BASE = 0x180980000
TABLE_VA = 0x180C64EBD
MASK32 = 0xFFFFFFFF

CHOSEN_BRANCHES = {
    0x180C443AA: 0x180C4440D,
    0x180C444EB: 0x180C44642,
    0x180C446A1: 0x180C446A7,
    0x180C446E9: 0x180C446FF,
    0x180C4470D: 0x180C44713,
    0x180C44B28: 0x180C44B58,
    0x180C44B5B: 0x180C44C78,
    0x180C44C7C: 0x180C44C9A,
}


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def u32(value: int) -> int:
    return value & MASK32


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--runtime-bugland", type=Path, required=True)
    parser.add_argument("--prologue-json", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    blob = args.runtime_bugland.read_bytes()
    prologue = json.loads(args.prologue_json.read_text(encoding="utf-8"))
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    md.detail = True

    def decode(address: int):
        offset = address - BUGLAND_BASE
        instruction = next(md.disasm(blob[offset : offset + 15], address, count=1), None)
        if instruction is None:
            raise ValueError(f"cannot decode {address:#x}")
        return instruction

    def require(address: int, mnemonic: str, op_str: str):
        instruction = decode(address)
        if instruction.mnemonic != mnemonic or instruction.op_str != op_str:
            raise ValueError(
                f"unexpected {address:#x}: {instruction.mnemonic} {instruction.op_str}; "
                f"wanted {mnemonic} {op_str}"
            )
        return instruction

    def read_u16(address: int) -> int:
        return struct.unpack_from("<H", blob, address - BUGLAND_BASE)[0]

    def read_i32(address: int) -> int:
        return struct.unpack_from("<i", blob, address - BUGLAND_BASE)[0]

    def read_u32(address: int) -> int:
        return struct.unpack_from("<I", blob, address - BUGLAND_BASE)[0]

    def read_u64(address: int) -> int:
        return struct.unpack_from("<Q", blob, address - BUGLAND_BASE)[0]

    def table_target(index: int) -> int:
        return read_u64(TABLE_VA + index * 8)

    # The call-next setup makes RCX the module base.  The following 32-bit
    # constant is then zero-extended into RBP; the surrounding 64-bit adds and
    # subtracts cancel pairwise around `add rbp, rcx`.
    require(0x180C441AA, "sub", "rcx, 5")
    require(0x180C441AE, "sub", "rcx, 0xc43fdd")
    require(0x180C441CF, "mov", "qword ptr [rsp], 0x38ffc137")
    require(0x180C441E7, "mov", "ebp, ebx")
    require(0x180C4420D, "add", "rbp, rcx")
    context_rva = u32(0x38FFC137 - MASK32)
    context_rva &= 0x7F2C79BD
    context_rva = u32(context_rva - 0x379378B4)
    if context_rva != 0x98C884:
        raise ValueError(f"unexpected VM context RVA {context_rva:#x}")
    context_va = IMAGE_BASE + context_rva

    # Recompute RSP along the statically selected bootstrap path.  This proves
    # both prologue constants' source slots without relying on Stalker order.
    address = 0x180C43FDD
    rsp = -0x20  # relative to the native function entry RSP
    rsp_at: dict[int, int] = {}
    steps = 0
    while True:
        instruction = decode(address)
        rsp_at[address] = rsp
        if instruction.mnemonic in {"push", "pushfq", "call"}:
            rsp -= 8
        elif instruction.mnemonic in {"pop", "popfq"}:
            rsp += 8
        elif (
            instruction.mnemonic in {"add", "sub"}
            and instruction.operands[0].type == X86_OP_REG
            and md.reg_name(instruction.operands[0].reg) == "rsp"
            and instruction.operands[1].type == X86_OP_IMM
        ):
            amount = instruction.operands[1].imm
            rsp += amount if instruction.mnemonic == "add" else -amount
        if address == 0x180C44CED:
            break
        if address in CHOSEN_BRANCHES:
            address = CHOSEN_BRANCHES[address]
        elif instruction.mnemonic == "jmp" and instruction.operands[0].type == X86_OP_IMM:
            address = instruction.operands[0].imm
        else:
            address += instruction.size
        steps += 1
        if steps > 2000:
            raise ValueError("bootstrap path did not terminate")

    require(0x180C449B0, "push", "qword ptr [rsp + 0x90]")
    require(0x180C44A18, "pop", "qword ptr [rbx + rbp]")
    require(0x180C44A1B, "add", "qword ptr [rbx + rbp], 0x33cd8c5c")
    require(0x180C44C9A, "push", "qword ptr [rsp + 0x88]")
    if rsp_at[0x180C449B0] != -0x98 or rsp_at[0x180C44C9A] != -0x98:
        raise ValueError("unexpected bootstrap RSP at constant load")

    stack_by_entry_offset = {
        item["entry_rsp_offset"]: int(item["value"], 16)
        for item in prologue["dispatcher_stack"]
        if isinstance(item["value"], str) and item["value"].startswith("0x")
    }
    vip_seed_rva = stack_by_entry_offset["-0x8"]
    bootstrap_index = stack_by_entry_offset["-0x10"]
    if vip_seed_rva != 0x1555629 or bootstrap_index != 0x2CA:
        raise ValueError("unexpected prologue constants")
    if rsp_at[0x180C449B0] + 0x90 != -0x8:
        raise ValueError("VIP seed stack source mismatch")
    initial_vip = IMAGE_BASE + vip_seed_rva

    # The first real dispatcher consumes [VIP+0] as an unkeyed table index and
    # [VIP+2] as the signed advance before entering the selected handler.
    require(0x180A9803C, "mov", "r11w, word ptr [rbx]")
    require(0x180A98068, "shl", "r11, 3")
    require(0x180A98094, "movsxd", "r13, dword ptr [r8]")
    require(0x180A980DC, "add", "qword ptr [rsi], r13")
    require(0x180A98103, "jmp", "rdx")
    first_index = read_u16(initial_vip)
    first_advance = read_i32(initial_vip + 2)
    first_handler_vip = initial_vip + first_advance
    first_target = table_target(first_index)
    if (first_index, first_advance, first_target) != (0x147, 0xDBC5, 0x1809AC48D):
        raise ValueError("unexpected first VM dispatch")
    require(first_target, "jmp", "0x1809f4736")

    initial_key = read_u32(context_va + 0xA)
    key_after_first_dispatcher = ((initial_key & 0x0DE50139) ^ 0x0F3EA59B) & MASK32
    if initial_key != 0xFFFFFFA5 or key_after_first_dispatcher != 0x02DBA4BA:
        raise ValueError("unexpected initial key mutation")

    # Handler 0x1809f4736 advances by [VIP+2], and dispatches the table index
    # stored at [VIP+6].
    require(0x1809F48E7, "mov", "bx, word ptr [r12]")
    require(0x1809F490B, "shl", "rbx, 3")
    require(0x1809F496B, "movsxd", "r15, dword ptr [rsi]")
    require(0x1809F4996, "add", "qword ptr [rdi], r15")
    require(0x1809F49BC, "jmp", "rdx")
    second_index = read_u16(first_handler_vip + 6)
    second_advance = read_i32(first_handler_vip + 2)
    second_handler_vip = first_handler_vip + second_advance
    second_target = table_target(second_index)
    if (second_index, second_advance, second_target) != (
        0x321,
        -0x7E43,
        0x180981AC9,
    ):
        raise ValueError("unexpected second VM dispatch")
    require(second_target, "jmp", "0x1809da384")

    # Handler 0x1809da384 uses a different compact layout: index [VIP+0xc]
    # and signed advance [VIP+4].
    require(0x1809DA561, "mov", "dx, word ptr [r8]")
    require(0x1809DA584, "shl", "rdx, 3")
    require(0x1809DA5E4, "movsxd", "rbx, dword ptr [r9]")
    require(0x1809DA61E, "add", "qword ptr [r14], rbx")
    require(0x1809DA676, "jmp", "r14")
    third_index = read_u16(second_handler_vip + 0xC)
    third_advance = read_i32(second_handler_vip + 4)
    third_handler_vip = second_handler_vip + third_advance
    third_target = table_target(third_index)
    if (third_index, third_advance, third_target) != (
        0x5D,
        0xC173,
        0x18098257F,
    ):
        raise ValueError("unexpected third VM dispatch")
    require(third_target, "jmp", "0x1809bfebb")

    # Handler 0x1809bfebb first folds word[VIP+0xa] into the rolling key.  The
    # earlier initialization handler zeroed context+0xf6, so this first update
    # is exactly 0x36d2.  Its dispatch value is then
    # (word[VIP] - key + 0x5214a88c) & 0xffff.
    require(0x1809BFEEA, "movzx", "rax, word ptr [r10]")
    require(0x1809BFEFB, "xor", "eax, dword ptr [rdx]")
    require(0x1809BFF0A, "add", "eax, dword ptr [r15]")
    require(0x1809BFF17, "add", "dword ptr [r11], eax")
    require(0x1809C0266, "movzx", "r11, word ptr [r11]")
    require(0x1809C0285, "sub", "r11d, dword ptr [rbx]")
    require(0x1809C0288, "xor", "r13, 0x40")
    require(0x1809C028F, "add", "r11d, 0x5214a88c")
    require(0x1809C02CC, "sub", "dword ptr [rdi], r11d")
    require(0x1809C0303, "shl", "r11, 3")
    require(0x1809C0374, "movsxd", "rdx, dword ptr [rcx]")
    require(0x1809C039F, "add", "qword ptr [r9], rdx")
    require(0x1809C03A2, "jmp", "r14")
    fourth_key_input = read_u16(third_handler_vip + 0xA)
    fourth_key_before_dispatch = fourth_key_input
    fourth_raw = read_u16(third_handler_vip)
    fourth_index_full = u32(
        fourth_raw - fourth_key_before_dispatch + 0x5214A88C
    )
    fourth_index = fourth_index_full & 0xFFFF
    fourth_key_after_dispatch = u32(
        fourth_key_before_dispatch - fourth_index_full
    )
    fourth_advance = read_i32(third_handler_vip + 6)
    fourth_handler_vip = third_handler_vip + fourth_advance
    fourth_target = table_target(fourth_index)
    if (
        fourth_key_input,
        fourth_index,
        fourth_key_after_dispatch,
        fourth_advance,
        fourth_target,
    ) != (0x36D2, 0xE0, 0xADEB35F2, -0xA068, 0x1809A3B86):
        raise ValueError("unexpected fourth VM dispatch")

    result = {
        "schema": "maxhook.vm.initial-chain/v1",
        "vm_context": {
            "rva": hex(context_rva),
            "va": hex(context_va),
            "derivation": "module_base + zero_extend32(((0x38ffc137+1)&0x7f2c79bd)-0x379378b4)",
            "initial_key_low32_from_runtime_blob": hex(initial_key),
            "key_after_first_dispatcher": hex(key_after_first_dispatcher),
            "handler_table": hex(TABLE_VA),
        },
        "bootstrap_path": {
            "instruction_count": steps + 1,
            "vip_seed_source": "[ENTRY_RSP-0x8]",
            "vip_seed_rva": hex(vip_seed_rva),
            "initial_vip": hex(initial_vip),
            "bootstrap_table_index_source": "[ENTRY_RSP-0x10]",
            "bootstrap_table_index": hex(bootstrap_index),
        },
        "dispatch_chain": [
            {
                "ordinal": 1,
                "dispatcher": "0x180a97f70",
                "vip_before": hex(initial_vip),
                "index_source": "word[VIP+0]",
                "index": hex(first_index),
                "advance_source": "i32[VIP+2]",
                "advance": first_advance,
                "vip_after": hex(first_handler_vip),
                "table_target": hex(first_target),
                "handler_body": "0x1809f4736",
            },
            {
                "ordinal": 2,
                "handler_body": "0x1809f4736",
                "vip_before": hex(first_handler_vip),
                "index_source": "word[VIP+6]",
                "index": hex(second_index),
                "advance_source": "i32[VIP+2]",
                "advance": second_advance,
                "vip_after": hex(second_handler_vip),
                "table_target": hex(second_target),
                "next_handler_body": "0x1809da384",
            },
            {
                "ordinal": 3,
                "handler_body": "0x1809da384",
                "vip_before": hex(second_handler_vip),
                "index_source": "word[VIP+0xc]",
                "index": hex(third_index),
                "advance_source": "i32[VIP+4]",
                "advance": third_advance,
                "vip_after": hex(third_handler_vip),
                "table_target": hex(third_target),
                "next_handler_body": "0x1809bfebb",
            },
            {
                "ordinal": 4,
                "handler_body": "0x1809bfebb",
                "vip_before": hex(third_handler_vip),
                "key_input_source": "word[VIP+0xa] with prior context+0xf6=0",
                "key_before_dispatch": hex(fourth_key_before_dispatch),
                "index_expression": "(word[VIP+0] - key + 0x5214a88c) & 0xffff",
                "index": hex(fourth_index),
                "key_after_dispatch": hex(fourth_key_after_dispatch),
                "advance_source": "i32[VIP+6]",
                "advance": fourth_advance,
                "vip_after": hex(fourth_handler_vip),
                "table_target": hex(fourth_target),
            },
        ],
        "inputs": {
            "runtime_bugland_sha256": sha256_file(args.runtime_bugland),
            "prologue_json_sha256": sha256_file(args.prologue_json),
        },
    }
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(f"wrote {args.output.resolve()}")
    print(
        f"context={context_va:#x} initial_vip={initial_vip:#x} "
        f"chain={first_index:#x}->{second_index:#x}->{third_index:#x}->{fourth_index:#x}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
