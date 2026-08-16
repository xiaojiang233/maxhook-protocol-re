#!/usr/bin/env python3
"""Scan an offline process dump for bounded 64-hex strings and test AEAD keys.

This follows the native call-boundary observation that the protected envelope
builder receives a live 64-character std::string.  Raw candidates are not
written unless one authenticates a captured envelope.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import time
from collections import Counter
from pathlib import Path

from cryptography.hazmat.primitives.ciphers.aead import AESCCM, AESGCM, ChaCha20Poly1305

try:
    from cryptography.hazmat.primitives.ciphers.aead import AESGCMSIV
except ImportError:
    AESGCMSIV = None


HEX = b"0123456789abcdefABCDEF"
HEX_SET = set(HEX)
HEX64 = re.compile(rb"[0-9A-Fa-f]{64}")


def bounded_matches(path: Path, chunk_size: int = 8 * 1024 * 1024):
    """Yield (offset, value) without trusting artificial chunk boundaries."""
    overlap = b""
    position = 0
    with path.open("rb") as stream:
        while True:
            chunk = stream.read(chunk_size)
            eof = not chunk
            if eof:
                break
            data = overlap + chunk
            base = position - len(overlap)
            next_byte = stream.peek(1)[:1] if hasattr(stream, "peek") else b""
            for match in HEX64.finditer(data):
                start, end = match.span()
                absolute = base + start
                # Matches wholly inside the old overlap were handled already.
                if absolute + 64 <= position:
                    continue
                previous = data[start - 1] if start else None
                if end < len(data):
                    following = data[end]
                elif next_byte:
                    following = next_byte[0]
                else:
                    following = None
                if previous in HEX_SET or following in HEX_SET:
                    continue
                yield absolute, match.group(0)
            position += len(chunk)
            overlap = data[-66:]


def aad_candidates(envelope: dict):
    sv = str(envelope["sv"])
    kid = envelope["kid"]
    nonce = envelope["nonce"]
    yield "none", None
    yield "empty", b""
    yield "sv_ascii", sv.encode()
    yield "kid_ascii", kid.encode()
    yield "kid_raw", bytes.fromhex(kid)
    yield "nonce_ascii", nonce.encode()
    yield "nonce_raw", bytes.fromhex(nonce)
    yield "colon_fields", f"{sv}:{kid}:{nonce}".encode()
    yield "pipe_fields", f"{sv}|{kid}|{nonce}".encode()
    yield "concatenated_fields", f"{sv}{kid}{nonce}".encode()
    yield "json_sv", f'{{"sv":{sv}}}'.encode()
    yield "json_through_kid", f'{{"sv":{sv},"kid":"{kid}"}}'.encode()
    yield "json_through_nonce", f'{{"sv":{sv},"kid":"{kid}","nonce":"{nonce}"}}'.encode()
    yield "path", b"/api/v3/report"
    yield "domain", b"security.mcbjd.net"
    yield "method_path", b"POST /api/v3/report"


def key_variants(text: bytes):
    raw = bytes.fromhex(text.decode("ascii"))
    variants = {
        "hex_decoded": raw,
        "sha256_ascii_exact": hashlib.sha256(text).digest(),
        "sha256_ascii_lower": hashlib.sha256(text.lower()).digest(),
        "sha256_ascii_upper": hashlib.sha256(text.upper()).digest(),
        "sha256_hex_decoded": hashlib.sha256(raw).digest(),
    }
    # Deduplicate equal variants while retaining a stable explanatory name.
    seen = set()
    for name, value in variants.items():
        if value not in seen:
            seen.add(value)
            yield name, value


def algorithms(key: bytes):
    yield "AESGCM", AESGCM(key)
    yield "AESCCM", AESCCM(key)
    yield "ChaCha20Poly1305", ChaCha20Poly1305(key)
    if AESGCMSIV is not None:
        yield "AESGCMSIV", AESGCMSIV(key)


def decrypt(algorithm, envelope: dict, aad: bytes | None):
    try:
        return algorithm.decrypt(
            bytes.fromhex(envelope["nonce"]),
            bytes.fromhex(envelope["ciphertext"] + envelope["tag"]),
            aad,
        )
    except Exception:
        return None


def main() -> int:
    here = Path(__file__).resolve().parent
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dump-dir", type=Path, default=here / "dump_out" / "41264")
    parser.add_argument("--network-evidence", type=Path, default=here / "maxhook_network_evidence.json")
    parser.add_argument("--output", type=Path, default=here / "maxhook_hex64_keyscan.json")
    args = parser.parse_args()

    evidence = json.loads(args.network_evidence.read_text(encoding="utf-8"))
    envelopes = []
    identities = set()
    for item in evidence["valid_crypto_envelopes"]:
        envelope = item["envelope"]
        identity = (envelope["nonce"], envelope["ciphertext"], envelope["tag"])
        if identity not in identities:
            identities.add(identity)
            envelopes.append(envelope)
    if not envelopes:
        raise SystemExit("no complete envelope in network evidence")

    started = time.monotonic()
    files = sorted(path for path in args.dump_dir.iterdir() if path.is_file())
    total_bytes = sum(path.stat().st_size for path in files)
    values: dict[bytes, dict] = {}
    occurrences = 0
    scanned_bytes = 0
    for index, path in enumerate(files, 1):
        for offset, text in bounded_matches(path):
            occurrences += 1
            entry = values.setdefault(
                text,
                {
                    "fingerprint_sha256": hashlib.sha256(text).hexdigest(),
                    "occurrences": 0,
                    "first_location": {"file": path.name, "offset": offset},
                },
            )
            entry["occurrences"] += 1
        scanned_bytes += path.stat().st_size
        if index % 1000 == 0:
            print(
                f"[*] files={index}/{len(files)} bytes={scanned_bytes}/{total_bytes} "
                f"unique_hex64={len(values)}",
                flush=True,
            )

    hits = []
    attempts = 0
    first = envelopes[0]
    for text, metadata in values.items():
        for variant_name, key in key_variants(text):
            for algorithm_name, algorithm in algorithms(key):
                for aad_name, aad in aad_candidates(first):
                    attempts += 1
                    plaintext = decrypt(algorithm, first, aad)
                    if plaintext is None:
                        continue
                    validated = 0
                    for envelope in envelopes:
                        if decrypt(algorithm, envelope, dict(aad_candidates(envelope))[aad_name]) is None:
                            break
                        validated += 1
                    hits.append(
                        {
                            "candidate_text": text.decode("ascii"),
                            "candidate_fingerprint_sha256": metadata["fingerprint_sha256"],
                            "key_variant": variant_name,
                            "key_hex": key.hex(),
                            "algorithm": algorithm_name,
                            "aad": aad_name,
                            "validated_envelopes": validated,
                            "plaintext_sha256": hashlib.sha256(plaintext).hexdigest(),
                            "first_location": metadata["first_location"],
                        }
                    )

    result = {
        "schema": "maxhook.hex64-keyscan/v1",
        "constraint_source": {
            "native_call": "0x1803cf7e1 -> 0x180324610",
            "candidate_argument": "R8 = &std::string at report-builder RBP+0x1a0",
            "observed_candidate_length": 64,
            "protected_entry_jump": "0x180324610 -> 0x181523001 (.bugland)",
        },
        "dump_dir": str(args.dump_dir.resolve()),
        "files_scanned": len(files),
        "bytes_scanned": total_bytes,
        "bounded_hex64_occurrences": occurrences,
        "unique_hex64_candidates": len(values),
        "candidate_fingerprint_histogram": dict(
            Counter(str(item["occurrences"]) for item in values.values())
        ),
        "unique_envelopes_tested": len(envelopes),
        "key_variants": [
            "hex_decoded",
            "sha256_ascii_exact/lower/upper",
            "sha256_hex_decoded",
        ],
        "algorithms": ["AESGCM", "AESCCM", "ChaCha20Poly1305", "AESGCMSIV"],
        "aad_candidate_count": len(list(aad_candidates(first))),
        "attempts_against_first_envelope": attempts,
        "hits": hits,
        "raw_non_hit_candidates_written": False,
        "elapsed_seconds": round(time.monotonic() - started, 3),
    }
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(
        f"[+] wrote {args.output.resolve()} candidates={len(values)} "
        f"attempts={attempts} hits={len(hits)} elapsed={result['elapsed_seconds']}s"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
