#!/usr/bin/env python3
"""Classify the dispatch layout (idx_off, adv_off, key_off) of each handler body
by disassembling its dispatch tail.  This extends the statically-proven chain.

For each handler body, the dispatch tail does:
  - reads word[VIP + idx_off] (movzx reg, word ptr [reg]) -> shl 3 -> table index
  - reads i32[VIP + adv_off] (movsxd reg, dword ptr [reg]) -> add to VIP
  - optionally reads word[VIP + key_off] to fold the rolling key
  - jmp to handler

We identify idx_off/adv_off/key_off by scanning the handler body's instructions
for `word ptr [reg + off]` and `dword ptr [reg + off]` accesses where reg holds
the VIP.

For the milestone-17 proven handlers, the layout is:
  0x1809f4736: idx=+6 (word[+6]), adv=+2 (dword[+2])
  0x1809da384: idx=+0xc, adv=+4
  0x1809bfebb: idx=+0, adv=+6, key=+0xa

Let me disassemble the 5th handler 0x1809a3b86 (target 0x180a02a99) and find its layout."""
import struct
from pathlib import Path
import sys
sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
from capstone import CS_ARCH_X86, CS_MODE_64, Cs
from capstone.x86_const import X86_OP_MEM, X86_OP_IMM

BUGLAND = Path(r"E:\Coding\S1mple\target\dump_out\41264\region_0000000180980000.bin")
BUGLAND_BASE = 0x180980000

def main():
    blob = BUGLAND.read_bytes()
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    md.detail = True

    # The 5th handler body is 0x180a02a99 (from chain C, round 99/107)
    # Actually the dispatch target of dispatch4 was 0x1809a3b86 (stub), which
    # jmps to body 0x180a02a99.  Disassemble 0x180a02a99's body to find its tail.
    for body in [0x180a02a99, 0x180a02bcd, 0x180a02c51]:
        print("=== body %#x ===" % body)
        off = body - BUGLAND_BASE
        code = blob[off:off + 0x80]
        insns = list(md.disasm(code, body))
        for i, insn in enumerate(insns[:30]):
            ops = insn.op_str
            # flag word/dword memory accesses with displacement
            print("  %#x: %s %s" % (insn.address, insn.mnemonic, ops))
        print()

if __name__ == "__main__":
    main()
