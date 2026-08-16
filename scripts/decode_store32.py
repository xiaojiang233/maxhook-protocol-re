#!/usr/bin/env python3
import struct
import pefile

DLL = r"E:\Coding\S1mple\target\MaxHook.runtime-unpacked.dll"
BASE = 0x180000000

pe = pefile.PE(DLL, fast_load=True)
sections = []
for s in pe.sections:
    name = s.Name.rstrip(b'\x00').decode('ascii', 'replace')
    sections.append((name, pe.OPTIONAL_HEADER.ImageBase + s.VirtualAddress,
                     s.Misc_VirtualSize, s.PointerToRawData, s.SizeOfRawData))
data = open(DLL, 'rb').read()

def read_at(rva, size):
    va = BASE + rva
    for (name, sec_va, vsz, raw, rsz) in sections:
        if sec_va <= va < sec_va + max(vsz, rsz):
            off = raw + (va - sec_va)
            return data[off:off+size]
    return None

# store32 shift-count globals (used to split a u32 into 4 bytes)
# 0x7d78c4 -> cl1 = (global ^ 0xd7) + 0xdf
# 0x7d78bc -> cl2 = (global ^ 0x9d) + 0xfd
# 0x7d78c0 -> cl3 = (global ^ 0xdd)
# These are byte-sized reads (mov ecx, dword; then xor cl; add cl) — only low byte matters
for rva, x, a, name in [
    (0x7d78c4, 0xd7, 0xdf, "shift1 (byte1)"),
    (0x7d78bc, 0x9d, 0xfd, "shift2 (byte2)"),
    (0x7d78c0, 0xdd, 0x00, "shift3 (byte3)"),
]:
    b = read_at(rva, 4)
    g = struct.unpack('<I', b)[0] if b else 0
    low = g & 0xff
    cl = ((low ^ x) + a) & 0xff
    print(f"  {name}: global low-byte = {low:#x}, (global^x)+a = {cl:#x} = {cl}")
    if cl == 8 or cl == 16 or cl == 24:
        print(f"    -> shift by {cl} = standard little-endian byte extraction (byte {cl//8})")

print()
print("If cl1=8, cl2=16, cl3=24 -> store32 = plain little-endian u32 store.")
print("The captured writer records confirm offsets +0/+4/+8... and u32 values,")
print("so store32 is the obfuscated 'mov dword ptr [rcx], edx' — writes 4 bytes LE.")
