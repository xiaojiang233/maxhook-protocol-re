#!/usr/bin/env python3
"""Test whether the MaxHook keystream is AES-CTR (given the AES S-box was found
in the dump heap).  Use the writer_sync key + nonce and ground-truth keystream.

writer_sync: key=347230E63EEC999571342BE4417C430A6EBC3C82F27142361C1B5FEF02B4ACD9
             nonce=96e71401fc4f5faa040e5ca1 (12B)
             ground-truth block0 word0 = 0xdfa1e432
"""
import json
from pathlib import Path

def main():
    # ground-truth keystream
    d = json.load(open(r"E:\Coding\S1mple\target\writer_sync_clean_20260814_014351\analysis.json", encoding="utf-8"))
    call = next(c for c in d["calls"] if c["call_id"] == 1)
    block0 = bytes.fromhex(call["blocks"][0]["hex"])
    print("ground-truth block0 (64B):", block0.hex())
    print("block0 word0 (LE):", hex(int.from_bytes(block0[0:4], "little")))

    key = bytes.fromhex("347230E63EEC999571342BE4417C430A6EBC3C82F27142361C1B5FEF02B4ACD9")
    nonce = bytes.fromhex("96e71401fc4f5faa040e5ca1")
    print("key (%dB):" % len(key), key.hex())
    print("nonce (%dB):" % len(nonce), nonce.hex())

    # Try AES-256-CTR.  For AES-CTR, nonce is typically 12B nonce + 4B counter.
    # Check if pycryptodome is available
    try:
        from Crypto.Cipher import AES
        from Crypto.Util import Counter
        have_pycrypto = True
    except ImportError:
        have_pycrypto = False
    print("\npycryptodome available:", have_pycrypto)

    if have_pycrypto:
        # AES-256-CTR with 12-byte nonce + 4-byte counter (like AES-GCM style)
        ctr = Counter.new(128, initial_value=int.from_bytes(nonce + b"\x00\x00\x00\x00", "big"))
        cipher = AES.new(key, AES.MODE_CTR, counter=ctr)
        ks = cipher.encrypt(b"\x00" * 64)
        print("\nAES-256-CTR keystream (nonce+0 counter):", ks.hex())
        print("matches ground-truth block0?", ks == block0)

        # Try AES-256-CTR with nonce as-is (different counter layout)
        ctr2 = Counter.new(96, prefix=nonce)  # 12B nonce as prefix, 32-bit counter
        cipher2 = AES.new(key, AES.MODE_CTR, counter=ctr2)
        ks2 = cipher2.encrypt(b"\x00" * 64)
        print("AES-256-CTR (96-bit prefix nonce):", ks2.hex())
        print("matches?", ks2 == block0)

        # Try AES-256-ECB of the nonce (naive)
        cipher3 = AES.new(key, AES.MODE_ECB)
        ks3 = cipher3.encrypt(nonce + b"\x00" * 16)
        print("AES-256-ECB(nonce||0):", ks3.hex()[:64])
        print("matches first 32?", ks3[:32] == block0[:32])

if __name__ == "__main__":
    main()
