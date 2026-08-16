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

def rva_to_offset(rva):
    va = BASE + rva
    for (name, sec_va, vsz, raw, rsz) in sections:
        if sec_va <= va < sec_va + max(vsz, rsz):
            return raw + (va - sec_va)
    return None

def read_at(rva, size):
    off = rva_to_offset(rva)
    if off is None: return None
    return data[off:off+size]

def u32(rva):
    b = read_at(rva, 4)
    return struct.unpack('<I', b)[0] if b else None

def u64(rva):
    b = read_at(rva, 8)
    return struct.unpack('<Q', b)[0] if b else None

# Function pointer table at 0x1807d7c70 (rbx/r15)
print("=== function pointer table @ 0x7d7c70 ===")
for i in range(32):
    v = u64(0x7d7c70 + i*8)
    if v is None: break
    print(f"  [0x7d7c70+{i*8:#x}] = {v:#x}  (rva {v-BASE:#x})")

# Byte/word table at 0x1807d7cf0 (r12/r14)
print("\n=== dword table @ 0x7d7cf0 (r12) ===")
for i in range(48):
    v = u32(0x7d7cf0 + i*4)
    if v is None: break
    print(f"  [0x7d7cf0+{i*4:#x}] = {v:#010x}")

# Runtime globals (opaque constants) — these are in .data, likely zero in static file
print("\n=== runtime globals referenced ===")
globals_list = [
    (0x894b04, "rot key (first)"),
    (0x894aec, "rot key 2"),
    (0x894b00, "rot key 3"),
    (0x894ae8, "rot key 4"),
    (0x894afc, "rot key 5"),
    (0x894af4, "rot key 6"),
    (0x894af0, "rot key 7"),
    (0x894af8, "rot key 8"),
    (0x7d78c8, "opaque 1"),
    (0x7d7930, "opaque ptr 1"),
    (0x7d78dc, "opaque 2"),
    (0x7d78cc, "opaque 3"),
    (0x7d78d4, "opaque 4"),
    (0x7d7928, "opaque ptr 2"),
    (0x7d78d0, "opaque 5"),
    (0x7d78d8, "opaque 6"),
    (0x7d78e4, "opaque 7"),
    (0x7d7938, "opaque ptr 3"),
    (0x7d78e0, "opaque 8"),
    (0x7d78fc, "opaque 9"),
    (0x7d78ec, "opaque 10"),
    (0x7d7920, "opaque ptr 4"),
    (0x7d78f8, "opaque 11"),
    (0x7d78f4, "opaque 12"),
    (0x7d7950, "opaque ptr 5"),
    (0x7d7900, "opaque 13"),
    (0x7d78f0, "opaque 14"),
    (0x7d7910, "opaque 15"),
    (0x7d78e8, "opaque 16"),
    (0x7d7948, "opaque ptr 6"),
    (0x7d7918, "opaque ptr 7"),
    (0x7d7958, "opaque ptr 8"),
    (0x7d7940, "opaque ptr 9"),
    (0x7d7908, "opaque ptr 10"),
]
for rva, label in globals_list:
    b = read_at(rva, 8)
    if b is None:
        print(f"  {rva:#x} {label}: <not mapped>")
    else:
        print(f"  {rva:#x} {label}: raw={b.hex()}")
