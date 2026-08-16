#!/usr/bin/env python3
"""Capture the recovered MaxHook native envelope function's exact arguments.

This is intentionally a narrow, local research tool.  It writes plaintext and
key/KDF material to disk and therefore requires an explicit acknowledgement.
Use --compile-only for safe offline validation; do not attach to a production
or currently restricted game session.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import pathlib
import re
import sys
import threading
import time
from collections import defaultdict
from datetime import datetime


SAFE_LABEL = re.compile(r"[^A-Za-z0-9_.-]+")


def parse_args() -> argparse.Namespace:
    here = pathlib.Path(__file__).resolve().parent
    parser = argparse.ArgumentParser(description=__doc__)
    target = parser.add_mutually_exclusive_group(required=True)
    target.add_argument("--pid", type=int)
    target.add_argument("--process", help="exact process name, for example javaw.exe")
    target.add_argument("--compile-only", action="store_true")
    parser.add_argument(
        "--script",
        type=pathlib.Path,
        default=here / "capture_maxhook_encrypt_boundary.js",
    )
    parser.add_argument("--output", type=pathlib.Path)
    parser.add_argument("--duration", type=float, default=0)
    parser.add_argument(
        "--ack-sensitive-local-capture",
        action="store_true",
        help="required for attach mode: confirms output includes plaintext/key material",
    )
    return parser.parse_args()


def load_frida():
    try:
        import frida
    except ImportError as exc:
        raise RuntimeError(
            "Frida Python bindings are required; use `uv run --with frida -- python ...`"
        ) from exc
    return frida


def compile_script(frida, script_path: pathlib.Path) -> str:
    source = script_path.read_text(encoding="utf-8")
    compiler = frida.Compiler()
    return compiler.build(str(script_path), project_root=str(script_path.parent))


def choose_pid(device, process_name: str) -> int:
    wanted = process_name.casefold()
    matches = [item for item in device.enumerate_processes() if item.name.casefold() == wanted]
    if not matches:
        raise RuntimeError(f"process not found: {process_name}")
    if len(matches) != 1:
        choices = ", ".join(f"{item.pid}:{item.name}" for item in matches)
        raise RuntimeError(f"multiple matching processes ({choices}); use --pid")
    return matches[0].pid


class Capture:
    def __init__(self, output: pathlib.Path):
        self.output = output.resolve()
        self.output.mkdir(parents=True, exist_ok=True)
        self.events: list[dict] = []
        self.calls: dict[str, list[dict]] = defaultdict(list)
        self.sequence = 0
        self.lock = threading.Lock()

    def on_message(self, message, data) -> None:
        with self.lock:
            self.sequence += 1
            timestamp = datetime.now().astimezone().isoformat()
            if message.get("type") != "send":
                event = {
                    "sequence": self.sequence,
                    "captured_at": timestamp,
                    "kind": "frida_error",
                    "message": message,
                }
                print(json.dumps(event, ensure_ascii=False), file=sys.stderr)
            else:
                payload = message.get("payload") or {}
                event = {"sequence": self.sequence, "captured_at": timestamp, **payload}
                if data is not None:
                    blob = bytes(data)
                    call_id = str(payload.get("call_id", "meta"))
                    label = SAFE_LABEL.sub("_", str(payload.get("label", payload.get("kind", "data"))))
                    phase = SAFE_LABEL.sub("_", str(payload.get("phase", "meta")))
                    filename = f"{self.sequence:06d}_call_{call_id}_{phase}_{label}.bin"
                    path = self.output / filename
                    path.write_bytes(blob)
                    event.update(
                        file=filename,
                        captured_bytes=len(blob),
                        sha256=hashlib.sha256(blob).hexdigest(),
                    )
                print(json.dumps(event, ensure_ascii=False), flush=True)
            self.events.append(event)
            call_id = event.get("call_id")
            if call_id is not None:
                self.calls[str(call_id)].append(event)
            with (self.output / "events.jsonl").open("a", encoding="utf-8") as stream:
                stream.write(json.dumps(event, ensure_ascii=False) + "\n")

    def finish(self, pid: int) -> pathlib.Path:
        calls = []
        required_inputs = {"input32", "input64", "plaintext_json"}
        required_outputs = {"kid_hex", "nonce_hex", "ciphertext_hex", "tag_hex"}
        for call_id in sorted(self.calls, key=lambda value: int(value)):
            events = self.calls[call_id]
            strings = [event for event in events if event.get("kind") == "encrypt_string"]
            input_labels = {event.get("label") for event in strings if event.get("phase") == "input"}
            output_labels = {event.get("label") for event in strings if event.get("phase") == "output"}
            calls.append(
                {
                    "call_id": call_id,
                    "thread_ids": sorted({event.get("thread_id") for event in events if event.get("thread_id")}),
                    "return_address": next(
                        (event.get("return_address") for event in events if event.get("kind") == "encrypt_enter"),
                        None,
                    ),
                    "complete_inputs": required_inputs <= input_labels,
                    "complete_outputs": required_outputs <= output_labels,
                    "strings": [
                        {
                            key: event.get(key)
                            for key in ("phase", "label", "size", "capacity", "file", "sha256")
                        }
                        for event in strings
                    ],
                    "errors": [event for event in events if event.get("kind") == "encrypt_string_error"],
                }
            )
        summary = {
            "schema": "maxhook.encrypt-boundary.capture/v1",
            "pid": pid,
            "finished_at": datetime.now().astimezone().isoformat(),
            "sensitive_plaintext_and_key_material": True,
            "event_count": len(self.events),
            "call_count": len(calls),
            "complete_calls": sum(item["complete_inputs"] and item["complete_outputs"] for item in calls),
            "calls": calls,
        }
        path = self.output / "capture_summary.json"
        path.write_text(json.dumps(summary, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
        return path


def main() -> int:
    args = parse_args()
    frida = load_frida()
    bundle = compile_script(frida, args.script.resolve())
    print(f"[+] Frida compiler accepted {args.script.resolve()} ({len(bundle)} chars)")
    if args.compile_only:
        return 0
    if not args.ack_sensitive_local_capture:
        raise SystemExit(
            "attach mode refused: add --ack-sensitive-local-capture after reviewing that "
            "plaintext and key/KDF material will be written locally"
        )
    if args.output is None:
        raise SystemExit("attach mode requires --output")
    device = frida.get_local_device()
    pid = args.pid if args.pid is not None else choose_pid(device, args.process)
    capture = Capture(args.output)
    print(
        "[!] local sensitive capture enabled; do not upload this directory. "
        "Do not use against a production/restricted session."
    )
    session = device.attach(pid)
    script = session.create_script(bundle)
    script.on("message", capture.on_message)
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
    summary = capture.finish(pid)
    print(f"[+] wrote {summary}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
