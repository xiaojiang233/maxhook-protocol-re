#!/usr/bin/env python3
"""Decode the VM bytecode using the correct dispatch formula:
index = (word[VIP+4] + rolling_key) & 0xffff; key -= index.

This reconstructs the actual handler sequence the VM would execute."""
from __future__ import annotations
import json, struct
from pathlib import Path

DUMP = Path(r"E:\Coding\S1mple\target\dump_out\41264\region_0000000180980000.bin")
BUGLAND_BASE = 0x180980000
HANDLER_TABLE = 0x180c64ebd

def main():
    data = DUMP.read_bytes()
    # rolling key initial (from milestone 17) and VIP initial
    # Let's read the dump context's VIP and rolling key
    ctx_off = 0x18098c884 - BUGLAND_BASE  # 0xc884
    ctx = data[ctx_off:ctx_off+0x300]
    vip = struct.unpack('<Q', ctx[0x6d:0x75])[0]
    key = struct.unpack('<I', ctx[0xa:0xe])[0]
    print(f"dump VIP = {vip:#x}, rolling key = {key:#010x}")
    print()

    # decode first 20 bytecode words using formula: index = (word[VIP+4] + key) & 0xffff
    # Note: the dispatcher reads word[VIP+4], but the bytecode advances VIP by the
    # word's operand size. We'll read sequential words for now.
    table_off = HANDLER_TABLE - BUGLAND_BASE
    k = key
    v = vip
    print("decoded handler sequence (first 20):")
    for i in range(20):
        word_off = (v + 4) - BUGLAND_BASE
        w = struct.unpack('<H', data[word_off:word_off+2])[0]
        index = (w + k) & 0xffff
        handler_off = table_off + index * 8
        handler = struct.unpack('<Q', data[handler_off:handler_off+8])[0]
        # update key
        k = (k - index) & 0xffffffff
        print(f"  [{i:2d}] VIP={v:#x} word={w:#06x} index={index:#06x} key->{k:#010x} handler={handler:#x}")
        v += 6  # approximate: each bytecode instruction advances VIP by ~6 bytes

if __name__ == "__main__":
    main()
