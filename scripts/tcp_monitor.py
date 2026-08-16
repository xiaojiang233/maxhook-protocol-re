#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
javaw TCP 连接实时监控 - 确认游戏进程的网络活动 (含 MaxHook 独立上报连接)
用法:
  python tcp_monitor.py [时长秒]    默认 120 秒
输出: tcp_connections.txt (唯一连接) + 实时显示
"""
import subprocess
import time
import sys
import os
import re

DUR = int(sys.argv[1]) if len(sys.argv) > 1 else 120
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "tcp_connections.txt")


def find_javaw_pid():
    r = subprocess.run(['powershell', '-NoProfile', '-Command',
        'Get-Process javaw -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Id'],
        capture_output=True, text=True)
    pids = [int(x) for x in re.findall(r'\d+', r.stdout)]
    return pids


def get_connections(pid):
    """返回 javaw 的 TCP 连接列表 [(local, remote)]"""
    r = subprocess.run(['netstat', '-ano'], capture_output=True, text=True)
    out = []
    for line in r.stdout.splitlines():
        parts = line.split()
        if len(parts) >= 5 and parts[-1] == str(pid):
            state = parts[0]
            local = parts[1]
            remote = parts[2]
            out.append((state, local, remote))
    return out


def main():
    pids = find_javaw_pid()
    if not pids:
        print("[!] 找不到 javaw 进程! 请先启动游戏", flush=True)
        sys.exit(1)
    pid = pids[0]
    print(f"[*] javaw PID: {pid}", flush=True)

    seen = {}
    t0 = time.time()
    print(f"[*] 监控 {DUR} 秒... (游戏保持运行)", flush=True)
    while time.time() - t0 < DUR:
        now = time.time() - t0
        conns = get_connections(pid)
        for state, local, remote in conns:
            key = (state, local, remote)
            if key not in seen:
                seen[key] = now
                print(f"[{now:6.1f}s] {state} {local} -> {remote}", flush=True)
        left = int(DUR - (time.time() - t0))
        if int(now) % 10 == 0 and int(now) != int(now - 1):
            print(f"    剩余 {left}s (当前 {len(conns)} 条连接)", flush=True)
        time.sleep(1)

    print(f"\n=== 唯一连接 ({len(seen)}) ===", flush=True)
    with open(OUT, 'w', encoding='utf-8') as f:
        for (state, local, remote), t in sorted(seen.items(), key=lambda x: x[1]):
            f.write(f"[{t:.1f}s] {state} {local} -> {remote}\n")
            print(f"  [{t:.1f}s] {state} {local} -> {remote}", flush=True)
    print(f"\n已保存: {OUT}", flush=True)


if __name__ == "__main__":
    main()
