#!/usr/bin/env python3
"""Correlate the keystream byte (ctx[0xb5]) with the 105 key-derived state bytes,
to find the fold.  The keystream byte changes per-block, the key state is
constant per-call.  Test whether keystream byte = f(key_state, counter)."""
from __future__ import annotations
import json, glob
from pathlib import Path

CAP = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")

# The key-derived state offsets (from round 44)
KEY_STATE_OFFSETS = [
    0x045, 0x046, 0x047, 0x048, 0x049, 0x106, 0x107, 0x126, 0x127, 0x128, 0x129, 0x12a,
    0x142, 0x143, 0x144, 0x145, 0x146, 0x147, 0x148, 0x149, 0x180, 0x181, 0x18a, 0x18b,
    0x1a6, 0x1a7, 0x1a8, 0x1a9, 0x1e9, 0x1ea, 0x1eb, 0x1ec, 0x1ed, 0x1ee, 0x1ef,
    0x201, 0x202, 0x203, 0x204, 0x245, 0x246, 0x26d, 0x26e, 0x26f, 0x2da, 0x2db, 0x2ef,
]

def load(call):
    snaps = []
    for f in sorted(CAP.glob(f"*call_{call}*.bin")):
        d = json.loads(f.read_text(encoding="utf-8"))
        snaps.append((d["xor_index"], d["keystream_byte"], bytes.fromhex(d["context_hex"])))
    snaps.sort()
    return snaps

def main():
    for call in (1, 2, 3):
        snaps = load(call)
        print(f"\n=== call {call} ({len(snaps)} snapshots) ===")
        print("keystream bytes:", [f"{kb:02x}" for _, kb, _ in snaps])
        # counter slot 0x26 (block counter) and 0xd9 (byte offset)
        print("block counter (0x26):", [ctx[0x26] for _, _, ctx in snaps])
        # Is keystream byte XOR key_state byte a function of counter?
        # Try: for each key_state offset, check if (ks_byte ^ state[off]) has a
        # pattern related to counter.
        for off in KEY_STATE_OFFSETS[:8]:
            vals = [kb ^ ctx[off] for _, kb, ctx in snaps if off < len(ctx)]
            print(f"  ks ^ state[{off:#x}]: {[f'{v:02x}' for v in vals]}")

if __name__ == "__main__":
    main()
