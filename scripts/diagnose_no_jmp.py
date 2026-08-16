#!/usr/bin/env python3
"""Diagnose step 235 'no jmp' — what does the walker do at step 235?
It likely loops back to the dispatcher (0x180a97f70) or enters the keystream loop."""
import struct
from pathlib import Path
import sys
sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
from unicorn import Uc, UC_ARCH_X86, UC_MODE_64, UC_HOOK_CODE, UcError
from unicorn.x86_const import *
from capstone import CS_ARCH_X86, CS_MODE_64, Cs
import pefile

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
    ctx_off = CTX_BASE - BUGLAND_BASE
    ctx = bytearray(blob[ctx_off:ctx_off+768])
    key = bytes.fromhex("32206f9c196327ad276821ac8ebc7f80fe82d84cf72a4f7c1baf508c97d3aea8")
    uc.mem_write(0x1807bdc70, key)
    ctx[0xbd:0xc5] = struct.pack("<Q", 0x1807bdc70)
    uc.mem_write(CTX_BASE, bytes(ctx))

    state = {"last_jmp": None, "last_jmp_target": None, "last_insn": None}
    def on_code(uc_, address, size_, user):
        code = uc_.mem_read(address, min(size_, 15))
        insns = list(md.disasm(code, address))
        state["last_insn"] = (address, insns[0].mnemonic if insns else "?", insns[0].op_str if insns else "?")
        if insns and insns[0].mnemonic == "jmp" and insns[0].op_str in REGS:
            state["last_jmp"] = uc_.reg_read(REGS[insns[0].op_str])
            uc_.emu_stop()
        elif insns and insns[0].mnemonic in ("call",) and insns[0].op_str in REGS:
            # indirect call — record and continue
            pass
    uc.hook_add(UC_HOOK_CODE, on_code)

    handler = 0x1809f4736
    vip = 0x1815631ee
    key_word = 0xffffffa5
    for step in range(400):
        state["last_jmp"] = None
        uc.mem_write(CTX_BASE + 0x6d, struct.pack("<Q", vip))
        uc.mem_write(CTX_BASE + 0xa, struct.pack("<I", key_word & 0xffffffff))
        try:
            uc.emu_start(handler, 0, timeout=2_000_000, count=20000)
        except UcError:
            pass
        tgt = state["last_jmp"]
        if tgt is None:
            addr, mnem, ops = state["last_insn"]
            print("step %d: no jmp-reg. Last insn %#x: %s %s" % (step, addr, mnem, ops))
            print("  handler was %#x" % handler)
            break
        if is_stub(tgt):
            handler = stub_target(tgt)
            vip = struct.unpack("<Q", uc.mem_read(CTX_BASE + 0x6d, 8))[0]
            key_word = struct.unpack("<I", uc.mem_read(CTX_BASE + 0xa, 4))[0]
        else:
            print("step %d: jmp target %#x NOT stub (handler %#x)" % (step, tgt, handler))
            break

if __name__ == "__main__":
    main()
