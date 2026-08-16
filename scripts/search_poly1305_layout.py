#!/usr/bin/env python3
"""Offline search for MaxHook's 16-byte tag as a Poly1305 construction.

The ciphertext is now proven to be ChaCha20, so this enumerates plausible
one-time-key derivations and protocol/AAD layouts without changing live state.
"""
from __future__ import annotations

import hashlib
import hmac
import itertools
import json
import struct
from pathlib import Path

from cryptography.hazmat.primitives.poly1305 import Poly1305

from maxhook_protocol_reference import DOMAIN_LABEL, chacha20_block, derive_domain_key

HERE = Path(__file__).resolve().parent
SAMPLES = json.loads((HERE / "crypto_verify_set.json").read_text("utf-8"))["samples"]


def sample_parts(sample: dict) -> tuple[bytes, dict[str, bytes]]:
    raw_key = bytes.fromhex(sample["key_material_64hex"])
    plaintext = sample["plaintext"].encode("utf-8")
    ciphertext = bytes.fromhex(sample["ciphertext_hex"])
    nonce = bytes.fromhex(sample["nonce_24hex"])
    kid = bytes.fromhex(sample["kid"])
    return raw_key, {
        "domain": DOMAIN_LABEL,
        "v3": b"v3",
        "sv_ascii": b"3",
        "sv_u8": b"\x03",
        "sv_le32": struct.pack("<I", 3),
        "sv_be32": struct.pack(">I", 3),
        "kid": kid,
        "kid_hex_u": sample["kid"].encode("ascii"),
        "kid_hex_l": sample["kid"].lower().encode("ascii"),
        "nonce": nonce,
        "nonce_hex_l": sample["nonce_24hex"].encode("ascii"),
        "nonce_hex_u": sample["nonce_24hex"].upper().encode("ascii"),
        "ct": ciphertext,
        "ct_hex_l": sample["ciphertext_hex"].encode("ascii"),
        "ct_hex_u": sample["ciphertext_hex"].upper().encode("ascii"),
        "pt": plaintext,
        "pt_hex_l": plaintext.hex().encode("ascii"),
    }


def key_modes(sample: dict) -> dict[str, bytes]:
    raw_key, p = sample_parts(sample)
    nonce = p["nonce"]
    derived = derive_domain_key(raw_key)
    modes = {
        "raw_key": raw_key,
        "derived_key": derived,
        "hmac_raw_nonce": hmac.new(raw_key, nonce, hashlib.sha256).digest(),
        "hmac_derived_nonce": hmac.new(derived, nonce, hashlib.sha256).digest(),
        "hmac_raw_domain_nonce": hmac.new(raw_key, DOMAIN_LABEL + nonce, hashlib.sha256).digest(),
        "sha_raw_nonce": hashlib.sha256(raw_key + nonce).digest(),
        "sha_derived_nonce": hashlib.sha256(derived + nonce).digest(),
    }
    for base_name, base_key in (("derived", derived), ("raw", raw_key)):
        for counter in range(4):
            block = chacha20_block(base_key, counter, nonce)
            modes[f"chacha_{base_name}_c{counter}_lo"] = block[:32]
            modes[f"chacha_{base_name}_c{counter}_hi"] = block[32:]
    for label in (b"tag", b"mac", b"auth", b"poly1305", b"v3|tag", b"v3|mac"):
        modes[f"hmac_derived_{label!r}"] = hmac.new(derived, label + nonce, hashlib.sha256).digest()
        modes[f"hmac_raw_{label!r}"] = hmac.new(raw_key, label + nonce, hashlib.sha256).digest()
    return modes


def pad16(value: bytes) -> bytes:
    return value + bytes((-len(value)) % 16)


def sequence_specs() -> list[tuple[str, ...]]:
    specs = {
        ("ct",), ("pt",), ("nonce",),
        ("nonce", "ct"), ("nonce", "pt"),
        ("ct", "nonce"), ("pt", "nonce"),
        ("domain", "ct"), ("domain", "pt"),
        ("domain", "nonce", "ct"), ("domain", "nonce", "pt"),
        ("nonce", "domain", "ct"), ("nonce", "domain", "pt"),
        ("kid", "nonce", "ct"), ("kid", "nonce", "pt"),
        ("domain", "kid", "nonce", "ct"),
        ("domain", "kid", "nonce", "pt"),
    }
    # All envelope-field orders, with binary and textual representations.
    sv = ("sv_ascii", "sv_u8", "sv_le32", "sv_be32", "v3")
    kids = ("kid", "kid_hex_u", "kid_hex_l")
    nonces = ("nonce", "nonce_hex_l", "nonce_hex_u")
    payloads = ("ct", "ct_hex_l", "ct_hex_u", "pt", "pt_hex_l")
    for values in itertools.product(sv, kids, nonces, payloads):
        for order in itertools.permutations(values):
            specs.add(order)
            specs.add(("domain",) + order)
    return sorted(specs)


def encoded_messages(sample: dict):
    _, p = sample_parts(sample)
    seen: set[bytes] = set()
    for names in sequence_specs():
        values = [p[name] for name in names]
        for sep_name, sep in (("none", b""), ("pipe", b"|"), ("colon", b":"),
                              ("nul", b"\0"), ("comma", b","), ("newline", b"\n")):
            plain = sep.join(values)
            variants = [
                (f"{names}|sep={sep_name}|plain", plain),
                (f"{names}|sep={sep_name}|pad_final", pad16(plain)),
                (f"{names}|sep={sep_name}|pad_each", sep.join(pad16(v) for v in values)),
            ]
            for endian, fmt32, fmt64 in (("le", "<I", "<Q"), ("be", ">I", ">Q")):
                variants.extend([
                    (f"{names}|sep={sep_name}|len32_{endian}_prefix",
                     sep.join(struct.pack(fmt32, len(v)) + v for v in values)),
                    (f"{names}|sep={sep_name}|len64_{endian}_prefix",
                     sep.join(struct.pack(fmt64, len(v)) + v for v in values)),
                    (f"{names}|sep={sep_name}|len32_{endian}_suffix",
                     plain + b"".join(struct.pack(fmt32, len(v)) for v in values)),
                    (f"{names}|sep={sep_name}|len64_{endian}_suffix",
                     plain + b"".join(struct.pack(fmt64, len(v)) for v in values)),
                ])
            for name, message in variants:
                if message not in seen:
                    seen.add(message)
                    yield name, message

    # RFC 8439 two-field layouts for every plausible AAD and payload form.
    aad_names = ("domain", "kid", "kid_hex_u", "kid_hex_l", "v3",
                 "sv_ascii", "sv_u8", "domain_kid", "kid_domain", "empty")
    p = dict(p)
    p["domain_kid"] = p["domain"] + p["kid"]
    p["kid_domain"] = p["kid"] + p["domain"]
    p["empty"] = b""
    for aad_name in aad_names:
        for payload_name in ("ct", "ct_hex_l", "ct_hex_u", "pt", "pt_hex_l"):
            aad, payload = p[aad_name], p[payload_name]
            for endian, fmt in (("le", "<QQ"), ("be", ">QQ")):
                for bits in (False, True):
                    lengths = (len(aad) * (8 if bits else 1),
                               len(payload) * (8 if bits else 1))
                    message = pad16(aad) + pad16(payload) + struct.pack(fmt, *lengths)
                    name = f"rfc|aad={aad_name}|payload={payload_name}|{endian}|bits={bits}"
                    if message not in seen:
                        seen.add(message)
                        yield name, message


def tag_forms(tag: bytes) -> dict[str, bytes]:
    return {
        "identity": tag,
        "reverse": tag[::-1],
        "swap32": b"".join(tag[i:i + 4][::-1] for i in range(0, 16, 4)),
        "swap64": tag[0:8][::-1] + tag[8:16][::-1],
    }


def main() -> int:
    first = SAMPLES[0]
    target = bytes.fromhex(first["tag_32hex"])
    messages = list(encoded_messages(first))
    modes = key_modes(first)
    print(f"first-sample messages={len(messages)} key_modes={len(modes)} tests={len(messages)*len(modes)*4}")

    hits: list[tuple[str, str, str]] = []
    forms = tag_forms(target)
    for key_name, key in modes.items():
        for message_name, message in messages:
            produced = Poly1305.generate_tag(key, message)
            for form_name, wanted in forms.items():
                if produced == wanted:
                    hits.append((key_name, message_name, form_name))
                    print("FIRST HIT", hits[-1])

    verified = []
    for key_name, message_name, form_name in hits:
        ok = True
        for sample in SAMPLES:
            sample_messages = dict(encoded_messages(sample))
            key = key_modes(sample)[key_name]
            produced = Poly1305.generate_tag(key, sample_messages[message_name])
            wanted = tag_forms(bytes.fromhex(sample["tag_32hex"]))[form_name]
            if produced != wanted:
                ok = False
                break
        if ok:
            verified.append((key_name, message_name, form_name))
            print("VERIFIED ALL", verified[-1])

    report = {
        "schema": "maxhook.poly1305-layout-search/v1",
        "message_count": len(messages),
        "key_mode_count": len(modes),
        "first_sample_hits": hits,
        "verified_all_samples": verified,
    }
    (HERE / "poly1305_layout_search_report.json").write_text(
        json.dumps(report, indent=2) + "\n", "utf-8")
    print("verified", verified)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
