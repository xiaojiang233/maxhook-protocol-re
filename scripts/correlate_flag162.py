#!/usr/bin/env python3
"""Determine whether +0x162 alternation (0x69/0xC3) is position-dependent
(correlated with block counter) rather than key-dependent."""
import json
from pathlib import Path

CAP = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")

def main():
    for call in (1, 2, 3):
        print("call %d:" % call)
        for f in sorted(CAP.glob("*call_%s*.bin" % call)):
            d = json.loads(f.read_text(encoding="utf-8"))
            ctx = bytes.fromhex(d["context_hex"])
            flag = ctx[0x162]
            block = ctx[0x26]   # block counter
            byteoff = ctx[0xd9] # byte offset
            kb = d["keystream_byte"]
            print("  xor=%4d block=%3d byteoff=0x%02x flag=0x%02x ks=0x%02x" % (
                d["xor_index"], block, byteoff, flag, kb))
        print()

if __name__ == "__main__":
    main()
