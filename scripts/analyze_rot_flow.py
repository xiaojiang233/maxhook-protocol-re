#!/usr/bin/env python3
"""Trace value flow & detect block/round boundaries in rot_samples."""
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

# Value-flow: for each sample, does 'before' equal a prior sample's 'after'?
# Build a multiset of (value) from after's; check before membership.
print("=== value-flow: before values that appear as a prior 'after' ===")
afters_seen = collections.Counter()
flow_hits = 0
total = 0
for s in samples:
    if s["before"] is not None:
        total += 1
        if s["before"] in afters_seen:
            flow_hits += 1
    if s["after"] is not None:
        afters_seen[s["after"]] += 1
print(f"  {flow_hits}/{total} before-values were previously produced as after (memory-carried)")

# SHA-256 signature test: rotations {2,6,7,10,11,13,17,18,19,22,25}
sha = {2,6,7,10,11,13,17,18,19,22,25}
counts = collections.Counter(s["count"] for s in samples)
sha_fraction = sum(v for k,v in counts.items() if k in sha) / sum(counts.values())
print(f"  SHA-256 rotation-set coverage fraction: {sha_fraction:.3f}")
blake2s = {16,12,8,7}  # ChaCha quarter
chacha_frac = sum(v for k,v in counts.items() if k in blake2s) / sum(counts.values())
print(f"  ChaCha rotation-set coverage fraction: {chacha_frac:.3f}")
salsa = {7,9,13,18}
salsa_frac = sum(v for k,v in counts.items() if k in salsa) / sum(counts.values())
print(f"  Salsa rotation-set coverage fraction: {salsa_frac:.3f}")

# The 5 sites likely correspond to SHA-256's 4 sigma functions + 1 more.
# SHA-256 sigma rotations grouped by function:
#   Sigma0(a): ror 2, 13, 22   -> 3 rotates
#   Sigma1(e): ror 6, 11, 25   -> 3 rotates
#   sigma0(w): ror 7, 18, 3    -> 3 rotates
#   sigma1(w): ror 17, 19, 10  -> 3 rotates
# That's 12 rotate sites in native SHA-256.  We only have 5 sites -> likely a
# VM that reuses a single rotate "op" per role, OR a different construction.
# BLAKE2s: rotations 16,12,8,7 (G function, 4 rotates), 10 rounds.
# BLAKE2b: rotations 32,24,16,63.

print("\n=== distinct rax target slots and their role (site->addr mapping) ===")
# map: for each rax slot, which sites touch it
slot_sites = collections.defaultdict(set)
for s in samples:
    slot_sites[s["rax"]].add((s["rva"], s["op"]))
for slot in sorted(slot_sites, key=lambda x: int(x,16)):
    print(f"  {slot}: {sorted(slot_sites[slot])}")

# The address layout: group slots by proximity (strides)
addrs = sorted({int(s["rax"],16) for s in samples})
print(f"\n=== sorted unique target addresses ({len(addrs)}) ===")
for a in addrs:
    print(f"  0x{a:x}  (+{a-addrs[0]:#x})")
