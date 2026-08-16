#!/usr/bin/env python3
"""Fully disassemble the plaintext key-schedule code around 0x180322bc7, and
dump the helper table (0x1807bdc70) + data tables to understand the ARX key
mixing."""
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

    # Disassemble the key-schedule region 0x180322b80..0x180322e00
    off = va_to_off(pe, 0x180322b80)
    code = raw[off:off+0x280]
    insns = list(md.disasm(code, 0x180322b80))
    print("=== plaintext key-schedule 0x180322b80..0x180322e00 ===")
    for insn in insns:
        mark = ""
        if insn.mnemonic == "call" or insn.mnemonic.startswith("j"):
            mark = "  <--"
        if "0x44e924" in insn.op_str or "0xffbb16db" in insn.op_str or "0x7fcb1992" in insn.op_str:
            mark = "  <-- XOR const"
        if insn.mnemonic in ("ror","rol"):
            mark = "  <-- rotate"
        print("  %#x: %s %s%s" % (insn.address, insn.mnemonic, insn.op_str, mark))

    # dump the helper table at 0x1807bdc70 (16 entries)
    print("\n=== helper table 0x1807bdc70 (16 entries) ===")
    for i in range(16):
        va = 0x1807bdc70 + i*8
        off = va_to_off(pe, va)
        if off is None:
            print("  [%d] ???" % i); continue
        tgt = struct.unpack_from("<Q", raw, off)[0]
        print("  [%d] %#x" % (i, tgt))

if __name__ == "__main__":
    main()
