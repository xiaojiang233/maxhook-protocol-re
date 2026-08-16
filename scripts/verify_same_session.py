#!/usr/bin/env python3
"""Verify keystream_history and keystream_source are the same session by
comparing their keystream bytes."""
from __future__ import annotations
import json, glob
from pathlib import Path

KH = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")
KS = Path(r"E:\Coding\S1mple\target\keystream_source_capture_20260814")

def main():
    # keystream_history call 1 keystream bytes (ctx[0xb5] at xor_index)
    kh_bytes = {}
    for f in sorted(KH.glob("*call_1*.bin")):
        d = json.loads(f.read_text(encoding="utf-8"))
        kh_bytes[d["xor_index"]] = d["keystream_byte"]

    # keystream_source call 1 keystream bytes (store_value sequence)
    ks_records = []
    for f in sorted(KS.glob("*call_1*.bin")):
        d = json.loads(f.read_text(encoding="utf-8"))
        ks_records.extend(d)

    # The keystream_source store_value is the keystream byte written at each
    # XOR. Reconstruct the full keystream sequence.
    ks_full = [int(r["store_value"], 16) for r in ks_records if r.get("store_value")]

    print("keystream_history call1 xor_indices:", sorted(kh_bytes.keys()))
    print("keystream_history keystream bytes:", [f"{v:02x}" for _, v in sorted(kh_bytes.items())])
    print()
    print("keystream_source call1 full keystream (first 64):", [f"{b:02x}" for b in ks_full[:64]])
    print()
    # Check if keystream_history bytes match keystream_source at xor_index positions
    for xi, kb in sorted(kh_bytes.items()):
        if xi < len(ks_full):
            match = (kb == ks_full[xi])
            print(f"  xor_index={xi}: kh={kb:02x} ks_source={ks_full[xi]:02x} {'MATCH' if match else 'DIFF'}")

if __name__ == "__main__":
    main()
