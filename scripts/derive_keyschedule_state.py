#!/usr/bin/env python3
"""Derive the key-schedule: with known key + 10 nonces + 10 states, test whether
the nonce-derived state (+0x180..+0x1ef) is a simple function of the nonce.

Since the key is constant, state = F(nonce). Test simple hypotheses:
  state[i] = nonce[j] XOR C (byte-wise)
  state = nonce repeated / nonce-based counter
"""
from pathlib import Path

P = Path(r"E:\Coding\S1mple\target\vm_context_capture2")

def load_call(i):
    ctx = sorted(P.glob("*call_%d*vm_enter_context*" % i))[0].read_bytes()
    nonce = bytes.fromhex(sorted(P.glob("*call_%d*nonce*" % i))[0].read_bytes().decode())
    return nonce, ctx

def main():
    nonces, ctxs = [], []
    for i in range(1, 11):
        n, c = load_call(i)
        nonces.append(n)
        ctxs.append(c)

    # The nonce-derived state region (from round 145): +0x180..+0x1ef, +0x1a6, +0x1dd, +0x1e9, etc.
    # Focus on the high-entropy state: +0x180..+0x1ef (32 bytes)
    state_region = range(0x180, 0x1f0)

    # Extract the state bytes at these offsets for each nonce
    print("nonce -> state[+0x180..+0x18f] (16 bytes):")
    for i in range(10):
        st = ctxs[i][0x180:0x190]
        print("  %s -> %s" % (nonces[i].hex(), st.hex()))

    # Test: is state = nonce XOR constant? (byte-wise, for the first 12 bytes)
    # nonce is 12 bytes, state region is 32 bytes. Check if state[0:12] = nonce XOR C
    print("\nTest: state[0x180:0x18c] XOR nonce (should be constant if XOR relation):")
    for i in range(10):
        st = ctxs[i][0x180:0x18c]
        x = bytes(a ^ b for a, b in zip(st, nonces[i]))
        print("  %s" % x.hex())

    # Test: is state = nonce-based counter (state = nonce, or nonce rotated)?
    # Compare state[0x180:0x18c] with nonce directly
    print("\nTest: state[0x180:0x18c] == nonce (direct):")
    for i in range(10):
        st = ctxs[i][0x180:0x18c]
        print("  state=%s nonce=%s equal=%s" % (st.hex(), nonces[i].hex(), st == nonces[i]))

if __name__ == "__main__":
    main()
