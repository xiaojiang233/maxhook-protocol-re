#!/usr/bin/env python3
"""Verify the plaintext key-schedule: disassemble the full function containing
0x180322b80 to understand the overall structure (is it the key-schedule or a
sub-dispatch?), and identify where key/nonce bytes enter."""
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

    # Find the function containing 0x180322b80 — scan backwards for a prologue
    # (sub rsp / push).  Start from 0x180322b80 and go back ~0x200 bytes.
    start = 0x180322980
    off = va_to_off(pe, start)
    code = raw[off:off+0x600]
    insns = list(md.disasm(code, start))
    # find the function prologue (push/sub rsp) nearest before 0x180322b80
    print("=== function around 0x180322b80 (from 0x180322980) ===")
    for insn in insns:
        if insn.address > 0x180323000:
            break
        mark = ""
        if insn.mnemonic in ("push","sub") and insn.address < 0x180322b80:
            mark = "  <-- prologue?"
        if insn.address == 0x180322b80:
            mark = "  <-- key-schedule start"
        if insn.mnemonic == "call":
            mark = "  <-- call"
        print("  %#x: %s %s%s" % (insn.address, insn.mnemonic, insn.op_str, mark))

if __name__ == "__main__":
    main()
