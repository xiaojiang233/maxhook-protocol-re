#!/usr/bin/env python3
"""Examine the live state slots (0x36, 0x45, 0x14a) and their relationship to
the keystream byte, to find the fold."""
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
        print(f"{'xor':>4} {'kb':>4} | {'0x36':>6} {'0x45':>6} {'0x14a':>6} {'0x26':>6} {'0xd9':>6} {'0xb5':>6}")
        for xi, kb, ctx in snaps:
            s36 = ctx[0x36] if len(ctx) > 0x36 else 0
            s45 = ctx[0x45] if len(ctx) > 0x45 else 0
            s14a = ctx[0x14a] if len(ctx) > 0x14a else 0
            s26 = ctx[0x26] if len(ctx) > 0x26 else 0
            sd9 = ctx[0xd9] if len(ctx) > 0xd9 else 0
            sb5 = ctx[0xb5] if len(ctx) > 0xb5 else 0
            print(f"{xi:4d} {kb:3d} | {s36:6d} {s45:6d} {s14a:6d} {s26:6d} {sd9:6d} {sb5:6d}")

        # Check if keystream byte is a function of these state slots
        # e.g. kb = (s36 + s45) & 0xff, etc.
        print("  fold tests (kb vs state):")
        for xi, kb, ctx in snaps:
            s36 = ctx[0x36]; s45 = ctx[0x45]; s14a = ctx[0x14a]
            candidates = {
                "s36^s45": s36 ^ s45,
                "s36+s45": (s36 + s45) & 0xff,
                "s36^s14a": s36 ^ s14a,
                "s45^s14a": s45 ^ s14a,
                "s36+s45+s14a": (s36 + s45 + s14a) & 0xff,
                "s36^s45^s14a": s36 ^ s45 ^ s14a,
            }
            matches = [k for k, v in candidates.items() if v == kb]
            if matches:
                print(f"    xor={xi}: kb={kb} matches {matches}")

if __name__ == "__main__":
    main()
