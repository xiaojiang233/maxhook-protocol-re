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

def read_at(rva, size):
    off = rva_to_offset(rva)
    if off is None: return None
    return data[off:off+size]

def disasm_full(rva, max_insn=400, label=""):
    off = rva_to_offset(rva)
    if off is None:
        print(f"[{label}] RVA {rva:#x} not in section"); return
    code = data[off:off+0x1000]
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    md.detail = True
    print(f"\n===== {label}  RVA={rva:#x}  VA={BASE+rva:#x} =====")
    n = 0
    for insn in md.disasm(code, BASE+rva):
        # resolve rip-relative target
        annot = ""
        for op in insn.operands:
            if op.type == X86_OP_MEM and op.mem.base == X86_REG_RIP:
                tgt = insn.address + insn.size + op.mem.disp
                annot += f"  ; -> {tgt:#x} (rva {tgt-BASE:#x})"
        print(f"  {insn.address:#x}  {insn.bytes.hex():<24} {insn.mnemonic:8s} {insn.op_str}{annot}")
        n += 1
        if n >= max_insn: break

disasm_full(0x41a8a0, 400, "generator @ 0x41a8a0 FULL")
