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
PROCESS_VM_OPERATION = 0x0008
PAGE_NOACCESS = 0x01
PAGE_GUARD = 0x100
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


def read_region(h, base, size, chunk=4 * 1024 * 1024, guard=False):
    """分块读取区域; guard=True 时失败则 VirtualProtectEx 临时解除保护再读"""
    k32 = ctypes.windll.kernel32
    out = bytearray()
    off = 0
    changed = False
    old_prot = ctypes.wintypes.DWORD(0)
    if guard:
        # 先试直接读 (可能部分可读)
        pass
    while off < size:
        n = min(chunk, size - off)
        buf = ctypes.create_string_buffer(n)
        got = ctypes.c_size_t(0)
        ok = k32.ReadProcessMemory(h, ctypes.c_void_p(base + off), buf, n,
                                   ctypes.byref(got))
        if ok and got.value > 0:
            out += buf.raw[:got.value]
            off += got.value
            continue
        if not ok and guard and not changed:
            # 临时改 PAGE_READWRITE (清 GUARD), 整块读
            if k32.VirtualProtectEx(h, ctypes.c_void_p(base), size,
                                    PAGE_READWRITE, ctypes.byref(old_prot)):
                changed = True
                print(f"      [guard 解除] {base:#x} (old={old_prot.value:#x})", flush=True)
                continue
            else:
                break
        break  # 读不动了
    if changed:
        # 恢复原保护 (含 PAGE_GUARD 标志)
        k32.VirtualProtectEx(h, ctypes.c_void_p(base), size, old_prot.value,
                             ctypes.byref(ctypes.wintypes.DWORD(0)))
        print(f"      [guard 恢复] {base:#x}", flush=True)
    return bytes(out)


def dump_process(pid, outdir, all_pages=False):
    k32 = ctypes.windll.kernel32
    h = k32.OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ | PROCESS_VM_OPERATION,
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
            guard = bool(mbi.Protect & PAGE_GUARD)
            if all_pages:
                # 全部已提交区域, NOACCESS 页也标记解除保护; 排除映像避免体积爆炸
                guard = guard or (prot == PAGE_NOACCESS)
                if not (typ & MEM_IMAGE):
                    regions.append((mbi.BaseAddress, size, prot, typ, guard))
            else:
                if prot in READABLE_PROTS and not (typ & MEM_IMAGE):
                    regions.append((mbi.BaseAddress, size, prot, typ, False))
        addr += size
        if addr == 0:
            break

    print(f"[*] 发现 {len(regions)} 个候选区域" + (" (含 guard/NOACCESS)" if all_pages else ""))

    csv_lines = ["base,size,protect,type,guard,file"]
    total_bytes = 0
    t0 = time.time()
    n_guard = 0
    for i, (base, size, prot, typ, guard) in enumerate(regions):
        b = base
        if isinstance(b, int):
            base_int = b
        else:
            base_int = b
        fname = f"region_{base_int:016x}.bin"
        data = read_region(h, base_int, size, guard=guard)
        if not data:
            continue
        fpath = os.path.join(outdir, fname)
        with open(fpath, "wb") as f:
            f.write(data)
        typname = {MEM_PRIVATE: "PRIVATE", MEM_MAPPED: "MAPPED"}.get(typ, hex(typ))
        if guard:
            n_guard += 1
        csv_lines.append(f"{base_int:#x},{len(data)},{prot:#x},{typname},{1 if guard else 0},{fname}")
        total_bytes += len(data)
        if (i + 1) % 100 == 0:
            el = time.time() - t0
            print(f"    [{i+1}/{len(regions)}] 已写 {total_bytes/1e6:.0f} MB "
                  f"({el:.0f}s)", flush=True)

    with open(os.path.join(outdir, "regions.csv"), "w") as f:
        f.write("\n".join(csv_lines) + "\n")

    k32.CloseHandle(h)
    el = time.time() - t0
    print(f"[*] 完成: {len(csv_lines)-1} 个区域, {total_bytes/1e6:.0f} MB, "
          f"耗时 {el:.0f}s (guard 页 {n_guard} 个)")
    print(f"[*] 输出目录: {outdir}")
    return True


def main():
    enable_debug_privilege()
    args = sys.argv[1:]

    name = "javaw"
    pid = None
    all_pages = False
    i = 0
    while i < len(args):
        if args[i] == "--name" and i + 1 < len(args):
            name = args[i + 1]
            i += 2
        elif args[i] in ("--all", "-a"):
            all_pages = True
            i += 1
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
    dump_process(pid, outdir, all_pages=all_pages)


if __name__ == "__main__":
    main()
