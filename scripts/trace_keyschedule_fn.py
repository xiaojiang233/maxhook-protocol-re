#!/usr/bin/env python3
"""Trace the full plaintext key-schedule function (0x180322a20) to understand
its input/output interface and where keystream is produced.

The function is table-driven ARX.  We need to find:
1. Its input (rcx = key? nonce? state buffer?)
2. Its output (where keystream is written)
3. Whether it calls store32 (0x18041a860) or writes keystream directly
"""
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

    # disassemble the full function 0x180322a20 .. 0x180322e00 (until next ret/int3)
    start = 0x180322a20
    off = va_to_off(pe, start)
    code = raw[off:off+0x400]
    insns = list(md.disasm(code, start))
    print("=== full key-schedule function 0x180322a20 .. ===")
    for insn in insns:
        if insn.address > 0x180322e80:
            break
        mark = ""
        if insn.mnemonic == "call":
            mark = "  <-- call helper"
        if insn.mnemonic == "ret":
            mark = "  <-- return"
        if "store" in insn.mnemonic or insn.mnemonic == "movsb":
            mark = "  <-- store"
        print("  %#x: %s %s%s" % (insn.address, insn.mnemonic, insn.op_str, mark))

if __name__ == "__main__":
    main()
