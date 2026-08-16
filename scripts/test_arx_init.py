import struct
from pathlib import Path

P = Path(r"E:\Coding\S1mple\target\vm_context_capture2")
KEY = bytes.fromhex("32206F9C196327AD276821AC8EBC7F80FE82D84CF72A4F7C1BAF508C97D3AEA8")
kw = [struct.unpack("<I", KEY[i:i+4])[0] for i in range(0, 32, 4)]

pairs = []
for cid in range(1, 11):
    nonce = bytes.fromhex(list(P.glob("*call_%d*nonce*" % cid))[0].read_bytes().decode())
    ct = bytes.fromhex(list(P.glob("*call_%d*ciphertext*" % cid))[0].read_bytes().decode())
    pt = list(P.glob("*call_%d*plaintext*" % cid))[0].read_bytes()
    ks = bytes(a ^ b for a, b in zip(pt, ct))
    w0 = struct.unpack("<I", ks[0:4])[0]
    nw = [struct.unpack("<I", nonce[i:i+4])[0] for i in range(0, 12, 4)]
    pairs.append((nw, w0))

# The ARX round function (from fold region):
# state1 ^= (const3 ^ state1) - state2
# state1 ^= constA + state1 + state2
def arx_round(s1, s2, c3, cA):
    s1 = (s1 ^ (((c3 ^ s1) - s2) & 0xFFFFFFFF)) & 0xFFFFFFFF
    s1 = (s1 ^ ((cA + s1 + s2) & 0xFFFFFFFF)) & 0xFFFFFFFF
    return s1

# Key-schedule entry constants: 0x32f12c5a, 0x35a7d4cf
# Try: state1 = k0, state2 = n0, const = entry const
# word0 = arx_round(k0, n0, 0x32f12c5a, 0x35a7d4cf)?
for i, (nw, w0) in enumerate(pairs[:3]):
    for c3, cA in [(0x32f12c5a, 0x35a7d4cf), (0x35a7d4cf, 0x32f12c5a)]:
        r = arx_round(kw[0], nw[0], c3, cA)
        if r == w0:
            print("MATCH call%d: word0 = arx_round(k0, n0, %#x, %#x)" % (i+1, c3, cA))
    # Try state1 = n0, state2 = k0
    r = arx_round(nw[0], kw[0], 0x32f12c5a, 0x35a7d4cf)
    if r == w0:
        print("MATCH call%d: word0 = arx_round(n0, k0, entry)" % (i+1))

print("word0 for 10 calls:", [hex(w0) for _, w0 in pairs])
print("k0 = %#x" % kw[0])
print("n0 =", [hex(nw[0]) for nw, _ in pairs])

# Try a simple ChaCha-like: state = [k0..k7, n0..n2, counter], 1 round of qr
# Actually, let me test if word0 has any simple relation to k0 or n0
print("\nword0 XOR k0:")
for nw, w0 in pairs:
    print("  %#010x" % (w0 ^ kw[0]))
print("word0 XOR n0:")
for nw, w0 in pairs:
    print("  %#010x" % (w0 ^ nw[0]))
print("word0 - k0:")
for nw, w0 in pairs:
    print("  %#010x" % ((w0 - kw[0]) & 0xFFFFFFFF))
