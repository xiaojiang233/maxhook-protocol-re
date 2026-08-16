#!/usr/bin/env python3
"""Recover the 4 encrypted index-table dwords by inverting the generator's
deobfuscation, using the writer_sync oracle.

The generator dispatch:
  cl = 0x405a9e0 - dword[shift_src]
  eax = rol(bswap(rol(0x6000000, cl)), cl)
  r8d = dword[index_table + eax*4]     (encrypted, +1 before deobf)
  r8d = rol(r8d, 0x5e9298bc - eax); ror(r8d, eax + 0x5e9298bc);
        rol(r8d, 0x5e9298bc - eax); ror(r8d, eax + 0x5e9298bc)
  fn_index = r8d (must be 0..15 for valid fn table entry)

Since deobf is bijective, for each valid fn_index 0..15, invert to find the
encrypted dword, then verify against the oracle keystream.
"""
from __future__ import annotations
import json, struct
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

def deobfuscate(r8, eax):
    """The forward deobfuscation: r8 -> fn_index."""
    r8 = (r8 + 1) & 0xFFFFFFFF
    edx = (0x5e9298bc - eax) & 0xFFFFFFFF
    r8 = rol32(r8, edx)
    r8 = ror32(r8, (eax + 0x5e9298bc) & 0xFFFFFFFF)
    r8 = rol32(r8, edx)
    r8 = ror32(r8, (eax + 0x5e9298bc) & 0xFFFFFFFF)
    return r8

def inverse_deobfuscate(fn_index, eax):
    """Inverse: fn_index -> encrypted dword (before +1)."""
    edx = (0x5e9298bc - eax) & 0xFFFFFFFF
    eax2 = (eax + 0x5e9298bc) & 0xFFFFFFFF
    r8 = fn_index
    r8 = rol32(r8, eax2)   # undo ror
    r8 = ror32(r8, edx)    # undo rol
    r8 = rol32(r8, eax2)   # undo ror
    r8 = ror32(r8, edx)    # undo rol
    return (r8 - 1) & 0xFFFFFFFF

def main():
    pe = pefile.PE(str(DLL))
    raw = DLL.read_bytes()
    base = 0x180000000
    def va_to_off(va):
        for s in pe.sections:
            sv = base + s.VirtualAddress
            if sv <= va < sv + max(s.Misc_VirtualSize, s.SizeOfRawData):
                return s.PointerToRawData + (va - sv)
        return None
    def dword(va):
        off = va_to_off(va)
        return struct.unpack("<I", raw[off:off+4])[0]

    # For each subcall, compute eax and invert for each fn_index 0..15
    print("For each subcall: eax, and the encrypted dword for each fn_index 0..15:")
    for i, src in enumerate(SHIFT_SOURCES):
        cl = (0x405A9E0 - dword(src)) & 0xFFFFFFFF
        eax = rol32(0x6000000, cl)
        eax = bswap32(eax)
        eax = rol32(eax, cl)
        print(f"\nsubcall {i}: src={src:#x} dword[src]={dword(src):#x} cl={cl:#x} eax={eax:#x}")
        # on-disk encrypted value
        disk = dword(IDX_TABLE + eax*4)
        print(f"  on-disk encrypted: {disk:#x} (index_table[{eax:#x}])")
        print(f"  deobf(disk) = {deobfuscate(disk, eax):#x}")
        # invert for each fn_index
        for fn in range(16):
            enc = inverse_deobfuscate(fn, eax)
            print(f"    fn_index={fn:2d} -> encrypted dword = {enc:#010x}")

if __name__ == "__main__":
    main()
