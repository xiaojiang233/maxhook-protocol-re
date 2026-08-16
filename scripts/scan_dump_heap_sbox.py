#!/usr/bin/env python3
"""Scan the dump (pid 41264) heap regions for high-entropy S-box-like tables.
If the cipher S-box is session-independent (fixed seed at module init), it would
be present in the dump.  Scan the 0x5960... and 0x1ef... heap regions."""
import glob
import struct
from pathlib import Path

REGIONS = sorted(glob.glob(r"E:\Coding\S1mple\target\dump_out\41264\region_*.bin"))

def main():
    # Focus on heap regions (0x5960... and 0x1ef... and 0x800000000-range)
    heap_regions = [r for r in REGIONS
                    if "5960" in r or "1ef" in r or "600000000" in r or "800000000" in r]
    print("heap-ish regions:", len(heap_regions))

    found_perm = 0
    found_high_entropy = 0
    for r in heap_regions:
        data = Path(r).read_bytes()
        if len(data) < 256:
            continue
        # scan 256-byte windows (step 64) for permutation (256 distinct)
        for off in range(0, len(data) - 255, 64):
            w = data[off:off+256]
            d = len(set(w))
            if d == 256:
                print("  256-byte PERMUTATION at %s +0x%x" % (Path(r).name, off))
                found_perm += 1
                if found_perm >= 20:
                    break
            elif d >= 200:
                found_high_entropy += 1
        if found_perm >= 20:
            break

    print("\n256-byte permutations found in heap:", found_perm)
    print("high-entropy (>=200 distinct/256B) windows:", found_high_entropy)

if __name__ == "__main__":
    main()
