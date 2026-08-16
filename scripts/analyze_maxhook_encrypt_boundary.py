#!/usr/bin/env python3
"""Offline analysis of MaxHook encrypt-boundary captures.

The report intentionally omits raw KIDs, session secrets, nonces, ciphertexts,
tags, and plaintext.  It validates each event against the SHA-256 recorded by
the capture tool, reconstructs separate hook sessions, and tests whether the
known plaintext/ciphertext pair matches common stream constructions.
"""

from __future__ import annotations

import argparse
import hashlib
import hmac
import json
import math
import re
from collections import defaultdict
from pathlib import Path
from typing import Iterable

from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives.kdf.hkdf import HKDF


FIELDS = (
    "input_input32",
    "input_input64",
    "input_plaintext_json",
    "output_kid_hex",
    "output_nonce_hex",
    "output_ciphertext_hex",
    "output_tag_hex",
)


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def decode_hex(data: bytes) -> bytes | None:
    try:
        return bytes.fromhex(data.decode("ascii"))
    except (UnicodeDecodeError, ValueError):
        return None


def entropy(data: bytes) -> float:
    if not data:
        return 0.0
    counts = defaultdict(int)
    for value in data:
        counts[value] += 1
    size = len(data)
    return -sum((count / size) * math.log2(count / size) for count in counts.values())


def string_format(value: str) -> str:
    if value.isdecimal():
        return f"decimal/{len(value)}"
    if re.fullmatch(r"[0-9a-fA-F]+", value):
        return f"hex/{len(value)}"
    return f"string/{len(value)}"


def load_sessions(root: Path) -> list[dict]:
    sessions: list[dict] = []
    current: dict | None = None
    for line_number, line in enumerate((root / "events.jsonl").read_text("utf-8").splitlines(), 1):
        event = json.loads(line)
        if event.get("kind") == "encrypt_hook_installed":
            current = {
                "root": root,
                "session_index": len(sessions),
                "installed_at": event.get("captured_at"),
                "calls": {},
            }
            sessions.append(current)
            continue
        if current is None or "call_id" not in event:
            continue
        call = current["calls"].setdefault(
            int(event["call_id"]), {"events": [], "files": {}, "meta_files": []}
        )
        call["events"].append(event)
        file_name = event.get("file")
        if not file_name:
            continue
        path = root / file_name
        data = path.read_bytes() if path.is_file() else None
        valid = data is not None and sha256(data) == event.get("sha256")
        item = {
            "kind": event.get("kind"),
            "file": file_name,
            "valid": valid,
            "data": data if valid else None,
            "sha256": event.get("sha256"),
            "line_number": line_number,
        }
        if event.get("kind") == "encrypt_string":
            key = f"{event.get('phase')}_{event.get('label')}"
            call["files"][key] = item
        elif event.get("kind") in {"builder_frame", "context_dump", "ctx_ptr0", "ctx_ptr1", "ctx_ptr2"}:
            call["meta_files"].append(item)
    return sessions


def call_data(call: dict) -> dict[str, bytes] | None:
    if not all(name in call["files"] and call["files"][name]["valid"] for name in FIELDS):
        return None
    return {name: call["files"][name]["data"] for name in FIELDS}


def aes_or_sm4_counter_block(key: bytes, nonce: bytes, counter: int, little: bool, sm4: bool) -> bytes:
    block = nonce + counter.to_bytes(4, "little" if little else "big")
    algorithm = algorithms.SM4(key) if sm4 else algorithms.AES(key)
    encryptor = Cipher(algorithm, modes.ECB()).encryptor()
    return encryptor.update(block)


def chacha20_block(key: bytes, nonce: bytes, counter: int) -> bytes:
    def rotl(v: int, n: int) -> int:
        return ((v << n) & 0xFFFFFFFF) | (v >> (32 - n))

    def qr(x: list[int], a: int, b: int, c: int, d: int) -> None:
        x[a] = (x[a] + x[b]) & 0xFFFFFFFF; x[d] ^= x[a]; x[d] = rotl(x[d], 16)
        x[c] = (x[c] + x[d]) & 0xFFFFFFFF; x[b] ^= x[c]; x[b] = rotl(x[b], 12)
        x[a] = (x[a] + x[b]) & 0xFFFFFFFF; x[d] ^= x[a]; x[d] = rotl(x[d], 8)
        x[c] = (x[c] + x[d]) & 0xFFFFFFFF; x[b] ^= x[c]; x[b] = rotl(x[b], 7)

    constants = b"expand 32-byte k"
    words = [int.from_bytes(constants[i:i + 4], "little") for i in range(0, 16, 4)]
    words += [int.from_bytes(key[i:i + 4], "little") for i in range(0, 32, 4)]
    words += [counter]
    words += [int.from_bytes(nonce[i:i + 4], "little") for i in range(0, 12, 4)]
    state = words[:]
    for _ in range(10):
        qr(state, 0, 4, 8, 12); qr(state, 1, 5, 9, 13)
        qr(state, 2, 6, 10, 14); qr(state, 3, 7, 11, 15)
        qr(state, 0, 5, 10, 15); qr(state, 1, 6, 11, 12)
        qr(state, 2, 7, 8, 13); qr(state, 3, 4, 9, 14)
    return b"".join(((a + b) & 0xFFFFFFFF).to_bytes(4, "little") for a, b in zip(state, words))


def matches_prefix(plaintext: bytes, ciphertext: bytes, stream: bytes) -> bool:
    size = min(64, len(plaintext), len(ciphertext), len(stream))
    return size >= 16 and bytes(a ^ b for a, b in zip(ciphertext[:size], stream[:size])) == plaintext[:size]


def test_key(label: str, key: bytes, plaintext: bytes, ciphertext: bytes, nonce: bytes) -> list[dict]:
    hits: list[dict] = []
    if len(nonce) != 12:
        return hits
    if len(key) in (16, 24, 32):
        for counter in (0, 1, 2, 3):
            for little in (False, True):
                stream = aes_or_sm4_counter_block(key, nonce, counter, little, False)
                if matches_prefix(plaintext, ciphertext, stream):
                    hits.append({"candidate": label, "primitive": "AES-counter", "counter": counter, "little_endian": little})
    if len(key) == 16:
        for counter in (0, 1, 2, 3):
            for little in (False, True):
                stream = aes_or_sm4_counter_block(key, nonce, counter, little, True)
                if matches_prefix(plaintext, ciphertext, stream):
                    hits.append({"candidate": label, "primitive": "SM4-counter", "counter": counter, "little_endian": little})
    if len(key) == 32:
        for counter in (0, 1, 2):
            if matches_prefix(plaintext, ciphertext, chacha20_block(key, nonce, counter)):
                hits.append({"candidate": label, "primitive": "ChaCha20-IETF", "counter": counter})
    return hits


def common_candidates(kid: bytes, secret: bytes) -> dict[str, bytes]:
    kid_hex = decode_hex(kid) or b""
    secret_hex = decode_hex(secret) or b""
    bases = {
        "secret.hex": secret_hex,
        "secret.ascii.first32": secret[:32],
        "secret.ascii.last32": secret[32:],
        "secret.ascii": secret,
        "kid.hex": kid_hex,
        "kid.ascii": kid,
    }
    out: dict[str, bytes] = {}
    for name, value in bases.items():
        if len(value) in (16, 24, 32):
            out[name] = value
        out[f"sha256({name})"] = hashlib.sha256(value).digest()
        out[f"sha512({name}).first32"] = hashlib.sha512(value).digest()[:32]
        out[f"sha512({name}).last32"] = hashlib.sha512(value).digest()[32:]
        out[f"md5({name})"] = hashlib.md5(value).digest()
        if value:
            out[f"reverse({name})"] = value[::-1]
    for sname, sval in (("secret.hex", secret_hex), ("secret.ascii", secret)):
        for kname, kval in (("kid.hex", kid_hex), ("kid.ascii", kid)):
            for separator_name, separator in (("", b""), ("colon", b":"), ("nul", b"\0")):
                for order_name, combined in (("secret+kid", sval + separator + kval), ("kid+secret", kval + separator + sval)):
                    prefix = f"{order_name}.{sname}.{kname}.{separator_name or 'none'}"
                    out[f"sha256({prefix})"] = hashlib.sha256(combined).digest()
                    out[f"md5({prefix})"] = hashlib.md5(combined).digest()
            out[f"hmac-sha256(key={sname},msg={kname})"] = hmac.new(sval, kval, hashlib.sha256).digest()
            out[f"hmac-sha256(key={kname},msg={sname})"] = hmac.new(kval, sval, hashlib.sha256).digest()
            for salt_name, salt in (("none", None), (kname, kval)):
                for info_name, info in (("empty", b""), (kname, kval), (sname, sval)):
                    label = f"hkdf-sha256(ikm={sname},salt={salt_name},info={info_name})"
                    out[label] = HKDF(algorithm=hashes.SHA256(), length=32, salt=salt, info=info).derive(sval)
            for iterations in (1, 1000, 4096, 10000):
                label = f"pbkdf2-sha256(password={sname},salt={kname},iterations={iterations})"
                out[label] = hashlib.pbkdf2_hmac("sha256", sval, kval, iterations, 32)
    return out


def sliding_candidates(items: Iterable[dict]) -> Iterable[tuple[str, bytes]]:
    for item in items:
        if not item.get("valid") or item.get("data") is None:
            continue
        data = item["data"]
        kind = item["kind"]
        for size in (16, 24, 32):
            for offset in range(0, len(data) - size + 1):
                yield f"{kind}+0x{offset:x}/len{size}", data[offset:offset + size]


def analyze(roots: list[Path]) -> dict:
    sessions = [session for root in roots for session in load_sessions(root)]
    valid_calls: list[tuple[dict, int, dict, dict[str, bytes]]] = []
    session_report = []
    for session in sessions:
        report = {
            "directory": str(session["root"].resolve()),
            "session_index": session["session_index"],
            "installed_at": session["installed_at"],
            "calls": [],
        }
        for call_id, call in sorted(session["calls"].items()):
            data = call_data(call)
            report["calls"].append({
                "call_id": call_id,
                "complete_and_hash_valid": data is not None,
                "valid_string_fields": sum(bool(call["files"].get(name, {}).get("valid")) for name in FIELDS),
                "meta_files_valid": sum(bool(item.get("valid")) for item in call["meta_files"]),
            })
            if data is not None:
                valid_calls.append((session, call_id, call, data))
        session_report.append(report)

    relation_rows = []
    plaintext_rows = []
    for session, call_id, _call, data in valid_calls:
        plaintext = data["input_plaintext_json"]
        ciphertext = decode_hex(data["output_ciphertext_hex"]) or b""
        relation_rows.append({
            "directory": session["root"].name,
            "session_index": session["session_index"],
            "call_id": call_id,
            "kid_equals_input32": data["input_input32"].lower() == data["output_kid_hex"].lower(),
            "plaintext_bytes": len(plaintext),
            "ciphertext_bytes": len(ciphertext),
            "ciphertext_length_equals_plaintext": len(ciphertext) == len(plaintext),
            "kid_fingerprint_sha256_12": sha256(data["output_kid_hex"].upper())[:12],
            "secret_fingerprint_sha256_12": sha256(data["input_input64"].upper())[:12],
        })
        try:
            body = json.loads(plaintext)
        except (UnicodeDecodeError, json.JSONDecodeError):
            body = None
        if isinstance(body, dict):
            packet_text = body.get("report_packet")
            packet = bytes.fromhex(packet_text) if isinstance(packet_text, str) and re.fullmatch(r"[0-9a-fA-F]*", packet_text) else b""
            plaintext_rows.append({
                "directory": session["root"].name,
                "session_index": session["session_index"],
                "call_id": call_id,
                "key_order": list(body.keys()),
                "field_formats": {
                    key: string_format(value) if isinstance(value, str) else type(value).__name__
                    for key, value in body.items()
                },
                "seq": body.get("seq"),
                "sv": body.get("sv"),
                "report_packet_decoded_bytes": len(packet),
                "report_packet_entropy_bits_per_byte": round(entropy(packet), 4),
                "inner_nonce_equals_outer_nonce": (
                    isinstance(body.get("nonce"), str)
                    and body["nonce"].lower() == data["output_nonce_hex"].decode("ascii").lower()
                ),
                "input64_equals_any_string_field": any(
                    isinstance(value, str) and value.lower() == data["input_input64"].decode("ascii").lower()
                    for value in body.values()
                ),
                "field_fingerprints_sha256_12": {
                    key: sha256(value.encode("utf-8"))[:12]
                    for key, value in body.items()
                    if isinstance(value, str) and key != "report_packet"
                },
            })

    crypto_tests = {"common_candidate_count": 0, "meta_sliding_candidate_count": 0, "hits": []}
    if valid_calls:
        session, call_id, call, data = valid_calls[-1]
        plaintext = data["input_plaintext_json"]
        ciphertext = decode_hex(data["output_ciphertext_hex"]) or b""
        nonce = decode_hex(data["output_nonce_hex"]) or b""
        candidates = common_candidates(data["input_input32"], data["input_input64"])
        crypto_tests["common_candidate_count"] = len(candidates)
        for label, key in candidates.items():
            crypto_tests["hits"].extend(test_key(label, key, plaintext, ciphertext, nonce))
        seen: set[bytes] = set()
        for label, key in sliding_candidates(call["meta_files"]):
            if key in seen:
                continue
            seen.add(key)
            crypto_tests["meta_sliding_candidate_count"] += 1
            crypto_tests["hits"].extend(test_key(label, key, plaintext, ciphertext, nonce))
        crypto_tests["tested_call"] = {
            "directory": session["root"].name,
            "session_index": session["session_index"],
            "call_id": call_id,
        }
        crypto_tests["interpretation"] = (
            "A hit identifies a matching first-block keystream independent of AEAD AAD/tag. "
            "No hit excludes only the enumerated direct/KDF/context candidates."
        )

    return {
        "schema": "maxhook.encrypt-boundary.analysis/v1",
        "sensitive_values_omitted": True,
        "source_directories": [str(root.resolve()) for root in roots],
        "sessions": session_report,
        "valid_call_count": len(valid_calls),
        "relations": relation_rows,
        "plaintext_protocol": plaintext_rows,
        "crypto_tests": crypto_tests,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("directories", nargs="*", type=Path, default=[
        Path("target/encrypt_boundary_capture"),
        Path("target/encrypt_boundary_capture2"),
    ])
    parser.add_argument("-o", "--output", type=Path, default=Path("target/maxhook_encrypt_boundary_analysis.json"))
    args = parser.parse_args()
    report = analyze(args.directories)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", "utf-8")
    print(json.dumps({
        "output": str(args.output.resolve()),
        "valid_calls": report["valid_call_count"],
        "common_candidates": report["crypto_tests"]["common_candidate_count"],
        "meta_sliding_candidates": report["crypto_tests"]["meta_sliding_candidate_count"],
        "hits": len(report["crypto_tests"]["hits"]),
    }, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
