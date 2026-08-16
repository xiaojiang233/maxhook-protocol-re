import json, struct
from pathlib import Path

# The fold is counter-mode: keystream byte = F(key_state, block_counter, byte_offset)
# key_state is constant within a call. counter varies.
# From keystream_history: 3 calls (3 different keys), each with snapshots at
# different xor_index (byte offsets).

# Extract: for each call, the keystream bytes at consecutive byte offsets.
# If fold = f(key_state) XOR g(counter), then across SAME key_state:
#   ks[i] XOR ks[j] = g(counter_i) XOR g(counter_j)  (independent of key)
# We can test: is ks[i] XOR ks[j] the SAME across different calls (same counter)?
P = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")
snaps_by_call = {}
for call in (1, 2, 3):
    snaps = []
    for f in sorted(P.glob("*call_%d*.bin" % call)):
        d = json.loads(f.read_bytes().decode("utf-8"))
        snaps.append(d)
    snaps_by_call[call] = snaps

# Each snapshot has xor_index (byte offset) and keystream_byte.
# The keystream byte is a SINGLE byte at a byte offset.
# But the fold produces a 32-bit word. So 4 consecutive bytes = 1 word.
# Let me check: does the fold produce bytes or words?

# The keystream bytes are at xor_index 0, 64, 128, 192 (per 64B block).
# Wait, xor_index 0, 64, 128... means the keystream byte is captured every 64 bytes.
# That's ONE byte per 64-byte block, not per byte!

# Let me re-examine: the snapshots are at XOR moments (every 64 bytes).
print("Call 1 snapshots (xor_index, keystream_byte):")
for s in snaps_by_call[1]:
    print("  xor_index=%d  ks_byte=%02x" % (s['xor_index'], s['keystream_byte']))

# So the keystream byte is captured every 64 bytes (one byte per block).
# This means: keystream_byte = the byte at position (xor_index) of the keystream.
# The fold produces the keystream WORD, and each byte of the word goes to a
# different position.

# Actually, looking at the data: xor_index goes 0, 64, 128, 192, 256...
# These are byte positions in the keystream, spaced 64 bytes apart.
# So the keystream_byte is the byte at that position.

# The fold produces 16 words per 64B block. Each word = 4 bytes.
# The byte at position 0, 64, 128... = byte 0 of word 0, word 16, word 32...

# Let me correlate with writer_sync (which has FULL keystream):
a = json.loads(Path(r"E:\Coding\S1mple\target\writer_sync_clean_20260814_014351\analysis.json").read_text(encoding="utf-8"))
ks = bytes.fromhex(a["calls"][0]["keystream_hex"])
print("\nwriter_sync call1 full keystream:")
print("  byte[0]  = %02x" % ks[0])
print("  byte[64] = %02x" % ks[64])
print("  byte[128]= %02x" % ks[128])

# The keystream_history call1 keystream bytes: 0xf7, 0xde, 0x40, 0x6d...
# writer_sync (different key) call1: byte[0]=0x32, byte[64]=?, ...
# These are different keys, so no direct comparison.

# Key question: can I determine F(key_state, counter) from the 3 calls × 52 snapshots?
# Each call has a different key_state (different key). The counter is the same
# (0, 64, 128, 192...).
# So I have 3 (key_state, counter) -> keystream_byte data points per counter value.
# That's not enough to determine the full F (needs many key_state values).

print("\nConclusion: 3 calls = 3 key_state values, insufficient to fit F")
print("The fold is F(key_state_105bytes, counter). Need more key_state samples")
print("or the exact ARX recurrence (already decoded at handler level).")
