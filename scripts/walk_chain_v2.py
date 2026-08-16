#!/usr/bin/env python3
"""Rebuild the persistent-context Unicorn walker with the EXACT proven parameters.

Setup (from maxhook_vm_initial_chain.json + vm_dispatch_chain_extended.json):
  bugland = runtime_bugland2.bin (sha256 3a8e093a...)
  handler table = 0x180C64EBD
  context base = 0x18098C884
  initial VIP = 0x181555629, initial key = 0xffffffa5, flag = 0x69

Method: single persistent Unicorn instance, execute each handler body from entry,
context mutations carry forward. After each handler, the dispatch is 'jmp reg'
whose target decodes to a valid 'jmp imm' stub. Follow the stub to next handler.
Read back VIP + key from context after each handler.

Levels 1-4 are proven statically (milestone 17); we verify them, then continue.
"""
import struct
from pathlib import Path
import sys
sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
from unicorn import Uc, UC_ARCH_X86, UC_MODE_64, UC_HOOK_CODE, UcError
from unicorn.x86_const import *
from capstone import CS_ARCH_X86, CS_MODE_64, Cs

BUGLAND = Path(r"E:\Coding\S1mple\target\runtime_bugland2.bin")
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
    print("bugland size:", hex(len(blob)))
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    def rd64(va): return struct.unpack_from("<Q", blob, va - BUGLAND_BASE)[0]
    def rd16(va): return struct.unpack_from("<H", blob, va - BUGLAND_BASE)[0]

    index_to_target = {}
    target_to_index = {}
    for i in range(1612):
        t = rd64(TABLE_VA + i * 8)
        index_to_target[i] = t
        target_to_index.setdefault(t, []).append(i)

    def is_stub(va):
        off = va - BUGLAND_BASE
        if not (0 <= off < len(blob) - 2):
            return False
        insns = list(md.disasm(blob[off:off+0x10], va))
        return bool(insns) and insns[0].mnemonic == "jmp" and insns[0].op_str.startswith("0x")

    def stub_target(va):
        off = va - BUGLAND_BASE
        insns = list(md.disasm(blob[off:off+0x10], va))
        if insns and insns[0].mnemonic == "jmp" and insns[0].op_str.startswith("0x"):
            return int(insns[0].op_str, 16)
        return None

    # Unicorn setup
    uc = Uc(UC_ARCH_X86, UC_MODE_64)
    # Map the FULL DLL image first (includes .bugland + .data/.text).
    import pefile
    dll_path = Path(r"E:\Coding\S1mple\target\MaxHook.runtime-unpacked.dll")
    pe = pefile.PE(str(dll_path))
    dll_raw = dll_path.read_bytes()
    image_size = (pe.OPTIONAL_HEADER.SizeOfImage + 0xFFF) & ~0xFFF
    uc.mem_map(0x180000000, image_size)
    uc.mem_write(0x180000000, dll_raw[:pe.OPTIONAL_HEADER.SizeOfHeaders])
    for section in pe.sections:
        data = section.get_data()
        if data:
            uc.mem_write(0x180000000 + section.VirtualAddress, data)
    # Overlay the decrypted bugland (runtime_bugland2.bin) over the on-disk form.
    uc.mem_write(BUGLAND_BASE, blob)
    STACK = 0x7FF000000000
    uc.mem_map(STACK, 0x100000)
    uc.reg_write(UC_X86_REG_RSP, STACK + 0x80000)
    uc.reg_write(UC_X86_REG_RBP, CTX_BASE)

    # Map kernel32 import region (step 76+ writes to 0x7ff844477064 = kernel32 IAT)
    import os
    kernel32_base = 0x7FF844420000
    kernel32_path = Path(os.environ["WINDIR"]) / "System32" / "kernel32.dll"
    kdata = kernel32_path.read_bytes()
    uc.mem_map(kernel32_base, (len(kdata) + 0xFFF) & ~0xFFF)
    uc.mem_write(kernel32_base, kdata)

    # context from the blob at CTX_BASE (768 bytes, initial state)
    ctx_off = CTX_BASE - BUGLAND_BASE
    ctx = bytearray(blob[ctx_off:ctx_off+768])
    uc.mem_write(CTX_BASE, bytes(ctx))

    state = {"last_jmp": None}
    def on_code(uc_, address, size_, user):
        code = uc_.mem_read(address, min(size_, 15))
        insns = list(md.disasm(code, address))
        if insns and insns[0].mnemonic == "jmp" and insns[0].op_str in REGS:
            state["last_jmp"] = uc_.reg_read(REGS[insns[0].op_str])
            uc_.emu_stop()
    uc.hook_add(UC_HOOK_CODE, on_code)

    # Start: level 1 dispatcher reads word[VIP+0] unkeyed.  But milestone 17 said
    # the dispatcher is 0x180a97f70, and handler body for level 1 is 0x1809f4736.
    # Let's start executing at the FIRST handler body 0x1809f4736 with VIP=0x1815631ee
    # (vip_after of dispatch 1).  Actually, dispatch 1's target 0x1809ac48d is the
    # stub, which jmps to 0x1809f4736.  So we start at 0x1809f4736.
    handler = 0x1809f4736
    vip = 0x1815631ee  # vip after dispatch 1 (from initial_chain.json)
    key = 0xffffffa5

    chain = []
    for step in range(200):
        state["last_jmp"] = None
        uc.mem_write(CTX_BASE + 0x6d, struct.pack("<Q", vip))
        uc.mem_write(CTX_BASE + 0xa, struct.pack("<I", key & 0xffffffff))
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
            vip = struct.unpack("<Q", uc.mem_read(CTX_BASE + 0x6d, 8))[0]
            key = struct.unpack("<I", uc.mem_read(CTX_BASE + 0xa, 4))[0]
        else:
            print("step %d: jmp %#x not a stub (divergence at %#x)" % (step, tgt, handler))
            break

    print("\nwalked %d steps" % len(chain))
    import json
    Path(r"E:\Coding\S1mple\target\chain_walk_v2.json").write_text(
        json.dumps(chain, indent=1) + "\n")

if __name__ == "__main__":
    main()
