#!/usr/bin/env python3
"""Find the ~100 bytes that DIFFER across calls = the key-derived cipher state."""
from __future__ import annotations
import json, glob
from pathlib import Path

CAP = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")

def load(call):
    for f in sorted(CAP.glob(f"*call_{call}*.bin")):
        d = json.loads(f.read_text(encoding="utf-8"))
        return bytes.fromhex(d["context_hex"])
    return None

def main():
    c1, c2, c3 = load(1), load(2), load(3)
    # bytes that differ between ANY two calls
    diff = [i for i in range(768) if not (c1[i] == c2[i] == c3[i])]
    print(f"bytes differing across calls: {len(diff)}")
    print("differing offsets:")
    # group into ranges
    if diff:
        ranges = []
        start = prev = diff[0]
        for o in diff[1:]:
            if o == prev + 1:
                prev = o
            else:
                ranges.append((start, prev))
                start = prev = o
        ranges.append((start, prev))
        for a, b in ranges:
            vals1 = c1[a:b+1].hex()
            vals2 = c2[a:b+1].hex()
            vals3 = c3[a:b+1].hex()
            print(f"  +0x{a:03x}..+0x{b:03x}: call1={vals1} call2={vals2} call3={vals3}")

if __name__ == "__main__":
    main()
