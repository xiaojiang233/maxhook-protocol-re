#!/usr/bin/env python3
"""
Test whether the keystream is a lagged/recursive generator.

If keystream word w[n+1] = f(w[n], counter) for a simple f (add/xor/rotate),
we can detect it from the 800 ground-truth words in writer_sync.

Tests:
1. w[n+1] ^ w[n] pattern (xorshift-like)
2. w[n+1] - w[n] (counter addition)
3. w[n+1] == rotate(w[n]) ^ const
"""
from __future__ import annotations
import json, struct
from pathlib import Path

ANALYSIS = json.loads(Path(r"E:\Coding\S1mple\target\writer_sync_clean_20260814_014351\analysis.json").read_text(encoding="utf-8"))

def rol32(x, n): return ((x << n) | (x >> (32 - n))) & 0xffffffff

def words(ks):
    return [int.from_bytes(ks[i:i+4], "little") for i in range(0, len(ks)//4*4, 4)]

def main():
    for c in ANALYSIS["calls"]:
        ks = bytes.fromhex(c["keystream_hex"])
        w = words(ks)
        print(f"\n=== call {c['call_id']} ({len(w)} words) ===")
        # consecutive word diffs/xors
        xors = [w[i+1] ^ w[i] for i in range(len(w)-1)]
        diffs = [(w[i+1] - w[i]) & 0xffffffff for i in range(len(w)-1)]
        # check if xors/diffs repeat (period)
        print("first 8 word xors:", [f"{x:#010x}" for x in xors[:8]])
        print("first 8 word diffs:", [f"{x:#010x}" for x in diffs[:8]])
        # check for simple recurrence: w[n+1] == rol(w[n]) ^ const ?
        # gather (w[n], w[n+1]) pairs and test rotation+xor
        consts = set()
        for n in range(len(w)-1):
            for r in range(1, 32):
                c = (rol32(w[n], r) ^ w[n+1])
                consts.add((r, c))
        # if any (r,c) is consistent across ALL pairs, that's the recurrence
        from collections import Counter
        cnt = Counter(consts)
        common = cnt.most_common(3)
        print("most common (rotation, const) pairs:", [(f"r={r},c={c:#x}", n) for (r, c), n in common])

if __name__ == "__main__":
    main()
