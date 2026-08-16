import sys, struct
sys.path.insert(0, r'E:\Coding\S1mple\target\.pydeps')
from capstone import Cs, CS_ARCH_X86, CS_MODE_64

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
    name = data[off:off+8].rstrip(b'\x00').decode('ascii','replace')
    vsize, vaddr, rawsize, rawptr = struct.unpack_from('<IIII', data, off+8)
    sections.append(dict(name=name, vaddr=vaddr, vsize=vsize, rawsize=rawsize, rawptr=rawptr))

def rva_to_offset(rva):
    for s in sections:
        if s['vaddr'] <= rva < s['vaddr'] + max(s['vsize'], s['rawsize']):
            return s['rawptr'] + (rva - s['vaddr'])
    return None

md = Cs(CS_ARCH_X86, CS_MODE_64)
md.detail = True

def disasm(addr_rva, nbytes):
    off = rva_to_offset(addr_rva)
    if off is None:
        print("  !! cannot map rva 0x%x" % addr_rva); return
    code = data[off:off+nbytes]
    for insn in md.disasm(code, BASE+addr_rva):
        b = ' '.join('%02x'%x for x in insn.bytes)
        print("  0x%x  %-8s %-28s ; %s" % (insn.address, insn.mnemonic, insn.op_str, b))

# The full keystream load/store region 0xaa5bba (mov al,[rax]) and 0xaa5bce (mov dword [rbx],r10d)
print("==== keystream LOAD/STORE region 0x180aa5b80..0x180aa5c20 ====")
disasm(0xaa5b80, 0xa0)

# The dominant writer block 0x180aa58bf region (block boundary), disassemble back to find store
print()
print("==== 0x180aa58bf context (dominant slot-A keystream writer block) ====")
disasm(0xaa5870, 0x90)

# XOR region full r8 computation
print()
print("==== XOR region 0x1809c5500..0x1809c5590 (r8=slotA, r12=plaintext) ====")
disasm(0x9c5500, 0x90)
