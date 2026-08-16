#!/usr/bin/env python3
"""Verify handler table entries in the dump (are they valid .bugland addresses?)."""
from __future__ import annotations
import struct
from pathlib import Path

DUMP = Path(r"E:\Coding\S1mple\target\dump_out\41264\region_0000000180980000.bin")
BUG_BASE = 0x180980000

def main():
    data = DUMP.read_bytes()
    table_off = 0x180c64ebd - BUG_BASE
    print("handler table 0x180c64ebd first 16 entries:")
    ok = 0
    for i in range(16):
        e = struct.unpack("<Q", data[table_off + i*8 : table_off + i*8 + 8])[0]
        valid = BUG_BASE <= e < BUG_BASE + len(data)
        if valid:
            ok += 1
        print(f"  [{i:4d}] {e:#018x} {'OK' if valid else 'INVALID'}")
    print(f"\n{ok}/16 valid .bugland addresses")

if __name__ == "__main__":
    main()
