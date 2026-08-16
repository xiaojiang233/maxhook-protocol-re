#!/usr/bin/env python3
"""Find the live cipher state: which context slots CHANGE between consecutive
XOR-time snapshots within a call (these advance as keystream is produced)."""
from __future__ import annotations
import json, glob
from pathlib import Path
from collections import Counter

CAP = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")

def main():
    for call in (1, 2, 3):
        files = sorted(CAP.glob(f"*call_{call}*.bin"))
        snaps = []
        for f in files:
            d = json.loads(f.read_text(encoding="utf-8"))
            snaps.append((d["xor_index"], d["keystream_byte"], bytes.fromhex(d["context_hex"])))
        snaps.sort()

        # Find slots that change between ANY two consecutive snapshots
        changing = Counter()
        for i in range(len(snaps) - 1):
            _, _, c0 = snaps[i]
            _, _, c1 = snaps[i+1]
            for off in range(min(len(c0), len(c1))):
                if c0[off] != c1[off]:
                    changing[off] += 1

        # slots that change in EVERY consecutive pair = actively advancing state
        n_pairs = len(snaps) - 1
        always_changing = [off for off, cnt in changing.items() if cnt == n_pairs]
        mostly = changing.most_common(20)

        print(f"\n=== call {call} ({len(snaps)} snaps, {n_pairs} pairs) ===")
        print(f"slots changing in ALL {n_pairs} pairs ({len(always_changing)}):")
        for off in always_changing:
            print(f"  +0x{off:03x}")
        print("top 20 most-changing slots:")
        for off, cnt in mostly:
            print(f"  +0x{off:03x}: changes in {cnt}/{n_pairs} pairs")

if __name__ == "__main__":
    main()
