#!/usr/bin/env python3
"""Trace where the nonce enters the key-schedule. The nonce is 12 bytes, generated
by CSPRNG. The key-schedule reads key (32B) + nonce (12B) = 44B = the 47-byte state.

Let me check: in the seed_and_capture walker, after seeding the key, does the
key-schedule produce any state that relates to the nonce?  Also check where the
nonce might be written (the CSPRNG output buffer).

Actually, let me look at the key-schedule handlers that READ 12-byte (3-word)
values — the nonce.  The nonce is read via specific context slots or heap.

From the round-100 context slots, nonce-related slots: +0x26 (block counter),
+0xd9 (byte offset) are position, not nonce.  The nonce must be read from a
specific location during key-schedule.

Let me check the key pointer +0xbd target (0x1807bdc70) region in the DLL —
maybe the key AND nonce are stored adjacently there.
"""
import struct
from pathlib import Path

DLL = Path(r"E:\Coding\S1mple\target\MaxHook.runtime-unpacked.dll")
import sys
sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
import pefile

def main():
    pe = pefile.PE(str(DLL))
    raw = DLL.read_bytes()
    # read the region around 0x1807bdc70 (key pointer target) and 0x1807bf900 (state ptr)
    for va in [0x1807bdc70, 0x1807bf900, 0x1807c3ad0, 0x180668050]:
        # find section
        off = None
        for s in pe.sections:
            sec_va = 0x180000000 + s.VirtualAddress
            vs = max(s.Misc_VirtualSize, s.SizeOfRawData)
            if sec_va <= va < sec_va + vs:
                off = s.PointerToRawData + (va - sec_va)
                break
        if off is None:
            print("%#x: not in a section" % va)
            continue
        data = raw[off:off+64]
        print("%#x: %s" % (va, data.hex()))

if __name__ == "__main__":
    main()
