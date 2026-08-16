from pathlib import Path
import struct
BASE=0x180000000
raw=Path('MaxHook.runtime-unpacked.dll').read_bytes()
for target in (0x18042B840,0x18042B9B0,0x18042BB00):
    pat=[]
    # direct E8 rel32 calls
    for i in range(len(raw)-5):
        if raw[i]==0xE8:
            disp=struct.unpack_from('<i',raw,i+1)[0]
            va=BASE+i
            if va+5+disp==target: pat.append((va,'call_rel32'))
    print(hex(target),len(pat))
    for va,k in pat[:100]: print(hex(va),k)
