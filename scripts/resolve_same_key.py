#!/usr/bin/env python3
"""Resolve the same-key question decisively.

The plaintext JSON contains session_id and device_id. If the 3 calls share the
same session_id/device_id, they are the same session => same key.

But keystream_history only captured 'source' (plaintext pointer), not the
plaintext content. However, the 'source' low byte and the keystream byte at
XOR let us reconstruct ciphertext. More directly: check if there's any
plaintext/id captured.

Actually, the decisive test: the summary says keystream_history pid 42948, and
crypto_verify_set pid 16448, writer_sync pid (other), etc. are DIFFERENT sessions.
WITHIN keystream_history (pid 42948), are the 3 calls same-key?

Evidence available:
1. retval same (0x11a6cff4f0) -> output envelope reused -> same session context
2. thread same (20272)
3. key pointer +0xbd differs per call (heap reallocation)

The retval reuse is the STRONGEST evidence of same session/same key. A session
has ONE key (the summary says 'key_material 恒定' for verify_set). So keystream_history
3 calls = same key + 3 nonces.

Let me verify by checking if the nonces can be recovered. The nonce is 12B, output.
Actually let me check the plaintext content via the XOR: ciphertext = plaintext XOR keystream.
We have keystream byte (per XOR) and the plaintext is JSON (starts with '{"device_id":').

Let me reconstruct the plaintext prefix from the keystream + known JSON structure,
and extract session_id/device_id to confirm same session."""
import json
from pathlib import Path

CAP = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")

def main():
    for call in (1, 2, 3):
        # collect (xor_index, keystream_byte, source low byte) in order
        snaps = []
        for f in sorted(CAP.glob("*call_%s*.bin" % call)):
            d = json.loads(f.read_text(encoding="utf-8"))
            snaps.append((d["xor_index"], d["keystream_byte"], int(d["source"], 16) & 0xff))
        snaps.sort()
        # keystream byte + plaintext byte = ciphertext byte. We don't have
        # plaintext bytes directly, but 'source' low byte = plaintext byte at XOR.
        # Reconstruct first 16 plaintext bytes:
        pt = []
        for xi, kb, src in snaps[:16]:
            # source low byte = plaintext byte (r12b), keystream = [r8]
            pt.append(src)
        print("call %d first 16 plaintext bytes (from source low byte):" % call)
        print("  ", bytes(pt))
        print("  as ascii:", bytes(pt).decode(errors="replace"))

if __name__ == "__main__":
    main()
