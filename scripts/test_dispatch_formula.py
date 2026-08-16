#!/usr/bin/env python3
"""Attempt precise rolling-key recovery for the VM dispatch.

The dispatch reads word[VIP] (or word[VIP+4]) and combines with the rolling key
to compute handler index.  We have 4096 (vip, key, target) transitions where
target = handler address.  The handler table is at 0x180c64ebd (decrypted,
1612 entries).  If we can map target -> table index, we can solve for the
dispatch formula and the rolling key.

Approach: build target->index map from the decrypted handler table, then for
each transition test candidate formulas:
  index = (word[VIP+4] + key) & 0xffff        (round-26 formula A)
  index = (word[VIP+4] - key + 0x5214a88c) & 0xffff  (formula B)
"""
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

    # Build the handler table from the dump (decrypted .bugland).
    # The handler table base 0x180c64ebd -> offset in bugland
    ht_off = HANDLER_TABLE - BUGLAND_BASE
    print("handler table offset in bugland:", hex(ht_off))
    # read 1612 entries of 8 bytes each (function pointers)
    n_entries = 1612
    entries = []
    for i in range(n_entries):
        off = ht_off + i * 8
        if off + 8 <= len(bug):
            entries.append(struct.unpack("<Q", bug[off:off+8])[0])
    # map target addr -> index
    target_to_index = {}
    for i, e in enumerate(entries):
        target_to_index.setdefault(e, []).append(i)

    # Check: do the trace 'target' values appear in the handler table?
    targets = set(int(t["target"], 16) for t in trace)
    hit = 0
    miss = 0
    for t in targets:
        if t in target_to_index:
            hit += 1
        else:
            miss += 1
    print("distinct targets:", len(targets))
    print("targets IN handler table:", hit, "  NOT in table:", miss)

    # For targets in the table, test dispatch formulas
    # For each transition, read word[VIP+4] and try to recover index
    formulaA_hits = 0
    formulaB_hits = 0
    total_in_table = 0
    for t in trace:
        target = int(t["target"], 16)
        if target not in target_to_index:
            continue
        total_in_table += 1
        vip = int(t["vip"], 16)
        key = int(t["key"], 16) & 0xffffffff
        off = vip - BUGLAND_BASE
        if not (0 <= off < len(bug) - 2):
            continue
        w4 = struct.unpack("<H", bug[off+4:off+6])[0]
        w0 = struct.unpack("<H", bug[off:off+2])[0]
        idxs = target_to_index[target]
        # formula A: index = (w4 + key) & 0xffff
        ia = (w4 + (key & 0xffff)) & 0xffff
        # formula B: index = (w4 - key + 0x5214a88c) & 0xffff
        ib = (w4 - (key & 0xffff) + 0x5214a88c) & 0xffff
        if ia in idxs:
            formulaA_hits += 1
        if ib in idxs:
            formulaB_hits += 1

    print("\ntotal transitions with target in table:", total_in_table)
    print("formula A (w4+key)&0xffff matches table index: %d/%d" % (formulaA_hits, total_in_table))
    print("formula B (w4-key+0x5214a88c)&0xffff matches: %d/%d" % (formulaB_hits, total_in_table))

if __name__ == "__main__":
    main()
