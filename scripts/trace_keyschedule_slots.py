#!/usr/bin/env python3
"""Trace the key-schedule dataflow: find where key bytes (context+0xbd) and
state slots (0x1e/0x143) are read/written in the handler trace."""
from __future__ import annotations
import json
from pathlib import Path

VM_RBP = 0x18098c884

def main():
    d = json.loads(Path(r"E:\Coding\S1mple\target\encrypt_vm_mapped.json").read_text(encoding="utf-8"))
    writes = d.get("vm_pointer_slot_writes", [])

    # key pointer slot 0xbd, state slots 0x1e, 0x143
    key_slots = {0xbd, 0x1e, 0x143, 0x98, 0x92}
    for slot in key_slots:
        addr = VM_RBP + slot
        slot_writes = [w for w in writes if int(w["address"], 16) == addr]
        print(f"slot +0x{slot:03x} ({addr:#x}): {len(slot_writes)} writes")
        for w in slot_writes[:8]:
            print(f"    instr={w['instruction']:>8} rip={w['rip']} value={w['value']}")

if __name__ == "__main__":
    main()
