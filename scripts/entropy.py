# -*- coding: utf-8 -*-
import struct, math, collections
path = r'E:/MCLDownload/Game/.minecraft/native/MaxHook.dll'
data = open(path, 'rb').read()
e_lfanew = struct.unpack('<I', data[0x3C:0x40])[0]
coff = e_lfanew + 4
_, nsects, _, _, _, _, _ = struct.unpack('<HHIIIHH', data[coff:coff+20])
sec_off = coff + 20 + 240
def entropy(b):
    c = collections.Counter(b)
    n = len(b)
    if n == 0: return 0
    return -sum((v/n)*math.log2(v/n) for v in c.values())
for i in range(nsects):
    name = data[sec_off+i*40:sec_off+i*40+8].rstrip(b'\x00').decode(errors='replace')
    vsize, vaddr, rsize, raddr = struct.unpack('<IIII', data[sec_off+i*40+8:sec_off+i*40+24])
    if rsize > 0:
        chunk = data[raddr:raddr+min(rsize, 200000)]
        e = entropy(chunk)
        # 常见字节
        common = chunk[:64].hex()
        print(f"{name}: rsize={rsize} 熵={e:.2f} head={common[:48]}")
