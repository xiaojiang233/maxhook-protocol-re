#!/usr/bin/env python3
"""
Differential cryptanalysis of the keystream across nonces (same key).

writer_sync has 3 keystreams under key 347230e6 with nonces N1/N2/N3.
XORing two keystreams eliminates key-dependent constants and reveals how the
nonce enters the keystream.

If keystream = G(key) XOR H(nonce) (additive nonce mixing), then
KS1 XOR KS2 = H(nonce1) XOR H(nonce2), independent of key.
"""
from __future__ import annotations
import json
from pathlib import Path

ANALYSIS = json.loads(Path(r"E:\Coding\S1mple\target\writer_sync_clean_20260814_014351\analysis.json").read_text(encoding="utf-8"))
NONCES = ["96e71401fc4f5faa040e5ca1", "3fa29634397f82181677262f", "8260e5b4587f7b01e697ddf2"]

def main():
    kss = [bytes.fromhex(c["keystream_hex"]) for c in ANALYSIS["calls"]]
    n1, n2, n3 = [bytes.fromhex(n) for n in NONCES]

    print("=== keystream XOR across nonces (same key) ===")
    # KS1 ^ KS2
    d12 = bytes(a ^ b for a, b in zip(kss[0], kss[1]))
    d13 = bytes(a ^ b for a, b in zip(kss[0], kss[2]))
    d23 = bytes(a ^ b for a, b in zip(kss[1], kss[2]))

    print("KS1 ^ KS2 first 16 bytes:", d12[:16].hex())
    print("KS1 ^ KS3 first 16 bytes:", d13[:16].hex())
    print("KS2 ^ KS3 first 16 bytes:", d23[:16].hex())

    # nonce XOR
    print("\nnonce XOR:")
    print("N1 ^ N2:", bytes(a^b for a,b in zip(n1,n2)).hex())
    print("N1 ^ N3:", bytes(a^b for a,b in zip(n1,n3)).hex())

    # Is keystream XOR related to nonce XOR? Check if first 12 bytes match
    print("\n=== does KS1^KS2 prefix match N1^N2? ===")
    n12 = bytes(a^b for a,b in zip(n1,n2))
    print("N1^N2:", n12.hex())
    print("KS1^KS2[:12]:", d12[:12].hex())
    print("match:", d12[:12] == n12)

    # Check if keystream differences are ALSO fully diffused (no simple structure)
    print("\n=== keystream diff entropy ===")
    import collections
    for name, d in [("KS1^KS2", d12), ("KS1^KS3", d13)]:
        # check byte distribution
        hist = collections.Counter(d[:64])
        print(f"{name}: distinct byte values in first 64 = {len(hist)}")

if __name__ == "__main__":
    main()
