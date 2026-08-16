#!/usr/bin/env python3
"""Verify the ARX round function against the actual state in vm_context_capture2.

We have:
  - known key 32206F9C... (constant across 10 calls)
  - 10 nonces
  - 10 ciphertexts -> 10 keystreams
  - 10 vm_enter_context (persistent VM state)

The keystream = F(key, nonce). The keystream byte at ctx[0xb5] (round 100) is the
fold output. Let me verify: for the 10 calls, does the keystream[0] relate to the
nonce in a way consistent with the ARX round function?

Actually, the most decisive test: compute keystream = plaintext XOR ciphertext for
all 10 calls, then verify the keystreams are all distinct (nonce-dependent) and
relate to the nonce via the ARX round.

Let me first extract all 10 keystreams and check their relationship to nonces.
"""
from pathlib import Path

P = Path(r"E:\Coding\S1mple\target\vm_context_capture2")

def main():
    key = sorted(P.glob("*call_1*input64*"))[0].read_bytes().decode()
    print("key:", key)

    # extract 10 (nonce, keystream) pairs
    for i in range(1, 11):
        nonce = bytes.fromhex(sorted(P.glob("*call_%d*nonce*" % i))[0].read_bytes().decode())
        pt = sorted(P.glob("*call_%d*plaintext*" % i))[0].read_bytes()
        ct = bytes.fromhex(sorted(P.glob("*call_%d*ciphertext*" % i))[0].read_bytes().decode())
        ks = bytes(a ^ b for a, b in zip(pt, ct))
        print("call %2d: nonce=%s keystream[0:8]=%s" % (i, nonce.hex(), ks[:8].hex()))

    # Check: is keystream[0] = nonce[0] XOR constant? (weak mixing test)
    print("\nkeystream[0] vs nonce[0]:")
    ks0 = []
    n0 = []
    for i in range(1, 11):
        nonce = bytes.fromhex(sorted(P.glob("*call_%d*nonce*" % i))[0].read_bytes().decode())
        pt = sorted(P.glob("*call_%d*plaintext*" % i))[0].read_bytes()
        ct = bytes.fromhex(sorted(P.glob("*call_%d*ciphertext*" % i))[0].read_bytes().decode())
        ks = bytes(a ^ b for a, b in zip(pt, ct))
        ks0.append(ks[0]); n0.append(nonce[0])
    xors = [a ^ b for a, b in zip(ks0, n0)]
    print("  ks[0]:", ["%02x" % x for x in ks0])
    print("  n[0] :", ["%02x" % x for x in n0])
    print("  XOR  :", ["%02x" % x for x in xors])
    print("  XOR all-same (weak additive)?", len(set(xors)) == 1)

if __name__ == "__main__":
    main()
