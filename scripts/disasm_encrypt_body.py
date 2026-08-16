#!/usr/bin/env python3
"""Disassemble the real encrypt body at 0x181523001 (.bugland)."""
from __future__ import annotations
import sys
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE / ".pydeps"))
from capstone import CS_ARCH_X86, CS_MODE_64, Cs
import pefile

DLL = HERE / "MaxHook.runtime-unpacked.dll"
IMAGE_BASE = 0x180000000
TARGETS = [0x181523001]

def main():
    blob = DLL.read_bytes()
    pe = pefile.PE(str(DLL))
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    md.detail = True
    for t in TARGETS:
        rva = t - IMAGE_BASE
        sec = None
        for s in pe.sections:
            va = IMAGE_BASE + s.VirtualAddress
            if va <= t < va + s.Misc_VirtualSize:
                sec = s; break
        off = sec.get_offset_from_rva(rva)
        code = blob[off:off + 0x400]
        print(f"=== {hex(t)} ===")
        for insn in md.disasm(code, t):
            print(f"0x{insn.address:x}: {insn.mnemonic:<8} {insn.op_str}")
            if insn.address > t + 0x300:
                break
        print()

if __name__ == "__main__":
    main()
