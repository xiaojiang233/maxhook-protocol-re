#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Clash Verge 连接查询 - 拿 javaw 的实时连接域名 (fake-ip 映射)
用法:
  python clash_query.py [秒数]    轮询秒数, 默认 30
输出: clash_connections.txt
"""
import json
import urllib.request
import time
import sys
import os

PORTS = [9090, 9097, 9091, 9099]
SECRETS = ["", "secret", "clash"]


def try_connect():
    """找 Clash 外部控制器, 返回 (base_url, secret)"""
    for port in PORTS:
        for secret in SECRETS:
            url = f"http://127.0.0.1:{port}/version"
            try:
                req = urllib.request.Request(url)
                if secret:
                    req.add_header("Authorization", f"Bearer {secret}")
                with urllib.request.urlopen(req, timeout=2) as r:
                    ver = json.loads(r.read())
                    print(f"[*] Clash API: 127.0.0.1:{port} (version={ver.get('version')})")
                    return f"http://127.0.0.1:{port}", secret
            except Exception:
                continue
    return None, None


def get_connections(base, secret):
    url = base + "/connections"
    req = urllib.request.Request(url)
    if secret:
        req.add_header("Authorization", f"Bearer {secret}")
    with urllib.request.urlopen(req, timeout=3) as r:
        return json.loads(r.read())


def main():
    dur = int(sys.argv[1]) if len(sys.argv) > 1 else 30
    base, secret = try_connect()
    if not base:
        print("[!] 找不到 Clash 控制器 (试过端口 9090/9097/9091/9099)")
        print("    请在 Clash Verge 设置里开启「外部控制」或直接看界面连接页")
        sys.exit(1)

    OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "clash_connections.txt")
    seen = set()
    t0 = time.time()
    print(f"[*] 轮询连接 {dur} 秒... (游戏保持运行)", flush=True)
    while time.time() - t0 < dur:
        try:
            data = get_connections(base, secret)
            for conn in data.get("connections", []):
                meta = conn.get("metadata", {})
                proc = meta.get("process", "?")
                host = meta.get("host", meta.get("destinationIP", ""))
                dst_port = meta.get("destinationPort", "")
                src_port = meta.get("sourcePort", "")
                key = (proc, host, dst_port)
                if key not in seen:
                    seen.add(key)
                    print(f"[*] proc={proc} host={host}:{dst_port} (src:{src_port}) "
                          f"type={conn.get('type','')}", flush=True)
        except Exception as e:
            print(f"  (查询失败: {e})", flush=True)
        time.sleep(2)

    print(f"\n=== 连接 ({len(seen)}) 已保存 {OUT} ===")
    with open(OUT, 'w', encoding='utf-8') as f:
        for k in sorted(seen):
            f.write(f"{k}\n")


if __name__ == "__main__":
    main()
