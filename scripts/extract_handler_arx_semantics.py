#!/usr/bin/env python3
"""Extract the ARX semantics of all 54 key-schedule handlers: the genuine
context-slot arithmetic (reads/writes to context slots via rbp+offset, with
constants), filtering Themida register-shuffle decoys.

This gives the complete cipher arithmetic for each handler, enabling full
symbolic execution of key_schedule_expand().
"""
import json
import struct
import re
from pathlib import Path
import sys
sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
from capstone import CS_ARCH_X86, CS_MODE_64, Cs

BUGLAND = Path(r"E:\Coding\S1mple\target\dump_out\41264\region_0000000180980000.bin")
BUGLAND_BASE = 0x180980000
TABLE_VA = 0x180C64EBD
CAP = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")

# context slot base (VM context @ 0x18098c884)
RBP = 0x18098C884

def main():
    blob = BUGLAND.read_bytes()
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    def rd64(va): return struct.unpack_from("<Q", blob, va - BUGLAND_BASE)[0]

    # build index -> target (and follow jmp stubs to bodies)
    index_to_body = {}
    for i in range(1612):
        t = rd64(TABLE_VA + i * 8)
        # follow jmp stub
        body = t
        off = t - BUGLAND_BASE
        insns = list(md.disasm(blob[off:off+0x10], t))
        if insns and insns[0].mnemonic == "jmp" and insns[0].op_str.startswith("0x"):
            body = int(insns[0].op_str, 16)
        index_to_body[i] = body

    # get distinct indices from live history
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
                seen.add(idx)
                distinct.append(idx)

    print("distinct handlers:", len(distinct))
    # For each handler, disassemble body (~0x60 bytes) and extract context-slot
    # memory ops (rbp +/- offset) with their arithmetic.
    ARITH = {"add","sub","xor","and","or","shl","shr","rol","ror","not","neg","mov","movzx","movsxd","cmp","inc","dec"}
    results = {}
    for idx in distinct:
        body = index_to_body[idx]
        off = body - BUGLAND_BASE
        code = blob[off:off + 0x60]
        insns = list(md.disasm(code, body))
        ops_out = []
        for insn in insns:
            m = insn.mnemonic
            ops = insn.op_str
            # genuine: touches rbp+offset (context slot) in a memory operand
            # OR arithmetic with a full 32-bit immediate
            if "rbp" in ops and ("ptr" in ops or m in ("add","sub","xor","and","or")):
                # extract the rbp+offset
                mo = re.search(r"rbp\s*[+-]\s*(0x[0-9a-fA-F]+|\d+)", ops)
                offv = int(mo.group(1), 0) if mo else None
                # also extract any immediate constant
                imm = None
                im = re.search(r"0x[0-9a-fA-F]{8}", ops)
                if im:
                    imm = im.group(0)
                if offv is not None or imm:
                    ops_out.append((m, ops, offv, imm))
        results[idx] = ops_out

    # print genuine context-slot arithmetic per handler
    for idx in distinct:
        body = index_to_body[idx]
        ops = results[idx]
        if not ops:
            continue
        print("\nidx %#04x (%d) body %#x:" % (idx, idx, body))
        for m, opsstr, offv, imm in ops[:8]:
            print("  %s %s  (slot=+0x%x, const=%s)" % (m, opsstr, offv or 0, imm or "-"))

    # save
    out = Path(r"E:\Coding\S1mple\target\handler_arx_semantics.json")
    out.write_text(json.dumps(
        {hex(idx): [[m, ops, offv, imm] for (m, ops, offv, imm) in results[idx]]
         for idx in distinct}, indent=1) + "\n")
    print("\nwrote", out.resolve())

if __name__ == "__main__":
    main()
