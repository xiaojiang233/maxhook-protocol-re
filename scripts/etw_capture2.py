#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
WinHTTP ETW 被动监听 - 抓 MaxHook native 上报 (URL/headers/状态)
零注入零附加, 系统 ETW 被动记录, MaxHook 无法感知

用法 (管理员):
  python etw_capture.py [时长秒]    默认 120 秒

流程:
  1. logman 启动 Microsoft-Windows-WinHttp 监听 (关键字 API|SEND|RECEIVE)
  2. 等待指定时长 (游戏运行, 触发检测/上报)
  3. 停止并解析 ETL -> XML
  4. 提取 URL/headers/状态事件

输出: etw_out/winhttp.xml + etw_out/urls.txt
"""
import subprocess
import time
import os
import sys
import re

DUR = int(sys.argv[1]) if len(sys.argv) > 1 else 120
OUTDIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "etw_out")
os.makedirs(OUTDIR, exist_ok=True)
ETL = os.path.join(OUTDIR, "winhttp.etl")
XML = os.path.join(OUTDIR, "winhttp.xml")
URLS = os.path.join(OUTDIR, "urls.txt")


def run(cmd):
    r = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    return (r.stdout or "") + (r.stderr or "")


def main():
    # 清理旧 trace
    run('logman stop nettrace -ets')
    run('logman delete nettrace -f')

    print("[1/4] 启动 网络/DNS/TLS ETW 监听 (需要管理员权限)...", flush=True)
    r = run(f'logman create trace nettrace '
            f'-p "Microsoft-Windows-Kernel-Network" 0xFFFFFFFFFFFFFF 5 '
            f'-p "Microsoft-Windows-DNS-Client" 0xFFFFFFFFFFFFFF 5 '
            f'-p "Microsoft-Windows-Schannel-Events" 0xFFFFFFFFFFFFFF 5 '
            f'-o "{ETL}" -ets')
    if ('Error' in r or 'Access is denied' in r or '拒绝' in r
            or 'error' in r.lower()):
        print("[!] 创建失败:", r.strip(), flush=True)
        print("    ===== 必须以管理员身份运行终端! =====", flush=True)
        print("    右键开始菜单 -> 终端(管理员) / Windows PowerShell(管理员)", flush=True)
        sys.exit(1)
    print("    监听已启动", flush=True)

    print(f"[2/4] 监听 {DUR} 秒... 确保游戏在运行并已触发检测周期", flush=True)
    t0 = time.time()
    while time.time() - t0 < DUR:
        left = int(DUR - (time.time() - t0))
        print(f"    剩余 {left}s", flush=True)
        time.sleep(min(10, left))

    print("[3/4] 停止监听...", flush=True)
    run('logman stop nettrace -ets')
    run('logman delete nettrace -f')

    if not os.path.exists(ETL) or os.path.getsize(ETL) == 0:
        print("[!] ETL 为空 - 可能没有任何 WinHTTP 活动或权限不足", flush=True)
        sys.exit(1)
    print(f"    ETL 大小: {os.path.getsize(ETL)} bytes", flush=True)

    print("[4/4] 解析 ETL -> XML...", flush=True)
    run(f'tracerpt "{ETL}" -o "{XML}" -of XML -y')
    if not os.path.exists(XML):
        # 尝试 CSV
        CSV = os.path.join(OUTDIR, "winhttp.csv")
        run(f'tracerpt "{ETL}" -o "{CSV}" -of CSV -y')
        print(f"    CSV 模式输出: {CSV}", flush=True)
    else:
        print(f"    XML: {XML}", flush=True)
        # 提取 IP/域名/事件
        try:
            data = open(XML, encoding='utf-8', errors='replace').read()
            # DNS 域名
            domains = set(re.findall(r'[A-Za-z0-9_\-]{2,}(?:\.[A-Za-z0-9_\-]{2,})+\.(?:com|cn|net|org|io|cc|top|xyz|info|biz)', data))
            # IP 地址 (IPv4)
            ips = set(re.findall(r'\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b', data))
            # 进程相关
            evts = re.findall(r'<Data Name="[^"]*">([^<]{3,})</Data>', data)
            with open(URLS, 'w', encoding='utf-8') as f:
                f.write('--- 域名 ---\n')
                for d in sorted(domains): f.write(d + '\n')
                f.write('\n--- IP ---\n')
                for i in sorted(ips): f.write(i + '\n')
                f.write('\n--- 事件数据 (去重) ---\n')
                seen = set()
                for e in evts:
                    if e not in seen and len(e) < 200:
                        seen.add(e); f.write(e + '\n')
            print(f"    提取完成: {URLS}", flush=True)
            print(f"\n=== 域名 ({len(domains)}) ===", flush=True)
            for d in sorted(domains)[:40]: print(f"  {d}", flush=True)
            print(f"\n=== IP ({len(ips)}) ===", flush=True)
            for i in sorted(ips)[:40]: print(f"  {i}", flush=True)
        except Exception as e:
            print(f"    解析失败: {e}", flush=True)

    print("\n[*] 完成。把 etw_out/ 目录给我分析。", flush=True)


if __name__ == "__main__":
    main()
