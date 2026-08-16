#!/usr/bin/env python3
"""Comprehensive SHA-256/HMAC tag search against 20 fully-keyed verified samples.

Grounded in new evidence:
  * verify_writer_counter0.py proves the counter-0 ChaCha block is generated
    ahead of the payload stream (authentication material).
  * The emulator reaches a SHA-256 context init right after nonce seeding
    (SHA-256 IV words 6a09e667..5be0cd19 confirmed written), so the tag is a
    SHA-256-based MAC.
  * The tag phase allocates a nonce buffer + SHA context + one-64-byte (ChaCha
    block) buffer.

Unlike the earlier single/multi-sample blind searches, this harness requires a
candidate to match ALL 20 independently verified keyed samples (ciphertext
reproduced exactly), which gives far stronger discrimination. Message fields
include derived/raw key, nonce, ciphertext, AAD label, kid, and the counter-0
and counter-1 blocks, in every order with several separators and length-prefix
encodings, combined as SHA-256 / HMAC-SHA256 / keyed-BLAKE2s and truncated to
16 bytes via several forms.
"""
from __future__ import annotations

import hashlib
import hmac
import itertools
import json
import struct
from pathlib import Path

from maxhook_protocol_reference import DOMAIN_LABEL, chacha20_block, derive_domain_key

HERE = Path(__file__).resolve().parent
SAMPLES = json.loads((HERE / "tag_test_vectors.json").read_text("utf-8"))
AAD = DOMAIN_LABEL


def digest_forms(d: bytes) -> dict[str, bytes]:
    def swap4(x: bytes) -> bytes:
        return b"".join(x[i:i + 4][::-1] for i in range(0, len(x), 4))
    return {
        "first16": d[:16],
        "last16": d[16:],
        "rev_first16": d[::-1][:16],
        "swap4_first16": swap4(d)[:16],
        "xor_halves": bytes(a ^ b for a, b in zip(d[:16], d[16:])),
        "swap8_first16": b"".join(d[i:i + 8][::-1] for i in range(0, 16, 8)),
    }


def parts(s: dict) -> dict:
    key = bytes.fromhex(s["key"])
    nonce = bytes.fromhex(s["nonce"])
    ct = bytes.fromhex(s["ct"])
    derived = derive_domain_key(key)
    kid = bytes.fromhex(s["kid"]) if s.get("kid") else None
    return {
        "derived": derived,
        "raw": key,
        "nonce": nonce,
        "ct": ct,
        "aad": AAD,
        "kid": kid,
        "kidhex": s["kid"].encode() if s.get("kid") else None,
        "c0": chacha20_block(derived, 0, nonce),
        "c1": chacha20_block(derived, 1, nonce),
        "noncehex": s["nonce"].encode(),
        "svb": b"\x03",
    }


def build(p: dict, names: tuple, sep: bytes, mode: str) -> bytes:
    vals = []
    for n in names:
        v = p.get(n)
        if v is None:
            return None
        if mode == "plain":
            vals.append(v)
        elif mode == "len32le":
            vals.append(struct.pack("<I", len(v)) + v)
        elif mode == "len32be":
            vals.append(struct.pack(">I", len(v)) + v)
        elif mode == "len64le":
            vals.append(struct.pack("<Q", len(v)) + v)
        elif mode == "len64be":
            vals.append(struct.pack(">Q", len(v)) + v)
    return sep.join(vals)


def main() -> int:
    reps = {
        "derived": ("derived",), "raw": ("raw",),
        "nonce": ("nonce", "noncehex"), "ct": ("ct",), "aad": ("aad",),
        "kid": ("kid", "kidhex"), "c0": ("c0",), "c1": ("c1",),
    }
    # Focused orders: counter0 as auth material first, and standard MAC orders.
    orders = [
        ("c0", "ct"), ("c0", "nonce", "ct"), ("c0", "aad", "ct"),
        ("c0", "aad", "nonce", "ct"), ("c0", "kid", "nonce", "ct"),
        ("c0", "nonce"), ("c0", "aad"), ("c0", "ct", "nonce"),
        ("derived", "nonce", "ct"), ("derived", "ct"), ("derived", "aad", "ct"),
        ("derived", "nonce"), ("raw", "nonce", "ct"),
        ("aad", "nonce", "ct"), ("nonce", "ct"), ("kid", "nonce", "ct"),
        ("c1", "ct"), ("c1", "nonce", "ct"),
        ("derived", "c0", "ct"), ("derived", "c0", "nonce", "ct"),
        ("c0", "derived", "ct"), ("c0", "derived", "nonce", "ct"),
        ("c0", "aad", "kid", "nonce", "ct"),
        ("derived", "c0", "aad", "nonce", "ct"),
    ]
    keys = ("derived", "raw", "c0", "c1")
    specs = []
    for order in orders:
        for choice in itertools.product(*[reps[f] for f in order]):
            for sep in (b"", b"|", b":", b"\0", b"\n"):
                for mode in ("plain", "len32le", "len32be", "len64le", "len64be"):
                    specs.append((choice, sep, mode))
    print(f"samples {len(SAMPLES)} message specs {len(specs)}", flush=True)

    p0 = parts(SAMPLES[0])
    wanted = bytes.fromhex(SAMPLES[0]["tag"])

    def digests(key, msg):
        return {
            "sha256_key_pre": hashlib.sha256(key + msg).digest(),
            "sha256_msg_pre": hashlib.sha256(msg + key).digest(),
            "sha256_msg": hashlib.sha256(msg).digest(),
            "hmac_sha256": hmac.new(key, msg, hashlib.sha256).digest(),
            "blake2s_keyed": hashlib.blake2s(msg, key=key[:32]).digest(),
        }

    # Phase 1: find candidates matching sample 0.
    hits = []
    for kn in keys:
        key0 = p0[kn]
        for si, (names, sep, mode) in enumerate(specs):
            msg0 = build(p0, names, sep, mode)
            if msg0 is None:
                continue
            for dn, d in digests(key0, msg0).items():
                if d is None:
                    continue
                for fn, value in digest_forms(d).items():
                    if value == wanted:
                        hits.append((kn, names, sep, mode, dn, fn))
                        print("HIT sample0:", kn, names, sep, mode, dn, fn, flush=True)
            if si and si % 2000 == 0:
                print(f"  tested {si}...", flush=True)
    print(f"sample0 hits {len(hits)}", flush=True)

    # Phase 2: verify each hit against all samples.
    verified = []
    for kn, names, sep, mode, dn, fn in hits:
        ok = True
        for s in SAMPLES:
            p = parts(s)
            key = p[kn]
            msg = build(p, names, sep, mode)
            if msg is None:
                ok = False
                break
            d = digests(key, msg)[dn]
            if d is None or digest_forms(d)[fn] != bytes.fromhex(s["tag"]):
                ok = False
                break
        if ok:
            verified.append((kn, names, sep, mode, dn, fn))
            print("VERIFIED:", verified[-1], flush=True)
    print(f"verified {verified}")
    out = {
        "schema": "maxhook.sha256-tag-all-samples/v1",
        "samples": len(SAMPLES),
        "message_specs": len(specs),
        "keys": list(keys),
        "sample0_hits": hits,
        "verified_all_samples": verified,
    }
    (HERE / "sha256_tag_all_samples_report.json").write_text(
        json.dumps(out, indent=2) + "\n", "utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
