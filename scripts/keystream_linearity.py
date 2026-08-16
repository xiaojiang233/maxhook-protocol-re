"""Final decisive cryptanalysis: keystream structure and nonce->state.

All 7 samples share key.  Test several falsifiable hypotheses about how
(32-byte key, 12-byte nonce) seed the keystream, using the fact that the
keystream prefix is directly observable (common plaintext prefix of 48 bytes).

Hypotheses:
 H1: keystream = E(key || nonce) streaming, counter independent of nonce.
     -> keystream[offset] for a fixed offset should be a function of nonce only
        (true, verified: all differ).  But we can test a stronger sub-claim:
 H2: Is there any LINEAR (GF(2)) relation among keystream bytes across the 7
     samples?  If the round function were affine in the nonce (e.g., keystream
     = key-schedule XOR nonce-derived LFSR), then the 7x7 byte-matrix over GF(2)
     would be rank-deficient.  A full-strength cipher gives full rank.
 H3: nonce enters via a 96->N expansion that is bijective (unlikely to test).
 H4: counter structure: does keystream depend on nonce ONLY through the first
     block (i.e., is keystream[n] = G(key, H(nonce), n) with H a per-nonce
     constant)?  Test: for each offset n, does the SET {ks_i[n] : i} look like
     it could be E(key, nonce_i) for a fixed n?  This is H1 again.

The most valuable NEW test is H2: build, for each byte position n (0..47 within
common prefix), a 7-row matrix M where row i = keystream byte bits of sample i
at offset n, and check the GF(2) rank of the 7x8 matrix (and across offsets).
If the cipher mixes nonce nonlinearly, each byte's 7 samples should span high
rank; but if nonce is XOR-ed linearly into the state, low rank.

Also test: H5 tag = keystream-derived (e.g., tag = E(key,nonce,counter=end)).
"""

from __future__ import annotations
import json
from pathlib import Path

SRC = Path(r"E:\Coding\S1mple\target\crypto_verify_set.json")


def gf2_rank(rows):
    """GF(2) rank of a list of ints (bit vectors)."""
    if not rows:
        return 0
    rows = list(rows)
    rank = 0
    ncols = max(x.bit_length() for x in rows)
    for col in range(ncols):
        pivot = None
        for r in range(rank, len(rows)):
            if (rows[r] >> col) & 1:
                pivot = r
                break
        if pivot is None:
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        for r in range(len(rows)):
            if r != rank and ((rows[r] >> col) & 1):
                rows[r] ^= rows[rank]
        rank += 1
    return rank


def main():
    raw = json.loads(SRC.read_text("utf-8"))
    samples = []
    for s in raw["samples"]:
        pt = s["plaintext"].encode("utf-8")
        ct = bytes.fromhex(s["ciphertext_hex"])
        nonce = bytes.fromhex(s["nonce_24hex"])
        key = bytes.fromhex(s["key_material_64hex"])
        ks = bytes(a ^ b for a, b in zip(pt, ct))
        samples.append(dict(key=key, nonce=nonce, ks=ks))

    print("=== H2: GF(2) rank of keystream bytes across 7 samples (per offset) ===")
    # For each byte offset in common prefix, collect the 8-bit values across 7
    # samples -> 7x8 bit matrix, compute rank.
    ncommon = 48
    ranks = []
    for off in range(ncommon):
        bits = [samples[i]["ks"][off] for i in range(7)]
        r = gf2_rank(bits)
        ranks.append(r)
    print(f"offsets 0..{ncommon-1}, rank of 7x8 matrix (max 7):")
    print(f"  rank values: {ranks}")
    print(f"  min={min(ranks)} max={max(ranks)}")

    # Also test across a wider matrix: all 7 samples x first 48 bytes flattened
    # (7 rows x 384 bits).  If rank << 7, strong linear structure.
    print("\n=== H2 extended: GF(2) rank of full 48-byte prefix per sample ===")
    full_rows = []
    for i in range(7):
        v = 0
        for off in range(ncommon):
            v |= samples[i]["ks"][off] << (8 * (ncommon - 1 - off))
        full_rows.append(v)
    r = gf2_rank(full_rows)
    print(f"  rank of 7x384 matrix = {r} (max 7)")

    print("\n=== H2b: rank of NONCE bits themselves (sanity: should be ~full) ===")
    nonce_bits = [int.from_bytes(samples[i]["nonce"], "big") for i in range(7)]
    print(f"  rank of 7x96 nonce matrix = {gf2_rank(nonce_bits)} (max 7)")

    print("\n=== H6: nonce difference matrix (do nonces span independent dirs?) ===")
    # pairwise nonce XOR
    for i in range(7):
        for j in range(i+1, 7):
            d = bytes(a ^ b for a, b in zip(samples[i]["nonce"], samples[j]["nonce"]))
            print(f"  nonce[{i}]^nonce[{j}] = {d.hex()}")

    print("\n=== H7: keystream vs nonce byte-wise XOR linearity test ===")
    # If ks[i] = f(key) ^ g(nonce, i) with g linear (XOR), then
    # ks_a[i] ^ ks_b[i] should equal g(nonce_a ^ nonce_b, i) independent of key.
    # With same key, check: is ks_a^ks_b a function ONLY of nonce_a^nonce_b?
    # We have 7 samples -> 21 pairs, 21 unique nonce-diffs (since rank 7).  Can't
    # falsify with only 21 points, but can check consistency: if g is linear and
    # position-independent (g(nonce, i) = g(nonce) shifted), then for a fixed
    # offset the map nonce-diff -> ks-diff should be a homomorphism.
    # Practical check: does ks_a^ks_b (full stream) equal ks_c^ks_d whenever
    # nonce_a^nonce_b == nonce_c^nonce_d?  Only testable if we have such a pair.
    diffs = {}
    for i in range(7):
        for j in range(i+1, 7):
            d = bytes(a ^ b for a, b in zip(samples[i]["nonce"], samples[j]["nonce"]))
            kd = bytes(a ^ b for a, b in zip(samples[i]["ks"], samples[j]["ks"]))
            key = d.hex()
            if key in diffs:
                print(f"  COLLISION on nonce-diff {key}: ks-diffs match? {diffs[key][:16].hex() == kd[:16].hex()}")
            else:
                diffs[key] = kd
    print(f"  {len(diffs)} unique nonce-diffs (no collisions to test)")

    print("\n=== H8: is tag a function of (key, nonce) only (not ciphertext)? ===")
    # Can't test directly without an oracle, but check if tag correlates with
    # keystream (e.g., tag = keystream bytes 0..15 of a different counter).
    for i in range(7):
        s = samples[i]
        tag = bytes.fromhex(raw["samples"][i]["tag_32hex"])
        # compare tag to keystream at various windows
        print(f"  sample {i}: tag={tag.hex()}")
        # check if tag equals any 16-byte keystream window
        ks = s["ks"]
        found = []
        for off in range(len(ks)-15):
            if ks[off:off+16] == tag:
                found.append(off)
        if found:
            print(f"    !! tag == ks[{found[0]}:{found[0]+16}]")


if __name__ == "__main__":
    main()
