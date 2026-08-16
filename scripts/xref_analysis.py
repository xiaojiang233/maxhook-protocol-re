import sys, os, struct

base = r"E:\Coding\S1mple\target"
sys.path.insert(0, os.path.join(base, ".pydeps"))
sys.path.insert(0, os.path.join(base, ".pydeps", "capstone", "lib"))  # for capstone.dll

import pefile
from capstone import *
from capstone.x86 import *

dll = os.path.join(base, "MaxHook.runtime-unpacked.dll")
pe = pefile.PE(dll, fast_load=True)

image_base = pe.OPTIONAL_HEADER.ImageBase
print(f"ImageBase = 0x{image_base:x}")

# map sections
sections = []
for s in pe.sections:
    name = s.Name.rstrip(b'\x00').decode('latin1')
    va = image_base + s.VirtualAddress
    vsize = s.Misc_VirtualSize
    raw = s.PointerToRawData
    rsize = s.SizeOfRawData
    sections.append((name, va, vsize, raw, rsize))
    print(f"  section {name:8s} VA=0x{va:x} VSize=0x{vsize:x} Raw=0x{raw:x} RSize=0x{rsize:x}")

data = open(dll, "rb").read()

def read_va(va, n):
    for name, sva, vsize, raw, rsize in sections:
        if sva <= va < sva + vsize:
            off = va - sva
            if off + n <= rsize:
                return data[raw + off : raw + off + n]
    return None

# .text range
text_name, text_va, text_vsize, text_raw, text_rsize = None, None, None, None, None
for name, va, vsize, raw, rsize in sections:
    if name == '.text':
        text_name, text_va, text_vsize, text_raw, text_rsize = name, va, vsize, raw, rsize

print(f"\n.text VA=0x{text_va:x} VSize=0x{text_vsize:x}")
text_code = data[text_raw : text_raw + text_vsize]

md = Cs(CS_ARCH_X86, CS_MODE_64)
md.detail = True

# Target entry points
memcpy_entry = image_base + 0x5d0b10
memset_entry = image_base + 0x5d11b0

# Find all call xrefs to memcpy_entry (and nearby internal targets)
targets = {0x5d0b10: "memcpy_entry", 0x5d0b00: "rep_movsb_fallback",
           0x5d10a0: "memmove_backward", 0x5d11b0: "memset_entry",
           0x5d11a0: "rep_stosb_fallback", 0x5d0a10: "memcmp_entry"}

xrefs = {k: [] for k in targets}

insts = []
for ins in md.disasm(text_code, text_va):
    insts.append(ins)
    if ins.mnemonic == 'call':
        # capstone gives absolute target for direct call
        if ins.operands and ins.operands[0].type == X86_OP_IMM:
            tgt = ins.operands[0].imm
            rva = tgt - image_base
            if rva in targets:
                xrefs[rva].append((ins.address, ins.mnemonic, ins.op_str))

print(f"\nTotal instructions disassembled: {len(insts)}")

for rva, label in targets.items():
    va = image_base + rva
    xs = xrefs[rva]
    print(f"\n=== xrefs to {label} (0x{va:x}) : {len(xs)} call(s) ===")
    for addr, mn, op in xs:
        print(f"    caller 0x{addr:x} (RVA 0x{addr-image_base:x})  {mn} {op}")
