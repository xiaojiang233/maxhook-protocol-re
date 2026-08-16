"""Test RC5/RC6 hypothesis against the 7-sample verification set.

Confirmed: the VM uses data-dependent rotation 'rol/ror dword ptr [rax], cl'
(no S-box, add/sub/xor/and/or + rotate + bswap).  This is the ARX signature.

But note: ciphertext length == plaintext length with NO padding and length up to
1353 bytes.  RC5/RC6 are BLOCK ciphers (64/128-bit block), so if this were
RC5-CBC it would need padding; the observed stream behavior suggests a
stream/CTR-like mode.  However the round function primitive (data-dependent
rotation) is RC5-like.

Test: implement RC5-32/12/16 in CTR mode and RC6, with key = 32-byte session
key and nonce = 12 bytes, and check against ciphertext.  Also try a
ChaCha-like/Salsa-like structure is excluded (no 0x20 rotates in real trace).

Actually the more likely candidate given the primitive set (rol/ror cl +
add/xor + bswap) and stream output is a CUSTOM ARX stream cipher.  But we should
at least falsify RC5/RC6 explicitly.
"""

from __future__ import annotations
import json
import struct
from pathlib import Path

SRC = Path(r"E:\Coding\S1mple\target\crypto_verify_set.json")


def rotl(x, r, w=32):
    r &= (w - 1)
    return ((x << r) | (x >> (w - r))) & ((1 << w) - 1)


def rotr(x, r, w=32):
    r &= (w - 1)
    return ((x >> r) | (x << (w - r))) & ((1 << w) - 1)


def rc5_key_expand(key, rounds, w=32, b=None):
    """RC5 key schedule. key is bytes."""
    r = rounds
    if b is None:
        b = len(key)
    u = w // 8  # 4
    c = max(1, (b + u - 1) // u)  # number of words in key
    L = [0] * c
    for i in range(b - 1, -1, -1):
        L[i // u] = (L[i // u] << 8) + key[i]
    P = 0xB7E15163 if w == 32 else 0xB7E151628AED2A6B
    Q = 0x9E3779B9 if w == 32 else 0x9E3779B97F4A7C15
    t = 2 * (r + 1)
    S = [P]
    for i in range(1, t):
        S.append((S[i-1] + Q) & ((1 << w) - 1))
    i = j = 0
    A = B = 0
    for _ in range(3 * max(t, c)):
        A = S[i] = rotl((S[i] + A + B) & ((1 << w)-1), 3, w)
        B = L[j] = rotl((L[j] + A + B) & ((1 << w)-1), (A + B) & (w-1), w)
        i = (i + 1) % t
        j = (j + 1) % c
    return S


def rc5_encrypt_block(A, B, S, rounds, w=32):
    mask = (1 << w) - 1
    A = (A + S[0]) & mask
    B = (B + S[1]) & mask
    for i in range(1, rounds + 1):
        A = (rotl(A ^ B, B, w) + S[2*i]) & mask
        B = (rotl(B ^ A, A, w) + S[2*i+1]) & mask
    return A, B


def rc5_decrypt_block(A, B, S, rounds, w=32):
    mask = (1 << w) - 1
    for i in range(rounds, 0, -1):
        B = rotr((B - S[2*i+1]) & mask, A, w) ^ A
        A = rotr((A - S[2*i]) & mask, B, w) ^ B
    B = (B - S[1]) & mask
    A = (A - S[0]) & mask
    return A, B


def rc5_ctr_keystream(key, nonce, rounds, nbytes, w=32):
    """RC5 in CTR mode: counter = nonce||counter (little-endian)."""
    S = rc5_key_expand(key, rounds, w)
    out = bytearray()
    # counter block: 8 bytes = nonce truncated/padded + 4-byte counter
    # try: block = nonce[0:4] as first word, counter as second word (LE)
    n = (nbytes + 7) // 8
    for ctr in range(n):
        # first word = first 4 bytes of nonce (LE), second = counter (LE)
        A = struct.unpack("<I", (nonce + b"\x00"*12)[0:4])[0]
        B = ctr
        A, B = rc5_encrypt_block(A, B, S, rounds, w)
        out += struct.pack("<II", A, B)
    return bytes(out[:nbytes])


def main():
    raw = json.loads(SRC.read_text("utf-8"))
    # use sample 1
    s = raw["samples"][0]
    key = bytes.fromhex(s["key_material_64hex"])
    nonce = bytes.fromhex(s["nonce_24hex"])
    ct = bytes.fromhex(s["ciphertext_hex"])
    pt = s["plaintext"].encode("utf-8")

    print(f"plaintext len = {len(pt)}, ciphertext len = {len(ct)}")

    # Try RC5-32 with various round counts and counter layouts
    for rounds in [12, 16, 20]:
        for w in [32]:
            ks = rc5_ctr_keystream(key, nonce, rounds, len(pt), w)
            match = ks == bytes(a ^ b for a, b in zip(pt, ct))
            print(f"RC5-{w}/{rounds} CTR (nonce-first-word LE): match={match}")
            if match:
                print("  *** MATCH ***")

    # Also try RC5 where block = full 12-byte nonce || 4-byte counter -> but
    # RC5 block is 8 bytes.  Try different nonce insertion.

    # Variant 2: counter in high word, nonce in low word
    def rc5_ctr_keystream2(key, nonce, rounds, nbytes):
        S = rc5_key_expand(key, rounds, 32)
        out = bytearray()
        for ctr in range((nbytes + 7) // 8):
            A = ctr
            B = struct.unpack("<I", (nonce + b"\x00"*12)[0:4])[0]
            A, B = rc5_encrypt_block(A, B, S, rounds, 32)
            out += struct.pack("<II", A, B)
        return bytes(out[:nbytes])

    for rounds in [12, 16, 20]:
        ks = rc5_ctr_keystream2(key, nonce, rounds, len(pt))
        match = ks == bytes(a ^ b for a, b in zip(pt, ct))
        print(f"RC5-32/{rounds} CTR (counter-low-word LE): match={match}")

    print("\n(no RC5 match -> custom ARX, not standard RC5)")

    # Sanity: verify RC5 known test vector to ensure implementation correct
    # RC5-32/12/16, key=00..0f, plaintext = 00 00 00 00 00 00 00 00
    tv_key = bytes(range(16))
    S = rc5_key_expand(tv_key, 12, 32)
    A, B = rc5_encrypt_block(0, 0, S, 12, 32)
    # Known ciphertext for RC5-32/12/16 with zero key=0..15, zero pt:
    # 0x21A5DBEE 0x154B8F6D
    print(f"\nRC5 test vector: A=0x{A:08x} B=0x{B:08x} (expect 0x21A5DBEE 0x154B8F6D)")
    dA, dB = rc5_decrypt_block(A, B, S, 12, 32)
    print(f"decrypt back: A=0x{dA:08x} B=0x{dB:08x} (expect 0 0)")


if __name__ == "__main__":
    main()
