import sys, struct
sys.path.insert(0, r'E:\Coding\S1mple\target\.pydeps')
from capstone import Cs, CS_ARCH_X86, CS_MODE_64
from capstone.x86 import X86_OP_MEM, X86_REG_RIP, X86_OP_IMM

DLL = r'E:\Coding\S1mple\target\MaxHook.runtime-unpacked.dll'
BASE = 0x180000000

data = open(DLL, 'rb').read()
e_lfanew = struct.unpack_from('<I', data, 0x3C)[0]
coff = e_lfanew + 4
machine, nsections, timestamp, symtab, nsyms, optsize, characteristics = struct.unpack_from('<HHIIIHH', data, coff)
opt = coff + 20
sec_start = opt + optsize
sections = []
for i in range(nsections):
    off = sec_start + i*40
    name = data[off:off+8].rstrip(b'\x00').decode('ascii', 'replace')
    vsize, vaddr, rawsize, rawptr = struct.unpack_from('<IIII', data, off+8)
    sections.append(dict(name=name, vaddr=vaddr, vsize=vsize, rawsize=rawsize, rawptr=rawptr))

def rva_to_offset(rva):
    for s in sections:
        if s['vaddr'] <= rva < s['vaddr'] + max(s['vsize'], s['rawsize']):
            return s['rawptr'] + (rva - s['vaddr'])
    return None

md = Cs(CS_ARCH_X86, CS_MODE_64)
md.detail = True

def disasm(va, nbytes, label, maxn=300):
    rva = va - BASE
    off = rva_to_offset(rva)
    print("\n==== %s  VA=%#x (RVA=%#x) ====" % (label, va, rva))
    if off is None:
        print("  !! cannot map")
        return
    code = data[off:off+nbytes]
    n = 0
    for insn in md.disasm(code, va):
        annot = ""
        for op in insn.operands:
            if op.type == X86_OP_MEM and op.mem.base == X86_REG_RIP:
                tgt = insn.address + insn.size + op.mem.disp
                annot += "  ; -> %#x" % tgt
        print("  %#x  %-28s %-8s %s%s" % (insn.address, insn.bytes.hex(), insn.mnemonic, insn.op_str, annot))
        n += 1
        if n >= maxn:
            break

# The return address 0x181ad61e7 means CALL was at 0x181ad61e2 (5-byte E8 rel32).
# Disassemble well before it to find where EDX (the value) is computed.
disasm(0x181ad6100, 0x160, "call site to writer, return=0x181ad61e7")
