#!/usr/bin/env python3
"""Derive the fold: correlate context+0xb5 (keystream byte) with the 6
word-producer slot values within the SAME keystream_history snapshot.

The word-producer pushes context slots indexed by bytecode words {0xb5, 0x26,
0xd9, 0x61, 0xbd, 0x106}.  But those are the bytecode-word indices into
context.  The ACTUAL 6 values pushed are context[0xb5], context[0x26],
context[0xd9], context[0x61], context[0xbd], context[0x106].

Here keystream byte = context[0xb5] (confirmed ~90%).  So we test whether
context[0xb5] is a simple function of the other slots.
"""
from __future__ import annotations
import json, glob
from pathlib import Path
from itertools import combinations

CAP = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")
SLOTS = [0x26, 0x61, 0xbd, 0xd9, 0x106, 0x45, 0x85, 0x6d, 0xed, 0xe5, 0xa, 0x162]

def load(call):
    out = []
    for f in sorted(CAP.glob(f"*call_{call}*.bin")):
        d = json.loads(f.read_text(encoding="utf-8"))
        ctx = bytes.fromhex(d["context_hex"])
        out.append((d["xor_index"], d["keystream_byte"], ctx))
    return out

def main():
    for call in (1, 2, 3):
        snaps = load(call)
        print(f"\n=== call {call} ({len(snaps)} snapshots) ===")
        # For each snapshot, keystream byte = ctx[0xb5] (or ctx[0x235] alternation)
        # Print the 6 slot values vs keystream byte for a few snapshots
        for xi, kb, ctx in snaps[:4]:
            vals = {hex(s): ctx[s] if s < len(ctx) else None for s in SLOTS}
            print(f"  xor={xi:4d} ks_byte={kb:02x} ctx0xb5={ctx[0xb5]:02x} ctx0x235={ctx[0x235]:02x}")
            print(f"      slots: " + " ".join(f"{h}={v}" for h,v in vals.items()))

        # Test: is ks_byte == ctx[0xb5] ^ ctx[0x26] ^ ... any simple fold?
        # Focus on ctx[0xb5] as the ks byte source; check XOR/ADD relationships
        # with the other slots that are CONSTANT across the call (key-derived)
        # vs those that change (position-derived).
        if snaps:
            # find which slots are constant across all snapshots in this call
            const = []
            for s in SLOTS:
                vals = {sn[2][s] for sn in snaps if s < len(sn[2])}
                if len(vals) == 1:
                    const.append((hex(s), list(vals)[0]))
            print(f"  constant slots across call: {const}")

if __name__ == "__main__":
    main()
