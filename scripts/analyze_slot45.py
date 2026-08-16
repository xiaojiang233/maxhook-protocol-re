#!/usr/bin/env python3
"""Analyze slot 0x45 (key-dependent live state) across blocks, and check its
relationship to the keystream byte.  0x45 cycles through 4 values per 64-byte
block, suggesting it's a round counter or state index."""
from __future__ import annotations
import json, glob
from pathlib import Path

CAP = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")

def main():
    for call in (1, 2, 3):
        files = sorted(CAP.glob(f"*call_{call}*.bin"))
        snaps = []
        for f in files:
            d = json.loads(f.read_text(encoding="utf-8"))
            snaps.append((d["xor_index"], d["keystream_byte"], bytes.fromhex(d["context_hex"])))
        snaps.sort()

        print(f"\n=== call {call} ===")
        # 0x45 as 4-byte little-endian word
        print("0x45 (32-bit LE) vs keystream byte:")
        for xi, kb, ctx in snaps:
            if len(ctx) >= 0x49:
                s45 = int.from_bytes(ctx[0x45:0x49], "little")
                print(f"  xor={xi:4d} kb={kb:02x} 0x45={s45:#010x}")

        # The 4-value cycle of 0x45: is it (base + block_index*const) mod something?
        vals = [int.from_bytes(ctx[0x45:0x49], "little") for _, _, ctx in snaps if len(ctx) >= 0x49]
        if len(vals) >= 4:
            # diffs between consecutive
            diffs = [(vals[i+1] - vals[i]) & 0xffffffff for i in range(len(vals)-1)]
            print("  0x45 diffs:", [f"{d:#010x}" for d in diffs[:8]])

if __name__ == "__main__":
    main()
