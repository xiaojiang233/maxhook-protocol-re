#!/usr/bin/env python3
"""Summarize capture_maxhook_rot.js output without exposing payload/key files."""

from __future__ import annotations

import argparse
import collections
import json
from pathlib import Path


def load_calls(capture: Path) -> tuple[list[dict], dict[int, list[dict]]]:
    events = [json.loads(line) for line in (capture / "events.jsonl").read_text(encoding="utf-8").splitlines()]
    calls: dict[int, list[dict]] = collections.defaultdict(list)
    chunks = sorted(
        (event for event in events if event.get("kind") == "rot_samples"),
        key=lambda event: (int(event["call_id"]), int(event["chunk"])),
    )
    for event in chunks:
        calls[int(event["call_id"])].extend(json.loads((capture / event["file"]).read_bytes()))
    return events, dict(calls)


def semantic(sample: dict) -> tuple:
    return sample["rva"], sample["op"], sample["cl"], sample["before"], sample["after"]


def common_ends(left: list[dict], right: list[dict]) -> tuple[int, int]:
    a = list(map(semantic, left))
    b = list(map(semantic, right))
    prefix = 0
    while prefix < min(len(a), len(b)) and a[prefix] == b[prefix]:
        prefix += 1
    suffix = 0
    while suffix < min(len(a), len(b)) - prefix and a[-1 - suffix] == b[-1 - suffix]:
        suffix += 1
    return prefix, suffix


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("capture", type=Path)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    capture = args.capture.resolve()
    events, calls = load_calls(capture)
    leaves = {int(e["call_id"]): e for e in events if e.get("kind") == "rot_trace_leave"}
    summaries = []
    for call_id, samples in sorted(calls.items()):
        sites = collections.Counter((s["rva"], s["op"]) for s in samples)
        counts = collections.Counter(s["count"] for s in samples)
        addresses = collections.Counter(s["rax"] for s in samples)
        summaries.append({
            "call_id": call_id,
            "samples": len(samples),
            "dropped": leaves.get(call_id, {}).get("dropped"),
            "verified": sum(s.get("verified") is True for s in samples),
            "mismatches": sum(s.get("verified") is False for s in samples),
            "site_counts": [{"rva": k[0], "op": k[1], "count": v} for k, v in sites.most_common()],
            "rotation_counts": dict(sorted(counts.items())),
            "unique_target_addresses": len(addresses),
            "top_target_addresses": [{"address": k, "count": v} for k, v in addresses.most_common(20)],
        })
    comparisons = []
    ids = sorted(calls)
    for left, right in zip(ids, ids[1:]):
        prefix, suffix = common_ends(calls[left], calls[right])
        comparisons.append({"left": left, "right": right, "common_semantic_prefix": prefix, "common_semantic_suffix": suffix})
    result = {
        "schema": "maxhook.rotation-capture.analysis/v1",
        "capture": str(capture),
        "calls": summaries,
        "adjacent_call_comparisons": comparisons,
    }
    text = json.dumps(result, indent=2, ensure_ascii=False) + "\n"
    if args.output:
        args.output.write_text(text, encoding="utf-8")
    else:
        print(text, end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
