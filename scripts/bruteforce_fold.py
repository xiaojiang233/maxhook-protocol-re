#!/usr/bin/env python3
"""
Brute-force search for the fold relationship using 52 keystream_history
snapshots (full 768B context + keystream byte at XOR time).

For each snapshot, keystream byte K = ctx[0xb5].  Test whether K is a simple
function of other context slots: K = f(slot_i, slot_j) for various f in
{add, xor, sub}, over the candidate slots.

If a simple 2-slot fold is found, that's the fold.  Otherwise the fold is
higher-order (3+ slots or nonlinear via shr/shl/not/neg).
"""
from __future__ import annotations
import json, glob
from pathlib import Path

CAP = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")

# candidate slots (the word-producer's 6 slots + nearby state)
SLOTS = [0x26, 0x45, 0x61, 0x6d, 0x85, 0xbd, 0xd9, 0xe5, 0xed, 0x106, 0x143, 0x1e, 0x98, 0x92, 0xa0, 0x11b, 0xff]

def load_all():
    snaps = []
    for f in sorted(CAP.glob("*call_*.bin")):
        d = json.loads(f.read_text(encoding="utf-8"))
        ctx = bytes.fromhex(d["context_hex"])
        kb = d["keystream_byte"]
        snaps.append((d["xor_index"], kb, ctx))
    return snaps

def main():
    snaps = load_all()
    print(f"total snapshots: {len(snaps)}")

    # First: is K = ctx[0xb5] always? (already known ~90%, but check 0x235 alternation)
    n_b5 = sum(1 for _, kb, ctx in snaps if ctx[0xb5] == kb)
    n_235 = sum(1 for _, kb, ctx in snaps if ctx[0x235] == kb)
    print(f"K==ctx[0xb5]: {n_b5}/{len(snaps)}, K==ctx[0x235]: {n_235}/{len(snaps)}")

    # The keystream byte source slot (0xb5 or 0x235) alternates.  Use the one
    # that matches.  For fold search, use K as the target and search for
    # 2-slot simple functions.
    # Filter to snapshots where K==ctx[0xb5] (the "A" buffer phase)
    a_snaps = [(xi, kb, ctx) for xi, kb, ctx in snaps if ctx[0xb5] == kb]
    print(f"snapshots in 'A' phase (K==0xb5): {len(a_snaps)}")

    # Test all pairs of slots with add/xor/sub (byte-level, mod 256)
    ops = {
        "add": lambda x, y: (x + y) & 0xff,
        "xor": lambda x, y: x ^ y,
        "sub": lambda x, y: (x - y) & 0xff,
    }
    best = []
    for i, si in enumerate(SLOTS):
        for sj in SLOTS:
            for opname, op in ops.items():
                ok = 0
                for xi, kb, ctx in a_snaps:
                    if si < len(ctx) and sj < len(ctx):
                        if op(ctx[si], ctx[sj]) == kb:
                            ok += 1
                if ok > 0:
                    best.append((ok, si, sj, opname))
    best.sort(reverse=True)
    print("\ntop 2-slot fold candidates (ok_count, slot_i, slot_j, op):")
    for ok, si, sj, op in best[:20]:
        print(f"  {ok:3d}/{len(a_snaps)}  ctx[{si:#x}] {op} ctx[{sj:#x}]")

if __name__ == "__main__":
    main()
