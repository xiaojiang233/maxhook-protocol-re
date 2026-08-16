import json, glob, os
from collections import defaultdict, Counter

D = r'E:\Coding\S1mple\target\keystream_slot_changes_capture_20260814'
files = sorted(glob.glob(os.path.join(D, '*.bin')))

samples = []
for f in files:
    with open(f, 'rb') as fh:
        samples.extend(json.loads(fh.read().decode('utf-8','replace')))

print("Total samples:", len(samples))
print("Call IDs (from filenames):")
calls = Counter()
for f in files:
    base = os.path.basename(f)
    # 000003_call_1_meta...
    m = base.split('_')
    calls[m[1]] += 1
print(dict(calls))

SLOT_A = 0x98c939
SLOT_B = 0x98cab9

# For each sample, determine the destination slot from 'destination' field
dest_counter = Counter()
for s in samples:
    dest_counter[s['destination']] += 1
print()
print("Destination address distribution:")
for d, c in dest_counter.most_common():
    slot = 'A' if d.lower() == hex(SLOT_A) else ('B' if d.lower() == hex(SLOT_B) else '?')
    print("  %s  (%s slot) : %d" % (d, slot, c))

# Now the core question: which writer_block last changed the destination slot (A or B)
# to the keystream_byte value, immediately before this XOR?

# Build: for each sample, the destination slot, and find in recent_changes the LAST
# change to that slot whose 'after' == keystream_byte (this is the keystream producer),
# plus the LAST change to that slot regardless (which might be the XOR itself if XOR
# already flipped it — but samples capture keystream_byte = pre-XOR value read from r8).

def last_change(change_list, slot, upto_seq, value=None):
    best = None
    for ch in change_list:
        if ch['slot'] != slot: continue
        if ch['sequence'] > upto_seq: continue
        if value is not None and ch['after'] != value: continue
        best = ch
    return best

writer_to_ks = Counter()      # writer_block that last wrote keystream byte into destination
writer_to_any = Counter()     # writer_block of last change to destination slot
xor_self_write = Counter()    # changes where writer_block is in XOR region (0x9c5xxx)

# XOR region: the XOR itself writes to the destination slot. In the slot-change capture,
# the XOR write appears as a change whose writer_block is 0x1809c544c / observer 0x1809c5612
# (observed right after XOR) OR the change after XOR.

for s in samples:
    kb = s['keystream_byte']
    seq = s['block_sequence']
    dest = s['destination']
    slot = 'A' if dest.lower() == hex(SLOT_A) else 'B'
    ch = s.get('recent_changes', [])
    # last change to destination slot == keystream byte (the producer)
    c_ks = last_change(ch, slot, seq, value=kb)
    c_any = last_change(ch, slot, seq)
    if c_ks is not None:
        writer_to_ks[(slot, c_ks['writer_block'], c_ks['observer_block'])] += 1
    if c_any is not None:
        writer_to_any[(slot, c_any['writer_block'], c_any['observer_block'])] += 1

print()
print("=== Writer(block)->observer(block) that last wrote the KEYSTREAM byte into the destination slot (before XOR) ===")
for (slot, w, o), c in sorted(writer_to_ks.items(), key=lambda x: -x[1]):
    print("  slot %s  writer=%s  observer=%s  : %d" % (slot, w, o, c))

print()
print("=== Writer->observer of LAST change to destination slot (any value) ===")
for (slot, w, o), c in sorted(writer_to_any.items(), key=lambda x: -x[1]):
    print("  slot %s  writer=%s  observer=%s  : %d" % (slot, w, o, c))

# Consistency: For each sample, does the last change to the destination slot equal keystream_byte?
# If not, the keystream byte was already in place from an earlier change (change list truncated at 128).
match = 0
nomatch = 0
for s in samples:
    kb = s['keystream_byte']
    seq = s['block_sequence']
    slot = 'A' if s['destination'].lower() == hex(SLOT_A) else 'B'
    c_any = last_change(s.get('recent_changes', []), slot, seq)
    if c_any is not None and c_any['after'] == kb:
        match += 1
    else:
        nomatch += 1
print()
print("Last-change==keystream_byte: %d / %d  (nomatch=%d)" % (match, len(samples), nomatch))
