#!/usr/bin/env python3
"""合并捕获: 一次拿齐同会话加密材料."""
from __future__ import annotations
import argparse, json, pathlib, sys, time
from datetime import datetime

def parse_args():
    here = pathlib.Path(__file__).resolve().parent
    p = argparse.ArgumentParser()
    t = p.add_mutually_exclusive_group(required=True)
    t.add_argument("--pid", type=int); t.add_argument("--process")
    t.add_argument("--compile-only", action="store_true")
    p.add_argument("--script", type=pathlib.Path, default=here / "capture_maxhook_crypto.js")
    p.add_argument("--output", type=pathlib.Path)
    p.add_argument("--duration", type=float, default=0)
    p.add_argument("--ack-sensitive-local-capture", action="store_true")
    return p.parse_args()

def main():
    args = parse_args()
    try:
        import frida
    except ImportError:
        raise SystemExit("frida required")
    bundle = frida.Compiler().build(str(args.script.resolve()), project_root=str(args.script.parent))
    print(f"[+] compiled ({len(bundle)} chars)")
    if args.compile_only: return 0
    if not args.ack_sensitive_local_capture: raise SystemExit("add --ack-sensitive-local-capture")
    if args.output is None: raise SystemExit("need --output")
    out = args.output.resolve(); out.mkdir(parents=True, exist_ok=True)
    dev = frida.get_local_device()
    pid = args.pid or next((i.pid for i in dev.enumerate_processes() if i.name.casefold() == args.process.casefold()), None)
    if pid is None: raise SystemExit(f"not found: {args.process}")
    def on_message(message, data):
        ts = datetime.now().astimezone().isoformat()
        if message.get("type") != "send":
            print(json.dumps({"captured_at": ts, "kind": "frida_error", "message": message}, ensure_ascii=False), file=sys.stderr)
            return
        ev = {"captured_at": ts, **(message.get("payload") or {})}
        print(json.dumps(ev, ensure_ascii=False), flush=True)
        with (out / "events.jsonl").open("a", encoding="utf-8") as f:
            f.write(json.dumps(ev, ensure_ascii=False) + "\n")
    session = dev.attach(pid)
    script = session.create_script(bundle)
    script.on("message", on_message)
    script.load()
    print("[!] crypto capture active")
    try:
        if args.duration > 0: time.sleep(args.duration)
        else: input("[*] press Enter to stop ... ")
    except (KeyboardInterrupt, EOFError): pass
    finally:
        try: script.unload()
        finally: session.detach()
    (out / "capture_summary.json").write_text(json.dumps({"pid": pid, "done": True}, indent=2) + "\n", encoding="utf-8")
    print(f"[+] wrote {out}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
