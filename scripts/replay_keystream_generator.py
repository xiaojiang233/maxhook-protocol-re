#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Offline direct-generator replay of MaxHook's keystream generator.

This does NOT attach to the game.  It maps the runtime-unpacked DLL into a
Unicorn VM and enters the *plaintext* keystream generator dispatch at
0x18041a8a0 directly (bypassing the 0x180324610 encrypt entry whose 1.3M
instruction environment-decryption prefix previously dead-ended on the unmapped
1.95TB Java heap).

Architecture established from writer_sync_clean_20260814_014351 (call 1) plus
static disassembly:

  generator 0x18041a8a0  : plaintext dispatcher.  rcx=state buffer, rdx=output
                           block.  Computes obfuscated (rol/bswap/rol) indices and
                           calls qword ptr [0x1807d7c70 + idx*8]  (plaintext
                           function-pointer table).  Each table entry is a VM
                           stub (jmp into .bugland).  Combined results are written
                           back with obfuscated movabs+xor[rip]+add addressing.
  store32   0x18041a860  : plaintext 4-byte little-endian writer.  This is the
                           FINAL keystream-word sink; writer_sync proved its
                           64-byte blocks equal true keystream (plaintext XOR
                           ciphertext) 3/3.
  table     0x1807d7c70  : plaintext function-pointer table (VM stubs).
  constants 0x1807d78c8..: plaintext obfuscation constants (xor[rip+X] operands).
  index tbl 0x1807d7cf0  : encrypted .data (dispatch-index deobfuscation); the one
                           non-plaintext piece, recovered offline against oracle.

This script checkpoints at store32 (0x18041a860) and generator (0x18041a8a0),
and compares each store32 32-bit word against the writer_sync call-1 oracle,
emitting precise divergence diagnostics.
"""

from __future__ import annotations

import argparse
import json
import struct
import sys
from pathlib import Path
from typing import Any

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE / ".pydeps"))

import pefile  # type: ignore  # noqa: E402
from capstone import CS_ARCH_X86, CS_MODE_64, Cs  # type: ignore  # noqa: E402
from unicorn import (  # type: ignore  # noqa: E402
    UC_ARCH_X86,
    UC_HOOK_CODE,
    UC_HOOK_MEM_INVALID,
    UC_MODE_64,
    Uc,
    UcError,
)
from unicorn.x86_const import (  # type: ignore  # noqa: E402
    UC_X86_REG_GS_BASE,
    UC_X86_REG_RAX,
    UC_X86_REG_RBP,
    UC_X86_REG_RBX,
    UC_X86_REG_RCX,
    UC_X86_REG_RDI,
    UC_X86_REG_RDX,
    UC_X86_REG_RIP,
    UC_X86_REG_RSI,
    UC_X86_REG_RSP,
    UC_X86_REG_R8,
    UC_X86_REG_R9,
    UC_X86_REG_R10,
    UC_X86_REG_R11,
    UC_X86_REG_R12,
    UC_X86_REG_R13,
    UC_X86_REG_R14,
    UC_X86_REG_R15,
)

IMAGE_BASE = 0x180000000
GENERATOR = 0x18041A8A0       # keystream generator dispatcher (plaintext)
STORE32 = 0x18041A860         # keystream word writer (plaintext)
FN_TABLE = 0x1807D7C70        # plaintext function-pointer table (VM stubs)
IDX_TABLE = 0x1807D7CF0       # encrypted index table
CONST_TABLE = 0x1807D78C8     # plaintext obfuscation constants
RETURN_SENTINEL = 0x180500000

REGISTERS = {
    "rax": UC_X86_REG_RAX, "rbx": UC_X86_REG_RBX, "rcx": UC_X86_REG_RCX,
    "rdx": UC_X86_REG_RDX, "rsi": UC_X86_REG_RSI, "rdi": UC_X86_REG_RDI,
    "rbp": UC_X86_REG_RBP, "rsp": UC_X86_REG_RSP, "r8": UC_X86_REG_R8,
    "r9": UC_X86_REG_R9, "r10": UC_X86_REG_R10, "r11": UC_X86_REG_R11,
    "r12": UC_X86_REG_R12, "r13": UC_X86_REG_R13, "r14": UC_X86_REG_R14,
    "r15": UC_X86_REG_R15, "rip": UC_X86_REG_RIP,
}


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--dll", type=Path, default=HERE / "MaxHook.runtime-unpacked.dll")
    p.add_argument("--oracle-dir", type=Path,
                   default=HERE / "writer_sync_clean_20260814_014351")
    p.add_argument("--oracle-call", type=int, default=1)
    p.add_argument("--max-instructions", type=int, default=2_000_000)
    p.add_argument("--timeout-ms", type=int, default=20_000)
    p.add_argument("--output", type=Path,
                   default=HERE / "replay_generator_report.json")
    return p.parse_args()


def map_pe(uc: Uc, path: Path, base: int) -> pefile.PE:
    pe = pefile.PE(str(path))
    image_size = (pe.OPTIONAL_HEADER.SizeOfImage + 0xFFF) & ~0xFFF
    uc.mem_map(base, image_size)
    raw = path.read_bytes()
    uc.mem_write(base, raw[: pe.OPTIONAL_HEADER.SizeOfHeaders])
    for section in pe.sections:
        data = section.get_data()
        if data:
            uc.mem_write(base + section.VirtualAddress, data)
    return pe


def load_oracle(oracle_dir: Path, call_id: int) -> dict[str, Any]:
    """Load the writer_sync analysis.json blocks for the given call as oracle."""
    analysis_path = oracle_dir / "analysis.json"
    analysis = json.loads(analysis_path.read_text(encoding="utf-8"))
    call = next(c for c in analysis["calls"] if c["call_id"] == call_id)
    blocks = [bytes.fromhex(b["hex"]) for b in call["blocks"]]
    # Flatten to a stream of 32-bit LE words, in block order.
    words: list[int] = []
    for blk in blocks:
        for off in range(0, 64, 4):
            words.append(struct.unpack("<I", blk[off:off + 4])[0])
    return {
        "call_id": call_id,
        "plaintext_bytes": call["plaintext_bytes"],
        "blocks": blocks,
        "words": words,
        "keystream_hex": call["keystream_hex"],
    }


def run(args: argparse.Namespace) -> dict[str, Any]:
    oracle = load_oracle(args.oracle_dir, args.oracle_call)

    uc = Uc(UC_ARCH_X86, UC_MODE_64)
    map_pe(uc, args.dll.resolve(), IMAGE_BASE)

    # Synthetic execution stack.
    stack = 0x7FFE000000
    stack_size = 0x200000
    uc.mem_map(stack, stack_size)
    entry_rsp = stack + stack_size - 0x1000
    uc.reg_write(UC_X86_REG_RSP, entry_rsp)
    uc.mem_write(entry_rsp, struct.pack("<Q", RETURN_SENTINEL))

    # State + output buffers (generator's rcx / rdx).  Sized generously.
    state_buf = 0x20000000000
    output_buf = 0x20000010000
    uc.mem_map(state_buf, 0x10000)
    uc.mem_map(output_buf, 0x10000)
    # Zero-fill both (deterministic baseline).
    uc.mem_write(state_buf, b"\x00" * 0x10000)
    uc.mem_write(output_buf, b"\x00" * 0x10000)

    # Minimal TEB/GS (the .bugland VM stubs may read gs:[...]).
    teb = 0x7FFDE00000
    uc.mem_map(teb, 0x10000)
    uc.reg_write(UC_X86_REG_GS_BASE, teb)
    uc.mem_write(teb + 0x30, struct.pack("<Q", teb))
    uc.mem_write(teb + 0x188, struct.pack("<Q", teb + 0x1000))
    peb = 0x7FFDE10000
    uc.mem_map(peb, 0x10000)
    uc.mem_write(teb + 0x58, struct.pack("<Q", peb))   # TEB.PEB
    uc.mem_write(peb + 0x10, struct.pack("<Q", IMAGE_BASE))  # PEB.ImageBaseAddress

    # Entry registers: rcx=state, rdx=output (generator ABI per disassembly:
    # mov rdi,rdx ; mov rsi,rcx at prologue).
    uc.reg_write(UC_X86_REG_RCX, state_buf)
    uc.reg_write(UC_X86_REG_RDX, output_buf)

    # Checkpoint / diagnostics state.
    store32_checkpoints: list[dict[str, Any]] = []
    generator_checkpoints: list[dict[str, Any]] = []
    dispatch_calls: list[dict[str, Any]] = []
    first_divergence: dict[str, Any] | None = None
    invalid: dict[str, Any] | None = None
    state = {"instructions": 0, "stopped_by_limit": False}

    disassembler = Cs(CS_ARCH_X86, CS_MODE_64)

    def snapshot(instruction: int, address: int) -> dict[str, Any]:
        return {
            "instruction": instruction,
            "rip": hex(address),
            "registers": {n: hex(uc.reg_read(r)) for n, r in REGISTERS.items()},
        }

    def on_code(_uc: Uc, address: int, size: int, _user: Any) -> None:
        state["instructions"] += 1
        if address == STORE32:
            dest = uc.reg_read(UC_X86_REG_RCX)
            value = uc.reg_read(UC_X86_REG_RDX) & 0xFFFFFFFF
            off = dest - output_buf
            word_index = off // 4 if 0 <= off < 0x10000 else -1
            cp = {
                "instruction": state["instructions"],
                "dest": hex(dest),
                "offset_in_output": off,
                "value": hex(value),
                "word_index": word_index,
            }
            store32_checkpoints.append(cp)
            # Compare against oracle.
            if first_divergence is None and 0 <= word_index < len(oracle["words"]):
                expected = oracle["words"][word_index]
                if value != expected:
                    first_divergence = {
                        "instruction": state["instructions"],
                        "word_index": word_index,
                        "expected": hex(expected),
                        "actual": hex(value),
                        "context": snapshot(state["instructions"], address),
                    }
        elif address == GENERATOR:
            generator_checkpoints.append(
                {
                    "instruction": state["instructions"],
                    "kind": "enter",
                    "rcx": hex(uc.reg_read(UC_X86_REG_RCX)),
                    "rdx": hex(uc.reg_read(UC_X86_REG_RDX)),
                    "context": snapshot(state["instructions"], address),
                }
            )
        # Trace indirect dispatches through the plaintext function-pointer table.
        if address in (0x18041A914, 0x18041A969, 0x18041A9BE, 0x18041AA13,
                       0x18041AC69):
            # call qword ptr [rbx + idx*8]
            idx = uc.reg_read(UC_X86_REG_RAX) if address in (0x18041A914,) else \
                  uc.reg_read(UC_X86_REG_RDX) if address in (0x18041A969, 0x18041A9BE, 0x18041AA13) else \
                  uc.reg_read(UC_X86_REG_RAX)
            idx = idx & 0x7FFFFFFF
            target_slot = FN_TABLE + idx * 8
            try:
                fn = struct.unpack("<Q", bytes(uc.mem_read(target_slot, 8)))[0]
            except UcError:
                fn = None
            dispatch_calls.append({
                "instruction": state["instructions"],
                "rip": hex(address),
                "computed_index": hex(idx),
                "table_slot": hex(target_slot),
                "target_function": hex(fn) if fn else None,
            })
        if state["instructions"] >= args.max_instructions:
            state["stopped_by_limit"] = True
            uc.emu_stop()

    def on_invalid(
        _uc: Uc, access: int, address: int, size: int, value: int, _user: Any
    ) -> bool:
        nonlocal invalid
        if invalid is None:
            invalid = {
                "access": access,
                "address": hex(address),
                "size": size,
                "value": hex(value),
                "rip": hex(uc.reg_read(UC_X86_REG_RIP)),
                "instruction": state["instructions"],
                "registers": {n: hex(uc.reg_read(r)) for n, r in REGISTERS.items()},
            }
        return False

    uc.hook_add(UC_HOOK_CODE, on_code)
    uc.hook_add(UC_HOOK_MEM_INVALID, on_invalid)

    error = None
    try:
        uc.emu_start(GENERATOR, 0, timeout=args.timeout_ms * 1000)
    except UcError as exc:
        error = str(exc)

    # Dump the output buffer (what store32 produced) for inspection.
    output_bytes = bytes(uc.mem_read(output_buf, 64))

    return {
        "schema": "maxhook.generator.replay/v1",
        "dll": str(args.dll.resolve()),
        "oracle": {
            "dir": str(args.oracle_dir.resolve()),
            "call_id": oracle["call_id"],
            "plaintext_bytes": oracle["plaintext_bytes"],
            "oracle_word_count": len(oracle["words"]),
        },
        "entry": hex(GENERATOR),
        "state_buffer": hex(state_buf),
        "output_buffer": hex(output_buf),
        "instruction_count": state["instructions"],
        "stopped_by_limit": state["stopped_by_limit"],
        "error": error,
        "invalid_memory": invalid,
        "store32_checkpoints": store32_checkpoints,
        "generator_checkpoints": generator_checkpoints,
        "dispatch_calls": dispatch_calls,
        "first_divergence": first_divergence,
        "output_block_hex": output_bytes.hex(),
        "output_matches_oracle_first_block": (
            output_bytes == oracle["blocks"][0]
            if oracle["blocks"] else None
        ),
        "interpretation": (
            "store32 checkpoints record each final keystream word; first_divergence "
            "pinpoints the exact word/instruction where the offline replay departs "
            "from the writer_sync call-1 oracle."
        ),
    }


def recover_index_table(dll: Path) -> dict[str, Any]:
    """Recover the encrypted index-table values that the generator's dispatch
    reads, using the deterministic dispatch-index computation.

    The generator's first-phase dispatch computes, for each of its 4 sub-calls:
        cl   = 0x405a9e0 - dword[shift_src]      (deterministic, plaintext)
        eax  = rol(bswap(rol(0x6000000, cl)), cl)
        r8d  = dword[0x1807d7cf0 + eax]           (ENCRYPTED, unknown)
        r8d  = obfuscate(r8d + 1)                  (rol/ror with edx=0x5e9298bc-eax,
                                                    eax2=eax+0x5e9298bc)
        call qword ptr [0x1807d7c70 + r8d*8]      (plaintext fn table)

    So each sub-call reads a FIXED offset eax in the index table; the encrypted
    value at that offset determines (through a known bijective obfuscation) the
    fn-table index.  This reports those offsets and the on-disk (encrypted)
    values, which is the single missing piece preventing offline keystream.
    """
    import struct as _struct
    from pathlib import Path as _Path

    pe = pefile.PE(str(dll))
    raw = dll.read_bytes()
    base = IMAGE_BASE

    def va_to_off(va: int) -> int | None:
        for s in pe.sections:
            sec_va = base + s.VirtualAddress
            if sec_va <= va < sec_va + max(s.Misc_VirtualSize, s.SizeOfRawData):
                return s.PointerToRawData + (va - sec_va)
        return None

    def dword(va: int) -> int:
        off = va_to_off(va)
        return _struct.unpack("<I", raw[off:off + 4])[0]

    def qword(va: int) -> int:
        off = va_to_off(va)
        return _struct.unpack("<Q", raw[off:off + 8])[0]

    def rol32(x: int, n: int) -> int:
        n &= 0x1F
        return ((x << n) | (x >> (32 - n))) & 0xFFFFFFFF

    def ror32(x: int, n: int) -> int:
        n &= 0x1F
        return ((x >> n) | (x << (32 - n))) & 0xFFFFFFFF

    # The 4 first-phase shift-count sources, in dispatch order.
    shift_sources = [0x180894B04, 0x180894AEC, 0x180894B00, 0x180894AE8]
    # The 2 second-phase sources (used later in the generator body).
    phase2_sources = [0x180894AFC, 0x180894AF4]

    entries: list[dict[str, Any]] = []
    for i, src in enumerate(shift_sources):
        cl = (0x405A9E0 - dword(src)) & 0xFFFFFFFF
        eax = rol32(0x6000000, cl & 0x1F)
        eax = int.from_bytes(eax.to_bytes(4, "little"), "big")  # bswap
        eax = rol32(eax, cl & 0x1F)
        table_off = IDX_TABLE + eax
        encrypted = dword(table_off)
        entries.append({
            "subcall": i,
            "shift_src": hex(src),
            "shift_src_value": hex(dword(src)),
            "cl": hex(cl),
            "index_into_index_table": hex(eax),
            "index_table_address": hex(table_off),
            "encrypted_value_on_disk": hex(encrypted),
            "fn_table_base": hex(FN_TABLE),
        })

    # Also report the fn table (plaintext) so the consumer can correlate.
    fn_entries = [hex(qword(FN_TABLE + i * 8)) for i in range(16)]

    return {
        "index_table_address": hex(IDX_TABLE),
        "fn_table_address": hex(FN_TABLE),
        "fn_table_entries": fn_entries,
        "dispatch_entries": entries,
        "phase2_shift_sources": [
            {"src": hex(s), "value": hex(dword(s))} for s in phase2_sources
        ],
        "note": (
            "Each dispatch sub-call reads a fixed offset in the encrypted index "
            "table 0x1807d7cf0; the encrypted value there, deobfuscated via a "
            "known bijective rol/ror, selects the fn-table entry.  Recovering "
            "these 4 encrypted dwords offline (against the writer_sync oracle) "
            "is the single remaining step to reproduce the keystream without "
            "attaching to the game."
        ),
    }


def main() -> int:
    args = parse_args()
    result = run(args)
    result["index_table_recovery"] = recover_index_table(args.dll.resolve())
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(f"[+] wrote {args.output.resolve()}")
    print(f"[+] instructions={result['instruction_count']} error={result['error']!r}")
    print(f"[+] invalid_memory={result['invalid_memory']}")
    print(f"[+] store32 checkpoints={len(result['store32_checkpoints'])}")
    print(f"[+] generator checkpoints={len(result['generator_checkpoints'])}")
    print(f"[+] dispatch calls={len(result['dispatch_calls'])}")
    for dc in result["dispatch_calls"]:
        print(f"    inst {dc['instruction']} @ {dc['rip']} idx={dc['computed_index']} "
              f"-> table {dc['table_slot']} fn={dc['target_function']}")
    rec = result["index_table_recovery"]
    print(f"[+] index-table recovery: {rec['index_table_address']} (encrypted)")
    for e in rec["dispatch_entries"]:
        print(f"    subcall {e['subcall']}: index_table[{e['index_into_index_table']}]"
              f" = {e['encrypted_value_on_disk']} (on-disk encrypted)")
    print(f"[+] fn table (plaintext): {rec['fn_table_entries']}")
    if result["first_divergence"] is not None:
        fd = result["first_divergence"]
        print(f"[+] first divergence @ inst {fd['instruction']} word {fd['word_index']}: "
              f"expected {fd['expected']} got {fd['actual']}")
    else:
        print("[+] no divergence detected (or no oracle word reached)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
