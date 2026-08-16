#!/usr/bin/env python3
"""Extract the distinct dispatch indices in the key-schedule program and map
each to its handler body + first instruction, giving the decoded bytecode's
handler roles."""
import json
import struct
from pathlib import Path
from collections import OrderedDict
import sys
sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
from capstone import CS_ARCH_X86, CS_MODE_64, Cs

BUGLAND = Path(r"E:\Coding\S1mple\target\dump_out\41264\region_0000000180980000.bin")
BUGLAND_BASE = 0x180980000
TABLE_VA = 0x180C64EBD
CAP = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")

def main():
    blob = BUGLAND.read_bytes()
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    def rd64(va): return struct.unpack_from("<Q", blob, va - BUGLAND_BASE)[0]

    target_to_index = {}
    index_to_target = {}
    for i in range(1612):
        t = rd64(TABLE_VA + i * 8)
        target_to_index.setdefault(t, []).append(i)
        index_to_target[i] = t

    d = json.loads(sorted(CAP.glob("*call_1*.bin"))[0].read_bytes().decode("utf-8"))
    history = d["history"]

    # distinct indices in execution order (preserve first-seen order)
    distinct = OrderedDict()
    for h in history:
        va = int(h, 16)
        if va in target_to_index:
            idx = target_to_index[va][0]
            distinct.setdefault(idx, va)

    print("distinct dispatch indices in key-schedule program:", len(distinct))
    print()
    for idx, va in distinct.items():
        # disassemble first 3 insns of handler body (follow jmp)
        off = va - BUGLAND_BASE
        insns = list(md.disasm(blob[off:off+0x20], va))
        first = insns[0] if insns else None
        body = va
        if first and first.mnemonic == "jmp" and first.op_str.startswith("0x"):
            body = int(first.op_str, 16)
        off2 = body - BUGLAND_BASE
        insns2 = list(md.disasm(blob[off2:off2+0x20], body))
        # first non-jmp insn
        desc = ""
        for insn in insns2:
            if insn.mnemonic != "jmp":
                desc = "%s %s" % (insn.mnemonic, insn.op_str)
                break
        print("  idx %#04x (%4d) -> %#x : %s" % (idx, idx, body, desc))

if __name__ == "__main__":
    main()
