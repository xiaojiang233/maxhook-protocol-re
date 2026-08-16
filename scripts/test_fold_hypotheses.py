#!/usr/bin/env python3
"""Test fold hypotheses using keystream_history snapshots.

Within a call, key-schedule slots are constant.  The keystream byte at block b,
byte-offset j is F(const, b, j).  Test whether the 32-bit keystream word has a
simple structure (e.g., a lagged/xorshift/ARX update) by comparing consecutive
words within a call.

We only have sparse snapshots (every 64 bytes = one per block boundary), so we
can compare block N vs block N+1 keystream bytes and see if the update rule is
recognizable (e.g., word_{n+1} = word_n + const, or a rotation/xor).
"""
from __future__ import annotations
import json, glob
from pathlib import Path

CAP = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")

def load(call):
    out = []
    for f in sorted(CAP.glob(f"*call_{call}*.bin")):
        d = json.loads(f.read_text(encoding="utf-8"))
        out.append((d["xor_index"], d["keystream_byte"], bytes.fromhex(d["context_hex"])))
    out.sort()
    return out

def main():
    for call in (1, 2, 3):
        snaps = load(call)
        print(f"\n=== call {call} ===")
        # consecutive keystream bytes (at block boundaries)
        ks = [s[1] for s in snaps]
        print("keystream bytes:", [f"{b:02x}" for b in ks])
        # differences
        diffs = [(ks[i+1] - ks[i]) & 0xff for i in range(len(ks)-1)]
        xors = [ks[i+1] ^ ks[i] for i in range(len(ks)-1)]
        print("byte diffs (mod256):", [f"{d:02x}" for d in diffs])
        print("byte xors:          ", [f"{d:02x}" for d in xors])

        # The counter slot 0x26 increments 1,2,3,4...  Check if keystream byte
        # relates to counter via a simple rule.
        counters = [s[2][0x26] for s in snaps]
        print("counters (0x26):", counters)

if __name__ == "__main__":
    main()
