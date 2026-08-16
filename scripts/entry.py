# -*- coding: utf-8 -*-
"""反汇编入口点 + TLS 回调 + 找解密循环"""
import struct
from capstone import Cs, CS_ARCH_X86, CS_MODE_64

path = r'E:/MCLDownload/Game/.minecraft/native/MaxHook.dll'
data = open(path, 'rb').read()
e_lfanew = struct.unpack('<I', data[0x3C:0x40])[0]
coff = e_lfanew + 4
machine, nsects, ts, psym, nsym, optsize, chars = struct.unpack('<HHIIIHH', data[coff:coff+20])
opt = coff + 20
entry_rva = struct.unpack('<I', data[opt+16:opt+20])[0]
image_base = struct.unpack('<Q', data[opt+24:opt+32])[0]
sec_off = opt + 240
sections = []
for i in range(nsects):
    name = data[sec_off+i*40:sec_off+i*40+8].rstrip(b'\x00').decode(errors='replace')
    vsize, vaddr, rsize, raddr = struct.unpack('<IIII', data[sec_off+i*40+8:sec_off+i*40+24])
    sections.append((name, vaddr, vsize, raddr, rsize))
def va_to_off(va):
    for n, v, vs, ra, rs in sections:
        if v <= va < v + vs:
            return ra + (va - v)
    return None

print("EntryPoint RVA:", hex(entry_rva), " ImageBase:", hex(image_base))

# 入口点反汇编（前 300 条）
ep_off = va_to_off(entry_rva)
print(f"\n=== 入口点反汇编 ({hex(ep_off)}) 前 300 条 ===")
md = Cs(CS_ARCH_X86, CS_MODE_64)
md.detail = False
code = data[ep_off:ep_off+2000]
for insn in md.disasm(code, image_base + entry_rva):
    print(f"  {insn.address:#x}: {insn.mnemonic:8s} {insn.op_str}")
    if insn.mnemonic == 'ret' and insn.op_str == '':
        break

# TLS 回调（.tls 节 + 数据目录 index 9）
tls_rva = struct.unpack('<I', data[opt+144:opt+148])[0]
print(f"\nTLS directory RVA: {hex(tls_rva)}")
toff = va_to_off(tls_rva)
if toff and toff + 40 <= len(data):
    # IMAGE_TLS_DIRECTORY64: StartAddressOfRawData, EndAddressOfRawData, AddressOfIndex, AddressOfCallBacks, SizeOfZeroFill, Characteristics
    start, end, idx, callbacks = struct.unpack('<QQQQ', data[toff:toff+32])
    print(f"  callbacks VA: {hex(callbacks)}")
    coff_call = va_to_off(callbacks - image_base) if callbacks > image_base else va_to_off(callbacks)
    if coff_call and coff_call + 8 <= len(data):
        cb = struct.unpack('<Q', data[coff_call:coff_call+8])[0]
        print(f"  TLS 回调[0]: {hex(cb)}")
        cb_off = va_to_off(cb - image_base) if cb > image_base else va_to_off(cb)
        if cb_off:
            print(f"  === TLS 回调反汇编 ===")
            ccode = data[cb_off:cb_off+512]
            for insn in md.disasm(ccode, cb):
                print(f"    {insn.address:#x}: {insn.mnemonic:8s} {insn.op_str}")
                if insn.mnemonic == 'ret':
                    break

# 快速测试 .boot 解密：常见 XOR key
print("\n=== .boot 头 32 字节 ===")
boot_va = None
for n, v, vs, ra, rs in sections:
    if n == '.boot':
        boot_va, boot_off, boot_size = v, ra, rs
print(' '.join(f'{b:02x}' for b in data[boot_off:boot_off+32]))
for key in [0xFF, 0xAA, 0x55, 0x00, 0x88, 0xCC, 0x66, 0x99]:
    dec = bytes(b ^ key for b in data[boot_off:boot_off+64])
    printable = sum(1 for b in dec if 0x20 <= b < 0x7f)
    print(f"  XOR {key:#04x}: printable={printable}/64 head={dec[:16]!r}")
