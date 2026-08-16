import json, glob, os
from collections import defaultdict, Counter

D = r'E:\Coding\S1mple\target\keystream_slot_changes_capture_20260814'
files = sorted(glob.glob(os.path.join(D, '*.bin')))

samples = []  # list of dicts
for f in files:
    with open(f, 'rb') as fh:
        data = json.loads(fh.read().decode('utf-8', 'replace'))
    samples.extend(data)

print("Total samples:", len(samples))
print("Total files:", len(files))

# Group by call_id (derived from filename: 000003_call_1...)
by_call = defaultdict(list)
for f in files:
    base = os.path.basename(f)
    # pattern: NNNNNN_call_M_meta...
    parts = base.split('_')
    call_id = parts[1].replace('call','')
    by_call[call_id].append(f)

print("Calls:", sorted(by_call.keys()))

# Now, per sample, analyze the recent_changes. Key questions:
# 1) Which writer_block/observer_block changed slot A and slot B to the keystream byte value
#    immediately before the XOR at 0x1809c5561?
# 2) Distinguish ciphertext changes caused by the XOR itself vs by keystream generation.

# The XOR instruction is at 0x1809c5561. The XOR reads destination (r8) and plaintext (r12).
# keystream_byte = destination value read at XOR = value of slot.
# The relevant change for slot A/B that sets the keystream byte is the LAST change to that
# slot whose value equals keystream_byte, immediately before the XOR's block_sequence.

# Build per-call analysis.
XOR = 0x1809c5561

# We want: for each sample, identify the writer_block that last wrote the keystream byte
# to slot A and slot B (the "keystream byte" is read from destination=r8 at XOR).
# But which slot (A or B) is the destination? Need to understand slots.
# Slot A offset 0xb5, Slot B offset 0x235, VM context at 0x98c884.
# Destination in samples is 0x18098c939 = 0x98c884 + 0xb5 = 0x98c939. So slot A is the destination!
# 0x98c884 + 0xb5 = 0x98c939. Yes. Slot A = destination = the keystream byte slot.
# Slot B = 0x98c884 + 0x235 = 0x98cab9.

print()
print("Slot A addr = 0x%x, Slot B addr = 0x%x" % (0x98c884+0xb5, 0x98c884+0x235))
print("Destination in samples = 0x18098c939 -> slot A is the XOR destination (keystream byte).")
print()

# Aggregate: for each sample, find the last recent_change for slot A before block_sequence
# whose 'after' == keystream_byte. Also record the change immediately before that sets it.
def last_change_to(change_list, slot, value, upto_seq):
    best = None
    for ch in change_list:
        if ch['slot'] == slot and ch['sequence'] <= upto_seq:
            if ch['after'] == value:
                best = ch
    return best

# Also want the very last change to slot A regardless of value (to see what's latest)
def last_change_slot(change_list, slot):
    best = None
    for ch in change_list:
        if ch['slot'] == slot:
            best = ch
    return best

slotA_writers = Counter()   # writer_block -> count (change that set A to keystream byte)
slotB_writers = Counter()
xor_writer = Counter()      # writer_block that produced keystream via XOR itself?
mismatch = 0
matched_A = 0
matched_B = 0
total = 0

# Check consistency: keystream_byte vs plaintext_byte XOR? We don't have ciphertext directly.
# But we can check: does slot A 'after' == keystream_byte hold for the last A change?

# Also examine the writer 0x1809c544c which appears repeatedly and seems correlated with XOR region.

for s in samples:
    total += 1
    ch = s.get('recent_changes', [])
    kb = s['keystream_byte']
    seq = s['block_sequence']
    # last change to slot A
    la = last_change_slot(ch, 'A')
    lb = last_change_slot(ch, 'B')
    # change that set A to keystream byte
    ca = last_change_to(ch, 'A', kb, seq)
    cb = last_change_to(ch, 'B', kb, seq)
    if ca is not None:
        matched_A += 1
        slotA_writers[ca['writer_block']] += 1
    if cb is not None:
        matched_B += 1
        slotB_writers[cb['writer_block']] += 1
    # record final A value and whether equals kb
    if la is not None and la['after'] != kb:
        mismatch += 1

print("Samples analyzed:", total)
print("Slot A last-change value == keystream_byte in %d samples (%.1f%%)" % (matched_A, 100*matched_A/total if total else 0))
print("Slot B last-change value == keystream_byte in %d samples (%.1f%%)" % (matched_B, 100*matched_B/total if total else 0))
print("Samples where final A != keystream_byte:", mismatch)
print()
print("=== Writer blocks that set SLOT A to the keystream byte (top 20) ===")
for w,c in slotA_writers.most_common(20):
    print("  %s : %d" % (w,c))
print()
print("=== Writer blocks that set SLOT B to the keystream byte (top 20) ===")
for w,c in slotB_writers.most_common(20):
    print("  %s : %d" % (w,c))

# Now analyze the XOR instruction region. The XOR is at 0x1809c5561.
# writer_block 0x1809c544c with observer 0x1809c5612 repeatedly appears to change A then B.
# This is likely the block BEFORE the XOR that loads the keystream byte and plaintext.
# Let's look at the change pairs around the XOR for each sample: the last A change and last B change
# before the XOR, with their writer blocks, plus the sequence deltas to the XOR block_sequence.

print()
print("=== Per-sample: last A-change and last B-change before XOR, with seq delta ===")
seen = 0
for s in samples:
    ch = s.get('recent_changes', [])
    seq = s['block_sequence']
    la = last_change_slot(ch, 'A')
    lb = last_change_slot(ch, 'B')
    def f(c):
        if c is None: return None
        return (c['slot'], c['writer_block'], c['observer_block'], c['before'], c['after'], seq-c['sequence'])
    print("  xor=%d kb=%d pt=%d | A:%s | B:%s" % (s['xor_index'], s['keystream_byte'], s['plaintext_byte'], f(la), f(lb)))
    seen += 1
    if seen >= 40:
        print("  ... (showing first 40)")
        break
