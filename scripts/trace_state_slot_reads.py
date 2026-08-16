#!/usr/bin/env python3
"""Trace the walker's context state at the keystream-loop entry (step ~169-200)
to determine WHERE the key/nonce should be seeded.

The walker produces zero keystream because the key/nonce state is zeroed.  Let
me find which context slots the keystream loop READS (the fold inputs) and check
if they're zero (needing key/nonce seed) or non-zero (already correct)."""
import struct
from pathlib import Path
import sys
sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
from unicorn import Uc, UC_ARCH_X86, UC_MODE_64, UC_HOOK_CODE, UC_HOOK_MEM_READ, UcError
from unicorn.x86_const import *
from capstone import CS_ARCH_X86, CS_MODE_64, Cs
import pefile

BUGLAND = Path(r"E:\Coding\S1mple\target\runtime_bugland2.bin")
BUGLAND_BASE = 0x180980000
TABLE_VA = 0x180C64EBD
CTX_BASE = 0x18098C884
STORE32 = 0x18041A860

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

    uc = Uc(UC_ARCH_X86, UC_MODE_64)
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
    uc.mem_write(BUGLAND_BASE, blob)
    STACK = 0x7FF000000000
    uc.mem_map(STACK, 0x100000)
    uc.reg_write(UC_X86_REG_RSP, STACK + 0x80000)
    uc.reg_write(UC_X86_REG_RBP, CTX_BASE)
    import os
    kernel32_base = 0x7FF844420000
    kernel32_path = Path(os.environ["WINDIR"]) / "System32" / "kernel32.dll"
    kdata = kernel32_path.read_bytes()
    uc.mem_map(kernel32_base, (len(kdata) + 0xFFF) & ~0xFFF)
    uc.mem_write(kernel32_base, kdata)
    uc.mem_map(0x20000000000, 0x1000000)
    teb = 0x7FFDE00000
    uc.mem_map(teb, 0x10000)
    uc.reg_write(UC_X86_REG_GS_BASE, teb)
    uc.mem_write(teb + 0x30, struct.pack("<Q", teb))
    peb = 0x7FFDE10000
    uc.mem_map(peb, 0x10000)
    uc.mem_write(teb + 0x58, struct.pack("<Q", peb))
    uc.mem_write(peb + 0x10, struct.pack("<Q", 0x180000000))
    peb_scratch = 0x7FFDE20000
    uc.mem_map(peb_scratch, 0x10000)
    for off in (0x118, 0x128, 0x158, 0x168, 0x178):
        uc.mem_write(peb + off, struct.pack("<Q", peb_scratch + off))

    ctx_off = CTX_BASE - BUGLAND_BASE
    ctx = bytearray(blob[ctx_off:ctx_off+768])
    uc.mem_write(CTX_BASE, bytes(ctx))

    state = {"last_jmp": None, "reads": []}
    def on_code(uc_, address, size_, user):
        code = uc_.mem_read(address, min(size_, 15))
        insns = list(md.disasm(code, address))
        if insns and insns[0].mnemonic == "jmp" and insns[0].op_str in REGS:
            state["last_jmp"] = uc_.reg_read(REGS[insns[0].op_str])
            uc_.emu_stop()
    def on_read(uc_, access, address, size_, value, user):
        # record reads from context slots +0x180..+0x2db (key-schedule state)
        if CTX_BASE + 0x180 <= address < CTX_BASE + 0x2e0:
            state["reads"].append(address - CTX_BASE)
    uc.hook_add(UC_HOOK_CODE, on_code)
    uc.hook_add(UC_HOOK_MEM_READ, on_read)

    handler = 0x1809f4736
    vip = 0x1815631ee
    key = 0xffffffa5
    for step in range(400):
        state["last_jmp"] = None
        uc.mem_write(CTX_BASE + 0x6d, struct.pack("<Q", vip))
        uc.mem_write(CTX_BASE + 0xa, struct.pack("<I", key & 0xffffffff))
        try:
            uc.emu_start(handler, 0, timeout=2_000_000, count=20000)
        except UcError:
            pass
        tgt = state["last_jmp"]
        if tgt is None:
            break
        if is_stub(tgt):
            handler = stub_target(tgt)
            vip = struct.unpack("<Q", uc.mem_read(CTX_BASE + 0x6d, 8))[0]
            key = struct.unpack("<I", uc.mem_read(CTX_BASE + 0xa, 4))[0]
        else:
            break

    # report which state slots were read (the fold inputs)
    from collections import Counter
    c = Counter(state["reads"])
    print("state slots (0x180..0x2db) read during execution (fold inputs):")
    for off, cnt in c.most_common(30):
        print("  +0x%03x: %d reads" % (off, cnt))

if __name__ == "__main__":
    main()
