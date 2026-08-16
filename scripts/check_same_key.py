#!/usr/bin/env python3
"""Critical check: do the 3 calls in keystream_history (pid 42948) share the SAME
key or have DIFFERENT keys?

Evidence to check:
1. The key POINTER (+0xbd) across calls: same pointer = same key buffer.
2. The kid/output envelope: not captured here, but the key pointer is.
3. The 47 'key-derived' bytes: if same key, these would be NONCE-derived.

The summary said '3 different keys' but let me verify from the key pointer."""
import json
from pathlib import Path

CAP = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")

def main():
    for call in (1, 2, 3):
        # collect key pointer +0xbd (8 bytes) and state +0x61 across all snapshots
        key_ptrs = set()
        state_ptrs = set()
        for f in sorted(CAP.glob("*call_%s*.bin" % call)):
            d = json.loads(f.read_text(encoding="utf-8"))
            ctx = bytes.fromhex(d["context_hex"])
            key_ptrs.add(ctx[0xbd:0xc5].hex())
            state_ptrs.add(ctx[0x61:0x69].hex())
        print("call %d:" % call)
        print("  key pointer +0xbd values:", key_ptrs)
        print("  state pointer +0x61 values:", state_ptrs)

    # The retval pointer in events (output envelope) is same for all calls
    # (0x11a6cff4f0), suggesting same session. Check if kid/input64 was same.
    # Actually check the 'source' (plaintext pointer) - if plaintext differs but
    # key pointer is same, it's same key + different plaintext/nonce.
    print("\nAnalysis: if +0xbd (key pointer) is IDENTICAL across all 3 calls,")
    print("then the 3 calls share the SAME key (and the 47 differing bytes are")
    print("NONCE/position-derived, not key-derived).")

if __name__ == "__main__":
    main()
