#!/usr/bin/env python3
"""Read the vm_enter_stack (8704B) to extract the exact register/stack state at
VM entry, the final piece for fold closure."""
import json
from pathlib import Path

P = Path(r"E:\Coding\S1mple\target\vm_context_capture2")
lines = open(P / "events.jsonl", encoding="utf-8").read().splitlines()
events = [json.loads(l) for l in lines]

# Find the vm_enter_stack event and its file
for e in events:
    if e.get("kind") == "vm_enter_stack" and e.get("call_id") == "1":
        print("vm_enter_stack event:", json.dumps({k: v for k, v in e.items()
              if k not in ("captured_at", "thread_id", "module", "kind")}, indent=1))
        break

# list files matching vm_enter_stack or stack
for f in sorted(P.glob("*call_1*stack*")):
    print("stack file:", f.name, f.stat().st_size)

# also check all call_1 meta files
for f in sorted(P.glob("*call_1*")):
    print("  ", f.name, f.stat().st_size)
