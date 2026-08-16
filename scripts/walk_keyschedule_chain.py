#!/usr/bin/env python3
"""Extend the statically-proven VM dispatch chain (milestone 17) to walk the
FULL key-schedule bytecode program.

Proven dispatch mechanics:
  - dispatch reads word[VIP + idx_off] as table index (idx_off varies per handler)
  - index = (word - key + 0x5214a88c) & 0xffff  (for keyed handlers)
  - key = word[VIP + key_off] (data-driven, folded: key_after = key_before - index_full)
  - advance = i32[VIP + adv_off]
  - VIP += advance
  - handler = table[index]

Different handlers use different (idx_off, adv_off, key_off) layouts.  From the
proven chain:
  handler 0x1809f4736: idx=+6,   adv=+2
  handler 0x1809da384: idx=+0xc, adv=+4
  handler 0x1809bfebb: idx=+0,   adv=+6, key=+0xa  (keyed)

To walk the full chain, I need to classify each handler's dispatch layout by
disassembling its tail (the dispatch stub).  The handler table gives the target
for each index; the target's tail does the next dispatch.

This script reconstructs the full dispatch chain from the runtime bugland blob
using the handler table, classifying each handler's (idx_off, adv_off, key_off).
"""
import struct
from pathlib import Path

BUGLAND = Path(r"E:\Coding\S1mple\target\dump_out\41264\region_0000000180980000.bin")
BUGLAND_BASE = 0x180980000
TABLE_VA = 0x180C64EBD
MASK32 = 0xFFFFFFFF

def main():
    blob = BUGLAND.read_bytes()
    def rd16(va): return struct.unpack_from("<H", blob, va - BUGLAND_BASE)[0]
    def rd32(va): return struct.unpack_from("<i", blob, va - BUGLAND_BASE)[0]
    def rd64(va): return struct.unpack_from("<Q", blob, va - BUGLAND_BASE)[0]
    def table(idx): return rd64(TABLE_VA + idx * 8)

    # Known proven handler dispatch layouts: handler_body_va -> (idx_off, adv_off, key_off or None)
    # From milestone 17:
    LAYOUTS = {
        0x1809f4736: (6, 2, None),    # idx=+6, adv=+2, unkeyed
        0x1809da384: (0xc, 4, None),  # idx=+0xc, adv=+4, unkeyed
        0x1809bfebb: (0, 6, 0xa),     # idx=+0, adv=+6, keyed (key=word[VIP+0xa])
    }

    # Start the chain from the proven 4th dispatch
    initial_vip = 0x180000000 + 0x1555629  # from milestone 17 (vip_seed_rva)
    # Walk the proven 4 dispatches to get to the key-schedule start
    # (replicate milestone 17's chain)
    vip = initial_vip
    chain = []
    # dispatch 1: idx=word[VIP+0], adv=i32[VIP+2]
    idx1 = rd16(vip)
    adv1 = rd32(vip + 2)
    chain.append(("dispatch1", vip, idx1, adv1, table(idx1)))
    vip = vip + adv1
    # dispatch 2: handler 0x1809f4736, idx=+6, adv=+2
    idx2 = rd16(vip + 6); adv2 = rd32(vip + 2)
    chain.append(("dispatch2", vip, idx2, adv2, table(idx2)))
    vip = vip + adv2
    # dispatch 3: handler 0x1809da384, idx=+0xc, adv=+4
    idx3 = rd16(vip + 0xc); adv3 = rd32(vip + 4)
    chain.append(("dispatch3", vip, idx3, adv3, table(idx3)))
    vip = vip + adv3
    # dispatch 4: handler 0x1809bfebb, keyed, idx=+0, adv=+6, key=word[VIP+0xa]
    key4 = rd16(vip + 0xa)
    raw4 = rd16(vip)
    idx4_full = (raw4 - key4 + 0x5214a88c) & MASK32
    idx4 = idx4_full & 0xffff
    key4_after = (key4 - idx4_full) & MASK32
    adv4 = rd32(vip + 6)
    chain.append(("dispatch4", vip, idx4, adv4, table(idx4), key4_after))
    vip = vip + adv4

    print("Proven chain (milestone 17):")
    for c in chain:
        print("  ", c)

    print("\nContinuing chain from VIP=%#x, key=%#x..." % (vip, key4_after))

    # Now walk the rest. We need to classify each handler's dispatch layout.
    # The handler table target tells us the handler body; its dispatch tail
    # determines the next (idx_off, adv_off, key_off).
    # For now, report the table targets of the next several dispatches using
    # the keyed layout (idx=+0, adv=+6, key=+0xa) as a starting hypothesis.
    key = key4_after
    steps = 0
    while steps < 60:
        # try keyed layout: idx = (word[VIP+0] - key + 0x5214a88c) & 0xffff
        raw = rd16(vip)
        idx_full = (raw - (key & 0xffff) + 0x5214a88c) & MASK32
        idx = idx_full & 0xffff
        tgt = table(idx)
        adv = rd32(vip + 6)
        key_after = (key - idx_full) & MASK32
        # is target a valid handler (in bugland)?
        in_bug = BUGLAND_BASE <= tgt < BUGLAND_BASE + len(blob)
        print(f"  step {steps}: VIP={vip:#x} raw={raw:#06x} idx={idx:#06x} "
              f"tgt={tgt:#x} adv={adv} key={key_after:#x} valid={in_bug}")
        if not in_bug:
            break
        vip += adv
        key = key_after
        steps += 1

if __name__ == "__main__":
    main()
