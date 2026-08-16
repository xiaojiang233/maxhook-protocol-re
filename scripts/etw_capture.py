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
    run('logman stop winhttptrace -f')
    run('logman delete winhttptrace -f')

    print("[1/4] 启动 WinHTTP ETW 监听 (需要管理员权限)...", flush=True)
    r = run(f'logman create trace winhttptrace -p "Microsoft-Windows-WinHttp" '
            f'0xFFFFFFFFFFFFFF 5 -o "{ETL}" -ets')
    if 'Error' in r or 'Access is denied' in r:
        print("[!] 创建失败:", r.strip(), flush=True)
        print("    请用管理员身份运行终端!", flush=True)
        sys.exit(1)
    print("    监听已启动", flush=True)

    print(f"[2/4] 监听 {DUR} 秒... 确保游戏在运行并已触发检测周期", flush=True)
    t0 = time.time()
    while time.time() - t0 < DUR:
        left = int(DUR - (time.time() - t0))
        print(f"    剩余 {left}s", flush=True)
        time.sleep(min(10, left))

    print("[3/4] 停止监听...", flush=True)
    run('logman stop winhttptrace -ets -f')
    run('logman delete winhttptrace -f')

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
        # 提取 URL 相关事件
        try:
            data = open(XML, encoding='utf-8', errors='replace').read()
            urls = set(re.findall(r'https?://[^\s"<>]{4,}', data))
            # 也提取 WinHttpSendRequest 等事件文本
            evts = re.findall(r'<Data Name="[^"]*">([^<]{4,})</Data>', data)
            with open(URLS, 'w', encoding='utf-8') as f:
                for u in sorted(urls):
                    f.write(u + '\n')
                f.write('\n--- 事件数据片段 ---\n')
                seen = set()
                for e in evts:
                    if e not in seen and len(e) < 300:
                        seen.add(e)
                        f.write(e + '\n')
            print(f"    URL/事件提取: {URLS}", flush=True)
            if urls:
                print("\n=== 抓到的 URL ===", flush=True)
                for u in sorted(urls)[:40]:
                    print(f"  {u}", flush=True)
        except Exception as e:
            print(f"    解析失败: {e}", flush=True)

    print("\n[*] 完成。把 etw_out/ 目录给我分析。", flush=True)


if __name__ == "__main__":
    main()
