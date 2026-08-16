# -*- coding: utf-8 -*-
"""
trace_trap_tsc.py — 反模拟时间戳对策版
对全部 RDTSC/CPUID 指令位置加精准 hook:
  - RDTSC: 返回递增时间戳 (模拟真实 3GHz 周期计数)
  - CPUID: 返回真实硬件特征 (hypervisor 位=0)
  - 时间 API (GetSystemTimeAsFileTime/QueryPerformanceCounter/GetTickCount): 递增
"""
import struct, time, os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from unicorn import *
from unicorn.x86_const import *
from winenv import WinEnv

path = r'E:/MCLDownload/Game/.minecraft/native/MaxHook.dll'
data = open(path, 'rb').read()
BASE = 0x180000000
STACK_BASE = 0x7FFE000000
STACK_SIZE = 0x800000
RSP = STACK_BASE + STACK_SIZE - 0x1000
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
uc.mem_map(STACK_BASE, STACK_SIZE)
uc.reg_write(UC_X86_REG_RSP, RSP)
uc.mem_write(RSP, struct.pack('<QQQQ', 0, BASE, 1, 0))
print("HEAD OK")
