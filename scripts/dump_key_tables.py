#!/usr/bin/env python3
"""Correct the table addresses and dump the helper table + data tables.

lea r14, [rip + 0x49b0a0] at 0x180322bc9 -> target = 0x180322bd0 + 0x49b0a0
lea r15, [rip + 0x335fb8] at 0x180322b89 -> target = 0x180322b90 + 0x335fb8
lea r12, [rip + 0x4a0f20] at 0x180322ba9 -> target = 0x180322bb0 + 0x4a0f20
"""
import struct
from pathlib import Path
import sys
sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
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

    # table addresses (rip-relative, target = next_insn + disp)
    helper_tbl = 0x180322bd0 + 0x49b0a0  # r14
    data_tbl1 = 0x180322b90 + 0x335fb8    # r15
    data_tbl2 = 0x180322bb0 + 0x4a0f20    # r12
    print("helper table: %#x" % helper_tbl)
    print("data table 1: %#x" % data_tbl1)
    print("data table 2: %#x" % data_tbl2)

    # dump helper table (16 entries)
    print("\nhelper table (%#x) 16 entries:" % helper_tbl)
    for i in range(16):
        va = helper_tbl + i*8
        off = va_to_off(pe, va)
        if off is None:
            print("  [%d] ??? (not in section)" % i); continue
        tgt = struct.unpack_from("<Q", raw, off)[0]
        print("  [%d] %#x" % (i, tgt))

    # dump data table 1 (first 16 dwords)
    print("\ndata table 1 (%#x) first 16 dwords:" % data_tbl1)
    for i in range(16):
        va = data_tbl1 + i*4
        off = va_to_off(pe, va)
        if off is None:
            print("  [%d] ???" % i); continue
        v = struct.unpack_from("<I", raw, off)[0]
        print("  [%d] %#08x" % (i, v))

    # dump data table 2 (first 16 dwords)
    print("\ndata table 2 (%#x) first 16 dwords:" % data_tbl2)
    for i in range(16):
        va = data_tbl2 + i*4
        off = va_to_off(pe, va)
        if off is None:
            print("  [%d] ???" % i); continue
        v = struct.unpack_from("<I", raw, off)[0]
        print("  [%d] %#08x" % (i, v))

if __name__ == "__main__":
    main()
