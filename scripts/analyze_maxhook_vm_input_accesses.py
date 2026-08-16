#!/usr/bin/env python3
"""Verify the first MaxHook KID/key-material reads and 64-hex decoding."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def select_events(directory: Path, session_index: int, call_id: int) -> list[dict]:
    selected = []
    current_session = -1
    for raw in (directory / "events.jsonl").read_text(encoding="utf-8").splitlines():
        event = json.loads(raw)
        if event.get("kind") == "encrypt_hook_installed":
            current_session += 1
            continue
        if current_session == session_index and int(event.get("call_id", -1)) == call_id:
            selected.append(event)
    if not selected:
        raise ValueError("boundary call not found")
    return selected


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--emulation-json", type=Path, required=True)
    parser.add_argument("--boundary-dir", type=Path, required=True)
    parser.add_argument("--boundary-session", type=int, required=True)
    parser.add_argument("--boundary-call", type=int, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    emulation = json.loads(args.emulation_json.read_text(encoding="utf-8"))
    selected = select_events(
        args.boundary_dir, args.boundary_session, args.boundary_call
    )
    string_events = {
        event["label"]: event
        for event in selected
        if event.get("kind") == "encrypt_string" and event.get("phase") == "input"
    }
    kid_path = args.boundary_dir / string_events["input32"]["file"]
    key_path = args.boundary_dir / string_events["input64"]["file"]
    kid_ascii = kid_path.read_bytes()
    key_ascii = key_path.read_bytes()
    if len(kid_ascii) != 32 or len(key_ascii) != 64:
        raise ValueError("unexpected captured KID/key lengths")
    decoded_key = bytes.fromhex(key_ascii.decode("ascii"))

    accesses = emulation["watched_memory_accesses"]
    kid_reads = [item for item in accesses if item["label"] == "kid_data"]
    key_reads = [item for item in accesses if item["label"] == "key_material_data"]
    key_scan = [item for item in key_reads if item["rip"] == "0x180322e30"]
    key_decode = [
        item
        for item in key_reads
        if item["rip"] in {"0x1804ad4e8", "0x1804ad566"}
    ]
    if [item["offset"] for item in kid_reads] != list(range(32)):
        raise ValueError("KID scan is not one sequential 32-byte pass")
    if {item["rip"] for item in kid_reads} != {"0x180322e30"}:
        raise ValueError("unexpected KID reader")
    if [item["offset"] for item in key_scan] != list(range(64)):
        raise ValueError("key scan is not one sequential 64-byte pass")
    if [item["offset"] for item in key_decode] != list(range(64)):
        raise ValueError("key decode is not one sequential 64-byte pass")
    for item in key_decode:
        wanted = "0x1804ad4e8" if item["offset"] % 2 == 0 else "0x1804ad566"
        if item["rip"] != wanted:
            raise ValueError("key decoder even/odd reader mismatch")

    writes = [
        item
        for item in emulation["heap_writes"]
        if item["rip"] == "0x18001c563"
        and item.get("allocation", {}).get("reason") == "MaxHook CRT allocator"
    ]
    if len(writes) != 32:
        raise ValueError(f"expected 32 decoded-key writes, got {len(writes)}")
    base = int(writes[0]["allocation"]["pointer"], 16)
    if [int(item["address"], 16) - base for item in writes] != list(range(32)):
        raise ValueError("decoded-key heap offsets are not sequential")
    decoded_heap = bytes(int(item["value"], 16) & 0xFF for item in writes)
    if decoded_heap != decoded_key:
        raise ValueError("heap output does not equal bytes.fromhex(input64)")

    label_counts = {}
    for item in accesses:
        key = f"{item['label']}:{item['access']}"
        label_counts[key] = label_counts.get(key, 0) + 1

    result = {
        "schema": "maxhook.vm.input-accesses/v1",
        "boundary_selection": {
            "session": args.boundary_session,
            "call": args.boundary_call,
            "kid_ascii_bytes": len(kid_ascii),
            "key_material_ascii_bytes": len(key_ascii),
        },
        "first_input_reads": {
            "kid": {
                "reader": "0x180322e30",
                "offsets": [0, 31],
                "read_count": len(kid_reads),
                "semantics": "sequential character scan",
            },
            "key_material_validation": {
                "reader": "0x180322e30",
                "offsets": [0, 63],
                "read_count": len(key_scan),
                "semantics": "sequential character scan",
            },
            "key_material_decode": {
                "even_reader": "0x1804ad4e8",
                "odd_reader": "0x1804ad566",
                "offsets": [0, 63],
                "read_count": len(key_decode),
                "heap_writer": "0x18001c563",
                "heap_allocation": hex(base),
                "decoded_bytes": len(decoded_heap),
                "decoded_hex": decoded_heap.hex(),
                "equals_bytes_fromhex_input64": True,
            },
        },
        "access_counts": dict(sorted(label_counts.items())),
        "plaintext_or_output_access_observed": any(
            item["label"] in {"plaintext_object", "plaintext_data", "output_object"}
            for item in accesses
        ),
        "emulation_end": {
            "instruction_count": emulation["instruction_count"],
            "error": emulation["error"],
            "invalid_memory": emulation["invalid_memory"],
        },
        "inputs": {
            "emulation_json_sha256": sha256_file(args.emulation_json),
            "kid_file_sha256": sha256_file(kid_path),
            "key_material_file_sha256": sha256_file(key_path),
        },
    }
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(f"wrote {args.output.resolve()}")
    print(
        f"kid_scan={len(kid_reads)} key_scan={len(key_scan)} "
        f"key_decode={len(key_decode)} decoded={decoded_heap.hex()}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
