#!/usr/bin/env python3
"""Audit MaxHook VM Stalker translation captures without crypto material.

The capture script increments counters inside Stalker's transform callback.
Those counters describe translated instruction instances, not runtime hits.
It also stops remembering new instruction addresses at MAX_UNIQ.  This tool
keeps those evidence classes separate and measures older-table overlap.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import re
import struct
from collections import Counter
from pathlib import Path


IMAGE_BASE = 0x180000000
BUGLAND_BASE = 0x180980000
BUGLAND_END = 0x181EFC000
OLD_TABLE_VA = 0x180C64EBD
OLD_TABLE_COUNT = 0x64C
ANCHORS = {
    "crypto_vm_entry": 0x181523001,
    "outer_dispatcher": 0x180C43FDD,
    "dispatch_helper": 0x1809A57E6,
    "dispatch_indirect_jump": 0x1809A585F,
}


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def parse_mnemonics(text: str) -> dict[str, int]:
    result: dict[str, int] = {}
    for item in text.split(","):
        if not item:
            continue
        name, count = item.rsplit(":", 1)
        result[name] = int(count)
    return result


def parse_address_file(path: Path) -> tuple[dict[int, int], str]:
    addresses: dict[int, int] = {}
    saw_count = False
    saw_plain = False
    for line_no, raw in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        line = raw.strip()
        if not line:
            continue
        if ":" in line:
            address_text, count_text = line.rsplit(":", 1)
            saw_count = True
            count = int(count_text, 10)
        else:
            address_text = line
            saw_plain = True
            count = 1
        address = int(address_text, 16)
        if address in addresses:
            raise ValueError(f"duplicate address in {path}:{line_no}: {address_text}")
        addresses[address] = count
    if saw_count and saw_plain:
        fmt = "mixed"
    elif saw_count:
        fmt = "address:count"
    else:
        fmt = "address-only"
    return addresses, fmt


def load_capture(directory: Path) -> dict:
    summary_path = directory / "capture_summary.json"
    summary = json.loads(summary_path.read_text(encoding="utf-8"))
    calls = []
    for item in summary["summaries"]:
        call_id = int(item["call_id"])
        addresses_path = directory / f"vm_addrs_call{call_id}.txt"
        address_counts, address_format = parse_address_file(addresses_path)
        declared_unique = int(item["unique_addresses"])
        if declared_unique != len(address_counts):
            raise ValueError(
                f"{directory.name} call {call_id}: declared {declared_unique} unique, "
                f"file has {len(address_counts)}"
            )
        calls.append(
            {
                "call_id": call_id,
                "total_instructions": int(item["total_instructions"]),
                "unique_addresses": declared_unique,
                "address_format": address_format,
                "address_counts": address_counts,
                "mnemonics": parse_mnemonics(item["top_mnemonics"]),
                "addresses_file": addresses_path,
            }
        )
    return {
        "directory": directory,
        "summary_path": summary_path,
        "schema": summary.get("schema"),
        "calls": calls,
    }


def parse_capture_caps(script_path: Path) -> dict[str, int]:
    source = script_path.read_text(encoding="utf-8")
    result = {}
    for name in ("MAX_TOTAL", "MAX_UNIQ"):
        match = re.search(rf"\b{name}\s*=\s*(\d+)", source)
        if not match:
            raise ValueError(f"cannot find {name} in {script_path}")
        result[name.lower()] = int(match.group(1))
    return result


def read_old_handler_table(runtime_path: Path) -> list[int]:
    data = runtime_path.read_bytes()
    offset = OLD_TABLE_VA - BUGLAND_BASE
    needed = offset + OLD_TABLE_COUNT * 8
    if offset < 0 or needed > len(data):
        raise ValueError("old handler table does not fit runtime_bugland2.bin")
    return list(struct.unpack_from(f"<{OLD_TABLE_COUNT}Q", data, offset))


def parse_disassembly_universe(path: Path) -> set[int]:
    result: set[int] = set()
    line_pattern = re.compile(rb"^0x([0-9a-fA-F]+):")
    with path.open("rb") as stream:
        for raw in stream:
            match = line_pattern.match(raw)
            if match:
                address = int(match.group(1), 16)
                if BUGLAND_BASE <= address < BUGLAND_END:
                    result.add(address)
    return result


def population_enrichment(
    population: set[int], sample: set[int], marked: set[int]
) -> dict[str, float | int | None]:
    sample = sample & population
    marked = marked & population
    observed = len(sample & marked)
    population_size = len(population)
    sample_size = len(sample)
    marked_size = len(marked)
    expected = (sample_size * marked_size / population_size) if population_size else 0.0
    if population_size > 1:
        probability = marked_size / population_size
        variance = (
            sample_size
            * probability
            * (1.0 - probability)
            * (population_size - sample_size)
            / (population_size - 1)
        )
    else:
        variance = 0.0
    z_score = (observed - expected) / math.sqrt(variance) if variance > 0 else None
    return {
        "population_instruction_starts": population_size,
        "sample_instruction_starts": sample_size,
        "marked_table_entries": marked_size,
        "observed_table_entries": observed,
        "expected_if_uniform": round(expected, 4),
        "observed_over_expected": round(observed / expected, 4) if expected else None,
        "approx_hypergeometric_z": round(z_score, 4) if z_score is not None else None,
    }


def summarize_capture(
    capture: dict,
    caps: dict[str, int],
    capture_unique_cap: int,
    capture_unique_cap_source: str,
    table: list[int],
    universe: set[int],
) -> dict:
    calls = capture["calls"]
    sets = [set(call["address_counts"]) for call in calls]
    intersection = set.intersection(*sets)
    union = set.union(*sets)
    table_set = set(table)
    total_values = [call["total_instructions"] for call in calls]
    unique_values = [call["unique_addresses"] for call in calls]
    histogram_keys = sorted(set().union(*(call["mnemonics"] for call in calls)))
    histogram_ranges = {
        key: {
            "min": min(call["mnemonics"].get(key, 0) for call in calls),
            "max": max(call["mnemonics"].get(key, 0) for call in calls),
        }
        for key in histogram_keys
    }

    call_rows = []
    for call, address_set in zip(calls, sets):
        in_bugland = {address for address in address_set if BUGLAND_BASE <= address < BUGLAND_END}
        system = {address for address in address_set if address >= 0x7FF000000000}
        table_hit_counts = [
            call["address_counts"][address]
            for address in table_set
            if address in call["address_counts"]
        ]
        call_rows.append(
            {
                "call_id": call["call_id"],
                "transformed_instruction_instances": call["total_instructions"],
                "remembered_unique_addresses": call["unique_addresses"],
                "address_format": call["address_format"],
                "hit_unique_cap": call["unique_addresses"] == capture_unique_cap,
                "hit_transform_instance_cap": call["total_instructions"] >= caps["max_total"],
                "remembered_bugland_addresses": len(in_bugland),
                "remembered_system_addresses": len(system),
                "old_table_entry_hits": len(address_set & table_set),
                "old_table_entry_translation_count_histogram": {
                    str(count): frequency
                    for count, frequency in sorted(Counter(table_hit_counts).items())
                },
                "anchors": {
                    name: {
                        "present": address in address_set,
                        "recorded_translation_count": call["address_counts"].get(address),
                    }
                    for name, address in ANCHORS.items()
                },
                "sha256": sha256_file(call["addresses_file"]),
            }
        )

    pairwise_identical = []
    for left_index, left in enumerate(calls):
        for right_index in range(left_index + 1, len(calls)):
            right = calls[right_index]
            if left["address_counts"] == right["address_counts"]:
                pairwise_identical.append(
                    {
                        "left_call": left["call_id"],
                        "right_call": right["call_id"],
                        "transformed_instruction_instance_delta": right["total_instructions"]
                        - left["total_instructions"],
                    }
                )

    return {
        "directory": str(capture["directory"].resolve()),
        "capture_schema": capture["schema"],
        "call_count": len(calls),
        "translation_statistics": {
            "transformed_instruction_instances_min": min(total_values),
            "transformed_instruction_instances_max": max(total_values),
            "transformed_instruction_instances_range": max(total_values) - min(total_values),
            "translated_mnemonic_ranges": histogram_ranges,
            "note": (
                "Counters are incremented in Stalker transform(iterator), so they measure "
                "translation/retranslation instances, not runtime instruction executions."
            ),
        },
        "address_detail": {
            "effective_unique_cap": capture_unique_cap,
            "effective_unique_cap_source": capture_unique_cap_source,
            "remembered_unique_min": min(unique_values),
            "remembered_unique_max": max(unique_values),
            "all_calls_hit_unique_cap": all(value == capture_unique_cap for value in unique_values),
            "intersection_size": len(intersection),
            "union_size": len(union),
            "variable_membership_size": len(union - intersection),
            "pairwise_identical_address_count_maps": pairwise_identical,
            "note": (
                "Address files are a MAX_UNIQ-capped set in first-translation Map insertion order "
                "within equal translation-count buckets; they are not an execution trace."
            ),
        },
        "old_table_overlap": {
            "intersection_hits": len(intersection & table_set),
            "union_hits": len(union & table_set),
            "intersection_enrichment": population_enrichment(
                universe,
                {address for address in intersection if BUGLAND_BASE <= address < BUGLAND_END},
                table_set,
            ),
            "union_enrichment": population_enrichment(
                universe,
                {address for address in union if BUGLAND_BASE <= address < BUGLAND_END},
                table_set,
            ),
        },
        "calls": call_rows,
        "capture_summary_sha256": sha256_file(capture["summary_path"]),
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--capture", action="append", type=Path, required=True)
    parser.add_argument("--capture-script", type=Path, required=True)
    parser.add_argument("--runtime-bugland", type=Path, required=True)
    parser.add_argument("--disassembly", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument(
        "--capture-cap",
        action="append",
        default=[],
        metavar="DIRECTORY=LIMIT",
        help="historical MAX_UNIQ for a capture directory; defaults to the current script limit",
    )
    args = parser.parse_args()

    cap_overrides: dict[Path, int] = {}
    for raw in args.capture_cap:
        directory_text, separator, limit_text = raw.rpartition("=")
        if not separator or not directory_text:
            raise ValueError(f"invalid --capture-cap {raw!r}; expected DIRECTORY=LIMIT")
        cap_overrides[Path(directory_text).resolve()] = int(limit_text, 0)

    caps = parse_capture_caps(args.capture_script)
    table = read_old_handler_table(args.runtime_bugland)
    valid_table = [address for address in table if BUGLAND_BASE <= address < BUGLAND_END]
    if len(valid_table) != OLD_TABLE_COUNT:
        raise ValueError(
            f"expected {OLD_TABLE_COUNT} contiguous .bugland table entries, got {len(valid_table)}"
        )
    universe = parse_disassembly_universe(args.disassembly)
    if not universe:
        raise ValueError("disassembly universe is empty")

    captures = [load_capture(path) for path in args.capture]
    result = {
        "schema": "maxhook.vm.trace-coverage/v2",
        "limits_from_capture_script": caps,
        "ranges": {
            "image_base": hex(IMAGE_BASE),
            "bugland": [hex(BUGLAND_BASE), hex(BUGLAND_END)],
        },
        "anchors": {name: hex(address) for name, address in ANCHORS.items()},
        "old_handler_table": {
            "table_va": hex(OLD_TABLE_VA),
            "entry_count": OLD_TABLE_COUNT,
            "index_range": ["0x0", hex(OLD_TABLE_COUNT - 1)],
            "all_entries_point_into_bugland": True,
            "terminology": (
                "This is the runtime qword dispatch table. The executable range "
                "0x180c0c000-0x180c0d300 is VM code, not this table."
            ),
        },
        "static_instruction_universe": {
            "bugland_instruction_starts": len(universe),
            "source_sha256": sha256_file(args.disassembly),
        },
        "captures": [
            summarize_capture(
                capture,
                caps,
                cap_overrides.get(capture["directory"].resolve(), caps["max_uniq"]),
                (
                    "explicit_historical_override"
                    if capture["directory"].resolve() in cap_overrides
                    else "current_capture_script"
                ),
                table,
                universe,
            )
            for capture in captures
        ],
        "inputs": {
            "capture_script_sha256": sha256_file(args.capture_script),
            "runtime_bugland_sha256": sha256_file(args.runtime_bugland),
        },
        "interpretation_limits": [
            "The address detail is not a runtime chronological trace and cannot by itself identify a dispatched handler.",
            "Counts are transform-callback translation counts, not execution frequencies.",
            "Translation counts are retained only for addresses remembered before MAX_UNIQ was reached.",
            "A table-entry overlap does not prove that the corresponding table index was selected.",
            "The old runtime dump is asynchronous and cannot supply the real capture's key/VIP state.",
        ],
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"wrote {args.output.resolve()}")
    for capture in result["captures"]:
        detail = capture["address_detail"]
        overlap = capture["old_table_overlap"]["intersection_enrichment"]
        print(
            f"{Path(capture['directory']).name}: calls={capture['call_count']} "
            f"intersection={detail['intersection_size']} union={detail['union_size']} "
            f"all_hit_unique_cap={detail['all_calls_hit_unique_cap']} "
            f"table_hits={overlap['observed_table_entries']} "
            f"expected={overlap['expected_if_uniform']}"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
