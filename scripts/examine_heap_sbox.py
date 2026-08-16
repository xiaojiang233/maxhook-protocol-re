#!/usr/bin/env python3
"""Examine the 256-byte permutation tables found in the dump heap. Determine if
they are cipher S-boxes (AES-like) or unrelated tables (Themida, etc.)."""
import glob
from pathlib import Path

def find_permutations(data, region_name):
    results = []
    for off in range(0, len(data) - 255, 1):
        w = data[off:off+256]
        if len(set(w)) == 256:
            results.append((off, w))
    return results

def main():
    # The 3 regions that had permutations
    regions = [
        r"E:\Coding\S1mple\target\dump_out\41264\region_000001efaad0b000.bin",
        r"E:\Coding\S1mple\target\dump_out\41264\region_000001efaae7f000.bin",
        r"E:\Coding\S1mple\target\dump_out\41264\region_000001efefd50000.bin",
    ]
    for r in regions:
        data = Path(r).read_bytes()
        perms = find_permutations(data, Path(r).name)
        print("=== %s (%d bytes, %d permutations) ===" % (Path(r).name, len(data), len(perms)))
        for off, w in perms[:3]:
            print("  offset 0x%x:" % off)
            # print first 32 bytes
            print("    first 32: %s" % w[:32].hex())
            # check if it's an AES S-box (first byte 0x63, or matches AES)
            aes_sbox = bytes.fromhex("637c777bf26b6fc53001672bfed7ab76ca82c97dfa5947f0add4a2af9ca472c0")
            if w[:16] == aes_sbox[:16]:
                print("    *** MATCHES AES S-box! ***")
            # check if it's the standard ChaCha/salsa or identity-based
            if w == bytes(range(256)):
                print("    identity permutation")
        print()

if __name__ == "__main__":
    main()
