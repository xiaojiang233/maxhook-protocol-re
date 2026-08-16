#!/usr/bin/env python3
"""Disassemble the XOR byte site (0x1809c5561) and the writer (0x18041a860)
to establish the exact data-flow: what r12 (source) and r8 (destination) are,
and how the keystream byte reaches the output.

Also correlates the keystream_history snapshot's `keystream_byte` with the
writer_sync oracle (the 64-byte keystream blocks) to confirm they agree.
"""
from __future__ import annotations
import json, sys
from pathlib import Path
from collections import defaultdict

sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
from capstone import CS_ARCH_X86, CS_MODE_64, Cs

DLL = Path(r"E:\Coding\S1mple\target\MaxHook.runtime-unpacked.dll")
IMAGE_BASE = 0x180000000
XOR_RVA = 0x9C5561
WRITER_RVA = 0x41A860


def parse_sections(blob):
    import struct as _s
    pe = blob
    e_lfanew = _s.unpack_from("<I", pe, 0x3C)[0]
    num = _s.unpack_from("<H", pe, e_lfanew + 6)[0]
    opt_size = _s.unpack_from("<H", pe, e_lfanew + 20)[0]
    sec_off = e_lfanew + 24 + opt_size
    sections = []
    for i in range(num):
        o = sec_off + i * 40
        name = pe[o:o+8].rstrip(b"\x00").decode("latin1")
        vsize = _s.unpack_from("<I", pe, o + 8)[0]
        vaddr = _s.unpack_from("<I", pe, o + 12)[0]
        rsize = _s.unpack_from("<I", pe, o + 16)[0]
        roff = _s.unpack_from("<I", pe, o + 20)[0]
        sections.append((name, vaddr, vsize, roff, rsize))
    return sections


def rva_to_off(rva, sections):
    for name, vaddr, vsize, roff, rsize in sections:
        if vaddr <= rva < vaddr + max(vsize, rsize):
            return roff + (rva - vaddr)
    return None


def disasm(blob, sections, rva, count, base_va=IMAGE_BASE):
    off = rva_to_off(rva, sections)
    if off is None:
        return None
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    md.detail = True
    code = blob[off:off + count * 15]
    return list(md.disasm(code, base_va + rva))


def main():
    blob = DLL.read_bytes()
    sections = parse_sections(blob)

    print("=== XOR byte site 0x1809c5561 (rva 0x9c5561) ===")
    insns = disasm(blob, sections, XOR_RVA, 40)
    for x in insns:
        print(f"  {x.address:#x}: {x.mnemonic} {x.op_str}")

    print("\n=== writer 0x18041a860 (rva 0x41a860) ===")
    insns = disasm(blob, sections, WRITER_RVA, 40)
    for x in insns:
        print(f"  {x.address:#x}: {x.mnemonic} {x.op_str}")

    # Correlate keystream_byte with writer_sync oracle
    print("\n=== correlate snapshot keystream_byte with writer_sync keystream ===")
    # load the writer_sync analysis (already proven keystream)
    analysis = json.loads(Path(r"E:\Coding\S1mple\target\writer_sync_clean_20260814_014351\analysis.json").read_text())
    ks_by_call = {c["call_id"]: bytes.fromhex(c["keystream_hex"]) for c in analysis["calls"]}

    cap = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")
    snaps = []
    for f in sorted(cap.glob("*.bin")):
        j = json.loads(f.read_text())
        j["call"] = int(f.name.split("_call_")[1].split("_")[0])
        snaps.append(j)

    # For each snapshot, compare keystream_byte (at xor_index) to ks[xor_index]
    match = 0
    total = 0
    mismatches = []
    for s in snaps:
        call = s["call"]
        idx = s["xor_index"]
        kb = s["keystream_byte"]
        ks = ks_by_call.get(call)
        if ks is None:
            continue
        total += 1
        if idx < len(ks):
            if ks[idx] == kb:
                match += 1
            else:
                mismatches.append((call, idx, kb, ks[idx]))
        else:
            mismatches.append((call, idx, kb, "OOB"))
    print(f"  {match}/{total} snapshot keystream_byte values match writer_sync oracle")
    if mismatches:
        print(f"  first mismatches: {mismatches[:10]}")


if __name__ == "__main__":
    main()
