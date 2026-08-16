#!/usr/bin/env python3
"""Disassemble the top VM handlers to understand their semantics."""
from __future__ import annotations
import sys
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE / ".pydeps"))
from capstone import CS_ARCH_X86, CS_MODE_64, Cs
import pefile

DLL = HERE / "MaxHook.runtime-unpacked.dll"
IMAGE_BASE = 0x180000000

TOP_HANDLERS = [
    0x180ac30e1, 0x180c02d8c, 0x1809803d9, 0x1809a57e1,  # dispatch/loop (~380)
    0x1809a3b86, 0x180a02e9e,  # arithmetic (~215)
    0x180aa7fa4, 0x1809d3bed, 0x18098257f, 0x1809c03a2,  # ~200
]

def main():
    blob = DLL.read_bytes()
    pe = pefile.PE(str(DLL))
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    md.detail = True
    for t in TOP_HANDLERS:
        rva = t - IMAGE_BASE
        sec = None
        for s in pe.sections:
            va = IMAGE_BASE + s.VirtualAddress
            if va <= t < va + s.Misc_VirtualSize:
                sec = s; break
        if sec is None:
            print(f"{t:#x}: NOT IN SECTION")
            continue
        off = sec.get_offset_from_rva(rva)
        code = blob[off:off + 0x80]
        print(f"\n=== {t:#x} ===")
        for insn in md.disasm(code, t):
            print(f"  {insn.mnemonic:<7} {insn.op_str}")
            if insn.address >= t + 0x50:
                break

if __name__ == "__main__":
    main()
