import sys, struct
sys.path.insert(0, r'E:\Coding\S1mple\target\.pydeps')
from capstone import Cs, CS_ARCH_X86, CS_MODE_64, CS_OPT_SYNTAX_INTEL
from capstone.x86 import X86_OP_MEM, X86_REG_RIP

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

def sec_of_rva(rva):
    for s in sections:
        if s['vaddr'] <= rva < s['vaddr'] + max(s['vsize'], s['rawsize']):
            return s['name'], s['vaddr']
    return None, None

md = Cs(CS_ARCH_X86, CS_MODE_64)
md.detail = True

def disasm(va, nbytes, label, maxn=200):
    rva = va - BASE
    off = rva_to_offset(rva)
    name, svaddr = sec_of_rva(rva)
    print("\n==== %s  VA=%#x (RVA=%#x) section=%s ====" % (label, va, rva, name))
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

# Key addresses:
# writer (store32) = 0x18041a860
# caller_block = 0x180c2775c (popfq/ret mentioned in task)
# return address of the call to writer = 0x181ad61e7

disasm(0x18041a840, 0x80, "WRITER store32 @ 0x18041a860")
disasm(0x180c27700, 0xc0, "caller_block 0x180c2775c region")
disasm(0x181ad6100, 0x140, "return address 0x181ad61e7 region (call site to writer)")
