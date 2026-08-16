"""Analyze Stalker-translated VM addresses to find ALL real ARX instructions.

The trace files vm_addrs_callN.txt contain 40000 unique translated addresses
(real executed VM instructions).  Cross-reference these against the disk .bugland
bytes to find the real rol/ror/bswap/shift instructions and their surrounding
context.  This reveals the actual ARX round function.
"""

from __future__ import annotations
import struct
from pathlib import Path
from collections import Counter

from capstone import Cs, CS_ARCH_X86, CS_MODE_64, CS_OP_MEM, CS_OP_REG, CS_OP_IMM

TRACE_DIR = Path(r"E:\Coding\S1mple\target\vm_trace_capture4")
BUG = Path(r"E:\Coding\S1mple\target\runtime_bugland2.bin")
BUG_BASE = 0x180980000
BUG_END = BUG_BASE + BUG.stat().st_size

md = Cs(CS_ARCH_X86, CS_MODE_64)
md.detail = True
bug = BUG.read_bytes()


def load_addrs(call=1):
    p = TRACE_DIR / f"vm_addrs_call{call}.txt"
    addrs = []
    for line in p.read_text().splitlines():
        line = line.strip()
        if not line:
            continue
        # format: 0xADDR:count
        va_str, _, _ = line.partition(":")
        va = int(va_str, 16)
        addrs.append(va)
    return addrs


def main():
    addrs = load_addrs(1)
    print(f"loaded {len(addrs)} unique addresses from call1")

    # classify mnemonics of the translated addresses by disassembling disk bytes
    mnem_counter = Counter()
    rot_insns = []
    shift_insns = []
    bswap_insns = []
    for va in addrs:
        if not (BUG_BASE <= va < BUG_END):
            continue
        code = bug[va - BUG_BASE: va - BUG_BASE + 15]
        ins = next(md.disasm(code, va), None)
        if ins is None:
            continue
        m = ins.mnemonic
        mnem_counter[m] += 1
        if m in ("rol", "ror", "rcl", "rcr"):
            rot_insns.append((va, ins))
        elif m in ("shl", "shr", "sal", "sar"):
            shift_insns.append((va, ins))
        elif m == "bswap":
            bswap_insns.append((va, ins))

    print(f"\nmnemonics among translated addrs (top 30):")
    for m, c in mnem_counter.most_common(30):
        print(f"  {c:6d}  {m}")

    print(f"\n=== {len(rot_insns)} ROTATE instructions (rol/ror/rcl/rcr) ===")
    for va, ins in rot_insns:
        # show operand detail
        print(f"  0x{va:x}  {ins.mnemonic} {ins.op_str}")

    print(f"\n=== {len(shift_insns)} SHIFT instructions ===")
    for va, ins in shift_insns:
        print(f"  0x{va:x}  {ins.mnemonic} {ins.op_str}")

    print(f"\n=== {len(bswap_insns)} BSWAP instructions ===")
    for va, ins in bswap_insns:
        print(f"  0x{va:x}  {ins.mnemonic} {ins.op_str}")


if __name__ == "__main__":
    main()
