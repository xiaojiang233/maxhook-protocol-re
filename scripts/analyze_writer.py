#!/usr/bin/env python3
import json, struct, glob, os

files = sorted(glob.glob(r"E:\Coding\S1mple\target\writer_calls_manual_20260814_013014\*.bin"))

def parse(f):
    j = json.loads(open(f).read())
    return j

print("Writer call records analysis (store32 @ 0x41a860 = keystream writer)")
print("="*100)
for f in files[:4]:
    recs = parse(f)
    print(f"\n--- {os.path.basename(f)}  ({len(recs)} records) ---")
    # show first 8 records
    for r in recs[:8]:
        print(f"  dest={r['destination']}  offset={r['offset']:+d}  value={r['value']}  ret={r.get('return_address')}")

# Analyze the return addresses (callers of store32)
print("\n\n" + "="*100)
print("Return address (caller) distribution across all calls")
print("="*100)
from collections import Counter
ret_counter = Counter()
for f in files:
    recs = parse(f)
    for r in recs:
        ret_counter[r.get('return_address')] += 1
for ret, cnt in ret_counter.most_common(30):
    print(f"  {ret}  x{cnt}")

# Analyze offset range and value range
print("\n\n" + "="*100)
print("Offset distribution (within the 64-byte buffer)")
print("="*100)
all_recs = []
for f in files:
    all_recs.extend(parse(f))
offs = [r['offset'] for r in all_recs]
print(f"  total records: {len(all_recs)}")
print(f"  min offset: {min(offs)}, max offset: {max(offs)}")
off_counter = Counter(offs)
print("  offset histogram:")
for off, cnt in sorted(off_counter.items()):
    print(f"    offset {off:+d}: {cnt}")
