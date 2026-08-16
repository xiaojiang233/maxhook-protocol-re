#!/usr/bin/env python3
"""Identify round structure & fixed-constant rotations from rot_samples."""
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
samples = calls[2]

# The key question: is the rotation count a FIXED constant per (site, target-address)?
# ChaCha/Salsa: each site has one hardcoded rotation.  If count varies at one site,
# it's data-dependent (RC5/RC6 style) OR the same site is reused for multiple rounds
# with different constants via immediate, which is impossible for a single instruction.
# Instead, VM likely has one rotate instruction per "virtual register" slot.

# Build per (rva, rax) -> count histogram
keyhist = collections.defaultdict(collections.Counter)
for s in samples:
    keyhist[(s["rva"], s["rax"])][s["count"]] += 1

print("=== per (site, target-address) rotation-count purity ===")
# How many keys have exactly 1 distinct count (fixed) vs >1 (data-dependent)?
fixed = 0; data = 0
data_keys = []
for k, c in keyhist.items():
    if len(c) == 1:
        fixed += 1
    else:
        data += 1
        data_keys.append((k, c.most_common(4), sum(c.values())))
print(f"  fixed-count (site,addr) keys: {fixed}")
print(f"  variable-count (site,addr) keys: {data}")
print("  variable keys (site, addr, top counts, total):")
for k, top, tot in sorted(data_keys, key=lambda x: -x[2]):
    print(f"    {k[0]} @ {k[1]}  top={top} total={tot}")

print("\n=== fixed (site,addr) -> exact count table ===")
fixed_map = {}
for k, c in keyhist.items():
    if len(c) == 1:
        cnt = next(iter(c))
        fixed_map[k] = cnt
# group by site
by_site_fixed = collections.defaultdict(list)
for (rva, rax), cnt in sorted(fixed_map.items()):
    by_site_fixed[rva].append((rax, cnt))
for rva in sorted(by_site_fixed):
    lst = by_site_fixed[rva]
    cnts = collections.Counter(c for _, c in lst)
    print(f"  {rva}: {len(lst)} fixed addrs, count distribution={dict(sorted(cnts.items()))}")

# Determine: which site carries which "round constants"
# Salsa20: 7,9,13,18.  ChaCha20: 16,12,8,7.
print("\n=== global count totals across all sites ===")
g = collections.Counter(s["count"] for s in samples)
for c, n in g.most_common(20):
    print(f"  rot by {c:2d}: {n}")
