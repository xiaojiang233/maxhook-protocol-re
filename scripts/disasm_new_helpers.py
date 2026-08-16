#!/usr/bin/env python3
"""Disassemble the 16 helper functions from the NEW helper table 0x1807bdc70."""
import struct
from pathlib import Path
import sys
sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
from capstone import CS_ARCH_X86, CS_MODE_64, Cs
import pefile

DLL = Path(r"E:\Coding\S1mple\target\MaxHook.runtime-unpacked.dll")

def va_to_off(pe, va):
    for s in pe.sections:
        sec_va = 0x180000000 + s.VirtualAddress
        vs = max(s.Misc_VirtualSize, s.SizeOfRawData)
        if sec_va <= va < sec_va + vs:
            return s.PointerToRawData + (va - sec_va)
    return None

HELPERS = [
    0x180376ac0, 0x18001c570, 0x1803d4050, 0x1800493c0,
    0x180043540, 0x1803dfa60, 0x18005ef60, 0x180367b20,
    0x18031a530, 0x18037d240, 0x18026ed30, 0x18039be30,
    0x180383850, 0x180036550, 0x1803c6580, 0x180392e90,
]

def main():
    pe = pefile.PE(str(DLL))
    raw = DLL.read_bytes()
    md = Cs(CS_ARCH_X86, CS_MODE_64)

    for i, va in enumerate(HELPERS):
        off = va_to_off(pe, va)
        if off is None:
            print("[%d] %#x: not in section" % (i, va))
            continue
        code = raw[off:off+0x50]
        insns = list(md.disasm(code, va))
        print("[%d] %#x:" % (i, va))
        count = 0
        for insn in insns:
            if insn.mnemonic == "int3":
                continue
            print("    %#x: %s %s" % (insn.address, insn.mnemonic, insn.op_str))
            count += 1
            if count >= 8:
                break
        print()

if __name__ == "__main__":
    main()
