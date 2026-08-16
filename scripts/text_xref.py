# -*- coding: utf-8 -*-
"""扫描 .text 中引用 .boot/.data 节的立即数 → 定位解密例程"""
import struct
path = r'E:/MCLDownload/Game/.minecraft/native/MaxHook.dll'
data = open(path, 'rb').read()
e_lfanew = struct.unpack('<I', data[0x3C:0x40])[0]
coff = e_lfanew + 4
_, nsects, _, _, _, _, _ = struct.unpack('<HHIIIHH', data[coff:coff+20])
opt = coff + 20
image_base = struct.unpack('<Q', data[opt+24:opt+32])[0]
sec_off = opt + 240
sections = []
for i in range(nsects):
    name = data[sec_off+i*40:sec_off+i*40+8].rstrip(b'\x00').decode(errors='replace')
    vsize, vaddr, rsize, raddr = struct.unpack('<IIII', data[sec_off+i*40+8:sec_off+i*40+24])
    sections.append((name, vaddr, vsize, raddr, rsize))
    print(f"section {name}: VA={hex(vaddr)} VSize={hex(vsize)} Raw={hex(raddr)} RSize={hex(rsize)}")
print("ImageBase:", hex(image_base))

def section_of_va(va):
    for n, v, vs, ra, rs in sections:
        if v <= va < v + vs:
            return n
    return None

def va_to_off(va):
    for n, v, vs, ra, rs in sections:
        if v <= va < v + vs:
            return ra + (va - v)
    return None

text_off = None
text_va = None
text_size = None
for n, v, vs, ra, rs in sections:
    if n == '.text':
        text_off, text_va, text_size = ra, v, vs

print(f"\n=== .text 中引用 .boot/.data 的 32 位立即数 (lea/mov reg, [imm]) ===")
boot_va = None
data_va = None
for n, v, vs, ra, rs in sections:
    if n == '.boot':
        boot_va = v
    if n == '.data':
        data_va = v
print(f".boot VA={hex(boot_va) if boot_va else '?'}  .data VA={hex(data_va) if data_va else '?'}")

# 扫描 .text 里的 lea/mov 32位立即数模式：48 8D 05/0D/15/1D xx xx xx xx (RIP-relative)
# 以及 48 C7 C0 imm32 / B8 imm32 (mov eax, imm32) 等
hits = []
i = text_off
end = text_off + text_size
while i < end - 4:
    b = data[i]
    # RIP-relative LEA: 48 8D 05/0D/15/1D/35/3D disp32 ; 4C 8D 05...
    if b == 0x48 or b == 0x4C:
        if data[i+1] == 0x8D and data[i+2] in (0x05, 0x0D, 0x15, 0x1D, 0x25, 0x2D, 0x35, 0x3D):
            disp = struct.unpack('<i', data[i+3:i+7])[0]
            target = (text_va + (i - text_off) + 7 + disp)  # 指令长度 7
            sec = section_of_va(target)
            if sec in ('.boot', '.data', '.rdata', '.detourc', '.detourd', '.fptable'):
                hits.append((i, 'lea', hex(target), sec))
            i += 7
            continue
        i += 1
        continue
    # mov reg, imm32 (B8+r / 48 C7 C0)
    if b == 0xB8 or b == 0xB9 or b == 0xBA or b == 0xBB or b == 0xBC or b == 0xBD or b == 0xBE or b == 0xBF:
        imm = struct.unpack('<I', data[i+1:i+5])[0]
        if imm >= 0x10000:
            sec = section_of_va(image_base + imm) if image_base + imm < 0x7FFFFFFFFFFFFFFF else None
            # 也试试直接 VA 匹配
            if sec is None:
                sec = section_of_va(imm)
            if sec in ('.boot', '.data', '.rdata'):
                hits.append((i, 'mov', hex(imm), sec))
        i += 5
        continue
    i += 1

print(f"找到 {len(hits)} 处引用")
from collections import Counter
cnt = Counter(h[3] for h in hits)
print("按节分布:", dict(cnt))
# 显示前 40 个 .boot 引用
boot_hits = [h for h in hits if h[3] == '.boot']
print(f"\n=== .boot 引用 {len(boot_hits)} 处（前 60）===")
for off, kind, target, sec in boot_hits[:60]:
    print(f"  .text+{hex(off-text_off)}: {kind} {target}")
