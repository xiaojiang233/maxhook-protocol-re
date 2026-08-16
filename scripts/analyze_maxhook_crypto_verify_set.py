"""Validate the local MaxHook crypto verification set without echoing secrets.

The verification set contains raw session material and complete ciphertexts.  This
tool deliberately writes only structural facts and truncated SHA-256 fingerprints
so that it can be used as a repeatable gate for a future VM emulator.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path
from typing import Any


SCHEMA = "maxhook.crypto.verify-set/v1"
HEX_RE = re.compile(r"^[0-9a-fA-F]*$")
EXPECTED_PLAINTEXT_KEYS = [
    "device_id",
    "h2_cantor",
    "nonce",
    "report_packet",
    "seq",
    "session_id",
    "sv",
    "timestamp",
]


def fingerprint(value: bytes | str) -> str:
    if isinstance(value, str):
        value = value.encode("utf-8")
    return hashlib.sha256(value).hexdigest()[:12]


def hex_bytes(value: Any, name: str, expected_chars: int | None = None) -> bytes:
    if not isinstance(value, str):
        raise ValueError(f"{name}: expected string")
    if expected_chars is not None and len(value) != expected_chars:
        raise ValueError(f"{name}: expected {expected_chars} hex characters, got {len(value)}")
    if len(value) % 2 or not HEX_RE.fullmatch(value):
        raise ValueError(f"{name}: invalid hex")
    return bytes.fromhex(value)


def validate_sample(sample: dict[str, Any], index: int) -> dict[str, Any]:
    required = {
        "call_id",
        "kid",
        "key_material_64hex",
        "plaintext",
        "nonce_24hex",
        "ciphertext_hex",
        "tag_32hex",
        "output_kid",
    }
    missing = sorted(required - set(sample))
    if missing:
        raise ValueError(f"sample {index}: missing {missing}")

    kid = hex_bytes(sample["kid"], "kid", 32)
    key_material = hex_bytes(sample["key_material_64hex"], "key_material_64hex", 64)
    nonce = hex_bytes(sample["nonce_24hex"], "nonce_24hex", 24)
    ciphertext = hex_bytes(sample["ciphertext_hex"], "ciphertext_hex")
    tag = hex_bytes(sample["tag_32hex"], "tag_32hex", 32)

    output_kid = sample["output_kid"]
    if not isinstance(output_kid, str) or output_kid.lower() != sample["kid"].lower():
        raise ValueError(f"sample {index}: output_kid differs from kid")

    plaintext = sample["plaintext"]
    if not isinstance(plaintext, str):
        raise ValueError(f"sample {index}: plaintext must be a UTF-8 string")
    plaintext_bytes = plaintext.encode("utf-8")
    if len(ciphertext) != len(plaintext_bytes):
        raise ValueError(
            f"sample {index}: ciphertext bytes {len(ciphertext)} != plaintext bytes {len(plaintext_bytes)}"
        )
    try:
        body = json.loads(plaintext)
    except json.JSONDecodeError as exc:
        raise ValueError(f"sample {index}: plaintext is not JSON: {exc}") from exc
    if not isinstance(body, dict):
        raise ValueError(f"sample {index}: plaintext JSON is not an object")
    if list(body) != EXPECTED_PLAINTEXT_KEYS:
        raise ValueError(f"sample {index}: unexpected plaintext key order")
    packet = hex_bytes(body.get("report_packet"), "report_packet")
    h2 = body.get("h2_cantor")
    if not isinstance(h2, str) or not re.fullmatch(r"v2:[0-9a-fA-F]{32}:[0-9a-fA-F]{64}", h2):
        raise ValueError(f"sample {index}: unexpected h2_cantor format")
    inner_nonce = body.get("nonce")
    if not isinstance(inner_nonce, str) or not re.fullmatch(r"[0-9a-fA-F]{32}", inner_nonce):
        raise ValueError(f"sample {index}: unexpected plaintext nonce format")
    if body.get("sv") != 3:
        raise ValueError(f"sample {index}: sv is not 3")
    if not isinstance(body.get("seq"), int) or not isinstance(body.get("timestamp"), int):
        raise ValueError(f"sample {index}: seq/timestamp types are invalid")

    return {
        "sample_index": index,
        "call_id": sample["call_id"],
        "kid_fingerprint_sha256_12": fingerprint(kid),
        "key_material_fingerprint_sha256_12": fingerprint(key_material),
        "plaintext_bytes": len(plaintext_bytes),
        "report_packet_bytes": len(packet),
        "ciphertext_bytes": len(ciphertext),
        "tag_bytes": len(tag),
        "outer_nonce_bytes": len(nonce),
        "inner_nonce_bytes": len(bytes.fromhex(inner_nonce)),
        "seq": body["seq"],
        "timestamp_type": type(body["timestamp"]).__name__,
        "device_id_fingerprint_sha256_12": fingerprint(body["device_id"]),
        "session_id_fingerprint_sha256_12": fingerprint(body["session_id"]),
        "h2_cantor_fingerprint_sha256_12": fingerprint(h2),
        "outer_nonce_fingerprint_sha256_12": fingerprint(nonce),
        "ciphertext_fingerprint_sha256_12": fingerprint(ciphertext),
        "tag_fingerprint_sha256_12": fingerprint(tag),
        "output_kid_equals_input_kid": True,
        "ciphertext_length_equals_plaintext": True,
        "inner_nonce_equals_outer_nonce": inner_nonce.lower() == sample["nonce_24hex"].lower(),
    }


def analyze(source: Path) -> dict[str, Any]:
    raw = json.loads(source.read_text("utf-8"))
    if raw.get("schema") != SCHEMA:
        raise ValueError(f"unexpected schema: {raw.get('schema')!r}")
    samples = raw.get("samples")
    if not isinstance(samples, list) or not samples:
        raise ValueError("samples must be a non-empty list")

    rows = [validate_sample(sample, index + 1) for index, sample in enumerate(samples)]
    def unique(field: str) -> list[str]:
        return sorted({str(row[field]) for row in rows})

    return {
        "schema": "maxhook.crypto.verify-set.analysis/v1",
        "source": str(source.resolve()),
        "source_sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
        "sensitive_values_omitted": True,
        "sample_count": len(rows),
        "samples": rows,
        "invariants": {
            "all_output_kid_equals_input_kid": all(row["output_kid_equals_input_kid"] for row in rows),
            "all_ciphertext_lengths_match_plaintext": all(row["ciphertext_length_equals_plaintext"] for row in rows),
            "all_plaintext_key_orders_match": True,
            "unique_kid_fingerprints": unique("kid_fingerprint_sha256_12"),
            "unique_key_material_fingerprints": unique("key_material_fingerprint_sha256_12"),
            "unique_device_id_fingerprints": unique("device_id_fingerprint_sha256_12"),
            "unique_session_id_fingerprints": unique("session_id_fingerprint_sha256_12"),
            "unique_outer_nonce_fingerprints": unique("outer_nonce_fingerprint_sha256_12"),
            "unique_ciphertext_fingerprints": unique("ciphertext_fingerprint_sha256_12"),
            "unique_tag_fingerprints": unique("tag_fingerprint_sha256_12"),
            "inner_nonce_equals_outer_nonce_count": sum(row["inner_nonce_equals_outer_nonce"] for row in rows),
            "seq_values": [row["seq"] for row in rows],
        },
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("source", nargs="?", type=Path, default=Path("target/crypto_verify_set.json"))
    parser.add_argument("-o", "--output", type=Path, default=Path("target/maxhook_crypto_verify_set_analysis.json"))
    args = parser.parse_args()
    report = analyze(args.source)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", "utf-8")
    print(json.dumps({
        "output": str(args.output.resolve()),
        "samples": report["sample_count"],
        "key_material_fingerprints": report["invariants"]["unique_key_material_fingerprints"],
        "all_lengths_valid": report["invariants"]["all_ciphertext_lengths_match_plaintext"],
    }, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
