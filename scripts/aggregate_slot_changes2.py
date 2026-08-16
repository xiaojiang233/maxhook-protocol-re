import json, glob, os
from collections import defaultdict, Counter

D = r'E:\Coding\S1mple\target\keystream_slot_changes_capture_20260814'
files = sorted(glob.glob(os.path.join(D, '*.bin')))
samples = []
for f in files:
    with open(f, 'rb') as fh:
        samples.extend(json.loads(fh.read().decode('utf-8','replace')))

def slot_of(dest):
    d = dest.lower()
    if d.endswith('98c939'): return 'A'
    if d.endswith('98cab9'): return 'B'
    return '?'

# Confirm slot mapping
for s in samples[:3]:
    print(s['destination'], '->', slot_of(s['destination']))

def last_change(change_list, slot, upto_seq, value=None):
    best = None
    for ch in change_list:
        if ch['slot'] != slot: continue
        if ch['sequence'] > upto_seq: continue
        if value is not None and ch['after'] != value: continue
        best = ch
    return best

# Destination slot distribution
destc = Counter(slot_of(s['destination']) for s in samples)
print("Destination slot distribution:", dict(destc))

# For slot A and slot B separately: which writer last wrote keystream byte.
A_ks = Counter()
B_ks = Counter()
for s in samples:
    kb = s['keystream_byte']; seq = s['block_sequence']
    dslot = slot_of(s['destination'])
    ch = s.get('recent_changes', [])
    c_ks = last_change(ch, dslot, seq, value=kb)
    if c_ks is None: continue
    if dslot == 'A': A_ks[(c_ks['writer_block'], c_ks['observer_block'])] += 1
    else: B_ks[(c_ks['writer_block'], c_ks['observer_block'])] += 1

print()
print("=== SLOT A: writer->observer that last wrote keystream byte (before XOR) ===")
for (w,o),c in A_ks.most_common(15):
    print("  writer=%s observer=%s : %d" % (w,o,c))
print()
print("=== SLOT B: writer->observer that last wrote keystream byte (before XOR) ===")
for (w,o),c in B_ks.most_common(15):
    print("  writer=%s observer=%s : %d" % (w,o,c))

# The XOR itself: after XOR, the destination slot changes to ciphertext.
# In slot-change capture, the XOR write to slot A is observed as a change with
# writer_block = block containing the XOR (0x1809c544c..0x1809c5612 region).
# Let's find the change that represents the XOR's own write: the LAST change to the
# destination slot, and check if its observer is in the post-XOR region (0x1809c5612/0x9c56b4).

# Identify XOR-region blocks: writer in [0x9c544c, 0x9c56b4]
def is_xor_region(addr):
    a = int(addr, 16)
    return 0x9c5400 <= a <= 0x9c5800

# For each sample: the change right AFTER the XOR (sequence >= xor block_sequence) representing ciphertext write
xor_writer_counter = Counter()
for s in samples:
    seq = s['block_sequence']
    dslot = slot_of(s['destination'])
    ch = s.get('recent_changes', [])
    # find first change to dslot with sequence >= seq (the XOR's own write, or near it)
    for c in ch:
        if c['slot'] == dslot and c['sequence'] >= seq:
            xor_writer_counter[(c['writer_block'], c['observer_block'], c['sequence']-seq)] += 1
            break

print()
print("=== First change to destination slot at/after XOR (the XOR's own write) ===")
for (w,o,d),c in xor_writer_counter.most_common(15):
    print("  writer=%s observer=%s  seq_delta=%+d : %d" % (w,o,d,c))

# Also: how many samples have a change to destination slot exactly at the XOR sequence
# with writer_block 0x1809c544c (the block immediately before XOR, which is where the
# keystream byte gets finalized into the slot before XOR)?
at_xor = Counter()
for s in samples:
    seq = s['block_sequence']
    dslot = slot_of(s['destination'])
    for c in s.get('recent_changes', []):
        if c['slot'] == dslot and c['sequence'] == seq:
            at_xor[(c['writer_block'], c['observer_block'], c['before'], c['after'])] += 1
print()
print("=== Changes to destination slot with sequence == XOR block_sequence (top) ===")
for (w,o,b,a),c in at_xor.most_common(15):
    print("  writer=%s observer=%s  before=%d after=%d : %d" % (w,o,b,a,c))
