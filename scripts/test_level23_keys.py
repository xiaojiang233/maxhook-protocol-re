#!/usr/bin/env python3
"""Determine the correct level 23 dispatch using the emulator's recorded keys.

From vm_dispatch_chain_extended.json emulator_contrast:
  emulator key at inst 34082 = 0x6e3ac3ba (handler 0x180ac2fxx)
  emulator key at inst 34216 = 0x1c771 (handler 0x180a50bxx)

These are the CORRECT keys (the emulator actually executed the right path).
The level-23 handler 0x1809b6a53's dispatch index expression is:
  index = ((word[VIP+6] - key) - 0x6554fdd7) & 0xffff

With the static key 0x7c2c16c7 -> index 0x798 (invalid).
Let me try the emulator's key 0x6e3ac3ba and see if it gives a valid index.
"""
import struct
from pathlib import Path

BUGLAND = Path(r"E:\Coding\S1mple\target\dump_out\41264\region_0000000180980000.bin")
BUGLAND_BASE = 0x180980000
TABLE_VA = 0x180C64EBD

def main():
    blob = BUGLAND.read_bytes()
    def rd16(va): return struct.unpack_from("<H", blob, va - BUGLAND_BASE)[0]
    def rd64(va): return struct.unpack_from("<Q", blob, va - BUGLAND_BASE)[0]

    vip = 0x18155c6b7  # level 23 vip_before
    w6 = rd16(vip + 6)
    print("word[VIP+6] = 0x%x" % w6)

    for key in [0x7c2c16c7, 0x6e3ac3ba, 0x1c771, 0x6e3ac3ba & 0xffff, 0xffffa301]:
        idx = ((w6 - key) - 0x6554fdd7) & 0xffff
        tgt = rd64(TABLE_VA + idx * 8) if idx < 1612 else None
        print("key=0x%x -> idx=0x%x (%d) -> table=%s" % (
            key, idx, idx, hex(tgt) if tgt else "OUT OF RANGE"))

if __name__ == "__main__":
    main()
