#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Extract reproducible MaxHook HTTP/network evidence from process region dumps.

The extractor is deliberately conservative: bytes following an HTTP header are
reported as a body only when they can be parsed as the declared payload.  Heap
data that merely happens to follow ``CRLF CRLF`` is never treated as a body.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import mmap
import os
import re
from pathlib import Path
from typing import Any, Iterator


REGION_RE = re.compile(r"^region_([0-9a-fA-F]{16})\.bin$")
JSON_MARKER = b'{"sv":3'
TAG_MARKER = b'","tag":"'
ASCII_HEX = frozenset(b"0123456789abcdefABCDEF")
MAX_JSON = 1 << 20

NEEDLES = {
    "native_url": b"https://security.mcbjd.net",
    "native_request": b"POST /api/v3/report HTTP/1.1",
    "http_response": b"HTTP/1.1 200",
    "motherboard_count": b"motherboard_count",
    "mac_count": b"mac_count",
    "disk_count": b"disk_count",
    "cpu_count": b"cpu_count",
}


def parse_args() -> argparse.Namespace:
    here = Path(__file__).resolve().parent
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "dump_dir",
        nargs="?",
        type=Path,
        default=here / "dump_out" / "41264",
        help="directory containing region_<base>.bin files",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=here / "maxhook_network_evidence.json",
        help="JSON evidence output path",
    )
    return parser.parse_args()


def iter_hits(buf: mmap.mmap, needle: bytes) -> Iterator[int]:
    pos = 0
    while True:
        pos = buf.find(needle, pos)
        if pos < 0:
            return
        yield pos
        pos += max(1, len(needle))


def location(path: Path, base: int, offset: int) -> dict[str, Any]:
    return {
        "file": str(path.resolve()),
        "file_offset": offset,
        "file_offset_hex": hex(offset),
        "virtual_address": base + offset,
        "virtual_address_hex": hex(base + offset),
    }


def read_ascii_json(buf: mmap.mmap, start: int) -> tuple[dict[str, Any], int] | None:
    raw = bytes(buf[start : min(len(buf), start + MAX_JSON)])
    stop = 0
    while stop < len(raw) and 0x20 <= raw[stop] <= 0x7E:
        stop += 1
    if not stop:
        return None
    try:
        text = raw[:stop].decode("ascii")
        value, end = json.JSONDecoder().raw_decode(text)
    except (UnicodeDecodeError, json.JSONDecodeError):
        return None
    if not isinstance(value, dict):
        return None
    return value, end


def envelope_summary(value: dict[str, Any]) -> dict[str, Any] | None:
    required = ("sv", "kid", "nonce", "ciphertext", "tag")
    if any(key not in value for key in required):
        return None
    cipher = str(value["ciphertext"])
    return {
        "sv": value["sv"],
        "kid": value["kid"],
        "nonce": value["nonce"],
        "ciphertext": cipher,
        "ciphertext_chars": len(cipher),
        "ciphertext_bytes_if_hex": len(cipher) // 2
        if len(cipher) % 2 == 0 and all(ord(ch) in ASCII_HEX for ch in cipher)
        else None,
        "tag": value["tag"],
    }


def parse_header_block(buf: mmap.mmap, start: int) -> tuple[list[str], int] | None:
    end = buf.find(b"\r\n\r\n", start, min(len(buf), start + 0x4000))
    if end < 0:
        return None
    raw = bytes(buf[start:end])
    try:
        return raw.decode("latin1").split("\r\n"), end + 4
    except UnicodeDecodeError:
        return None


def headers_to_dict(lines: list[str]) -> dict[str, str]:
    out: dict[str, str] = {}
    for line in lines[1:]:
        if ":" in line:
            name, value = line.split(":", 1)
            out[name.strip().lower()] = value.strip()
    return out


def parse_inline_request_body(
    buf: mmap.mmap, body_start: int, headers: dict[str, str]
) -> dict[str, Any]:
    declared = headers.get("content-length")
    try:
        length = int(declared) if declared is not None else None
    except ValueError:
        length = None
    result: dict[str, Any] = {
        "declared_content_length": length,
        "inline_body_valid": False,
    }
    if length is None or length < 0 or body_start + length > len(buf):
        result["reason"] = "missing/invalid Content-Length or body outside region"
        return result
    candidate = bytes(buf[body_start : body_start + length])
    result["candidate_sha256"] = hashlib.sha256(candidate).hexdigest()
    result["candidate_prefix_hex"] = candidate[:64].hex()
    if not candidate.startswith(b"{"):
        result["reason"] = "adjacent bytes do not begin with a JSON object"
        return result
    try:
        value = json.loads(candidate.decode("ascii"))
    except (UnicodeDecodeError, json.JSONDecodeError) as exc:
        result["reason"] = f"declared bytes are not a complete ASCII JSON body: {exc}"
        return result
    result["inline_body_valid"] = True
    result["json"] = value
    return result


def parse_chunked_response(buf: mmap.mmap, body_start: int) -> dict[str, Any] | None:
    line_end = buf.find(b"\r\n", body_start, min(len(buf), body_start + 32))
    if line_end < 0:
        return None
    try:
        chunk_size = int(bytes(buf[body_start:line_end]).split(b";", 1)[0], 16)
    except ValueError:
        return None
    chunk_start = line_end + 2
    chunk_end = chunk_start + chunk_size
    if chunk_end > len(buf):
        return None
    chunk = bytes(buf[chunk_start:chunk_end])
    result: dict[str, Any] = {
        "chunk_size": chunk_size,
        "chunk_sha256": hashlib.sha256(chunk).hexdigest(),
    }
    try:
        value = json.loads(chunk.decode("ascii"))
    except (UnicodeDecodeError, json.JSONDecodeError):
        result["json_valid"] = False
        result["chunk_prefix_hex"] = chunk[:64].hex()
        return result
    result["json_valid"] = True
    result["json"] = value
    summary = envelope_summary(value)
    if summary:
        result["envelope"] = summary
    return result


def printable_run_around_tag(buf: mmap.mmap, tag_marker: int) -> tuple[int, int]:
    start = tag_marker
    while start > 0 and 0x20 <= buf[start - 1] <= 0x7E:
        start -= 1
    end = tag_marker
    while end < len(buf) and 0x20 <= buf[end] <= 0x7E:
        end += 1
    return start, end


def main() -> int:
    args = parse_args()
    dump_dir = args.dump_dir.resolve()
    if not dump_dir.is_dir():
        raise SystemExit(f"dump directory does not exist: {dump_dir}")

    evidence: dict[str, Any] = {
        "dump_dir": str(dump_dir),
        "literal_hits": [],
        "http_requests": [],
        "http_responses": [],
        "valid_crypto_envelopes": [],
        "crypto_tail_fragments": [],
    }
    envelope_fingerprints: set[str] = set()
    fragment_fingerprints: set[str] = set()
    files_scanned = 0
    bytes_scanned = 0

    for path in sorted(dump_dir.glob("region_*.bin")):
        match = REGION_RE.match(path.name)
        if not match or path.stat().st_size == 0:
            continue
        base = int(match.group(1), 16)
        files_scanned += 1
        bytes_scanned += path.stat().st_size
        with path.open("rb") as stream, mmap.mmap(
            stream.fileno(), 0, access=mmap.ACCESS_READ
        ) as buf:
            interesting = False
            for name, needle in NEEDLES.items():
                for hit in iter_hits(buf, needle):
                    interesting = True
                    item = {"kind": name, **location(path, base, hit)}
                    evidence["literal_hits"].append(item)

                    if name == "native_request":
                        parsed = parse_header_block(buf, hit)
                        if parsed:
                            lines, body_start = parsed
                            headers = headers_to_dict(lines)
                            evidence["http_requests"].append(
                                {
                                    **location(path, base, hit),
                                    "request_line": lines[0],
                                    "headers": headers,
                                    "body_buffer": parse_inline_request_body(
                                        buf, body_start, headers
                                    ),
                                }
                            )
                    elif name == "http_response":
                        parsed = parse_header_block(buf, hit)
                        if parsed:
                            lines, body_start = parsed
                            headers = headers_to_dict(lines)
                            response = {
                                **location(path, base, hit),
                                "status_line": lines[0],
                                "headers": headers,
                            }
                            if headers.get("transfer-encoding", "").lower() == "chunked":
                                response["first_chunk"] = parse_chunked_response(
                                    buf, body_start
                                )
                            evidence["http_responses"].append(response)

            if not interesting and buf.find(JSON_MARKER) < 0 and buf.find(TAG_MARKER) < 0:
                continue

            for hit in iter_hits(buf, JSON_MARKER):
                parsed = read_ascii_json(buf, hit)
                if not parsed:
                    continue
                value, length = parsed
                summary = envelope_summary(value)
                if not summary:
                    continue
                fingerprint = hashlib.sha256(
                    json.dumps(value, sort_keys=True, separators=(",", ":")).encode()
                ).hexdigest()
                if fingerprint in envelope_fingerprints:
                    continue
                envelope_fingerprints.add(fingerprint)
                evidence["valid_crypto_envelopes"].append(
                    {
                        **location(path, base, hit),
                        "json_length": length,
                        "sha256": fingerprint,
                        "envelope": summary,
                    }
                )

            for hit in iter_hits(buf, TAG_MARKER):
                run_start, run_end = printable_run_around_tag(buf, hit)
                run = bytes(buf[run_start:run_end])
                if len(run) < 256 or run.startswith(JSON_MARKER):
                    continue
                tag_match = re.search(rb'","tag":"([0-9a-fA-F]{32})"\}', run)
                if not tag_match:
                    continue
                fingerprint = hashlib.sha256(run).hexdigest()
                if fingerprint in fragment_fingerprints:
                    continue
                fragment_fingerprints.add(fingerprint)
                evidence["crypto_tail_fragments"].append(
                    {
                        **location(path, base, run_start),
                        "printable_chars": len(run),
                        "sha256": fingerprint,
                        "prefix": run[:80].decode("ascii"),
                        "suffix": run[-120:].decode("ascii"),
                        "tag": tag_match.group(1).decode("ascii"),
                        "note": "printable tail only; not claimed as a complete HTTP body",
                    }
                )

    evidence["files_scanned"] = files_scanned
    evidence["bytes_scanned"] = bytes_scanned
    evidence["conclusions"] = {
        "native_endpoint": "https://security.mcbjd.net/api/v3/report"
        if any(x["kind"] == "native_url" for x in evidence["literal_hits"])
        and evidence["http_requests"]
        else None,
        "request_body_recovered_inline": any(
            req["body_buffer"].get("inline_body_valid")
            for req in evidence["http_requests"]
        ),
        "crypto_envelope_fields": ["sv", "kid", "nonce", "ciphertext", "tag"],
        "warning": (
            "The request body uses a separate heap buffer in this dump. "
            "Bytes adjacent to the POST headers are unrelated UTF-16 locale data."
        ),
    }

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(
        json.dumps(evidence, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    print(
        f"scanned {files_scanned} regions / {bytes_scanned:,} bytes; "
        f"requests={len(evidence['http_requests'])}, "
        f"responses={len(evidence['http_responses'])}, "
        f"envelopes={len(evidence['valid_crypto_envelopes'])}, "
        f"fragments={len(evidence['crypto_tail_fragments'])}"
    )
    print(args.output.resolve())
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
