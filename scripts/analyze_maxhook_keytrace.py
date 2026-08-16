#!/usr/bin/env python3
"""Offline analysis of the MaxHook input32/input64 keytrace capture.

The Frida capture uses ``MemoryAccessMonitor``.  That API reports the first
access to a monitored page, not every load, so this report deliberately treats
the reader RIPs as *first-page-read evidence* rather than a complete key data
flow.  Raw KID/key material is never copied to the generated JSON.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from collections import defaultdict
from pathlib import Path
from typing import Any


HEX_RE = re.compile(r"^[0-9a-fA-F]+$")
ROOT = Path(__file__).resolve().parent


def fingerprint_captured_hex(value: str) -> str:
    """Fingerprint the captured ASCII bytes, without retaining the value.

    ``input*_hex`` in events.jsonl is itself a hex encoding of the bytes in the
    std::string.  Decode that transport layer first so the fingerprint matches
    the boundary-capture reports.
    """

    raw = bytes.fromhex(value)
    return hashlib.sha256(raw.upper()).hexdigest()[:12]


def parse_reader_list(value: str | None) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    if not value:
        return rows
    for item in value.split(","):
        if not item:
            continue
        address, _, count = item.partition(":")
        try:
            rows.append({"address": address.lower(), "count": int(count)})
        except ValueError:
            rows.append({"address": address.lower(), "count": None})
    return rows


def load_event_sessions(path: Path) -> list[dict[str, Any]]:
    sessions: list[dict[str, Any]] = []
    current: dict[str, Any] | None = None
    for line_number, line in enumerate(path.read_text("utf-8").splitlines(), 1):
        if not line.strip():
            continue
        event = json.loads(line)
        if event.get("kind") == "keytrace_installed":
            current = {
                "installed_at": event.get("captured_at"),
                "thread_id": event.get("thread_id"),
                "events": [],
                "line_number": line_number,
            }
            sessions.append(current)
        elif current is not None:
            current["events"].append(event)
    return sessions


def summarize_session(session: dict[str, Any]) -> dict[str, Any]:
    begins = [e for e in session["events"] if e.get("kind") == "keytrace_begin"]
    summaries = {
        int(e["call_id"]): e
        for e in session["events"]
        if e.get("kind") == "keytrace_summary" and "call_id" in e
    }
    calls: list[dict[str, Any]] = []
    input32_values: list[str] = []
    input64_values: list[str] = []
    for begin in begins:
        call_id = int(begin["call_id"])
        value32 = str(begin.get("input32_hex") or "")
        value64 = str(begin.get("input64_hex") or "")
        valid32 = len(value32) == 64 and bool(HEX_RE.fullmatch(value32))
        valid64 = len(value64) == 128 and bool(HEX_RE.fullmatch(value64))
        if valid32:
            input32_values.append(value32)
        if valid64:
            input64_values.append(value64)
        summary = summaries.get(call_id, {})
        calls.append(
            {
                "call_id": call_id,
                "input32_bytes": int(begin.get("input32_size") or 0),
                "input64_bytes": int(begin.get("input64_size") or 0),
                "input32_format": "uppercase-or-lowercase-hex/32-bytes" if valid32 else "invalid-or-missing",
                "input64_format": "uppercase-or-lowercase-hex/64-bytes" if valid64 else "invalid-or-missing",
                "input32_fingerprint_sha256_12": fingerprint_captured_hex(value32) if valid32 else None,
                "input64_fingerprint_sha256_12": fingerprint_captured_hex(value64) if valid64 else None,
                "total_access": summary.get("total_access"),
                "first_page_readers": parse_reader_list(summary.get("top_readers")),
            }
        )

    def unique(values: list[str]) -> list[str]:
        return sorted({fingerprint_captured_hex(value) for value in values})

    reader_counts: defaultdict[str, int] = defaultdict(int)
    for call in calls:
        for reader in call["first_page_readers"]:
            if reader["count"] is not None:
                reader_counts[reader["address"]] += int(reader["count"])

    return {
        "installed_at": session.get("installed_at"),
        "thread_id": session.get("thread_id"),
        "calls": calls,
        "valid_input32_calls": sum(bool(c["input32_fingerprint_sha256_12"]) for c in calls),
        "valid_input64_calls": sum(bool(c["input64_fingerprint_sha256_12"]) for c in calls),
        "unique_input32_fingerprints": unique(input32_values),
        "unique_input64_fingerprints": unique(input64_values),
        "input32_constant_within_capture": len(set(input32_values)) <= 1,
        "input64_constant_within_capture": len(set(input64_values)) <= 1,
        "aggregated_first_page_readers": [
            {"address": address, "count": count}
            for address, count in sorted(reader_counts.items(), key=lambda pair: (-pair[1], pair[0]))
        ],
    }


def static_helper_summary(dll: Path) -> dict[str, Any]:
    """Read only enough static code to pin the keytrace reader loop."""

    sys.path.insert(0, str(ROOT / ".pydeps"))
    import pefile  # type: ignore
    from capstone import CS_ARCH_X86, CS_MODE_64, Cs  # type: ignore

    image_base = 0x180000000
    fn = 0x180322D10
    loop = 0x180322E30
    pe = pefile.PE(str(dll))
    image_size = (int(pe.OPTIONAL_HEADER.SizeOfImage) + 0xFFF) & ~0xFFF
    memory = bytearray(image_size)
    raw = dll.read_bytes()
    header_size = int(pe.OPTIONAL_HEADER.SizeOfHeaders)
    memory[:header_size] = raw[:header_size]
    for section in pe.sections:
        data = section.get_data()
        start = int(section.VirtualAddress)
        memory[start : start + len(data)] = data

    disassembler = Cs(CS_ARCH_X86, CS_MODE_64)
    def disassemble(address: int, size: int) -> list[dict[str, str]]:
        offset = address - image_base
        return [
            {
                "address": hex(ins.address),
                "mnemonic": ins.mnemonic,
                "op_str": ins.op_str,
            }
            for ins in disassembler.disasm(bytes(memory[offset : offset + size]), address)
        ]

    return {
        "dll_sha256": hashlib.sha256(raw).hexdigest(),
        "function": hex(fn),
        "loop_byte_load": hex(loop),
        "loop_byte_load_instruction": disassemble(loop, 5)[0],
        "loop_shape": [
            "movzx edx, byte ptr [rdi]",
            "indirect predicate call",
            "inc rdi",
            "cmp rdi, rsi",
            "jne loop_byte_load",
        ],
        "interpretation": (
            "The only recorded RIP is a byte-wise range/predicate helper. "
            "It is consistent with input-string validation or comparison, "
            "not proof of the VM cipher/KDF."
        ),
    }


def analyze(capture_dir: Path, dll: Path) -> dict[str, Any]:
    sessions = load_event_sessions(capture_dir / "events.jsonl")
    return {
        "schema": "maxhook.keytrace.analysis/v1",
        "sensitive_values_omitted": True,
        "source": {
            "capture_dir": str(capture_dir.resolve()),
            "events_sha256": hashlib.sha256((capture_dir / "events.jsonl").read_bytes()).hexdigest(),
        },
        "sessions": [summarize_session(session) for session in sessions],
        "static_helper": static_helper_summary(dll),
        "limitations": [
            "Frida MemoryAccessMonitor reports page-first access; it does not reconstruct every load or copied buffer.",
            "A constant input64 across eight calls proves session-level reuse for this capture, not a universal constant.",
            "No KDF, stream state, tag formula, or report_packet transform is recovered by this artifact alone.",
        ],
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--capture-dir", type=Path, default=ROOT / "keytrace_capture")
    parser.add_argument("--dll", type=Path, default=ROOT / "MaxHook.runtime-unpacked.dll")
    parser.add_argument("-o", "--output", type=Path, default=ROOT / "maxhook_keytrace_analysis.json")
    args = parser.parse_args()
    report = analyze(args.capture_dir, args.dll)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({
        "output": str(args.output.resolve()),
        "sessions": len(report["sessions"]),
        "valid_input64_calls": sum(s["valid_input64_calls"] for s in report["sessions"]),
        "input64_fingerprints": sorted({f for s in report["sessions"] for f in s["unique_input64_fingerprints"]}),
        "reader_addresses": report["sessions"][-1]["aggregated_first_page_readers"] if report["sessions"] else [],
    }, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
