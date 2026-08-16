#!/usr/bin/env python3
"""Run the full emulator with vm_context_capture2's boundary data to correctly
model the encrypt prologue and produce the keystream.

The full emulator (emulate_maxhook_encrypt_boundary.py) has --boundary-dir mode
that restores the real key/context objects.  Let me check if vm_context_capture2
has the required event types (encrypt_enter, builder_frame, context_dump, etc.)
that the boundary mode needs."""
import json
from pathlib import Path

P = Path(r"E:\Coding\S1mple\target\vm_context_capture2")
lines = open(P / "events.jsonl", encoding="utf-8").read().splitlines()
events = [json.loads(l) for l in lines]

# Check event kinds the boundary mode needs
kinds = {}
for e in events:
    kinds.setdefault(e.get("kind"), 0)
    kinds[e.get("kind")] += 1
print("event kinds:", kinds)

# The emulator's select_boundary_events needs encrypt_enter, builder_frame, etc.
# Check call 1's encrypt_enter event fields
for e in events:
    if e.get("kind") == "encrypt_enter" and e.get("call_id") == "1":
        print("\nencrypt_enter call 1:", {k: v for k, v in e.items()
              if k not in ("captured_at", "thread_id", "module", "kind")})
        break

# Check builder_frame / context_dump events for call 1
for e in events:
    if e.get("kind") in ("builder_frame", "context_dump") and e.get("call_id") == "1":
        print(e.get("kind"), ":", {k: v for k, v in e.items()
              if k not in ("captured_at", "thread_id", "module", "kind")})
