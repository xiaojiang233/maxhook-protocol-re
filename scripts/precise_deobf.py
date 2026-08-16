#!/usr/bin/env python3
"""Precisely compute the forward deobfuscation for the on-disk encrypted values,
and determine what fn_index each subcall resolves to."""
from __future__ import annotations
import struct
from pathlib import Path
import pefile

T = Path(r"E:\Coding\S1mple\target")
DLL = T / "MaxHook.runtime-unpacked.dll"

SHIFT_SOURCES = [0x180894B04, 0x180894AEC, 0x180894B00, 0x180894AE8]
IDX_TABLE = 0x1807D7CF0

def rol32(x, n):
    n &= 0x1F
    return ((x << n) | (x >> (32 - n))) & 0xFFFFFFFF

def ror32(x, n):
    n &= 0x1F
    return ((x >> n) | (x << (32 - n))) & 0xFFFFFFFF

def bswap32(x):
    return int.from_bytes(x.to_bytes(4, "little"), "big")

def main():
    pe = pefile.PE(str(DLL))
    raw = DLL.read_bytes()
    base = 0x180000000
    def va_to_off(va):
        for s in pe.sections:
            sv = base + s.VirtualAddress
            if sv <= va < sv + max(s.Misc_VirtualSize, s.SizeOfRawData):
                return s.PointerToRawData + (va - sv)
    def dword(va):
        off = va_to_off(va)
        return struct.unpack("<I", raw[off:off+4])[0]

    for i, src in enumerate(SHIFT_SOURCES):
        cl = (0x405A9E0 - dword(src)) & 0xFFFFFFFF
        eax = rol32(0x6000000, cl)
        eax = bswap32(eax)
        eax = rol32(eax, cl)
        enc = dword(IDX_TABLE + eax*4)
        # forward deobf: inc; rol(edx); ror(eax2); rol(edx); ror(eax2)
        edx = (0x5e9298bc - eax) & 0xFFFFFFFF
        eax2 = (eax + 0x5e9298bc) & 0xFFFFFFFF
        r8 = (enc + 1) & 0xFFFFFFFF
        r8 = rol32(r8, edx)
        r8 = ror32(r8, eax2)
        r8 = rol32(r8, edx)
        r8 = ror32(r8, eax2)
        print(f"subcall {i}: eax={eax:#x} enc={enc:#x} deobf={r8:#x} (fn_index={r8 if r8 < 16 else 'INVALID'})")

if __name__ == "__main__":
    main()
