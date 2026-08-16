#!/usr/bin/env python3
"""
MaxHook 报告加密协议栈 — 离线恢复参考实现（tag 尚未恢复）

Strict evidence boundary:
  - raw key -> HMAC-SHA256 domain key is independently recovered;
  - key + nonce -> ChaCha20(counter=1) keystream is independently reproduced;
  - ciphertext reproduction is verified against every currently loaded vector;
  - the exact 16-byte tag construction and therefore full envelope encryption
    remain unresolved and fail closed.

The VM implementation is heavily virtualized, but its externally visible stream
cipher is standard IETF ChaCha20 with the HMAC-derived 32-byte key.  Historical
VM handler constants below are retained as reverse-engineering evidence; they
are not needed by the compact independent implementation.
"""
from __future__ import annotations

import hashlib
import hmac
import json
import struct
from pathlib import Path

DOMAIN_LABEL = b"v3|hpac.v3.session.report.req"

# ---------------------------------------------------------------------------
# Cipher constants (all recovered offline, cross-validated)
# ---------------------------------------------------------------------------

# key-schedule entry constants
KEY_SCHED_ENTRY = [0x32F12C5A, 0x35A7D4CF]

# key-schedule ARX round constants (round 99; 14/16 memory-write cross-validated)
KEY_SCHED_ARX = [
    0x5F5C808F, 0x3B6A3D7A, 0x4ECEEE25,   # chain B
    0x558A625A, 0x681B64D8, 0x4DBFDE8F, 0x6ABD113B,  # chain C
    0x7F594FCF, 0x616C560B, 0x472793ED,   # chain D
    0x4BFBA08F,                            # chain E
    0x453D7DE7, 0x3E0CC8B0, 0x3B86D410, 0x6220B8CA, 0x662FF97C, 0x3C02264D,  # chain F
    0x31D126F2, 0x544833D7, 0x6C4B7E4B,   # chain G
    0x5E800FC4, 0x7829EBAB,                # chain W
]

# fold constants (fold 6 slot values -> keystream word)
FOLD_CONSTANTS = [
    0x7EF78E7D, 0x47F75FB8, 0x1F5FF464, 0x3879C8AB,
    0x6EAA89FC, 0x5F77D611, 0x77914AFF, 0x1BD67EAC,
]

# dispatcher constants
DISPATCHER_CONSTANTS = [0x7B5C860B, 0x5C03BDB2, 0x4CDEC89F, 0x7A65B189]

# pointer-obfuscation masks (NOT cipher constants)
POINTER_MASKS = [0x9E22, 0x1D6E, 0x65AA]

# Context slots (VM context @ 0x18098c884)
CTX = {
    "block_counter": 0x26,    # +1 per 64B block
    "byte_offset":   0xD9,    # 0x00/0x40/0x80/0xC0 cycle
    "state_offset":  0x45,    # +0x20 per block
    "state_table":   0x61,    # -> 0x180835f10 (pointer table, NOT S-box)
    "vip":           0x6D,    # bytecode IP
    "keystream":     0xB5,    # keystream byte output
    "key_ptr":       0xBD,    # -> heap key buffer
    "round_state":   0x1E,    # key-schedule round state (state[0x1e])
    "state2":        0x143,   # state word (low byte = byte offset)
    "keystream_b":   0x235,   # keystream double-buffer B
}


# ---------------------------------------------------------------------------
# Envelope (fully reconstructed)
# ---------------------------------------------------------------------------

def hex_encode(data: bytes) -> bytes:
    """Return lowercase hex ASCII (as produced by the DLL)."""
    return data.hex().lower().encode("ascii")


def build_envelope(key: bytes, nonce: bytes, ciphertext: bytes, tag: bytes,
                   kid: bytes) -> dict:
    """Reproduce the {sv:3, kid, nonce, ciphertext, tag} envelope.

    The output object is 4 contiguous MSVC std::string fields; here we return
    them as decoded values for clarity (hex-ASCII is what the DLL emits).
    """
    assert len(key) == 32
    assert len(nonce) == 12
    assert len(tag) == 16
    return {
        "sv": 3,
        "kid": kid.hex().upper(),          # 16B -> 32 uppercase hex chars
        "nonce": hex_encode(nonce),        # 12B -> 24 lowercase hex chars
        "ciphertext": hex_encode(ciphertext),  # len = 2 * plaintext
        "tag": hex_encode(tag),            # 16B -> 32 lowercase hex chars
    }


# ---------------------------------------------------------------------------
# ARX round function (decoded, round 10)
# ---------------------------------------------------------------------------

def arx_round(state1: int, state2: int, const3: int, constA: int) -> tuple[int, int]:
    """The key-schedule round function recovered from the fold region:
        state1 ^= (const3 ^ state1) - state2
        state1 ^= constA + state1 + state2
    (word[VIP+3] = const3, word[VIP+0xa] = constA; both 16-bit bytecode words.)
    """
    s1 = state1 & 0xFFFFFFFF
    s2 = state2 & 0xFFFFFFFF
    s1 ^= ((const3 & 0xFFFFFFFF) ^ s1) - s2
    s1 &= 0xFFFFFFFF
    s1 ^= (constA & 0xFFFFFFFF) + s1 + s2
    s1 &= 0xFFFFFFFF
    return s1, s2


# ---------------------------------------------------------------------------
# VM dispatch mechanics (statically PROVEN, milestone 17 + round 118)
# ---------------------------------------------------------------------------

def vm_dispatch(word: int, key: int) -> tuple[int, int]:
    """The proven keyed dispatch formula:
        index = (word[VIP+idx_off] - key + 0x5214a88c) & 0xffff
        key_after = key - index_full
    where key is DATA-DRIVEN (key = word[VIP+key_off]), NOT a fixed recurrence.
    """
    index_full = (word - (key & 0xFFFF) + 0x5214A88C) & 0xFFFFFFFF
    index = index_full & 0xFFFF
    key_after = (key - index_full) & 0xFFFFFFFF
    return index, key_after


# ---------------------------------------------------------------------------
# Key absorption (fully recovered) and remaining expansion
# ---------------------------------------------------------------------------

def absorb_key_block(key: bytes) -> tuple[bytes, bytes]:
    """Recover the exact post-absorption key-dependent arrays.

    The protected VM processes ``key || zero32`` as 64 fixed rounds, 26 VM
    jumps per byte. At the post-round boundary every other context/register/
    stack value is key-independent; all key dependence is exactly:

      array_a[i] = block[i] ^ 0x5c
      array_b[i] = block[i] ^ 0x36

    This replaces 1664 VM jumps and is verified against a random 00..1f key by
    complete context, stack, register, VIP, dispatch-key and target equality.
    """
    if len(key) != 32:
        raise ValueError("key must be exactly 32 bytes")
    block = key + bytes(32)
    return (
        bytes(value ^ 0x5C for value in block),
        bytes(value ^ 0x36 for value in block),
    )


def derive_domain_key(key: bytes, label: bytes = DOMAIN_LABEL) -> bytes:
    """Derive the exact 32-byte domain-separated key.

    Offline SHA component tracing proves the standard HMAC-SHA256 sequence:
      SHA256((key_pad ^ 0x36) || label)
      SHA256((key_pad ^ 0x5c) || inner_digest)

    For this protocol ``label`` is the 29-byte constant
    ``v3|hpac.v3.session.report.req``.
    """
    if len(key) != 32:
        raise ValueError("key must be exactly 32 bytes")
    return hmac.new(key, label, hashlib.sha256).digest()


def _rotl32(value: int, count: int) -> int:
    value &= 0xFFFFFFFF
    return ((value << count) & 0xFFFFFFFF) | (value >> (32 - count))


def _chacha_quarter_round(state: list[int], a: int, b: int,
                          c: int, d: int) -> None:
    state[a] = (state[a] + state[b]) & 0xFFFFFFFF
    state[d] = _rotl32(state[d] ^ state[a], 16)
    state[c] = (state[c] + state[d]) & 0xFFFFFFFF
    state[b] = _rotl32(state[b] ^ state[c], 12)
    state[a] = (state[a] + state[b]) & 0xFFFFFFFF
    state[d] = _rotl32(state[d] ^ state[a], 8)
    state[c] = (state[c] + state[d]) & 0xFFFFFFFF
    state[b] = _rotl32(state[b] ^ state[c], 7)


def chacha20_block(derived_key: bytes, counter: int, nonce: bytes) -> bytes:
    """Return one standard RFC 8439/IETF ChaCha20 block.

    ``derived_key`` is the 32-byte output of :func:`derive_domain_key`.
    MaxHook encrypts the payload starting at counter 1; counter 0 is reserved
    for whatever authentication construction is still being recovered.
    """
    if len(derived_key) != 32:
        raise ValueError("derived_key must be exactly 32 bytes")
    if len(nonce) != 12:
        raise ValueError("nonce must be exactly 12 bytes")
    if not 0 <= counter <= 0xFFFFFFFF:
        raise ValueError("counter must fit in uint32")

    initial = list(struct.unpack("<4I", b"expand 32-byte k"))
    initial += list(struct.unpack("<8I", derived_key))
    initial += [counter]
    initial += list(struct.unpack("<3I", nonce))
    working = initial.copy()

    for _ in range(10):
        _chacha_quarter_round(working, 0, 4, 8, 12)
        _chacha_quarter_round(working, 1, 5, 9, 13)
        _chacha_quarter_round(working, 2, 6, 10, 14)
        _chacha_quarter_round(working, 3, 7, 11, 15)
        _chacha_quarter_round(working, 0, 5, 10, 15)
        _chacha_quarter_round(working, 1, 6, 11, 12)
        _chacha_quarter_round(working, 2, 7, 8, 13)
        _chacha_quarter_round(working, 3, 4, 9, 14)

    return struct.pack(
        "<16I",
        *((value + base) & 0xFFFFFFFF
          for value, base in zip(working, initial)),
    )


def key_schedule_expand(key: bytes, nonce: bytes,
                        counter: int = 1) -> bytearray:
    """Build MaxHook's externally equivalent 64-byte ChaCha20 state block.

    The protected implementation reaches this result through a large VM.  The
    independent equivalent is the standard ChaCha20 block function using
    ``HMAC-SHA256(key, DOMAIN_LABEL)`` and a 96-bit nonce.
    """
    derived_key = derive_domain_key(key)
    return bytearray(chacha20_block(derived_key, counter, nonce))


# ---------------------------------------------------------------------------
# Fold + store32 (generator, plaintext, recovered rounds 58-66/84-91)
# ---------------------------------------------------------------------------

def fold(six_values: list[int]) -> int:
    """Fold 6 32-bit slot values into one 32-bit keystream word.

    Round 224 refinement: the fold is COUNTER-MODE non-linear ARX.  The 6 inputs
    (from keystream_history 52-snapshot measurement):
      +0xb5 = keystream byte (output accumulator)   +0x26 = block counter
      +0xd9 = byte offset (0x40 * block)             +0x61 = state pointer (0)
      +0xbd = key pointer (constant within call)     +0x106 = key-schedule state
    (constant within call)

    Genuine arithmetic (fold_trampoline_折叠算术精确规格.md), 12 ops + 8 constants:
      rdx-chain: add rdx,rbx; sub rdx,0x7ef78e7d; shr rdx,3; shl rdx,1
      r13-chain: sub r13d,ebp; add r13d,0x47f75fb8; not; neg; not
      others:    xor r14,0x77914aff; add r10,0x1bd67eac; sub r8,0x1f5ff464
                 push 0x3879c8ab; mov ebp,0x6eaa89fc; xor rsi,0x5f77d611

    The exact 6-value -> register mapping (which value feeds rbx/ebp/rdx/r13/r14/r10)
    is the remaining symbolic step.  Skeleton below documents the arithmetic shape.
    """
    # Several arithmetic instructions were observed, but the exact VM-stack
    # mapping and the producer of S10 (the final RDX restored by the trampoline)
    # are not proven. Returning any guessed convergence would be misleading.
    raise NotImplementedError(
        "exact fold stack/register mapping to S10 is not recovered"
    )


def store32_le(word: int) -> bytes:
    return struct.pack("<I", word & 0xFFFFFFFF)


# ---------------------------------------------------------------------------
# Top-level keystream generation (structure complete)
# ---------------------------------------------------------------------------

def generate_keystream(key: bytes, nonce: bytes, n_blocks: int) -> bytes:
    """Generate ``n_blocks`` (64 bytes each) of the MaxHook payload stream.

    The first payload block uses IETF ChaCha20 counter 1.  Counter wrap is
    rejected rather than silently reusing a keystream block.
    """
    if n_blocks < 0:
        raise ValueError("n_blocks must be non-negative")
    if n_blocks > 0xFFFFFFFF:
        raise ValueError("too many blocks for the 32-bit ChaCha20 counter")
    if len(nonce) != 12:
        raise ValueError("nonce must be exactly 12 bytes")
    derived_key = derive_domain_key(key)
    return b"".join(
        chacha20_block(derived_key, counter, nonce)
        for counter in range(1, n_blocks + 1)
    )


def encrypt_ciphertext(key: bytes, nonce: bytes, plaintext: bytes) -> bytes:
    """Reproduce MaxHook's ciphertext, without claiming the unresolved tag."""
    blocks = (len(plaintext) + 63) // 64
    stream = generate_keystream(key, nonce, blocks)
    return bytes(value ^ stream[index] for index, value in enumerate(plaintext))


# ---------------------------------------------------------------------------
# Tag evidence — SHA-256 initialization observed; role not yet attributed
# ---------------------------------------------------------------------------

# Standard SHA-256 IV constants were observed written to a 112-byte context by
# 0x18042b970 on the replayed path. This proves SHA-256 context initialization,
# but does NOT by itself prove that the envelope tag is a SHA-256 MAC.
AAD = DOMAIN_LABEL

def mac_tag(key: bytes, nonce: bytes, ciphertext: bytes, aad: bytes) -> bytes:
    """The exact 16-byte tag construction is not recovered.

    A SHA-256 context initialization is observed, but its relation to the tag,
    input ordering, and possible derived key are unproven.
    """
    raise NotImplementedError("exact tag construction is not recovered")


# ---------------------------------------------------------------------------
# Verification harness against the 14 offline pairs
# ---------------------------------------------------------------------------

def load_verify_pairs() -> list[dict]:
    pairs = []
    d = json.loads(
        Path(r"E:\Coding\S1mple\target\crypto_verify_set.json").read_text("utf-8"))
    for s in d["samples"]:
        pairs.append({
            "key": bytes.fromhex(s["key_material_64hex"]),
            "nonce": bytes.fromhex(s["nonce_24hex"]),
            "plaintext": s["plaintext"].encode("utf-8"),
            "ciphertext": bytes.fromhex(s["ciphertext_hex"]),
            "tag": bytes.fromhex(s["tag_32hex"]),
            "kid": bytes.fromhex(s["kid"]),
        })
    return pairs


def verify_envelope() -> bool:
    """Verify the envelope structure against all 7 verify-set samples."""
    pairs = load_verify_pairs()
    ok = 0
    for p in pairs:
        reproduced = encrypt_ciphertext(
            p["key"], p["nonce"], p["plaintext"])
        env_ok = (reproduced == p["ciphertext"] and len(p["key"]) == 32 and
                  len(p["nonce"]) == 12 and len(p["tag"]) == 16 and
                  len(p["kid"]) == 16)
        if env_ok:
            ok += 1
    print(f"[ciphertext] {ok}/{len(pairs)} samples independently reproduced "
          f"(HMAC-SHA256 KDF + ChaCha20 counter=1)")
    return ok == len(pairs)


if __name__ == "__main__":
    print("MaxHook recovered ciphertext reference (tag still unresolved)")
    print("=" * 60)
    verify_envelope()

    # Show the recovered constants (complete)
    print(f"\n[constants] key-schedule entry: {[hex(c) for c in KEY_SCHED_ENTRY]}")
    print(f"[constants] ARX round ({len(KEY_SCHED_ARX)}): "
          f"{[hex(c) for c in KEY_SCHED_ARX[:6]]}...")
    print(f"[constants] fold ({len(FOLD_CONSTANTS)}): "
          f"{[hex(c) for c in FOLD_CONSTANTS]}")
    print(f"[constants] dispatcher: {[hex(c) for c in DISPATCHER_CONSTANTS]}")

    # Show the round function works (self-consistency)
    s1, s2 = arx_round(0x12345678, 0x9ABCDEF0, 0x0001, 0x0002)
    print(f"\n[round] arx_round(0x12345678,0x9abcdef0,1,2) -> "
          f"s1=0x{s1:08x} s2=0x{s2:08x}")

    print("\nPARTIAL: ciphertext is complete; authentication is not.")
    print("  Unresolved: exact 16-byte tag construction and full envelope output.")
    print("  mac_tag() intentionally fails closed until that is verified.")
