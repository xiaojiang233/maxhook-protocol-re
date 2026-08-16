#!/usr/bin/env python3
"""Round 17: test ChaCha20-Poly1305 (IETF AEAD) tag against call-4 ground truth.

Ground truth (call 4):
  key = 413d6b04...60eda (32B raw)
  nonce = d12c161bf503d4599dd8c235
  tag = b11b18f627561cef4657d52c59d5033d
  ct = 691B, pt = 754B
  input32 = 63E11EFC90C1941CCEE3C2F8F0918EEE (16B AAD, hex-encoded as 32 ASCII)
  domain_label = v3|hpac.v3.session.report.req (29B)

Hypothesis: the protocol is standard ChaCha20-Poly1305 where the payload
keystream starts at counter=1 (already verified) and the tag is Poly1305
over the AEAD using the one-time key from ChaCha20 block 0 (counter=0).
"""
import hashlib, hmac, struct
from pathlib import Path

KEY = bytes.fromhex("413D6B04AA3567D4DA22BE246443216C6A4CD4D4E1D7A9232770D222BE960EDA")
NONCE = bytes.fromhex("d12c161bf503d4599dd8c235")
TAG = bytes.fromhex("b11b18f627561cef4657d52c59d5033d")
LABEL = b"v3|hpac.v3.session.report.req"
AAD = bytes.fromhex("63E11EFC90C1941CCEE3C2F8F0918EEE")
CT = bytes.fromhex(Path("encrypt_boundary_capture2/000055_call_4_output_ciphertext_hex.bin").read_bytes().decode())
DK = hmac.new(KEY, LABEL, hashlib.sha256).digest()

def rotl(v,c): return ((v<<c)&0xffffffff)|(v>>(32-c))

def chacha20_block(key, counter, nonce):
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

def poly1305(msg, key):
    # RFC 8439 Poly1305. key = 32 bytes (r || s)
    r0,r1,r2,r3,r4 = struct.unpack("<5I", key[:20])
    r0 &= 0x0ffffffc; r1 &= 0x0ffffffc; r2 &= 0x0ffffffc; r3 &= 0x0ffffffc; r4 &= 0x0ffffffc
    s0,s1,s2,s3,s4 = struct.unpack("<5I", key[16:])
    h0=h1=h2=h3=h4=0
    MASK = (1<<32)-1
    for i in range(0, len(msg), 16):
        block = msg[i:i+16]
        n = block + b'\x01'
        if len(block)<16:
            n = block + b'\x01' + b'\x00'*(16-len(block))
        n0,n1,n2,n3,n4 = struct.unpack("<5I", n.ljust(20,b'\x00')[:20])
        h0 = (h0 + n0)&MASK; h1=(h1+n1)&MASK; h2=(h2+n2)&MASK; h3=(h3+n3)&MASK; h4=(h4+n4)&MASK
        # d = h*r (64x32 -> mult)
        d0=(h0*r0 + h1*s4 + h2*s3 + h3*s2 + h4*s1)&MASK
        d1=(h0*r1 + h1*r0 + h2*s4 + h3*s3 + h4*s2)&MASK
        d2=(h0*r2 + h1*r1 + h2*r0 + h3*s4 + h4*s3)&MASK
        d3=(h0*r3 + h1*r2 + h2*r1 + h3*r0 + h4*s4)&MASK
        d4=(h0*r4 + h1*r3 + h2*r2 + h3*r1 + h4*r0 + h0*r4*4)&MASK  # approx - needs 130-bit
        h0,h1,h2,h3,h4 = d0,d1,d2,d3,d4
    raise NotImplementedError("need 130-bit arithmetic")

# Use a clean, correct Poly1305 (RFC 8439 reference) with Python big ints.
def poly1305_rfc(msg, key):
    r = int.from_bytes(key[:16],'little')
    s = int.from_bytes(key[16:],'little')
    r &= (1<<130)-5  # clamp
    r = ((r & 0x0ffffffc0ffffffc0ffffffc0fffffff) | (r & 0x0ffffffc0ffffffc0ffffffc0ffffffc) & 0x0fffffffffffffffffffffffffffffff)  # just clamp bits
    # proper clamp
    r &= 0x0ffffffc0ffffffc0ffffffc0fffffff  # this keeps bits as RFC
    acc = 0
    p = (1<<130)-5
    for i in range(0, len(msg)+16, 16):
        block = msg[i:i+16]
        n = int.from_bytes(block + b'\x01', 'little') if block else None
        if not block: break
        acc = (acc + n) % p
        acc = (acc * r) % p
    acc = (acc + s) % (1<<128)
    return acc.to_bytes(16,'little')

# Actually implement correct clamp: clear bits 2,5,8,... of bytes[3],[7],[11],[15]
def clamp(r):
    r &= ~0x0c; r &= ~(0x0c << 8); r &= ~(0x0c << 16); r &= ~(0x0c << 24)
    r &= ~(0x0c << 32); r &= ~(0x0c << 40); r &= ~(0x0c << 48); r &= ~(0x0c << 56)
    r &= ~(0x0c << 64); r &= ~(0x0c << 72); r &= ~(0x0c << 80); r &= ~(0x0c << 88)
    r &= ~(0x0c << 96); r &= ~(0x0c << 104); r &= ~(0x0c << 112); r &= ~(0x0c << 120)
    # top bit
    r &= (1<<128)-1
    return r

def poly1305(msg, key):
    r = clamp(int.from_bytes(key[:16],'little'))
    s = int.from_bytes(key[16:],'little')
    p = (1<<130)-5
    acc = 0
    i=0
    while i < len(msg):
        block = msg[i:i+16]
        n = int.from_bytes(block + b'\x01', 'little')
        acc = (acc + n) % p
        acc = (acc * r) % p
        i += 16
    return ((acc + s) % (1<<128)).to_bytes(16,'little')

def aead_tag(key, nonce, aad, ct):
    otk = chacha20_block(key, 0, nonce)[:32]
    mac_data = aad + b'\x00'*((16-len(aad)%16)%16) + ct + b'\x00'*((16-len(ct)%16)%16)
    mac_data += struct.pack('<Q', len(aad)) + struct.pack('<Q', len(ct))
    return poly1305(mac_data, otk)

# Test various AEAD parameterizations
def chacha20_block_ks(key, counter, nonce):
    return chacha20_block(key, counter, nonce)

# Encrypting keystream starts at counter 1 (verified). For AEAD, otk = block 0.
def aead_tag_full(key_enc, nonce, aad, ct, otk_key):
    otk = chacha20_block(otk_key, 0, nonce)[:32]
    mac_data = aad + b'\x00'*((16-len(aad)%16)%16)
    mac_data += ct + b'\x00'*((16-len(ct)%16)%16)
    mac_data += struct.pack('<Q', len(aad)) + struct.pack('<Q', len(ct))
    return poly1305(mac_data, otk)

results = {}
# AEAD with otk from domain key block 0
results['poly1305(dk0, aad||ct||lens)'] = aead_tag(DK, NONCE, AAD, CT)
# otk from raw key
results['poly1305(key0, aad||ct||lens)'] = aead_tag(KEY, NONCE, AAD, CT)
# aad = label instead of input32?
results['poly1305(dk0, label||ct||lens)'] = aead_tag(DK, NONCE, LABEL, CT)
# include nonce in mac
def aead_nonce(otk_key, nonce, aad, ct):
    otk = chacha20_block(otk_key, 0, nonce)[:32]
    mac_data = aad + b'\x00'*((16-len(aad)%16)%16) + nonce + ct + b'\x00'*((16-len(ct)%16)%16)
    mac_data += struct.pack('<Q', len(aad)+len(nonce)) + struct.pack('<Q', len(ct))
    return poly1305(mac_data, otk)
results['poly1305(dk0, aad||nonce||ct||lens)'] = aead_nonce(DK, NONCE, AAD, CT)
results['poly1305(key0, aad||nonce||ct||lens)'] = aead_nonce(KEY, NONCE, AAD, CT)

print("tag target", TAG.hex())
for n,v in results.items():
    hit = "*** MATCH ***" if v==TAG else ""
    print(f"{n:48s} = {v.hex()} {hit}")
if not any(v==TAG for v in results.values()):
    print("\nNo ChaCha20-Poly1305 match with these parameterizations.")
