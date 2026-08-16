#!/usr/bin/env python3
"""Test whether the 16-byte tag is HMAC-SHA256 (or a SHA-256 variant) over
key/nonce/ciphertext/AAD.

Discovery (round 216): the emulation trace showed SHA-256 IV constants
(0x6a09e667..0x5be0cd19) written at 0x18042b970, so the tag MAC uses SHA-256.

Test hypotheses for the 16-byte tag:
  H1: tag = first 16 bytes of SHA256(key || nonce || ciphertext)
  H2: tag = first 16 bytes of HMAC-SHA256(key, nonce || ciphertext)
  H3: tag = first 16 bytes of HMAC-SHA256(key, ciphertext)
  H4: tag = first 16 bytes of SHA256(aad || nonce || ciphertext)
  H5: tag = HMAC-SHA256(key, aad || nonce || ciphertext)
  H6: tag = first 16 bytes of SHA256(key || ciphertext)

Ground truth (vm_context_capture2 call 1):
  key   = 32206F9C196327AD276821AC8EBC7F80FE82D84CF72A4F7C1BAF508C97D3AEA8
  nonce = c38d500ac2ae8d2611ae1749
  tag   = ba78f9e38bd583d2deac54945f3f778a
  AAD (input32) = 16 bytes (the "v3|hpac.v3.session.report.req" AAD)
"""
import hashlib
import hmac
from pathlib import Path

KEY = bytes.fromhex("32206F9C196327AD276821AC8EBC7F80FE82D84CF72A4F7C1BAF508C97D3AEA8")
NONCE = bytes.fromhex("c38d500ac2ae8d2611ae1749")
TAG = bytes.fromhex("ba78f9e38bd583d2deac54945f3f778a")

# ciphertext from vm_context_capture2 call 1
P = Path(r"E:\Coding\S1mple\target\vm_context_capture2")
CT = bytes.fromhex((P/"000010_call_1_output_ciphertext_hex.bin").read_bytes().decode())
PT = (P/"000005_call_1_input_plaintext_json.bin").read_bytes()
input32 = (P/"000003_call_1_input_input32.bin").read_bytes()  # 32B = AAD hex? or raw

print("key:", KEY.hex())
print("nonce:", NONCE.hex())
print("tag (target):", TAG.hex())
print("ciphertext len:", len(CT))
print("plaintext len:", len(PT))
print("input32:", input32)

# input32 is 32 bytes - likely hex-encoded 16-byte AAD
aad_hex = input32.decode() if input32.decode().isprintable() else None
print("input32 as ascii:", aad_hex)

# The AAD is "v3|hpac.v3.session.report.req" (16 bytes) per the summary
AAD = b"v3|hpac.v3.session.report.req"
print("AAD (16B):", AAD, "len", len(AAD))

results = {}
# H1-H6 variants
results["sha256(key||nonce||ct)[:16]"] = hashlib.sha256(KEY+NONCE+CT).digest()[:16]
results["sha256(key||ct)[:16]"] = hashlib.sha256(KEY+CT).digest()[:16]
results["sha256(nonce||ct)[:16]"] = hashlib.sha256(NONCE+CT).digest()[:16]
results["sha256(ct)[:16]"] = hashlib.sha256(CT).digest()[:16]
results["sha256(aad||nonce||ct)[:16]"] = hashlib.sha256(AAD+NONCE+CT).digest()[:16]
results["sha256(aad||key||nonce||ct)[:16]"] = hashlib.sha256(AAD+KEY+NONCE+CT).digest()[:16]
results["sha256(key||aad||nonce||ct)[:16]"] = hashlib.sha256(KEY+AAD+NONCE+CT).digest()[:16]
results["hmac_sha256(key, nonce||ct)[:16]"] = hmac.new(KEY, NONCE+CT, hashlib.sha256).digest()[:16]
results["hmac_sha256(key, ct)[:16]"] = hmac.new(KEY, CT, hashlib.sha256).digest()[:16]
results["hmac_sha256(key, aad||nonce||ct)[:16]"] = hmac.new(KEY, AAD+NONCE+CT, hashlib.sha256).digest()[:16]
results["hmac_sha256(key, nonce||aad||ct)[:16]"] = hmac.new(KEY, NONCE+AAD+CT, hashlib.sha256).digest()[:16]
results["hmac_sha256(nonce, ct)[:16]"] = hmac.new(NONCE, CT, hashlib.sha256).digest()[:16]
results["hmac_sha256(aad, ct)[:16]"] = hmac.new(AAD, CT, hashlib.sha256).digest()[:16]
# full sha256 tag (32 bytes) truncated comparison
results["sha256(key||nonce||ct)[:16] (full check)"] = hashlib.sha256(KEY+NONCE+CT).digest()[:16]

# also check if the tag is sha256 of something and we have the full 32-byte hash
# tag is 16 bytes = 32 hex chars. So it's a truncated 16-byte value.
# Try: is tag = first 16 of sha256, or last 16, or middle?
full = hashlib.sha256(KEY+NONCE+CT).digest()
results["sha256(key||nonce||ct) last16"] = full[16:]

print("\n=== tag hypothesis test ===")
for name, val in results.items():
    match = "*** MATCH ***" if val == TAG else ""
    print("  %-45s = %s %s" % (name, val.hex(), match))
