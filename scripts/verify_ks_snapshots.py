#!/usr/bin/env python3
"""Reconstruct full keystream from keystream_history snapshots and verify
against writer_sync analysis.json keystream."""
from __future__ import annotations
import json, glob
from pathlib import Path

CAP = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")
ANALYSIS = json.loads(Path(r"E:\Coding\S1mple\target\writer_sync_clean_20260814_014351\analysis.json").read_text(encoding="utf-8"))

def main():
    for c in ANALYSIS["calls"]:
        call = c["call_id"]
        ks_expected = bytes.fromhex(c["keystream_hex"])
        files = sorted(CAP.glob(f"*call_{call}*.bin"))
        # Each snapshot has xor_index (byte offset) and keystream_byte (one byte)
        # But snapshots are sparse (only ~11 per call at 64-byte intervals).
        snaps = []
        for f in files:
            d = json.loads(f.read_text(encoding="utf-8"))
            snaps.append((d["xor_index"], d["keystream_byte"], bytes.fromhex(d["context_hex"])))
        snaps.sort()
        print(f"call {call}: {len(snaps)} snapshots, xor_index={[s[0] for s in snaps]}")
        # verify keystream_byte at xor_index matches expected keystream
        for xi, kb, ctx in snaps:
            if xi < len(ks_expected):
                match = (kb == ks_expected[xi])
                if not match:
                    print(f"  MISMATCH xor_index={xi}: snapshot_byte={kb:02x} expected={ks_expected[xi]:02x}")
        # The snapshot's keystream_byte is ONE byte of the 64-byte block.
        # Verify it equals expected keystream at that index.
        allok = all(kb == ks_expected[xi] for xi, kb, _ in snaps if xi < len(ks_expected))
        print(f"  keystream_byte matches expected keystream: {allok}")

if __name__ == "__main__":
    main()
