#!/usr/bin/env python3
"""Trace the fold: analyze the writes to keystream byte slot (0xb5) in the
emulator, showing the handler + value + old_bytes sequence."""
from __future__ import annotations
import json
from pathlib import Path

VM_RBP = 0x18098c884

def main():
    d = json.loads(Path(r"E:\Coding\S1mple\target\encrypt_vm_mapped.json").read_text(encoding="utf-8"))
    writes = d.get("vm_pointer_slot_writes", [])
    # filter writes to slot 0xb5
    b5_writes = [w for w in writes if int(w["address"], 16) == VM_RBP + 0xb5]
    print(f"total writes to ctx+0xb5: {len(b5_writes)}")
    print()
    # show first 30 with the handler (rip) and value
    print("first 30 writes to ctx+0xb5 (the keystream byte slot):")
    for w in b5_writes[:30]:
        print(f"  instr={w['instruction']:>8} rip={w['rip']} value={w['value']} old={w.get('old_bytes')}")

if __name__ == "__main__":
    main()
