#!/usr/bin/env python3
"""Analyze crypto_capture2 (pid 16448): the verify-set session.
It captured keyread (48 bytes) + nonce + mat_input32/input64/plaintext/context.
Determine: is this the crypto_verify_set.json session? Extract full key + nonces,
and check mat_context for the cipher VM context."""
import json
from pathlib import Path

P = Path(r"E:\Coding\S1mple\target\crypto_capture2")
lines = open(P / "events.jsonl", encoding="utf-8").read().splitlines()
events = [json.loads(l) for l in lines]

# decode keyread for events that have it
keyreads = []
for i, e in enumerate(events):
    if e.get("keyread_bytes", 0) > 0:
        kh = e["keyread_hex"]
        b = bytes.fromhex(kh)  # ascii-hex of ascii-hex
        # the raw bytes are ASCII of the real key hex
        real = b.decode("ascii")
        keyreads.append((i, e.get("nonce_hex"), real, len(real)//2))
        print("event %d: nonce=%s keyread(%dB hex): %s" % (i, e.get("nonce_hex"), len(real)//2, real))

# Also check mat_* events (input32/64/plaintext/context)
print("\nmat events:")
for i, e in enumerate(events):
    if e["kind"].startswith("mat_"):
        print("  %d: %s -> %s" % (i, e["kind"], {k:v for k,v in e.items() if k not in ('captured_at','kind','thread_id','module')}))

# full dump of all event kinds
print("\nall event kinds in order:")
for i, e in enumerate(events):
    print("  %2d: %s" % (i, e["kind"]))
