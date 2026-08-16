#!/usr/bin/env python3
"""Analyze the raw bytecode word stream at VIP across the full 4096-transition
trace: collect distinct raw words (the key-schedule program's operand set)."""
import json
import struct
from pathlib import Path
from collections import Counter

BUGLAND = Path(r"E:\Coding\S1mple\target\dump_out\41264\region_0000000180980000.bin")
BUGLAND_BASE = 0x180980000
TRACE = Path(r"E:\Coding\S1mple\target\vm_handler_execution_trace.json")

def main():
    bug = BUGLAND.read_bytes()
    trace = json.loads(TRACE.read_text(encoding="utf-8"))

    # Collect raw 16-bit words at VIP+0, +2, +4, +6 (the dispatch reads word[VIP+4])
    raw_counter = Counter()
    slot_hits = Counter()
    known_slots = {0x26, 0xd9, 0x106, 0xbd, 0x61, 0xb5, 0xe5, 0xed, 0x6d, 0xa, 0x45, 0x143, 0x14a, 0x235, 0x1e, 0x5d, 0x69}
    for t in trace:
        vip = int(t["vip"], 16)
        off = vip - BUGLAND_BASE
        if 0 <= off < len(bug) - 8:
            for k in (0, 2, 4, 6):
                w = struct.unpack("<H", bug[off+k:off+k+2])[0]
                raw_counter[w] += 1
                if w in known_slots:
                    slot_hits[w] += 1

    print("distinct raw words:", len(raw_counter))
    print("\nknown slot offsets appearing DIRECTLY in bytecode (plaintext operands):")
    for s in sorted(slot_hits):
        print("  0x%03x (+%d): %d hits" % (s, s, slot_hits[s]))

    print("\ntop 40 raw words by frequency:")
    for w, c in raw_counter.most_common(40):
        tag = ""
        if w < 0x300:
            tag = "  (small=slot offset %d)" % w
        print("  0x%04x: %d%s" % (w, c, tag))

if __name__ == "__main__":
    main()
