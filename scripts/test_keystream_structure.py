import struct
from pathlib import Path

# Work backwards: keystream word0 = fold(key_state, counter=0, offset=0)
# The fold's 6 inputs at block 0, offset 0:
#   +0xb5 (keystream byte accumulator), +0x26 (block=0), +0xd9 (offset=0),
#   +0x61 (state ptr), +0xbd (key ptr), +0x106 (state)
# The keystream word0 is the fold OUTPUT.

# The fold arithmetic (confirmed round 248-251):
#   rdx-chain: rdx = ((shl(rdx,1) >> 3) + rbx) - 0x7ef78e7d
#   r13-chain: r13 = not(neg(not((r13 - ebp) + 0x47f75fb8)))
#   aux: r14 ^= 0x77914aff; r10 += 0x1bd67eac; r8 -= 0x1f5ff464
# Final EDX = value on VM data stack (result of 6 pushes + ARX).

# Since the final EDX comes from the stack (not a simple convergence), and I
# don't have the exact convergence, I can't easily invert.

# But here's the key: the keystream word0 depends on key_state (constant within
# call) + counter (0 at block 0).  For the SAME key, different nonces -> different
# key_state -> different word0.

# Let me check: is the key_state a SIMPLE function of (key, nonce) that I can
# determine from 10 (nonce -> word0) samples?

# Actually, let me reconsider the whole thing at a higher level. The cipher is:
#   keystream = ARX_cipher(key, nonce)
# This is a deterministic function. I have 10 (nonce -> word0) samples with same key.

# The most important remaining question: can I determine the cipher's STRUCTURE
# (the exact ARX recurrence) from the 10 samples + the decoded handler semantics?

# The handler semantics ARE the recurrence. The issue is the INITIAL state.

# Let me check one concrete thing: does the keystream word0 have a relationship
# to the nonce that reveals the key-schedule's nonce mixing?

KEY = bytes.fromhex("32206F9C196327AD276821AC8EBC7F80FE82D84CF72A4F7C1BAF508C97D3AEA8")
kw = [struct.unpack("<I", KEY[i:i+4])[0] for i in range(0, 32, 4)]

P = Path(r"E:\Coding\S1mple\target\vm_context_capture2")
pairs = []
for cid in range(1, 11):
    nonce = bytes.fromhex(list(P.glob("*call_%d*nonce*" % cid))[0].read_bytes().decode())
    ct = bytes.fromhex(list(P.glob("*call_%d*ciphertext*" % cid))[0].read_bytes().decode())
    pt = list(P.glob("*call_%d*plaintext*" % cid))[0].read_bytes()
    ks = bytes(a ^ b for a, b in zip(pt, ct))
    w0 = struct.unpack("<I", ks[0:4])[0]
    w1 = struct.unpack("<I", ks[4:8])[0]
    w2 = struct.unpack("<I", ks[8:12])[0]
    pairs.append((nonce, [w0, w1, w2]))

# Check if word0 across nonces reveals a key-schedule pattern.
# The key-schedule INIT mixes key + nonce. If the mixing is:
#   state[i] = key_word[i] XOR nonce_word[j]  (simple XOR)
# then word0 (which depends on state) would show XOR patterns.
# We already ruled this out (round 240). 

# Let me check: is the keystream word0 = f(key_words) where f is the SAME
# function applied to a nonce-mixed key?  I.e., the nonce modifies the key
# via a simple operation, then the ARX cipher runs.

# Test: word0_i XOR word0_j should equal a function of nonce_i XOR nonce_j
# ONLY if the nonce enters via XOR. We ruled this out.

# The nonce must enter via ADD (modular), or via the ARX round directly.

print("keystream word0/word1/word2 for 10 nonces (same key):")
for i, (n, ws) in enumerate(pairs):
    print("  call %2d: nonce=%s  w0=%08x w1=%08x w2=%08x" % (i+1, n.hex(), ws[0], ws[1], ws[2]))

# Check: is there a relationship between word0 and word1 within each call
# that's consistent (revealing the block-to-block recurrence)?
# If the block-to-block recurrence is counter-based (not key-dependent),
# then word0^word1 should be CONSTANT across calls (same counter delta 0->1).
# Let me check.
d = [pairs[i][1][0] ^ pairs[i][1][1] for i in range(10)]
print("\nword0^word1 values across calls:")
for x in d:
    print("  %08x" % x)
print("constant across calls?", len(set(d)) == 1)
