#!/usr/bin/env python3
"""Analyze the key pointer slot (0xbd) writes to understand the key-schedule's
actual dataflow.  The 825 writes show the key-schedule's rolling state."""
from __future__ import annotations
import json
from pathlib import Path
from collections import Counter

VM_RBP = 0x18098c884

def main():
    d = json.loads(Path(r"E:\Coding\S1mple\target\encrypt_vm_mapped.json").read_text(encoding="utf-8"))
    writes = d.get("vm_pointer_slot_writes", [])
    bd_writes = [w for w in writes if int(w["address"], 16) == VM_RBP + 0xbd]
    print(f"slot 0xbd: {len(bd_writes)} writes")
    # distinct RIPs (handlers) that write 0xbd
    rips = Counter(w["rip"] for w in bd_writes)
    print(f"distinct writer handlers: {len(rips)}")
    for rip, cnt in rips.most_common(15):
        print(f"  {rip}: {cnt}")
    # distinct values written
    vals = Counter(w["value"] for w in bd_writes)
    print(f"\ndistinct values: {len(vals)}")
    for v, cnt in vals.most_common(15):
        print(f"  {v}: {cnt}")

if __name__ == "__main__":
    main()
