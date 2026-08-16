# -*- coding: utf-8 -*-
"""扫描 MaxHook.dll：环境收集清单（工具/进程/路径/API）"""
import re

path = r'E:/MCLDownload/Game/.minecraft/native/MaxHook.dll'
data = open(path, 'rb').read()

def get_strings(data):
    out = []
    # ASCII
    for m in re.finditer(rb'[\x20-\x7e]{5,}', data):
        out.append(m.group().decode('ascii', errors='replace'))
    return out

strs = get_strings(data)
print("字符串总数:", len(strs))

# 1. 抓包/调试/代理/作弊工具关键词
tools = {
    'wireshark': r'wireshark|Wireshark|dumpcap|tshark',
    'npcap/winpcap': r'npcap|winpcap|packet\.dll|wpcap',
    'fiddler/charles': r'fiddler|charles|httpdebugger',
    'proxifier/代理': r'proxifier|clash|v2ray|shadowsocks|xray|sing-box|mitmproxy|burp',
    '调试器': r'ollydbg|x64dbg|x32dbg|windbg|ida64|ida\.exe|ghidra|dnspy',
    'ce/修改器': r'cheat.?engine|cheatengine|artmoney|gameguard|wpe',
    '进程工具': r'processhacker|procmon|tcpview|sysinternals|autoruns|regmon|filemon',
    'hook/注入': r'minhook|detours|easilyhook|fasm|injector|dll.?inject|wintools',
    'vm/沙箱': r'vmware|virtualbox|qemu|sandboxie|vbox|hyper-v',
    '网络工具': r'nmap|netcat|nc\.exe|putty|winscp|mobaxterm|ping\.exe|tracert|netsh',
}
print("\n=== 工具检测关键词命中 ===")
for name, pat in tools.items():
    found = set()
    for s in strs:
        if re.search(pat, s, re.I):
            found.add(s[:80])
    print(f"\n[{name}] {len(found)} 个")
    for f in sorted(found)[:10]:
        print("   ", f)

# 2. 进程枚举/API
print("\n=== 进程/系统 API（含混淆）===")
api_pat = re.compile(r'^(CreateToolhelp32Snapshot|Process32First|Process32Next|EnumProcesses|OpenProcess|ReadProcessMemory|WriteProcessMemory|VirtualAllocEx|CreateRemoteThread|NtQuerySystemInformation|QueryFullProcessImageName|GetProcessImageFileName|GetModuleFileNameEx|OpenThread|SuspendThread|ResumeThread|SetWindowsHookEx|CallNextHookEx|GetForegroundWindow|GetWindowText|EnumWindows|IsDebuggerPresent|CheckRemoteDebuggerPresent|OutputDebugString|NtQueryInformationProcess|GetTickCount|QueryPerformanceCounter|GetSystemInfo|GlobalMemoryStatusEx|GetDiskFreeSpaceEx|GetLogicalDrives|GetDriveType|GetVolumeInformation|ExpandEnvironmentStrings|GetEnvironmentVariable|GetTempPath|SHGetFolderPath|GetModuleBaseName|EnumProcessModules|GetProcAddress|LoadLibrary|VirtualQuery|VirtualProtect|NtProtectVirtualMemory)[A-Za-z0-9]*$')
apis = {}
for s in strs:
    if api_pat.match(s):
        apis[s] = apis.get(s, 0) + 1
print("发现的 API 名:")
for a in sorted(apis)[:40]:
    print("   ", a)

# 3. 路径类字符串（%TEMP%、.minecraft、native 等）
print("\n=== 路径相关 ===")
path_hits = set()
for s in strs:
    if re.search(r'%[A-Z_]+%|\.minecraft|\\\\|/native|:\\\\|AppData|ProgramData|system32|\\Temp\\|\\mods\\', s):
        path_hits.add(s[:100])
for p in sorted(path_hits)[:25]:
    print("   ", p)
