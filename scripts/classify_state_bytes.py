#!/usr/bin/env python3
"""Classify the 105 cross-call-differing bytes as key-derived (random) vs
ASLR-pointer (structured addresses)."""
from __future__ import annotations
import json, glob
from pathlib import Path

CAP = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")

def load(call):
    for f in sorted(CAP.glob(f"*call_{call}*.bin")):
        d = json.loads(f.read_text(encoding="utf-8"))
        return bytes.fromhex(d["context_hex"])

def main():
    c1, c2, c3 = load(1), load(2), load(3)
    diff = [i for i in range(768) if not (c1[i] == c2[i] == c3[i])]
    
    # For each 8-byte-aligned region, check if it's a pointer (structured) or
    # key material (random)
    # Group the 105 diff bytes into contiguous runs
    runs = []
    if diff:
        start = prev = diff[0]
        for o in diff[1:]:
            if o == prev + 1:
                prev = o
            else:
                runs.append((start, prev))
                start = prev = o
        runs.append((start, prev))
    
    print(f"{len(diff)} differing bytes in {len(runs)} runs:")
    for a, b in runs:
        v1 = c1[a:b+1]
        v2 = c2[a:b+1]
        v3 = c3[a:b+1]
        # classify: pointer-like if values share high bytes or are 8-byte aligned
        same_high = (v1[:2] == v2[:2] == v3[:2])
        label = "ptr?" if same_high else "key?"
        print(f"  +0x{a:03x}..+0x{b:03x} ({b-a+1:2d}B) {label}: c1={v1.hex()} c2={v2.hex()} c3={v3.hex()}")

if __name__ == "__main__":
    main()
