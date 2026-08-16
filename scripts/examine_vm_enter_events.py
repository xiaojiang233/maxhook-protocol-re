#!/usr/bin/env python3
"""Examine vm_enter_stack and vm_enter_context events — these capture the exact
VM entry state (context + stack) for driving the key-schedule."""
import json
from pathlib import Path

P = Path(r"E:\Coding\S1mple\target\vm_context_capture2")
lines = open(P / "events.jsonl", encoding="utf-8").read().splitlines()
events = [json.loads(l) for l in lines]

for e in events:
    if e.get("kind") in ("vm_enter_context", "vm_enter_stack") and e.get("call_id") == "1":
        print(e.get("kind"), ":", json.dumps({k: v for k, v in e.items()
              if k not in ("captured_at", "thread_id", "module", "kind")}, indent=1))
        print()

# check the encrypt_enter for call 1 (full fields)
for e in events:
    if e.get("kind") == "encrypt_enter" and e.get("call_id") == "1":
        print("encrypt_enter:", json.dumps({k: v for k, v in e.items()
              if k not in ("captured_at", "thread_id", "module", "kind")}, indent=1))
