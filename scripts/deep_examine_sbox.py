#!/usr/bin/env python3
"""Deep-examine the 4 non-AES permutation tables in region_000001efaad0b000.bin.
Determine if they are MaxHook cipher S-boxes by:
1. Checking if they're a known cipher's S-box (Salsa/ChaCha/ARIA/Camellia/SM4).
2. Checking their structure (4 consecutive 256-byte tables at 0x100 spacing =
   could be 4 8-bit S-boxes, or a 1024-byte table, or 4 rows of a larger S-box)."""
from pathlib import Path

REGION = Path(r"E:\Coding\S1mple\target\dump_out\41264\region_000001efaad0b000.bin")

# Known S-boxes for comparison (first 16 bytes)
KNOWN = {
    "AES": "637c777bf26b6fc53001672bfed7ab76",
    "AES_inv": "52096ad53036a538bf40a39e81f3d7fb",
    "SM4": "d690e9f9e095909dbb739a72d642d2b8",
    "Camellia": "7070708282c2c2eceef3f3a5a5b9b9",  # placeholder
    "ARIA_s1": "636c7777f2f26b6bc5c5303001016767",
}

def main():
    data = REGION.read_bytes()
    print("region size:", hex(len(data)))
    # the 4 tables at 0x8af80, 0x8b080, 0x8b180, 0x8b280 (spacing 0x100)
    for i, off in enumerate([0x8af80, 0x8b080, 0x8b180, 0x8b280]):
        w = data[off:off+256]
        print("\n=== table %d @ 0x%x ===" % (i, off))
        print("  first 16:", w[:16].hex())
        print("  last 16: ", w[-16:].hex())
        # check against known S-boxes
        for name, sbox in KNOWN.items():
            if w[:16].hex() == sbox:
                print("  *** matches", name, "***")
        # check if it's a linear/affine transform (S-box like structure)
        # check involution: sbox[sbox[x]] == x
        is_involution = all(w[w[x]] == x for x in range(256))
        print("  involution (sbox[sbox[x]]==x):", is_involution)

    # Are the 4 tables related? Check table[i+1] = table[i] shifted or transformed
    t0 = data[0x8af80:0x8b080]
    t1 = data[0x8b080:0x8b180]
    t2 = data[0x8b180:0x8b280]
    t3 = data[0x8b280:0x8b380]
    print("\n=== inter-table relationships ===")
    # is t1 = t0 XOR constant?
    xors = [t0[i] ^ t1[i] for i in range(256)]
    print("t0^t1 all-same-byte?", len(set(xors)) == 1, "(if so:", hex(xors[0]), ")")
    xors = [t1[i] ^ t2[i] for i in range(256)]
    print("t1^t2 all-same-byte?", len(set(xors)) == 1)
    xors = [t2[i] ^ t3[i] for i in range(256)]
    print("t2^t3 all-same-byte?", len(set(xors)) == 1)
    # is t1 = t0 composed with something? (t1[i] = t0[i] + c)
    adds = [(t1[i] - t0[i]) & 0xff for i in range(256)]
    print("t1-t0 all-same?", len(set(adds)) == 1)

if __name__ == "__main__":
    main()
