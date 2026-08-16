#!/usr/bin/env python3
"""Systematically classify the dispatch layout of every handler in the decrypted
handler table.  For each handler body, find:
  - idx_off:  offset where `word ptr [VIP + idx_off]` is read (the table index)
  - adv_off:  offset where `dword ptr [VIP + adv_off]` is read (signed advance)
  - key_off:  offset where the rolling-key word is read (keyed handlers)

The VIP is stored at context+0x6d.  Handlers load VIP via `mov rX, [rbp+0x6d]`
then `add rX, K` then `movzx rY, word ptr [rX]` (idx) / `movsxd rY, dword ptr [rX]`
(advance).

We scan each handler body for the pattern: after loading [rbp+0x6d] and adding a
constant K, a `word ptr [reg]` read gives idx_off=K, a `dword ptr [reg]` read
gives adv_off=K.
"""
import struct
import re
from pathlib import Path
import sys
sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
from capstone import CS_ARCH_X86, CS_MODE_64, Cs
from capstone.x86_const import X86_OP_MEM, X86_OP_REG, X86_OP_IMM

BUGLAND = Path(r"E:\Coding\S1mple\target\dump_out\41264\region_0000000180980000.bin")
BUGLAND_BASE = 0x180980000
TABLE_VA = 0x180C64EBD

def main():
    blob = BUGLAND.read_bytes()
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    md.detail = True

    def rd64(va): return struct.unpack_from("<Q", blob, va - BUGLAND_BASE)[0]

    # For each table entry, get the handler target, then disassemble its body
    # to find the dispatch-tail offsets.
    # Load the 177 handlers that were actually executed (from the trace).
    import json
    trace = json.loads(Path(r"E:\Coding\S1mple\target\vm_handler_execution_trace.json").read_text("utf-8"))
    targets = sorted({int(t["target"], 16) for t in trace})
    print("classifying %d executed handlers..." % len(targets))

    results = {}
    for tgt in targets:
        off = tgt - BUGLAND_BASE
        if not (0 <= off < len(blob) - 0x80):
            continue
        code = blob[off:off + 0x80]
        insns = list(md.disasm(code, tgt))
        # Track: which register holds VIP (loaded from [rbp+0x6d] then +K)
        # Find word/dword memory reads with a displacement, and the preceding
        # "add reg, K" to determine the offset.
        idx_off = adv_off = key_off = None
        for i, insn in enumerate(insns):
            m = insn.mnemonic
            ops = insn.op_str
            # detect word ptr [reg] reads (idx candidates)
            if m == "movzx" and "word ptr" in ops:
                # the base register and any disp
                pass
        # simpler heuristic: scan for the dispatch-tail signature:
        #   shl reg, 3  (index * 8)  -> preceded by movzx word ptr [VIP+off]
        for i, insn in enumerate(insns):
            if insn.mnemonic == "shl" and insn.op_str.endswith(", 3"):
                # look backward for the movzx word ptr [reg] or the add reg, K
                for j in range(i-1, max(0, i-8), -1):
                    p = insns[j]
                    if p.mnemonic == "movzx" and "word ptr" in p.op_str:
                        # extract the memory operand
                        m = re.search(r"\[(\w+)(?:\s*\+\s*(0x[0-9a-fA-F]+|-?\d+))?\]", p.op_str)
                        if m:
                            idx_off = m.group(2)
                        break
                # look forward for movsxd dword ptr [reg] (advance)
                for j in range(i, min(i+6, len(insns))):
                    q = insns[j]
                    if q.mnemonic in ("movsxd", "mov") and "dword ptr" in q.op_str:
                        m = re.search(r"\[(\w+)(?:\s*\+\s*(0x[0-9a-fA-F]+|-?\d+))?\]", q.op_str)
                        if m:
                            adv_off = m.group(2)
                        break
                break
        results[tgt] = (idx_off, adv_off, key_off)

    # summarize
    from collections import Counter
    layout_counts = Counter()
    for tgt, (io, ao, ko) in results.items():
        layout_counts[(io, ao, ko)] += 1
    print("\ndispatch layout distribution (idx_off, adv_off, key_off): count")
    for (io, ao, ko), c in layout_counts.most_common(20):
        print("  (%s, %s, %s): %d" % (io, ao, ko, c))

    # Save results
    out = Path(r"E:\Coding\S1mple\target\dispatch_layouts.json")
    out.write_text(json.dumps(
        {hex(k): list(v) for k, v in results.items()}, indent=1) + "\n")
    print("\nwrote", out.resolve())

if __name__ == "__main__":
    main()
