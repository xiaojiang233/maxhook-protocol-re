#!/usr/bin/env python3
"""Verify genuine key-schedule constants appear as real memory-write instructions."""
import json
from pathlib import Path

d = json.load(open(r"E:\Coding\S1mple\target\keystream_history_capture_20260814\candidate_memory_writes.json", encoding="utf-8"))
genuine = ["0x5f5c808f","0x558a625a","0x4dbfde8f","0x6abd113b","0x7f594fcf","0x616c560b",
           "0x472793ed","0x4bfba08f","0x453d7de7","0x3e0cc8b0","0x3b86d410","0x6220b8ca",
           "0x662ff97c","0x3c02264d","0x31d126f2","0x5e800fc4"]
print("Verifying genuine key-schedule constants appear as actual memory-write instructions:")
for g in genuine:
    hits = [w for w in d if g in w["op_str"]]
    if hits:
        w = hits[0]
        print("  %s -> %s %s  (block %s)" % (g, w["mnemonic"], w["op_str"], w["block"]))
    else:
        print("  %s -> NOT in write records (register-only or decoy)" % g)
