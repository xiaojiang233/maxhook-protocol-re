#!/usr/bin/env python3
"""Complete symbolic executor for the key-schedule handlers using z3.

Tracks registers as z3 expressions through the full Themida obfuscation:
  - mov/add/sub/xor/and/or with immediate
  - register moves
  - memory loads/stores to context slots (rbp+off)
  - the VIP indirection (ctx+0x6d -> VIP -> word[VIP+K])

Goal: for each of the 54 handlers, extract the pure function from input context
slots to output context slots (the cipher arithmetic), to enable full symbolic
execution of key_schedule_expand().
"""
import json
import struct
import re
from pathlib import Path
import sys
sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
from capstone import CS_ARCH_X86, CS_MODE_64, Cs
from z3 import BitVec, BitVecVal, simplify

BUGLAND = Path(r"E:\Coding\S1mple\target\dump_out\41264\region_0000000180980000.bin")
BUGLAND_BASE = 0x180980000
TABLE_VA = 0x180C64EBD
CAP = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")

REG = ["rax","rbx","rcx","rdx","rsi","rdi","rbp","rsp",
       "r8","r9","r10","r11","r12","r13","r14","r15"]

def main():
    blob = BUGLAND.read_bytes()
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    def rd64(va): return struct.unpack_from("<Q", blob, va - BUGLAND_BASE)[0]

    index_to_body = {}
    for i in range(1612):
        t = rd64(TABLE_VA + i * 8)
        body = t
        off = t - BUGLAND_BASE
        insns = list(md.disasm(blob[off:off+0x10], t))
        if insns and insns[0].mnemonic == "jmp" and insns[0].op_str.startswith("0x"):
            body = int(insns[0].op_str, 16)
        index_to_body[i] = body

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

    # Symbolic context slots as 64-bit bitvectors, referenced by offset.
    # We track: regs[name] = z3 expr (64-bit), and a "mem" model where
    # ctx[off] is a symbolic variable.
    ctx_vars = {}  # off -> BitVec('ctx_off', 64)

    def ctx(off):
        if off not in ctx_vars:
            ctx_vars[off] = BitVec("ctx_0x%x" % off, 64)
        return ctx_vars[off]

    def analyze(body):
        off = body - BUGLAND_BASE
        code = blob[off:off + 0x70]
        insns = list(md.disasm(code, body))
        regs = {r: BitVecVal(0, 64) for r in REG}
        regs["rbp"] = BitVecVal(0x18098C884, 64)  # VM context base
        events = []  # list of (desc, slot_off) genuine cipher ops

        # Track which registers are symbolic ADDRESSES into the context.
        # We approximate: if a reg = ctx_base + constant, it's an address.
        # After mov reg,[addr] where addr=ctx_base+off, reg = ctx[off] (a value).
        # After mov reg,[addr] where addr=VIP+off (VIP loaded from ctx+0x6d), reg = word[VIP+off].
        ctx_base = 0x18098C884

        for insn in insns:
            m = insn.mnemonic
            ops = insn.op_str
            # --- mov reg, imm ---
            mm = re.match(r"^(\w+),\s*(0x[0-9a-fA-F]+|-?\d+)$", ops)
            if m == "mov" and mm and mm.group(1) in REG:
                regs[mm.group(1)] = BitVecVal(int(mm.group(2), 0) & 0xFFFFFFFFFFFFFFFF, 64)
                continue
            # --- mov reg, reg ---
            mr = re.match(r"^(\w+),\s*(\w+)$", ops)
            if m == "mov" and mr and mr.group(1) in REG and mr.group(2) in REG:
                regs[mr.group(1)] = regs[mr.group(2)]
                continue
            # --- add/sub reg, imm ---
            ai = re.match(r"^(\w+),\s*(0x[0-9a-fA-F]+|-?\d+)$", ops)
            if m in ("add","sub") and ai and ai.group(1) in REG:
                k = int(ai.group(2), 0)
                r = ai.group(1)
                regs[r] = (regs[r] + k if m == "add" else regs[r] - k)
                continue
            # --- add/sub reg, reg ---
            ar = re.match(r"^(\w+),\s*(\w+)$", ops)
            if m in ("add","sub") and ar and ar.group(1) in REG and ar.group(2) in REG:
                a, b = ar.group(1), ar.group(2)
                regs[a] = regs[a] + regs[b] if m == "add" else regs[a] - regs[b]
                continue
            # --- xor/and/or reg, reg ---
            xr = re.match(r"^(\w+),\s*(\w+)$", ops)
            if m in ("xor","and","or") and xr and xr.group(1) in REG and xr.group(2) in REG:
                a, b = xr.group(1), xr.group(2)
                if m == "xor": regs[a] = regs[a] ^ regs[b]
                elif m == "and": regs[a] = regs[a] & regs[b]
                else: regs[a] = regs[a] | regs[b]
                continue
            # --- xor/and/or reg, imm ---
            xi = re.match(r"^(\w+),\s*(0x[0-9a-fA-F]+|-?\d+)$", ops)
            if m in ("xor","and","or") and xi and xi.group(1) in REG:
                k = int(xi.group(2), 0)
                r = xi.group(1)
                if m == "xor": regs[r] = regs[r] ^ k
                elif m == "and": regs[r] = regs[r] & k
                else: regs[r] = regs[r] | k
                continue
            # --- mov reg, [reg]  (register-indirect load) ---
            dl = re.match(r"^(\w+),\s*qword ptr \[(\w+)\]$", ops)
            if m == "mov" and dl and dl.group(1) in REG and dl.group(2) in REG:
                dst, src = dl.group(1), dl.group(2)
                # src holds a symbolic address; if it's ctx_base+off, load ctx[off]
                # We approximate by simplifying the address expr to a constant if possible.
                addr = simplify(regs[src])
                try:
                    av = addr.as_long()
                    offv = av - ctx_base
                    if 0 <= offv < 0x400:
                        regs[dst] = ctx(offv)
                        continue
                except Exception:
                    pass
                # otherwise, unknown load -> fresh symbolic value
                regs[dst] = BitVec("load_%#x_%d" % (body, len(events)), 64)
                continue
            # --- mov [reg], reg (register-indirect store) ---
            st = re.match(r"^qword ptr \[(\w+)\],\s*(\w+)$", ops)
            if m == "mov" and st and st.group(1) in REG and st.group(2) in REG:
                addr = simplify(regs[st.group(1)])
                try:
                    av = addr.as_long()
                    offv = av - ctx_base
                    if 0 <= offv < 0x400:
                        events.append(("store_ctx", offv, regs[st.group(2)]))
                except Exception:
                    pass
                continue
            # --- movzx reg, word ptr [reg] ---
            wz = re.match(r"^(\w+),\s*word ptr \[(\w+)\]$", ops)
            if m in ("movzx","mov") and wz and wz.group(1) in REG and wz.group(2) in REG:
                # word read at symbolic address (VIP+off)
                addr = simplify(regs[wz.group(2)])
                try:
                    av = addr.as_long()
                    # is it in context range?
                    if ctx_base <= av < ctx_base + 0x400:
                        offv = av - ctx_base
                        events.append(("read_word_ctx", offv, None))
                except Exception:
                    pass
                continue
            # --- arithmetic on [reg] (register-indirect) ---
            ar2 = re.match(r"^(add|sub|xor|and|or)\s+(byte|word|dword|qword) ptr \[(\w+)\],\s*(\w+)$", ops)
            if ar2 and ar2.group(3) in REG:
                addr = simplify(regs[ar2.group(3)])
                try:
                    av = addr.as_long()
                    offv = av - ctx_base
                    if 0 <= offv < 0x400:
                        events.append((ar2.group(1) + "_ctx", offv, ar2.group(4)))
                except Exception:
                    pass
                continue
        return events

    print("symbolic extraction of context-slot ops per handler:")
    count = 0
    for idx in distinct:
        body = index_to_body[idx]
        ev = analyze(body)
        if ev:
            count += 1
            print("\nidx %#04x (%d) %#x:" % (idx, idx, body))
            for e in ev[:12]:
                print("  ", e)
    print("\nhandlers with extracted context-slot ops:", count, "/", len(distinct))

if __name__ == "__main__":
    main()
