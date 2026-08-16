# -*- coding: utf-8 -*-
"""
hash_match.py — 提取 .text 中的 FNV 哈希常量, 匹配系统 DLL 导出名
WinLicense import resolver: hash = (char ^ hash) * 0x1000193, seed 0x1c258cc9
"""
import struct, os

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
        text = (orig[ra:ra+rs], v)

def fnv_hash(name):
    h = 0x1c258cc9
    for c in name.encode():
        h = ((c ^ h) * 0x1000193) & 0xFFFFFFFF
    return h

# 1. 提取 .text 中 cmp edi/esi/edx/ecx/r10d/r14d/r8d/r9d/r11d/r15d/r13d/r12d, imm32 的常量
code, text_va = text
cands = set()
i = 0
n = len(code)
while i < n - 7:
    b = code[i]
    # cmp r32, imm32: 81 F8/F9/FA/FB/FC/FD/FE/FF imm32 或 3D imm32 (eax)
    if b == 0x81 and code[i+1] in range(0xF8, 0x100):
        imm = struct.unpack('<I', code[i+2:i+6])[0]
        if imm > 0x1000000:  # 过滤小常量
            cands.add(imm)
        i += 6
    elif b == 0x3D:
        imm = struct.unpack('<I', code[i+1:i+5])[0]
        if imm > 0x1000000:
            cands.add(imm)
        i += 5
    elif b == 0x83 and code[i+1] in range(0xF8, 0x100):  # cmp r32, imm8
        i += 3
    else:
        i += 1

print(f"提取到 {len(cands)} 个 imm32 常量 (候选哈希)")

# 2. 加载系统 DLL 导出名
def load_exports(name):
    p = os.path.join(r'C:\Windows\System32', name)
    if not os.path.exists(p):
        return []
    d = open(p, 'rb').read()
    e_lfanew = struct.unpack('<I', d[0x3C:0x40])[0]
    if e_lfanew + 4 > len(d): return []
    nsec = struct.unpack('<H', d[e_lfanew+6:e_lfanew+8])[0]
    opt = e_lfanew + 24
    is64 = struct.unpack('<H', d[opt:opt+2])[0] == 0x20B
    sec_off = opt + (240 if is64 else 224)
    exp_rva, exp_size = struct.unpack('<II', d[opt+112:opt+120]) if is64 else struct.unpack('<II', d[opt+96:opt+104])
    if not exp_rva: return []
    def rva2off(rva):
        for i in range(nsec):
            vs_, va_, rs_, ra_ = struct.unpack('<IIII', d[sec_off+i*40+8:sec_off+i*40+24])
            if va_ <= rva < va_ + vs_:
                return ra_ + (rva - va_)
        return None
    def rd_cstr(off, maxlen=256):
        if off >= len(d): return None
        end = d.find(b'\x00', off, min(off+maxlen, len(d)))
        if end < 0: return None
        return d[off:end]
    def rd_u32(off):
        if off + 4 > len(d): return None
        return struct.unpack('<I', d[off:off+4])[0]
    eo = rva2off(exp_rva)
    if eo is None: return []
    nnames = rd_u32(eo+24)
    name_rva = rd_u32(eo+32)
    ord_rva = rd_u32(eo+36)
    if nnames is None or name_rva is None or ord_rva is None: return []
    no_ = rva2off(name_rva); oo = rva2off(ord_rva)
    if no_ is None: return []
    out = []
    for i in range(nnames):
        nr = rd_u32(no_+i*4)
        if nr is None: break
        so = rva2off(nr)
        if so is None: continue
        nm = rd_cstr(so)
        if nm:
            out.append(nm.decode(errors='replace'))
    return out

dlls = ['kernel32.dll', 'ntdll.dll', 'winhttp.dll', 'ws2_32.dll', 'iphlpapi.dll',
        'version.dll', 'advapi32.dll', 'user32.dll', 'ole32.dll', 'oleaut32.dll',
        'iphlpapi.dll', 'crypt32.dll', 'bcrypt.dll', 'psapi.dll', 'tlhelp32.dll', 'netapi32.dll']
export_names = {}
for dll in dlls:
    for nm in load_exports(dll):
        export_names[nm] = dll

print(f"系统导出名总数: {len(export_names)}")

# 3. 哈希匹配 (原样 + 各种大小写)
name_hashes = {}
for nm in export_names:
    for variant in (nm, nm.lower(), nm.upper(), nm.capitalize()):
        h = fnv_hash(variant)
        name_hashes.setdefault(h, set()).add((nm, export_names[nm]))

# 4. 匹配
matched = {}
for c in cands:
    if c in name_hashes:
        for nm, dll in name_hashes[c]:
            matched.setdefault(nm, []).append(hex(c))

print(f"\n=== 哈希匹配结果 ({len(matched)} 个 API) ===")
for nm, hashes in sorted(matched.items()):
    print(f"  {nm:45s} <- {', '.join(hashes)}")
