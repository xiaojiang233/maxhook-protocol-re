#!/usr/bin/env python3
"""Rebuild the persistent-context Unicorn execution to walk the dispatch chain
past level 23.  Methodology from vm_dispatch_chain_extended.json:
  - single persistent unicorn instance
  - concretely execute each handler body from its entry
  - context fields mutate and carry into next handler
  - follow 'jmp reg' only if target is a valid table stub (jmp imm)

Start from level-22 exit state (from the JSON):
  vip = 0x18155c6b7, key = 0x7c2c16c7, next handler = 0x1809b6a53 (level 23)
"""
import struct
from pathlib import Path
import sys
sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
from unicorn import Uc, UC_ARCH_X86, UC_MODE_64, UC_HOOK_CODE, UcError
from unicorn.x86_const import *

BUGLAND = Path(r"E:\Coding\S1mple\target\dump_out\41264\region_0000000180980000.bin")
BUGLAND_BASE = 0x180980000
TABLE_VA = 0x180C64EBD
CTX_BASE = 0x18098C884

def main():
    blob = BUGLAND.read_bytes()
    def rd64(va): return struct.unpack_from("<Q", blob, va - BUGLAND_BASE)[0]

    # build index -> target and target -> index maps
    index_to_target = {}
    target_to_index = {}
    for i in range(1612):
        t = rd64(TABLE_VA + i * 8)
        index_to_target[i] = t
        target_to_index.setdefault(t, []).append(i)

    # valid stubs: target that decodes to 'jmp imm'
    from capstone import CS_ARCH_X86, CS_MODE_64, Cs
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    def is_stub(va):
        off = va - BUGLAND_BASE
        if not (0 <= off < len(blob)):
            return False
        insns = list(md.disasm(blob[off:off+0x10], va))
        return insns and insns[0].mnemonic == "jmp"

    # Set up unicorn
    uc = Uc(UC_ARCH_X86, UC_MODE_64)
    # map bugland (0x180980000 .. + len)
    size = (len(blob) + 0xFFF) & ~0xFFF
    uc.mem_map(BUGLAND_BASE, size)
    uc.mem_write(BUGLAND_BASE, blob)
    # map a stack
    STACK = 0x7FF000000000
    uc.mem_map(STACK, 0x100000)
    uc.reg_write(UC_X86_REG_RSP, STACK + 0x80000)

    # Initialize context (768B) — use the dump's context at CTX_BASE (idle state),
    # but we'll patch the flag +0x162 = 0xC3 (steady state, round 131).
    ctx_off = CTX_BASE - BUGLAND_BASE
    ctx = bytearray(blob[ctx_off:ctx_off+768])
    ctx[0x162] = 0xC3  # correct steady-state flag
    uc.mem_write(CTX_BASE, bytes(ctx))

    # Set rbp = context base
    uc.reg_write(UC_X86_REG_RBP, CTX_BASE)

    # Start at level 23 handler
    vip = 0x18155c6b7
    key = 0x7c2c16c7
    handler = 0x1809b6a53

    # Track the dispatch: after executing handler, find the jmp reg whose target
    # is a valid stub.
    state = {"steps": 0, "last_jmp_target": None}

    def on_code(uc_, address, size_, user):
        # read the instruction; if jmp reg, record the register target
        code = uc_.mem_read(address, min(size_, 15))
        insns = list(md.disasm(code, address))
        if insns:
            insn = insns[0]
            if insn.mnemonic == "jmp" and insn.op_str in REGS:
                reg = REGS[insn.op_str]
                state["last_jmp_target"] = uc_.reg_read(reg)
                # stop execution here
                uc_.emu_stop()

    REGS = {
        "rax": UC_X86_REG_RAX, "rbx": UC_X86_REG_RBX, "rcx": UC_X86_REG_RCX,
        "rdx": UC_X86_REG_RDX, "rsi": UC_X86_REG_RSI, "rdi": UC_X86_REG_RDI,
        "r8": UC_X86_REG_R8, "r9": UC_X86_REG_R9, "r10": UC_X86_REG_R10,
        "r11": UC_X86_REG_R11, "r12": UC_X86_REG_R12, "r13": UC_X86_REG_R13,
        "r14": UC_X86_REG_R14, "r15": UC_X86_REG_R15,
    }

    uc.hook_add(UC_HOOK_CODE, on_code)

    print("walking dispatch chain from level 23 (handler %#x, vip %#x, key %#x)..."
          % (handler, vip, key))

    # Execute handler, catch the jmp reg dispatch
    chain = []
    for step in range(40):
        state["last_jmp_target"] = None
        # write VIP into context+0x6d so handler reads it
        uc.mem_write(CTX_BASE + 0x6d, struct.pack("<Q", vip))
        # write key into context+0xa
        uc.mem_write(CTX_BASE + 0xa, struct.pack("<Q", key))
        try:
            uc.emu_start(handler, 0, timeout=2_000_000, count=5000)
        except UcError as e:
            print("  step %d: UcError %s" % (step, e))
            break
        tgt = state["last_jmp_target"]
        if tgt is None:
            print("  step %d: no jmp reg found (handler %#x)" % (step, handler))
            break
        # is tgt a valid stub?
        if is_stub(tgt):
            idx = target_to_index.get(tgt, [None])[0]
            chain.append((step, handler, vip, key, tgt, idx))
            print("  step %d: handler %#x -> target %#x (idx %#x)" % (step, handler, tgt, idx))
            # compute next handler = the jmp imm target of the stub
            stub_off = tgt - BUGLAND_BASE
            stub_insns = list(md.disasm(blob[stub_off:stub_off+0x10], tgt))
            if stub_insns and stub_insns[0].mnemonic == "jmp" and stub_insns[0].op_str.startswith("0x"):
                handler = int(stub_insns[0].op_str, 16)
            # advance VIP and key: read from context after execution
            vip = struct.unpack("<Q", uc.mem_read(CTX_BASE + 0x6d, 8))[0]
            key = struct.unpack("<Q", uc.mem_read(CTX_BASE + 0xa, 8))[0]
        else:
            print("  step %d: jmp target %#x NOT a valid stub (divergence)" % (step, tgt))
            break

    print("\nwalked %d steps past level 23" % len(chain))

if __name__ == "__main__":
    main()
