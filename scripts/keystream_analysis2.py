"""Deeper structural analysis.

Key idea: all 7 plaintexts share a long common prefix:
  {"device_id":"E43A2C0F779F0DF2","h2_cantor":"v2:
then the h2 32-hex-char differs, then ":" then 64-hex differs, then:
  ...","nonce":"<32hex>","report_packet":"<hex>","seq":NN,...

So at each absolute byte offset, the plaintext byte is either:
  - identical across all 7 (the JSON skeleton), or
  - a hex digit (0-9a-f) that varies.

This means keystream at those offsets is directly observable (ks = pt^ct), and
we can study how keystream at a FIXED offset varies with nonce, with NO plaintext
confound.  This is effectively a chosen-plaintext oracle over 7 nonces.
"""

from __future__ import annotations
import json
from pathlib import Path
from collections import Counter

SRC = Path(r"E:\Coding\S1mple\target\crypto_verify_set.json")


def load():
    raw = json.loads(SRC.read_text("utf-8"))
    out = []
    for s in raw["samples"]:
        pt = s["plaintext"].encode("utf-8")
        ct = bytes.fromhex(s["ciphertext_hex"])
        key = bytes.fromhex(s["key_material_64hex"])
        nonce = bytes.fromhex(s["nonce_24hex"])
        ks = bytes(a ^ b for a, b in zip(pt, ct))
        tag = bytes.fromhex(s["tag_32hex"])
        out.append(dict(key=key, nonce=nonce, tag=tag, pt=pt, ct=ct, ks=ks))
    return out


def main():
    rows = load()
    # common prefix length: find min length where all plaintexts agree
    common = 0
    ref = rows[0]["pt"]
    for i in range(min(len(r["pt"]) for r in rows)):
        if all(r["pt"][i] == ref[i] for r in rows):
            common = i + 1
        else:
            break
    print(f"common plaintext prefix = {common} bytes")
    print(f"prefix: {ref[:common]!r}")
    print()

    # At each offset, classify: is plaintext byte constant across samples?
    # Build a table of (offset, pt_constant?, ks values across 7 samples)
    maxlen = min(r["pt"] for r in rows) if False else max(len(r["pt"]) for r in rows)

    # For offsets in the common prefix, keystream = observable.  Check whether
    # keystream at a fixed offset correlates with nonce in a simple way.
    print("=" * 70)
    print("A. Fixed-offset keystream vs nonce (within common prefix)")
    print("=" * 70)
    # Print keystream bytes 0..64 in columns per sample, to eyeball
    for off in range(0, 64):
        line = f"{off:3d}: " + " ".join(f"{r['ks'][off]:02x}" for r in rows)
        print(line)

    print()
    print("=" * 70)
    print("B. Does keystream[offset] depend on nonce positionally?")
    print("=" * 70)
    # Test hypothesis: keystream = E(key, nonce) || E(key, nonce+1) || ...
    # (CTR).  Then keystream[offset] for a given sample is a deterministic
    # function of (nonce, offset).  With 7 nonces we can test whether the SAME
    # nonce at different offsets shows a counter increment pattern.
    # We cannot directly test without the permutation, but we CAN test a weaker
    # hypothesis: keystream[offset] is independent of nonce for offset >= block.
    # Clearly false (all differ).  So nonce enters the whole stream, or a large
    # state is seeded by nonce.

    # Instead test: are there any two offsets o1,o2 where ks[o1] XOR ks[o2] is
    # CONSTANT across all 7 samples?  That would reveal a counter/positional
    # delta that is nonce-independent (i.e., stream is E(k, nonce, counter) with
    # additive counter, linear-ish).
    print("Searching offset pairs (o1,o2) with constant ks[o1]^ks[o2] across samples:")
    n = min(len(r["ks"]) for r in rows)
    hits = 0
    for o1 in range(n):
        for o2 in range(o1 + 1, n):
            vals = {r["ks"][o1] ^ r["ks"][o2] for r in rows}
            if len(vals) == 1:
                print(f"  ks[{o1}]^ks[{o2}] = {vals.pop():02x} (constant)")
                hits += 1
                if hits > 20:
                    print("  ...")
                    return
    if hits == 0:
        print("  none found -> keystream is not a simple additive counter over nonce")

    print()
    print("=" * 70)
    print("C. Tag relationship (is tag = MAC of ciphertext, or keystream tail?)")
    print("=" * 70)
    # If tag is independent of length-position (e.g., Poly1305-style), test whether
    # tag is a pure function of (key, nonce, ciphertext).  Can't test without oracle,
    # but check if tag correlates with keystream prefix (a weak AEAD might use
    # keystream-derived tag).
    for r in rows:
        print(f"call: tag={r['tag'].hex()}")

    print()
    print("=" * 70)
    print("D. h2_cantor position: does keystream change at the first plaintext diff?")
    print("=" * 70)
    # First differing plaintext byte is at offset 'common'.  Check keystream around
    # that boundary - if the cipher is a stream cipher (bytewise), keystream should
    # be smooth across it (no discontinuity).  If it's block CBC-like, there might
    # be structure at block boundaries.
    for r in rows:
        print(f"call {r['nonce'].hex()[:6]}: pt[{common-2}:{common+4}] = "
              f"{r['pt'][common-2:common+4]!r}  ks = {r['ks'][common-2:common+4].hex()}")


if __name__ == "__main__":
    main()
