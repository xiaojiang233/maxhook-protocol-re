#!/usr/bin/env python3
"""Recover first-translation control-flow candidates from capped VM captures.

The capture increments counters inside Stalker's transform callback, so they
are translation counts, not execution counts.  Stable sorting means addresses
within one count bucket retain Map insertion (first-translation) order.  The
tool validates that limited ordering against static successors.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import struct
import sys
from pathlib import Path

LOCAL_DEPS = Path(__file__).resolve().with_name(".pydeps")
if LOCAL_DEPS.is_dir():
    sys.path.insert(0, str(LOCAL_DEPS))

from capstone import (  # noqa: E402
    CS_ARCH_X86,
    CS_GRP_CALL,
    CS_GRP_JUMP,
    CS_GRP_RET,
    CS_MODE_64,
    Cs,
)
from capstone.x86_const import X86_INS_JMP, X86_OP_IMM, X86_OP_REG  # noqa: E402


BUGLAND_BASE = 0x180980000
OLD_TABLE_VA = 0x180C64EBD
OLD_TABLE_COUNT = 0x64C
DISPATCH_BRIDGE = 0x1809DEE32
DISPATCH_HELPER = 0x1809A57E6
DISPATCH_JUMP = 0x1809A585F


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def read_capture(path: Path) -> list[tuple[int, int]]:
    rows: list[tuple[int, int]] = []
    for line_no, raw in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        line = raw.strip()
        if not line:
            continue
        address_text, separator, count_text = line.rpartition(":")
        if not separator:
            raise ValueError(f"{path}:{line_no}: address:count format required")
        rows.append((int(address_text, 16), int(count_text, 10)))
    counts = [count for _, count in rows]
    if any(left < right for left, right in zip(counts, counts[1:])):
        raise ValueError(f"{path}: translation counts are not sorted non-increasingly")
    if len({address for address, _ in rows}) != len(rows):
        raise ValueError(f"{path}: duplicate addresses")
    return rows


def read_table(blob: bytes) -> tuple[list[int], dict[int, list[int]]]:
    offset = OLD_TABLE_VA - BUGLAND_BASE
    table = list(struct.unpack_from(f"<{OLD_TABLE_COUNT}Q", blob, offset))
    reverse: dict[int, list[int]] = {}
    for index, address in enumerate(table):
        reverse.setdefault(address, []).append(index)
    return table, reverse


def decode_one(md: Cs, blob: bytes, address: int):
    offset = address - BUGLAND_BASE
    if offset < 0 or offset >= len(blob):
        return None
    return next(md.disasm(blob[offset : offset + 15], address, count=1), None)


def direct_successors(instruction) -> set[int]:
    fallthrough = instruction.address + instruction.size
    if instruction.group(CS_GRP_RET):
        return set()
    if instruction.group(CS_GRP_JUMP):
        result = set()
        if instruction.operands and instruction.operands[0].type == X86_OP_IMM:
            result.add(instruction.operands[0].imm & ((1 << 64) - 1))
        if instruction.id != X86_INS_JMP:
            result.add(fallthrough)
        return result
    if instruction.group(CS_GRP_CALL):
        result = {fallthrough}
        if instruction.operands and instruction.operands[0].type == X86_OP_IMM:
            result.add(instruction.operands[0].imm & ((1 << 64) - 1))
        return result
    return {fallthrough}


def table_indices(reverse_table: dict[int, list[int]], address: int) -> list[str]:
    return [hex(index) for index in reverse_table.get(address, [])]


def detect_context_offset_chains(
    rows: list[tuple[int, int]], start: int, end: int, md: Cs, blob: bytes
) -> dict:
    instructions = []
    for address, _ in rows[start : end + 1]:
        instruction = decode_one(md, blob, address)
        if instruction is not None:
            instructions.append(instruction)
    evidence = []
    for index, instruction in enumerate(instructions):
        if (
            instruction.mnemonic != "mov"
            or len(instruction.operands) < 2
            or instruction.operands[0].type != X86_OP_REG
            or instruction.operands[1].type != X86_OP_REG
            or instruction.reg_name(instruction.operands[1].reg) != "rbp"
        ):
            continue
        destination = instruction.operands[0].reg
        for candidate in instructions[index + 1 : index + 13]:
            if (
                candidate.mnemonic == "add"
                and len(candidate.operands) >= 2
                and candidate.operands[0].type == X86_OP_REG
                and candidate.operands[0].reg == destination
                and candidate.operands[1].type == X86_OP_IMM
            ):
                evidence.append(
                    {
                        "mov_rbp": hex(instruction.address),
                        "register": instruction.reg_name(destination),
                        "add": hex(candidate.address),
                        "offset": hex(candidate.operands[1].imm),
                    }
                )
                break
    offsets = sorted({int(item["offset"], 16) for item in evidence})
    return {
        "segment_translated_instruction_count": len(instructions),
        "rbp_derived_offsets": [hex(offset) for offset in offsets],
        "has_key_vip_table_signature": all(offset in offsets for offset in (0xA, 0x6D, 0x85)),
        "evidence": evidence,
    }


def analyze_call(
    path: Path,
    md: Cs,
    blob: bytes,
    table: list[int],
    reverse_table: dict[int, list[int]],
    max_indirect: int,
) -> dict:
    rows = read_capture(path)
    address_to_count = dict(rows)
    dispatch_positions = [
        index for index, (address, count) in enumerate(rows) if address == DISPATCH_JUMP and count == 1
    ]
    if len(dispatch_positions) != 1:
        raise ValueError(f"{path}: expected one count=1 dispatch jump, got {dispatch_positions}")
    dispatch_position = dispatch_positions[0]
    if dispatch_position + 1 >= len(rows):
        raise ValueError(f"{path}: dispatch jump is last remembered address")
    first_new_address, first_new_count = rows[dispatch_position + 1]

    table_hit_counts = [address_to_count[address] for address in table if address in address_to_count]
    old_table_hits_above_one = sum(count > 1 for count in table_hit_counts)

    indirect_edges = []
    for position in range(dispatch_position, len(rows) - 1):
        address, count = rows[position]
        if count != 1:
            continue
        instruction = decode_one(md, blob, address)
        if instruction is None or instruction.mnemonic != "jmp":
            continue
        if instruction.operands and instruction.operands[0].type == X86_OP_IMM:
            continue
        next_address, next_count = rows[position + 1]
        indirect_edges.append(
            {
                "position": position,
                "source": hex(address),
                "source_operand": instruction.op_str,
                "next_first_seen_address": hex(next_address),
                "next_count": next_count,
                "next_old_table_indices": table_indices(reverse_table, next_address),
            }
        )
        if len(indirect_edges) >= max_indirect:
            break

    for ordinal, edge in enumerate(indirect_edges):
        segment_start = (
            indirect_edges[ordinal - 1]["position"] + 1
            if ordinal
            else max(0, edge["position"] - 250)
        )
        edge["segment_context_signature"] = detect_context_offset_chains(
            rows, segment_start, edge["position"], md, blob
        )

    first_indirect_position = (
        indirect_edges[1]["position"]
        if len(indirect_edges) > 1 and indirect_edges[0]["source"] == hex(DISPATCH_JUMP)
        else (indirect_edges[0]["position"] if indirect_edges else len(rows) - 1)
    )
    # The dispatch jump itself is position zero of the recovered segment.  The
    # validation window starts at its first-new target and ends at the next
    # indirect jump, where the target is not statically knowable.
    validation_start = dispatch_position + 1
    validation_end = first_indirect_position
    valid_edges = 0
    invalid_edges = []
    for position in range(validation_start, validation_end):
        address, count = rows[position]
        next_address, next_count = rows[position + 1]
        if count != 1 or next_count != 1:
            invalid_edges.append(
                {
                    "position": position,
                    "source": hex(address),
                    "next": hex(next_address),
                    "reason": "crosses_translation_count_bucket",
                }
            )
            continue
        instruction = decode_one(md, blob, address)
        if instruction is None:
            invalid_edges.append(
                {
                    "position": position,
                    "source": hex(address),
                    "next": hex(next_address),
                    "reason": "decode_failed_or_outside_bugland",
                }
            )
            continue
        expected = direct_successors(instruction)
        if next_address in expected:
            valid_edges += 1
        else:
            invalid_edges.append(
                {
                    "position": position,
                    "source": hex(address),
                    "instruction": f"{instruction.mnemonic} {instruction.op_str}".strip(),
                    "next": hex(next_address),
                    "expected_direct_successors": [hex(item) for item in sorted(expected)],
                }
            )
    checked_edges = max(0, validation_end - validation_start)

    return {
        "file": str(path.resolve()),
        "sha256": sha256_file(path),
        "remembered_addresses": len(rows),
        "dispatch_jump_position": dispatch_position,
        "dispatch_jump_translation_count": address_to_count[DISPATCH_JUMP],
        "first_new_after_dispatch": {
            "address": hex(first_new_address),
            "count": first_new_count,
            "old_table_indices": table_indices(reverse_table, first_new_address),
        },
        "old_table_hits": len(table_hit_counts),
        "old_table_hits_above_translation_count_one": old_table_hits_above_one,
        "first_translation_segment_static_continuity": {
            "start": hex(first_new_address),
            "end_indirect_jump": indirect_edges[1]["source"] if len(indirect_edges) > 1 else None,
            "checked_edges": checked_edges,
            "valid_direct_edges": valid_edges,
            "valid_ratio": round(valid_edges / checked_edges, 6) if checked_edges else None,
            "invalid_edges": invalid_edges,
        },
        "indirect_first_seen_edge_candidates": indirect_edges,
        "indirect_edges_with_key_vip_table_signature": sum(
            edge["segment_context_signature"]["has_key_vip_table_signature"]
            for edge in indirect_edges
        ),
    }


def longest_common_indirect_prefix(calls: list[dict]) -> list[dict]:
    edge_lists = [call["indirect_first_seen_edge_candidates"] for call in calls]
    result = []
    for ordinal, edge_tuple in enumerate(zip(*edge_lists)):
        signature = {
            (
                edge["source"],
                edge["source_operand"],
                edge["next_first_seen_address"],
                tuple(edge["next_old_table_indices"]),
            )
            for edge in edge_tuple
        }
        if len(signature) != 1:
            break
        source, operand, target, indices = next(iter(signature))
        result.append(
            {
                "ordinal": ordinal,
                "source": source,
                "source_operand": operand,
                "next_first_seen_address": target,
                "next_old_table_indices": list(indices),
            }
        )
    return result


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--capture", type=Path, required=True)
    parser.add_argument("--runtime-bugland", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--max-indirect", type=int, default=32)
    args = parser.parse_args()

    blob = args.runtime_bugland.read_bytes()
    table, reverse_table = read_table(blob)
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    md.detail = True

    bridge_instruction = decode_one(md, blob, DISPATCH_BRIDGE)
    if bridge_instruction is None:
        raise ValueError("cannot decode dispatch bridge")
    bridge_successors = direct_successors(bridge_instruction)
    if bridge_successors != {DISPATCH_HELPER}:
        raise ValueError(f"unexpected bridge successors: {bridge_successors}")

    paths = sorted(args.capture.glob("vm_addrs_call*.txt"))
    if not paths:
        raise ValueError(f"no vm_addrs_call*.txt under {args.capture}")
    calls = [
        analyze_call(path, md, blob, table, reverse_table, args.max_indirect)
        for path in paths
    ]
    first_target_signatures = {
        (
            call["first_new_after_dispatch"]["address"],
            tuple(call["first_new_after_dispatch"]["old_table_indices"]),
        )
        for call in calls
    }
    result = {
        "schema": "maxhook.vm.prefix-edges/v2",
        "method": {
            "capture_sort": (
                "transform-callback translation count descending; equal-count order treated "
                "as stable Map first-translation insertion order"
            ),
            "empirical_guard": "first-translation segment is checked against decoded direct successors",
            "caveat": (
                "After an indirect jump, next_first_seen_address is only the next newly translated address. "
                "It is not proven to be the immediate runtime target because that target may already be "
                "present in Stalker's translation cache. Translation count 1 does not mean execution count 1."
            ),
        },
        "dispatch": {
            "bridge": hex(DISPATCH_BRIDGE),
            "bridge_old_table_indices": table_indices(reverse_table, DISPATCH_BRIDGE),
            "bridge_instruction": f"{bridge_instruction.mnemonic} {bridge_instruction.op_str}",
            "helper": hex(DISPATCH_HELPER),
            "indirect_jump": hex(DISPATCH_JUMP),
            "first_new_candidate_consistent_across_calls": len(first_target_signatures) == 1,
            "first_new_candidate_signature": (
                {
                    "address": next(iter(first_target_signatures))[0],
                    "old_table_indices": list(next(iter(first_target_signatures))[1]),
                }
                if len(first_target_signatures) == 1
                else None
            ),
        },
        "longest_common_indirect_first_translation_prefix": longest_common_indirect_prefix(calls),
        "calls": calls,
        "inputs": {
            "runtime_bugland_sha256": sha256_file(args.runtime_bugland),
        },
    }
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(f"wrote {args.output.resolve()}")
    print(
        "first-new candidate after dispatch:",
        result["dispatch"]["first_new_candidate_signature"],
        "consistent=",
        result["dispatch"]["first_new_candidate_consistent_across_calls"],
    )
    print(
        "common indirect first-translation prefix:",
        len(result["longest_common_indirect_first_translation_prefix"]),
    )
    for call in calls:
        continuity = call["first_translation_segment_static_continuity"]
        print(
            f"{Path(call['file']).name}: target={call['first_new_after_dispatch']} "
            f"continuity={continuity['valid_direct_edges']}/{continuity['checked_edges']} "
            f"old_table_hits_above_translation_count_one="
            f"{call['old_table_hits_above_translation_count_one']}"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
