#!/usr/bin/env python3
"""Trace all writes to context+0x162 (flag byte) in the key-schedule handlers,
to determine the correct flag value during key-schedule (level 1-23).

The flag byte 0x162 gates dispatch branches. We need its correct value at each
key-schedule stage."""
import struct
from pathlib import Path
import sys
sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
from capstone import CS_ARCH_X86, CS_MODE_64, Cs

BUGLAND = Path(r"E:\Coding\S1mple\target\dump_out\41264\region_0000000180980000.bin")
BUGLAND_BASE = 0x180980000
TABLE_VA = 0x180C64EBD
CTX_BASE = 0x18098C884

def main():
    blob = BUGLAND.read_bytes()
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    def rd64(va): return struct.unpack_from("<Q", blob, va - BUGLAND_BASE)[0]

    # get all 54 handler bodies (from live history, round 122)
    import json
    CAP = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")
    target_to_index = {}
    for i in range(1612):
        t = rd64(TABLE_VA + i * 8)
        target_to_index.setdefault(t, []).append(i)
    d = json.loads(sorted(CAP.glob("*call_1*.bin"))[0].read_bytes().decode("utf-8"))
    distinct = []
    seen = set()
    for h in d["history"]:
        va = int(h, 16)
        if va in target_to_index:
            idx = target_to_index[va][0]
            if idx not in seen:
                seen.add(idx); distinct.append(idx)

    # follow each to body, scan for writes to [rbp+0x162] or r12=rbp+0x162 then write
    index_to_body = {}
    for i in range(1612):
        t = rd64(TABLE_VA + i * 8)
        body = t
        off = t - BUGLAND_BASE
        insns = list(md.disasm(blob[off:off+0x10], t))
        if insns and insns[0].mnemonic == "jmp" and insns[0].op_str.startswith("0x"):
            body = int(insns[0].op_str, 16)
        index_to_body[i] = body

    print("handlers that write to context+0x162 (flag byte):")
    for idx in distinct:
        body = index_to_body[idx]
        off = body - BUGLAND_BASE
        code = blob[off:off + 0x80]
        insns = list(md.disasm(code, body))
        # track r12 = rbp + 0x162 pattern
        r12_is_flag = False
        for insn in insns:
            m, ops = insn.mnemonic, insn.op_str
            # mov r12, rbp; add r12, 0x162
            if m == "mov" and ops == "r12, rbp":
                r12_is_flag = False
            if m == "add" and ops.startswith("r12, 0x162"):
                r12_is_flag = True
            if m in ("or","and","xor","mov","add","sub") and r12_is_flag and ("[r12]" in ops or "byte ptr [r12]" in ops):
                print("  idx %#x body %#x: %s %s" % (idx, body, m, ops))

if __name__ == "__main__":
    main()
