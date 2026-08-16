#!/usr/bin/env python3
"""Corrected full chain walk: track VIP advance + key per the milestone-17
proven dispatch mechanics.

Proven (milestone 17, analyze_maxhook_vm_initial_chain.py):
  dispatch 1 (dispatcher 0x180a97f70): idx=word[VIP+0], adv=i32[VIP+2], VIP+=adv
    idx=0x147 adv=0xDBC5 target=0x1809ac48d -> handler 0x1809f4736
  dispatch 2 (handler 0x1809f4736): idx=word[VIP+6], adv=i32[VIP+2], VIP+=adv
    idx=0x321 adv=-0x7E43 target=0x180981ac9 -> handler 0x1809da384
  dispatch 3 (handler 0x1809da384): idx=word[VIP+0xc], adv=i32[VIP+4]
    idx=0x05d adv=0xC173 target=0x18098257f -> handler 0x1809bfebb
  dispatch 4 (handler 0x1809bfebb, keyed): key=word[VIP+0xa],
    idx=(word[VIP+0]-key+0x5214a88c)&0xffff, adv=i32[VIP+6], key_after=key-idx_full
    idx=0x0e0 adv=-0xA068 target=0x1809a3b86 -> handler 0x180a02a99

Each handler has a DIFFERENT (idx_off, adv_off, key_off) layout.  The
vm_dispatch_chain_extended.json already contains levels 5-22 with the correct
per-handler layouts.  Let me continue from level 22 using those layouts and the
correct flag byte.

From the JSON, level 22 = handler 0x1809d2bc2, exit key=0x7c2c16c7 (but this was
computed with flag 0x69; correct flag is 0xC3).

The key realization: instead of re-deriving everything, let me just READ the
already-decoded chain (levels 5-22) and identify what layout level 23 uses, then
re-derive level 23's index with the CORRECT key.

Level 23 handler = 0x1809b6a53. Its dispatch (from the divergence note):
  index = ((word[VIP+6] - key) - 0x6554fdd7) & 0xffff
  advance = i32[VIP+0]
  word_vip6 = 0x1c36, key=0x7c2c16c7 -> index 0x798 (invalid)

The question: is the key 0x7c2c16c7 correct, or was it wrong due to flag?
"""
import struct
from pathlib import Path

BUGLAND = Path(r"E:\Coding\S1mple\target\dump_out\41264\region_0000000180980000.bin")
BUGLAND_BASE = 0x180980000
TABLE_VA = 0x180C64EBD

def main():
    blob = BUGLAND.read_bytes()
    def rd16(va): return struct.unpack_from("<H", blob, va - BUGLAND_BASE)[0]
    def rd32(va): return struct.unpack_from("<i", blob, va - BUGLAND_BASE)[0]
    def rd64(va): return struct.unpack_from("<Q", blob, va - BUGLAND_BASE)[0]

    # Level 23: handler 0x1809b6a53, vip=0x18155c6b7, key=0x7c2c16c7
    vip = 0x18155c6b7
    key = 0x7c2c16c7
    w6 = rd16(vip + 6)
    idx = ((w6 - key) - 0x6554fdd7) & 0xffff
    print("level 23 re-derivation (key=0x%x):" % key)
    print("  word[VIP+6]=0x%x, index=((0x%x-0x%x)-0x6554fdd7)&0xffff=0x%x" % (w6, w6, key, idx))

    # The key 0x7c2c16c7 came from level 22's key_after. Level 22's key_before
    # was 0x53890e3b (from level 21's key_after). Let me check: what should
    # level 22's key_after be with correct flag?
    # Level 22 handler 0x1809d2bc2 reads ctx+0x69 and ctx+0xa. The key is stored
    # at ctx+0xa. The flag byte +0x162 gates a branch that affects the key fold.

    # Actually, let me try a DIFFERENT key hypothesis: what if level 22's key
    # computation is independent of flag, and the divergence is elsewhere?
    # Let me check if index 0x798 is simply out of the 1612-entry table (it is,
    # 1944 > 1611), meaning the key is definitely wrong.

    # Try: what key value would make index a valid (< 1612) value?
    # idx = ((w6 - key) - 0x6554fdd7) & 0xffff must be < 1612 = 0x64c
    # w6 = 0x1c36, so (0x1c36 - key - 0x6554fdd7) & 0xffff < 0x64c
    # => key = (0x1c36 - 0x6554fdd7 - idx) & 0xffff... for idx in valid range
    # Let's find candidate keys that give a valid stub target
    valid = []
    for cand_idx in range(1612):
        tgt = rd64(TABLE_VA + cand_idx * 8)
        # check if tgt is a valid stub (jmp imm)
        off = tgt - BUGLAND_BASE
        if 0 <= off < len(blob) - 2:
            # crude check: first byte is 0xE9 (jmp rel32) or 0xEB (jmp rel8)
            if blob[off] in (0xE9, 0xEB):
                valid.append(cand_idx)
    print("\nvalid stub indices count:", len(valid))
    # For each valid idx, the required key = (w6 - idx - 0x6554fdd7) & 0xffffffff
    # (using 32-bit: key = (w6 - 0x6554fdd7 - idx) mod 2^32, but key is 32-bit)
    candidates = []
    for idx in valid[:200]:
        k = (w6 - 0x6554fdd7 - idx) & 0xffffffff
        candidates.append((idx, k))
    print("candidate (idx, key) pairs that give valid stubs:")
    for idx, k in candidates[:20]:
        print("  idx=%#x -> key=%#x" % (idx, k))

if __name__ == "__main__":
    main()
