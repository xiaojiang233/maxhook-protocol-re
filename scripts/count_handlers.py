#!/usr/bin/env python3
"""Extract the distinct VM handlers from the execution trace, to gauge the
scope of the bytecode-decoding task."""
from __future__ import annotations
import json
from pathlib import Path
from collections import Counter

def main():
    d = json.loads(Path(r"E:\Coding\S1mple\target\encrypt_vm_mapped.json").read_text(encoding="utf-8"))
    jumps = d.get("vm_indirect_jumps", [])
    # collect distinct source and target handlers
    handlers = Counter()
    for j in jumps:
        handlers[j.get("source")] += 1
        handlers[j.get("target")] += 1
    print("distinct handlers:", len(handlers))
    print()
    print("top 30 handlers by frequency:")
    for h, cnt in handlers.most_common(30):
        print(f"  {h}: {cnt}")

if __name__ == "__main__":
    main()
