#!/usr/bin/env python3
"""Re-derive level 23's dispatch with correct flag byte. The prior session
diverged because it used flag 0x69, but the correct steady-state flag is 0xC3.

Level 23 (from vm_dispatch_chain_extended.json divergence):
  handler_body 0x1809b6a53, vip_before 0x18155c6b7, key_before 0x7c2c16c7
  index = ((word[VIP+6] - key) - 0x6554fdd7) & 0xffff = 0x798 (invalid)
  word_vip6 = 0x1c36

Let me examine the level-23 handler body to find how the flag +0x162 affects
the dispatch, and re-derive with flag=0xC3 vs 0x69."""
import struct
from pathlib import Path
import sys
sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
from capstone import CS_ARCH_X86, CS_MODE_64, Cs

BUGLAND = Path(r"E:\Coding\S1mple\target\dump_out\41264\region_0000000180980000.bin")
BUGLAND_BASE = 0x180980000

def main():
    blob = BUGLAND.read_bytes()
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    def rd16(va): return struct.unpack_from("<H", blob, va - BUGLAND_BASE)[0]
    def rd32(va): return struct.unpack_from("<i", blob, va - BUGLAND_BASE)[0]

    # level 23 handler 0x1809b6a53
    body = 0x1809b6a53
    off = body - BUGLAND_BASE
    code = blob[off:off + 0x80]
    insns = list(md.disasm(code, body))
    print("=== level 23 handler 0x1809b6a53 (full body) ===")
    for insn in insns[:40]:
        mark = ""
        if insn.mnemonic in ("cmp","test","jmp") or insn.mnemonic.startswith("j"):
            mark = "  <-- %s" % insn.mnemonic
        print("  %#x: %s %s%s" % (insn.address, insn.mnemonic, insn.op_str, mark))

    # Re-derive: index = ((word[VIP+6] - key) - 0x6554fdd7) & 0xffff
    vip = 0x18155c6b7
    key = 0x7c2c16c7
    w6 = rd16(vip + 6)
    idx = ((w6 - key) - 0x6554fdd7) & 0xffff
    print("\nword[VIP+6] = 0x%x, key = 0x%x" % (w6, key))
    print("index = ((0x%x - 0x%x) - 0x6554fdd7) & 0xffff = 0x%x (%d)" % (w6, key, idx, idx))

if __name__ == "__main__":
    main()
