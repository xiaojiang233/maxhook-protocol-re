import struct
from pathlib import Path

P = Path(r"E:\Coding\S1mple\target\vm_context_capture2")
KEY = bytes.fromhex("32206F9C196327AD276821AC8EBC7F80FE82D84CF72A4F7C1BAF508C97D3AEA8")

pairs = []
for cid in range(1, 11):
    nonce = bytes.fromhex(list(P.glob("*call_%d*nonce*" % cid))[0].read_bytes().decode())
    ct = bytes.fromhex(list(P.glob("*call_%d*ciphertext*" % cid))[0].read_bytes().decode())
    pt = list(P.glob("*call_%d*plaintext*" % cid))[0].read_bytes()
    ks = bytes(a ^ b for a, b in zip(pt, ct))
    w0 = struct.unpack("<I", ks[0:4])[0]
    pairs.append((nonce, w0))

print("10 (nonce, keystream word0) pairs, same key:")
for i, (n, w0) in enumerate(pairs):
    print("  call %2d: nonce=%s  word0=%#010x" % (i+1, n.hex(), w0))

# Test: is word0 a linear function of nonce?
# If word0 = f(key) XOR g(nonce) where g is linear, then
# word0_i XOR word0_j = g(nonce_i) XOR g(nonce_j) = h(nonce_i XOR nonce_j)
# Test: does word0 XOR depend only on nonce XOR?
print("\nTest linear nonce dependence:")
for i in range(10):
    for j in range(i+1, 10):
        dw = pairs[i][1] ^ pairs[j][1]
        dn = bytes(a^b for a,b in zip(pairs[i][0], pairs[j][0]))
        # check if dw is a simple function of dn
        dn0 = struct.unpack("<I", dn[0:4])[0]
        dn1 = struct.unpack("<I", dn[4:8])[0]
        dn2 = struct.unpack("<I", dn[8:12])[0]
        # try dw == dn0, dn0^dn1^dn2, etc
        for label, val in [("dn0", dn0), ("dn0^dn1", dn0^dn1), ("dn0^dn1^dn2", dn0^dn1^dn2),
                            ("dn0+dn1+dn2", (dn0+dn1+dn2)&0xffffffff)]:
            if val == dw:
                print("  LINEAR! word0[%d]^word0[%d] = %s" % (i+1, j+1, label))
print("  (no linear nonce dependence found)" )

# Alternative: is word0 = key_state XOR nonce_word (where key_state is fixed)?
# Then word0_i XOR word0_j = nonce_i XOR nonce_j (at some word position)
print("\nTest word0 = key_state XOR nonce_word:")
for i in range(10):
    for j in range(i+1, 10):
        dw = pairs[i][1] ^ pairs[j][1]
        for k in range(3):
            dn = struct.unpack("<I", pairs[i][0][k*4:k*4+4])[0] ^ struct.unpack("<I", pairs[j][0][k*4:k*4+4])[0]
            if dn == dw:
                print("  word0[%d]^word0[%d] = nonce_word%d XOR" % (i+1, j+1, k))
print("  (done)")
