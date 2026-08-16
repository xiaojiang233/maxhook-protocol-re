#!/usr/bin/env python3
"""Verify ciphertext reproduction across all fully-keyed real MaxHook samples.

Each sample carries a real captured (key, nonce, ciphertext, tag).  This script
proves the recovered ChaCha20 stream cipher (HMAC-SHA256 domain KDF + IETF
ChaCha20 counter=1..N) reproduces the ciphertext for all samples — more than the
24-vector local requirement.  The 16-byte tag construction remains unrecovered;
mac_tag() stays fail-closed.
"""
from __future__ import annotations

import json
from pathlib import Path

from maxhook_protocol_reference import encrypt_ciphertext

HERE = Path(__file__).resolve().parent
SAMPLES = json.loads((HERE / "tag_test_vectors.json").read_text("utf-8"))


def main() -> int:
    ok = 0
    for s in SAMPLES:
        try:
            pt = s["pt"].encode("utf-8")
        except Exception:
            pt = s["pt"]
        repro = encrypt_ciphertext(
            bytes.fromhex(s["key"]), bytes.fromhex(s["nonce"]), pt)
        match = repro == bytes.fromhex(s["ct"])
        ok += match
        print(f"{s['src']:35s} call={s['call']:<3} ciphertext_ok={match}")
    print(f"\nTOTAL ciphertext reproduction: {ok}/{len(SAMPLES)}")
    print("(tag construction remains unrecovered; mac_tag() is fail-closed)")
    return 0 if ok == len(SAMPLES) else 1


if __name__ == "__main__":
    raise SystemExit(main())
