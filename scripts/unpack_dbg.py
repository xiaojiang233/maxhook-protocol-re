# -*- coding: utf-8 -*-
"""调试版: trace 入口执行路径, 找解压为何失败"""
import struct, time
from unicorn import *
from unicorn.x86_const import *

path = r'E:/MCLDownload/Game/.minecraft/native/MaxHook.dll'
data = open(path, 'rb').read()
BASE = 0x180000000
STACK = 0x50000000
STACK_SIZE = 0x20000
RSP = STACK + STACK_SIZE - 0x1000
ENTRY = BASE + 0x1f00058
REAL_ENTRY = BASE + 0xEFEB27
DST_BASE = BASE + 0xC70000

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
    if rsize > 0:
        uc.mem_write(va, data[raddr:raddr+rsize])
    if vsize > rsize:
        uc.mem_write(va + rsize, b'\x00' * (vsize - rsize))
uc.mem_map(STACK, STACK_SIZE)
uc.reg_write(UC_X86_REG_RSP, RSP)
uc.mem_write(RSP, struct.pack('<QQQQ', 0, BASE, 1, 0))

# 流起始字节
stream = data[0x896600+0x248:0x896600+0x248+32]
print("stream @0x1f00248:", stream.hex(), repr(stream))

log = []
stop_at = [None]
def trace(uc, address, size, ud):
    if address == ENTRY + 5 or (address == BASE + 0x1f001df):
        pass
    if address == BASE + 0x1f0005d:
        rsp = uc.reg_read(UC_X86_REG_RSP)
        src = struct.unpack('<Q', uc.mem_read(rsp+8, 8))[0]
        dst = struct.unpack('<Q', uc.mem_read(rsp+0x18, 8))[0]
        print(f"[TRACE] 解压例程入口 rsp={rsp:#x} src={src:#x} dst={dst:#x}")
    if address == BASE + 0x1f001d2:
        print("[TRACE] 解压例程结束(EOF) rdi=%#x" % uc.reg_read(UC_X86_REG_RDI))
    if address == BASE + 0x1f0021e:
        print("[TRACE] helper 循环 cl=%#x" % (uc.reg_read(UC_X86_REG_RCX) & 0xFF))
    if address == BASE + 0x1f00246:
        print("[TRACE] jmp rax → %#x" % uc.reg_read(UC_X86_REG_RAX))
        stop_at[0] = uc.reg_read(UC_X86_REG_RAX)
    if address == BASE + 0x1a5:
        print(f"[TRACE] rep movsb @0x1a5 ecx={uc.reg_read(UC_X86_REG_RCX):#x} rsi={uc.reg_read(UC_X86_REG_RSI):#x} rdi={uc.reg_read(UC_X86_REG_RDI):#x}")

uc.hook_add(UC_HOOK_CODE, trace)

t0 = time.time()
try:
    uc.emu_start(ENTRY, 0, timeout=30000, count=0)
    print(f"[*] 返回 RIP=0x{uc.reg_read(UC_X86_REG_RIP):x} ({time.time()-t0:.1f}s) stop={stop_at[0] and hex(stop_at[0])}")
except UcError as e:
    print(f"[!] UcError: {e} RIP=0x{uc.reg_read(UC_X86_REG_RIP):x} ({time.time()-t0:.1f}s)")

# 检查输出区
probe = uc.mem_read(DST_BASE, 0x100)
print("DST_BASE 头 64B:", probe[:64].hex())
