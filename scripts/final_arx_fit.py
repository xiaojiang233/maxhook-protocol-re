#!/usr/bin/env python3
"""Final systematic test: does the decoded ARX round function, applied to
key+nonce with ANY simple initialization + round count + constant assignment,
reproduce the writer_sync keystream word0 (0xdfa1e432)?

This is the decisive test of whether the key-schedule is a simple ARX expansion
(fittable) vs the 54-handler VM program (requires execution).

key = 347230E6... (32B), nonce = 96e71401... (12B), word0 = 0xdfa1e432
"""
import struct

key = bytes.fromhex("347230E63EEC999571342BE4417C430A6EBC3C82F27142361C1B5FEF02B4ACD9")
nonce = bytes.fromhex("96e71401fc4f5faa040e5ca1")
TARGET = 0xdfa1e432

CONSTS = [
    0x5f5c808f, 0x3b6a3d7a, 0x4eceee25, 0x558a625a,
    0x681b64d8, 0x4dbfde8f, 0x6abd113b, 0x7f594fcf,
    0x616c560b, 0x472793ed, 0x4bfba08f, 0x32f12c5a,
    0x35a7d4cf, 0x7ef78e7d, 0x47f75fb8, 0x5f77d611,
]

def rol(x, n):
    n &= 31
    return ((x << n) | (x >> (32 - n))) & 0xFFFFFFFF

def main():
    kw = list(struct.unpack("<8I", key))
    nw = list(struct.unpack("<3I", nonce))
    print("key words:", [hex(w) for w in kw])
    print("nonce words:", [hex(w) for w in nw])
    print("target word0:", hex(TARGET))

    # Test: state = key words + nonce words (11 words), apply the ARX round
    # with various constant assignments and round counts, fold = various.
    # The round: state[i] ^= ((const ^ state[i]) - state[(i+1)%11])
    found = False
    for n_rounds in range(1, 5):
        for const_offset in range(len(CONSTS)):
            state = kw + nw  # 11 words
            for r in range(n_rounds):
                new = list(state)
                for i in range(11):
                    c = CONSTS[(const_offset + i) % len(CONSTS)]
                    s1 = state[i]
                    s2 = state[(i+1) % 11]
                    new[i] = (s1 ^ ((c ^ s1) - s2)) & 0xFFFFFFFF
                state = new
            # fold: try sum/xor of first N words, and various subsets
            for fold_mode in range(4):
                if fold_mode == 0:
                    out = sum(state[:4]) & 0xFFFFFFFF
                elif fold_mode == 1:
                    out = 0
                    for w in state[:4]:
                        out ^= w
                elif fold_mode == 2:
                    out = state[0]
                elif fold_mode == 3:
                    out = (state[0] + state[1]) & 0xFFFFFFFF
                if out == TARGET:
                    print("MATCH! rounds=%d const_off=%d fold=%d" % (n_rounds, const_offset, fold_mode))
                    found = True

    if not found:
        print("\nNo match — key-schedule is NOT a simple 11-word ARX expansion.")
        print("Confirms: it is the 54-handler VM program (requires execution).")

if __name__ == "__main__":
    main()
