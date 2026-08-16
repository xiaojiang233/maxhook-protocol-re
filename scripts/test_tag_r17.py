#!/usr/bin/env python3
"""Round 17: test tag hypotheses against call-4 ground truth, using the
SHA event structure captured from the emulator.

Ground truth (call 4):
  key    = 413d6b04...60eda (32B, from input64 hex)
  nonce  = d12c161bf503d4599dd8c235
  tag    = b11b18f627561cef4657d52c59d5033d
  ciphertext = 691B
  input32 = 63E11EFC90C1941CCEE3C2F8F0918EEE (32 hex chars = 16B AAD)
  domain_label = v3|hpac.v3.session.report.req (29B)

Emulator SHA events proved the HMAC-SHA256 domain-key derivation:
  inner = SHA256((key_pad ^ 0x36) || label)
  outer = SHA256((key_pad ^ 0x5c) || inner)   = domain_key
The tag-phase SHA-256 context (112B heap) was initialized but its update
input (which should consume nonce/ct) was NOT reached due to async-snapshot
desync. So we test every plausible construction against the ground-truth tag.
"""
import hashlib, hmac
from pathlib import Path

KEY = bytes.fromhex("413D6B04AA3567D4DA22BE246443216C6A4CD4D4E1D7A9232770D222BE960EDA")
NONCE = bytes.fromhex("d12c161bf503d4599dd8c235")
TAG = bytes.fromhex("b11b18f627561cef4657d52c59d5033d")
LABEL = b"v3|hpac.v3.session.report.req"
AAD_HEX = "63E11EFC90C1941CCEE3C2F8F0918EEE"
AAD = bytes.fromhex(AAD_HEX)          # 16B raw AAD
CT = bytes.fromhex(Path("encrypt_boundary_capture2/000055_call_4_output_ciphertext_hex.bin").read_bytes().decode())
PT = Path("encrypt_boundary_capture2/000038_call_4_input_plaintext_json.bin").read_bytes()
DK = hmac.new(KEY, LABEL, hashlib.sha256).digest()  # domain key

print("len: key=%d nonce=%d tag=%d ct=%d pt=%d aad=%d dk=%d" % (
    len(KEY),len(NONCE),len(TAG),len(CT),len(PT),len(AAD),len(DK)))
print("domain_key", DK.hex())
print("tag target", TAG.hex())

def chacha20_block(key, counter, nonce):
    import struct
    def rotl(v,c): return ((v<<c)&0xffffffff)|(v>>(32-c))
    st0=list(struct.unpack("<4I",b"expand 32-byte k"))
    st0+=list(struct.unpack("<8I",key)); st0+=[counter]; st0+=list(struct.unpack("<3I",nonce))
    w=st0.copy()
    for _ in range(10):
        for a,b,c,d in ((0,4,8,12),(1,5,9,13),(2,6,10,14),(3,7,11,15),
                        (0,5,10,15),(1,6,11,12),(2,7,8,13),(3,4,9,14)):
            w[a]=(w[a]+w[b])&0xffffffff; w[d]=rotl(w[d]^w[a],16)
            w[c]=(w[c]+w[d])&0xffffffff; w[b]=rotl(w[b]^w[c],12)
            w[a]=(w[a]+w[b])&0xffffffff; w[d]=rotl(w[d]^w[a],8)
            w[c]=(w[c]+w[d])&0xffffffff; w[b]=rotl(w[b]^w[c],7)
    return struct.pack("<16I",*((w[i]+st0[i])&0xffffffff for i in range(16)))

# Poly1305-style? Also chacha20-poly1305 AEAD: tag = Poly1305(key = chacha20(dk,0,nonce)[0:32], aad||pad||ct||pad||len)
def chacha20_aead_encrypt(key, nonce, aad, plaintext):
    # returns ciphertext, tag per RFC 8439
    import struct
    def rotl(v,c): return ((v<<c)&0xffffffff)|(v>>(32-c))
    def block(k,cnt,n):
        st0=list(struct.unpack("<4I",b"expand 32-byte k"))
        st0+=list(struct.unpack("<8I",k)); st0+=[cnt]; st0+=list(struct.unpack("<3I",n))
        w=st0.copy()
        for _ in range(10):
            for a,b,c,d in ((0,4,8,12),(1,5,9,13),(2,6,10,14),(3,7,11,15),
                            (0,5,10,15),(1,6,11,12),(2,7,8,13),(3,4,9,14)):
                w[a]=(w[a]+w[b])&0xffffffff; w[d]=rotl(w[d]^w[a],16)
                w[c]=(w[c]+w[d])&0xffffffff; w[b]=rotl(w[b]^w[c],12)
                w[a]=(w[a]+w[b])&0xffffffff; w[d]=rotl(w[d]^w[a],8)
                w[c]=(w[c]+w[d])&0xffffffff; w[b]=rotl(w[b]^w[c],7)
        return struct.pack("<16I",*((w[i]+st0[i])&0xffffffff for i in range(16)))
    def poly1305(key,m):
        # key: 32 bytes
        r=struct.unpack("<I",key[0:4])[0]; r&=0x0ffffffc
        r|=struct.unpack("<I",key[4:8])[0]<<32; r&=~((0x0c<<96))
        # simplified - use a small implementation
        raise NotImplementedError
    # Use cryptography-like via raw
    # Generate one-time subkey
    one=block(key,0,nonce)[:32]
    # poly1305 (not implemented here) - skip
    return None

# We cannot easily Poly1305 in stdlib. Focus on SHA256/HMAC-based constructions.

results = {}
def t(name, val): results[name]=val
T=t
# 1. truncated HMAC/keccak over various orderings
combos = {
  "sha256(ct)": CT,
  "sha256(nonce||ct)": NONCE+CT,
  "sha256(aad||ct)": AAD+CT,
  "sha256(aad||nonce||ct)": AAD+NONCE+CT,
  "sha256(key||nonce||ct)": KEY+NONCE+CT,
  "sha256(dk||nonce||ct)": DK+NONCE+CT,
  "sha256(dk||ct)": DK+CT,
  "sha256(key||ct)": KEY+CT,
  "sha256(aad||nonce||ct||key)": AAD+NONCE+CT+KEY,
  "sha256(dk||nonce||ct||aad)": DK+NONCE+CT+AAD,
  "sha256(nonce||aad||ct)": NONCE+AAD+CT,
  "sha256(aad||ct||nonce)": AAD+CT+NONCE,
}
for n,msg in combos.items():
    t(n, hashlib.sha256(msg).digest()[:16])
    t(n+"_full32", hashlib.sha256(msg).digest())
# HMAC variants
for n,msg in {
  "hmac(dk,ct)": CT, "hmac(dk,nonce||ct)": NONCE+CT,
  "hmac(dk,aad||nonce||ct)": AAD+NONCE+CT,
  "hmac(key,ct)": CT, "hmac(key,nonce||ct)": NONCE+CT,
  "hmac(key,aad||nonce||ct)": AAD+NONCE+CT,
  "hmac(dk,aad||ct)": AAD+CT, "hmac(dk,nonce||aad||ct)": NONCE+AAD+CT,
}.items():
    t(n, hmac.new(DK if n.startswith("hmac(dk") else KEY, msg, hashlib.sha256).digest()[:16])

print("\n=== tag match test ===")
for n,v in results.items():
    if isinstance(v,bytes) and len(v)>=16:
        hit = "*** MATCH ***" if v[:16]==TAG else ""
        if hit: print(n, v.hex(), hit)
# print any full32 that starts with tag
for n,v in results.items():
    if isinstance(v,bytes) and len(v)==32 and v[:16]==TAG:
        print("FULL32 match on prefix:", n, v.hex())
# none printed => no match
if not any(isinstance(v,bytes) and v[:16]==TAG for v in results.values()):
    print("No match among tested SHA256/HMAC constructions (tag remains unresolved).")
