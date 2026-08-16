# -*- coding: utf-8 -*-
"""分析 MaxHook.dll 的 .detourc/.fptable 节（Detours hook 表）+ 导入表"""
import struct
from capstone import Cs, CS_ARCH_X86, CS_MODE_64

path = r'E:/MCLDownload/Game/.minecraft/native/MaxHook.dll'
data = open(path, 'rb').read()
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

def sec_bytes(name):
    for n, va, vs, ra, rs in sections:
        if n == name:
            return data[ra:ra+rs], va
    return None, None

# .fptable (Detours 固定跳板表)
print("=== .fptable 内容 ===")
fp, fp_va = sec_bytes('.fptable')
print(' '.join(f'{b:02x}' for b in fp[:32]))

# .detourc 反汇编（跳板代码）
print("\n=== .detourc 反汇编（前 80 条指令）===")
dc, dc_va = sec_bytes('.detourc')
md = Cs(CS_ARCH_X86, CS_MODE_64)
md.detail = False
count = 0
for insn in md.disasm(dc, dc_va):
    # 找 jmp/call 到导入表或绝对地址
    print(f"  {insn.address:#x}: {insn.mnemonic} {insn.op_str}")
    count += 1
    if count >= 80:
        break

# 导入表（.idata 节按 PE 解析）
print("\n=== 导入表 ===")
imp_rva = struct.unpack('<I', data[opt+120:opt+124])[0]
imp_size = struct.unpack('<I', data[opt+124:opt+128])[0]
def rva2off(rva):
    for n, va, vs, ra, rs in sections:
        if va <= rva < va + vs:
            return ra + (rva - va)
    return None
off = rva2off(imp_rva)
if off:
    idx = 0
    while True:
        entry = struct.unpack('<IIIIII', data[off+idx:off+idx+20])
        oft, timestamp, fwd, name_rva, iat = entry
        if not any(entry):
            break
        idx += 20
        noff = rva2off(name_rva)
        if noff:
            dll_name = data[noff:data.find(b'\x00', noff)].decode(errors='replace')
            print(f"  DLL: {dll_name}")
