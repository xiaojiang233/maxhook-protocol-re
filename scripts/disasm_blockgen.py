#!/usr/bin/env python3
import sys, struct
import pefile
from capstone import *
from capstone.x86 import *

DLL = r"E:\Coding\S1mple\target\MaxHook.runtime-unpacked.dll"
BASE = 0x180000000  # image base from events.jsonl module_base

pe = pefile.PE(DLL, fast_load=True)
print("ImageBase:", hex(pe.OPTIONAL_HEADER.ImageBase))
print("SizeOfImage:", hex(pe.OPTIONAL_HEADER.SizeOfImage))

# Build RVA -> file offset mapping
sections = []
for s in pe.sections:
    name = s.Name.rstrip(b'\x00').decode('ascii', 'replace')
    va = pe.OPTIONAL_HEADER.ImageBase + s.VirtualAddress
    vsz = s.Misc_VirtualSize
    raw = s.PointerToRawData
    rsz = s.SizeOfRawData
    sections.append((name, va, vsz, raw, rsz))
    print(f"  {name:8s} VA={va:#x} VSize={vsz:#x} RawOff={raw:#x} RawSize={rsz:#x}")

data = open(DLL, 'rb').read()

def rva_to_offset(rva):
    va = BASE + rva
    for (name, sec_va, vsz, raw, rsz) in sections:
        if sec_va <= va < sec_va + max(vsz, rsz):
            return raw + (va - sec_va)
    return None

def read_at(rva, size):
    off = rva_to_offset(rva)
    if off is None:
        return None
    return data[off:off+size]

def disasm_n(n, rva, count=80, label=""):
    off = rva_to_offset(rva)
    if off is None:
        print(f"[{label}] RVA {rva:#x} not in any section")
        return
    code = data[off:off+count*16]
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    md.detail = True
    print(f"\n===== {label}  RVA={rva:#x}  VA={BASE+rva:#x} =====")
    n_out = 0
    for insn in md.disasm(code, BASE+rva):
        print(f"  {insn.address:#x}  {insn.bytes.hex():<24} {insn.mnemonic:8s} {insn.op_str}")
        n_out += 1
        if n_out >= n:
            break

# --- Store32 helper at 0x41a860 ---
disasm_n(40, 0x41a860, 40, "store32 @ 0x41a860")

# --- Generator at 0x41a8a0 ---
disasm_n(160, 0x41a8a0, 160, "generator @ 0x41a8a0")

# --- Encrypt at 0x324610 (prologue only, to understand call site) ---
disasm_n(60, 0x324610, 60, "encrypt @ 0x324610 (prologue)")
