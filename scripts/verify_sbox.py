#!/usr/bin/env python3
"""Verify the ~520 constant slots are the key-derived S-box: compare across
calls (different keys) to confirm they differ (key-derived) vs same (constant)."""
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
    c1 = load(1)[0]  # first snapshot of call 1
    c2 = load(2)[0]
    c3 = load(3)[0]
    print("context sizes:", len(c1), len(c2), len(c3))
    # compare constant slots across calls
    same_1_2 = sum(1 for i in range(min(len(c1),len(c2))) if c1[i] == c2[i])
    same_1_3 = sum(1 for i in range(min(len(c1),len(c3))) if c1[i] == c3[i])
    print(f"bytes same call1 vs call2: {same_1_2}/{len(c1)}")
    print(f"bytes same call1 vs call3: {same_1_3}/{len(c1)}")
    # dump the S-box (constant slots) of call 1
    print("\ncall 1 full context (768 bytes) first 256 bytes:")
    for i in range(0, 256, 32):
        print(f"  +{i:03x}: {c1[i:i+32].hex()}")

if __name__ == "__main__":
    main()
