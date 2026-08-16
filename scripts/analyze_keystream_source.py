import json, glob, os
from collections import Counter

# keystream_source records: source byte -> destination. Map destination offsets.
D = r'E:\Coding\S1mple\target\keystream_source_capture_20260814'
files = sorted(glob.glob(os.path.join(D, '*.bin')))
recs = []
for f in files:
    with open(f,'rb') as fh:
        recs.extend(json.loads(fh.read().decode('utf-8','replace')))
print("keystream_source records:", len(recs))

VM_ABS = 0x18098c884   # module base 0x180000000 + VM_CONTEXT_RVA 0x98c884
dest_offsets = Counter()
for r in recs:
    d = int(r['destination'], 16)
    off = d - VM_ABS
    dest_offsets[off] += 1

print("Destination offsets from VM context base 0x98c884:")
for off, c in sorted(dest_offsets.items()):
    print("  +0x%03x (%d) : %d" % (off, off, c))

# Verify: source_byte == store_value low byte, and destination_after == source_byte
ok = sum(1 for r in recs if r.get('destination_after') == r['source_byte'])
print("records where destination_after==source_byte: %d / %d" % (ok, len(recs)))

# Also check store_value: it's r10d low byte
ok2 = sum(1 for r in recs if int(r['store_value'],16) & 0xff == r['source_byte'])
print("records where store_value&0xff==source_byte: %d / %d" % (ok2, len(recs)))

# The load source addresses (source = rax at 0xaa5bba)
src = Counter(r['source'] for r in recs)
print()
print("Source (load) addresses (top 10):")
for a,c in src.most_common(10):
    print("  %s : %d" % (a,c))
