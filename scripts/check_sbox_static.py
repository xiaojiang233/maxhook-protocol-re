#!/usr/bin/env python3
"""Check whether the S-box at 0x180835f10 is static module data readable from
MaxHook.runtime-unpacked.dll.  If it's a high-entropy table, the fold's S-box
lookup becomes known offline (closing a key input)."""
import struct
from pathlib import Path
import sys

sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
import pefile

DLL = Path(r"E:\Coding\S1mple\target\MaxHook.runtime-unpacked.dll")
IMAGE_BASE = 0x180000000
SBOX = 0x180835F10  # context+0x61 pointed here at xor=64 (live session)

def va_to_off(pe, va):
    for s in pe.sections:
        sec_va = IMAGE_BASE + s.VirtualAddress
        vs = max(s.Misc_VirtualSize, s.SizeOfRawData)
        if sec_va <= va < sec_va + vs:
            return s.PointerToRawData + (va - sec_va)
    return None

def main():
    pe = pefile.PE(str(DLL))
    raw = DLL.read_bytes()
    off = va_to_off(pe, SBOX)
    print("S-box VA 0x%x -> file offset 0x%x" % (SBOX, off or 0))
    if off is None:
        print("NOT in a section (may be runtime-allocated / .bss)")
        return
    # dump 256 bytes
    data = raw[off:off+256]
    print("first 64 bytes:", data[:64].hex())
    # entropy / distinct
    distinct = len(set(data[:256]))
    print("distinct byte values in 256B: %d" % distinct)
    # check if looks like S-box (permutation) or zeros/pointers
    if distinct > 200:
        print("HIGH distinct count -> looks like a static S-box (permutation)!")
    elif set(data[:64]) == {0}:
        print("all-zero -> .bss, populated at runtime (not static)")
    else:
        print("mixed -> inspect further")
    # also dump 256 bytes as 64 u32
    for i in range(0, 64, 16):
        words = struct.unpack("<IIII", data[i:i+16])
        print("  +0x%03x: %08x %08x %08x %08x" % (i, *words))

if __name__ == "__main__":
    main()
