#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
MaxHook 后台持续监控脚本
抓 VM 初始化瞬间 + 检测周期内的内存变化 (解密窗口)

用法:
  python monitor_javaw.py                 # 等待 javaw 出现后开始监控
  python monitor_javaw.py --pid <PID>     # 指定进程
  python monitor_javaw.py --duration 300  # 监控时长(秒), 默认 300

输出: monitor_out/
  snapshot_<t>.bin        初始化瞬间/检测变化的内存快照
  changes.csv             变化记录 (time, region, offset, size)
  heypixel.log.tail       heypixel.log 尾部跟踪
"""
import ctypes
import ctypes.wintypes
import os
import sys
import time
import struct
import hashlib

PROCESS_QUERY_INFORMATION = 0x0400
PROCESS_VM_READ = 0x0010
TH32CS_SNAPPROCESS = 0x00000002

# MaxHook 模块布局 (固定 ImageBase)
BASE = 0x180000000
BUGLAND = BASE + 0x980000      # .bugland 解压区 (22.5MB)
BUGLAND_SIZE = 0x157C000
CTX_OFF = 0xc000               # VM 上下文区偏移
CTX_SIZE = 0x5000              # 上下文+数据表区

# 需要监控的区域: .bugland 整体 + VM 上下文区
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


def find_pids(name):
    k32 = ctypes.windll.kernel32
    snap = k32.CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    out = []
    pe = PROCESSENTRY32W()
    pe.dwSize = ctypes.sizeof(PROCESSENTRY32W)
    if k32.Process32FirstW(snap, ctypes.byref(pe)):
        while True:
            if name.lower() in pe.szExeFile.lower():
                out.append(pe.th32ProcessID)
            if not k32.Process32NextW(snap, ctypes.byref(pe)):
                break
    k32.CloseHandle(snap)
    return out


def read_mem(h, addr, size):
    """读内存, 失败返回 None"""
    k32 = ctypes.windll.kernel32
    buf = ctypes.create_string_buffer(size)
    got = ctypes.c_size_t(0)
    if k32.ReadProcessMemory(h, ctypes.c_void_p(addr), buf, size, ctypes.byref(got)):
        return buf.raw[:got.value]
    return None


def extract_high_ptrs(data, base_va):
    """从数据中提取高位指针 (>=1TB, 指向 MaxHook/JVM 堆)"""
    out = []
    for i in range(0, len(data) - 8, 8):
        v = struct.unpack_from('<Q', data, i)[0]
        if v >= 0x10000000000 and v < 0x7FF000000000:
            out.append((base_va + i, v))
    return out


def diff_regions(a, b, base_va):
    """逐块比较, 返回 [(offset, size), ...]"""
    n = min(len(a), len(b))
    CH = 0x400
    diffs = []
    off = 0
    while off < n:
        if a[off:off+CH] != b[off:off+CH]:
            s = off
            while off < n and a[off:off+CH] != b[off:off+CH]:
                off += CH
            diffs.append((s, off - s))
        else:
            off += CH
    return diffs


def main():
    args = sys.argv[1:]
    pid = None
    duration = 300
    i = 0
    while i < len(args):
        if args[i] == "--pid" and i + 1 < len(args):
            pid = int(args[i+1]); i += 2
        elif args[i] == "--duration" and i + 1 < len(args):
            duration = int(args[i+1]); i += 2
        else:
            i += 1

    k32 = ctypes.windll.kernel32
    outdir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "monitor_out")
    os.makedirs(outdir, exist_ok=True)
    log_path = r"E:/MCLDownload/Game/.minecraft/heypixel/heypixel.log"

    print("[*] 等待 javaw 进程...", flush=True)
    while pid is None:
        pids = find_pids("javaw")
        if pids:
            pid = pids[0]
            print(f"[*] 发现 javaw: PID={pid}", flush=True)
            break
        time.sleep(1)

    h = k32.OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, False, pid)
    if not h:
        print(f"[!] OpenProcess 失败 (err={ctypes.get_last_error()})，用管理员身份重试", flush=True)
        sys.exit(1)

    # 等待模块加载 (MaxHook 注入)
    print("[*] 等待 MaxHook 模块加载...", flush=True)
    bugland_ctx = None
    for attempt in range(300):
        data = read_mem(h, BUGLAND + CTX_OFF, CTX_SIZE)
        if data and any(data):
            bugland_ctx = data
            print(f"[*] MaxHook 已加载 (等待 {attempt*0.5:.0f}s)", flush=True)
            break
        if attempt % 20 == 19:
            print(f"    ...仍在等待 ({attempt*0.5:.0f}s), 请确认游戏已启动到游戏内", flush=True)
        time.sleep(0.5)
    if bugland_ctx is None:
        print("[!] 150 秒内未检测到 MaxHook 模块", flush=True)
        print("    提示: 确认游戏进程是 javaw.exe, 且已进入游戏世界 (MaxHook 随 mod 加载)", flush=True)
        sys.exit(1)
    print("[*] MaxHook .bugland 已加载, 开始监控", flush=True)

    # 初始全量读取
    prev = read_mem(h, BUGLAND, BUGLAND_SIZE)
    if prev is None:
        print("[!] 读 .bugland 失败", flush=True)
        sys.exit(1)
    prev_ctx = prev[CTX_OFF:CTX_OFF+CTX_SIZE]
    prev_hash = hashlib.md5(prev).hexdigest()
    open(os.path.join(outdir, "baseline.bin"), "wb").write(prev)
    print(f"[*] 基线已保存 (md5={prev_hash[:16]}...)", flush=True)

    changes = []
    t0 = time.time()
    last_log_tail = b""
    n_snap = 0
    seen_ptrs = set()
    last_vm_scan = -1
    while time.time() - t0 < duration:
        now = time.time() - t0
        cur = read_mem(h, BUGLAND, BUGLAND_SIZE)
        if cur is None:
            time.sleep(0.05)
            continue

        # 1. 整体变化检测
        cur_hash = hashlib.md5(cur).hexdigest()
        if cur_hash != prev_hash:
            diffs = diff_regions(prev, cur, BUGLAND)
            if diffs:
                total = sum(sz for _, sz in diffs)
                print(f"[{now:7.1f}s] .bugland 变化: {len(diffs)} 段, {total} 字节", flush=True)
                for off, sz in diffs[:10]:
                    print(f"    @ {BUGLAND+off:#x} +{sz:#x}: {cur[off:off+32].hex()}", flush=True)
                # 保存变化快照
                fn = os.path.join(outdir, f"change_{int(now*1000):08d}.bin")
                blob = bytearray()
                for off, sz in diffs:
                    blob += struct.pack('<QQ', BUGLAND + off, sz) + cur[off:off+sz]
                    changes.append((now, BUGLAND + off, sz))
                open(fn, "wb").write(bytes(blob))
                n_snap += 1
                # 变化区域里的高位指针追踪
                for off, sz in diffs[:20]:
                    for p_va, p in extract_high_ptrs(cur[off:off+sz], BUGLAND+off):
                        print(f"      高位指针: {p:#x}", flush=True)
                        # 尝试读指针指向的内容
                        pdata = read_mem(h, p & ~0xFFF, 0x1000)
                        if pdata:
                            pf = os.path.join(outdir, f"ptr_{p:016x}_{int(now*1000):08d}.bin")
                            open(pf, "wb").write(pdata)
                            print(f"      已存指针区域 {p:#x}", flush=True)
            prev_hash = cur_hash

        # 2. VM 上下文区域变化 (高频关注)
        cur_ctx = cur[CTX_OFF:CTX_OFF+CTX_SIZE]
        if cur_ctx != prev_ctx:
            ctx_diffs = diff_regions(prev_ctx, cur_ctx, BUGLAND + CTX_OFF)
            print(f"[{now:7.1f}s] VM 上下文变化: {len(ctx_diffs)} 段", flush=True)
            for off, sz in ctx_diffs[:8]:
                print(f"    ctx+{off:#x}: {cur_ctx[off:off+16].hex()}", flush=True)
            prev_ctx = cur_ctx

        # 3. heypixel.log 尾部
        try:
            if os.path.exists(log_path):
                sz = os.path.getsize(log_path)
                with open(log_path, 'rb') as f:
                    f.seek(max(0, sz - 2048))
                    tail = f.read()
                if tail != last_log_tail:
                    with open(os.path.join(outdir, "heypixel.log.tail"), "ab") as f:
                        f.write(f"\n--- t={now:.1f}s ---\n".encode())
                        f.write(tail[-1024:])
                    last_log_tail = tail
        except Exception:
            pass

        # 4. VM 虚拟地址区域抓取: 每 5s 扫描 .bugland 高位指针 -> 读指针区域
        if int(now) % 5 == 0 and int(now) != last_vm_scan:
            last_vm_scan = int(now)
            new_ptrs = 0
            for i in range(0, len(cur) - 8, 8):
                v = struct.unpack_from('<Q', cur, i)[0]
                if 0x10000000000 <= v < 0x80000000000:
                    pg = v & ~0xFFF
                    if pg not in seen_ptrs:
                        seen_ptrs.add(pg)
                        pdata = read_mem(h, pg, 0x4000)
                        if pdata and any(pdata):
                            pf = os.path.join(outdir, f"vmsnap_{pg:016x}.bin")
                            open(pf, "wb").write(pdata)
                            new_ptrs += 1
                            print(f"[{now:7.1f}s] VM 虚拟地址 {pg:#x} 已抓 ({len(pdata)}B)", flush=True)
            if new_ptrs:
                print(f"[{now:7.1f}s] 本轮新抓 {new_ptrs} 个 VM 区域", flush=True)

        prev = cur
        time.sleep(0.15)

    k32.CloseHandle(h)
    print(f"[*] 监控结束: {duration}s, 捕获 {n_snap} 个变化快照, {len(changes)} 处变化")
    print(f"[*] 输出: {outdir}")


if __name__ == "__main__":
    main()
