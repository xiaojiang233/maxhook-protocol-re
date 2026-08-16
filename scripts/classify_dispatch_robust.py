#!/usr/bin/env python3
"""Robust dispatch-layout classifier using register dataflow tracking.

For each handler body, symbolically track which register holds VIP+offset, then
find:
  - idx read:  movzx/mov reg, word ptr [VIP_reg]  (the table index)
  - adv read:  movsxd reg, dword ptr [VIP_reg]    (the signed advance)
  - key read:  (keyed handlers) movzx reg, word ptr [VIP_reg] used in key fold

Approach: single-pass over the handler body's instructions, tracking register
values as symbolic expressions like "vip", "vip+4", "ctx+0x6d", etc.
"""
import struct
import re
from pathlib import Path
import sys
sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
from capstone import CS_ARCH_X86, CS_MODE_64, Cs

BUGLAND = Path(r"E:\Coding\S1mple\target\dump_out\41264\region_0000000180980000.bin")
BUGLAND_BASE = 0x180980000

REG64 = ["rax","rbx","rcx","rdx","rsi","rdi","rbp","rsp","r8","r9","r10","r11","r12","r13","r14","r15"]
REG32 = ["eax","ebx","ecx","edx","esi","edi","ebp","esp","r8d","r9d","r10d","r11d","r12d","r13d","r14d","r15d"]
REG16 = ["ax","bx","cx","dx","si","di","bp","sp","r8w","r9w","r10w","r11w","r12w","r13w","r14w","r15w"]
REG8  = ["al","bl","cl","dl","sil","dil","bpl","spl","r8b","r9b","r10b","r11b","r12b","r13b","r14b","r15b"]

def reg_base(name):
    for r in REG64:
        if name == r: return r, 64
    for r in REG32:
        if name == r: return REG64[REG32.index(r)], 32
    for r in REG16:
        if name == r: return REG64[REG16.index(r)], 16
    for r in REG8:
        if name == r: return REG64[REG8.index(r)], 8
    return name, 64

def main():
    blob = BUGLAND.read_bytes()
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    md.detail = True

    import json
    trace = json.loads(Path(r"E:\Coding\S1mple\target\vm_handler_execution_trace.json").read_text("utf-8"))
    targets = sorted({int(t["target"], 16) for t in trace})

    layouts = {}
    for tgt in targets:
        off = tgt - BUGLAND_BASE
        if not (0 <= off < len(blob) - 0x80):
            continue
        code = blob[off:off + 0x80]
        insns = list(md.disasm(code, tgt))

        # symbolic registers: name -> ("vip", offset) or ("ctx", slot) or None
        regs = {}
        idx_off = adv_off = key_off = None

        for insn in insns:
            m = insn.mnemonic
            ops = insn.op_str
            # Track: mov reg, [rbp+0x6d] -> reg = "vip"
            mm = re.match(r"^(\w+),\s*qword ptr \[rbp \+ (0x[0-9a-fA-F]+|\d+)\]$", ops)
            if m == "mov" and mm:
                dst = reg_base(mm.group(1))[0]
                slot = int(mm.group(2), 0)
                if slot == 0x6d:
                    regs[dst] = ("vip", 0)
                continue
            # add reg, K  -> if reg is vip, offset += K
            am = re.match(r"^(\w+),\s*(0x[0-9a-fA-F]+|\d+)$", ops)
            if m in ("add", "sub") and am:
                dst = reg_base(am.group(1))[0]
                k = int(am.group(2), 0)
                if dst in regs and regs[dst] and regs[dst][0] == "vip":
                    _, offv = regs[dst]
                    regs[dst] = ("vip", offv + k if m == "add" else offv - k)
                continue
            # movzx/mov reg, word ptr [vip_reg] -> idx read at offset
            wm = re.match(r"^(\w+),\s*word ptr \[(\w+)\]$", ops)
            if m in ("movzx", "mov") and wm:
                dst = reg_base(wm.group(1))[0]
                src = wm.group(2)
                if src in regs and regs[src] and regs[src][0] == "vip":
                    if idx_off is None:
                        idx_off = regs[src][1]
                continue
            # movsxd/mov reg, dword ptr [vip_reg] -> advance read
            dm = re.match(r"^(\w+),\s*dword ptr \[(\w+)\]$", ops)
            if m in ("movsxd", "mov") and dm:
                src = dm.group(2)
                if src in regs and regs[src] and regs[src][0] == "vip":
                    if adv_off is None:
                        adv_off = regs[src][1]
                continue

        layouts[tgt] = (idx_off, adv_off)

    # summarize
    from collections import Counter
    c = Counter()
    classified = 0
    for tgt, (io, ao) in layouts.items():
        if io is not None or ao is not None:
            classified += 1
            c[(io, ao)] += 1
    print("classified %d/%d handlers (non-None idx or adv)" % (classified, len(layouts)))
    print("\n(idx_off, adv_off) distribution:")
    for (io, ao), n in c.most_common(30):
        print("  (idx=%s, adv=%s): %d" % (io, ao, n))

    out = Path(r"E:\Coding\S1mple\target\dispatch_layouts2.json")
    out.write_text(json.dumps({hex(k): list(v) for k, v in layouts.items()}, indent=1) + "\n")
    print("\nwrote", out.resolve())

if __name__ == "__main__":
    main()
