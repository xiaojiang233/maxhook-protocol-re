# -*- coding: utf-8 -*-
import re
path = r'E:/MCLDownload/Game/.minecraft/native/MaxHook.dll'
data = open(path, 'rb').read()
strs = re.findall(rb'[\x20-\x7e]{6,}', data)
decoded = [s.decode('ascii', errors='replace') for s in strs]

print("=== URL 相关 ===")
for t in decoded:
    if re.search(r'https?://|\.com|\.cn|\.net/|\.io/|api[.\-/]|/report|/upload|/submit', t, re.I) and len(t) < 120:
        print(" ", t[:110])

print("\n=== heypixel.log / 日志格式 ===")
for t in decoded:
    if 'heypixel' in t.lower() or ('#%d' in t) or ('%dms' in t) or ('%d - ' in t) or ('#1' in t and len(t) < 80):
        print(" ", t[:110])

print("\n=== 上报/验证相关 ===")
for kw in ['report', 'verify', 'validate', 'token', 'handshake', 'auth', 'secret', 'key', 'session', 'server_id', 'serverId', 'client_id']:
    for t in decoded:
        if kw.lower() in t.lower() and len(t) < 100 and not t.startswith('#'):
            print(f"  [{kw}]", t[:100])
            break
