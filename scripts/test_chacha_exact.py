import struct
from pathlib import Path

def rotl32(v, c):
    return ((v << c) | (v >> (32 - c))) & 0xFFFFFFFF

def chacha20_block(key, counter, nonce):
    """Standard ChaCha20 block function (20 rounds)."""
    constants = [0x61707865, 0x3320646e, 0x79622d32, 0x6b206574]
    key_words = list(struct.unpack("<8I", key))
    nonce_words = list(struct.unpack("<3I", nonce))
    state = constants + key_words + [counter & 0xFFFFFFFF] + nonce_words
    working = state[:]
    def qr(x, a, b, c, d):
        x[a] = (x[a] + x[b]) & 0xFFFFFFFF
        x[d] ^= x[a]; x[d] = rotl32(x[d], 16)
        x[c] = (x[c] + x[d]) & 0xFFFFFFFF
        x[b] ^= x[c]; x[b] = rotl32(x[b], 12)
        x[a] = (x[a] + x[b]) & 0xFFFFFFFF
        x[d] ^= x[a]; x[d] = rotl32(x[d], 8)
        x[c] = (x[c] + x[d]) & 0xFFFFFFFF
        x[b] ^= x[c]; x[b] = rotl32(x[b], 7)
    for _ in range(10):
        qr(working, 0, 4, 8, 12)
        qr(working, 1, 5, 9, 13)
        qr(working, 2, 6, 10, 14)
        qr(working, 3, 7, 11, 15)
        qr(working, 0, 5, 10, 15)
        qr(working, 1, 6, 11, 12)
        qr(working, 2, 7, 8, 13)
        qr(working, 3, 4, 9, 14)
    out = []
    for i in range(16):
        out.append((working[i] + state[i]) & 0xFFFFFFFF)
    return b"".join(struct.pack("<I", w) for w in out)

def chacha20_keystream(key, counter, nonce, nblocks):
    ks = b""
    for i in range(nblocks):
        ks += chacha20_block(key, counter + i, nonce)
    return ks

# Ground truth: vm_context2 call1
KEY = bytes.fromhex("32206F9C196327AD276821AC8EBC7F80FE82D84CF72A4F7C1BAF508C97D3AEA8")
NONCE = bytes.fromhex("c38d500ac2ae8d2611ae1749")
P = Path(r"E:\Coding\S1mple\target\vm_context_capture2")
CT = bytes.fromhex((P/"000010_call_1_output_ciphertext_hex.bin").read_bytes().decode())
PT = (P/"000005_call_1_input_plaintext_json.bin").read_bytes()
KS = bytes(a^b for a,b in zip(PT, CT))
print("ground-truth keystream[0:64]:", KS[:64].hex())

# ChaCha20 with counter 0, nonce (3 words) 
for counter in (0, 1):
    ks = chacha20_keystream(KEY, counter, NONCE, 1)
    print("ChaCha20(counter=%d) keystream[0:32]: %s  match=%s" % (counter, ks[:32].hex(), 'YES' if ks[:32]==KS[:32] else ''))

# Also try nonce as the 3 words in different endianness, and counter as the 4th word
# ChaCha20 IETF: counter(32) || nonce(96)
# Try nonce as 12 bytes, counter as block counter starting at various values
for counter in range(8):
    ks = chacha20_keystream(KEY, counter, NONCE, 1)
    if ks[:8] == KS[:8]:
        print("MATCH ChaCha20 counter=%d" % counter)

print()
# Also try: is it Salsa20 (no counter, nonce 8 bytes)?
def salsa20_block(key, nonce, counter):
    pass  # skip for now

print("done")
