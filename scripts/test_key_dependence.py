#!/usr/bin/env python3
"""Determine whether keystream_byte depends on the key (S-box) or only on
(counter, byte-offset).  Compare keystream bytes at the SAME (block_counter,
byte_offset) position ACROSS the 3 calls (which have different keys)."""
import json
from pathlib import Path

CAP = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")

def load(call):
    out = []
    for f in sorted(CAP.glob("*call_%s*.bin" % call)):
        d = json.loads(f.read_text(encoding="utf-8"))
        ctx = bytes.fromhex(d["context_hex"])
        # block counter = ctx[0x26], byte offset = ctx[0xd9]
        out.append({
            "xor": d["xor_index"],
            "kb": d["keystream_byte"],
            "block": ctx[0x26],        # block counter
            "byteoff": ctx[0xd9],      # byte offset within block
            "ctx": ctx,
        })
    return sorted(out, key=lambda x: x["xor"])

def main():
    c1, c2, c3 = load(1), load(2), load(3)
    # Build a map: (block, byteoff) -> kb for each call
    maps = []
    for snaps in (c1, c2, c3):
        m = {}
        for s in snaps:
            m[(s["block"], s["byteoff"])] = s["kb"]
        maps.append(m)

    # Find positions present in all 3 calls
    common = set(maps[0]) & set(maps[1]) & set(maps[2])
    print("positions (block,byteoff) common to all 3 calls:", len(common))
    same = 0
    diff = 0
    examples = []
    for pos in sorted(common):
        kbs = [m[pos] for m in maps]
        if len(set(kbs)) == 1:
            same += 1
        else:
            diff += 1
            if len(examples) < 12:
                examples.append((pos, kbs))
    print("SAME keystream byte across 3 keys: %d" % same)
    print("DIFFERENT keystream byte across 3 keys: %d" % diff)
    print("\nexamples of DIFFERENT (key-dependent) positions:")
    for pos, kbs in examples:
        print("  (block=%d, byteoff=0x%02x): %s" % (pos[0], pos[1], ["%02x" % k for k in kbs]))

    # Also check: within a single call, does keystream byte repeat at same byteoff?
    # (i.e., is there a position-dependent pattern independent of block?)
    print("\nkeystream bytes at byteoff=0x00 across blocks (call 1):")
    for s in c1:
        if s["byteoff"] == 0:
            print("  block=%d ks=%02x" % (s["block"], s["kb"]))

if __name__ == "__main__":
    main()
