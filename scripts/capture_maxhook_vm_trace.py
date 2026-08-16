#!/usr/bin/env python3
"""Capture VM-protected encrypt function execution trace (方案 2).

Hooks MaxHook.dll+0x324610, follows the thread with Stalker while the
VM-protected encrypt function runs, and records:
  - mnemonic histogram (algorithm primitive hints: ARX vs lookup-table)
  - unique executed addresses (for offline disassembly)
Output directory contains vm_trace events + address chunks.

Usage:
  python capture_maxhook_vm_trace.py --compile-only
  uv run --with frida -- python capture_maxhook_vm_trace.py --process javaw.exe \
      --output .\vm_trace_capture --ack-sensitive-local-capture --duration 120
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


def parse_args() -> argparse.Namespace:
    here = pathlib.Path(__file__).resolve().parent
    parser = argparse.ArgumentParser(description=__doc__)
    target = parser.add_mutually_exclusive_group(required=True)
    target.add_argument("--pid", type=int)
    target.add_argument("--process", help="exact process name, e.g. javaw.exe")
    target.add_argument("--compile-only", action="store_true")
    parser.add_argument("--script", type=pathlib.Path,
                        default=here / "capture_maxhook_vm_trace.js")
    parser.add_argument("--output", type=pathlib.Path)
    parser.add_argument("--duration", type=float, default=0)
    parser.add_argument("--ack-sensitive-local-capture", action="store_true")
    return parser.parse_args()


def load_frida():
    try:
        import frida
    except ImportError as exc:
        raise RuntimeError("Frida bindings required; use `uv run --with frida -- python ...`") from exc
    return frida


class Capture:
    def __init__(self, output: pathlib.Path):
        self.output = output.resolve()
        self.output.mkdir(parents=True, exist_ok=True)
        self.events = []
        self.lock = threading.Lock()
        self.addr_chunks = {}

    def on_message(self, message, data):
        with self.lock:
            ts = datetime.now().astimezone().isoformat()
            if message.get("type") != "send":
                ev = {"captured_at": ts, "kind": "frida_error", "message": message}
                print(json.dumps(ev, ensure_ascii=False), file=sys.stderr)
                return
            payload = message.get("payload") or {}
            ev = {"captured_at": ts, **payload}
            if data is not None:
                blob = bytes(data)
                if payload.get("kind") == "vm_trace_addrs":
                    cid = payload.get("call_id")
                    chunk = payload.get("chunk")
                    try:
                        text = blob.decode("utf-8")
                    except Exception:
                        text = blob.decode("latin1")
                    self.addr_chunks.setdefault(cid, {})[chunk] = text
                    ev.update(bytes=len(blob), sha256=hashlib.sha256(blob).hexdigest()[:16])
                else:
                    fname = f"{len(self.events):06d}_{payload.get('kind', 'event')}.bin"
                    (self.output / fname).write_bytes(blob)
                    ev.update(file=fname, bytes=len(blob))
            print(json.dumps(ev, ensure_ascii=False), flush=True)
            self.events.append(ev)
            with (self.output / "events.jsonl").open("a", encoding="utf-8") as f:
                f.write(json.dumps(ev, ensure_ascii=False) + "\n")

    def finish(self, pid: int):
        # 合并地址块 -> 每 call 一个 txt
        summaries = [e for e in self.events if e.get("kind") == "vm_trace_summary"]
        for e in summaries:
            cid = e["call_id"]
            chunks = self.addr_chunks.get(cid, {})
            addrs = []
            for k in sorted(chunks, key=int):
                addrs.extend(a.strip() for a in chunks[k].splitlines() if a.strip())
            path = self.output / f"vm_addrs_call{cid}.txt"
            path.write_text("\n".join(addrs), encoding="utf-8")
            e["addrs_file"] = str(path)
            e["addrs_count"] = len(addrs)
        summary = {
            "schema": "maxhook.vm-trace.capture/v1",
            "pid": pid,
            "finished_at": datetime.now().astimezone().isoformat(),
            "event_count": len(self.events),
            "trace_calls": len(summaries),
            "summaries": [
                {k: v for k, v in e.items() if k in (
                    "call_id", "total_instructions", "unique_addresses",
                    "top_mnemonics", "addrs_count", "addrs_file")}
                for e in summaries
            ],
        }
        path = self.output / "capture_summary.json"
        path.write_text(json.dumps(summary, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
        return path


def main() -> int:
    args = parse_args()
    frida = load_frida()
    bundle = frida.Compiler().build(str(args.script.resolve()),
                                    project_root=str(args.script.parent))
    print(f"[+] Frida compiler accepted {args.script.resolve()} ({len(bundle)} chars)")
    if args.compile_only:
        return 0
    if not args.ack_sensitive_local_capture:
        raise SystemExit("attach refused: add --ack-sensitive-local-capture")
    if args.output is None:
        raise SystemExit("attach mode requires --output")
    device = frida.get_local_device()
    pid = args.pid if args.pid is not None else next(
        (i.pid for i in device.enumerate_processes() if i.name.casefold() == args.process.casefold()), None)
    if pid is None:
        raise SystemExit(f"process not found: {args.process}")
    cap = Capture(args.output)
    print("[!] local capture enabled; VM trace may be slow while encrypt runs")
    session = device.attach(pid)
    script = session.create_script(bundle)
    script.on("message", cap.on_message)
    script.load()
    try:
        if args.duration > 0:
            time.sleep(args.duration)
        else:
            input("[*] capturing; press Enter to stop ... ")
    except (KeyboardInterrupt, EOFError):
        pass
    finally:
        try:
            script.unload()
        finally:
            session.detach()
    out = cap.finish(pid)
    print(f"[+] wrote {out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
