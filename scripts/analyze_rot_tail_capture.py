#!/usr/bin/env python3
"""Analyze unified MaxHook input/output and tail rotation captures."""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter
from pathlib import Path


def events(path: Path) -> list[dict]:
    return [json.loads(line) for line in (path / "events.jsonl").read_text(encoding="utf-8").splitlines()]


def details(path: Path, all_events: list[dict], call_id: int) -> list[dict]:
    result = []
    chunks = sorted(
        (e for e in all_events if e.get("kind") == "rot_tail_details" and int(e["call_id"]) == call_id),
        key=lambda e: int(e["chunk"]),
    )
    for event in chunks:
        result.extend(json.loads((path / event["file"]).read_bytes()))
    return result


def semantic(sample: dict) -> tuple:
    return sample["rva"], sample["op"], sample["cl"], sample["before"], sample.get("after")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("capture", type=Path)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    capture = args.capture.resolve()
    all_events = events(capture)
    leave_events = [e for e in all_events if e.get("kind") == "rot_tail_leave"]
    calls = {}
    output = []
    for leave in leave_events:
        call_id = int(leave["call_id"])
        samples = details(capture, all_events, call_id)
        calls[call_id] = samples
        strings = {e["label"]: e for e in all_events if int(e.get("call_id", -1)) == call_id and e.get("kind") == "encrypt_string"}
        plaintext = (capture / strings["plaintext_json"]["file"]).read_bytes()
        ciphertext = bytes.fromhex((capture / strings["ciphertext_hex"]["file"]).read_text(encoding="ascii"))
        nonce = (capture / strings["nonce_hex"]["file"]).read_text(encoding="ascii")
        stream = bytes(a ^ b for a, b in zip(plaintext, ciphertext))
        output.append({
            "call_id": call_id,
            "plaintext_bytes": len(plaintext),
            "ciphertext_bytes": len(ciphertext),
            "nonce_hex": nonce,
            "keystream_sha256": hashlib.sha256(stream).hexdigest(),
            "rot_hits": leave["rot_hits"],
            "detail_range": [samples[0]["seq"], samples[-1]["seq"]] if samples else None,
            "site_counts": dict(Counter(x["rva"] for x in samples)),
            "verified": sum(x.get("verified") is True for x in samples),
            "mismatches": sum(x.get("verified") is False for x in samples),
        })
    comparisons = []
    ids = sorted(calls)
    for left, right in zip(ids, ids[1:]):
        a, b = calls[left], calls[right]
        same = sum(semantic(x) == semantic(y) for x, y in zip(a, b))
        comparisons.append({
            "left": left,
            "right": right,
            "aligned_tail_samples": min(len(a), len(b)),
            "same_rotation_semantics": same,
            "rotation_semantics_identical": len(a) == len(b) == same,
            "register_rows_identical": sum(x.get("registers") == y.get("registers") for x, y in zip(a, b)),
            "context_rows_identical": sum(x.get("context_slots") == y.get("context_slots") for x, y in zip(a, b)),
        })
    result = {
        "schema": "maxhook.rotation-tail.analysis/v1",
        "capture": str(capture),
        "calls": output,
        "comparisons": comparisons,
        "interpretation": (
            "Identical aligned tail rotation semantics across calls with distinct plaintext, nonce, and keystream "
            "shows these five rotate handlers are generic VM/control-flow primitives, not observations of the cipher state."
        ),
    }
    text = json.dumps(result, ensure_ascii=False, indent=2) + "\n"
    if args.output:
        args.output.write_text(text, encoding="utf-8")
    else:
        print(text, end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
