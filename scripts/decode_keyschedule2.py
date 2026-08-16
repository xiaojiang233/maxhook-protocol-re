#!/usr/bin/env python3
"""Decode key-schedule bytecode with the CORRECT dispatch formula from milestone 17:
index = (word[VIP+0] - key + 0x5214a88c) & 0xffff."""
from __future__ import annotations
import struct
from pathlib import Path

DUMP = Path(r"E:\Coding\S1mple\target\dump_out\41264\region_0000000180980000.bin")
BUG_BASE = 0x180980000
HANDLER_TABLE = 0x180c64ebd

def main():
    data = DUMP.read_bytes()
    table_off = HANDLER_TABLE - BUG_BASE
    vip = 0x181555629
    key = 0xffffffa5

    print("decoding with milestone-17 formula: index=(word[VIP]-key+0x5214a88c)&0xffff:")
    for i in range(24):
        word_off = (vip) - BUG_BASE
        w = struct.unpack('<H', data[word_off:word_off+2])[0]
        index = (w - key + 0x5214a88c) & 0xffff
        handler_off = table_off + index * 8
        handler = struct.unpack('<Q', data[handler_off:handler_off+8])[0]
        # rolling key update (milestone 20: key ^= key + 0x4111)
        key = ((key ^ ((key + 0x4111) & 0xffffffff))) & 0xffffffff
        valid = BUG_BASE <= handler < BUG_BASE + len(data)
        print(f"  [{i:2d}] VIP={vip:#x} word={w:#06x} index={index:#06x} handler={handler:#x} {'OK' if valid else 'INVALID'}")
        vip += 2  # bytecode word is 2 bytes; but instruction size varies

if __name__ == "__main__":
    main()
