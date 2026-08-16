#!/usr/bin/env python3
"""Examine the emulator's dispatch trace to extract the decoded VM bytecode
sequence (rolling key + VIP + handler index at each dispatch)."""
from __future__ import annotations
import json
from pathlib import Path

def main():
    d = json.loads(Path(r"E:\Coding\S1mple\target\encrypt_vm_mapped.json").read_text(encoding="utf-8"))
    disp = d.get("dispatcher", {})
    print("dispatcher count:", disp.get("count"))
    print("distinct handler targets:", disp.get("distinct_handler_targets"))
    print()
    print("first 40 dispatch records (decoded bytecode):")
    for item in disp.get("recent", [])[:40]:
        print(f"  instr={item.get('instruction'):>8} key={item.get('key_low32')} "
              f"vip={item.get('vip')} idx={item.get('handler_index')} -> {item.get('handler_target')}")

if __name__ == "__main__":
    main()
