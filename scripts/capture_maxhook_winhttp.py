#!/usr/bin/env python3
"""Capture MaxHook's pre-TLS WinHTTP request/response buffers with Frida."""

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


HEX_RE = re.compile(r"^[0-9A-Fa-f]+$")


def parse_envelope(data: bytes) -> dict | None:
    """Strictly validate an envelope without assuming JSON member order."""

    try:
        value = json.loads(data)
    except (UnicodeDecodeError, json.JSONDecodeError):
        return None
    if not isinstance(value, dict) or set(value) != {
        "sv",
        "kid",
        "nonce",
        "ciphertext",
        "tag",
    }:
        return None
    if not isinstance(value["sv"], int) or isinstance(value["sv"], bool):
        return None
    expected_lengths = {"kid": 32, "nonce": 24, "tag": 32}
    for name, length in expected_lengths.items():
        field = value[name]
        if not isinstance(field, str) or len(field) != length or not HEX_RE.fullmatch(field):
            return None
    ciphertext = value["ciphertext"]
    if (
        not isinstance(ciphertext, str)
        or not ciphertext
        or len(ciphertext) % 2
        or not HEX_RE.fullmatch(ciphertext)
    ):
        return None
    return value


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Capture security.mcbjd.net/api/v3/report before TLS",
    )
    target = parser.add_mutually_exclusive_group(required=True)
    target.add_argument("--pid", type=int, help="javaw process id")
    target.add_argument("--process", help="process name, for example javaw.exe")
    target.add_argument(
        "--rebuild",
        type=pathlib.Path,
        help="offline-rebuild summary from an existing capture directory",
    )
    parser.add_argument(
        "--script",
        type=pathlib.Path,
        default=pathlib.Path(__file__).with_name("capture_maxhook_winhttp.js"),
    )
    parser.add_argument("--output", type=pathlib.Path)
    parser.add_argument(
        "--duration",
        type=float,
        default=0,
        help="seconds to capture; 0 waits for Enter/Ctrl-C",
    )
    return parser.parse_args()


def choose_pid(device, process_name: str) -> int:
    wanted = process_name.lower()
    matches = [p for p in device.enumerate_processes() if p.name.lower() == wanted]
    if not matches:
        raise RuntimeError(f"process not found: {process_name}")
    if len(matches) != 1:
        choices = ", ".join(f"{p.pid}:{p.name}" for p in matches)
        raise RuntimeError(f"multiple matches ({choices}); use --pid")
    return matches[0].pid


class Capture:
    def __init__(self, output: pathlib.Path):
        self.output = output
        self.output.mkdir(parents=True, exist_ok=True)
        self.events = []
        self.chunks = defaultdict(list)
        self.sequence = 0
        self.lock = threading.Lock()

    def on_message(self, message, data):
        with self.lock:
            self.sequence += 1
            now = datetime.now().astimezone().isoformat()
            if message.get("type") != "send":
                event = {
                    "sequence": self.sequence,
                    "captured_at": now,
                    "kind": "frida_error",
                    "message": message,
                }
                print(json.dumps(event, ensure_ascii=False), file=sys.stderr)
            else:
                payload = message.get("payload") or {}
                event = {"sequence": self.sequence, "captured_at": now, **payload}
                if data is not None:
                    blob = bytes(data)
                    name = (
                        f"{self.sequence:06d}_request_{payload.get('request_id', 'unknown')}_"
                        f"{payload.get('kind', 'data')}.bin"
                    )
                    path = self.output / name
                    path.write_bytes(blob)
                    event.update(
                        file=name,
                        captured_bytes=len(blob),
                        sha256=hashlib.sha256(blob).hexdigest(),
                    )
                    if payload.get("kind") in ("send_optional", "write"):
                        self.chunks[str(payload.get("request_id"))].append(blob)
                print(json.dumps(event, ensure_ascii=False), flush=True)
            self.events.append(event)
            with (self.output / "events.jsonl").open("a", encoding="utf-8") as stream:
                stream.write(json.dumps(event, ensure_ascii=False) + "\n")

    def finish(self, pid: int) -> pathlib.Path:
        bodies = []
        event_by_id = defaultdict(list)
        for event in self.events:
            event_by_id[str(event.get("request_id"))].append(event)
        for request_id, chunks in self.chunks.items():
            body = b"".join(chunks)
            totals = [
                e.get("total_length")
                for e in event_by_id[request_id]
                if isinstance(e.get("total_length"), int)
            ]
            expected = max(totals, default=0)
            candidate = body[:expected] if expected and len(body) >= expected else body
            path = self.output / f"request_{request_id}_body.bin"
            path.write_bytes(candidate)
            envelope = parse_envelope(candidate)
            bodies.append(
                {
                    "request_id": request_id,
                    "file": path.name,
                    "bytes": len(candidate),
                    "captured_chunk_bytes": len(body),
                    "expected_bytes": expected,
                    "sha256": hashlib.sha256(candidate).hexdigest(),
                    "valid_envelope": envelope is not None,
                    "sv": envelope["sv"] if envelope else None,
                    "kid": envelope["kid"] if envelope else None,
                    "nonce": envelope["nonce"] if envelope else None,
                    "ciphertext": envelope["ciphertext"] if envelope else None,
                    "ciphertext_hex_length": (
                        len(envelope["ciphertext"]) if envelope else None
                    ),
                    "tag": envelope["tag"] if envelope else None,
                }
            )

        crypto_events = [
            event
            for event in self.events
            if str(event.get("kind", "")).startswith("bcrypt_")
        ]
        key_events = {}
        for event in crypto_events:
            if event.get("kind") in {
                "bcrypt_generate_symmetric_key",
                "bcrypt_import_key",
            } and event.get("key_handle"):
                key_events[str(event["key_handle"])] = event

        test_vectors = []
        encrypt_events = [
            event for event in crypto_events if event.get("kind") == "bcrypt_encrypt"
        ]
        for body in bodies:
            if not body["valid_envelope"]:
                continue
            ciphertext = bytes.fromhex(body["ciphertext"])
            for event in encrypt_events:
                output_file = event.get("file")
                if not output_file:
                    continue
                output_path = self.output / str(output_file)
                if not output_path.is_file() or output_path.read_bytes() != ciphertext:
                    continue
                auth = event.get("auth_info") or {}
                nonce_matches = not auth.get("nonce_hex") or (
                    str(auth["nonce_hex"]).lower() == str(body["nonce"]).lower()
                )
                tag_matches = not auth.get("tag_hex") or (
                    str(auth["tag_hex"]).lower() == str(body["tag"]).lower()
                )
                if not (nonce_matches and tag_matches):
                    continue
                key_event = key_events.get(str(event.get("key_handle")))
                test_vectors.append(
                    {
                        "request_id": body["request_id"],
                        "envelope_file": body["file"],
                        "encrypt_event_sequence": event.get("sequence"),
                        "algorithm": (event.get("key") or {}).get("algorithm"),
                        "key_handle": event.get("key_handle"),
                        "key_capture_event_sequence": (
                            key_event.get("sequence") if key_event else None
                        ),
                        "key_capture_file": key_event.get("file") if key_event else None,
                        "plaintext_hex": event.get("input_hex"),
                        "nonce_hex": body["nonce"],
                        "aad_hex": auth.get("aad_hex"),
                        "ciphertext_hex": body["ciphertext"],
                        "tag_hex": body["tag"],
                        "match_basis": "exact BCrypt output == envelope ciphertext; nonce/tag checked when available",
                    }
                )
        summary = {
            "schema": "maxhook.winhttp.capture/v1",
            "pid": pid,
            "finished_at": datetime.now().astimezone().isoformat(),
            "event_count": len(self.events),
            "requests": bodies,
            "crypto_event_count": len(crypto_events),
            "crypto_events": crypto_events,
            "reproducible_test_vectors": test_vectors,
        }
        path = self.output / "capture_summary.json"
        path.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
        return path


def rebuild_existing_capture(output: pathlib.Path) -> pathlib.Path:
    events_path = output / "events.jsonl"
    if not events_path.is_file():
        raise FileNotFoundError(f"events file not found: {events_path}")
    capture = Capture(output)
    for line in events_path.read_text(encoding="utf-8").splitlines():
        if line.strip():
            capture.events.append(json.loads(line))
    for event in capture.events:
        if event.get("kind") not in ("send_optional", "write") or not event.get("file"):
            continue
        chunk_path = output / str(event["file"])
        if chunk_path.is_file():
            capture.chunks[str(event.get("request_id"))].append(chunk_path.read_bytes())
    old_summary = output / "capture_summary.json"
    pid = 0
    if old_summary.is_file():
        try:
            pid = int(json.loads(old_summary.read_text(encoding="utf-8")).get("pid", 0))
        except (ValueError, TypeError, json.JSONDecodeError):
            pass
    return capture.finish(pid)


def main() -> int:
    args = parse_args()
    if args.rebuild is not None:
        try:
            summary = rebuild_existing_capture(args.rebuild.resolve())
        except Exception as exc:
            print(f"rebuild failed: {exc}", file=sys.stderr)
            return 1
        print(f"summary rebuilt: {summary.resolve()}")
        return 0
    try:
        import frida
    except ImportError:
        print("frida is required: python -m pip install frida", file=sys.stderr)
        return 2

    if not args.script.is_file():
        print(f"script not found: {args.script}", file=sys.stderr)
        return 2
    output = args.output or pathlib.Path(__file__).with_name(
        "native_capture_" + datetime.now().strftime("%Y%m%d_%H%M%S")
    )
    device = frida.get_local_device()
    try:
        pid = args.pid if args.pid is not None else choose_pid(device, args.process)
        session = device.attach(pid)
    except Exception as exc:
        print(f"attach failed: {exc}", file=sys.stderr)
        if "VirtualAllocEx returned 0x00000005" in str(exc):
            print(
                "Windows denied remote allocation; run this capture from an "
                "elevated terminal at the same integrity level as javaw.exe.",
                file=sys.stderr,
            )
        return 1

    capture = Capture(output)
    script = session.create_script(args.script.read_text(encoding="utf-8"))
    script.on("message", capture.on_message)
    script.load()
    print(f"capturing pid={pid} into {output.resolve()}", flush=True)
    try:
        if args.duration > 0:
            time.sleep(args.duration)
        else:
            input("Press Enter to stop capture...\n")
    except (KeyboardInterrupt, EOFError):
        pass
    finally:
        try:
            script.unload()
        finally:
            session.detach()
    summary = capture.finish(pid)
    print(f"summary: {summary.resolve()}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
