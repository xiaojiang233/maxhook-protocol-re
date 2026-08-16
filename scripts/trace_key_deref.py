#!/usr/bin/env python3
"""Trace the key pointer dereference chain: +0xbd -> 0x1807bdc70 (pointer table)
-> actual key buffer.  Follow the pointers to find where the 32-byte key lives."""
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
    def rd64(va):
        off = va_to_off(pe, va)
        if off is None: return None
        return struct.unpack_from("<Q", raw, off)[0]

    # The key pointer +0xbd = 0x1807bdc70.  Its content is a pointer table.
    # Follow: what does 0x1807bdc70 contain? (first 8 bytes = 0x1803786c0)
    p0 = rd64(0x1807bdc70)
    print("0x1807bdc70 -> %#x" % p0)
    # Follow the chain
    for i in range(5):
        if p0 is None: break
        nxt = rd64(p0)
        print("  [%d] %#x -> %s" % (i, p0, hex(nxt) if nxt else "?"))
        p0 = nxt

    # The key (32B) hex = 32206f9c...  Search for it in the DLL .data
    key = bytes.fromhex("32206f9c196327ad276821ac8ebc7f80fe82d84cf72a4f7c1baf508c97d3aea8")
    idx = raw.find(key)
    print("\nkey in DLL raw:", "found at 0x%x" % idx if idx >= 0 else "NOT found (runtime-write)")

if __name__ == "__main__":
    main()
