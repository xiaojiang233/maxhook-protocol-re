#!/usr/bin/env python3
"""Offline, sanitized analysis for a MaxHook WinHTTP capture.

The generated JSON deliberately excludes raw KIDs, nonces, ciphertexts, tags,
request bodies, response bodies, handles, pointers, and access tokens.  It is
safe to use as a structural protocol report; the source capture remains
sensitive and must not be published.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import struct
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any


SCHEMA = "maxhook.live-capture.analysis/v1"
HEX_LENGTHS = {"kid": 32, "nonce": 24, "tag": 32}
REPORT_BUILDER = {
    "function": "0x1803cd330-0x1803d18b9",
    "call_wrapper": "0x1803d0acf",
    "return_after_call": "0x1803d0ad4",
    "wrapper": "0x180332770-0x180333c82",
    "winhttp_return": "0x180333271",
    "builder_rbp_from_winhttp_rsp": 0x238,
}
NATIVE_ENCRYPT_BOUNDARY = {
    "call_address": "0x1803cf7e1",
    "callee": "0x180324610-0x1803261bc",
    "protected_entry_jump": "0x180324610 -> 0x181523001 (.bugland)",
    "arguments": {
        "rcx": "output envelope struct at builder RBP+0x290",
        "rdx": "32-character std::string at builder RBP+0xe0",
        "r8": "64-character std::string at builder RBP+0x1a0 (key-material candidate)",
        "r9": "fresh context/object at builder RBP+0x38",
        "stack_0x20": "plaintext JSON std::string at builder RBP+0x100",
    },
    "plaintext_destructor_call": "0x1803cf7ed -> 0x18031b970",
}
SESSION_EXCHANGE_BUILDER = {
    "function": "0x18033ef60-0x180348545",
    "call_wrapper": "0x18034503f",
    "return_after_call": "0x180345044",
    "builder_rbp_from_winhttp_rsp": 0x238,
    "native_encrypt_call": "0x18034406d -> 0x180324610",
    "encrypt_arguments": {
        "rcx": "output envelope struct at builder RBP+0xba0",
        "rdx": "32-character std::string at builder RBP+0x200",
        "r8": "64-character std::string at builder RBP+0x580",
        "r9": "fresh context/object at builder RBP+0x50",
        "stack_0x20": "plaintext JSON std::string at builder RBP+0x220",
    },
    "final_envelope": "std::string at builder RBP+0x240",
}
REPORT_FRAME_FIELDS = {
    0x0C0: "unknown_len_100",
    0x0E0: "unknown_len_32",
    0x120: "envelope_json",
    0x1A0: "unknown_len_64",
    0x290: "kid_hex",
    0x2B0: "nonce_hex",
    0x2D0: "ciphertext_hex",
    0x2F0: "tag_hex",
}


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def value_fingerprint(value: str) -> str:
    """Fingerprint the serialized value without retaining it in output."""
    return hashlib.sha256(value.encode("ascii")).hexdigest()


def load_events(capture_dir: Path) -> list[dict[str, Any]]:
    events_path = capture_dir / "events.jsonl"
    events = []
    with events_path.open("r", encoding="utf-8") as stream:
        for line_no, line in enumerate(stream, 1):
            if not line.strip():
                continue
            try:
                events.append(json.loads(line))
            except json.JSONDecodeError as exc:
                raise ValueError(f"invalid JSON at {events_path}:{line_no}: {exc}") from exc
    return events


def strict_envelope(data: bytes) -> dict[str, Any]:
    try:
        obj = json.loads(data.decode("utf-8"))
    except (UnicodeDecodeError, json.JSONDecodeError) as exc:
        return {"valid": False, "error": type(exc).__name__}
    if not isinstance(obj, dict):
        return {"valid": False, "error": "not_object"}
    expected = {"ciphertext", "kid", "nonce", "sv", "tag"}
    if set(obj) != expected:
        return {"valid": False, "error": "wrong_members", "members": sorted(obj)}
    if obj["sv"] != 3:
        return {"valid": False, "error": "wrong_sv", "sv": obj["sv"]}
    for name, expected_length in HEX_LENGTHS.items():
        value = obj[name]
        if not isinstance(value, str) or len(value) != expected_length:
            return {"valid": False, "error": f"wrong_{name}_length"}
        try:
            bytes.fromhex(value)
        except ValueError:
            return {"valid": False, "error": f"non_hex_{name}"}
    ciphertext = obj["ciphertext"]
    if not isinstance(ciphertext, str) or len(ciphertext) % 2:
        return {"valid": False, "error": "wrong_ciphertext_length"}
    try:
        bytes.fromhex(ciphertext)
    except ValueError:
        return {"valid": False, "error": "non_hex_ciphertext"}
    return {
        "valid": True,
        "serialized_member_order": list(obj),
        "sv": 3,
        "kid_fingerprint_sha256": value_fingerprint(obj["kid"]),
        "nonce_bytes": len(obj["nonce"]) // 2,
        "ciphertext_bytes": len(ciphertext) // 2,
        "tag_bytes": len(obj["tag"]) // 2,
        "_lengths": {
            "kid_hex": len(obj["kid"]),
            "nonce_hex": len(obj["nonce"]),
            "ciphertext_hex": len(ciphertext),
            "tag_hex": len(obj["tag"]),
            "envelope_json": len(data),
        },
    }


def event_file(capture_dir: Path, event: dict[str, Any]) -> bytes:
    path = capture_dir / event["file"]
    data = path.read_bytes()
    recorded = event.get("sha256")
    if recorded and sha256_bytes(data) != recorded:
        raise ValueError(f"hash mismatch: {path}")
    return data


def parse_u64(data: bytes, offset: int) -> int:
    if offset < 0 or offset + 8 > len(data):
        raise ValueError(f"u64 offset 0x{offset:x} outside stack dump of {len(data)} bytes")
    return struct.unpack_from("<Q", data, offset)[0]


def analyze_report_frame(
    stack: bytes,
    send_event: dict[str, Any],
    body_analysis: dict[str, Any],
) -> dict[str, Any]:
    rbp_delta = REPORT_BUILDER["builder_rbp_from_winhttp_rsp"]
    body_pointer = int(send_event["optional_pointer"], 16)
    fields = []
    all_expected_lengths_match = True
    for rbp_offset, name in REPORT_FRAME_FIELDS.items():
        stack_offset = rbp_delta + rbp_offset
        pointer = parse_u64(stack, stack_offset)
        size = parse_u64(stack, stack_offset + 0x10)
        capacity = parse_u64(stack, stack_offset + 0x18)
        expected_length = body_analysis.get("_lengths", {}).get(name)
        length_match = expected_length is None or size == expected_length
        if expected_length is not None:
            all_expected_lengths_match &= length_match
        fields.append(
            {
                "name": name,
                "rbp_offset": f"0x{rbp_offset:x}",
                "stack_offset": f"0x{stack_offset:x}",
                "size": size,
                "capacity": capacity,
                "expected_size": expected_length,
                "size_matches": length_match,
                "pointer_matches_send_buffer": pointer == body_pointer,
            }
        )
    plaintext_offset = rbp_delta + 0x100
    plaintext_size = parse_u64(stack, plaintext_offset + 0x10)
    plaintext_capacity = parse_u64(stack, plaintext_offset + 0x18)
    plaintext_union_tail = stack[plaintext_offset + 8 : plaintext_offset + 16]
    field_by_name = {item["name"]: item for item in fields}
    ciphertext_bytes = body_analysis.get("ciphertext_bytes")
    return {
        "layout": "msvc_basic_string_char: union@+0x0,size@+0x10,capacity@+0x18",
        "builder_rbp_from_captured_rsp": f"+0x{rbp_delta:x}",
        "fields": fields,
        "all_protocol_field_lengths_match": all_expected_lengths_match,
        "envelope_pointer_matches_send_buffer": next(
            item["pointer_matches_send_buffer"]
            for item in fields
            if item["name"] == "envelope_json"
        ),
        "native_encrypt_boundary": {
            **NATIVE_ENCRYPT_BOUNDARY,
            "post_call_output_shape": {
                "kid_hex_chars": field_by_name["kid_hex"]["size"],
                "nonce_hex_chars": field_by_name["nonce_hex"]["size"],
                "ciphertext_hex_chars": field_by_name["ciphertext_hex"]["size"],
                "tag_hex_chars": field_by_name["tag_hex"]["size"],
            },
            "input_objects_at_send_time": {
                "rbp_plus_e0_size": field_by_name["unknown_len_32"]["size"],
                "rbp_plus_1a0_size": field_by_name["unknown_len_64"]["size"],
                "plaintext_rbp_plus_100_size_after_destructor": plaintext_size,
                "plaintext_rbp_plus_100_retained_capacity": plaintext_capacity,
                "plaintext_capacity_covers_ciphertext_bytes": (
                    ciphertext_bytes is not None and plaintext_capacity >= ciphertext_bytes
                ),
                "plaintext_union_residual_is_json_schema_fragment": (
                    plaintext_union_tail.rstrip(b"\x00") == b'_id":"'
                ),
            },
        },
    }


def analyze_session_exchange_frame(
    stack: bytes,
    send_event: dict[str, Any],
    body_analysis: dict[str, Any],
) -> dict[str, Any]:
    rbp_delta = SESSION_EXCHANGE_BUILDER["builder_rbp_from_winhttp_rsp"]
    send_pointer = int(send_event["optional_pointer"], 16)

    def string_object(rbp_offset: int) -> dict[str, Any]:
        offset = rbp_delta + rbp_offset
        pointer = parse_u64(stack, offset)
        return {
            "rbp_offset": f"0x{rbp_offset:x}",
            "stack_offset": f"0x{offset:x}",
            "size": parse_u64(stack, offset + 0x10),
            "capacity": parse_u64(stack, offset + 0x18),
            "pointer_matches_send_buffer": pointer == send_pointer,
        }

    input_32 = string_object(0x200)
    plaintext = string_object(0x220)
    final_envelope = string_object(0x240)
    input_64 = string_object(0x580)
    output_names = ["kid_hex", "nonce_hex", "ciphertext_hex", "tag_hex"]
    output_offsets = [0xBA0, 0xBC0, 0xBE0, 0xC00]
    outputs = []
    lengths = body_analysis.get("_lengths", {})
    for name, offset in zip(output_names, output_offsets):
        item = string_object(offset)
        item["name"] = name
        item["expected_size"] = lengths.get(name)
        item["size_matches"] = item["size"] == item["expected_size"]
        outputs.append(item)
    ciphertext_bytes = body_analysis.get("ciphertext_bytes")
    return {
        **SESSION_EXCHANGE_BUILDER,
        "msvc_string_layout": "union@+0x0,size@+0x10,capacity@+0x18",
        "input_32": input_32,
        "input_64": input_64,
        "plaintext_after_destructor": {
            **plaintext,
            "size_is_zero": plaintext["size"] == 0,
            "capacity_covers_ciphertext_bytes": (
                ciphertext_bytes is not None and plaintext["capacity"] >= ciphertext_bytes
            ),
        },
        "output_fields": outputs,
        "all_output_lengths_match": all(item["size_matches"] for item in outputs),
        "final_envelope": {
            **final_envelope,
            "expected_size": lengths.get("envelope_json"),
            "size_matches": final_envelope["size"] == lengths.get("envelope_json"),
        },
    }


def sanitize_envelope(result: dict[str, Any]) -> dict[str, Any]:
    return {key: value for key, value in result.items() if key != "_lengths"}


def analyze(capture_dir: Path) -> dict[str, Any]:
    events = load_events(capture_dir)
    grouped: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for event in events:
        request_id = event.get("request_id")
        if request_id is not None:
            grouped[str(request_id)].append(event)

    requests = []
    report_frame_count = 0
    valid_report_frames = 0
    request_kids: dict[str, set[str]] = defaultdict(set)
    response_kids: dict[str, set[str]] = defaultdict(set)

    def one(items: list[dict[str, Any]], kind: str) -> dict[str, Any] | None:
        matches = [event for event in items if event.get("kind") == kind]
        if not matches:
            return None
        if len(matches) != 1:
            raise ValueError(f"expected one {kind}, got {len(matches)}")
        return matches[0]

    for request_id in sorted(grouped, key=lambda value: int(value)):
        items = grouped[request_id]
        opened = one(items, "request_open")
        sent = one(items, "send_begin")
        send_body_event = one(items, "send_optional")
        stack_event = one(items, "send_stack")
        if not (opened and sent and send_body_event):
            continue
        path = opened["path"]
        request_body = event_file(capture_dir, send_body_event)
        request_envelope = strict_envelope(request_body)
        if request_envelope.get("valid"):
            request_kids[path].add(request_envelope["kid_fingerprint_sha256"])

        read_events = sorted(
            (event for event in items if event.get("kind") == "read"),
            key=lambda event: event["sequence"],
        )
        response_body = b"".join(event_file(capture_dir, event) for event in read_events)
        response_envelope = strict_envelope(response_body) if read_events else {"valid": False, "error": "not_captured"}
        if response_envelope.get("valid"):
            response_kids[path].add(response_envelope["kid_fingerprint_sha256"])

        item: dict[str, Any] = {
            "request_id": request_id,
            "method": opened["verb"],
            "path": path,
            "thread_id": opened["thread_id"],
            "request_bytes": len(request_body),
            "request_sha256": sha256_bytes(request_body),
            "request_envelope": sanitize_envelope(request_envelope),
            "response_bytes": len(response_body),
            "response_sha256": sha256_bytes(response_body) if response_body else None,
            "response_envelope": sanitize_envelope(response_envelope),
            "request_response_kid_match": (
                request_envelope.get("valid")
                and response_envelope.get("valid")
                and request_envelope["kid_fingerprint_sha256"]
                == response_envelope["kid_fingerprint_sha256"]
            ),
            "winhttp_caller": sent.get("caller"),
        }
        if path == "/api/v3/report" and stack_event:
            stack = event_file(capture_dir, stack_event)
            frame = analyze_report_frame(stack, sent, request_envelope)
            item["report_builder_frame"] = frame
            report_frame_count += 1
            if frame["all_protocol_field_lengths_match"] and frame["envelope_pointer_matches_send_buffer"]:
                valid_report_frames += 1
        elif path == "/api/v3/session/exchange" and stack_event:
            stack = event_file(capture_dir, stack_event)
            item["session_exchange_builder_frame"] = analyze_session_exchange_frame(
                stack, sent, request_envelope
            )
        requests.append(item)

    endpoint_counts = Counter(item["path"] for item in requests)
    kid_transitions = []
    previous = None
    for item in requests:
        current = item["request_envelope"].get("kid_fingerprint_sha256")
        if current != previous:
            kid_transitions.append(
                {
                    "request_id": item["request_id"],
                    "path": item["path"],
                    "kid_fingerprint_sha256": current,
                }
            )
            previous = current

    return {
        "schema": SCHEMA,
        "source": {
            "capture_directory": str(capture_dir.resolve()),
            "events_sha256": sha256_bytes((capture_dir / "events.jsonl").read_bytes()),
            "sensitive_raw_capture": True,
        },
        "sanitization": {
            "raw_envelopes_included": False,
            "raw_kids_included": False,
            "raw_nonces_included": False,
            "raw_ciphertexts_included": False,
            "raw_tags_included": False,
            "raw_pointers_included": False,
        },
        "event_count": len(events),
        "event_kind_counts": dict(sorted(Counter(event.get("kind", "unknown") for event in events).items())),
        "request_count": len(requests),
        "endpoint_counts": dict(sorted(endpoint_counts.items())),
        "valid_request_envelopes": sum(item["request_envelope"].get("valid", False) for item in requests),
        "valid_response_envelopes": sum(item["response_envelope"].get("valid", False) for item in requests),
        "request_response_kid_matches": sum(item["request_response_kid_match"] for item in requests),
        "kid_transitions": kid_transitions,
        "endpoint_request_kid_fingerprints": {
            path: sorted(values) for path, values in sorted(request_kids.items())
        },
        "endpoint_response_kid_fingerprints": {
            path: sorted(values) for path, values in sorted(response_kids.items())
        },
        "report_builder": REPORT_BUILDER,
        "native_encrypt_boundary": NATIVE_ENCRYPT_BOUNDARY,
        "session_exchange_builder": SESSION_EXCHANGE_BUILDER,
        "report_frame_count": report_frame_count,
        "fully_validated_report_frames": valid_report_frames,
        "requests": requests,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("capture_dir", type=Path)
    parser.add_argument("-o", "--output", type=Path, required=True)
    args = parser.parse_args()
    result = analyze(args.capture_dir)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(f"[+] wrote {args.output.resolve()}")
    print(
        f"[+] requests={result['request_count']} "
        f"request_envelopes={result['valid_request_envelopes']} "
        f"response_envelopes={result['valid_response_envelopes']} "
        f"report_frames={result['fully_validated_report_frames']}/{result['report_frame_count']}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
