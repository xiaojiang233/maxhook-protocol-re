#!/usr/bin/env python3
"""
Test the hypothesis: keystream[0..k] is a low-diffusion transformation of
nonce[0..k] (i.e., the state is seeded directly from the nonce, and the first
few output words leak nonce bits before the ARX rounds fully diffuse).

Observed: for nonce 8260e5b4587f7b01e697ddf2, ks[0:2]=0x8261 == 0x8260 + 1.
"""
from __future__ import annotations
import json, struct
from pathlib import Path

TARGET = Path(r"E:\Coding\S1mple\target")
WRITER = json.loads((TARGET / "writer_sync_clean_20260814_014351/analysis.json").read_text(encoding="utf-8"))
VERIFY = json.loads((TARGET / "crypto_verify_set.json").read_text(encoding="utf-8"))

def h2b(s): return bytes.fromhex(s)

def main():
    samples = []
    nonces_w = ["96e71401fc4f5faa040e5ca1", "3fa29634397f82181677262f", "8260e5b4587f7b01e697ddf2"]
    for i, c in enumerate(WRITER["calls"]):
        samples.append((h2b(nonces_w[i]), h2b(c["keystream_hex"])))
    for s in VERIFY["samples"]:
        pt = s["plaintext"].encode("utf-8")
        ct = h2b(s["ciphertext_hex"])
        ks = bytes(a ^ b for a, b in zip(ct, pt))
        samples.append((h2b(s["nonce_24hex"]), ks))

    print("=== nonce vs first keystream bytes (byte-level XOR diff) ===")
    for nb, ks in samples:
        diff = bytes(a ^ b for a, b in zip(nb, ks[:12]))
        add = bytes((ks[i] - nb[i]) & 0xff for i in range(12))
        print(f"nonce={nb.hex()}")
        print(f"  ks[:12]   ={ks[:12].hex()}")
        print(f"  ks^nonce  ={diff.hex()}")
        print(f"  ks-nonce  ={add.hex()} (mod 256)")

    # 16-bit word analysis: is ks[i:i+2] ~ nonce[i:i+2] + small delta?
    print("\n=== 16-bit word deltas (ks word - nonce word, LE) ===")
    for nb, ks in samples:
        deltas = []
        for i in range(0, 12, 2):
            nw = int.from_bytes(nb[i:i+2], "little")
            kw = int.from_bytes(ks[i:i+2], "little")
            deltas.append((kw - nw) & 0xffff)
        print(f"  nonce={nb.hex()[:12]}... deltas={[hex(d) for d in deltas]}")

if __name__ == "__main__":
    main()
