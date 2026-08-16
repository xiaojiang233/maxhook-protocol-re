# -*- coding: utf-8 -*-
"""
gen_disasm.py — 生成 MaxHook.dll 明文区系统反汇编
1. 原始 .text (RVA 0x10000, 含真实 anti-cheat 代码如 net/minecraft 匹配器)
2. 解压区明文区 (0x980000-0xB00000, VM handler + 壳运行时)
输出: .asm 文件, RIP-relative 引用 .rdata/.data 的指令标注字符串
"""
import struct, re
from capstone import Cs, CS_ARCH_X86, CS_MODE_64

path = r'E:/MCLDownload/Game/.minecraft/native/MaxHook.dll'
data = open(path, 'rb').read()
boot = open(r'E:/Coding/S1mple/target/boot_unpacked.bin','rb').read()
BASE = 0x180000000

# 节表
e_lfanew = struct.unpack('<I', data[0x3C:0x40])[0]
coff = e_lfanew + 4
_, nsects, _, _, _, _, _ = struct.unpack('<HHIIIHH', data[coff:coff+20])
opt = coff + 20
sec_off = opt + 240
sections = []
for i in range(nsects):
    name = data[sec_off+i*40:sec_off+i*40+8].rstrip(b'\x00').decode(errors='replace')
    vsize, vaddr, rsize, raddr = struct.unpack('<IIII', data[sec_off+i*40+8:sec_off+i*40+24])
    sections.append((name, vaddr, vsize, raddr, rsize))
def off2va_rdata(off):
    """文件偏移 -> (RVA, 节名), 用于字符串归属"""
    for n, v, vs, ra, rs in sections:
        if ra <= off < ra + rs:
            return v + (off - ra), n
    return None, None

# 收集 .rdata/.data 明文串: (rva, 串)
strings = {}
# 全文件字符串收集 (含 .text 内嵌串)
def fileoff_to_va(off):
    for n, v, vs, ra, rs in sections:
        if ra <= off < ra + rs:
            return BASE + v + (off - ra)
    return None
for m in re.finditer(rb'[\x20-\x7e]{6,}', data):
    va = fileoff_to_va(m.start())
    if va:
        strings[va] = m.group().decode('latin1')

md = Cs(CS_ARCH_X86, CS_MODE_64)

import collections, math
def entropy(b):
    c = collections.Counter(b); n = len(b)
    if n == 0: return 0
    return -sum((v/n)*math.log2(v/n) for v in c.values())

def disasm_region(region_data, region_va, region_off_in_file, label, out_path):
    """分块反汇编区域: 每 0x1000 一块, 熵<6.5 视为代码块才反汇编"""
    lines = [f"; {label}", f"; 反汇编区域: {region_va:#x} 大小 {len(region_data):#x}", ""]
    md.skipdata = True  # 无效字节自动跳过 (.byte)
    total_insn = 0
    for insn in md.disasm(region_data, region_va):
        ann = ''
        if insn.mnemonic == 'lea' and 'rip' in insn.op_str:
            try:
                import re as _re
                mm = _re.search(r'rip \+ (0x[0-9a-f]+)', insn.op_str)
                if mm:
                    target = insn.address + insn.size + int(mm.group(1), 16)
                    if target in strings:
                        ann = f'  ; str: {strings[target][:60]!r}'
            except Exception:
                pass
        lines.append(f"{insn.address:#x}: {insn.mnemonic:10s} {insn.op_str}{ann}")
        total_insn += 1
        if total_insn > 3000000:
            lines.append("; ...截断...")
            break
    open(out_path, 'w', encoding='utf-8', errors='replace').write('\n'.join(lines))
    print(f"[*] {out_path}: {len(lines)} 行, {total_insn} 条指令")

# 1. 原始 .text 反汇编 (RVA 0x10000, raw 0x400)
text_raw = data[0x400:0x400+0x5c2800]
disasm_region(text_raw, BASE + 0x10000, 0x400, "原始 .text (真实 anti-cheat 代码 + WinLicense stub)", 
              r'E:\Coding\S1mple\target\disasm_text.asm')

# 2. 解压区明文区反汇编 (0x980000-0xB00000)
disasm_region(boot[:0x300000], BASE + 0x980000, None,
              "解压区明文区 (Themida VM handler + 壳运行时)", 
              r'E:\Coding\S1mple\target\disasm_unpacked.asm')

# 3. 字符串表导出
print(f"[*] .rdata/.data 字符串总数: {len(strings)}")
with open(r'E:\Coding\S1mple\target\strings_table.txt', 'w', encoding='utf-8', errors='replace') as f:
    for rva in sorted(strings):
        f.write(f"{BASE+rva:#x}\t{strings[rva]!r}\n")
print("[*] strings_table.txt 已生成")
