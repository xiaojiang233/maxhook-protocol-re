#!/usr/bin/env python3
"""Mini symbolic executor to extract context-slot/VIP-offset arithmetic from
each key-schedule handler.

Tracks registers as symbolic expressions:
  ("const", n)      - constant
  ("ctx", off)      - VM context base + off (rbp + off)
  ("vip", off)      - VIP value + off (word[VIP+off] index)
  ("mem_ctx", off)  - value loaded from context slot off
  ("mem_vip", off)  - 16-bit word at VIP+off

Then identifies genuine arithmetic on context slots (the cipher ops).
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

REG = ["rax","rbx","rcx","rdx","rsi","rdi","rbp","rsp",
       "r8","r9","r10","r11","r12","r13","r14","r15"]
REG8 = ["al","bl","cl","dl","sil","dil","bpl","spl","r8b","r9b","r10b","r11b","r12b","r13b","r14b","r15b"]
REG16 = ["ax","bx","cx","dx","si","di","bp","sp","r8w","r9w","r10w","r11w","r12w","r13w","r14w","r15w"]
REG32 = ["eax","ebx","ecx","edx","esi","edi","ebp","esp","r8d","r9d","r10d","r11d","r12d","r13d","r14d","r15d"]

def reg64(name):
    if name in REG: return name
    if name in REG32: return REG[REG32.index(name)]
    if name in REG16: return REG[REG16.index(name)]
    if name in REG8: return REG[REG8.index(name)]
    return name

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

    def analyze(body):
        off = body - BUGLAND_BASE
        code = blob[off:off + 0x70]
        insns = list(md.disasm(code, body))
        regs = {}  # name -> ("const",v) | ("ctx",off) | ("vip",off) | ("mem",kind,off)
        events = []  # genuine cipher ops: (mnemonic, desc, slot_off, const)
        for insn in insns:
            m = insn.mnemonic
            ops = insn.op_str
            # mov reg, rbp  -> ctx base
            if m == "mov" and ops in ("reg, rbp",):
                pass
            # general: handle mov reg, imm
            mm = re.match(r"^(\w+),\s*(0x[0-9a-fA-F]+|-?\d+)$", ops)
            if m == "mov" and mm:
                dst = reg64(mm.group(1))
                regs[dst] = ("const", int(mm.group(2), 0))
                continue
            # mov reg, reg
            mr = re.match(r"^(\w+),\s*(\w+)$", ops)
            if m == "mov" and mr:
                dst = reg64(mr.group(1)); src = reg64(mr.group(2))
                if src in regs:
                    regs[dst] = regs[src]
                continue
            # add/sub reg, imm (constant offset)
            ai = re.match(r"^(\w+),\s*(0x[0-9a-fA-F]+|-?\d+)$", ops)
            if m in ("add","sub") and ai:
                dst = reg64(ai.group(1))
                k = int(ai.group(2), 0)
                if dst in regs and regs[dst][0] in ("ctx","vip","mem"):
                    kind, offv = regs[dst][0], regs[dst][1]
                    nv = offv + k if m == "add" else offv - k
                    regs[dst] = (kind, nv)
                continue
            # mov reg, [reg]  (dereference: ctx+off -> VIP, or VIP+off -> word)
            mderef = re.match(r"^(\w+),\s*qword ptr \[(\w+)\]$", ops)
            if m == "mov" and mderef:
                dst = reg64(mderef.group(1)); src = reg64(mderef.group(2))
                if src in regs:
                    kind, offv = regs[src]
                    if kind == "ctx":
                        # loading [ctx+off] = context slot value (e.g. VIP at 0x6d)
                        regs[dst] = ("mem", "ctx", offv)
                    elif kind == "vip":
                        regs[dst] = ("mem", "vip", offv)
                continue
            # movzx reg, word ptr [reg]  (16-bit read at VIP+off = bytecode word)
            mz = re.match(r"^(\w+),\s*word ptr \[(\w+)\]$", ops)
            if m in ("movzx","mov") and mz:
                dst = reg64(mz.group(1)); src = reg64(mz.group(2))
                if src in regs and regs[src][0] == "vip":
                    events.append(("read_word", "word[VIP+%d]" % regs[src][1], regs[src][1], None))
                    regs[dst] = ("mem", "vip", regs[src][1])
                continue
            # arithmetic on context slots: op [ctx+off], reg / imm
            # mov/add/sub/xor/and/or with 'ptr [reg]' where reg = ctx+off
            pm = re.match(r"^(add|sub|xor|and|or|mov)\s+(\w+) ptr \[(\w+)\],\s*(.+)$", ops)
            if pm:
                op = pm.group(1); sz = pm.group(2); src = reg64(pm.group(3)); rhs = pm.group(4)
                if src in regs and regs[src][0] == "ctx":
                    events.append((op, "%s [ctx+0x%x], %s" % (op, regs[src][1], rhs), regs[src][1], None))
                continue
        return events

    print("symbolic extraction of cipher ops per handler:")
    count = 0
    for idx in distinct:
        body = index_to_body[idx]
        ev = analyze(body)
        if ev:
            count += 1
            print("\nidx %#04x (%d) %#x:" % (idx, idx, body))
            for e in ev[:10]:
                print("  %s" % (e,))
    print("\nhandlers with extracted cipher ops:", count, "/", len(distinct))

if __name__ == "__main__":
    main()
