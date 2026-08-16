import hashlib
from pathlib import Path
P = Path(r"E:\Coding\S1mple\target\vm_context_capture2")
KEY = bytes.fromhex("32206F9C196327AD276821AC8EBC7F80FE82D84CF72A4F7C1BAF508C97D3AEA8")
nonces = []
for cid in range(1, 11):
    f = list(P.glob("*call_%d*nonce*" % cid))[0]
    nonces.append(bytes.fromhex(f.read_bytes().decode()))
print("10 nonces:")
for n in nonces:
    print("  ", n.hex())

# Check if nonce = truncated SHA256 of key+counter
print("\nCheck nonce = SHA256(key||counter)[:12]:")
for i, n in enumerate(nonces):
    for delta in (0, 1, i, i+1):
        c = hashlib.sha256(KEY + delta.to_bytes(4, "little")).digest()[:12]
        if c == n:
            print("  MATCH nonce%d = sha256(key||%d)[:12]" % (i+1, delta))
        c2 = hashlib.sha256(KEY + delta.to_bytes(8, "little")).digest()[:12]
        if c2 == n:
            print("  MATCH nonce%d = sha256(key||%d-le64)[:12]" % (i+1, delta))

# Check nonce diffs
print("\nnonce diffs (XOR with nonce1):")
for i in range(1, 3):
    d = bytes(a ^ b for a, b in zip(nonces[0], nonces[i]))
    print("  n1^n%d = %s" % (i+1, d.hex()))
