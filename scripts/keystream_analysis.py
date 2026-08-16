"""Cryptanalysis of the MaxHook stream cipher using the 7-sample verification set.

Same key (32 bytes), different nonce (12 bytes) per sample. Compute keystream =
plaintext XOR ciphertext, then hunt for structure: block size, counter mode,
nonce->state mapping, rolling-key-like linearity, etc.
"""

from __future__ import annotations

import json
import hashlib
from pathlib import Path

SRC = Path(r"E:\Coding\S1mple\target\crypto_verify_set.json")


def load():
    raw = json.loads(SRC.read_text("utf-8"))
    out = []
    for s in raw["samples"]:
        pt = s["plaintext"].encode("utf-8")
        ct = bytes.fromhex(s["ciphertext_hex"])
        key = bytes.fromhex(s["key_material_64hex"])
        nonce = bytes.fromhex(s["nonce_24hex"])
        tag = bytes.fromhex(s["tag_32hex"])
        assert len(pt) == len(ct), (len(pt), len(ct))
        ks = bytes(a ^ b for a, b in zip(pt, ct))
        out.append(dict(
            call_id=s["call_id"], key=key, nonce=nonce, tag=tag,
            pt=pt, ct=ct, ks=ks, n=len(pt),
        ))
    return out


def report(rows):
    print("=" * 70)
    print("KEYSTREAM BASIC STATS")
    print("=" * 70)
    key = rows[0]["key"]
    print(f"key (32B): {key.hex()}")
    print(f"key sha256: {hashlib.sha256(key).hexdigest()}")
    print()
    for r in rows:
        print(f"call {r['call_id']}: len={r['n']:4d}  nonce={r['nonce'].hex()}  "
              f"ks[:8]={r['ks'][:8].hex()}  tag={r['tag'].hex()}")

    print()
    print("=" * 70)
    print("1. NONCE DIFFERENCES vs KEYSTREAM PREFIX DIFFERENCES")
    print("=" * 70)
    # If keystream prefix = f(key, nonce), then similar nonces -> ?  Check if
    # nonce XOR directly feeds the first 12 bytes of keystream (a common design).
    for i, r in enumerate(rows):
        nonce_pad = r["nonce"] + b"\x00" * (16 - 12)
        # Try: ks[:12] XOR nonce -> should be constant across samples if nonce
        # is XORed directly into initial state as a 12-byte block.
        pre = r["ks"][:16]
        print(f"call {r['call_id']}: ks[:12]^nonce = {(bytes(a^b for a,b in zip(r['ks'][:12], r['nonce']))).hex()}")

    print()
    print("=" * 70)
    print("2. PAIRWISE KEYSTREAM PREFIX XOR (samples with common plaintext prefix)")
    print("=" * 70)
    # All plaintexts start with {"device_id":"E43A2C0F779F0DF2", so the keystream
    # prefix is observable directly.  Compare ks[i] across samples.
    # Look for: is there a stable offset where nonce enters?  Does the first N
    # bytes of keystream depend only on key (constant across samples)?
    for off in [0, 4, 8, 12, 16, 24, 32, 48, 64]:
        vals = [r["ks"][off:off+4].hex() for r in rows]
        unique = len(set(vals))
        print(f"ks[{off:3d}:{off+4:3d}]: {unique} unique -> {vals}")

    print()
    print("=" * 70)
    print("3. KEYSTREAM SELF-CORRELATION (period detection within one sample)")
    print("=" * 70)
    # Find the longest keystream sample, check for repeating blocks / period.
    longest = max(rows, key=lambda r: r["n"])
    ks = longest["ks"]
    for blk in [4, 8, 16, 32, 64]:
        # count distinct blocks
        blocks = [ks[i:i+blk] for i in range(0, len(ks) - blk + 1, blk)]
        distinct = len(set(blocks))
        print(f"block={blk:3d}: {len(blocks):4d} blocks, {distinct:4d} distinct "
              f"(dup={len(blocks)-distinct})")

    print()
    print("=" * 70)
    print("4. DIFFERENTIAL: nonce bit flip -> keystream prefix delta")
    print("=" * 70)
    # Single-bit nonce differences should produce avalanche if nonce goes through
    # a permutation.  If nonce is used directly (e.g., as counter seed), flipping
    # one nonce bit changes only a few keystream bytes predictably.
    for a in rows:
        for b in rows:
            if a is b:
                continue
            dn = bytes(x ^ y for x, y in zip(a["nonce"], b["nonce"]))
            # count differing bits in nonce
            ndiff = sum(bin(x).count("1") for x in dn)
            if ndiff == 1:
                bit = dn.hex()
                # where does keystream differ?
                dks = bytes(x ^ y for x, y in zip(a["ks"], b["ks"]))
                first_diff = next((i for i, c in enumerate(dks) if c), len(dks))
                ndks = sum(bin(x).count("1") for x in dks)
                print(f"nonce 1-bit diff ({bit}) calls {a['call_id']}vs{b['call_id']}: "
                      f"ks first diff @ {first_diff}, total ks bits differ={ndks}")

    print()
    print("=" * 70)
    print("5. KEYSTREAM BYTE VALUE DISTRIBUTION (entropy check)")
    print("=" * 70)
    from collections import Counter
    allks = b"".join(r["ks"] for r in rows)
    c = Counter(allks)
    import math
    # min/max byte counts
    mn, mx = min(c.values()), max(c.values())
    print(f"total ks bytes={len(allks)}, byte counts min={mn} max={mx}")
    # chi-square
    expected = len(allks) / 256
    chi2 = sum((v - expected) ** 2 / expected for v in c.values())
    print(f"chi2={chi2:.1f} (df=255, expect ~255 for uniform)")

    print()
    print("=" * 70)
    print("6. COUNTER-MODE TEST: does ks[i] look like E(key, nonce||counter_i)?")
    print("=" * 70)
    # In CTR mode, keystream block j = E(k, nonce || j).  If the same plaintext
    # position is encrypted in two samples, and nonce differs only in the counter
    # field, we'd see the keystream blocks relate.  Check first block.
    # More directly: test whether keystream is *independent of position* given
    # nonce (i.e., a pure PRF stream, not counter).  Hard without oracle.
    # Instead: check if ks XOR across two samples is constant in some window
    # (which would mean the counter contribution is additive/linear there).
    a, b = rows[0], rows[1]
    d = bytes(x ^ y for x, y in zip(a["ks"], b["ks"]))
    # look at 16-byte chunks of d
    for off in range(0, min(a["n"], b["n"]) - 16, 16):
        chunk = d[off:off+16]
        print(f"ks0^ks1[{off:4d}] = {chunk.hex()}")
        if off >= 64:
            break

    return rows


if __name__ == "__main__":
    rows = load()
    report(rows)
