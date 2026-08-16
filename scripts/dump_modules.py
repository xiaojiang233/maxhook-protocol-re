#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
枚举 javaw 进程的所有已加载模块 (DLL 基址表)
用途: 把 MaxHook 解析出的 API 函数指针 (0x7ff8...) 映射到具体 DLL+函数

用法:
  python dump_modules.py            # 自动找 javaw
  python dump_modules.py <PID>      # 指定进程
输出: modules_<pid>.txt  (base, size, name, path)
"""
import ctypes
import ctypes.wintypes
import sys
import os

TH32CS_SNAPMODULE = 0x00000008
TH32CS_SNAPMODULE32 = 0x00000010
TH32CS_SNAPPROCESS = 0x00000002


class MODULEENTRY32W(ctypes.Structure):
    _fields_ = [
        ("dwSize", ctypes.wintypes.DWORD),
        ("th32ModuleID", ctypes.wintypes.DWORD),
        ("th32ProcessID", ctypes.wintypes.DWORD),
        ("GlblcntUsage", ctypes.wintypes.DWORD),
        ("ProccntUsage", ctypes.wintypes.DWORD),
        ("modBaseAddr", ctypes.c_void_p),
        ("modBaseSize", ctypes.wintypes.DWORD),
        ("hModule", ctypes.c_void_p),
        ("szModule", ctypes.c_wchar * 256),
        ("szExePath", ctypes.c_wchar * 260),
    ]


class PROCESSENTRY32W(ctypes.Structure):
    _fields_ = [
        ("dwSize", ctypes.wintypes.DWORD),
        ("cntUsage", ctypes.wintypes.DWORD),
        ("th32ProcessID", ctypes.wintypes.DWORD),
        ("th32DefaultHeapID", ctypes.c_void_p),
        ("th32ModuleID", ctypes.wintypes.DWORD),
        ("cntThreads", ctypes.wintypes.DWORD),
        ("th32ParentProcessID", ctypes.wintypes.DWORD),
        ("pcPriClassBase", ctypes.c_long),
        ("dwFlags", ctypes.wintypes.DWORD),
        ("szExeFile", ctypes.c_wchar * 260),
    ]


def find_pid(name="javaw"):
    k32 = ctypes.windll.kernel32
    snap = k32.CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe = PROCESSENTRY32W()
    pe.dwSize = ctypes.sizeof(PROCESSENTRY32W)
    pids = []
    if k32.Process32FirstW(snap, ctypes.byref(pe)):
        while True:
            if name.lower() in pe.szExeFile.lower():
                pids.append(pe.th32ProcessID)
            if not k32.Process32NextW(snap, ctypes.byref(pe)):
                break
    k32.CloseHandle(snap)
    return pids


def dump_modules(pid):
    k32 = ctypes.windll.kernel32
    out = []
    for flags in (TH32CS_SNAPMODULE, TH32CS_SNAPMODULE32):
        snap = k32.CreateToolhelp32Snapshot(flags, pid)
        if snap == ctypes.c_void_p(-1).value or snap == -1:
            continue
        me = MODULEENTRY32W()
        me.dwSize = ctypes.sizeof(MODULEENTRY32W)
        try:
            if k32.Module32FirstW(snap, ctypes.byref(me)):
                while True:
                    out.append((me.modBaseAddr, me.modBaseSize,
                                me.szModule, me.szExePath))
                    if not k32.Module32NextW(snap, ctypes.byref(me)):
                        break
        finally:
            k32.CloseHandle(snap)
    # 去重
    seen = set()
    uniq = []
    for b, s, n, p in out:
        if b not in seen:
            seen.add(b)
            uniq.append((b, s, n, p))
    return uniq


def main():
    args = sys.argv[1:]
    pid = None
    if args and args[0].isdigit():
        pid = int(args[0])
    if pid is None:
        pids = find_pid()
        if not pids:
            print("[!] 找不到 javaw 进程 (请先启动游戏)", flush=True)
            sys.exit(1)
        pid = pids[0]
        print(f"[*] 目标进程: {pid}", flush=True)

    mods = dump_modules(pid)
    print(f"[*] 模块数: {len(mods)}", flush=True)
    outpath = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                           f"modules_{pid}.txt")
    with open(outpath, "w", encoding="utf-8") as f:
        for b, s, n, p in mods:
            f.write(f"{b:#x},{s:#x},{n},{p}\n")
            print(f"  {b:#x}  {s:#x}  {n}", flush=True)
    print(f"[*] 已保存: {outpath}", flush=True)


if __name__ == "__main__":
    main()
