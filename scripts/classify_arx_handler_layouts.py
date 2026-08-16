#!/usr/bin/env python3
"""Carefully classify the dispatch layout of the TOP executed handlers by
analyzing their full body, following milestone 17's exact-signature approach.

Milestone 17 identified these dispatch-tail patterns per handler:
  handler 0x1809f4736 (dispatch#2): 
      mov bx, word ptr [r12]      ; idx read (r12 = VIP + idx_off)
      shl rbx, 3
      movsxd r15, dword ptr [rsi] ; advance read
      add qword ptr [rdi], r15    ; VIP += advance
      jmp rdx
  handler 0x1809da384 (dispatch#3):
      mov dx, word ptr [r8]       ; idx
      shl rdx, 3
      movsxd rbx, dword ptr [r9]  ; advance
      add qword ptr [r14], rbx
      jmp r14

The common signature: mov* word ptr [reg] -> shl reg,3 -> movsxd dword ptr [reg]
-> add [VIPslot], reg -> jmp reg.

For each handler, the idx_off/adv_off are determined by tracking which register
holds VIP+offset.  The VIP is loaded from context+0x6d.

Let me focus on the ARX chain handlers (the ones that matter for the cipher):
chain A/B/C/D handlers from rounds 99/107.
"""
import struct
import re
from pathlib import Path
import sys
sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
from capstone import CS_ARCH_X86, CS_MODE_64, Cs

BUGLAND = Path(r"E:\Coding\S1mple\target\dump_out\41264\region_0000000180980000.bin")
BUGLAND_BASE = 0x180980000

# The ARX chain handler BODIES (from rounds 99/107, the cipher core)
ARX_HANDLERS = {
    "A1": 0x18099089e, "A2": 0x180990a93, "A3": 0x180990b21,
    "B1": 0x1809bfebb, "B2": 0x1809bff47, "B3": 0x1809c012a,
    "C1": 0x180a02a99, "C2": 0x180a02bcd, "C3": 0x180a02c51, "C4": 0x180a02c94,
    "D1": 0x180b41fb8, "D2": 0x180b42104, "D3": 0x180b42287, "D4": 0x180b423a3,
}

def main():
    blob = BUGLAND.read_bytes()
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    md.detail = True

    for name, body in ARX_HANDLERS.items():
        off = body - BUGLAND_BASE
        code = blob[off:off + 0x60]
        insns = list(md.disasm(code, body))
        # find the dispatch signature: shl reg, 3 and movsxd dword ptr [reg]
        # print the tail (last ~15 instructions) to see the dispatch structure
        print("=== %s (%#x) — tail ===" % (name, body))
        for insn in insns:
            m = insn.mnemonic
            ops = insn.op_str
            # highlight the dispatch signature ops
            mark = ""
            if m == "shl" and ops.endswith(", 3"):
                mark = "  <-- idx*8"
            elif m in ("movsxd",) and "dword ptr" in ops:
                mark = "  <-- advance"
            elif m == "movzx" and "word ptr" in ops:
                mark = "  <-- idx read"
            elif m == "jmp":
                mark = "  <-- dispatch"
            print("  %#x: %s %s%s" % (insn.address, m, ops, mark))
        print()

if __name__ == "__main__":
    main()
