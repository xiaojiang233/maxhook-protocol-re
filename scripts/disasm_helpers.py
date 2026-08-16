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

def rva_to_offset(rva):
    va = BASE + rva
    for (name, sec_va, vsz, raw, rsz) in sections:
        if sec_va <= va < sec_va + max(vsz, rsz):
            return raw + (va - sec_va)
    return None

def disasm_full(rva, max_insn=80, label=""):
    off = rva_to_offset(rva)
    if off is None:
        print(f"[{label}] RVA {rva:#x} not in section"); return
    code = data[off:off+0x800]
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    md.detail = True
    print(f"\n===== {label}  RVA={rva:#x}  VA={BASE+rva:#x} =====")
    n = 0
    for insn in md.disasm(code, BASE+rva):
        annot = ""
        for op in insn.operands:
            if op.type == X86_OP_MEM and op.mem.base == X86_REG_RIP:
                tgt = insn.address + insn.size + op.mem.disp
                annot += f"  ; -> {tgt:#x}"
        print(f"  {insn.address:#x}  {insn.bytes.hex():<24} {insn.mnemonic:8s} {insn.op_str}{annot}")
        n += 1
        if n >= max_insn: break

# The 8 helpers called through the table (each takes rcx=output ptr)
helpers = [
    (0x4167e0, "helper_0 @ 0x4167e0"),
    (0x417130, "helper_1 @ 0x417130"),
    (0x4172e0, "helper_2 @ 0x4172e0"),
    (0x41b180, "helper_3 @ 0x41b180"),
    (0x41b0a0, "helper_4 @ 0x41b0a0"),
    (0x416750, "helper_5 @ 0x416750"),
    (0x41a840, "helper_6 @ 0x41a840 (near store32)"),
    (0x4160d0, "helper_7 @ 0x4160d0"),
    (0x41b950, "helper_8 @ 0x41b950"),
    (0x415d0,  "helper_9 @ 0x415d0"),
    (0x89bc0,  "helper_10 @ 0x89bc0"),
    (0x416280, "helper_11 @ 0x416280"),
]
for rva, label in helpers:
    disasm_full(rva, 60, label)
