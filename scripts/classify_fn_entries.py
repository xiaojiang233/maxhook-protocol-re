#!/usr/bin/env python3
"""Disassemble all valid fn-table entries to classify each sub-function."""
from __future__ import annotations
import sys, struct
from pathlib import Path
sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
from capstone import Cs, CS_ARCH_X86, CS_MODE_64
import pefile

DLL = Path(r"E:\Coding\S1mple\target\MaxHook.runtime-unpacked.dll")
FN = 0x1807D7C70
md = Cs(CS_ARCH_X86, CS_MODE_64)

def main():
    pe = pefile.PE(str(DLL))
    raw = DLL.read_bytes()
    base = 0x180000000
    def va_to_off(va):
        for s in pe.sections:
            sv = base + s.VirtualAddress
            if sv <= va < sv + max(s.Misc_VirtualSize, s.SizeOfRawData):
                return s.PointerToRawData + (va - sv)
    def qword(va):
        off = va_to_off(va)
        return struct.unpack("<Q", raw[off:off+8])[0]

    entries = [qword(FN + i*8) for i in range(16)]
    for i, e in enumerate(entries):
        # disassemble first few insns
        off = va_to_off(e)
        if off is None:
            print(f"[{i:2d}] {e:#x}  (unmapped)")
            continue
        code = raw[off:off+40]
        insns = list(md.disasm(code, e))
        first = insns[0] if insns else None
        mnem = first.mnemonic if first else "?"
        op = first.op_str if first else "?"
        print(f"[{i:2d}] {e:#x}  {mnem} {op}")

if __name__ == "__main__":
    main()
