#!/usr/bin/env python3
"""Determine cipher identity & ARX semantics from rot_samples (read-only)."""
from __future__ import annotations
import collections, json
from pathlib import Path

CAP = Path(r"E:\Coding\S1mple\target\rot_capture_20260814")

def load(cap):
    events = [json.loads(l) for l in (cap/"events.jsonl").read_text(encoding="utf-8").splitlines()]
    calls = collections.defaultdict(list)
    for e in events:
        if e.get("kind") == "rot_samples":
            calls[int(e["call_id"])].extend(json.loads((cap/e["file"]).read_bytes()))
    return dict(calls)

calls = load(CAP)
# Use the full call 2 (largest, canonical)
samples = calls[2]
print(f"analyzing call 2: {len(samples)} samples")

# Group consecutive same-site runs: find the canonical repeating cycle
# First, determine the site address -> role by looking at whether 'count' is a
# constant per site (hardcoded rotation) or data-dependent (RC5: count = y & 31).
print("\n=== rotation-count: constant vs data-dependent ===")
by_site = collections.defaultdict(collections.Counter)
for s in samples:
    by_site[s["rva"]][s["count"]] += 1
for rva, c in sorted(by_site.items()):
    total = sum(c.values())
    top = c.most_common(3)
    entropy = len(c)
    # dominant fraction
    dom = top[0][1] / total if top else 0
    print(f"  {rva}: total={total} distinct_counts={entropy} dominant={top} dom_frac={dom:.3f}")

# RC5 test: count == (before & 0x1f)?  Check correlation between cl and before for
# a site where count is data-dependent.  Also test count == (after & 0x1f)?
print("\n=== RC5 hypothesis: rotation count derived from a data value ===")
# For each site, test whether cl == (some prior value & 31)
for rva in ["0xaf6547", "0xa164be", "0xa59e63", "0xb5f49c", "0xb3cbf4"]:
    ss = [s for s in samples if s["rva"] == rva]
    # does count correlate with low 5 bits of 'before'?
    match_before = sum(1 for s in ss if s["before"] is not None and (s["before"] & 31) == s["count"])
    match_after = sum(1 for s in ss if s["after"] is not None and (s["after"] & 31) == s["count"])
    print(f"  {rva}: count==before&31 {match_before}/{len(ss)}  count==after&31 {match_after}/{len(ss)}")

# ChaCha quarter round uses fixed constants. Identify the block structure.
# Look at the exact sequence of (site, count) pairs — print a canonical cycle.
print("\n=== canonical instruction cycle (site,op,count) — first 64 samples ===")
for i, s in enumerate(samples[:64]):
    print(f"  {i:3d} {s['op']:>3} @ {s['rva']}  cl={s['cl']:3d} count={s['count']:2d}  rax={s['rax']}")

# Determine address stride pattern: map rax offset relative to a base
print("\n=== target address offsets (rax - 0x18098c000) for first 64 ===")
for s in samples[:64]:
    a = int(s["rax"], 16)
    print(f"  offset={a-0x18098c000:#x}  {s['op']} @ {s['rva']}")
