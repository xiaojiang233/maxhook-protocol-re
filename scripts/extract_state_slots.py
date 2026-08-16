#!/usr/bin/env python3
"""Extract state slots (0x1e, 0x143, 0x98, 0x92, 0xa0) and keystream byte from
keystream_history snapshots, and test whether the round function
(state ^= word[VIP+3] ^ s1 - s2) explains the keystream evolution."""
from __future__ import annotations
import json, glob
from pathlib import Path

CAP = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")

def main():
    for call in (1, 2, 3):
        files = sorted(CAP.glob(f"*call_{call}*.bin"))
        print(f"\n=== call {call} ({len(files)} snapshots) ===")
        for f in files[:5]:
            d = json.loads(f.read_text(encoding="utf-8"))
            ctx = bytes.fromhex(d["context_hex"])
            kb = d["keystream_byte"]
            xi = d["xor_index"]
            s1e = int.from_bytes(ctx[0x1e:0x22], "little")
            s143 = int.from_bytes(ctx[0x143:0x147], "little")
            s98 = int.from_bytes(ctx[0x98:0x9c], "little")
            s92 = int.from_bytes(ctx[0x92:0x96], "little")
            print(f"xor={xi:4d} kb={kb:02x} | 0x1e={s1e:#010x} 0x143={s143:#010x} "
                  f"0x98={s98:#010x} 0x92={s92:#010x}")

if __name__ == "__main__":
    main()
