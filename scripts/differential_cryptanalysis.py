#!/usr/bin/env python3
"""Differential cryptanalysis of the MaxHook key-schedule using 3 keystreams
with the SAME key and 3 DIFFERENT nonces (writer_sync).

Hypotheses to test:
  H1: keystream word0 = f(key) XOR g(nonce)  (separable nonce)
  H2: state = key || nonce, then ARX rounds (ChaCha/Salsa-like init)
  H3: nonce mixed via a counter / simple add into the state
  H4: first keystream word = nonce-dependent XOR of key words

We have:
  key   = 347230E63EEC999571342BE4417C430A6EBC3C82F27142361C1B5FEF02B4ACD9 (32B)
  nonce1 = 96e71401fc4f5faa040e5ca1  -> word0 = 0xdfa1e432 (LE of 32e4a1df)
  nonce2 = 3fa29634397f82181677262f  -> word0 = 0x2ddcd8d5 (LE of d5d8dc2d)
  nonce3 = 8260e5b4587f7b01e697ddf2  -> word0 = 0x8261ee0c (LE of 0cee6182)
"""
from __future__ import annotations
import struct
import json
from pathlib import Path

T = Path(r"E:\Coding\S1mple\target")

def w32(b): return struct.unpack("<I", b[:4])[0]

KEY = bytes.fromhex("347230E63EEC999571342BE4417C430A6EBC3C82F27142361C1B5FEF02B4ACD9")
NONCES = [
    bytes.fromhex("96e71401fc4f5faa040e5ca1"),
    bytes.fromhex("3fa29634397f82181677262f"),
    bytes.fromhex("8260e5b4587f7b01e697ddf2"),
]
# keystream word0 (LE) for each nonce
KS0 = [0xdfa1e432, 0x2ddcd8d5, 0x8261ee0c]

# also full keystreams
a = json.loads((T/"writer_sync_clean_20260814_014351/analysis.json").read_text(encoding="utf-8"))
KS = [bytes.fromhex(c["keystream_hex"]) for c in a["calls"]]

def key_words(key):
    return [struct.unpack("<I", key[i:i+4])[0] for i in range(0, 32, 4)]

KW = key_words(KEY)

print("key words (LE):")
for i, w in enumerate(KW):
    print("  k[%d] = %#010x" % (i, w))

print("\nnonce words (first 3 LE words = 12B):")
for n in NONCES:
    print("  ", [hex(struct.unpack('<I', n[i:i+4])[0]) for i in range(0,12,4)])

print("\nkeystream word0 (LE):")
for i, ks in enumerate(KS0):
    print("  nonce%d -> %#010x" % (i+1, ks))

# H1: separable nonce.  Compute d = ks0[i] XOR ks0[j] and compare to nonce diffs
print("\n=== H1: separability test ===")
d_ks = [KS0[0] ^ KS0[1], KS0[0] ^ KS0[2], KS0[1] ^ KS0[2]]
print("keystream word0 diffs:", [hex(x) for x in d_ks])
# nonce word diffs
nw = [[struct.unpack('<I', n[i:i+4])[0] for i in range(0,12,4)] for n in NONCES]
for k in range(3):
    d = [nw[0][k] ^ nw[1][k], nw[0][k] ^ nw[2][k], nw[1][k] ^ nw[2][k]]
    print("nonce word%d diffs:" % k, [hex(x) for x in d])

# H2/H3: check if keystream word0 equals a simple combination of key+nonce words
print("\n=== H2/H3: simple state init ===")
for i, n in enumerate(NONCES):
    nw0 = struct.unpack('<I', n[0:4])[0]
    nw1 = struct.unpack('<I', n[4:8])[0]
    nw2 = struct.unpack('<I', n[8:12])[0]
    ks = KS0[i]
    # test: ks = k0 ^ n0, ks = k0 + n0, ks = k0 ^ n0 ^ n1 ^ n2, etc
    candidates = {
        "k0^n0": KW[0] ^ nw0,
        "k0+n0": (KW[0] + nw0) & 0xffffffff,
        "k0^n0^n1^n2": KW[0] ^ nw0 ^ nw1 ^ nw2,
        "k0+n0+n1+n2": (KW[0] + nw0 + nw1 + nw2) & 0xffffffff,
        "k0-k1^n0": (KW[0] - KW[1]) & 0xffffffff ^ nw0,
        "k7^n0": KW[7] ^ nw0,
        "k7+n0": (KW[7] + nw0) & 0xffffffff,
        "n0^n1^n2": nw0 ^ nw1 ^ nw2,
    }
    for name, cand in candidates.items():
        if cand == ks:
            print("  MATCH: nonce%d ks0 = %s" % (i+1, name))

# H4: check for a rolling counter / block counter in the keystream
print("\n=== keystream structure (per 64B block) ===")
ks1 = KS[0]
for b in range(min(3, len(ks1)//64)):
    block = ks1[b*64:(b+1)*64]
    w0 = struct.unpack("<I", block[0:4])[0]
    print("  block %d word0 = %#010x" % (b, w0))

# Check: is word0 of block1 = word0 of block0 after a simple transform (counter)?
print("\n=== block counter test ===")
for i in range(3):
    ks = KS[i]
    b0 = struct.unpack("<I", ks[0:4])[0]
    b1 = struct.unpack("<I", ks[64:68])[0] if len(ks) > 64 else None
    b2 = struct.unpack("<I", ks[128:132])[0] if len(ks) > 128 else None
    print("  nonce%d: blk0=%#010x blk1=%#010x blk2=%#010x" % (i+1, b0, b1 or 0, b2 or 0))
    if b1 is not None:
        print("    blk0^blk1 = %#010x, blk1^blk2 = %#010x" % (b0^b1, b1^b2 if b2 else 0))
