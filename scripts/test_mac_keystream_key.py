import hashlib, hmac
from pathlib import Path

P = Path(r"E:\Coding\S1mple\target\vm_context_capture2")
KEY = bytes.fromhex("32206F9C196327AD276821AC8EBC7F80FE82D84CF72A4F7C1BAF508C97D3AEA8")
AAD = b"v3|hpac.v3.session.report.req"

pairs = []
for cid in range(1, 11):
    nonce = bytes.fromhex(list(P.glob("*call_%d*nonce*" % cid))[0].read_bytes().decode())
    tag = bytes.fromhex(list(P.glob("*call_%d*tag*" % cid))[0].read_bytes().decode())
    ct = bytes.fromhex(list(P.glob("*call_%d*ciphertext*" % cid))[0].read_bytes().decode())
    pt = list(P.glob("*call_%d*plaintext*" % cid))[0].read_bytes()
    ks = bytes(a ^ b for a, b in zip(pt, ct))
    pairs.append((cid, nonce, tag, ct, ks))

# Hypothesis: MAC key = keystream (first 32 bytes) or derived from keystream
# tag = HMAC-SHA256(keystream[:32], AAD || nonce || ct)  etc.
def test(name, fn):
    m = sum(1 for _, n, t, c, ks in pairs if fn(n, c, ks) == t)
    if m: print("*** MATCH %d/10: %s ***" % (m, name))
    return m

total = 0
total += test("hmac(ks[:32], aad||nonce||ct)", lambda n,c,ks: hmac.new(ks[:32], AAD+n+c, hashlib.sha256).digest()[:16])
total += test("hmac(ks[:32], ct)", lambda n,c,ks: hmac.new(ks[:32], c, hashlib.sha256).digest()[:16])
total += test("hmac(ks[:32], nonce||ct)", lambda n,c,ks: hmac.new(ks[:32], n+c, hashlib.sha256).digest()[:16])
total += test("hmac(ks[:16], aad||ct)", lambda n,c,ks: hmac.new(ks[:16], AAD+c, hashlib.sha256).digest()[:16])
total += test("hmac(ks[:32], aad||ct)", lambda n,c,ks: hmac.new(ks[:32], AAD+c, hashlib.sha256).digest()[:16])
total += test("sha256(ks[:32]||aad||nonce||ct)", lambda n,c,ks: hashlib.sha256(ks[:32]+AAD+n+c).digest()[:16])
total += test("sha256(ks||ct)[:16]", lambda n,c,ks: hashlib.sha256(ks+c).digest()[:16])
# maybe the tag key = keystream first 32 bytes, and tag = HMAC over ct only
total += test("hmac(ks[:32], aad||nonce||ct) full32", lambda n,c,ks: hmac.new(ks[:32], AAD+n+c, hashlib.sha256).digest()[:16])
# derived key = sha256(key||nonce) then hmac
total += test("hmac(sha256(key||nonce), ct)", lambda n,c,ks: hmac.new(hashlib.sha256(KEY+n).digest(), c, hashlib.sha256).digest()[:16])
total += test("hmac(sha256(key||nonce), aad||ct)", lambda n,c,ks: hmac.new(hashlib.sha256(KEY+n).digest(), AAD+c, hashlib.sha256).digest()[:16])
# derived key = hmac(key, nonce)
total += test("hmac(hmac(key,nonce), ct)", lambda n,c,ks: hmac.new(hmac.new(KEY,n,hashlib.sha256).digest(), c, hashlib.sha256).digest()[:16])
total += test("hmac(hmac(key,nonce), aad||ct)", lambda n,c,ks: hmac.new(hmac.new(KEY,n,hashlib.sha256).digest(), AAD+c, hashlib.sha256).digest()[:16])

print("\nTotal tests:", total, "(0 = no match found)")
