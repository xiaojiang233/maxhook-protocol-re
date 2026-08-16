#!/usr/bin/env python3
"""Solve for the rolling key directly: we know word[VIP+4] (raw) and the correct
handler index (from target -> table map).  Solve index = f(word, key) for key,
then examine the key sequence for the recurrence."""
import json
import struct
from pathlib import Path
from collections import Counter

BUGLAND = Path(r"E:\Coding\S1mple\target\dump_out\41264\region_0000000180980000.bin")
BUGLAND_BASE = 0x180980000
TRACE = Path(r"E:\Coding\S1mple\target\vm_handler_execution_trace.json")
HANDLER_TABLE = 0x180C64EBD

def main():
    bug = BUGLAND.read_bytes()
    trace = json.loads(TRACE.read_text(encoding="utf-8"))

    # build target->index
    ht_off = HANDLER_TABLE - BUGLAND_BASE
    entries = [struct.unpack("<Q", bug[ht_off+i*8:ht_off+i*8+8])[0] for i in range(1612)]
    target_to_index = {}
    for i, e in enumerate(entries):
        target_to_index.setdefault(e, []).append(i)

    # For each transition, compute: what value of (key_low16) would satisfy
    #   index = (word[VIP+4] + key) & 0xffff  =>  key = (index - word) & 0xffff
    # Compare this derived key to the trace's 'key' low16.
    derived_keys = []
    for t in trace:
        target = int(t["target"], 16)
        idx = target_to_index[target][0]  # first index
        vip = int(t["vip"], 16)
        key = int(t["key"], 16) & 0xffff
        off = vip - BUGLAND_BASE
        if not (0 <= off < len(bug) - 2):
            continue
        # try word at +0, +2, +4, +6
        for k in (0, 2, 4, 6):
            w = struct.unpack("<H", bug[off+k:off+k+2])[0]
            derived = (idx - w) & 0xffff
            if derived == key:
                derived_keys.append((k, derived))
                break

    print("transitions where derived key matches trace key:", len(derived_keys), "/", len(trace))
    # which word offset k matched?
    ks = Counter(k for k, _ in derived_keys)
    print("matching word offsets:", dict(ks))

    # Alternative: maybe index uses word at VIP+4 with subtraction:
    #   index = (key - word) & 0xffff  => key = (index + word) & 0xffff
    derived_keys2 = []
    for t in trace:
        target = int(t["target"], 16)
        idx = target_to_index[target][0]
        vip = int(t["vip"], 16)
        key = int(t["key"], 16) & 0xffff
        off = vip - BUGLAND_BASE
        if not (0 <= off < len(bug) - 2):
            continue
        for k in (0, 2, 4, 6):
            w = struct.unpack("<H", bug[off+k:off+k+2])[0]
            derived = (idx + w) & 0xffff
            if derived == key:
                derived_keys2.append((k, derived))
                break
    print("derived key = index+word matches:", len(derived_keys2), "/", len(trace))
    ks2 = Counter(k for k, _ in derived_keys2)
    print("matching word offsets (add):", dict(ks2))

if __name__ == "__main__":
    main()
