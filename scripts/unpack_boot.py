# -*- coding: utf-8 -*-
"""
Unicorn 模拟 MaxHook.dll 入口解压流程:
  入口 base+0x1f00058 -> helper 计算 delta -> 检查 [base+0xEFEB27]==0 (BSS 必零)
  -> 循环调用解压例程 base+0x1f0005d (src=base+0x1f00248, dst=base+0xC70000)
  -> 完成后 jmp base+0xEFEB27 (解压后真实入口)
dump 解压后的 .bugland 内存为 boot_unpacked.bin
"""
import struct, sys, time
from unicorn import *
from unicorn.x86_const import *

path = r'E:/MCLDownload/Game/.minecraft/native/MaxHook.dll'
data = open(path, 'rb').read()
BASE = 0x180000000
STACK = 0x50000000
STACK_SIZE = 0x20000
RSP = STACK + STACK_SIZE - 0x1000
ENTRY = BASE + 0x1f00058
REAL_ENTRY = BASE + 0x980000 + 0x28EB27   # = 0x180C0EB27, .bugland 内解压后真实入口
DST_BASE = BASE + 0x980000                # 解压目标 = .bugland 基址
BUGLAND_END = BASE + 0x1EFC000            # .bugland 末尾

# ---- 解析节表 ----
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

# 一次性映射 BASE..最后一个节末尾
last_end = max(vaddr + vsize for _, vaddr, vsize, _, _ in sections)
TOTAL = (last_end + 0xFFF) & ~0xFFF
uc.mem_map(BASE, TOTAL)
uc.mem_write(BASE, data)  # 整文件先映射为底

# 每个节按 VA 写入 raw 内容 / BSS 清零
for name, vaddr, vsize, raddr, rsize in sections:
    va = BASE + vaddr
    if rsize > 0:
        uc.mem_write(va, data[raddr:raddr+rsize])
    if vsize > rsize:
        # BSS 尾巴清零（.bugland 全 BSS；.data/.idata 超 raw 部分）
        uc.mem_write(va + rsize, b'\x00' * (vsize - rsize))


# 栈
uc.mem_map(STACK, STACK_SIZE)
uc.reg_write(UC_X86_REG_RSP, RSP)
# DllMain 调用约定: [rsp]=ret, [rsp+8]=hinstDLL, [rsp+0x10]=reason, [rsp+0x18]=reserved
uc.mem_write(RSP, struct.pack('<QQQQ', 0, BASE, 1, 0))
for r in (UC_X86_REG_RCX, UC_X86_REG_RDX, UC_X86_REG_R8, UC_X86_REG_R9,
          UC_X86_REG_RAX, UC_X86_REG_RBX, UC_X86_REG_RSI, UC_X86_REG_RDI, UC_X86_REG_RBP):
    uc.reg_write(r, 0)
uc.reg_write(UC_X86_REG_RFLAGS, 0x2)

# 到达解压后代码区即停
hit = {'addr': None}
def on_code(uc, address, size, user_data):
    if DST_BASE <= address < BUGLAND_END:
        hit['addr'] = address
        uc.emu_stop()

uc.hook_add(UC_HOOK_CODE, on_code, begin=DST_BASE, end=BUGLAND_END - 1)

t0 = time.time()
try:
    uc.emu_start(ENTRY, 0, timeout=180000, count=0)
    print(f"[*] emu_stop 于 {time.time()-t0:.1f}s, RIP=0x{uc.reg_read(UC_X86_REG_RIP):x}, hit={hex(hit['addr']) if hit['addr'] else None}")
except UcError as e:
    print(f"[!] UcError: {e}  RIP=0x{uc.reg_read(UC_X86_REG_RIP):x} ({time.time()-t0:.1f}s)")

# dump 解压区
out = uc.mem_read(DST_BASE, BUGLAND_END - DST_BASE)
nz = len(out) - len(out.rstrip(b'\x00'))
print(f"[*] 解压区大小: {len(out)} 最后非零偏移: {nz:#x} ({nz/1024/1024:.1f}MB)")
with open(r'E:/Coding/S1mple/target/boot_unpacked.bin', 'wb') as f:
    f.write(out)
print(f"[*] 已保存 boot_unpacked.bin ({len(out)} bytes)")

# 验证真实入口内容
ent = uc.mem_read(REAL_ENTRY, 64)
print(f"[*] 真实入口 0x{REAL_ENTRY:x} 头 32 字节: {ent[:32].hex()}")
print(f"    ASCII: {repr(ent[:32])}")
