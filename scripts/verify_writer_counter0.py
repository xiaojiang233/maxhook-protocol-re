#!/usr/bin/env python3
"""Solidify the counter-0 writer evidence for the recovered MaxHook ChaCha20.

Goal (priority #1 from the offline recovery plan):

  For every writer_sync capture, prove that
    * the leading records that earlier analysis "discarded" are exactly the
      ChaCha20 counter-0 block words 0..11 (the block generated *before* the
      payload counter starts at 1), and
    * the payload records (offsets 0..0x3c in the VM wrap order) reproduce
      counters 1..N.

This turns the previously-ambiguous leading 12 records into hard evidence that
the counter-0 block is genuinely generated ahead of the payload stream, which
is the natural feeding point for an authentication (tag) construction.

Everything here is offline and evidence-only; it does not fabricate a tag.
"""
from __future__ import annotations

import json
import re
import struct
from pathlib import Path

from maxhook_protocol_reference import chacha20_block, derive_domain_key

HERE = Path(__file__).resolve().parent
WRITER_CAPTURES = sorted(HERE.glob("writer_sync_clean_*"))
COUNTER0_WORDS_EXPECTED = 12  # words 0..11 captured before Stalker tracked the block


def load_records(capture: Path) -> list[tuple[int, list[dict]]]:
    """Return [(call_id, records), ...] from the writer_sync captures."""
    out = []
    for path in sorted(capture.glob("*_meta_writer_sync_records.bin")):
        m = re.search(r"_call_(\d+)_meta", path.name)
        call_id = int(m.group(1)) if m else 0
        out.append((call_id, json.loads(path.read_text("utf-8"))))
    return out


def get_inputs(capture: Path, call_id: int) -> tuple[bytes, bytes]:
    key_path = next(capture.glob(f"*_call_{call_id}_input_input64.bin"))
    nonce_path = next(capture.glob(f"*_call_{call_id}_output_nonce_hex.bin"))
    key = bytes.fromhex(key_path.read_text("ascii").strip())
    nonce = bytes.fromhex(nonce_path.read_text("ascii").strip())
    return key, nonce


def verify_call(capture: Path, call_id: int, rec: list[dict]) -> dict:
    key, nonce = get_inputs(capture, call_id)
    derived = derive_domain_key(key)

    # --- counter-0 block (words 0..11) -------------------------------------
    counter0_words = struct.unpack("<12I", chacha20_block(derived, 0, nonce)[:48])
    lead_words = [int(r["value"], 0) & 0xFFFFFFFF for r in rec[:COUNTER0_WORDS_EXPECTED]]
    lead_offsets = [int(r["offset"]) for r in rec[:COUNTER0_WORDS_EXPECTED]]
    counter0_matched = list(counter0_words) == lead_words
    counter0_offsets_ok = lead_offsets == list(range(16, 16 + 4 * COUNTER0_WORDS_EXPECTED, 4))

    # --- payload records (counters 1..N) -----------------------------------
    payload_records = rec[COUNTER0_WORDS_EXPECTED:]
    n_blocks = len(payload_records) // 16
    block_results = []
    all_payload_matched = True
    for block_index in range(n_blocks):
        chunk = payload_records[block_index * 16:(block_index + 1) * 16]
        buf = bytearray(64)
        for r in chunk:
            off = int(r["offset"])
            if off < 64:
                buf[off:off + 4] = struct.pack("<I", int(r["value"], 0) & 0xFFFFFFFF)
        expected = chacha20_block(derived, block_index + 1, nonce)
        ok = bytes(buf) == expected
        all_payload_matched = all_payload_matched and ok
        block_results.append({"block": block_index, "expected_counter": block_index + 1,
                              "equals_keystream_block": ok})
    # Partial trailing records (<16) are not counted as a full block.
    trailing = len(payload_records) % 16

    return {
        "call_id": call_id,
        "key_len": len(key),
        "nonce": nonce.hex(),
        "counter0_block_words_0_11": [hex(w) for w in counter0_words],
        "leading_captured_words": [hex(w) for w in lead_words],
        "counter0_matched": counter0_matched,
        "counter0_offsets_ok": counter0_offsets_ok,
        "payload_blocks_checked": n_blocks,
        "payload_all_matched": all_payload_matched,
        "trailing_records": trailing,
        "payload_block_detail": block_results,
    }


def main() -> int:
    all_ok = True
    any_capture = False
    for capture in WRITER_CAPTURES:
        entries = load_records(capture)
        if not entries:
            continue
        any_capture = True
        print(f"== {capture.name} ==")
        for call_id, rec in entries:
            result = verify_call(capture, call_id, rec)
            print(f"  call={result['call_id']} counter0_matched={result['counter0_matched']} "
                  f"offsets_ok={result['counter0_offsets_ok']} "
                  f"payload {result['payload_blocks_checked']} blocks all={result['payload_all_matched']}")
            all_ok = all_ok and (
                result["counter0_matched"]
                and result["counter0_offsets_ok"]
                and result["payload_all_matched"]
            )
    if not any_capture:
        print("no writer_sync captures found")
        return 2
    print(f"\nRESULT: {'ALL WRITER COUNTER0 + PAYLOAD EVIDENCE VERIFIED' if all_ok else 'MISMATCH'}")
    return 0 if all_ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
