#!/usr/bin/env python3
"""Find context slots that are CONSTANT within a single call (key-derived
state = S-box candidates) vs those that CHANGE (counters/pointers)."""
from __future__ import annotations
import json, glob
from pathlib import Path

CAP = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")

def load(call):
    snaps = []
    for f in sorted(CAP.glob(f"*call_{call}*.bin")):
        d = json.loads(f.read_text(encoding="utf-8"))
        snaps.append((d["xor_index"], d["keystream_byte"], bytes.fromhex(d["context_hex"])))
    snaps.sort()
    return snaps

def main():
    # For call 2 (20 snapshots, most data), find constant slots
    for call in (1, 2, 3):
        snaps = load(call)
        n = len(snaps)
        if n < 2:
            continue
        ctx0 = snaps[0][2]
        # slots constant across ALL snapshots in this call
        const = []
        for off in range(len(ctx0)):
            vals = {s[2][off] for s in snaps if off < len(s[2])}
            if len(vals) == 1:
                const.append(off)
        print(f"\n=== call {call}: {n} snapshots, {len(const)} constant slots (key-derived S-box candidates) ===")
        # group contiguous constant slots into ranges
        ranges = []
        if const:
            start = prev = const[0]
            for o in const[1:]:
                if o == prev + 1:
                    prev = o
                else:
                    ranges.append((start, prev))
                    start = prev = o
            ranges.append((start, prev))
        for a, b in ranges:
            print(f"  +0x{a:03x}..+0x{b:03x} ({b-a+1} bytes)")

if __name__ == "__main__":
    main()
