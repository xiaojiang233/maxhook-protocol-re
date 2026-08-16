#!/usr/bin/env python3
"""Find the truly key-derived bytes: constant WITHIN a call, differ ACROSS calls."""
from __future__ import annotations
import json, glob
from pathlib import Path

CAP = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")

def load(call):
    snaps = []
    for f in sorted(CAP.glob(f"*call_{call}*.bin")):
        d = json.loads(f.read_text(encoding="utf-8"))
        snaps.append(bytes.fromhex(d["context_hex"]))
    return snaps

def main():
    c1, c2, c3 = load(1), load(2), load(3)
    # truly key-derived: constant within each call, but differs across calls
    key_bytes = []
    for i in range(768):
        within1 = len({s[i] for s in c1}) == 1
        within2 = len({s[i] for s in c2}) == 1
        within3 = len({s[i] for s in c3}) == 1
        cross = not (c1[0][i] == c2[0][i] == c3[0][i])
        if within1 and within2 and within3 and cross:
            key_bytes.append(i)
    print(f"truly key-derived bytes (constant within call, differ across calls): {len(key_bytes)}")
    # group into ranges
    if key_bytes:
        ranges = []
        s = p = key_bytes[0]
        for o in key_bytes[1:]:
            if o == p+1: p = o
            else: ranges.append((s,p)); s = p = o
        ranges.append((s,p))
        for a,b in ranges:
            print(f"  +0x{a:03x}..+0x{b:03x} ({b-a+1}B): c1={c1[0][a:b+1].hex()} c2={c2[0][a:b+1].hex()} c3={c3[0][a:b+1].hex()}")

if __name__ == "__main__":
    main()
