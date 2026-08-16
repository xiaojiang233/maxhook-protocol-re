# -*- coding: utf-8 -*-
"""完整解析 MaxHook.dll 导入表：所有 DLL + 全部函数"""
import struct
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
def rva2off(rva):
    for n, va, vs, ra, rs in sections:
        if va <= rva < va + vs:
            return ra + (rva - va)
    return None
imp_rva = struct.unpack('<I', data[opt+120:opt+124])[0]
off = rva2off(imp_rva)
print("import RVA:", hex(imp_rva), "offset:", hex(off))
idx = 0
while off and off + idx + 20 <= len(data):
    entry = struct.unpack('<IIIII', data[off+idx:off+idx+20])
    if not any(entry):
        break
    name_rva = entry[3]
    noff = rva2off(name_rva)
    if noff:
        end = data.find(b'\x00', noff)
        dll = data[noff:end].decode(errors='replace')
        print(f"\n### {dll}")
        oft = entry[0] if entry[0] else entry[4]
        if not oft:
            idx += 20
            continue
        toff = rva2off(oft)
        f_idx = 0
        funcs = []
        while toff and toff + f_idx*8 + 8 <= len(data):
            val = struct.unpack('<Q', data[toff+f_idx*8:toff+f_idx*8+8])[0]
            if not val:
                break
            if val & 0x8000000000000000:
                funcs.append(f"ord{val & 0xFFFF}")
            else:
                hn = rva2off(val & 0x7FFFFFFF)
                if hn:
                    nm = data[hn+2:data.find(b'\x00', hn+2)].decode(errors='replace')
                    funcs.append(nm)
            f_idx += 1
        print("  ", ", ".join(funcs) if funcs else "(none)")
    idx += 20
