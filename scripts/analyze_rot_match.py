#!/usr/bin/env python3
"""Match rotation constants to known ARX algorithms precisely."""
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

# Distinct (site -> count) dominant mapping.  A site's "identity" is its fixed
# rotation.  Because VM reuses one rotate instruction per virtual slot, each
# (rva) may implement MULTIPLE roles.  Look at the GLOBAL distinct counts and
# map to candidate algorithms.

counts = collections.Counter(s["count"] for s in samples)
print("=== global rotation counts (all sites) ===")
for c in sorted(counts, key=lambda x: -counts[x]):
    print(f"  {c:2d}: {counts[c]:5d}")

# Candidate rotation constant sets:
algs = {
  "SHA-256 (Sigma/sigma)": {2,3,6,7,10,11,13,17,18,19,22,25},
  "SHA-512": {1,8,14,19,28,34,39,41,6,11,25,18},
  "BLAKE2s G": {16,12,8,7},
  "BLAKE2b G": {32,24,16,63},
  "ChaCha20 QR": {16,12,8,7},
  "Salsa20": {7,9,13,18},
  "Speck": {7,8},
  "RC5/RC6": set(),
  "SM3": {9,15,7,19,12},
  "CubeHash": {7,11},
}
print("\n=== coverage of top counts vs candidate sets ===")
top = {c for c, n in counts.items() if n >= 20}
print(f"  significant counts (>=20): {sorted(top)}")
for name, s in algs.items():
    inter = top & s
    frac = sum(counts[c] for c in inter)/sum(counts.values())
    print(f"  {name}: intersect={sorted(inter)} frac={frac:.3f}")

# BLAKE3 uses 7 rotations per round but shares ChaCha quarter-round {16,12,8,7}
# SipHash: 2 rotate amounts per round
# Let me also check the ratio of rol vs ror and per-site dominant constant pairs:
print("\n=== per-site dominant constant pair (round role) ===")
by_site = collections.defaultdict(collections.Counter)
for s in samples:
    by_site[s["rva"]][s["count"]] += 1
for rva, c in sorted(by_site.items()):
    top3 = c.most_common(3)
    print(f"  {rva}: {top3}")
