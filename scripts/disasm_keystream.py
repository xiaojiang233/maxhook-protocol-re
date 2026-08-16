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

def disasm(addr_rva, nbytes, base=BASE, prefix="   "):
    off = rva_to_offset(addr_rva)
    if off is None:
        print("  !! cannot map rva 0x%x" % addr_rva)
        return
    code = data[off:off+nbytes]
    for insn in md.disasm(code, base+addr_rva):
        print("%s0x%x  %-9s %s" % (prefix, insn.address, insn.mnemonic, insn.op_str))

regions = [
    (0x9c5500, 0x90, "XOR region: 0x1809c552a load-ptr / 0x1809c552e load-plaintext / 0x1809c5561 xor"),
    (0x9c544c, 0x28, "writer_block 0x1809c544c (repeated A/B change near XOR)"),
    (0xaa58bf, 0x60, "writer_block 0x180aa58bf (dominant slot A keystream writer)"),
    (0xaa5b80, 0x70, "keystream LOAD 0x180aa5bba / STORE 0x180aa5bce"),
    (0x9851af, 0x20, "observer 0x1809851af"),
    (0x9c5612, 0x30, "observer 0x1809c5612 (post-XOR)"),
]
for rva, nb, label in regions:
    print()
    print("==== %s ====" % label)
    disasm(rva, nb)
