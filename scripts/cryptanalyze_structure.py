#!/usr/bin/env python3
"""
Deep keystream structure analysis for MaxHook.

Determine: word size, endianness, block boundaries, and whether the keystream
matches any recognizable ARX stream cipher construction.

We have 10 (key, nonce, keystream) tuples:
  - writer_sync: key 347230e6..., nonces N1/N2/N3, keystreams 745/1353/1127 B
  - verify:      key 30bfeafe..., 7 nonces, keystream = ct XOR pt

Tests:
  1. Word-level: view keystream as 16/32/64-bit LE/BE words; check if the
     sequence looks like a counter-mode (incrementing) vs. PRNG.
  2. Lagged correlation: does keystream[i] relate to keystream[i-k]?
  3. Known-construction matching against common stream ciphers.
"""
from __future__ import annotations
import json, struct, hashlib
from pathlib import Path
from collections import Counter

TARGET = Path(r"E:\Coding\S1mple\target")
WRITER = json.loads((TARGET / "writer_sync_clean_20260814_014351/analysis.json").read_text(encoding="utf-8"))
VERIFY = json.loads((TARGET / "crypto_verify_set.json").read_text(encoding="utf-8"))

def h2b(s): return bytes.fromhex(s)

def words(b, n, endian="little"):
    return [int.from_bytes(b[i:i+n], endian) for i in range(0, len(b)//n*n, n)]

def main():
    # Gather all (key, nonce, keystream) tuples
    samples = []
    for c in WRITER["calls"]:
        samples.append(("347230E63EEC999571342BE4417C430A6EBC3C82F27142361C1B5FEF02B4ACD9",
                        c["nonce_24hex"] if "nonce_24hex" in c else None,
                        h2b(c["keystream_hex"])))
    for s in VERIFY["samples"]:
        pt = s["plaintext"].encode("utf-8")
        ct = h2b(s["ciphertext_hex"])
        ks = bytes(a ^ b for a, b in zip(ct, pt))
        samples.append((s["key_material_64hex"], s["nonce_24hex"], ks))

    # writer nonces
    nonces_w = ["96e71401fc4f5faa040e5ca1", "3fa29634397f82181677262f", "8260e5b4587f7b01e697ddf2"]
    for i, c in enumerate(WRITER["calls"]):
        samples[i] = (samples[i][0], nonces_w[i], samples[i][2])

    print("=== word-size / structure analysis ===")
    for key, nonce, ks in samples[:3]:
        w32 = words(ks, 4)
        w16 = words(ks, 2)
        print(f"nonce={nonce} len={len(ks)}")
        print(f"  first 8 x 32-bit LE: {[hex(x) for x in w32[:8]]}")
        print(f"  first 8 x 16-bit LE: {[hex(x) for x in w16[:8]]}")

    # Check: is keystream[0..11] related to nonce[0..11]?
    print("\n=== nonce -> first keystream byte correlation ===")
    for key, nonce, ks in samples[:3]:
        nb = h2b(nonce)
        print(f"nonce={nonce}  ks[0:12]={ks[:12].hex()}")

    # Critical test: does the keystream have a fixed block size?
    # Check if keystream is aligned to 64-byte blocks (writer emits 64B blocks)
    print("\n=== 64-byte block alignment ===")
    ks1 = samples[0][2]
    print("ks1 total len:", len(ks1), "= 11 full 64B blocks +", len(ks1) % 64, "bytes")

    # Is there a repeating period? Check for repeated 64-byte blocks
    print("\n=== block repetition (period detection) ===")
    blocks = [ks1[i:i+64] for i in range(0, len(ks1)//64*64, 64)]
    seen = {}
    for i, blk in enumerate(blocks):
        if blk in seen:
            print(f"  block {i} == block {seen[blk]} (repeat!)")
        seen[blk] = i
    print(f"  unique blocks: {len(set(blocks))}/{len(blocks)}")

    # Endianness / word structure via difference analysis
    print("\n=== 32-bit word differences (first keystream, consecutive) ===")
    w32 = words(samples[0][2], 4)
    diffs = [(w32[i+1] - w32[i]) & 0xffffffff for i in range(len(w32)-1)]
    print("  first 8 diffs:", [hex(x) for x in diffs[:8]])

if __name__ == "__main__":
    main()
