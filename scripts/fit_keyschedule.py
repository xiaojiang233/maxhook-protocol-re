#!/usr/bin/env python3
"""Focused attempt: fit a simple word-oriented ARX key-schedule to the 10
(key, nonce -> keystream) pairs from vm_context_capture2.

Hypothesis: state = key words (8) + nonce words (3) + counter, then the ARX
round function produces keystream.  Test various simple initializations and
check against the 10 keystreams.

We have the ARX round: state1 ^= (const ^ state1) - state2.
Let me test the most natural constructions and see if ANY reproduces keystream.
"""
from pathlib import Path
import struct

P = Path(r"E:\Coding\S1mple\target\vm_context_capture2")

def load_pairs():
    pairs = []
    for i in range(1, 11):
        key = bytes.fromhex(sorted(P.glob("*call_%d*input64*" % i))[0].read_bytes().decode())
        nonce = bytes.fromhex(sorted(P.glob("*call_%d*nonce*" % i))[0].read_bytes().decode())
        pt = sorted(P.glob("*call_%d*plaintext*" % i))[0].read_bytes()
        ct = bytes.fromhex(sorted(P.glob("*call_%d*ciphertext*" % i))[0].read_bytes().decode())
        ks = bytes(a ^ b for a, b in zip(pt, ct))
        pairs.append((key, nonce, ks))
    return pairs

def rol(x, n):
    n &= 31
    return ((x << n) | (x >> (32 - n))) & 0xFFFFFFFF

def main():
    pairs = load_pairs()
    key, nonce, ks = pairs[0]
    print("key (%dB):" % len(key), key.hex())
    print("nonce (%dB):" % len(nonce), nonce.hex())
    print("keystream[0:16]:", ks[:16].hex())
    print("keystream word0 (LE):", hex(struct.unpack("<I", ks[0:4])[0]))

    # key words (8 x 32-bit LE)
    kw = list(struct.unpack("<8I", key))
    nw = list(struct.unpack("<3I", nonce))
    print("\nkey words:", [hex(w) for w in kw])
    print("nonce words:", [hex(w) for w in nw])

    # ground-truth keystream words (first 4)
    ks_words = list(struct.unpack("<4I", ks[0:16]))
    print("\nground-truth keystream words[0:4]:", [hex(w) for w in ks_words])

    # Test simple constructions: state = kw + nw + counter, apply ARX rounds
    # round: for i in range(11): state[i] ^= (const[i] ^ state[i]) - state[(i+1)%11]
    # Try a few constant sets (including the recovered ARX constants)
    CONSTS = [
        0x5f5c808f, 0x3b6a3d7a, 0x4eceee25, 0x558a625a,
        0x681b64d8, 0x4dbfde8f, 0x6abd113b, 0x7f594fcf,
        0x616c560b, 0x472793ed, 0x4bfba08f,
    ]
    # Try: state = key words + nonce words (11 words), 1 round, fold = sum
    state = kw + nw  # 11 words
    # apply round
    for r in range(1):
        for i in range(11):
            c = CONSTS[i % len(CONSTS)]
            s1 = state[i]
            s2 = state[(i+1) % 11]
            s1 ^= ((c ^ s1) - s2) & 0xFFFFFFFF
            state[i] = s1 & 0xFFFFFFFF
    # fold: sum or xor of first 4 words
    fold_sum = (state[0] + state[1] + state[2] + state[3]) & 0xFFFFFFFF
    fold_xor = state[0] ^ state[1] ^ state[2] ^ state[3]
    print("\nARX round result (sum):", hex(fold_sum), "vs gt", hex(ks_words[0]))
    print("ARX round result (xor):", hex(fold_xor), "vs gt", hex(ks_words[0]))

if __name__ == "__main__":
    main()
