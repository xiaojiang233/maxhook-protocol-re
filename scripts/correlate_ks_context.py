#!/usr/bin/env python3
"""Correlate keystream_history context with keystream bytes.

Goal: find which context slot holds the keystream byte (or its source), and
observe how key-schedule state advances, to derive the fold.
"""
from __future__ import annotations
import json, glob
from pathlib import Path

CAP = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")

def main():
    for call in (1, 2, 3):
        files = sorted(CAP.glob(f"*call_{call}*.bin"))
        if not files:
            continue
        # verify destination slot holds keystream byte
        # destination 0x18098c939 = base 0x18098c884 + 0xb5
        ok_b5 = ok_235 = 0
        for f in files:
            d = json.loads(f.read_text(encoding="utf-8"))
            ctx = bytes.fromhex(d["context_hex"])
            kb = d["keystream_byte"]
            if len(ctx) > 0xb5 and ctx[0xb5] == kb:
                ok_b5 += 1
            if len(ctx) > 0x235 and ctx[0x235] == kb:
                ok_235 += 1
        print(f"call {call}: {len(files)} snapshots, ctx[0xb5]==ks_byte: {ok_b5}/{len(files)}, ctx[0x235]==ks_byte: {ok_235}/{len(files)}")

        # Find the slot that ALWAYS equals keystream_byte
        if files:
            # gather all (ctx, ks_byte)
            pairs = []
            for f in files:
                d = json.loads(f.read_text(encoding="utf-8"))
                pairs.append((bytes.fromhex(d["context_hex"]), d["keystream_byte"]))
            # find candidate slots
            cands = []
            for slot in range(min(len(p[0]) for p in pairs)):
                if all(p[0][slot] == p[1] for p in pairs):
                    cands.append(slot)
            print(f"  slots always == keystream_byte: {[hex(c) for c in cands]}")

if __name__ == "__main__":
    main()
