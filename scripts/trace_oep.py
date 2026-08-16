# -*- coding: utf-8 -*-
"""追踪真实入口执行, 抓取未映射读取地址, 判断是否需要 PEB/TEB"""
import struct, time
from unicorn import *
from unicorn.x86_const import *

path = r'E:/MCLDownload/Game/.minecraft/native/MaxHook.dll'
data = open(path, 'rb').read()
BASE = 0x180000000
STACK = 0x50000000
RSP = STACK + 0x1F000
ENTRY = BASE + 0x1f00058

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

uc = Uc(UC_ARCH_X86, UC_MODE_64)
last_end = max(vaddr + vsize for _, vaddr, vsize, _, _ in sections)
uc.mem_map(BASE, (last_end + 0xFFF) & ~0xFFF)
uc.mem_write(BASE, data)
for name, vaddr, vsize, raddr, rsize in sections:
    va = BASE + vaddr
    if rsize > 0: uc.mem_write(va, data[raddr:raddr+rsize])
    if vsize > rsize: uc.mem_write(va + rsize, b'\x00' * (vsize - rsize))
uc.mem_map(STACK, 0x20000)
uc.reg_write(UC_X86_REG_RSP, RSP)
uc.mem_write(RSP, struct.pack('<QQQQ', 0, BASE, 1, 0))

# 解压到 jmp rax
uc.emu_start(ENTRY, BASE + 0x1f00246, timeout=0, count=0)
rax = uc.reg_read(UC_X86_REG_RAX)
print(f"[*] 解压完成, 真实入口 rax={rax:#x}")

# 追踪入口执行: 记录每次 RIP + 关键寄存器, 上限 3000 条
log = []
def trace(uc, address, size, ud):
    if len(log) >= 3000:
        uc.emu_stop(); return
    rsp = uc.reg_read(UC_X86_REG_RSP)
    log.append((address, rsp))

uc.hook_add(UC_HOOK_CODE, trace)
t0 = time.time()
try:
    uc.emu_start(rax, 0xFFFFFFFFFFFFFFFF, timeout=30000, count=0)
    print(f"[*] 入口执行返回 RIP=0x{uc.reg_read(UC_X86_REG_RIP):x} {time.time()-t0:.1f}s 指令数={len(log)}")
except UcError as e:
    print(f"[!] UcError {e} RIP=0x{uc.reg_read(UC_X86_REG_RIP):x} {time.time()-t0:.1f}s 指令数={len(log)}")

# 分析尾部 30 条指令
print("\n=== 最后 30 条执行 ===")
for addr, rsp in log[-30:]:
    print(f"  RIP=0x{addr:x} rsp=0x{rsp:x}")

# 第一个跨区访问: 检测是否访问 0x7FF000000000+ (用户区) / 0xFFFF (内核)
print("\n=== 执行区间分布 ===")
from collections import Counter
regions = Counter((addr >> 20) for addr, _ in log)
for reg, cnt in sorted(regions.items())[:30]:
    print(f"  {reg*0x100000:#x}: {cnt} 条")
