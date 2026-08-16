#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Extract proven NetEase acSDK/EnvSDK detection artifacts from one dump region.

This is intentionally a strict, read-only evidence extractor for the known
``region_000001efa8d60000.bin`` snapshot.  It validates the source hash, the
expected offset windows, duplicate LuaJIT constant tables, and rule markers
before writing any derived artifact.  The results are acSDK/EnvSDK evidence;
they must not be described as MaxHook VM-internal detection lists.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path
from typing import Any, Iterable


EXPECTED_SOURCE_SHA256 = (
    "ecfa1647be6ddd66a04cdbd1e527a57712cd786f62daf8ebd365518040f17a86"
)
EXPECTED_SOURCE_SIZE = 745_472
REGION_RE = re.compile(r"^region_([0-9a-fA-F]{16})\.bin$")

# Half-open file-offset windows.  Pinning the extractors to these ranges avoids
# silently accepting unrelated literals elsewhere in a future/different dump.
PRIMARY_VM_WINDOW = (0x21000, 0x22000)
DUPLICATE_VM_WINDOW = (0x4A700, 0x4AD00)
COMMON_KEY_WINDOW = (0x28700, 0x28B00)
YARA_WINDOW = (0x2E000, 0x30000)

VM_LISTS: tuple[tuple[str, str, tuple[str, ...]], ...] = (
    (
        "VMware",
        "vmware",
        (
            "vm3dgl64.dll",
            "vm3dgl.dll",
            "vm3dum64.dll",
            "vm3dum.dll",
            "VmbuxCoinstaller.dll",
            "vmGuestLib.dll",
            "vmGuestLibJava.dll",
            "vmhgfs.dll",
            "vmwogl32.dll",
            "vmmreg32.dll",
            "vmx_fb.dll",
            "vmx_mode.dll",
            "VMUpgradeAtShutdownWXP.dll",
        ),
    ),
    (
        "VirtualBox",
        "virtualbox",
        (
            "vboxdisp.dll",
            "vboxhook.dll",
            "vboxmrxnp.dll",
            "vboxogl.dll",
            "vboxoglarrayspu.dll",
            "vboxoglcrutil.dll",
            "vboxoglerrorspu.dll",
            "vboxoglfeedbackspu.dll",
            "vboxoglpackspu.dll",
            "vboxoglpassthroughspu.dll",
            "vboxservice.exe",
            "vboxtray.exe",
            "VBoxControl.exe",
        ),
    ),
    ("QEMU", "qemu", ("qemu-ga.exe",)),
    (
        "Hyper-V",
        "hyperv",
        (
            "VmbusCoinstaller.dll",
            "VmdCoinstall.dll",
            "vmbusres.dll",
            "VMBusVideoD.dll",
            "vmicres.dll",
            "vmstorfltres.dll",
            "vmicsvc.exe",
        ),
    ),
)

CATEGORY_CONSTANT_ORDER = ("real", "hyperv", "qemu", "virtualbox", "vmware")

COMMON_KEY_GROUPS: tuple[tuple[str, tuple[str, ...]], ...] = (
    (
        "鼠标连点",
        (
            "___BBXMouseClick___",
            "___JDBBX_MOUSECLICK__BETA_",
            "___JDBBX_MOUSECLICK___",
            "jdyou0",
        ),
    ),
    ("键盘连按", ("KEY_BOARD_2011_5_9", "jdyou1")),
    ("鼠标录制", ("___JDBBX_MOUSERECODE___",)),
    (
        "简单百宝箱",
        (
            "http://soft.jdbbx.com/",
            "http://jt.soft.jdbbx.com/",
            "JdbbxIsRunning",
        ),
    ),
    (
        "按键精灵",
        (
            "http://pos.baidu.com/",
            "http://ad.vrbrothers.com/",
            "CJProtect_Event_CodeInfo",
            "CJProtect_Event_CodeFlag",
            "_CJProtect_Share_Mem_CodeData_",
            "_CJProtect_Share_Mem_CodeFlag_",
            "292020MMRunning",
        ),
    ),
)

YARA_RULE_NAMES = (
    "X19_NekoLauncher",
    "X19_Akira",
    "X19_0613_module_younkoo",
    "x19_0623_module_Zen",
)


class EvidenceError(RuntimeError):
    """Raised when the dump does not match the pinned evidence layout."""


def parse_args() -> argparse.Namespace:
    here = Path(__file__).resolve().parent
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "region",
        nargs="?",
        type=Path,
        default=here / "dump_out" / "41264" / "region_000001efa8d60000.bin",
        help="known process-dump region containing the acSDK LuaJIT constants",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=here / "acsdk_detection_artifacts.json",
        help="JSON evidence output",
    )
    parser.add_argument(
        "--yara-output",
        type=Path,
        default=None,
        help="optional .yar output assembled from the four verbatim rule spans",
    )
    return parser.parse_args()


def require(condition: bool, message: str) -> None:
    if not condition:
        raise EvidenceError(message)


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def find_all(data: bytes, needle: bytes, start: int = 0, end: int | None = None) -> list[int]:
    require(bool(needle), "empty search needle")
    limit = len(data) if end is None else end
    positions: list[int] = []
    pos = start
    while True:
        pos = data.find(needle, pos, limit)
        if pos < 0:
            return positions
        positions.append(pos)
        pos += len(needle)


def in_window(offset: int, window: tuple[int, int]) -> bool:
    return window[0] <= offset < window[1]


def location(
    source: Path, region_base: int, start: int, end: int | None = None
) -> dict[str, Any]:
    result: dict[str, Any] = {
        "file": str(source),
        "file_offset": start,
        "file_offset_hex": hex(start),
        "virtual_address": region_base + start,
        "virtual_address_hex": hex(region_base + start),
    }
    if end is not None:
        result.update(
            {
                "end_file_offset_exclusive": end,
                "end_file_offset_exclusive_hex": hex(end),
                "end_virtual_address_exclusive": region_base + end,
                "end_virtual_address_exclusive_hex": hex(region_base + end),
                "length": end - start,
            }
        )
    return result


def lj_short_string(value: str) -> bytes:
    raw = value.encode("utf-8")
    # LuaJIT bytecode encodes short string lengths as ULEB128(len + 5).  Every
    # pinned value here is short enough to have a one-byte prefix.
    require(len(raw) + 5 < 0x80, f"value is not a one-byte LuaJIT string: {value!r}")
    return bytes((len(raw) + 5,)) + raw


def decode_lj_short_string(data: bytes, offset: int) -> tuple[str, int]:
    require(offset < len(data), f"string offset outside source: {offset:#x}")
    encoded_length = data[offset]
    require(5 <= encoded_length < 0x80, f"invalid short-string prefix at {offset:#x}")
    length = encoded_length - 5
    end = offset + 1 + length
    require(end <= len(data), f"truncated short string at {offset:#x}")
    try:
        value = data[offset + 1 : end].decode("utf-8")
    except UnicodeDecodeError as exc:
        raise EvidenceError(f"invalid UTF-8 string at {offset:#x}: {exc}") from exc
    return value, end


def parse_lua_list(data: bytes, first_prefix: int) -> tuple[list[str], int, int]:
    """Parse one table's consecutive KGC strings using its four-byte header."""
    header_start = first_prefix - 4
    require(header_start >= 0, f"missing table header at {first_prefix:#x}")
    header = data[header_start:first_prefix]
    require(
        len(header) == 4 and header[0] == 1 and header[2:] == b"\x00\x00",
        f"unexpected LuaJIT table header {header.hex()} at {header_start:#x}",
    )
    entry_count = header[1] - 1  # The additional KGC item is the ``ipairs`` symbol.
    require(entry_count > 0, f"invalid table entry count at {header_start:#x}")

    values: list[str] = []
    cursor = first_prefix
    for _ in range(entry_count):
        value, cursor = decode_lj_short_string(data, cursor)
        values.append(value)
    return values, header_start, cursor


def extract_vm_lists(
    data: bytes, source: Path, region_base: int
) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    families: list[dict[str, Any]] = []
    for family, category, expected_values in VM_LISTS:
        anchor = lj_short_string(expected_values[0])
        hits = find_all(data, anchor)
        require(
            len(hits) == 2,
            f"expected two {family} table copies, found {len(hits)}",
        )
        require(
            in_window(hits[0], PRIMARY_VM_WINDOW)
            and in_window(hits[1], DUPLICATE_VM_WINDOW),
            f"{family} table copies are outside the pinned windows: "
            + ", ".join(hex(hit) for hit in hits),
        )

        copies: list[dict[str, Any]] = []
        parsed_values: list[list[str]] = []
        for hit in hits:
            values, start, end = parse_lua_list(data, hit)
            require(
                tuple(values) == expected_values,
                f"{family} list mismatch at {hit:#x}: {values!r}",
            )
            parsed_values.append(values)
            copies.append(
                {
                    **location(source, region_base, start, end),
                    "sha256": sha256(data[start:end]),
                }
            )
        require(parsed_values[0] == parsed_values[1], f"{family} table copies differ")

        primary_prefix = hits[0]
        entries: list[dict[str, Any]] = []
        cursor = primary_prefix
        for expected in expected_values:
            actual, next_cursor = decode_lj_short_string(data, cursor)
            require(actual == expected, f"unexpected {family} entry at {cursor:#x}")
            entries.append(
                {
                    "value": actual,
                    "source": location(source, region_base, cursor + 1, next_cursor),
                }
            )
            cursor = next_cursor

        families.append(
            {
                "family": family,
                "classification_value": category,
                "count": len(entries),
                "entries": entries,
                "validated_identical_table_copies": copies,
            }
        )

    category_blob = b"".join(lj_short_string(item) for item in CATEGORY_CONSTANT_ORDER)
    category_hits = find_all(data, category_blob)
    require(
        len(category_hits) == 2,
        f"expected two category-constant blocks, found {len(category_hits)}",
    )
    require(
        in_window(category_hits[0], PRIMARY_VM_WINDOW)
        and in_window(category_hits[1], DUPLICATE_VM_WINDOW),
        "category-constant blocks are outside the pinned windows",
    )
    category_copies = [
        {
            **location(source, region_base, hit, hit + len(category_blob)),
            "values_in_serialized_order": list(CATEGORY_CONSTANT_ORDER),
            "sha256": sha256(category_blob),
        }
        for hit in category_hits
    ]
    return families, category_copies


def extract_common_key_indicators(
    data: bytes, source: Path, region_base: int
) -> dict[str, Any]:
    function_name = "scanCommonKeySimul"
    function_hits = find_all(data, lj_short_string(function_name))
    require(len(function_hits) == 1, f"expected one {function_name} marker")
    start = function_hits[0]
    require(in_window(start, COMMON_KEY_WINDOW), f"{function_name} is outside its window")

    terminal = "292020MMRunning"
    terminal_hits = find_all(data, lj_short_string(terminal), start, COMMON_KEY_WINDOW[1])
    require(len(terminal_hits) == 1, f"expected one terminal {terminal!r} marker")
    end = terminal_hits[0] + len(lj_short_string(terminal))

    category_occurrences: list[dict[str, Any]] = []
    groups: list[dict[str, Any]] = []
    flattened: list[dict[str, Any]] = []
    previous_offset = -1

    for category, expected_indicators in COMMON_KEY_GROUPS:
        category_hits = find_all(data, lj_short_string(category), start, end)
        require(category_hits, f"classification value {category!r} is absent")
        category_occurrences.append(
            {
                "value": category,
                "occurrence_count": len(category_hits),
                "sources": [
                    location(
                        source,
                        region_base,
                        hit + 1,
                        hit + len(lj_short_string(category)),
                    )
                    for hit in category_hits
                ],
            }
        )

        group_entries: list[dict[str, Any]] = []
        for indicator in expected_indicators:
            encoded = lj_short_string(indicator)
            hits = find_all(data, encoded, start, end)
            require(
                len(hits) == 1,
                f"expected one encoded {indicator!r} in {function_name}, found {len(hits)}",
            )
            hit = hits[0]
            require(
                hit > previous_offset,
                f"indicator order changed near {indicator!r} at {hit:#x}",
            )
            previous_offset = hit
            item = {
                "value": indicator,
                "classification_value": category,
                "source": location(source, region_base, hit + 1, hit + len(encoded)),
            }
            group_entries.append(item)
            flattened.append(item)
        groups.append(
            {
                "classification_value": category,
                "count": len(group_entries),
                "indicators": group_entries,
            }
        )

    return {
        "function_name": function_name,
        "source_range": {
            **location(source, region_base, start, end),
            "sha256": sha256(data[start:end]),
        },
        "classification_values": category_occurrences,
        "group_count": len(groups),
        "indicator_count": len(flattened),
        "groups": groups,
        "indicators_in_source_order": flattened,
    }


def extract_balanced_rule(data: bytes, marker_offset: int) -> tuple[bytes, int]:
    brace = data.find(b"{", marker_offset, YARA_WINDOW[1])
    require(brace >= 0, f"rule at {marker_offset:#x} has no opening brace")
    depth = 0
    cursor = brace
    while cursor < YARA_WINDOW[1]:
        byte = data[cursor]
        require(
            byte in (0x09, 0x0A, 0x0D) or 0x20 <= byte <= 0x7E,
            f"non-text byte {byte:#x} inside rule at {cursor:#x}",
        )
        if byte == ord("{"):
            depth += 1
        elif byte == ord("}"):
            depth -= 1
            require(depth >= 0, f"unbalanced closing brace at {cursor:#x}")
            if depth == 0:
                end = cursor + 1
                if data[end : end + 2] == b"\r\n":
                    end += 2
                elif data[end : end + 1] == b"\n":
                    end += 1
                return data[marker_offset:end], end
        cursor += 1
    raise EvidenceError(f"unterminated rule at {marker_offset:#x}")


def optional_yara_compile_validation(source_text: str) -> dict[str, Any]:
    try:
        import yara  # type: ignore[import-not-found]
    except ImportError:
        return {
            "compiler_available": False,
            "status": "not_run",
            "reason": "yara-python is not installed; structural extraction checks passed",
        }
    try:
        yara.compile(source=source_text)
    except Exception as exc:  # pragma: no cover - only used with optional dependency
        raise EvidenceError(f"YARA compiler rejected extracted rules: {exc}") from exc
    return {"compiler_available": True, "status": "passed"}


def extract_yara_rules(
    data: bytes, source: Path, region_base: int
) -> tuple[dict[str, Any], bytes]:
    rules: list[dict[str, Any]] = []
    raw_rules: list[bytes] = []
    for name in YARA_RULE_NAMES:
        marker = b"rule " + name.encode("ascii")
        hits = find_all(data, marker)
        require(len(hits) == 1, f"expected one rule marker for {name}, found {len(hits)}")
        start = hits[0]
        require(in_window(start, YARA_WINDOW), f"rule {name} is outside the pinned window")
        raw, end = extract_balanced_rule(data, start)
        header_match = re.match(rb"rule\s+([A-Za-z0-9_]+)", raw)
        require(
            header_match is not None and header_match.group(1).decode("ascii") == name,
            f"rule header mismatch at {start:#x}",
        )
        require(b"condition:" in raw, f"rule {name} has no condition section")
        text = raw.decode("ascii")
        raw_rules.append(raw.rstrip(b"\r\n"))
        rules.append(
            {
                "name": name,
                "source": location(source, region_base, start, end),
                "sha256": sha256(raw),
                "text": text,
            }
        )

    combined = b"\n\n".join(raw_rules) + b"\n"
    compilation = optional_yara_compile_validation(combined.decode("ascii"))
    result = {
        "count": len(rules),
        "rules": rules,
        "assembly": "verbatim rule spans joined in source order by one blank line",
        "combined_sha256": sha256(combined),
        "combined_length": len(combined),
        "validation": compilation,
    }
    return result, combined


def count_vm_entries(families: Iterable[dict[str, Any]]) -> int:
    return sum(int(family["count"]) for family in families)


def main() -> int:
    args = parse_args()
    source = args.region.resolve()
    require(source.is_file(), f"source region does not exist: {source}")
    match = REGION_RE.match(source.name)
    require(match is not None, f"cannot derive region base from filename: {source.name}")
    region_base = int(match.group(1), 16)

    data = source.read_bytes()
    source_hash = sha256(data)
    require(len(data) == EXPECTED_SOURCE_SIZE, f"unexpected source size: {len(data)}")
    require(
        source_hash == EXPECTED_SOURCE_SHA256,
        f"source SHA-256 mismatch: {source_hash}",
    )

    vm_families, category_copies = extract_vm_lists(data, source, region_base)
    common_key = extract_common_key_indicators(data, source, region_base)
    yara_result, yara_bytes = extract_yara_rules(data, source, region_base)

    yara_output: Path | None = None
    if args.yara_output is not None:
        yara_output = args.yara_output.resolve()
        yara_output.parent.mkdir(parents=True, exist_ok=True)
        yara_output.write_bytes(yara_bytes)
        yara_result["output_file"] = str(yara_output)
        yara_result["output_sha256"] = sha256(yara_bytes)
    else:
        yara_result["output_file"] = None

    evidence: dict[str, Any] = {
        "schema_version": 1,
        "artifact_family": "NetEase acSDK/EnvSDK",
        "scope_note": (
            "These plaintext artifacts belong to the NetEase acSDK/EnvSDK layer; "
            "they are not evidence of MaxHook VM-internal detection lists."
        ),
        "source": {
            "file": str(source),
            "region_base": region_base,
            "region_base_hex": hex(region_base),
            "size": len(data),
            "sha256": source_hash,
        },
        "validation": {
            "all_checks_passed": True,
            "source_hash_pinned": True,
            "source_size_pinned": True,
            "offset_windows_pinned": True,
            "vm_table_copy_count": 2,
            "vm_table_copies_identical": True,
        },
        "virtual_machine_file_indicators": {
            "physical_machine_classification_value": "real",
            "classification_mapping_basis": (
                "four list factories followed by the LuaJIT reverse-serialized KGC "
                "constant block real/hyperv/qemu/virtualbox/vmware"
            ),
            "family_count": len(vm_families),
            "indicator_count": count_vm_entries(vm_families),
            "families": vm_families,
            "validated_category_constant_copies": category_copies,
        },
        "scan_common_key_simul": common_key,
        "yara_rules": yara_result,
    }

    output = args.output.resolve()
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(
        json.dumps(evidence, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
        newline="\n",
    )

    print(f"source_sha256={source_hash}")
    print(
        "vm_families={} vm_indicators={} table_copies=2".format(
            len(vm_families), count_vm_entries(vm_families)
        )
    )
    print(
        "common_key_groups={} common_key_indicators={}".format(
            common_key["group_count"], common_key["indicator_count"]
        )
    )
    print(
        "yara_rules={} yara_sha256={}".format(
            yara_result["count"], yara_result["combined_sha256"]
        )
    )
    print(f"json_output={output} sha256={sha256(output.read_bytes())}")
    if yara_output is not None:
        print(f"yara_output={yara_output} sha256={sha256(yara_output.read_bytes())}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except EvidenceError as exc:
        raise SystemExit(f"evidence validation failed: {exc}") from exc
