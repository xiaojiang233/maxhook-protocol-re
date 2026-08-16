#!/usr/bin/env python3
"""Verify the state-slot constancy claims: which slots are IDENTICAL across all
3 calls (3 different keys) -> fixed constants, vs key-derived."""
import json
from pathlib import Path

CAP = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")

def load(call):
    out = []
    for f in sorted(CAP.glob("*call_%s*.bin" % call)):
        d = json.loads(f.read_text(encoding="utf-8"))
        out.append(bytes.fromhex(d["context_hex"]))
    return out

def main():
    c1, c2, c3 = load(1), load(2), load(3)
    slots = [0x0a, 0x1e, 0x45, 0x61, 0x6d, 0x85, 0xb5, 0xbd, 0xd9, 0xe5, 0xed, 0x106, 0x143, 0x14a, 0x235]
    print("slot | call1 | call2 | call3 | cross-call const?")
    for s in slots:
        # get value (first snapshot) for each call
        v1 = c1[0][s:s+8].hex() if s < len(c1[0]) else "?"
        v2 = c2[0][s:s+8].hex() if s < len(c2[0]) else "?"
        v3 = c3[0][s:s+8].hex() if s < len(c3[0]) else "?"
        # check constancy WITHIN each call (all snapshots same)
        def within(call):
            vals = {c[s:s+8] for c in call if s+8 <= len(c)}
            return len(vals) == 1
        w1, w2, w3 = within(c1), within(c2), within(c3)
        cross = (v1 == v2 == v3)
        print("0x%03x | %s | %s | %s | %s (within:%s%s%s)" % (
            s, v1, v2, v3, "YES" if cross else "no", w1, w2, w3))

    # specifically the 0x143 high-6-bytes
    print("\n0x143 high 6 bytes (fixed constant claim):")
    for call in (c1, c2, c3):
        base = call[0][0x143:0x149].hex()  # 6 bytes
        print("  ", base)

if __name__ == "__main__":
    main()
