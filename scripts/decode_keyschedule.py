#!/usr/bin/env python3
"""Decode the key-schedule bytecode using the dispatch formula:
index = (word[VIP+4] + rolling_key) & 0xffff; key -= index; handler = table + index*8."""
from __future__ import annotations
import struct
from pathlib import Path

DUMP = Path(r"E:\Coding\S1mple\target\dump_out\41264\region_0000000180980000.bin")
BUG_BASE = 0x180980000
HANDLER_TABLE = 0x180c64ebd

def main():
    data = DUMP.read_bytes()
    table_off = HANDLER_TABLE - BUG_BASE
    vip = 0x181555629  # key-schedule entry VIP (round 74)
    key = 0xffffffa5   # initial rolling key (milestone 17)

    print("decoding key-schedule bytecode (first 24 dispatches):")
    for i in range(24):
        # dispatch reads word[VIP+4]
        word_off = (vip + 4) - BUG_BASE
        w = struct.unpack('<H', data[word_off:word_off+2])[0]
        index = (w + key) & 0xffff
        handler_off = table_off + index * 8
        handler = struct.unpack('<Q', data[handler_off:handler_off+8])[0]
        key = (key - index) & 0xffffffff
        valid = BUG_BASE <= handler < BUG_BASE + len(data)
        print(f"  [{i:2d}] VIP={vip:#x} word={w:#06x} index={index:#06x} key->{key:#010x} handler={handler:#x} {'OK' if valid else 'INVALID'}")
        # advance VIP (approximate: +6 per instruction)
        vip += 6

if __name__ == "__main__":
    main()
