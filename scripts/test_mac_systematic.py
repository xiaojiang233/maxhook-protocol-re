#!/usr/bin/env python3
"""Systematic MAC hypothesis test using 10 (nonce, tag, ct) pairs with same key.

Round 217: SHA-256 confirmed (round 216).  Test HMAC-SHA256 and SHA-256 variants
with domain separation, key derivation, and length encoding.

Common AEAD MAC constructions:
  - HMAC-SHA256(K, AAD || nonce || ct)  [ruled out round 216]
  - HMAC-SHA256(K, ct || AAD) 
  - HMAC-SHA256(K, nonce || ct) with key = K || 0x00/0x01/0x02
  - SHA256(K || nonce || ct || len)
  - SIV-like: SHA256(derived_key || nonce || ct)
"""
import hashlib, hmac
from pathlib import Path

P = Path(r"E:\Coding\S1mple\target\vm_context_capture2")
KEY = bytes.fromhex("32206F9C196327AD276821AC8EBC7F80FE82D84CF72A4F7C1BAF508C97D3AEA8")
AAD = b"v3|hpac.v3.session.report.req"

pairs = []
for cid in range(1, 11):
    nonce_f = list(P.glob("*call_%d*nonce*" % cid))[0]
    tag_f = list(P.glob("*call_%d*tag*" % cid))[0]
    ct_f = list(P.glob("*call_%d*ciphertext*" % cid))[0]
    nonce = bytes.fromhex(nonce_f.read_bytes().decode())
    tag = bytes.fromhex(tag_f.read_bytes().decode())
    ct = bytes.fromhex(ct_f.read_bytes().decode())
    pairs.append((cid, nonce, tag, ct))

def test(name, fn):
    matches = sum(1 for _, n, t, c in pairs if fn(n, c) == t)
    if matches > 0:
        print("*** %-55s MATCH %d/10 ***" % (name, matches))
    return matches

# key derivation candidates
def key_derivations():
    return {
        "K": KEY,
        "K||0x00": KEY + b"\x00",
        "K||0x01": KEY + b"\x01",
        "K||0x02": KEY + b"\x02",
        "sha256(K)": hashlib.sha256(KEY).digest(),
        "K||'tag'": KEY + b"tag",
        "K||'mac'": KEY + b"mac",
        "K||'enc'": KEY + b"enc",
        "K||0xff": KEY + b"\xff",
        "K||nonce": None,  # special
    }

total = 0
# Try HMAC with various keys and message orders
for kname, k in key_derivations().items():
    if k is None:
        continue
    total += test("hmac(%s, aad||nonce||ct)" % kname, lambda n,c,k=k: hmac.new(k, AAD+n+c, hashlib.sha256).digest()[:16])
    total += test("hmac(%s, nonce||aad||ct)" % kname, lambda n,c,k=k: hmac.new(k, n+AAD+c, hashlib.sha256).digest()[:16])
    total += test("hmac(%s, aad||ct)" % kname, lambda n,c,k=k: hmac.new(k, AAD+c, hashlib.sha256).digest()[:16])
    total += test("hmac(%s, nonce||ct)" % kname, lambda n,c,k=k: hmac.new(k, n+c, hashlib.sha256).digest()[:16])
    total += test("hmac(%s, ct||aad||nonce)" % kname, lambda n,c,k=k: hmac.new(k, c+AAD+n, hashlib.sha256).digest()[:16])
    total += test("hmac(%s, ct)" % kname, lambda n,c,k=k: hmac.new(k, c, hashlib.sha256).digest()[:16])
    # full 32-byte, take last 16
    total += test("hmac(%s, aad||nonce||ct)[16:32]" % kname, lambda n,c,k=k: hmac.new(k, AAD+n+c, hashlib.sha256).digest()[16:32])

# SHA256 variants with length encoding
def le64(x): return x.to_bytes(8, "little")
def be64(x): return x.to_bytes(8, "big")

total += test("sha256(K||nonce||ct||len_be)", lambda n,c: hashlib.sha256(KEY+n+c+be64(len(c))).digest()[:16])
total += test("sha256(K||nonce||ct||len_le)", lambda n,c: hashlib.sha256(KEY+n+c+le64(len(c))).digest()[:16])
total += test("sha256(aad||nonce||ct||len_be)", lambda n,c: hashlib.sha256(AAD+n+c+be64(len(c))).digest()[:16])
total += test("sha256(K||nonce||len_be||ct)", lambda n,c: hashlib.sha256(KEY+n+be64(len(c))+c).digest()[:16])
total += test("sha256(K||aad||nonce||ct)", lambda n,c: hashlib.sha256(KEY+AAD+n+c).digest()[:16])
total += test("sha256(nonce||K||ct)", lambda n,c: hashlib.sha256(n+KEY+c).digest()[:16])
total += test("sha256(K||ct)", lambda n,c: hashlib.sha256(KEY+c).digest()[:16])
total += test("sha256(aad||K||ct)", lambda n,c: hashlib.sha256(AAD+KEY+c).digest()[:16])

# The nonce might be the HMAC key (nonce as key)
total += test("hmac(nonce, aad||ct)", lambda n,c: hmac.new(n, AAD+c, hashlib.sha256).digest()[:16])
total += test("hmac(nonce, K||aad||ct)", lambda n,c: hmac.new(n, KEY+AAD+c, hashlib.sha256).digest()[:16])

# derived key = HMAC(K, nonce) then HMAC that over ct
def hkdf_like(n, c):
    dk = hmac.new(KEY, n, hashlib.sha256).digest()
    return hmac.new(dk, AAD+c, hashlib.sha256).digest()[:16]
total += test("hmac(hmac(K,nonce), aad||ct)", hkdf_like)

def hkdf_like2(n, c):
    dk = hmac.new(KEY, AAD+n, hashlib.sha256).digest()
    return hmac.new(dk, c, hashlib.sha256).digest()[:16]
total += test("hmac(hmac(K,aad||nonce), ct)", hkdf_like2)

print("\nTotal tests:", total, "(all should be 0 unless a MATCH appears)")
