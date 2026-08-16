# -*- coding: utf-8 -*-
"""
scan_constructed.py — 扫描 .text 中 movabs imm64 构造的字符串常量
WinLicense 加密了 .rdata 里的串, 但 .text 里的 movabs 立即数 (ASCII 分块) 是明文
"""
import struct, re
from capstone import Cs, CS_ARCH_X86, CS_MODE_64

path = r'E:/MCLDownload/Game/.minecraft/native/MaxHook.dll'
orig = open(path, 'rb').read()
e_lfanew = struct.unpack('<I', orig[0x3C:0x40])[0]
coff = e_lfanew + 4
_, nsects, _, _, _, _, _ = struct.unpack('<HHIIIHH', orig[coff:coff+20])
opt = coff + 20
image_base = struct.unpack('<Q', orig[opt+24:opt+32])[0]
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

md = Cs(CS_ARCH_X86, CS_MODE_64)
md.detail = True

code, text_va, text_ra = text

def printable8(q):
    b = struct.pack('<Q', q)
    return all(0x20 <= c < 0x7f for c in b)

def ascii_of(q):
    return struct.pack('<Q', q).decode('latin1')

# 收集所有 movabs imm64 (48 B8-BF imm64) 且 imm 为全可打印
hits = []
i = 0
n = len(code)
while i < n - 10:
    b = code[i]
    if b == 0x48 and code[i+1] in range(0xB8, 0xC0):
        imm = struct.unpack('<Q', code[i+2:i+10])[0]
        if printable8(imm):
            hits.append((text_va + i, code[i+1], imm, i))
        i += 10
    else:
        i += 1

print(f"movabs 可打印立即数: {len(hits)} 处")

# 分组: 相邻的 movabs (间隔 < 0x20) 且指向同一寄存器 → 拼成长串
def group_strings(hits):
    groups = []
    cur = []
    for addr, reg, imm, off in hits:
        if cur and addr - cur[-1][0] < 0x30 and reg == cur[-1][1]:
            cur.append((addr, reg, imm, off))
        else:
            if cur: groups.append(cur)
            cur = [(addr, reg, imm, off)]
    if cur: groups.append(cur)
    return groups

groups = group_strings(hits)
print(f"分组: {len(groups)}")

# 解码每组: 每块 8 字符, 拼接后按可能的重叠合并
results = []
for g in groups:
    s = ''
    for addr, reg, imm, off in g:
        s += ascii_of(imm)
    results.append((g[0][0], len(g), s))

# 按 8 字符对齐合并重叠
merged = []
for addr, nchunks, s in results:
    # s 长度 = nchunks*8
    merged.append((addr, s))

print("\n=== 构造字符串常量 (相邻 movabs 组) ===")
seen = set()
for addr, s in sorted(merged):
    # 去重 + 过滤无意义
    key = s
    if key in seen: continue
    seen.add(key)
    if sum(c.isalpha() for c in s) < 6: continue
    print(f"  @RVA {addr-text_va:#x}: {s!r}")

# 也输出单个 movabs 的有意义串
print("\n=== 单个 movabs 串 (含字母>=6) ===")
cnt = 0
for addr, reg, imm, off in hits:
    s = ascii_of(imm)
    if sum(c.isalpha() for c in s) >= 6:
        print(f"  @RVA {addr-text_va:#x}: {s!r}")
        cnt += 1
        if cnt > 80: break
