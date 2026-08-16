# -*- coding: utf-8 -*-
import re

path = r'E:/MCLDownload/Game/.minecraft/native/MaxHook.dll'
data = open(path, 'rb').read()

strs = re.findall(rb'[\x20-\x7e]{6,}', data)
decoded = [s.decode('ascii', errors='replace') for s in strs]
print("ASCII 字符串总数:", len(decoded))

# Windows API 名（GetProcAddress 动态加载的 API）
api_pattern = re.compile(r'^(Nt|Zw|Create|Open|Read|Write|Virtual|Alloc|Free|Load|Get|Set|Reg|Hook|Detour|WSA|socket|connect|send|recv|Internet|WinHttp|Query|Enum|Terminate|Suspend|Resume|Peek|Map|Unmap|Heap|Thread|Process|System|NtQuery|DeviceIo|Copy|Move)[A-Za-z0-9]+[A-Za-z]$')
apis = {}
for t in decoded:
    if api_pattern.match(t) and len(t) < 60:
        apis[t] = apis.get(t, 0) + 1
print("=== 可能的 Windows API 名 ===")
for a, c in sorted(apis.items(), key=lambda x: -x[1]):
    if c >= 1:
        print(f"  {a} x{c}")
