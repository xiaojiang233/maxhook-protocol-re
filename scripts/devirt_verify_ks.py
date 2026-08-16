#!/usr/bin/env python3
"""Verify the keystream_byte field is the true keystream byte (destination
context byte) and correlate the two destination slots (+0xb5/+0x235) with the
XOR site semantics established in milestone 26.

Milestone 26: at 0x1809c5561 `xor byte [r8], r12b`:
  r12b      = plaintext byte (source_byte)
  [r8]      = keystream byte BEFORE xor (the "before" value)
  [r8]^r12b = ciphertext byte (after)

The keystream_history capture recorded:
  source        = r12  (plaintext pointer, low byte = plaintext byte)
  destination   = r8   (points to context slot +0xb5 or +0x235)
  keystream_byte= [r8] read BEFORE xor = the TRUE keystream byte

So keystream_byte should equal the context byte at (destination - CTX_BASE)
in the SAME snapshot's context_hex.
"""
from __future__ import annotations
import json
from pathlib import Path

CAPTURE = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")
CTX_BASE = 0x18098C884


def main():
    snaps = []
    for f in sorted(CAPTURE.glob("*.bin")):
        j = json.loads(f.read_text())
        j["_file"] = f.name
        j["ctx"] = bytes.fromhex(j["context_hex"])
        j["call"] = int(f.name.split("_call_")[1].split("_")[0])
        snaps.append(j)

    # For each snapshot, destination is r8 (context slot). keystream_byte should
    # equal ctx[destination - CTX_BASE].
    ok = 0
    total = 0
    mism = []
    for s in snaps:
        dst = int(s["destination"], 16)
        off = dst - CTX_BASE
        if 0 <= off < len(s["ctx"]):
            total += 1
            ctxb = s["ctx"][off]
            if ctxb == s["keystream_byte"]:
                ok += 1
            else:
                mism.append((s["_file"], off, ctxb, s["keystream_byte"]))
    print(f"keystream_byte == context[destination] in {ok}/{total} snapshots")
    if mism:
        print("mismatches:", mism[:10])

    # Also: source low byte should be the plaintext byte. But we don't have the
    # plaintext for this session. However, we can check that source low byte
    # XOR keystream_byte = ciphertext byte, and the ciphertext should look
    # like the plaintext's first byte '{'=0x7b when... actually plaintext[0]='{'.
    # r12b = plaintext byte = '{' = 0x7b = 123 (matches source low byte 123!).
    print("\n=== source (r12) low byte vs 'plaintext starts with {' ===")
    for s in snaps[:12]:
        src = int(s["source"], 16)
        low = src & 0xFF
        print(f"  {s['_file']}: source low byte = {low} (0x{low:02x})")

    # The keystream byte sequence: first 16 keystream bytes of call 1
    print("\n=== call 1 keystream bytes (keystream_byte field, order by xor_index) ===")
    call1 = sorted([s for s in snaps if s["call"] == 1], key=lambda s: s["xor_index"])
    ks = [s["keystream_byte"] for s in call1]
    print(f"  {len(ks)} bytes: {bytes(ks).hex()}")

    # Sanity: are these the keystream? XOR with plaintext '{' prefix.
    # plaintext = {"device_id":"E43A2C0F779F0DF2",... (same skeleton as crypto_verify_set)
    pt_prefix = b'{"device_id":"E43A2C0F779F0DF2"'
    if len(ks) >= len(pt_prefix):
        ct = bytes(k ^ p for k, p in zip(ks, pt_prefix))
        print(f"  ks XOR '{pt_prefix.decode()[:16]}...' = {ct.hex()}")
        print(f"  (ciphertext should match the real ciphertext for this session's call)")


if __name__ == "__main__":
    main()
