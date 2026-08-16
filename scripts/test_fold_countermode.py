import json, struct
from pathlib import Path

# writer_sync call 1: key 347230E6, nonce 96e71401..., ground-truth keystream
a = json.loads(Path(r"E:\Coding\S1mple\target\writer_sync_clean_20260814_014351\analysis.json").read_text(encoding="utf-8"))
c1 = a["calls"][0]
ks = bytes.fromhex(c1["keystream_hex"])
print("writer_sync call1 keystream len:", len(ks))
words = [struct.unpack("<I", ks[i:i+4])[0] for i in range(0, len(ks) - 3, 4)]
print("keystream words (LE):")
for i, w in enumerate(words[:16]):
    print("  word[%2d] = %#010x" % (i, w))

# The keystream is counter-mode: word_i = fold(key_state, block_i, byte_offset_i)
# block = i // 16 (16 words per 64B block), byte_offset = (i % 16) * 4
# Test: is word_i = some_key_word XOR (block * something + offset)?

# Check the fold arithmetic hypothesis: 
#   rdx-chain: add rdx,rbx; sub rdx,0x7ef78e7d; shr rdx,3; shl rdx,1
# This is: rdx = ((rdx + rbx - 0x7ef78e7d) >> 3) << 1
# Note: shr 3 then shl 1 = (x >> 3) << 1 = clears low 3 bits then shifts, = (x & ~7) << 1... 
# Actually (x >> 3) << 1 = (x // 8) * 2 = x/4 (integer, but loses bits)

# Let me check if there's a simple relationship between consecutive words
print("\nword differences (XOR consecutive):")
for i in range(4):
    print("  word[%d]^word[%d] = %#010x" % (i, i+1, words[i] ^ words[i+1]))

# Check: is the keystream = AES-like or ChaCha-like with a counter?
# The block counter (0x26) increments per 64B block (16 words)
# Let me check if word[16] (block 1) relates to word[0] (block 0)
print("\nblock 0 vs block 1 first words:")
print("  word[0]  = %#010x" % words[0])
print("  word[16] = %#010x" % words[16])
print("  XOR = %#010x" % (words[0] ^ words[16]))
print("  word[32] = %#010x" % words[32] if len(words) > 32 else "N/A")

# The key_state is constant within a call. The counter varies.
# If fold = f(key_state) XOR g(counter), then word_i XOR word_j = g(counter_i) XOR g(counter_j)
# = function of (counter_i, counter_j) only, INDEPENDENT of key_state.
# This means: across DIFFERENT keys (same counter), word_i XOR word_j should be SAME.
# We can test this with vm_context2 (10 keystreams, same key, but same counter positions)
