# -*- coding: utf-8 -*-
import re, struct

path = r'E:/MCLDownload/Game/.minecraft/native/MaxHook.dll'
data = open(path, 'rb').read()
print("扫描字符串中...")

# UTF-8 可读字符串
strs = re.findall(rb'[\x20-\x7e\xe4-\xe9\x80-\xbf]{5,}', data)
decoded = []
for s in strs:
    try:
        t = s.decode('utf-8')
        if any(c.isalpha() for c in t):
            decoded.append(t)
    except Exception:
        pass
print("ASCII/UTF-8 字符串总数:", len(decoded))

# 敏感关键词
keywords = ['detect', 'hook', 'cheat', 'inject', 'dll', 'process', 'thread', 'window', 'network', 'socket',
            'proxy', 'packet', 'memory', 'scan', 'debug', 'virtual', 'alloc', 'protect', 'module', 'bypass',
            'anti', 'kick', 'ban', 'verify', 'integrity', 'signature', 'hash', 'crash', 'exception', 'veh',
            'minhook', 'detour', 'trampoline', 'iat', 'inline', 'md5', 'sha', 'aes', 'xor', 'encrypt',
            'magnet', 'wechat', 'qq', 'driver', 'sys', 'registry', 'mutex', 'event', 'timer', 'heartbeat',
            '他妈的', '作弊', '检测', '异常', '代理', '修改', '注入', '内存']
hits = {}
for k in keywords:
    kk = k.lower()
    cnt = sum(1 for t in decoded if kk in t.lower())
    if cnt:
        hits[k] = cnt
print("=== 关键词命中 ===")
for k, c in sorted(hits.items(), key=lambda x: -x[1]):
    print(f"  {k}: {c}")
    for t in decoded:
        if k.lower() in t.lower():
            print("    e.g.", t[:150])
            break

# 特殊标记字符串（#1 #2 等编号可能是错误码，找对应）
print("\n=== 含 # 编号的字符串 ===")
for t in decoded:
    if re.match(r'^#\d', t):
        print(" ", t[:120])
