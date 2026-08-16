import sys, struct
sys.path.insert(0, r'E:\Coding\S1mple\target\.pydeps')
from capstone import Cs, CS_ARCH_X86, CS_MODE_64, x86

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

# The VM context base rbp = 0x98c884. Slot A = +0xb5, Slot B = +0x235.
# Find all instructions in .bugland that reference [rbp + 0xb5] or [rbp+0x235] or
# a register that equals rbp+0xb5. Since obfuscation splits "rbp+0xb5" as "reg=rbp; reg+=0xb5",
# we search for "add rX, 0xb5" and "add rX, 0x235" and "add rX, 0xe5" etc.

md = Cs(CS_ARCH_X86, CS_MODE_64)
md.detail = True

# Search the whole .bugland section (vaddr 0x980000, size 0x157c000) for interesting instructions.
bug = next(s for s in sections if s['name'] == '.bugland')
base_vaddr = bug['vaddr']
code = data[bug['rawptr']:bug['rawptr']+bug['vsize']]

# We search for: immediate adds of 0xb5, 0x235, 0xe5, and movs to [reg] after such add.
# Also search for byte/dword/word stores with displacement 0xb5 or 0x235 in a memory operand.
import re

targets = [0xb5, 0x235, 0xe5, 0x5d, 0xa, 0x6d, 0x85, 0xbd, 0x162]
print("Scanning .bugland (%d bytes) for context-offset references..." % len(code))
hits = []
for insn in md.disasm(code, BASE + base_vaddr):
    op = insn.op_str
    mnem = insn.mnemonic
    # Look for "0xb5", "+ 0xb5", "0x235" as immediate
    for t in targets:
        ts = hex(t)
        if ts in op and ('+' in op or mnem in ('add','sub','lea','cmp','mov') or insn.operands):
            # refine: immediate add/sub
            if mnem in ('add','sub','lea','cmp','xor','or','and') and ts in op:
                hits.append((insn.address, mnem, op))
    # memory operand with disp 0xb5/0x235
    for i, operand in enumerate(insn.operands):
        if operand.type == x86.X86_OP_MEM:
            mem = operand.mem
            if mem.disp in (0xb5, 0x235):
                hits.append((insn.address, mnem, op))

# Dedup and print
seen = set()
for addr, m, o in hits:
    if addr in seen: continue
    seen.add(addr)
print("Total unique hits:", len(seen))
for addr, m, o in sorted(hits)[:200]:
    print("  0x%x  %-8s %s" % (addr, m, o))
