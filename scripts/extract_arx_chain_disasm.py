#!/usr/bin/env python3
"""Extract disassembly of the core ARX key-schedule loop handler bodies
from disasm_unpacked.asm, following the call-history trace from
keystream_history_capture_20260814 snapshots."""
from __future__ import annotations
import json, re
from pathlib import Path
from collections import OrderedDict

HERE = Path(__file__).resolve().parent
DISASM = HERE / "disasm_unpacked.asm"
CAP = HERE / "keystream_history_capture_20260814"

# Core ARX chain addresses observed in history (chains A/B/C/D + producer + store32)
CORE_ADDRS = [
    0x1809815b2, 0x18099089e, 0x180990a93, 0x180990b21,  # chain A
    0x18098257f, 0x1809bfebb, 0x1809bff47, 0x1809c012a,  # chain B
    0x1809a3b86, 0x180a02a99, 0x180a02bcd, 0x180a02c51, 0x180a02c94, 0x180a02ca5,  # chain C
    0x18098202a, 0x180b41fb8, 0x180b42104, 0x180b42287, 0x180b422aa, 0x180b423a3,  # chain D
    0x180981a92, 0x180a182e9, 0x180a1841c, 0x180a1842d,  # chain E (pop/add)
    0x1809851af, 0x180bd41ad, 0x180bd430d, 0x180bd437e, 0x180bd438f, 0x180bd43de,  # chain F
    0x18098858a, 0x180addfc6, 0x180ade18c, 0x180ade35e, 0x180ade38e,  # chain G
    0x18098b0a7, 0x1809ba2f0, 0x1809ba397, 0x1809ba63e,  # chain H
    0x180985196, 0x1809e62cd, 0x1809e6430,  # chain I
    0x18098abf8, 0x180aa57d7, 0x180aa58bf,  # chain J
    0x18099412c, 0x180bce721, 0x180bce798, 0x180bce861, 0x180bceb64,  # chain K
    0x18098b5e0, 0x1809c5184, 0x1809c544c,  # chain L
    0x180996b98, 0x1809ac339, 0x180a31591,  # chain M
    0x180981ac9, 0x1809da384,  # chain N
    0x1809dee32, 0x1809a57e6,  # producer entry
    0x180b8c7aa,  # word producer
    0x18041a860,  # store32
    0x1809876d0, 0x180bc0334,  # chain O
    0x18098a77d, 0x180988e03, 0x180bc3d44,  # chain P (0x180bc3... = fold trampolines?)
    0x180987adc, 0x180bbe02d,  # chain Q
    0x180987dca, 0x1809ee838, 0x1809ee875,  # chain R
    0x180988d5e, 0x180988d22,  # chain S
    0x180989613, 0x1809f275a,  # chain T
    0x1809d5d81, 0x180a73b12,  # chain U
    0x1809a37ff, 0x1809a38c5,  # chain V
    0x18098a787, 0x180a725cb, 0x180a72787, 0x180a728df, 0x180a7293c,  # chain W
    0x1809da915, 0x180bb20f1, 0x180bb24ba, 0x180bb24cb,  # chain X
    0x180a4ce63, 0x180a4ceae,  # chain Y
    0x1809a3bb8,  # chain Z
]

def build_index():
    """Build addr -> file offset index (the .asm lines are ~fixed order; do a single pass)."""
    idx = {}
    with open(DISASM, "r", encoding="utf-8", errors="replace") as f:
        for off, line in enumerate(f):
            m = re.match(r"^(0x[0-9a-fA-F]+):", line)
            if m:
                a = int(m.group(1), 16)
                if a not in idx:
                    idx[a] = line.rstrip("\n")
    return idx

def main():
    idx = build_index()
    print(f"indexed {len(idx)} addresses\n")
    # group: for each core addr, print its line and the next ~12 lines (the body)
    for a in CORE_ADDRS:
        if a not in idx:
            print(f"### {a:#x}: NOT FOUND")
            continue
        # find consecutive lines from this address
        print(f"### {a:#x}:")
        # we only stored first line per address; re-scan file for the body
        # instead, do a second pass gathering ranges
        break
    # Better: do a second pass to gather body ranges
    bodies = {}
    targets = set(CORE_ADDRS)
    with open(DISASM, "r", encoding="utf-8", errors="replace") as f:
        lines = f.readlines()
    for i, line in enumerate(lines):
        m = re.match(r"^(0x[0-9a-fA-F]+):", line)
        if m and int(m.group(1), 16) in targets:
            a = int(m.group(1), 16)
            body = [line.rstrip("\n")]
            j = i + 1
            while j < len(lines) and j < i + 16:
                body.append(lines[j].rstrip("\n"))
                j += 1
            bodies[a] = body
    # print in chain order
    for a in CORE_ADDRS:
        if a in bodies:
            print(f"### {a:#x}:")
            for ln in bodies[a]:
                print("   ", ln)
            print()

if __name__ == "__main__":
    main()
