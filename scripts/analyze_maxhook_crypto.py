#!/usr/bin/env python3
"""Reproduce MaxHook crypto-boundary scans from a process memory dump.

This script does not guess a protocol key.  It records exactly which simple,
auditable hypotheses were tested so zero-hit results remain reproducible.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import pathlib
import re
import struct
import time
from collections.abc import Iterable

from cryptography.hazmat.primitives.ciphers.aead import (
    AESCCM,
    AESGCM,
    ChaCha20Poly1305,
)

try:
    from cryptography.hazmat.primitives.ciphers.aead import AESGCMSIV
except ImportError:
    AESGCMSIV = None


HEX_KEY_RE = re.compile(rb"(?<![0-9A-Fa-f])([0-9A-Fa-f]{32}|[0-9A-Fa-f]{48}|[0-9A-Fa-f]{64})(?![0-9A-Fa-f])")
OPCODE_SIGNATURES = {
    "aesenc": bytes.fromhex("66 0f 38 dc"),
    "aesenclast": bytes.fromhex("66 0f 38 dd"),
    "aesdec": bytes.fromhex("66 0f 38 de"),
    "aesdeclast": bytes.fromhex("66 0f 38 df"),
    "aesimc": bytes.fromhex("66 0f 38 db"),
    "aeskeygenassist": bytes.fromhex("66 0f 3a df"),
    "pclmulqdq": bytes.fromhex("66 0f 3a 44"),
    "sha1rnds4": bytes.fromhex("0f 3a cc"),
    "sha256rnds2": bytes.fromhex("0f 38 cb"),
    "sha256msg1": bytes.fromhex("0f 38 cc"),
    "sha256msg2": bytes.fromhex("0f 38 cd"),
}


def parse_args() -> argparse.Namespace:
    here = pathlib.Path(__file__).resolve().parent
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dump-dir", type=pathlib.Path, default=here / "dump_out" / "41264")
    parser.add_argument("--modules", type=pathlib.Path, default=here / "modules_37988.txt")
    parser.add_argument(
        "--network-evidence",
        type=pathlib.Path,
        default=here / "maxhook_network_evidence.json",
    )
    parser.add_argument(
        "--maxhook-dll",
        type=pathlib.Path,
        default=pathlib.Path(r"E:\MCLDownload\Game\.minecraft\native\MaxHook.dll"),
    )
    parser.add_argument("--runtime-bugland", type=pathlib.Path, default=here / "runtime_bugland2.bin")
    parser.add_argument("--output", type=pathlib.Path, default=here / "maxhook_crypto_analysis.json")
    parser.add_argument("--skip-memory-keys", action="store_true")
    return parser.parse_args()


def unique_envelopes(evidence: dict) -> list[dict]:
    result = []
    seen = set()
    for item in evidence["valid_crypto_envelopes"]:
        envelope = item["envelope"]
        identity = (envelope["nonce"], envelope["ciphertext"], envelope["tag"])
        if identity not in seen:
            seen.add(identity)
            result.append(envelope)
    return result


def aad_candidates(envelope: dict) -> list[tuple[str, bytes | None]]:
    sv = str(envelope["sv"])
    kid = envelope["kid"]
    nonce = envelope["nonce"]
    return [
        ("none", None),
        ("empty", b""),
        ("sv_ascii", sv.encode()),
        ("kid_ascii", kid.encode()),
        ("kid_raw", bytes.fromhex(kid)),
        ("nonce_ascii", nonce.encode()),
        ("nonce_raw", bytes.fromhex(nonce)),
        ("colon_fields", f"{sv}:{kid}:{nonce}".encode()),
        ("pipe_fields", f"{sv}|{kid}|{nonce}".encode()),
        ("concatenated_fields", f"{sv}{kid}{nonce}".encode()),
        ("json_sv", f'{{"sv":{sv}}}'.encode()),
        ("json_through_kid", f'{{"sv":{sv},"kid":"{kid}"}}'.encode()),
        (
            "json_through_nonce",
            f'{{"sv":{sv},"kid":"{kid}","nonce":"{nonce}"}}'.encode(),
        ),
        (
            "json_ciphertext_prefix",
            f'{{"sv":{sv},"kid":"{kid}","nonce":"{nonce}","ciphertext":"'.encode(),
        ),
        ("path", b"/api/v3/report"),
        ("domain", b"security.mcbjd.net"),
        ("method_path", b"POST /api/v3/report"),
    ]


def algorithms_for_key(key: bytes, derived: bool = False) -> Iterable[tuple[str, object]]:
    if len(key) in (16, 24, 32):
        yield "AESGCM", AESGCM(key)
        yield "AESCCM", AESCCM(key)
    if AESGCMSIV is not None and len(key) in (16, 32):
        yield "AESGCMSIV", AESGCMSIV(key)
    if len(key) == 32:
        yield "ChaCha20Poly1305", ChaCha20Poly1305(key)


def validate_aead(algorithm, envelope: dict, aad: bytes | None) -> bytes | None:
    try:
        return algorithm.decrypt(
            bytes.fromhex(envelope["nonce"]),
            bytes.fromhex(envelope["ciphertext"] + envelope["tag"]),
            aad,
        )
    except Exception:
        return None


def build_derived_keys(kid: str) -> dict[str, bytes]:
    raw = bytes.fromhex(kid)
    materials = {
        "kid_ascii_upper": kid.encode(),
        "kid_ascii_lower": kid.lower().encode(),
        "kid_raw": raw,
        "kid_raw_reversed": raw[::-1],
        "domain": b"security.mcbjd.net",
        "path": b"/api/v3/report",
        "url": b"https://security.mcbjd.net/api/v3/report",
        "sv3": b"3",
    }
    keys: dict[str, bytes] = {}
    for name, material in materials.items():
        variants = {
            "direct": material,
            "md5": hashlib.md5(material).digest(),
            "sha1": hashlib.sha1(material).digest(),
            "sha256": hashlib.sha256(material).digest(),
            "sha512": hashlib.sha512(material).digest(),
        }
        for variant, value in variants.items():
            for size in (16, 24, 32):
                if len(value) >= size:
                    keys[f"{name}:{variant}:{size}"] = value[:size]
    for separator in (b"", b":", b"|", b"/"):
        for left, right in (
            (kid.encode(), b"security.mcbjd.net"),
            (raw, b"security.mcbjd.net"),
            (kid.encode(), b"/api/v3/report"),
        ):
            material = left + separator + right
            name = f"composite:{separator!r}:{hashlib.sha256(material).hexdigest()[:8]}"
            keys[name] = hashlib.sha256(material).digest()
    return keys


def derived_key_scan(envelopes: list[dict]) -> dict:
    keys = build_derived_keys(envelopes[0]["kid"])
    hits = []
    attempts = 0
    first_aads = aad_candidates(envelopes[0])
    for key_name, key in keys.items():
        for algorithm_name, algorithm in algorithms_for_key(key, derived=True):
            for aad_index, (aad_name, _) in enumerate(first_aads):
                attempts += 1
                plaintexts = []
                for envelope in envelopes:
                    aad = aad_candidates(envelope)[aad_index][1]
                    plaintext = validate_aead(algorithm, envelope, aad)
                    if plaintext is None:
                        break
                    plaintexts.append(plaintext.hex())
                if plaintexts:
                    hits.append(
                        {
                            "key": key_name,
                            "algorithm": algorithm_name,
                            "aad": aad_name,
                            "valid_count": len(plaintexts),
                            "plaintexts": plaintexts,
                        }
                    )
    return {
        "unique_envelopes": len(envelopes),
        "candidate_keys": len(keys),
        "attempt_families": attempts,
        "hits": hits,
    }


def memory_key_candidates(files: list[pathlib.Path]) -> tuple[set[bytes], list[dict]]:
    keys: set[bytes] = set()
    regions = []
    for path in files:
        data = path.read_bytes()
        regions.append({"file": str(path.resolve()), "bytes": len(data)})
        for offset in range(0, max(0, len(data) - 15), 8):
            for size in (16, 24, 32):
                if offset + size <= len(data):
                    keys.add(data[offset : offset + size])
        for match in HEX_KEY_RE.finditer(data):
            keys.add(bytes.fromhex(match.group(1).decode()))
    return keys, regions


def memory_key_scan(dump_dir: pathlib.Path, envelope: dict) -> dict:
    names = [
        "region_0000005962cf8000.bin",
        "region_0000005966ff6000.bin",
        "region_00000001806e0000.bin",
        "region_00000001805e0000.bin",
    ]
    files = [dump_dir / name for name in names]
    keys, regions = memory_key_candidates(files)
    aads = aad_candidates(envelope)
    # Keep this scan equivalent to the original narrow test: AES-GCM and
    # ChaCha20-Poly1305 against the first complete response.
    hits = []
    attempts = 0
    for key in keys:
        candidates = []
        if len(key) in (16, 24, 32):
            candidates.append(("AESGCM", AESGCM(key)))
        if len(key) == 32:
            candidates.append(("ChaCha20Poly1305", ChaCha20Poly1305(key)))
        for algorithm_name, algorithm in candidates:
            for aad_name, aad in aads:
                attempts += 1
                plaintext = validate_aead(algorithm, envelope, aad)
                if plaintext is not None:
                    hits.append(
                        {
                            "key_hex": key.hex(),
                            "algorithm": algorithm_name,
                            "aad": aad_name,
                            "plaintext_hex": plaintext.hex(),
                        }
                    )
    return {
        "regions": regions,
        "alignment": 8,
        "unique_keys": len(keys),
        "attempts": attempts,
        "hits": hits,
    }


def parse_modules(path: pathlib.Path) -> dict[str, tuple[int, int]]:
    wanted = {
        "bcryptprimitives.dll": "bcryptPrimitives",
        "bcrypt.dll": "bcrypt",
        "ncrypt.dll": "ncrypt",
        "ncryptsslp.dll": "ncryptsslp",
        "winhttp.dll": "winhttp",
    }
    result = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        try:
            address, size, name, _ = line.split(",", 3)
        except ValueError:
            continue
        label = wanted.get(name.lower())
        if label:
            base = int(address, 16)
            result[label] = (base, base + int(size, 16))
    return result


def pointer_scan(dump_dir: pathlib.Path, ranges: dict[str, tuple[int, int]]) -> dict:
    try:
        import numpy as np
    except ImportError as exc:
        raise RuntimeError("pointer scan requires numpy") from exc
    hits = []
    files = sorted(dump_dir.glob("region_000000018*.bin"))
    for path in files:
        base = int(path.stem.rsplit("_", 1)[1], 16)
        data = path.read_bytes()
        for alignment in range(8):
            count = (len(data) - alignment) // 8
            if count <= 0:
                continue
            values = np.frombuffer(data, dtype="<u8", count=count, offset=alignment)
            for name, (low, high) in ranges.items():
                for index in np.flatnonzero((values >= low) & (values < high)):
                    offset = alignment + int(index) * 8
                    target = int(values[index])
                    hits.append(
                        {
                            "file": path.name,
                            "owner_va": hex(base + offset),
                            "alignment": offset % 8,
                            "target": hex(target),
                            "module": name,
                            "rva": hex(target - low),
                        }
                    )
    return {
        "scope": "all dumped MaxHook image regions matching region_000000018*.bin",
        "ranges": {name: [hex(low), hex(high)] for name, (low, high) in ranges.items()},
        "files": len(files),
        "hits": hits,
    }


def signature_scan(paths: list[pathlib.Path]) -> list[dict]:
    output = []
    for path in paths:
        data = path.read_bytes()
        hits = {}
        for name, signature in OPCODE_SIGNATURES.items():
            positions = []
            cursor = 0
            while True:
                cursor = data.find(signature, cursor)
                if cursor < 0:
                    break
                positions.append(hex(cursor))
                cursor += 1
            if positions:
                hits[name] = positions
        output.append(
            {
                "file": str(path.resolve()),
                "bytes": len(data),
                "raw_opcode_hits": hits,
                "warning": "raw opcode hits in packed/data sections are not proof of executed instructions",
            }
        )
    return output


def main() -> int:
    args = parse_args()
    started = time.monotonic()
    evidence = json.loads(args.network_evidence.read_text(encoding="utf-8"))
    envelopes = unique_envelopes(evidence)
    if not envelopes:
        raise RuntimeError("network evidence contains no complete crypto envelopes")
    result = {
        "schema": "maxhook.crypto.analysis/v1",
        "inputs": {
            "dump_dir": str(args.dump_dir.resolve()),
            "modules": str(args.modules.resolve()),
            "network_evidence": str(args.network_evidence.resolve()),
        },
        "derived_key_scan": derived_key_scan(envelopes),
        "system_crypto_pointer_scan": pointer_scan(args.dump_dir, parse_modules(args.modules)),
        "instruction_signature_scan": signature_scan([args.maxhook_dll, args.runtime_bugland]),
    }
    if not args.skip_memory_keys:
        result["memory_key_scan"] = memory_key_scan(args.dump_dir, envelopes[0])
    result["elapsed_seconds"] = round(time.monotonic() - started, 3)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    print(args.output.resolve())
    print(
        json.dumps(
            {
                "derived_hits": len(result["derived_key_scan"]["hits"]),
                "pointer_hits": len(result["system_crypto_pointer_scan"]["hits"]),
                "memory_key_hits": len(result.get("memory_key_scan", {}).get("hits", [])),
                "elapsed_seconds": result["elapsed_seconds"],
            },
            indent=2,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
