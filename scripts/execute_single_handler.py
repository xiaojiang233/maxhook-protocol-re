#!/usr/bin/env python3
"""Execute a SINGLE VM handler body (0x180c0304d, index 0x5d0) with the REAL
vm_enter_context, and observe the exact context-slot transformation it performs.

This isolates the handler's semantics: which slots it reads, which it writes,
and the net delta.  By chaining these semantics we can reproduce the key-schedule
without full VM environment emulation.
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

    # Seed the REAL vm_enter_context
    live = (Path(r"E:\Coding\S1mple\target\vm_context_capture2")
            / "000006_call_1_meta_vm_enter_context.bin").read_bytes()
    ctx = bytearray(blob[CTX_BASE - BUGLAND_BASE : CTX_BASE - BUGLAND_BASE + 768])
    ctx[:512] = live
    uc.mem_write(CTX_BASE, bytes(ctx))

    # Map the heap key buffer (from keystream_history: key at 0x13a4e192070, pid 42948;
    # for vm_context2 pid 44328 the pointer is in context +0xbd).  Map a broad heap
    # region and place the key bytes there so the handler's key derefs succeed.
    key_hex = bytes.fromhex("32206F9C196327AD276821AC8EBC7F80FE82D84CF72A4F7C1BAF508C97D3AEA8")
    heap_base = 0x13a4e000000
    uc.mem_map(heap_base, 0x200000)
    uc.mem_write(0x13a4e192070, key_hex)  # key bytes (32B)
    uc.mem_write(0x13a4e192070 + 32, key_hex)  # duplicate (idempotent)

    # Snapshot context before execution
    before = bytes(uc.mem_read(CTX_BASE, 768))

    # Execute the handler body 0x180c0304d, stop at the first jmp reg (dispatch)
    # or ret.
    state = {"done": False, "insts": 0}
    def on_code(uc_, address, size_, user):
        state["insts"] += 1
        code = uc_.mem_read(address, min(size_, 15))
        insns = list(md.disasm(code, address))
        if insns:
            m = insns[0]
            # stop at indirect jmp (dispatch to next handler) or ret
            if m.mnemonic == "jmp" and m.op_str in REGS:
                state["done"] = True
                uc_.emu_stop()
            elif m.mnemonic == "ret":
                state["done"] = True
                uc_.emu_stop()
        if state["insts"] > 100000:
            uc_.emu_stop()
    uc.hook_add(UC_HOOK_CODE, on_code)

    try:
        uc.emu_start(0x180c0304d, 0, timeout=2_000_000, count=100000)
    except UcError as e:
        print("UcError:", e)

    after = bytes(uc.mem_read(CTX_BASE, 768))
    print("instructions:", state["insts"], "done:", state["done"])
    print("final RIP:", hex(uc.reg_read(UC_X86_REG_RIP)))

    # Diff the context: which slots changed?
    changed = []
    for i in range(768):
        if before[i] != after[i]:
            changed.append(i)
    print("changed byte offsets (%d):" % len(changed))
    for off in changed[:60]:
        print("  +0x%03x: %02x -> %02x" % (off, before[off], after[off]))

if __name__ == "__main__":
    main()
