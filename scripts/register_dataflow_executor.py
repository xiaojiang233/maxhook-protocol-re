#!/usr/bin/env python3
"""Register-dataflow symbolic interpreter for a key-schedule handler.

Tracks registers as symbolic expressions (z3) through the handler's instructions,
following the Themida multi-step register-indirect addressing (mov r13,rbp;
add r13,0x6d; mov r13,[r13]; ...).  Records context-slot reads/writes to extract
the genuine ARX semantics.

This is the proper tool that round 244 identified as needed: not regex, but
register dataflow tracking.

For each handler, we:
  1. Symbolize the context slots (ctx[off] = symbolic 64-bit).
  2. Track registers as expressions.
  3. Handle: mov/add/sub/xor/and/or (reg/imm), indirect load/store [reg],
     word/byte access, push/pop (stack).
  4. Record writes to ctx slots (the ARX output) as expressions over ctx inputs.
"""
from __future__ import annotations
import struct
from pathlib import Path
import sys
sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
from capstone import CS_ARCH_X86, CS_MODE_64, Cs
from capstone.x86_const import X86_OP_IMM, X86_OP_REG, X86_OP_MEM, X86_REG_RIP
from z3 import BitVec, BitVecVal, simplify, is_bv_value

BUGLAND = Path(r"E:\Coding\S1mple\target\runtime_bugland2.bin")
BUG = 0x180980000
CTX = 0x18098C884

REG64 = ["rax","rbx","rcx","rdx","rsi","rdi","rbp","rsp",
         "r8","r9","r10","r11","r12","r13","r14","r15"]

def main():
    blob = BUGLAND.read_bytes()
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    md.detail = True

    HANDLER = 0x18099089E  # chain A body (slot swap)

    def analyze(addr, max_insn=120):
        regs = {r: BitVecVal(0, 64) for r in REG64}
        regs["rbp"] = BitVecVal(CTX, 64)
        regs["rsp"] = BitVecVal(0x7FFE000000, 64)
        # symbolic context slots
        ctx_syms = {}
        def ctx(off):
            if off not in ctx_syms:
                ctx_syms[off] = BitVec("ctx_%03x" % off, 64)
            return ctx_syms[off]
        # memory model: track [reg] loads as expressions when reg is ctx+off
        writes = []  # (slot_off, expr) genuine ctx writes

        off = addr - BUG
        code = blob[off:off+0x200]
        insns = list(md.disasm(code, addr))

        def eval_addr(reg):
            e = simplify(regs[reg])
            return e

        def get_mem_expr(reg_expr, size):
            # reg_expr = ctx + off -> ctx[off]
            try:
                v = reg_expr.as_long()
                offv = v - CTX
                if 0 <= offv < 0x400:
                    return ctx(offv)
            except Exception:
                pass
            return None

        for insn in insns[:max_insn]:
            m = insn.mnemonic
            op = insn.op_str
            ops = insn.operands

            # mov reg, imm
            if m == "mov" and len(ops) == 2 and ops[1].type == X86_OP_IMM and ops[0].type == X86_OP_REG:
                r = insn.reg_name(ops[0].reg)
                if r in REG64:
                    regs[r] = BitVecVal(ops[1].imm & 0xFFFFFFFFFFFFFFFF, 64)
                continue
            # mov reg, reg
            if m == "mov" and len(ops) == 2 and ops[0].type == X86_OP_REG and ops[1].type == X86_OP_REG:
                r1 = insn.reg_name(ops[0].reg); r2 = insn.reg_name(ops[1].reg)
                if r1 in REG64 and r2 in REG64:
                    regs[r1] = regs[r2]
                continue
            # add/sub reg, imm
            if m in ("add","sub") and len(ops) == 2 and ops[1].type == X86_OP_IMM and ops[0].type == X86_OP_REG:
                r = insn.reg_name(ops[0].reg)
                if r in REG64:
                    k = ops[1].imm & 0xFFFFFFFFFFFFFFFF
                    regs[r] = regs[r] + k if m == "add" else regs[r] - k
                continue
            # add/sub reg, reg
            if m in ("add","sub") and len(ops) == 2 and ops[0].type == X86_OP_REG and ops[1].type == X86_OP_REG:
                r1 = insn.reg_name(ops[0].reg); r2 = insn.reg_name(ops[1].reg)
                if r1 in REG64 and r2 in REG64:
                    regs[r1] = regs[r1] + regs[r2] if m == "add" else regs[r1] - regs[r2]
                continue
            # xor/and/or reg, imm
            if m in ("xor","and","or") and len(ops) == 2 and ops[1].type == X86_OP_IMM and ops[0].type == X86_OP_REG:
                r = insn.reg_name(ops[0].reg)
                if r in REG64:
                    k = ops[1].imm & 0xFFFFFFFFFFFFFFFF
                    if m == "xor": regs[r] = regs[r] ^ k
                    elif m == "and": regs[r] = regs[r] & k
                    else: regs[r] = regs[r] | k
                continue
            # mov reg, [reg]  (indirect load)
            if m == "mov" and len(ops) == 2 and ops[0].type == X86_OP_REG and ops[1].type == X86_OP_MEM:
                r = insn.reg_name(ops[0].reg)
                mem = ops[1].mem
                if mem.base and insn.reg_name(mem.base) in REG64:
                    be = eval_addr(insn.reg_name(mem.base))
                    v = get_mem_expr(be, mem.disp)
                    if v is not None and r in REG64:
                        regs[r] = v
                continue
            # mov [reg], reg  (indirect store -> ctx write)
            if m == "mov" and len(ops) == 2 and ops[0].type == X86_OP_MEM and ops[1].type == X86_OP_REG:
                mem = ops[0].mem
                if mem.base and insn.reg_name(mem.base) in REG64:
                    be = eval_addr(insn.reg_name(mem.base))
                    try:
                        v = be.as_long()
                        offv = v - CTX
                        if 0 <= offv < 0x400:
                            r2 = insn.reg_name(ops[1].reg)
                            if r2 in REG64:
                                writes.append((offv, regs[r2]))
                    except Exception:
                        pass
                continue

        return ctx_syms, writes

    ctx_syms, writes = analyze(HANDLER)
    print("handler %#x: %d ctx writes" % (HANDLER, len(writes)))
    for offv, expr in writes:
        print("  ctx+%03x = %s" % (offv, simplify(expr)))

if __name__ == "__main__":
    main()
