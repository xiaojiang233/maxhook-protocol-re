#!/usr/bin/env python3
"""Decisive continuous execution: start VM dispatcher 0x180a97f70 with the REAL
vm_enter_context (flag=0x41, key=0xffffa301) and run CONTINUOUSLY to follow the
full INIT -> key-schedule -> keystream path, capturing store32 words.

Key correction vs prior attempts:
  - Start at the DISPATCHER 0x180a97f70 (not a mid-chain handler).
  - Seed the REAL vm_enter_context 512B (flag=0x41), not the idle blob (flag=0x69).
  - The dispatcher reads VIP from context[0x6d], key from context[0xa].
  - Run continuously (no per-handler emu_stop) so registers persist through the
    transition into the plaintext key-schedule.

Ground truth (vm_context_capture2 call 1):
  key    = 32206F9C196327AD276821AC8EBC7F80FE82D84CF72A4F7C1BAF508C97D3AEA8
  nonce  = c38d500ac2ae8d2611ae1749
  keystream[0:8] = 9bd9300fdf47a800
"""
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
CTX_BASE = 0x18098C884
STORE32 = 0x18041A860
DISPATCHER = 0x180A97F70

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

    # Seed the REAL vm_enter_context (512B) at the context base.
    live = (Path(r"E:\Coding\S1mple\target\vm_context_capture2")
            / "000006_call_1_meta_vm_enter_context.bin").read_bytes()
    ctx = bytearray(blob[CTX_BASE - BUGLAND_BASE : CTX_BASE - BUGLAND_BASE + 768])
    # Overlay the real captured 512B context (flag=0x41, key=0xffffa301)
    ctx[:512] = live
    uc.mem_write(CTX_BASE, bytes(ctx))

    vip = int.from_bytes(live[0x6d:0x75], "little")
    key = int.from_bytes(live[0xa:0xe], "little")
    print("live seed: vip=%#x key=%#x flag=%#x" % (vip, key, live[0x162]))

    state = {"store32": [], "insts": 0, "dispatches": 0}
    def on_code(uc_, address, size_, user):
        state["insts"] += 1
        if address == STORE32:
            dest = uc_.reg_read(UC_X86_REG_RCX)
            val = uc_.reg_read(UC_X86_REG_RDX) & 0xFFFFFFFF
            state["store32"].append((dest, val))
        if address == DISPATCHER:
            state["dispatches"] += 1
        if state["insts"] >= 500000:
            uc_.emu_stop()
    uc.hook_add(UC_HOOK_CODE, on_code)

    # Try both the live mid-execution VIP and the bootstrap VIP.
    try:
        uc.emu_start(DISPATCHER, 0, timeout=3_000_000, count=500000)
    except UcError as e:
        print("UcError:", e)

    print("instructions executed:", state["insts"])
    print("dispatcher entries:", state["dispatches"])
    print("store32 captured:", len(state["store32"]))
    for d, v in state["store32"][:16]:
        print("  val=%#010x" % v)
    print("final RIP:", hex(uc.reg_read(UC_X86_REG_RIP)))
    print("final registers:", {n: hex(uc.reg_read(r)) for n, r in REGS.items()})

if __name__ == "__main__":
    main()
