import sys, os
sys.path.insert(0, r'E:\Coding\S1mple\target\.pydeps')
import pefile
pe = pefile.PE(r'E:\Coding\S1mple\target\MaxHook.runtime-unpacked.dll', fast_load=True)
ib = pe.OPTIONAL_HEADER.ImageBase
data = open(r'E:\Coding\S1mple\target\MaxHook.runtime-unpacked.dll','rb').read()

def va_to_raw(va):
    for s in pe.sections:
        sva = ib + s.VirtualAddress
        if sva <= va < sva + s.Misc_VirtualSize:
            return s.PointerToRawData + (va - sva)
    return None

for va in [0x180878df8, 0x180878e00, 0x180878e08, 0x1808a4a3c, 0x180879e78, 0x180879e80, 0x180879e88, 0x180879e90, 0x180879ea8, 0x180879eb0, 0x180879ee8]:
    off = va_to_raw(va)
    if off is not None:
        val = data[off:off+8]
        print(f'0x{va:x} raw=0x{off:x} bytes={val.hex()} qwordLE=0x{int.from_bytes(val,"little"):x}')
    else:
        print(f'0x{va:x} -> not mapped')
