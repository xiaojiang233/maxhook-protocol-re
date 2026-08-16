#!/usr/bin/env python3
"""Deep structural analysis of rot_samples for ARX reconstruction (read-only)."""
from __future__ import annotations
import collections, json, sys
from pathlib import Path

CAP = Path(r"E:\Coding\S1mple\target\rot_capture_20260814")

def load(cap: Path):
    events = [json.loads(l) for l in (cap/"events.jsonl").read_text(encoding="utf-8").splitlines()]
    calls = collections.defaultdict(list)
    for e in events:
        if e.get("kind") == "rot_samples":
            calls[int(e["call_id"])].extend(json.loads((cap/e["file"]).read_bytes()))
    return events, dict(calls)

events, calls = load(CAP)

for call_id, samples in sorted(calls.items()):
    print("="*90)
    print(f"CALL {call_id}: {len(samples)} samples")
    # --- per-site (rva,op) counts ---
    site = collections.Counter((s["rva"], s["op"]) for s in samples)
    print("  site_counts (order of magnitude):")
    for k, v in site.most_common():
        print(f"    {k[1]:>3} @ {k[0]}  x{v}")

    # --- rotation-count distribution per site ---
    print("  rotation counts (cl&31) per site:")
    by_site = collections.defaultdict(collections.Counter)
    for s in samples:
        by_site[(s["rva"], s["op"])][s["count"]] += 1
    for k in sorted(by_site, key=lambda k: -site[k]):
        c = by_site[k]
        top = c.most_common(6)
        print(f"    {k[1]:>3} @ {k[0]}  counts={dict(sorted(c.items()))}")
        print(f"          top6={top}")

    # --- target address locality: base + offsets ---
    addrs = [int(s["rax"], 16) for s in samples if s["rax"] != "0x0"]
    print(f"  target addresses: {len(set(addrs))} unique, min={hex(min(addrs))}, max={hex(max(addrs))}")
    if addrs:
        diffs = [b-a for a, b in zip(addrs, addrs[1:])]
        nd = [d for d in diffs if d != 0]
        print(f"  consecutive address deltas: nonzero={len(nd)}, distinct={sorted(set(nd))[:30]}")

print()
print("="*90)
print("ADJACENT-CALL SEMANTIC COMPARISON (rva,op,cl,before,after)")
def sem(s): return (s["rva"], s["op"], s["cl"], s["before"], s["after"])
ids = sorted(calls)
for left, right in zip(ids, ids[1:]):
    a = [sem(s) for s in calls[left]]
    b = [sem(s) for s in calls[right]]
    pref = 0
    while pref < min(len(a), len(b)) and a[pref] == b[pref]: pref += 1
    suff = 0
    while suff < min(len(a), len(b)) - pref and a[-1-suff] == b[-1-suff]: suff += 1
    print(f"  call {left} vs {right}: prefix={pref} suffix={suff} len={len(a)}/{len(b)}")
    # where does it diverge?
    print(f"    first divergence at index {pref}:")
    if pref < len(a) and pref < len(b):
        print(f"      left : {a[pref]}")
        print(f"      right: {b[pref]}")
    # middle differing region
    mid_l = a[pref:len(a)-suff] if suff else a[pref:]
    mid_r = b[pref:len(b)-suff] if suff else b[pref:]
    print(f"    middle region sizes: left={len(mid_l)} right={len(mid_r)}")

print()
print("="*90)
print("MOTIF DISCOVERY (site-op sequences)")
# Build site-op symbol sequence per call
for call_id in ids:
    seq = [(s["rva"], s["op"]) for s in calls[call_id]]
    # n-gram (window 8) most common motifs
    ng = collections.Counter(tuple(seq[i:i+8]) for i in range(len(seq)-7))
    print(f"CALL {call_id}: top 8-site op motifs:")
    for m, c in ng.most_common(8):
        ops = "".join(x[1][0] for x in m)  # 'r' or 'l'... actually rol/ror first letters r both
        ops = "".join(("L" if x[1]=="rol" else "R") for x in m)
        print(f"    x{c}  [{ops}]  {[x[0] for x in m]}")
