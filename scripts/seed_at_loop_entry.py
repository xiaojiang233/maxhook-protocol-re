#!/usr/bin/env python3
"""Seed the fold-input state slots at the keystream-loop ENTRY (after INIT),
then capture keystream and verify.

The walker's INIT phase is ~169 steps (before the ARX loop handlers start
repeating).  At the loop entry, seed +0x180..+0x2db from vm_enter_context,
then continue to capture store32."""
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
    live = (Path(r"E:\Coding\S1mple\target\vm_context_capture2") / "000006_call_1_meta_vm_enter_context.bin").read_bytes()

    state = {"last_jmp": None, "store32": [], "seeded": False}
    def on_code(uc_, address, size_, user):
        if address == STORE32:
            dest = uc_.reg_read(UC_X86_REG_RCX)
            val = uc_.reg_read(UC_X86_REG_RDX) & 0xFFFFFFFF
            state["store32"].append((dest, val))
        code = uc_.mem_read(address, min(size_, 15))
        insns = list(md.disasm(code, address))
        if insns and insns[0].mnemonic == "jmp" and insns[0].op_str in REGS:
            state["last_jmp"] = uc_.reg_read(REGS[insns[0].op_str])
            uc_.emu_stop()
    uc.hook_add(UC_HOOK_CODE, on_code)

    handler = 0x1809f4736
    vip = 0x1815631ee
    key = 0xffffffa5
    for step in range(400):
        state["last_jmp"] = None
        uc.mem_write(CTX_BASE + 0x6d, struct.pack("<Q", vip))
        uc.mem_write(CTX_BASE + 0xa, struct.pack("<I", key & 0xffffffff))
        # Seed the state slots at the keystream-loop entry (step ~169, when the
        # ARX loop handler 0x180ac2b8c starts repeating)
        if step >= 169 and not state["seeded"]:
            cur = bytearray(uc.mem_read(CTX_BASE, 768))
            cur[0x180:0x2e0] = live[0x180:0x2e0]
            uc.mem_write(CTX_BASE, bytes(cur))
            state["seeded"] = True
            print("seeded state slots at step %d" % step)
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

    print("store32 captured:", len(state["store32"]))
    for dest, val in state["store32"][:16]:
        print("  val=%#010x" % val)
    P = Path(r"E:\Coding\S1mple\target\vm_context_capture2")
    pt = (P / "000005_call_1_input_plaintext_json.bin").read_bytes()
    ct = bytes.fromhex((P / "000010_call_1_output_ciphertext_hex.bin").read_bytes().decode())
    ks = bytes(a ^ b for a, b in zip(pt, ct))
    print("\nground-truth keystream[0:16]:", ks[:16].hex())
    if state["store32"]:
        cap = b"".join(struct.pack("<I", v) for _, v in state["store32"])
        print("captured keystream[0:16]:", cap[:16].hex())
        print("MATCH?", cap[:16] == ks[:16])

if __name__ == "__main__":
    main()
