#!/usr/bin/env python3
import struct
import pefile
from capstone import *
from capstone.x86 import *

DLL = r"E:\Coding\S1mple\target\MaxHook.runtime-unpacked.dll"
BASE = 0x180000000

pe = pefile.PE(DLL, fast_load=True)
sections = []
for s in pe.sections:
    name = s.Name.rstrip(b'\x00').decode('ascii', 'replace')
    sections.append((name, pe.OPTIONAL_HEADER.ImageBase + s.VirtualAddress,
                     s.Misc_VirtualSize, s.PointerToRawData, s.SizeOfRawData))
data = open(DLL, 'rb').read()

def va_to_offset(va):
    for (name, sec_va, vsz, raw, rsz) in sections:
        if sec_va <= va < sec_va + max(vsz, rsz):
            return raw + (va - sec_va)
    return None

def disasm_va(va, max_insn=80, label=""):
    off = va_to_offset(va)
    if off is None:
        print(f"[{label}] VA {va:#x} not in section"); return
    code = data[off:off+0x600]
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    md.detail = True
    print(f"\n===== {label}  VA={va:#x} =====")
    n = 0
    for insn in md.disasm(code, va):
        annot = ""
        for op in insn.operands:
            if op.type == X86_OP_MEM and op.mem.base == X86_REG_RIP:
                tgt = insn.address + insn.size + op.mem.disp
                annot += f"  ; -> {tgt:#x}"
        print(f"  {insn.address:#x}  {insn.bytes.hex():<24} {insn.mnemonic:8s} {insn.op_str}{annot}")
        n += 1
        if n >= max_insn: break

# Caller of store32 is at 0x181ad61e7 (return address). The call instruction is just before.
# So the call to store32 is at ~0x181ad61e2. Let's look at the region around 0x181ad61e7.
print("Which section contains 0x181ad61e7?")
for (name, sec_va, vsz, raw, rsz) in sections:
    if sec_va <= 0x181ad61e7 < sec_va + max(vsz, rsz):
        print(f"  -> section {name}, VA {sec_va:#x}, so RVA = {0x181ad61e7 - sec_va:#x} within it")

# Disassemble backwards from 0x181ad61e7 to find the call
disasm_va(0x181ad5e00, 100, "region before caller 0x181ad61e7")

# Also disassemble the store32 caller context precisely
disasm_va(0x181ad6180, 40, "caller 0x181ad61e7 context")
