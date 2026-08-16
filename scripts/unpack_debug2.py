# -*- coding: utf-8 -*-
"""深度调试: 抓取解压中断原因"""
import struct, time
from unicorn import *
from unicorn.x86_const import *

path = r'E:/MCLDownload/Game/.minecraft/native/MaxHook.dll'
data = open(path, 'rb').read()
BASE = 0x180000000
STACK = 0x50000000
RSP = STACK + 0x1F000
ENTRY = BASE + 0x1f00058
DST_BASE = BASE + 0x980000

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

# 观察关键点
events = []
def on_insn(uc, address, size, ud):
    if address in (BASE+0x1f0018e, BASE+0x1f001a5):
        ecx = uc.reg_read(UC_X86_REG_ECX) & 0xFFFFFFFF
        rsi = uc.reg_read(UC_X86_REG_RSI); rdi = uc.reg_read(UC_X86_REG_RDI)
        rax = uc.reg_read(UC_X86_REG_RAX)
        print(f"[rep movsb @{address-BASE:#x}] ecx={ecx:#x} ({ecx}) rsi={rsi:#x} rdi={rdi:#x} rax={rax:#x}")
    if address == BASE+0x1f001d2:
        print(f"[EOF @{address-BASE:#x}] rdi={uc.reg_read(UC_X86_REG_RDI):#x} (产出 {uc.reg_read(UC_X86_REG_RDI)-DST_BASE:#x} 字节)")
    if address == BASE+0x1f0021e:
        pass
    if address == BASE+0x1f0005d:
        rsp = uc.reg_read(UC_X86_REG_RSP)
        src = struct.unpack('<Q', uc.mem_read(rsp+8, 8))[0]
        dst = struct.unpack('<Q', uc.mem_read(rsp+0x18, 8))[0]
        print(f"[chunk 开始] src={src:#x} dst={dst:#x}")

def on_mem_read(uc, access, address, size, value, ud):
    print(f"[MEM READ {access}] addr={address:#x} size={size}")
    uc.emu_stop()
def on_mem_write(uc, access, address, size, value, ud):
    print(f"[MEM WRITE {access}] addr={address:#x} size={size} (unmapped)")
    uc.emu_stop()

uc.hook_add(UC_HOOK_CODE, on_insn)
uc.hook_add(UC_HOOK_MEM_READ_UNMAPPED, on_mem_read)
uc.hook_add(UC_HOOK_MEM_WRITE_UNMAPPED, on_mem_write)

t0 = time.time()
try:
    uc.emu_start(ENTRY, 0xFFFFFFFFFFFFFFFF, timeout=120000, count=5_000_000_000)
    print(f"[*] 返回 RIP=0x{uc.reg_read(UC_X86_REG_RIP):x} {time.time()-t0:.1f}s")
except UcError as e:
    print(f"[!] UcError {e} RIP=0x{uc.reg_read(UC_X86_REG_RIP):x} {time.time()-t0:.1f}s")
