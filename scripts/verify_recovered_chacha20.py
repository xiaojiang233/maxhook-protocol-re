#!/usr/bin/env python3
"""Verify the recovered MaxHook ciphertext algorithm against all local captures."""
from __future__ import annotations

import json
import re
from pathlib import Path

from maxhook_protocol_reference import encrypt_ciphertext

HERE = Path(__file__).resolve().parent


def _read_single(base: Path, pattern: str) -> bytes:
    matches = list(base.glob(pattern))
    if len(matches) != 1:
        raise RuntimeError(f"expected one {pattern!r} in {base}, found {len(matches)}")
    return matches[0].read_bytes()


def verify_json_set() -> tuple[int, int]:
    samples = json.loads((HERE / "crypto_verify_set.json").read_text("utf-8"))["samples"]
    matched = 0
    for sample in samples:
        key = bytes.fromhex(sample["key_material_64hex"])
        nonce = bytes.fromhex(sample["nonce_24hex"])
        plaintext = sample["plaintext"].encode("utf-8")
        expected = bytes.fromhex(sample["ciphertext_hex"])
        matched += encrypt_ciphertext(key, nonce, plaintext) == expected
    return matched, len(samples)


def capture_call_ids(base: Path) -> list[int]:
    ids = set()
    for path in base.glob("*_call_*_input_input64.bin"):
        match = re.search(r"_call_(\d+)_", path.name)
        if match:
            ids.add(int(match.group(1)))
    return sorted(ids)


def verify_capture_dir(base: Path) -> tuple[int, int]:
    matched = 0
    complete = 0
    for call_id in capture_call_ids(base):
        patterns = {
            "key": f"*_call_{call_id}_input_input64.bin",
            "plaintext": f"*_call_{call_id}_input_plaintext_json.bin",
            "nonce": f"*_call_{call_id}_output_nonce_hex.bin",
            "ciphertext": f"*_call_{call_id}_output_ciphertext_hex.bin",
        }
        if any(len(list(base.glob(pattern))) != 1 for pattern in patterns.values()):
            continue
        complete += 1
        key = bytes.fromhex(_read_single(base, patterns["key"]).decode("ascii"))
        plaintext = _read_single(base, patterns["plaintext"])
        nonce = bytes.fromhex(_read_single(base, patterns["nonce"]).decode("ascii"))
        expected = bytes.fromhex(_read_single(base, patterns["ciphertext"]).decode("ascii"))
        matched += encrypt_ciphertext(key, nonce, plaintext) == expected
    return matched, complete


def main() -> int:
    results = [("crypto_verify_set", *verify_json_set())]
    results.append(("vm_context_capture2", *verify_capture_dir(HERE / "vm_context_capture2")))
    writer_dirs = sorted(HERE.glob("writer_sync_clean_*"))
    if writer_dirs:
        results.append((writer_dirs[-1].name, *verify_capture_dir(writer_dirs[-1])))

    all_ok = True
    total_matches = total_vectors = 0
    for name, matched, total in results:
        print(f"{name}: {matched}/{total}")
        all_ok &= matched == total and total > 0
        total_matches += matched
        total_vectors += total
    print(f"TOTAL: {total_matches}/{total_vectors}")
    return 0 if all_ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
