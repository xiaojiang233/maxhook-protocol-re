#!/usr/bin/env python3
"""Test the ChaCha-like hypothesis: is the keystream a ChaCha20-style output
with the custom constants we found (0x32f12c5a, 0x35a7d4cf, etc.)?"""
from __future__ import annotations
import struct, json
from pathlib import Path

def rol(x, n): return ((x << n) | (x >> (32 - n))) & 0xffffffff

def quarter_round(a, b, c, d):
    a = (a + b) & 0xffffffff; d = rol(d ^ a, 16)
    c = (c + d) & 0xffffffff; b = rol(b ^ c, 12)
    a = (a + b) & 0xffffffff; d = rol(d ^ a, 8)
    c = (c + d) & 0xffffffff; b = rol(b ^ c, 7)
    return a, b, c, d

def main():
    analysis = json.loads(Path(r"E:\Coding\S1mple\target\writer_sync_clean_20260814_014351\analysis.json").read_text(encoding="utf-8"))
    block0 = bytes.fromhex(analysis["calls"][0]["blocks"][0]["hex"])
    oracle_words = [struct.unpack("<I", block0[i:i+4])[0] for i in range(0, 64, 4)]
    key = bytes.fromhex("347230E63EEC999571342BE4417C430A6EBC3C82F27142361C1B5FEF02B4ACD9")
    nonce = bytes.fromhex("96e71401fc4f5faa040e5ca1")

    print("oracle first 4 words:", [hex(w) for w in oracle_words[:4]])

    # Try various constant sets and layouts
    const_sets = [
        [0x32f12c5a, 0x35a7d4cf, 0x7ef78e7d, 0x47f75fb8],
        [0x61707865, 0x3320646e, 0x79622d32, 0x6b206574],  # standard "expand 32-byte k"
    ]
    for consts in const_sets:
        # ChaCha state: 4 const + 8 key + 1 counter + 3 nonce (12 bytes = 3 words)
        st = list(consts)
        key_words = [struct.unpack("<I", key[i*4:i*4+4])[0] for i in range(8)]
        st += key_words
        n0 = struct.unpack("<I", nonce[0:4])[0]
        n1 = struct.unpack("<I", nonce[4:8])[0]
        n2 = struct.unpack("<I", nonce[8:12])[0]
        st += [0, n0, n1, n2]  # counter=0, then 3 nonce words
        orig = list(st)
        for _ in range(10):
            st[0],st[4],st[8],st[12] = quarter_round(st[0],st[4],st[8],st[12])
            st[1],st[5],st[9],st[13] = quarter_round(st[1],st[5],st[9],st[13])
            st[2],st[6],st[10],st[14] = quarter_round(st[2],st[6],st[10],st[14])
            st[3],st[7],st[11],st[15] = quarter_round(st[3],st[7],st[11],st[15])
        out0 = (st[0] + orig[0]) & 0xffffffff
        print(f"consts={[hex(c) for c in consts]}: ChaCha word0={out0:#010x} vs oracle {oracle_words[0]:#010x}")

if __name__ == "__main__":
    main()
