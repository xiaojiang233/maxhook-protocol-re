#!/usr/bin/env python3
"""Prove the MaxHook crypto VM bootstrap table/index/target statically."""

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


IMAGE_BASE = 0x180000000
BUGLAND_BASE = 0x180980000
INDIRECT_JUMP = 0x180C44CED
EXPECTED_TARGET = 0x1809894BA
EXPECTED_TARGET_BODY = 0x180A97F70
MASK32 = 0xFFFFFFFF


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def decode_one(md: Cs, blob: bytes, address: int):
    offset = address - BUGLAND_BASE
    return next(md.disasm(blob[offset : offset + 15], address, count=1), None)


def require_instruction(md: Cs, blob: bytes, address: int, mnemonic: str, op_str: str):
    instruction = decode_one(md, blob, address)
    if instruction is None:
        raise ValueError(f"cannot decode {address:#x}")
    if instruction.mnemonic != mnemonic or instruction.op_str != op_str:
        raise ValueError(
            f"unexpected {address:#x}: {instruction.mnemonic} {instruction.op_str}; "
            f"wanted {mnemonic} {op_str}"
        )
    return instruction


def read_first_new_after(path: Path, address: int) -> dict:
    rows = []
    for raw in path.read_text(encoding="utf-8").splitlines():
        address_text, separator, count_text = raw.strip().rpartition(":")
        if not separator:
            continue
        rows.append((int(address_text, 16), int(count_text, 10)))
    positions = [index for index, (item, _) in enumerate(rows) if item == address]
    if len(positions) != 1 or positions[0] + 1 >= len(rows):
        raise ValueError(f"{path}: expected one non-final {address:#x}")
    index = positions[0]
    next_address, next_translation_count = rows[index + 1]
    return {
        "file": str(path.resolve()),
        "source_translation_count": rows[index][1],
        "next_first_translation_address": hex(next_address),
        "next_translation_count": next_translation_count,
        "matches_static_target": next_address == EXPECTED_TARGET,
        "sha256": sha256_file(path),
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--runtime-bugland", type=Path, required=True)
    parser.add_argument("--capture", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    blob = args.runtime_bugland.read_bytes()
    md = Cs(CS_ARCH_X86, CS_MODE_64)

    # VM prologue constant saved at ENTRY_RSP-0x10.
    bootstrap_index = (((0x6AF57D4F >> 4) ^ 0x7B502D73) ^ 0x7DFF786D) & MASK32
    if bootstrap_index != 0x2CA:
        raise ValueError(f"unexpected bootstrap index {bootstrap_index:#x}")

    # Obfuscated table-RVA arithmetic at 0x180c44a23..0x180c44a5a.
    table_term = (0x6F7F2C0B + 0x7DFAEF37) & MASK32
    table_term ^= 0x6C9C6B51
    table_rva = (
        0x7EDFDEAA - 0x5EFFC61F + table_term + 0x5EFFC61F
    ) & MASK32
    if table_rva != 0xC64EBD:
        raise ValueError(f"unexpected handler table RVA {table_rva:#x}")
    table_va = IMAGE_BASE + table_rva

    # Exact structural assertions tying the arithmetic to the indirect jump.
    require_instruction(md, blob, 0x180C44A23, "push", "r10")
    require_instruction(md, blob, 0x180C44A25, "mov", "r10d, 0x7edfdeaa")
    require_instruction(md, blob, 0x180C44A5A, "mov", "eax, r10d")
    require_instruction(md, blob, 0x180C44A86, "add", "rax, rcx")
    require_instruction(md, blob, 0x180C44C9A, "push", "qword ptr [rsp + 0x88]")
    require_instruction(md, blob, 0x180C44CB6, "shl", "rbx, 3")
    require_instruction(md, blob, 0x180C44CD2, "add", "rax, rbx")
    require_instruction(md, blob, INDIRECT_JUMP, "jmp", "qword ptr [rax]")

    # The proven chosen path reaches 0x180c44c9a with RSP=ENTRY_RSP-0x98;
    # therefore [RSP+0x88] is ENTRY_RSP-0x10, the 0x2ca prologue slot.
    rsp_at_index_load = -0x98
    source_entry_rsp_offset = rsp_at_index_load + 0x88
    if source_entry_rsp_offset != -0x10:
        raise ValueError("bootstrap index stack offset mismatch")

    table_offset = table_va - BUGLAND_BASE
    entry_offset = table_offset + bootstrap_index * 8
    if entry_offset < 0 or entry_offset + 8 > len(blob):
        raise ValueError("bootstrap table entry is outside runtime blob")
    target = struct.unpack_from("<Q", blob, entry_offset)[0]
    if target != EXPECTED_TARGET:
        raise ValueError(f"unexpected bootstrap table target {target:#x}")
    target_stub = require_instruction(
        md, blob, EXPECTED_TARGET, "jmp", hex(EXPECTED_TARGET_BODY)
    )

    capture_files = sorted(args.capture.glob("vm_addrs_call*.txt"))
    if not capture_files:
        raise ValueError("no capture address files")
    capture_checks = [
        read_first_new_after(path, INDIRECT_JUMP) for path in capture_files
    ]
    if not all(item["matches_static_target"] for item in capture_checks):
        raise ValueError("capture first-translation address disagrees with static target")

    result = {
        "schema": "maxhook.vm.bootstrap-dispatch/v1",
        "proof": {
            "prologue_stack_index": hex(bootstrap_index),
            "index_entry_rsp_offset": "-0x10",
            "rsp_at_index_load_relative_to_entry": hex(rsp_at_index_load & ((1 << 64) - 1)),
            "index_load": "0x180c44c9a push qword ptr [rsp+0x88]",
            "index_scale": "0x180c44cb6 shl rbx,3",
            "handler_table_rva": hex(table_rva),
            "handler_table_va": hex(table_va),
            "table_base_expression": "RCX(module_base) + 0x00c64ebd",
            "indirect_jump": "0x180c44ced jmp qword ptr [rax]",
            "table_entry_va": hex(table_va + bootstrap_index * 8),
            "target": hex(target),
            "target_stub": f"{target_stub.mnemonic} {target_stub.op_str}",
        },
        "capture_cross_check": {
            "semantics": "first translation after source, not runtime hit count",
            "all_calls_match_static_target": True,
            "calls": capture_checks,
        },
        "inputs": {
            "runtime_bugland_sha256": sha256_file(args.runtime_bugland),
        },
    }
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(f"wrote {args.output.resolve()}")
    print(
        f"table={table_va:#x} index={bootstrap_index:#x} "
        f"target={target:#x} body={EXPECTED_TARGET_BODY:#x} "
        f"capture_match={len(capture_checks)}/{len(capture_checks)}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
