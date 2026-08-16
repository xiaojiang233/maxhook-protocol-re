#!/usr/bin/env python3
"""Derive the fold dataflow: keystream byte = F(context slots, constants).
Since control flow is key-independent and we have 52 (context -> keystream byte)
pairs, test whether keystream byte is a simple ARX function of the visible
non-key-dependent slots (counters/offsets) OR the key-dependent state slots.

The keystream byte is at ctx[0xb5]. Test candidate expressions against the
oracle across all 52 snapshots (3 keys).
"""
import json
from pathlib import Path
from itertools import combinations

CAP = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")

# candidate slots (single bytes) that might feed the fold
# counters/offsets: 0x26 (block), 0xd9 (byteoff), 0x36, 0x14a
# key-derived state (high entropy, differs per key): 0xed, 0xe5, 0x106, 0x45, 0xbd, 0x61
SLOTS = [0x26, 0xd9, 0x36, 0x14a, 0xed, 0xe5, 0x106, 0x45, 0xbd, 0x61, 0x5d, 0x69, 0xa, 0x143, 0x1e]

def load_all():
    snaps = []
    for call in (1, 2, 3):
        for f in sorted(CAP.glob("*call_%s*.bin" % call)):
            d = json.loads(f.read_text(encoding="utf-8"))
            ctx = bytes.fromhex(d["context_hex"])
            snaps.append((d["keystream_byte"], ctx))
    return snaps

def main():
    snaps = load_all()
    print("total snapshots:", len(snaps))

    # First: is keystream byte == ctx[0xb5]? (should be, destination slot)
    ok = sum(1 for kb, ctx in snaps if ctx[0xb5] == kb)
    print("keystream == ctx[0xb5]:", ok, "/", len(snaps))

    # Test simple 1-slot and 2-slot ARX: kb = slot_a OP slot_b (or OP const)
    # For each slot, check if kb == slot (identity) — no
    # For 2-slot XOR/ADD across all snapshots:
    def test_expr(fn, name):
        hit = 0
        for kb, ctx in snaps:
            try:
                if (fn(ctx) & 0xff) == kb:
                    hit += 1
            except IndexError:
                pass
        return hit

    # single slot identity
    print("\nkeystream == ctx[slot] (identity) for candidate slots:")
    for s in SLOTS:
        h = sum(1 for kb, ctx in snaps if s < len(ctx) and ctx[s] == kb)
        print("  0x%03x: %d/%d" % (s, h, len(snaps)))

    # 2-slot XOR
    print("\nkeystream == ctx[a] ^ ctx[b] (2-slot XOR), top matches:")
    results = []
    for a, b in combinations(SLOTS, 2):
        h = 0
        for kb, ctx in snaps:
            if a < len(ctx) and b < len(ctx) and (ctx[a] ^ ctx[b]) == kb:
                h += 1
        if h > 0:
            results.append((h, a, b))
    results.sort(reverse=True)
    for h, a, b in results[:15]:
        print("  0x%03x ^ 0x%03x: %d/%d" % (a, b, h, len(snaps)))

    # 2-slot ADD
    print("\nkeystream == (ctx[a] + ctx[b]) & 0xff (2-slot ADD), top matches:")
    results = []
    for a, b in combinations(SLOTS, 2):
        h = 0
        for kb, ctx in snaps:
            if a < len(ctx) and b < len(ctx) and ((ctx[a] + ctx[b]) & 0xff) == kb:
                h += 1
        if h > 0:
            results.append((h, a, b))
    results.sort(reverse=True)
    for h, a, b in results[:15]:
        print("  0x%03x + 0x%03x: %d/%d" % (a, b, h, len(snaps)))

if __name__ == "__main__":
    main()
