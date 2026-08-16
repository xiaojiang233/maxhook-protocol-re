#!/usr/bin/env python3
"""Inspect boundary2 session event kinds to understand what the emulator's
--boundary-dir needs."""
import json
from pathlib import Path

P = Path(r"E:\Coding\S1mple\target\encrypt_boundary_capture2")
lines = open(P / "events.jsonl", encoding="utf-8").read().splitlines()
events = [json.loads(l) for l in lines]

kinds = {}
for e in events:
    k = e.get("kind")
    kinds.setdefault(k, 0)
    kinds[k] += 1
print("event kinds:", kinds)

# show the key boundary events
for e in events:
    k = e.get("kind")
    if k in ("encrypt_enter", "builder_frame", "context_dump", "send_stack",
             "encrypt_hook_installed", "crypto_installed"):
        print("  ", k, {kk: vv for kk, vv in e.items()
                        if kk not in ("captured_at", "thread_id", "module", "kind")})
