#!/usr/bin/env python3
"""Test AES-CTR / AES-GCM hypotheses using the 'cryptography' library.
The 16-byte tag strongly suggests AES-GCM (12B nonce + 16B tag is the classic
AES-GCM layout).  Test against writer_sync ground-truth."""
import json
from pathlib import Path

def main():
    d = json.load(open(r"E:\Coding\S1mple\target\writer_sync_clean_20260814_014351\analysis.json", encoding="utf-8"))
    call = next(c for c in d["calls"] if c["call_id"] == 1)
    block0 = bytes.fromhex(call["blocks"][0]["hex"])
    print("ground-truth block0 word0:", hex(int.from_bytes(block0[0:4], "little")))

    key = bytes.fromhex("347230E63EEC999571342BE4417C430A6EBC3C82F27142361C1B5FEF02B4ACD9")
    nonce = bytes.fromhex("96e71401fc4f5faa040e5ca1")

    from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes

    # AES-256-CTR: 12-byte nonce as prefix, 4-byte counter
    ctr = modes.CTR(nonce + b"\x00\x00\x00\x00")
    cipher = Cipher(algorithms.AES(key), ctr)
    enc = cipher.encryptor()
    ks = enc.update(b"\x00" * 64)
    print("\nAES-256-CTR (nonce||counter=0) block0:", ks[:16].hex())
    print("  matches ground-truth?", ks == block0)
    print("  word0:", hex(int.from_bytes(ks[0:4], "little")), "expected 0xdfa1e432")

    # AES-256-CTR with counter starting at 1
    ctr1 = modes.CTR(nonce + b"\x00\x00\x00\x01")
    cipher1 = Cipher(algorithms.AES(key), ctr1)
    ks1 = cipher1.encryptor().update(b"\x00" * 64)
    print("AES-256-CTR (counter=1):", ks1[:16].hex(), "word0", hex(int.from_bytes(ks1[0:4],"little")))

    # AES-GCM (would produce tag, not raw keystream; but test its keystream = CTR with J0)
    # GCM keystream = AES-CTR with counter starting at 1 (J0 = nonce||00000001 for 96-bit nonce)
    # already tested above (counter=1)

    # AES-256-ECB on nonce
    ecb = modes.ECB()
    c2 = Cipher(algorithms.AES(key), ecb)
    e2 = c2.encryptor().update(nonce + b"\x00" * 16)
    print("AES-256-ECB(nonce||0):", e2[:16].hex(), "word0", hex(int.from_bytes(e2[0:4],"little")))

    # AES-256-CBC with nonce as IV
    cbc = modes.CBC(nonce + b"\x00" * 4)
    c3 = Cipher(algorithms.AES(key), cbc)
    e3 = c3.encryptor().update(b"\x00" * 32)
    print("AES-256-CBC(nonce IV):", e3[:16].hex(), "word0", hex(int.from_bytes(e3[0:4],"little")))

if __name__ == "__main__":
    main()
