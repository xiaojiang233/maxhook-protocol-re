#!/usr/bin/env python3
"""Reconstruct the actual VM bytecode execution from the emulator's
vm_indirect_jumps (handler-to-handler jmp reg transitions)."""
from __future__ import annotations
import json
from pathlib import Path
from collections import Counter

def main():
    d = json.loads(Path(r"E:\Coding\S1mple\target\encrypt_vm_mapped.json").read_text(encoding="utf-8"))
    jumps = d.get("vm_indirect_jumps", [])
    print("vm_indirect_jumps count:", len(jumps))
    if jumps:
        print("first entry keys:", list(jumps[0].keys()))
        print()
        # show first 30 handler transitions
        print("first 30 handler->handler transitions:")
        for j in jumps[:30]:
            print(f"  instr={j.get('instruction')} {j.get('source')} -> {j.get('target')}")

if __name__ == "__main__":
    main()
