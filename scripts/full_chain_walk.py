#!/usr/bin/env python3
"""Full persistent-context chain walk from level 1.

Methodology (from milestone 17 + vm_dispatch_chain_extended.json):
  - initial context: key=0xffffffa5, VIP=0x180d2879b (from dump), flag=0x69
  - execute each handler body under a single persistent unicorn instance
  - after each handler, the dispatch is a 'jmp reg' whose target must decode
    to a valid 'jmp imm' stub (the table stub)
  - follow the stub's jmp to the next handler body
  - VIP and key are read back from context after execution

The handlers are the ARX loop + key-schedule; we walk until we loop back to a
seen state (the key-schedule completes and enters the keystream loop).
"""
import struct
from pathlib import Path
import sys
sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
from unicorn import Uc, UC_ARCH_X86, UC_MODE_64, UC_HOOK_CODE, UcError
from unicorn.x86_const import *
from capstone import CS_ARCH_X86, CS_MODE_64, Cs

BUGLAND = Path(r"E:\Coding\S1mple\target\dump_out\41264\region_0000000180980000.bin")
BUGLAND_BASE = 0x180980000
TABLE_VA = 0x180C64EBD
CTX_BASE = 0x18098C884

REGS = {
    "rax": UC_X86_REG_RAX, "rbx": UC_X86_REG_RBX, "rcx": UC_X86_REG_RCX,
    "rdx": UC_X86_REG_RDX, "rsi": UC_X86_REG_RSI, "rdi": UC_X86_REG_RDI,
    "r8": UC_X86_REG_R8, "r9": UC_X86_REG_R9, "r10": UC_X86_REG_R10,
    "r11": UC_X86_REG_R11, "r12": UC_X86_REG_R12, "r13": UC_X86_REG_R13,
    "r14": UC_X86_REG_R14, "r15": UC_X86_REG_R15,
}

def main():
    blob = BUGLAND.read_bytes()
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    def rd64(va): return struct.unpack_from("<Q", blob, va - BUGLAND_BASE)[0]

    index_to_target = {}
    target_to_index = {}
    for i in range(1612):
        t = rd64(TABLE_VA + i * 8)
        index_to_target[i] = t
        target_to_index.setdefault(t, []).append(i)

    def is_stub(va):
        off = va - BUGLAND_BASE
        if not (0 <= off < len(blob)):
            return False
        insns = list(md.disasm(blob[off:off+0x10], va))
        return bool(insns) and insns[0].mnemonic == "jmp" and insns[0].op_str.startswith("0x")

    def stub_target(va):
        off = va - BUGLAND_BASE
        insns = list(md.disasm(blob[off:off+0x10], va))
        if insns and insns[0].mnemonic == "jmp" and insns[0].op_str.startswith("0x"):
            return int(insns[0].op_str, 16)
        return None

    # unicorn setup
    uc = Uc(UC_ARCH_X86, UC_MODE_64)
    size = (len(blob) + 0xFFF) & ~0xFFF
    uc.mem_map(BUGLAND_BASE, size)
    uc.mem_write(BUGLAND_BASE, blob)
    STACK = 0x7FF000000000
    uc.mem_map(STACK, 0x100000)
    uc.reg_write(UC_X86_REG_RSP, STACK + 0x80000)

    # initial context from dump
    ctx_off = CTX_BASE - BUGLAND_BASE
    ctx = bytearray(blob[ctx_off:ctx_off+768])
    uc.mem_write(CTX_BASE, bytes(ctx))
    uc.reg_write(UC_X86_REG_RBP, CTX_BASE)

    # initial VIP and key (from dump)
    vip = struct.unpack("<Q", ctx[0x6d:0x75])[0]
    key = struct.unpack("<I", ctx[0xa:0xe])[0]  # dword 0xffffffa5
    print("initial VIP=%#x key=%#x flag=%#x" % (vip, key & 0xffffffff, ctx[0x162]))

    # Start: milestone 17 proved first dispatch: index = word[VIP] (unkeyed),
    # target = table[index], handler = stub_target(target)
    # first_index = 0x147, first_advance = 0xDBC5, first_target = 0x1809ac48d
    state = {"last_jmp": None}

    def on_code(uc_, address, size_, user):
        code = uc_.mem_read(address, min(size_, 15))
        insns = list(md.disasm(code, address))
        if insns:
            insn = insns[0]
            if insn.mnemonic == "jmp" and insn.op_str in REGS:
                state["last_jmp"] = uc_.reg_read(REGS[insn.op_str])
                uc_.emu_stop()

    uc.hook_add(UC_HOOK_CODE, on_code)

    # Walk: start from the proven level-1 handler. Actually, let me use the
    # proven chain's handler sequence to drive the execution.
    # Level 1 handler body = 0x1809f4736 (after stub 0x1809ac48d)
    handler = 0x1809f4736
    chain = []
    for step in range(60):
        state["last_jmp"] = None
        # sync context VIP + key
        uc.mem_write(CTX_BASE + 0x6d, struct.pack("<Q", vip))
        uc.mem_write(CTX_BASE + 0xa, struct.pack("<Q", key))
        try:
            uc.emu_start(handler, 0, timeout=2_000_000, count=20000)
        except UcError as e:
            print("step %d: UcError %s (handler %#x)" % (step, e, handler))
            break
        tgt = state["last_jmp"]
        if tgt is None:
            print("step %d: no jmp (handler %#x)" % (step, handler))
            break
        if is_stub(tgt):
            idx = target_to_index.get(tgt, [None])[0]
            nxt = stub_target(tgt)
            chain.append((step, handler, vip, key & 0xffffffff, idx))
            print("step %2d: %#x -> idx %#x -> %#x (key=%#x)" % (
                step, handler, idx, nxt, key & 0xffffffff))
            handler = nxt
            # read back VIP + key from context (handler mutated them)
            vip = struct.unpack("<Q", uc.mem_read(CTX_BASE + 0x6d, 8))[0]
            key = struct.unpack("<Q", uc.mem_read(CTX_BASE + 0xa, 8))[0]
        else:
            print("step %d: jmp %#x not a stub (divergence at %#x)" % (step, tgt, handler))
            break

    print("\nwalked %d steps" % len(chain))
    import json
    Path(r"E:\Coding\S1mple\target\chain_walk_rebuilt.json").write_text(
        json.dumps(chain, indent=1) + "\n")

if __name__ == "__main__":
    main()
