#!/usr/bin/env python3
"""Key 材料数据流追踪 (破加密). 监控 input32/input64 的读取, 定位 key 派生代码.

Usage:
  python capture_maxhook_keytrace.py --compile-only
  uv run --with frida -- python capture_maxhook_keytrace.py --process javaw.exe \
      --output .\keytrace_capture --ack-sensitive-local-capture --duration 90
"""

from __future__ import annotations

import argparse
import hashlib
import json
import pathlib
import sys
import threading
import time
from datetime import datetime


def parse_args():
    here = pathlib.Path(__file__).resolve().parent
    p = argparse.ArgumentParser(description=__doc__)
    t = p.add_mutually_exclusive_group(required=True)
    t.add_argument("--pid", type=int)
    t.add_argument("--process")
    t.add_argument("--compile-only", action="store_true")
    p.add_argument("--script", type=pathlib.Path, default=here / "capture_maxhook_keytrace.js")
    p.add_argument("--output", type=pathlib.Path)
    p.add_argument("--duration", type=float, default=0)
    p.add_argument("--ack-sensitive-local-capture", action="store_true")
    return p.parse_args()


def main():
    args = parse_args()
    try:
        import frida
    except ImportError:
        raise SystemExit("frida required; use `uv run --with frida -- python ...`")
    bundle = frida.Compiler().build(str(args.script.resolve()), project_root=str(args.script.parent))
    print(f"[+] compiled {args.script.name} ({len(bundle)} chars)")
    if args.compile_only:
        return 0
    if not args.ack_sensitive_local_capture:
        raise SystemExit("add --ack-sensitive-local-capture")
    if args.output is None:
        raise SystemExit("need --output")
    out = args.output.resolve()
    out.mkdir(parents=True, exist_ok=True)
    dev = frida.get_local_device()
    pid = args.pid or next((i.pid for i in dev.enumerate_processes() if i.name.casefold() == args.process.casefold()), None)
    if pid is None:
        raise SystemExit(f"process not found: {args.process}")
    addr_chunks = {}
    lock = threading.Lock()

    def on_message(message, data):
        with lock:
            ts = datetime.now().astimezone().isoformat()
            if message.get("type") != "send":
                print(json.dumps({"captured_at": ts, "kind": "frida_error", "message": message}, ensure_ascii=False), file=sys.stderr)
                return
            payload = message.get("payload") or {}
            ev = {"captured_at": ts, **payload}
            if data is not None:
                blob = bytes(data)
                if payload.get("kind") == "keytrace_addrs":
                    cid = payload.get("call_id"); ch = payload.get("chunk")
                    addr_chunks.setdefault(cid, {})[ch] = blob.decode("utf-8", "replace")
                else:
                    fn = f"{len(addr_chunks):06d}_{payload.get('kind','ev')}.bin"
                    (out / fn).write_bytes(blob)
                    ev.update(file=fn, bytes=len(blob))
            print(json.dumps(ev, ensure_ascii=False), flush=True)
            with (out / "events.jsonl").open("a", encoding="utf-8") as f:
                f.write(json.dumps(ev, ensure_ascii=False) + "\n")

    session = dev.attach(pid)
    script = session.create_script(bundle)
    script.on("message", on_message)
    script.load()
    print("[!] keytrace active")
    try:
        if args.duration > 0:
            time.sleep(args.duration)
        else:
            input("[*] press Enter to stop ... ")
    except (KeyboardInterrupt, EOFError):
        pass
    finally:
        try:
            script.unload()
        finally:
            session.detach()
    # 合并
    for cid, chunks in addr_chunks.items():
        lines = []
        for k in sorted(chunks, key=int):
            lines.extend(x for x in chunks[k].splitlines() if x.strip())
        (out / f"key_readers_call{cid}.txt").write_text("\n".join(lines), encoding="utf-8")
    summ = {"schema": "maxhook.keytrace.capture/v1", "pid": pid,
            "finished_at": datetime.now().astimezone().isoformat(),
            "calls": len(addr_chunks)}
    (out / "capture_summary.json").write_text(json.dumps(summ, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(f"[+] wrote {out / 'capture_summary.json'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
