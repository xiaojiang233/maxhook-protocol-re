#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
MaxHook 内存 dump 工具（无特征进程名 / 不注入 / 不附加调试器 / 不暂停目标进程）

用法:
  python dump_process.py               # 自动找 javaw.exe 并 dump
  python dump_process.py <PID>         # 指定进程 ID
  python dump_process.py --name java   # 按进程名模糊匹配 (默认 javaw)

输出:
  dump_out/<pid>/
    regions.csv            区域清单 (base,size,protect,type,file)
    region_<base>.bin      每个可读非映像区域一个文件

说明:
  - 只读取 State=MEM_COMMIT 且非 MEM_IMAGE 的可读区域 (堆/私有分配/映射),
    排除模块映像 (MaxHook 模块我已有 runtime-unpacked dump, 不需要重复)
  - 目标进程全程保持运行, 不做任何修改; 读取失败的区域自动跳过
"""
import ctypes
import ctypes.wintypes
import os
import sys
import time

# ---- Win32 常量 ----
PROCESS_QUERY_INFORMATION = 0x0400
PROCESS_VM_READ = 0x0010
TH32CS_SNAPPROCESS = 0x00000002

MEM_COMMIT = 0x1000
PAGE_READONLY = 0x02
PAGE_READWRITE = 0x04
PAGE_EXECUTE = 0x10
PAGE_EXECUTE_READ = 0x20
PAGE_EXECUTE_READWRITE = 0x40
PAGE_WRITECOPY = 0x08
PAGE_EXECUTE_WRITECOPY = 0x80
MEM_PRIVATE = 0x20000
MEM_MAPPED = 0x40000
MEM_IMAGE = 0x1000000

READABLE_PROTS = {
    PAGE_READONLY, PAGE_READWRITE, PAGE_EXECUTE,
    PAGE_EXECUTE_READ, PAGE_EXECUTE_READWRITE,
    PAGE_WRITECOPY, PAGE_EXECUTE_WRITECOPY,
}


class MEMORY_BASIC_INFORMATION(ctypes.Structure):
    _fields_ = [
        ("BaseAddress", ctypes.c_void_p),
        ("AllocationBase", ctypes.c_void_p),
        ("AllocationProtect", ctypes.wintypes.DWORD),
        ("RegionSize", ctypes.c_size_t),
        ("State", ctypes.wintypes.DWORD),
        ("Protect", ctypes.wintypes.DWORD),
        ("Type", ctypes.wintypes.DWORD),
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


def enable_debug_privilege():
    """提升 SeDebugPrivilege (同用户进程读取一般不需要, 保险起见)"""
    try:
        adv = ctypes.windll.advapi32
        k32 = ctypes.windll.kernel32
        hToken = ctypes.wintypes.HANDLE()
        if not adv.OpenProcessToken(k32.GetCurrentProcess(),
                                    0x0020 | 0x0008,  # ADJUST | QUERY
                                    ctypes.byref(hToken)):
            return
        class LUID(ctypes.Structure):
            _fields_ = [("LowPart", ctypes.wintypes.DWORD),
                        ("HighPart", ctypes.c_long)]
        class LUID_AND_ATTRIBUTES(ctypes.Structure):
            _fields_ = [("Luid", LUID),
                        ("Attributes", ctypes.wintypes.DWORD)]
        class TOKEN_PRIVILEGES(ctypes.Structure):
            _fields_ = [("PrivilegeCount", ctypes.wintypes.DWORD),
                        ("Privileges", LUID_AND_ATTRIBUTES * 1)]
        luid = LUID()
        adv.LookupPrivilegeValueW(None, "SeDebugPrivilege", ctypes.byref(luid))
        tp = TOKEN_PRIVILEGES()
        tp.PrivilegeCount = 1
        tp.Privileges[0].Luid = luid
        tp.Privileges[0].Attributes = 0x00000002  # SE_PRIVILEGE_ENABLED
        adv.AdjustTokenPrivileges(hToken, False, ctypes.byref(tp),
                                  ctypes.sizeof(tp), None, None)
        k32.CloseHandle(hToken)
    except Exception:
        pass


def find_pids(name):
    """按 exe 名模糊查找进程, 返回 [(pid, exe), ...]"""
    k32 = ctypes.windll.kernel32
    snap = k32.CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    if snap == ctypes.c_void_p(-1).value or snap == -1:
        return []
    out = []
    pe = PROCESSENTRY32W()
    pe.dwSize = ctypes.sizeof(PROCESSENTRY32W)
    try:
        if k32.Process32FirstW(snap, ctypes.byref(pe)):
            while True:
                if name.lower() in pe.szExeFile.lower():
                    out.append((pe.th32ProcessID, pe.szExeFile))
                if not k32.Process32NextW(snap, ctypes.byref(pe)):
                    break
    finally:
        k32.CloseHandle(snap)
    return out


def read_region(h, base, size, chunk=4 * 1024 * 1024):
    """分块读取区域, 返回 bytes (部分失败时返回已读部分)"""
    k32 = ctypes.windll.kernel32
    out = bytearray()
    off = 0
    while off < size:
        n = min(chunk, size - off)
        buf = ctypes.create_string_buffer(n)
        got = ctypes.c_size_t(0)
        if not k32.ReadProcessMemory(h, ctypes.c_void_p(base + off), buf, n,
                                     ctypes.byref(got)):
            break  # 区域中途失效, 放弃剩余
        out += buf.raw[:got.value]
        off += got.value
        if got.value == 0:
            break
    return bytes(out)


def dump_process(pid, outdir):
    k32 = ctypes.windll.kernel32
    h = k32.OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ,
                        False, pid)
    if not h:
        err = ctypes.get_last_error()
        print(f"[!] OpenProcess 失败 pid={pid} (err={err})")
        print("    提示: 用管理员身份运行终端再试")
        return False

    os.makedirs(outdir, exist_ok=True)
    regions = []
    addr = 0
    while addr < 0x7FFFFFFFFFFF:
        mbi = MEMORY_BASIC_INFORMATION()
        r = k32.VirtualQueryEx(h, ctypes.c_void_p(addr),
                               ctypes.byref(mbi), ctypes.sizeof(mbi))
        if r == 0:
            break
        size = mbi.RegionSize
        if (mbi.State & MEM_COMMIT) and size > 0:
            prot = mbi.Protect & 0xFF
            typ = mbi.Type
            # 只保留可读 + 非映像 (排除模块文件映射)
            if prot in READABLE_PROTS and not (typ & MEM_IMAGE):
                regions.append((mbi.BaseAddress, size, prot, typ))
        addr += size
        if addr == 0:  # 溢出保护
            break

    print(f"[*] 发现 {len(regions)} 个可读非映像区域")

    csv_lines = ["base,size,protect,type,file"]
    total_bytes = 0
    t0 = time.time()
    for i, (base, size, prot, typ) in enumerate(regions):
        b = base
        if isinstance(b, int):
            base_int = b
        else:
            base_int = b
        fname = f"region_{base_int:016x}.bin"
        data = read_region(h, base_int, size)
        if not data:
            continue
        fpath = os.path.join(outdir, fname)
        with open(fpath, "wb") as f:
            f.write(data)
        typname = {MEM_PRIVATE: "PRIVATE", MEM_MAPPED: "MAPPED"}.get(typ, hex(typ))
        csv_lines.append(f"{base_int:#x},{len(data)},{prot:#x},{typname},{fname}")
        total_bytes += len(data)
        if (i + 1) % 50 == 0:
            el = time.time() - t0
            print(f"    [{i+1}/{len(regions)}] 已写 {total_bytes/1e6:.0f} MB "
                  f"({el:.0f}s)", flush=True)

    with open(os.path.join(outdir, "regions.csv"), "w") as f:
        f.write("\n".join(csv_lines) + "\n")

    k32.CloseHandle(h)
    el = time.time() - t0
    print(f"[*] 完成: {len(csv_lines)-1} 个区域, {total_bytes/1e6:.0f} MB, "
          f"耗时 {el:.0f}s")
    print(f"[*] 输出目录: {outdir}")
    return True


def main():
    enable_debug_privilege()
    args = sys.argv[1:]

    name = "javaw"
    pid = None
    i = 0
    while i < len(args):
        if args[i] == "--name" and i + 1 < len(args):
            name = args[i + 1]
            i += 2
        elif args[i].isdigit():
            pid = int(args[i])
            i += 1
        else:
            i += 1

    if pid is None:
        pids = find_pids(name)
        if not pids:
            print(f"[!] 找不到进程名包含 '{name}' 的进程")
            print("    用法: python dump_process.py <PID> 或 --name <名字>")
            sys.exit(1)
        if len(pids) > 1:
            print(f"[?] 找到多个进程:")
            for p, e in pids:
                print(f"    {p}: {e}")
            pid = pids[0][0]
            print(f"[*] 使用第一个: {pid}")
        else:
            pid = pids[0][0]
            print(f"[*] 目标进程: {pid} ({pids[0][1]})")

    outdir = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                          "dump_out", str(pid))
    dump_process(pid, outdir)


if __name__ == "__main__":
    main()
