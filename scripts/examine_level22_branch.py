#!/usr/bin/env python3
"""Examine the level-22 data-dependent branch at 0x1809d2d81 to determine what
it compares (key-derived state vs position/counter)."""
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

    # Level-22 handler body 0x1809d2bc2 (from vm_dispatch_chain_extended.json)
    # branch at 0x1809d2d81
    for va in [0x1809d2bc2, 0x1809d2d81, 0x1809d2df4]:
        off = va - BUGLAND_BASE
        code = blob[off:off + 0x60]
        insns = list(md.disasm(code, va))
        print("=== %#x ===" % va)
        for insn in insns[:25]:
            mark = ""
            if insn.mnemonic in ("cmp", "test", "je", "jne", "jz", "jnz", "ja", "jb", "jg", "jl"):
                mark = "  <-- branch"
            print("  %#x: %s %s%s" % (insn.address, insn.mnemonic, insn.op_str, mark))
        print()

if __name__ == "__main__":
    main()
