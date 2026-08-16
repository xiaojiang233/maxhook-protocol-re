#!/usr/bin/env python3
"""Extract the list of arithmetic handlers (the cipher operations) with their
body addresses, for focused fold analysis."""
from __future__ import annotations
import json, sys
from pathlib import Path
from collections import Counter
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE / ".pydeps"))
from capstone import CS_ARCH_X86, CS_MODE_64, Cs
import pefile

DLL = HERE / "MaxHook.runtime-unpacked.dll"
IMAGE_BASE = 0x180000000

def main():
    d = json.loads(Path(r"E:\Coding\S1mple\target\encrypt_vm_mapped.json").read_text(encoding="utf-8"))
    jumps = d.get("vm_indirect_jumps", [])
    handlers = Counter()
    for j in jumps:
        handlers[j.get("source")] += 1
        handlers[j.get("target")] += 1

    blob = DLL.read_bytes()
    pe = pefile.PE(str(DLL))
    md = Cs(CS_ARCH_X86, CS_MODE_64)

    arith = []
    for h_str, cnt in handlers.items():
        h = int(h_str, 16)
        rva = h - IMAGE_BASE
        sec = None
        for s in pe.sections:
            va = IMAGE_BASE + s.VirtualAddress
            if va <= h < va + s.Misc_VirtualSize:
                sec = s; break
        if sec is None:
            continue
        off = sec.get_offset_from_rva(rva)
        insns = list(md.disasm(blob[off:off+0x20], h))
        if not insns:
            continue
        body_addr = h
        if insns[0].mnemonic == "jmp" and insns[0].op_str.startswith("0x"):
            body_addr = int(insns[0].op_str, 16)
        # body
        rva2 = body_addr - IMAGE_BASE
        sec2 = None
        for s in pe.sections:
            va = IMAGE_BASE + s.VirtualAddress
            if va <= body_addr < va + s.Misc_VirtualSize:
                sec2 = s; break
        if sec2 is None:
            continue
        off2 = sec2.get_offset_from_rva(rva2)
        bins = list(md.disasm(blob[off2:off2+0x40], body_addr))
        for insn in bins:
            m = insn.mnemonic
            if m == "jmp":
                continue
            if m in ("xor", "add", "sub", "and", "or", "shl", "shr", "rol", "ror", "not", "neg"):
                arith.append((h_str, body_addr, m, insn.op_str, cnt))
            break

    arith.sort(key=lambda x: -x[4])
    print(f"arithmetic handlers: {len(arith)} distinct")
    print()
    for h_str, body, m, op, cnt in arith[:40]:
        print(f"  stub={h_str} body={body:#x} cnt={cnt:4d} {m} {op}")

if __name__ == "__main__":
    main()
