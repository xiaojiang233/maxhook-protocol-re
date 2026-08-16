#!/usr/bin/env python3
"""Find the first cross-call first-translation branch variant."""

from __future__ import annotations

import argparse
import hashlib
import json
import sys
from collections import Counter
from pathlib import Path

LOCAL_DEPS = Path(__file__).resolve().with_name(".pydeps")
if LOCAL_DEPS.is_dir():
    sys.path.insert(0, str(LOCAL_DEPS))

from capstone import CS_ARCH_X86, CS_MODE_64, Cs  # noqa: E402
from capstone.x86_const import X86_OP_IMM  # noqa: E402

from recover_maxhook_vm_prefix_edges import (  # noqa: E402
    BUGLAND_BASE,
    DISPATCH_JUMP,
    decode_one,
    direct_successors,
    read_capture,
    sha256_file,
)


BRANCH_DISPATCH_ORDINAL = 11
RECONVERGED_DISPATCH_ORDINAL = 12


def indirect_positions(rows, md: Cs, blob: bytes) -> list[int]:
    start = rows.index((DISPATCH_JUMP, 1))
    result = []
    for position in range(start, len(rows)):
        address, count = rows[position]
        if count != 1:
            continue
        instruction = decode_one(md, blob, address)
        if instruction is None or instruction.mnemonic != "jmp":
            continue
        if instruction.operands and instruction.operands[0].type == X86_OP_IMM:
            continue
        result.append(position)
    return result


def set_hash(addresses: set[int]) -> str:
    payload = b"".join(address.to_bytes(8, "little") for address in sorted(addresses))
    return hashlib.sha256(payload).hexdigest()


def ordered_extra_chain(
    start: int, extra: set[int], md: Cs, blob: bytes
) -> tuple[list[dict], int | None]:
    current = start
    seen = set()
    result = []
    exit_address = None
    while current in extra and current not in seen:
        seen.add(current)
        instruction = decode_one(md, blob, current)
        if instruction is None:
            break
        result.append(
            {
                "address": hex(current),
                "bytes": instruction.bytes.hex(),
                "mnemonic": instruction.mnemonic,
                "op_str": instruction.op_str,
            }
        )
        successors = direct_successors(instruction)
        if len(successors) != 1:
            break
        successor = next(iter(successors))
        if successor not in extra:
            exit_address = successor
            break
        current = successor
    if seen != extra:
        missing = ", ".join(hex(address) for address in sorted(extra - seen))
        raise ValueError(f"extra-address CFG chain did not cover: {missing}")
    return result, exit_address


def recognize_zero_store(chain: list[dict]) -> dict:
    signature = [(item["mnemonic"], item["op_str"]) for item in chain]
    if len(signature) != 12:
        return {"matched": False}
    expected_mnemonics = [
        "push",
        "jmp",
        "push",
        "push",
        "mov",
        "add",
        "add",
        "xor",
        "jmp",
        "mov",
        "mov",
        "add",
    ]
    if [mnemonic for mnemonic, _ in signature] != expected_mnemonics:
        return {"matched": False}
    first_immediate = int(signature[2][1], 0) & 0xFFFFFFFF
    xor_parts = signature[7][1].split(",")
    try:
        xor_immediate = int(xor_parts[-1].strip(), 0) & 0xFFFFFFFF
    except (ValueError, IndexError):
        return {"matched": False}
    operand_checks = [
        signature[0][1] == "rdi",
        signature[3][1] == "qword ptr [rsp]",
        signature[4][1] == "rdi, qword ptr [rsp]",
        signature[5][1] == "rsp, 8",
        signature[6][1] == "rsp, 8",
        xor_parts[0].strip() == "edi",
        first_immediate == xor_immediate,
        signature[9][1] == "qword ptr [rbx], rdi",
        signature[10][1] == "rdi, qword ptr [rsp]",
        signature[11][1] == "rsp, 8",
    ]
    matched = all(operand_checks)
    return {
        "matched": matched,
        "constant": hex(first_immediate) if matched else None,
        "net_effect": (
            "qword[RBX] = 0; original RDI restored; stack pointer restored"
            if matched
            else None
        ),
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--capture", type=Path, required=True)
    parser.add_argument("--runtime-bugland", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    blob = args.runtime_bugland.read_bytes()
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    md.detail = True
    calls = []
    for path in sorted(args.capture.glob("vm_addrs_call*.txt")):
        rows = read_capture(path)
        positions = indirect_positions(rows, md, blob)
        if len(positions) <= RECONVERGED_DISPATCH_ORDINAL:
            raise ValueError(f"{path}: not enough indirect dispatches")
        branch_position = positions[BRANCH_DISPATCH_ORDINAL]
        reconverged_position = positions[RECONVERGED_DISPATCH_ORDINAL]
        segment_rows = rows[branch_position + 1 : reconverged_position + 1]
        segment_set = {address for address, _ in segment_rows}
        calls.append(
            {
                "file": str(path.resolve()),
                "sha256": sha256_file(path),
                "branch_dispatch_source": hex(rows[branch_position][0]),
                "first_new_after_branch_dispatch": hex(rows[branch_position + 1][0]),
                "reconverged_dispatch_source": hex(rows[reconverged_position][0]),
                "segment_first_translation_addresses": len(segment_set),
                "segment_set_sha256": set_hash(segment_set),
                "_segment_set": segment_set,
            }
        )

    clusters = Counter(call["segment_set_sha256"] for call in calls)
    baseline_hash, baseline_frequency = clusters.most_common(1)[0]
    baseline_set = next(
        call["_segment_set"] for call in calls if call["segment_set_sha256"] == baseline_hash
    )
    variants = []
    for variant_hash in sorted(clusters):
        variant_calls = [call for call in calls if call["segment_set_sha256"] == variant_hash]
        variant_set = variant_calls[0]["_segment_set"]
        extra = variant_set - baseline_set
        missing = baseline_set - variant_set
        chain = []
        exit_address = None
        recognition = None
        if extra:
            starts = {
                int(call["first_new_after_branch_dispatch"], 16)
                for call in variant_calls
            }
            if len(starts) == 1 and next(iter(starts)) in extra:
                chain, exit_address = ordered_extra_chain(next(iter(starts)), extra, md, blob)
                recognition = recognize_zero_store(chain)
        variants.append(
            {
                "segment_set_sha256": variant_hash,
                "call_files": [Path(call["file"]).name for call in variant_calls],
                "frequency": len(variant_calls),
                "is_baseline_majority": variant_hash == baseline_hash,
                "segment_first_translation_addresses": len(variant_set),
                "extra_vs_baseline": [hex(address) for address in sorted(extra)],
                "missing_vs_baseline": [hex(address) for address in sorted(missing)],
                "extra_cfg_chain": chain,
                "extra_cfg_exit": hex(exit_address) if exit_address is not None else None,
                "recognized_effect": recognition,
            }
        )

    for call in calls:
        del call["_segment_set"]
    result = {
        "schema": "maxhook.vm.branch-variants/v2",
        "dispatch_ordinals": {
            "branch": BRANCH_DISPATCH_ORDINAL,
            "reconverged": RECONVERGED_DISPATCH_ORDINAL,
        },
        "branch_dispatch_source_consistent": len(
            {call["branch_dispatch_source"] for call in calls}
        )
        == 1,
        "reconverged_dispatch_source_consistent": len(
            {call["reconverged_dispatch_source"] for call in calls}
        )
        == 1,
        "baseline": {
            "segment_set_sha256": baseline_hash,
            "frequency": baseline_frequency,
            "call_count": len(calls),
        },
        "variants": variants,
        "calls": calls,
        "inputs": {"runtime_bugland_sha256": sha256_file(args.runtime_bugland)},
        "limits": [
            "The branch trigger value is not present in the address-only capture.",
            "RBX's concrete pointee is unknown because already-translated addresses are outside the translation-count=1 ordering slice.",
            "The extra block has zero-store semantics if entered; transform counts are not runtime hit counts.",
            "This does not prove that the branch depends specifically on plaintext or nonce.",
        ],
    }
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(f"wrote {args.output.resolve()}")
    print(f"clusters={dict(clusters)} baseline_frequency={baseline_frequency}/{len(calls)}")
    for variant in variants:
        if variant["extra_vs_baseline"]:
            print(
                f"variant calls={variant['call_files']} extra={len(variant['extra_vs_baseline'])} "
                f"effect={variant['recognized_effect']}"
            )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
