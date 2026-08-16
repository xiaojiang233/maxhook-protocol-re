# -*- coding: utf-8 -*-
"""
hash_match2.py — 提取 .text 中所有 FNV resolver 的 (seed, expected_hash) 对并匹配系统导出
每个 resolver: mov rXX, SEED; loop { movsx ebx,byte; xor ebx,rXX; imul rXX,ebx,0x1000193; ...; cmp rXX, HASH }
"""
import struct, os
from capstone import Cs, CS_ARCH_X86, CS_MODE_64

path = r'E:/MCLDownload/Game/.minecraft/native/MaxHook.dll'
orig = open(path, 'rb').read()
e_lfanew = struct.unpack('<I', orig[0x3C:0x40])[0]
coff = e_lfanew + 4
_, nsects, _, _, _, _, _ = struct.unpack('<HHIIIHH', orig[coff:coff+20])
opt = coff + 20
sec_off = opt + 240
sections = []
for i in range(nsects):
    name = orig[sec_off+i*40:sec_off+i*40+8].rstrip(b'\x00').decode(errors='replace')
    vsize, vaddr, rsize, raddr = struct.unpack('<IIII', orig[sec_off+i*40+8:sec_off+i*40+24])
    sections.append((name, vaddr, vsize, raddr, rsize))
text = None
for n, v, vs, ra, rs in sections:
    if n == '.text':
        text = (orig[ra:ra+rs], v, ra)

code, text_va, text_ra = text
md = Cs(CS_ARCH_X86, CS_MODE_64)

# 1. 找所有 imul x, ebx, 0x1000193 站点 (69 xx 93010001)
sites = []
i = 0
n = len(code)
while i < n - 6:
    if code[i] == 0x69 and code[i+2:i+6] == b'\x93\x01\x00\x01':
        sites.append(i)
        i += 6
    else:
        i += 1
print(f"imul 站点: {len(sites)}")

import re as _re
# 2. 对每个站点, 反汇编 ±0x50, 提取 seed (mov r32,imm32) 与 cmp r32,imm32
regpat = _re.compile(r'^(r\d+[d]?|e[a-z]{2}|r\d+)$')
pairs = []  # (seed, hash)
for s in sites:
    start = max(0, s - 0x60)
    end = min(n, s + 0x40)
    seed = None
    hashes = set()
    for insn in md.disasm(code[start:end], text_va + start):
        if insn.mnemonic == 'mov' and ',' in insn.op_str:
            parts = insn.op_str.split(',')
            if len(parts) == 2:
                try:
                    imm = int(parts[1].strip(), 16)
                except ValueError:
                    continue
                rn = parts[0].strip()
                if 0x10000000 < imm < 0xFFFFFFFF and regpat.match(rn):
                    seed = imm
        if insn.mnemonic == 'cmp':
            parts = insn.op_str.split(',')
            if len(parts) == 2:
                try:
                    imm = int(parts[1].strip(), 16)
                except ValueError:
                    continue
                if imm > 0x1000000:
                    hashes.add(imm)
    if seed and hashes:
        for h in hashes:
            pairs.append((seed, h))
print(f"(seed, hash) 对: {len(pairs)}")

# 3. 加载导出
def load_exports(name):
    p = os.path.join(r'C:\Windows\System32', name)
    if not os.path.exists(p): return []
    d = open(p, 'rb').read()
    e_lfanew = struct.unpack('<I', d[0x3C:0x40])[0]
    if e_lfanew + 4 > len(d): return []
    coff = e_lfanew + 4
    nsec = struct.unpack('<H', d[coff+2:coff+4])[0]
    optsize = struct.unpack('<H', d[coff+16:coff+18])[0]
    opt = coff + 20
    sec_off = opt + optsize
    exp_rva, exp_size = struct.unpack('<II', d[opt+112:opt+120])
    if not exp_rva: return []
    def rva2off(rva):
        for i in range(nsec):
            vs_, va_, rs_, ra_ = struct.unpack('<IIII', d[sec_off+i*40+8:sec_off+i*40+24])
            if va_ <= rva < va_ + vs_:
                return ra_ + (rva - va_)
        return None
    def rd_u32(off):
        if off + 4 > len(d): return None
        return struct.unpack('<I', d[off:off+4])[0]
    eo = rva2off(exp_rva)
    if eo is None: return []
    nnames = rd_u32(eo+24); name_rva = rd_u32(eo+32)
    if nnames is None or name_rva is None: return []
    no_ = rva2off(name_rva)
    if no_ is None: return []
    out = []
    for i in range(nnames):
        nr = rd_u32(no_+i*4)
        if nr is None: break
        so = rva2off(nr)
        if so is None: continue
        if so >= len(d): continue
        end = d.find(b'\x00', so, min(so+256, len(d)))
        if end < 0: continue
        out.append(d[so:end].decode(errors='replace'))
    return out

dlls = ['kernel32.dll', 'ntdll.dll', 'winhttp.dll', 'ws2_32.dll', 'iphlpapi.dll',
        'version.dll', 'advapi32.dll', 'user32.dll', 'ole32.dll', 'oleaut32.dll',
        'crypt32.dll', 'bcrypt.dll', 'psapi.dll', 'dbghelp.dll', 'wtsapi32.dll',
        'secur32.dll', 'netapi32.dll', 'shell32.dll', 'shlwapi.dll', 'wintrust.dll']
export_names = set()
for dll in dlls:
    for nm in load_exports(dll):
        export_names.add(nm)
print(f"导出名总数: {len(export_names)}")

# 4. 对每个 seed, 建 hash->name 表
matched = {}
for seed, h in set(pairs):
    for nm in export_names:
        hh = seed
        for c in nm.encode():
            hh = ((c ^ hh) * 0x1000193) & 0xFFFFFFFF
        if hh == h:
            matched.setdefault((hex(seed), hex(h)), set()).add(nm)
            break

print(f"\n=== 匹配结果 ===")
for k, names in sorted(matched.items()):
    print(f"  seed={k[0]} hash={k[1]}: {', '.join(sorted(names))}")
print(f"\n未匹配的 (seed,hash) 对: {len(set(pairs)) - len(matched)}")
for seed, h in sorted(set(pairs)):
    if (hex(seed), hex(h)) not in matched:
        print(f"  seed={seed:#x} hash={h:#x}")
