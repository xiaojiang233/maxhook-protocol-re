#!/usr/bin/env python3
"""Evidence-based SHA-256 tag search using the counter-0 block as auth material.

New evidence motivating this search (not covered by the earlier blind HMAC/hash
searches, which never placed the ChaCha counter-0 block inside a SHA-256
message):
  * verify_writer_counter0.py proves the counter-0 block is generated ahead of
    the payload stream on every writer capture (authentication material).
  * The emulator observes a SHA-256 context init (112-byte heap context
    0x20000100180) reached right after the nonce is seeded, and the tag phase
    allocates a nonce buffer + SHA context + a 64-byte (one-ChaCha-block) buffer.

We test SHA-256 (and HMAC-SHA256/BLAKE2s) digests whose message is built from
derived_key / nonce / AAD / kid / ciphertext AND the counter-0 block.  A
candidate must match ALL 7 crypto_verify_set tags before it is reported.
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
SAMPLES = json.loads((HERE / "crypto_verify_set.json").read_text("utf-8"))["samples"]
AAD = DOMAIN_LABEL


def digest_forms(d: bytes) -> dict[str, bytes]:
    def swap4(x: bytes) -> bytes:
        return b"".join(x[i:i + 4][::-1] for i in range(0, len(x), 4))
    return {
        "first16": d[:16],
        "last16": d[16:],
        "reverse_first16": d[::-1][:16],
        "word_swap_first16": swap4(d)[:16],
        "xor_halves": bytes(a ^ b for a, b in zip(d[:16], d[16:])),
    }


def parts(s: dict) -> dict:
    key = bytes.fromhex(s["key_material_64hex"])
    kid = bytes.fromhex(s["kid"])
    nonce = bytes.fromhex(s["nonce_24hex"])
    ct = bytes.fromhex(s["ciphertext_hex"])
    derived = derive_domain_key(key)
    return {
        "derived": derived,
        "raw": key,
        "c0": chacha20_block(derived, 0, nonce),
        "c1": chacha20_block(derived, 1, nonce),
        "nonce": nonce,
        "aad": AAD,
        "kid": kid,
        "ct": ct,
        "kidhex": s["kid"].encode(),
        "noncehex": s["nonce_24hex"].encode(),
        "svb": b"\x03",
    }


def build_message(p: dict, names: tuple, sep: bytes, mode: str) -> bytes:
    vals = []
    for n in names:
        v = p[n]
        if mode == "plain":
            vals.append(v)
        elif mode == "len32le":
            vals.append(struct.pack("<I", len(v)) + v)
        elif mode == "len32be":
            vals.append(struct.pack(">I", len(v)) + v)
    return sep.join(vals)


def main() -> int:
    reps = {"nonce": ("nonce", "noncehex"), "kid": ("kid", "kidhex"),
            "ct": ("ct",), "aad": ("aad",), "c0": ("c0",), "c1": ("c1",)}
    orders = [
        ("c0", "nonce", "ct"), ("c0", "ct"), ("c0", "aad", "ct"),
        ("c0", "kid", "nonce", "ct"), ("c0", "aad", "kid", "nonce", "ct"),
        ("c0", "nonce"), ("c0", "aad"), ("c0", "ct", "nonce"),
        ("c0", "ct", "aad"), ("c1", "nonce", "ct"), ("c1", "ct"),
    ]
    keys = ("derived", "raw", "c0", "c1")
    p0 = parts(SAMPLES[0])
    wanted = bytes.fromhex(SAMPLES[0]["tag_32hex"])

    specs = []
    for order in orders:
        for choice in itertools.product(*[reps[f] for f in order]):
            for sep in (b"", b"|", b":", b"\0"):
                for mode in ("plain", "len32le", "len32be"):
                    specs.append((choice, sep, mode))
    print(f"message specs {len(specs)}", flush=True)

    def digests(key, msg):
        return {
            "sha256_key_pre": hashlib.sha256(key + msg).digest(),
            "sha256_msg_pre": hashlib.sha256(msg + key).digest(),
            "sha256_msg": hashlib.sha256(msg).digest(),
            "hmac_sha256": hmac.new(key, msg, hashlib.sha256).digest(),
            "blake2s_keyed": hashlib.blake2s(msg, key=key[:32]).digest(),
        }

    hits = []
    for kn in keys:
        key0 = p0[kn]
        for si, (names, sep, mode) in enumerate(specs):
            msg0 = build_message(p0, names, sep, mode)
            for dn, d in digests(key0, msg0).items():
                for fn, value in digest_forms(d).items():
                    if value == wanted:
                        hits.append((kn, names, sep, mode, dn, fn))
                        print("HIT sample0:", kn, names, sep, mode, dn, fn, flush=True)
            if si and si % 500 == 0:
                pass
    print(f"sample0 hits {len(hits)}", flush=True)

    verified = []
    for kn, names, sep, mode, dn, fn in hits:
        ok = True
        for s in SAMPLES:
            p = parts(s)
            key = p[kn]
            msg = build_message(p, names, sep, mode)
            d = digests(key, msg)[dn]
            if digest_forms(d)[fn] != bytes.fromhex(s["tag_32hex"]):
                ok = False
                break
        if ok:
            verified.append((kn, names, sep, mode, dn, fn))
            print("VERIFIED:", verified[-1], flush=True)
    print(f"verified {verified}")
    out = {
        "schema": "maxhook.sha256-counter0-tag-search/v1",
        "message_specs": len(specs),
        "keys": list(keys),
        "sample0_hits": hits,
        "verified_all_samples": verified,
    }
    (HERE / "sha256_counter0_tag_search_report.json").write_text(
        json.dumps(out, indent=2) + "\n", "utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
