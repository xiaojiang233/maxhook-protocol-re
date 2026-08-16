#!/usr/bin/env python3
"""Disassemble the plaintext helper at 0x18001ebb0 (the VM→helper transition),
which does the key/nonce mixing.  This is in the DLL's main .text section."""
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

def main():
    pe = pefile.PE(str(DLL))
    raw = DLL.read_bytes()
    md = Cs(CS_ARCH_X86, CS_MODE_64)

    # disassemble 0x18001ebb0 and 0x180322bc7 (the call site)
    for va in [0x18001ebb0, 0x180322bc7]:
        off = va_to_off(pe, va)
        if off is None:
            print("%#x: not in a section" % va)
            continue
        code = raw[off:off+0x60]
        insns = list(md.disasm(code, va))
        print("=== %#x ===" % va)
        for insn in insns[:25]:
            print("  %#x: %s %s" % (insn.address, insn.mnemonic, insn.op_str))
        print()

if __name__ == "__main__":
    main()
