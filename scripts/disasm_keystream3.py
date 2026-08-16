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
def disasm(addr_rva, nbytes, label):
    off = rva_to_offset(addr_rva)
    if off is None:
        print("!! cannot map 0x%x" % addr_rva); return
    print("==== %s (0x%x) ====" % (label, BASE+addr_rva))
    code = data[off:off+nbytes]
    for insn in md.disasm(code, BASE+addr_rva):
        b = ' '.join('%02x'%x for x in insn.bytes)
        print("  0x%x  %-8s %-30s ; %s" % (insn.address, insn.mnemonic, insn.op_str, b))

# 1. The producer block 0x180aa58bf: find the actual store to slot A.
#    The block boundary observed is 0x180aa58bf; the store happens inside the block.
#    r11 = rbp + 0xe5 (computed at 0xaa58c9/0xaa58d3), then "add word ptr [r11], r10w" at 0xaa58e4.
#    rbp + 0xe5 = 0x98c884 + 0xe5 = 0x98c969. Hmm, not 0x98c939. Let me look wider.
disasm(0xaa5800, 0x200, "Producer block 0x180aa58bf full context")

# 2. The alternate producer 0x180a182e9
disasm(0xa182c0, 0x90, "Alternate producer 0x180a182e9")

# 3. The observer / dispatcher target 0x180bd41ad
disasm(0xbd41a0, 0x40, "Dispatcher 0x180bd41ad (observer target)")
