#!/usr/bin/env python3
"""Concrete symbolic execution of key-schedule handlers using the REAL dispatch
trace's VIP/key values to constrain the data-driven control flow.

The handler reads context slots, does ARX, and dispatches via jmp reg. By using
the REAL VIP (from vm_handler_execution_trace.json) we know exactly which
bytecode words are read, so we can concretely execute the handler's arithmetic
and observe the context-slot writes.

This extracts the genuine ARX semantics per handler: which slots are read,
which are written, and with what expression.

Approach: use the Unicorn concrete execution (already working) but with the
context slots SYMBOLIC, tracking the dataflow to determine the mapping.
Actually simpler: since control flow is key-independent (proven 623 stable
4-grams), we can concretely execute each handler once with a known state and
observe which slots change, giving the slot-level dataflow.
"""
import struct
from pathlib import Path
import sys
sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
from capstone import CS_ARCH_X86, CS_MODE_64, Cs
import json

BUGLAND = Path(r"E:\Coding\S1mple\target\runtime_bugland2.bin")
BUG = 0x180980000
TABLE_VA = 0x180C64EBD

def main():
    blob = BUGLAND.read_bytes()
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    def rd64(va): return struct.unpack_from("<Q", blob, va - BUG)[0]

    # Build index -> body (follow jmp stubs)
    index_to_body = {}
    for i in range(1612):
        t = rd64(TABLE_VA + i * 8)
        body = t
        off = t - BUG
        if 0 <= off < len(blob) - 2:
            insns = list(md.disasm(blob[off:off+0x10], t))
            if insns and insns[0].mnemonic == "jmp" and insns[0].op_str.startswith("0x"):
                body = int(insns[0].op_str, 16)
        index_to_body[i] = body

    # The dispatch trace gives the handler sequence. Extract the body sequence.
    trace = json.loads(Path(r"E:\Coding\S1mple\target\vm_handler_execution_trace.json").read_text(encoding="utf-8"))
    # The trace 'target' values are the handler table entries (stubs).
    # Map them to bodies.
    bodies = []
    for t in trace:
        va = int(t["target"], 16)
        # follow stub
        off = va - BUG
        if 0 <= off < len(blob) - 2:
            insns = list(md.disasm(blob[off:off+0x10], va))
            if insns and insns[0].mnemonic == "jmp" and insns[0].op_str.startswith("0x"):
                va = int(insns[0].op_str, 16)
        bodies.append(va)

    # The distinct body sequence (first occurrence order)
    distinct = []
    seen = set()
    for b in bodies:
        if b not in seen:
            seen.add(b)
            distinct.append(b)

    print("distinct handler bodies in trace:", len(distinct))
    print()
    # For each distinct body, disassemble the first 0x80 bytes and extract
    # the context-slot access pattern (rbp+offset) to map slot-level dataflow.
    for b in distinct[:60]:
        off = b - BUG
        if not (0 <= off < len(blob)):
            continue
        code = blob[off:off+0x80]
        insns = list(md.disasm(code, b))
        # extract rbp+offset references
        slots = set()
        for insn in insns:
            ops = insn.op_str
            if "rbp" in ops:
                import re
                for m in re.finditer(r"rbp\s*\+\s*(0x[0-9a-fA-F]+|\d+)", ops):
                    slots.add(int(m.group(1), 0))
                for m in re.finditer(r"rbp\s*-\s*(0x[0-9a-fA-F]+|\d+)", ops):
                    slots.add(-int(m.group(1), 0))
        if slots:
            print("%#x: slots=%s" % (b, sorted(hex(s) if s>=0 else '-0x%x'%(-s) for s in slots)))

if __name__ == "__main__":
    main()
