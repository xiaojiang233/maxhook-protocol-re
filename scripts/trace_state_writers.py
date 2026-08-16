#!/usr/bin/env python3
"""Trace which handlers write the keystream state slots (0xb5, 0x36, 0x45,
0x14a) to identify the cipher fold subset."""
from __future__ import annotations
import json
from pathlib import Path
from collections import Counter

VM_RBP = 0x18098c884
STATE_SLOTS = [0xb5, 0x36, 0x45, 0x14a, 0x26, 0xd9]

def main():
    d = json.loads(Path(r"E:\Coding\S1mple\target\encrypt_vm_mapped.json").read_text(encoding="utf-8"))
    writes = d.get("vm_pointer_slot_writes", [])
    # group writes by slot offset
    slot_writers = {}
    for w in writes:
        addr = int(w["address"], 16)
        off = addr - VM_RBP
        if off in STATE_SLOTS:
            slot_writers.setdefault(off, Counter())[w["rip"]] += 1

    for off in STATE_SLOTS:
        if off in slot_writers:
            writers = slot_writers[off]
            print(f"slot +0x{off:03x}: {sum(writers.values())} writes, {len(writers)} distinct writers:")
            for rip, cnt in writers.most_common(10):
                print(f"    {rip}: {cnt}")

if __name__ == "__main__":
    main()
