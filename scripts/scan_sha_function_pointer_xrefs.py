from pathlib import Path
import pefile,struct
BASE=0x180000000
p=pefile.PE('MaxHook.runtime-unpacked.dll'); raw=Path('MaxHook.runtime-unpacked.dll').read_bytes()
targets={0x18042B840:'sha_init',0x18042B9B0:'sha_update',0x18042BB00:'sha_finalize'}
for target,name in targets.items():
 pat=struct.pack('<Q',target); hits=[]; start=0
 while True:
  i=raw.find(pat,start)
  if i<0:break
  va=None
  for s in p.sections:
   if s.PointerToRawData<=i<s.PointerToRawData+s.SizeOfRawData:
    va=BASE+s.VirtualAddress+(i-s.PointerToRawData);break
  if va is not None:hits.append(hex(va))
  start=i+1
 print(name,hex(target),'qword_hits',len(hits),hits[:100])
