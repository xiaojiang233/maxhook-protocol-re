#!/usr/bin/env python3
"""Determine whether context+0x162 (the self-mutating flag byte) is key-derived
or has a fixed/position value.

Check its value across the 3 calls in keystream_history (same key, 3 nonces) and
whether it's constant (fixed) or varies (key/nonce/position derived)."""
import json
from pathlib import Path

CAP = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")

def main():
    for call in (1, 2, 3):
        vals = []
        for f in sorted(CAP.glob("*call_%s*.bin" % call)):
            d = json.loads(f.read_text(encoding="utf-8"))
            ctx = bytes.fromhex(d["context_hex"])
            vals.append(ctx[0x162])
        print("call %d: +0x162 values across %d snapshots: %s" % (
            call, len(vals), sorted(set(vals))))
        print("  distinct:", sorted(set(vals)))

    # Also check the initial context value (milestone 17 / dump)
    # The flag byte at +0x162 in the dump (pid 41264, idle)
    dump = Path(r"E:\Coding\S1mple\target\dump_out\41264\region_0000000180980000.bin")
    # VM context base 0x18098c884 -> offset in bugland
    ctx_base = 0x18098C884
    bug_base = 0x180980000
    off = ctx_base + 0x162 - bug_base
    blob = dump.read_bytes()
    if 0 <= off < len(blob):
        print("\ndump context+0x162 value:", hex(blob[off]))

if __name__ == "__main__":
    main()
