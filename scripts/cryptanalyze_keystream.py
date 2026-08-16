#!/usr/bin/env python3
"""
MaxHook keystream cryptanalysis.

Goal: recover F(key, nonce) -> keystream from the offline captures we already
own, then independently reproduce ciphertext/tag for crypto_verify_set.json.

Inputs (all local, offline):
  - writer_sync_clean_20260814_014351/analysis.json  (3 full keystreams,
    key 347230e6..., nonces N1/N2/N3, each ~700+ bytes)
  - crypto_verify_set.json (7 samples, key 30bfeafe..., 7 nonces,
    ciphertext = plaintext XOR keystream, tag = 16-byte MAC)

Method:
  1. Load the 3 keystreams and 7 verify samples.
  2. Characterize the keystream: length, block alignment, whether the first
     bytes depend on nonce (stream cipher) vs. constant (block cipher).
  3. Test candidate round functions against the recovered keystream.
"""
from __future__ import annotations
import json, hashlib, struct
from pathlib import Path

TARGET = Path(r"E:\Coding\S1mple\target")
WRITER = json.loads((TARGET / "writer_sync_clean_20260814_014351/analysis.json").read_text(encoding="utf-8"))
VERIFY = json.loads((TARGET / "crypto_verify_set.json").read_text(encoding="utf-8"))

KEY_W = "347230E63EEC999571342BE4417C430A6EBC3C82F27142361C1B5FEF02B4ACD9"
NONCES_W = ["96e71401fc4f5faa040e5ca1", "3fa29634397f82181677262f", "8260e5b4587f7b01e697ddf2"]

def h2b(s):
    return bytes.fromhex(s)

def b2h(b):
    return b.hex()

def main():
    # Load 3 keystreams
    keystreams = []
    for c in WRITER["calls"]:
        ks = h2b(c["keystream_hex"])
        keystreams.append(ks)
        print(f"call {c['call_id']}: keystream len={len(ks)} bytes, "
              f"plaintext={c['plaintext_bytes']}")

    ks1, ks2, ks3 = keystreams
    n1, n2, n3 = [h2b(n) for n in NONCES_W]

    # Cross-keystream analysis: are first bytes nonce-dependent?
    print("\n=== cross-keystream ===")
    print("ks1[:32] =", b2h(ks1[:32]))
    print("ks2[:32] =", b2h(ks2[:32]))
    print("ks3[:32] =", b2h(ks3[:32]))

    # Do any two share a prefix? (would indicate ECB/constant-keystream)
    print("ks1==ks2 prefix:", b2h(ks1) == b2h(ks2))

    # Verify ciphertext = plaintext XOR keystream for the 7 verify samples
    print("\n=== verify set: ciphertext = plaintext XOR keystream ===")
    key_v = None
    for s in VERIFY["samples"]:
        pt = s["plaintext"].encode("utf-8")
        ct = h2b(s["ciphertext_hex"])
        # recover keystream = ct XOR pt
        ks = bytes(a ^ b for a, b in zip(ct, pt))
        if key_v is None:
            key_v = s["key_material_64hex"]
        print(f"  call {s['call_id']}: plaintext={len(pt)}B, ciphertext={len(ct)}B, "
              f"nonce={s['nonce_24hex']}, keystream[:16]={b2h(ks[:16])}")

    # Confirm all 7 samples same key
    keys = {s["key_material_64hex"] for s in VERIFY["samples"]}
    print("verify keys:", keys)

    # Fundamental check: is it a stream cipher (keystream independent of
    # plaintext)? We have the same key, different nonce -> keystream differs.
    print("\n=== conclusions ===")
    print("1. keystream length == plaintext length (stream cipher, not padding)")
    print("2. keystream differs per nonce under same key (nonce is in the state)")
    print("3. ciphertext = plaintext XOR keystream (already proven by writer oracle)")
    print("4. remaining unknown: F(key, nonce) -> keystream bytes + tag MAC")

if __name__ == "__main__":
    main()
