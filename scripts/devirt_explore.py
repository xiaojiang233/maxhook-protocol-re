#!/usr/bin/env python3
"""Explore the keystream_history snapshots to locate the stable common suffix
of the repeated 1024-block generator trace and separate VM bookkeeping from
cipher state.

Data: 52 snapshots across 3 calls. Each snapshot captures, at XOR byte index
multiples of 64 (i.e. once per 64-byte keystream block), the following:

  xor_index   - byte offset into the keystream stream (snapshot every 64 bytes)
  source      - r12 at the XOR instruction (heap pointer, per-call)
  destination - r8  at the XOR instruction (context-relative working buffer)
  keystream_byte - the byte being XORed (context.r8 readU8)
  history     - 1024 basic-block start addresses (Stalker putCallout ring)
  context_hex - 0x300 (768) bytes of the VM context at 0x18098c884

This script prints:
  1. per-call stats and destination analysis
  2. stable-vs-changing context bytes (cipher state vs bookkeeping)
  3. the common suffix of the 1024-entry histories (dispatch loop)
  4. history address distribution / clustering
"""
from __future__ import annotations
import json
import hashlib
import struct
from pathlib import Path
from collections import Counter, defaultdict

CAPTURE = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")
CTX_BASE = 0x18098C884


def load_snapshots():
    snaps = []
    for f in sorted(CAPTURE.glob("*.bin")):
        j = json.loads(f.read_text(encoding="utf-8"))
        j["_file"] = f.name
        snaps.append(j)
    return snaps


def hexs(s):
    return bytes.fromhex(s)


def main():
    snaps = load_snapshots()
    by_call = defaultdict(list)
    for s in snaps:
        # filename: 000003_call_1_meta_keystream_history_snapshot.bin
        call = int(s["_file"].split("_call_")[1].split("_")[0])
        by_call[call].append(s)

    print(f"total snapshots = {len(snaps)}")
    for call, ss in sorted(by_call.items()):
        idxs = [s["xor_index"] for s in ss]
        print(f"  call {call}: {len(ss)} snapshots, xor_index range {min(idxs)}..{max(idxs)}")
        dst = Counter(s["destination"] for s in ss)
        print(f"    destinations: {dict(dst)}")
        src = Counter(s["source"] for s in ss)
        print(f"    sources: {dict(src)}")

    # --- destination analysis ---
    print("\n=== destination (r8) analysis ===")
    for s in snaps:
        dst = int(s["destination"], 16)
        off = dst - CTX_BASE
        print(f"  {s['_file']}: dst={s['destination']} off=+0x{off:x}")

    # --- context stability ---
    print("\n=== context (0x300 bytes) stability across ALL snapshots ===")
    ctxs = [hexs(s["context_hex"]) for s in snaps]
    assert all(len(c) == 0x300 for c in ctxs), [len(c) for c in ctxs]
    n = len(ctxs)
    stable = []
    changing = []
    for off in range(0x300):
        vals = [c[off] for c in ctxs]
        if len(set(vals)) == 1:
            stable.append(off)
        else:
            changing.append(off)
    print(f"  stable bytes: {len(stable)} / 768  changing bytes: {len(changing)} / 768")

    # group changing bytes into contiguous runs
    runs = []
    if changing:
        start = changing[0]
        prev = changing[0]
        for off in changing[1:]:
            if off == prev + 1:
                prev = off
            else:
                runs.append((start, prev))
                start = off
                prev = off
        runs.append((start, prev))
    print("  changing byte runs (context-relative offset ranges):")
    for a, b in runs:
        print(f"    +0x{a:03x}..+0x{b:03x}  ({b-a+1} bytes)")

    # count distinct values per changing offset
    print("\n  distinct-value histogram over changing offsets:")
    dv = Counter()
    for off in changing:
        dv[len(set(c[off] for c in ctxs))] += 1
    for k in sorted(dv):
        print(f"    {k} distinct values: {dv[k]} offsets")

    # --- history common suffix ---
    print("\n=== history (1024 entries) common suffix ===")
    # histories are rings; the last entry is most recent block start.
    hist = [s["history"] for s in snaps]
    # find longest common suffix (from the END)
    minlen = min(len(h) for h in hist)
    csuf = 0
    for i in range(1, minlen + 1):
        tail = hist[0][-i]
        if all(h[-i] == tail for h in hist):
            csuf = i
        else:
            break
    print(f"  longest common suffix length = {csuf} (of {minlen})")
    for i in range(1, csuf + 1):
        print(f"    [-{i:3d}] {hist[0][-i]}")

    # common prefix
    cpre = 0
    for i in range(minlen):
        head = hist[0][i]
        if all(h[i] == head for h in hist):
            cpre = i + 1
        else:
            break
    print(f"  longest common prefix length = {cpre}")
    for i in range(cpre):
        print(f"    [{i:3d}] {hist[0][i]}")

    # --- address distribution ---
    print("\n=== history address frequency (top 40) ===")
    alladdr = Counter()
    for h in hist:
        alladdr.update(h)
    for addr, cnt in alladdr.most_common(40):
        print(f"  {addr} : {cnt}")

    # --- per-call history stability: is the suffix identical within a call? ---
    print("\n=== within-call history stability ===")
    for call, ss in sorted(by_call.items()):
        hs = [s["history"] for s in ss]
        # common suffix within the call
        ml = min(len(h) for h in hs)
        cs = 0
        for i in range(1, ml + 1):
            t = hs[0][-i]
            if all(h[-i] == t for h in hs):
                cs = i
            else:
                break
        print(f"  call {call}: {len(ss)} snapshots, within-call common suffix = {cs}")


if __name__ == "__main__":
    main()
