#!/usr/bin/env python3
"""Prove the VM plaintext XOR boundary against synchronized envelope output."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path


def load_events(directory: Path) -> list[dict]:
    return [json.loads(line) for line in (directory / "events.jsonl").read_text(encoding="utf-8").splitlines()]


def load_records(directory: Path, events: list[dict], call_id: int) -> list[dict]:
    result = []
    chunks = sorted(
        (e for e in events if e.get("kind") == "plaintext_xor_records" and int(e["call_id"]) == call_id),
        key=lambda e: int(e["chunk"]),
    )
    for event in chunks:
        result.extend(json.loads((directory / event["file"]).read_bytes()))
    return result


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("capture", type=Path)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    directory = args.capture.resolve()
    events = load_events(directory)
    calls = []
    for leave in (e for e in events if e.get("kind") == "plaintext_xor_leave"):
        call_id = int(leave["call_id"])
        records = load_records(directory, events, call_id)
        strings = {
            e["label"]: e
            for e in events
            if int(e.get("call_id", -1)) == call_id and e.get("kind") == "encrypt_string"
        }
        plaintext = (directory / strings["plaintext_json"]["file"]).read_bytes()
        ciphertext = bytes.fromhex((directory / strings["ciphertext_hex"]["file"]).read_text(encoding="ascii"))
        keystream = bytes(a ^ b for a, b in zip(plaintext, ciphertext))
        source = bytes(r["source_byte"] for r in records)
        before = bytes(r["before"] for r in records)
        after = bytes(r["after"] for r in records)
        xor_operand = bytes(r["xor_byte"] for r in records)
        captured = len(records)
        calls.append({
            "call_id": call_id,
            "plaintext_bytes": len(plaintext),
            "captured_bytes": captured,
            "uncaptured_tail_bytes": len(plaintext) - captured,
            "captured_is_floor_64": captured == (len(plaintext) // 64) * 64,
            "source_equals_plaintext_prefix": source == plaintext[:captured],
            "xor_operand_equals_plaintext_prefix": xor_operand == plaintext[:captured],
            "before_equals_keystream_prefix": before == keystream[:captured],
            "after_equals_ciphertext_prefix": after == ciphertext[:captured],
            "all_instruction_semantics_verified": all(r.get("verified") is True for r in records),
            "keystream_sha256": hashlib.sha256(keystream).hexdigest(),
            "destination_addresses": sorted({r["destination"] for r in records}),
            "source_pointer_slots": sorted({r["pointer_slot"] for r in records}),
        })
    result = {
        "schema": "maxhook.plaintext-xor.analysis/v1",
        "capture": str(directory),
        "xor_boundary": {
            "load_pointer": "0x1809c552a",
            "load_plaintext_byte": "0x1809c552e",
            "xor_plaintext_into_keystream": "0x1809c5561",
            "semantics": "ciphertext_byte = preexisting_keystream_byte XOR plaintext_byte",
            "block_bytes": 64,
        },
        "calls": calls,
        "all_calls_closed": all(
            c["source_equals_plaintext_prefix"]
            and c["xor_operand_equals_plaintext_prefix"]
            and c["before_equals_keystream_prefix"]
            and c["after_equals_ciphertext_prefix"]
            and c["all_instruction_semantics_verified"]
            for c in calls
        ),
    }
    text = json.dumps(result, indent=2, ensure_ascii=False) + "\n"
    if args.output:
        args.output.write_text(text, encoding="utf-8")
    else:
        print(text, end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
