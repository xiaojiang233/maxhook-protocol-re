#!/usr/bin/env python3
"""With same key + 3 nonces established (round 114), analyze the nonce->keystream
relationship.  First, find where the nonce lives in the context, then check if
the 47 nonce-derived bytes correspond to the nonce directly or via a transform.

Also reconstruct the 3 nonces if possible: the plaintext JSON has a "nonce"
field (report nonce) but the ENCRYPTION nonce is the 12B output. The snapshot
'source' + 'keystream_byte' give ciphertext; but nonce is separate.

Key goal: determine if the 47 nonce-derived bytes = F(nonce) with a recognizable
structure (e.g., nonce XOR key, nonce as counter, etc.)"""
import json
from pathlib import Path

CAP = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")

def main():
    # Collect the 47 nonce-derived bytes across the 3 calls (from round 112's
    # list of small ranges).
    # From round 112: offsets +0x106, +0x180, +0x1a6, +0x1e9, +0x201, +0x23d,
    # +0x245, +0x265, +0x26d, +0x2da, +0x2e2, +0x217, +0x227, +0x22f, +0x259,
    # +0x286, +0x28e, +0x2a6, +0x2ef, +0x18a, +0x1dd...
    # Let me re-extract precisely: bytes that differ across calls AND are in
    # ranges <= 4 bytes.
    def load_first(call):
        for f in sorted(CAP.glob("*call_%s*.bin" % call)):
            d = json.loads(f.read_text(encoding="utf-8"))
            if d["xor_index"] == 0:
                return bytes.fromhex(d["context_hex"])
        return None
    c1, c2, c3 = load_first(1), load_first(2), load_first(3)

    # find small (<=4B) differing ranges
    diff = [i for i in range(768) if len({c1[i], c2[i], c3[i]}) > 1]
    ranges = []
    s = p = diff[0]
    for o in diff[1:]:
        if o == p + 1:
            p = o
        else:
            ranges.append((s, p)); s = p = o
    ranges.append((s, p))
    small = [(a, b) for a, b in ranges if b - a + 1 <= 4]

    print("nonce/position-derived small ranges (<=4B):")
    for a, b in small:
        v1 = int.from_bytes(c1[a:b+1], "little")
        v2 = int.from_bytes(c2[a:b+1], "little")
        v3 = int.from_bytes(c3[a:b+1], "little")
        print("  +0x%03x..+0x%03x: %08x | %08x | %08x" % (a, b, v1, v2, v3))

if __name__ == "__main__":
    main()
