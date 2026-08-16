#!/usr/bin/env python3
"""Offline diagnostic emulation of MaxHook's recovered envelope function.

The purpose is not to pretend that an asynchronous .bugland snapshot is a
synchronized function-entry state.  The script makes that limitation
measurable: it restores runtime PE sections, a captured report-builder object
graph, controlled string arguments and small allocator stubs, then records the
first concrete state dependency that prevents further execution.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import struct
import sys
from collections import deque
from pathlib import Path
from typing import Any


HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE / ".pydeps"))

import pefile  # type: ignore  # noqa: E402
from capstone import CS_ARCH_X86, CS_MODE_64, Cs  # type: ignore  # noqa: E402
from unicorn import (  # type: ignore  # noqa: E402
    UC_ARCH_X86,
    UC_HOOK_CODE,
    UC_HOOK_MEM_INVALID,
    UC_HOOK_MEM_READ,
    UC_HOOK_MEM_WRITE,
    UC_MODE_64,
    Uc,
    UcError,
)
from unicorn.x86_const import (  # type: ignore  # noqa: E402
    UC_X86_REG_GS_BASE,
    UC_X86_REG_R8,
    UC_X86_REG_R9,
    UC_X86_REG_RAX,
    UC_X86_REG_RBP,
    UC_X86_REG_RBX,
    UC_X86_REG_RCX,
    UC_X86_REG_RDI,
    UC_X86_REG_RDX,
    UC_X86_REG_RIP,
    UC_X86_REG_RSI,
    UC_X86_REG_RSP,
    UC_X86_REG_R10,
    UC_X86_REG_R11,
    UC_X86_REG_R12,
    UC_X86_REG_R13,
    UC_X86_REG_R14,
    UC_X86_REG_R15,
)


IMAGE_BASE = 0x180000000
BUGLAND_BASE = 0x180980000
ENCRYPT_ENTRY = 0x180324610
VM_RBP = 0x18098C884
VM_POINTER_SLOT = VM_RBP + 0x45
ALLOC_FUNCTION = 0x1805BC4D0
FREE_FUNCTION = 0x1805BC470
MEMSET_FUNCTION = 0x1805D11B0
PROBE_FIRST_DEREF = 0x1809BD54C
PROBE_SECOND_DEREF = 0x1809BD556
PROBE_VALUE_SOURCE_LOAD = 0x180BD46B1
POP_R8_HANDLER = 0x1809C005E
# The real VM dispatcher (per milestone 16/17) is 0x180a97f70, which reads
# [context+0x5d] flag / VIP word and does the handler-table lookup.  0x180c43fdd
# is only the bootstrap call-next stub and was previously mis-identified.
DISPATCHER = 0x180A97F70
BOOTSTRAP_STUB = 0x180C43FDD
HANDLER_TABLE_BASE = 0x180C64EBD
HANDLER_TABLE_BYTES = 0x10000 * 8
RETURN_SENTINEL = 0x180500000
STORE32 = 0x18041A860
GENERATOR_CANDIDATE = 0x18041A8A0
# The 6 push sites inside the word-producer handler 0x180b8c7aa.  Each loads a
# 16-bit bytecode word at VIP+K, computes context+word, and pushes context[word]
# onto the VM data stack; these 6 context values fold into the keystream word.
WORD_PRODUCER_PUSH_SITES = {
    0x180B8C81B: 0x1C,  # push [ctx + word[VIP+0x1c]]
    0x180B8C882: 0x18,  # push [ctx + word[VIP+0x18]]
    0x180B8C91A: 0x10,  # push [ctx + word[VIP+0x10]]
    0x180B8C9A6: 0x08,  # push [ctx + word[VIP+0x08]]
    0x180B8CA27: 0x1A,  # push [ctx + word[VIP+0x1a]]
    0x180B8CAA0: 0x0C,  # push [ctx + word[VIP+0x0c]]
}
# Fold output: the final keystream word EDX is loaded from [rsp] (S10) at
# 0x180c27be2 (mov rdx, [rsp]), right before the popfq;ret trampoline to store32.
FOLD_EDX_LOAD = 0x180C27BE2
REGISTERS = {
    "rax": UC_X86_REG_RAX,
    "rbx": UC_X86_REG_RBX,
    "rcx": UC_X86_REG_RCX,
    "rdx": UC_X86_REG_RDX,
    "rsi": UC_X86_REG_RSI,
    "rdi": UC_X86_REG_RDI,
    "rbp": UC_X86_REG_RBP,
    "rsp": UC_X86_REG_RSP,
    "r8": UC_X86_REG_R8,
    "r9": UC_X86_REG_R9,
    "r10": UC_X86_REG_R10,
    "r11": UC_X86_REG_R11,
    "r12": UC_X86_REG_R12,
    "r13": UC_X86_REG_R13,
    "r14": UC_X86_REG_R14,
    "r15": UC_X86_REG_R15,
    "rip": UC_X86_REG_RIP,
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dll", type=Path, default=HERE / "MaxHook.runtime-unpacked.dll")
    parser.add_argument("--dump-dir", type=Path, default=HERE / "dump_out" / "41264")
    parser.add_argument("--bugland", type=Path, default=HERE / "runtime_bugland2.bin")
    parser.add_argument(
        "--vm-context-snapshot",
        type=Path,
        default=None,
        help="overwrite VM context at 0x18098c884 with this real-machine 512-byte snapshot "
        "before emulation (from capture_maxhook_vm_context.js vm_enter_context.bin)",
    )
    parser.add_argument(
        "--capture-dir", type=Path, default=HERE / "target" / "native_capture_live"
    )
    parser.add_argument("--request-id", default="3")
    parser.add_argument("--input32", default="A" * 32)
    parser.add_argument("--input64", default="B" * 64)
    parser.add_argument("--plaintext", default='{"report_id":"offline-diagnostic"}')
    parser.add_argument(
        "--boundary-dir",
        type=Path,
        help="use one synchronized encrypt-boundary entry capture instead of synthetic arguments",
    )
    parser.add_argument("--boundary-session", type=int, default=0)
    parser.add_argument("--boundary-call", type=int, default=1)
    parser.add_argument("--max-instructions", type=int, default=2_000_000)
    parser.add_argument("--timeout-ms", type=int, default=30_000)
    parser.add_argument(
        "--trace-window-start",
        type=int,
        default=0,
        help="record full instruction+register window from this instruction count",
    )
    parser.add_argument(
        "--patch-stack-value",
        type=lambda value: int(value, 0),
        default=None,
        help="patch [rsp] to this value right before the pop-r8 handler at 0x1809c005e "
        "executes (targeted stack-gap experiment; e.g. 0x1807b6980)",
    )
    parser.add_argument(
        "--patch-stack-times",
        type=int,
        default=1,
        help="how many times to apply --patch-stack-value (default 1)",
    )
    parser.add_argument(
        "--watch-stack",
        action="store_true",
        help="record every read/write into the execution stack region (0x7FFE000000..)",
    )
    parser.add_argument(
        "--synthesize-unmapped-reads",
        action="store_true",
        help="map zero-filled pages for otherwise-unmapped data reads; records every synthetic page",
    )
    parser.add_argument(
        "--max-synthetic-pages",
        type=int,
        default=256,
        help="safety cap for --synthesize-unmapped-reads (default 256 pages)",
    )
    parser.add_argument(
        "--snapshot-vm-jumps",
        action="store_true",
        help="attach VM context (0x200 bytes), RSP and 0x100 stack bytes to each "
        "recorded VM indirect jump for trace-lifter before/after validation",
    )
    parser.add_argument(
        "--fast-diff-trace",
        action="store_true",
        help="offline differential mode: capture only known VM jump sources and "
        "disable expensive diagnostic memory logging/disassembly",
    )
    parser.add_argument(
        "--compact-fast-diff", action="store_true",
        help="with --fast-diff-trace, omit context/stack/register snapshots from jumps",
    )
    parser.add_argument(
        "--diff-source-trace", type=Path,
        default=HERE / "encrypt_vm_jump_snapshots_registers_700k.json",
        help="baseline JSON supplying indirect-jump source address and operand register",
    )
    parser.add_argument(
        "--max-vm-jumps", type=int, default=0,
        help="stop after this many captured VM jumps in --fast-diff-trace mode",
    )
    parser.add_argument(
        "--stop-on-key-read", action="store_true",
        help="stop fast differential replay at the first decoded-key buffer read",
    )
    parser.add_argument(
        "--stop-on-nonce-read", action="store_true",
        help="stop fast differential replay at the first seeded nonce-buffer read",
    )
    parser.add_argument(
        "--patch-ret-stack-trampoline", action="store_true",
        help="offline experiment: replace stale stack code reached by 0x180c25a53 ret "
        "with an absolute jump to the VM target stored at [rsp+0x78]",
    )
    parser.add_argument(
        "--patch-ret-target", type=lambda value: int(value, 0), default=None,
        help="offline experiment: after nonce seed, replace [rsp] at 0x180c25a53 "
        "with this candidate generated-code address",
    )
    parser.add_argument(
        "--patch-context-pointer61",
        type=lambda value: int(value, 0),
        default=None,
        help="replace context+0x61 at its proven producer handler (offline context reconstruction)",
    )
    parser.add_argument(
        "--fast-tag-replay", action="store_true",
        help="disable VM dispatch/disassembly/heap/context tracing unrelated to tag SHA capture; "
        "keeps allocator stubs, nonce injection, SHA events, host-call workarounds and errors",
    )
    parser.add_argument(
        "--stop-on-sha-update-after-nonce", action="store_true",
        help="stop the emulator at the first SHA update (0x18042b9b0) that executes "
        "after the nonce buffer has been seeded, dumping the data pointer, length, "
        "context and surrounding registers/stack (used to recover the tag MAC input)",
    )
    parser.add_argument(
        "--watch-sha-context", type=lambda value: int(value, 0), default=None,
        help="additionally dump data_hex/length for SHA updates whose context equals "
        "this address (in addition to the generic --stop-on-sha-update-after-nonce stop)",
    )
    parser.add_argument(
        "--stub-kernel32-ispfp", type=int, default=None,
        help="intercept kernel32!IsProcessorFeaturePresent (export thunk 0x7ff84445d920) "
        "and return this value instead of executing it. The real kernel32 file has an "
        "unrelocated forwarder IAT that otherwise crashes at 0xb8c12. Pass 1 to model a "
        "modern CPU that supports the probed feature.",
    )
    parser.add_argument(
        "--stub-host-calls-tag", action="store_true",
        help="during the tag phase (instruction >= tag_phase_instruction), intercept "
        "FETCH_UNMAPPED crashes at small RVA-like addresses (host functions whose IAT "
        "slots the raw module did not populate) and emulate a host call that returns 0: "
        "set RAX=0, pop the return address from [RSP], and continue. Experimental: lets "
        "the emulator blast past unrelocated host dispatches to reach the tag SHA update.",
    )
    parser.add_argument(
        "--tag-phase-instruction", type=int, default=4_000_000,
        help="instruction count at which the tag phase begins (host-call stubbing applies "
        "only at or after this point; default 4000000)",
    )
    parser.add_argument(
        "--stub-crt-1000", action="store_true",
        help="intercept execution at 0x1805a1000 (the CRT fail-fast/init helper reached "
        "right after IsProcessorFeaturePresent) and emulate an immediate return: pop the "
        "return address from [RSP] and continue there. This bypasses the broken module "
        "IAT host calls inside that CRT helper so the emulator can reach the tag SHA update.",
    )
    parser.add_argument(
        "--zero-integrity-flags", action="store_true",
        help="zero the VM anti-tamper/integrity-check byte flags at 0x180a4f75e and "
        "0x180a9777f (checked by `cmp byte ptr [rbp+0x24f75e],0` / `cmp byte ptr "
        "[rbp+0x11977f],0` with rbp=bugland base 0x180980000). These checks gate the "
        "fail-fast path; zeroing them may let the VM take the non-fail branch toward the "
        "tag SHA update.",
    )
    parser.add_argument(
        "--stub-security-cookie", action="store_true",
        help="intercept the module's __security_check_cookie at 0x180416750 and always "
        "take the pass path (rcx==0 -> ret). The GS stack-cookie check fails in the "
        "emulator (rdx != r8) because the async VM stack lacks the runtime cookie, "
        "triggering __report_gsfailure -> __fastfail(STATUS_STACK_BUFFER_OVERRUN). "
        "Forcing the check to pass may let the VM reach the tag SHA update.",
    )
    parser.add_argument(
        "--stub-crt-helpers", action="store_true",
        help="intercept the CRT helpers 0x1805a1130 and 0x1805a11a4 (called from the "
        "0x1805a1000 path right after IsProcessorFeaturePresent) and make each return 0 "
        "immediately. These helpers call host functions (RtlCaptureContext etc.) through "
        "unrelocated module IAT slots that crash the emulator; skipping them lets "
        "0x1805a1000 reach its final `ret` back to the VM so the tag SHA can proceed.",
    )
    parser.add_argument(
        "--trace-failfast-code", action="store_true",
        help="record every write to the execution stack of the dword 0xc0000409 "
        "(STATUS_STACK_BUFFER_OVERRUN, little-endian 090400c0). Used to find which VM "
        "bytecode/handler stages the anti-tamper fail code.",
    )
    parser.add_argument(
        "--skip-int3", action="store_true",
        help="in the tag phase (instruction >= tag_phase_instruction), treat int3 (0xCC) "
        "instructions as NOPs (advance RIP past them). The module uses int3 as a soft "
        "trap that a real-process SEH handler would skip; the emulator lacks SEH and "
        "crashes (UC_ERR_EXCEPTION). Skipping them may let the VM continue past the "
        "fail/trap path toward the tag SHA update.",
    )
    parser.add_argument(
        "--dump-tag-buffers", action="store_true",
        help="at the tag-phase fail point (instruction >= tag_phase_instruction, near the "
        "int3/fail dispatch), dump the SHA context and the stack/heap buffers that would "
        "be fed to the tag SHA update, to recover the MAC message input.",
    )
    parser.add_argument(
        "--test-sha-standard", action="store_true",
        help="at the first SHA init (0x18042b840) after the nonce is seeded, capture the "
        "context, then directly invoke the module SHA update (0x18042b9b0) with a known "
        "64-byte message and read the resulting context state. Used to determine whether "
        "the module's SHA-256 is standard or a custom variant.",
    )
    parser.add_argument(
        "--reconstruct-keystream-state",
        action="store_true",
        help="reconstruct context+0xc5 as plaintext_object-0x530 (64 bytes before the proven keystream buffer)",
    )
    parser.add_argument(
        "--seed-nonce",
        type=lambda value: bytes.fromhex(value),
        default=None,
        help="seed the nonce buffer (12B) with this hex value when the VM reaches "
        "nonce generation (rdi=nonce buffer); enables key-schedule completion past "
        "the CSPRNG (which needs the uncaptured VM data stack).",
    )
    parser.add_argument("--output", type=Path, default=HERE / "maxhook_encrypt_vm_emulation.json")
    return parser.parse_args()


def map_pe(uc: Uc, path: Path, base: int) -> pefile.PE:
    pe = pefile.PE(str(path))
    image_size = (pe.OPTIONAL_HEADER.SizeOfImage + 0xFFF) & ~0xFFF
    uc.mem_map(base, image_size)
    raw = path.read_bytes()
    uc.mem_write(base, raw[: pe.OPTIONAL_HEADER.SizeOfHeaders])
    for section in pe.sections:
        data = section.get_data()
        if data:
            uc.mem_write(base + section.VirtualAddress, data)
    return pe


def load_events(capture_dir: Path) -> list[dict[str, Any]]:
    return [
        json.loads(line)
        for line in (capture_dir / "events.jsonl").read_text(encoding="utf-8").splitlines()
        if line.strip()
    ]


def select_boundary_events(directory: Path, session_index: int, call_id: int) -> list[dict[str, Any]]:
    selected: list[dict[str, Any]] = []
    current_session = -1
    for event in load_events(directory):
        if event.get("kind") == "encrypt_hook_installed":
            current_session += 1
            continue
        if current_session == session_index and int(event.get("call_id", -1)) == call_id:
            selected.append(event)
    if not selected:
        raise ValueError(f"boundary session={session_index} call={call_id} not found")
    return selected


def run(args: argparse.Namespace) -> dict[str, Any]:
    if args.boundary_dir is None and (len(args.input32.encode()) != 32 or len(args.input64.encode()) != 64):
        raise ValueError("--input32 and --input64 must encode to exactly 32/64 bytes")
    uc = Uc(UC_ARCH_X86, UC_MODE_64)
    map_pe(uc, args.dll.resolve(), IMAGE_BASE)

    overlays = []
    region_pattern = re.compile(r"region_([0-9a-fA-F]+)\.bin$")
    # Load ALL dump regions (module + heap + system DLL) so environment pointers
    # (native heap, system DLL IAT) resolve instead of being zero-filled.
    for path in sorted(args.dump_dir.glob("region_*.bin")):
        match = region_pattern.fullmatch(path.name)
        if not match:
            continue
        address = int(match.group(1), 16)
        if address == BUGLAND_BASE:
            continue
        # Differential runs use the proven 16 module overlays from the clean
        # replay. Avoid reading 5.7 GB / 10k+ unrelated process-heap files.
        if args.fast_diff_trace and address >= 0x183000000:
            continue
        data = path.read_bytes()
        try:
            # Map the region first, but only for regions that are NOT already
            # mapped by map_pe (module) or the explicit setup below.  Mapping
            # every one of the 10764 dump regions individually is too slow and
            # memory-heavy, so only map on-demand-writable regions we actually
            # need: heap regions (>= 0x1ef0000000) and system DLLs.
            page_lo = address & ~0xFFF
            page_hi = (address + len(data) + 0xFFF) & ~0xFFF
            if address >= 0x1EF0000000:  # Java heap / large heap regions only
                try:
                    uc.mem_map(page_lo, page_hi - page_lo)
                except UcError:
                    pass  # already mapped
            uc.mem_write(address, data)
        except UcError:
            continue
        overlays.append({"file": path.name, "address": hex(address), "bytes": len(data)})
    bugland = args.bugland.read_bytes()
    uc.mem_write(BUGLAND_BASE, bugland)

    # Zero the VM anti-tamper/integrity-check byte flags that gate the fail-fast
    # path (`cmp byte ptr [rbp+0x24f75e],0` / `cmp byte ptr [rbp+0x11977f],0`
    # with rbp = bugland base 0x180980000). The async bugland snapshot holds
    # code bytes there that differ from the live process, so the check fails and
    # the VM enters __fastfail before the tag SHA update. Zeroing lets it take
    # the non-fail branch.
    if args.zero_integrity_flags:
        for flag_addr in (0x180A4F75E, 0x180A9777F):
            try:
                uc.mem_write(flag_addr, b"\x00")
            except UcError:
                pass

    # Overwrite the VM context with a real-machine entry snapshot so the
    # emulator starts from the same (persistent, decrypted) context the real
    # process uses, instead of the on-disk encrypted/initial form.
    if args.vm_context_snapshot is not None:
        snapshot = args.vm_context_snapshot.read_bytes()
        if len(snapshot) < 512:
            raise ValueError("vm-context-snapshot must be at least 512 bytes")
        uc.mem_write(VM_RBP, snapshot[:512])

    # The old dump's KERNEL32 base is stable in modules_37988.txt.  Mapping the
    # local same-size image lets forwarding thunks execute; the MaxHook CRT
    # allocator itself is stubbed below so no real Windows calls are made.
    kernel32_base = 0x7FF844420000
    kernel32_path = Path(os.environ["WINDIR"]) / "System32" / "kernel32.dll"
    map_pe(uc, kernel32_path, kernel32_base)

    events = load_events(args.capture_dir)
    stack_event = next(
        event
        for event in events
        if event.get("kind") == "send_stack"
        and str(event.get("request_id")) == args.request_id
    )
    stack_bytes = (args.capture_dir / stack_event["file"]).read_bytes()
    api_rsp = int(stack_event["stack_pointer"], 16)
    stack_low = api_rsp & ~0xFFF
    stack_high = (api_rsp + len(stack_bytes) + 0xFFF) & ~0xFFF
    uc.mem_map(stack_low, stack_high - stack_low)
    uc.mem_write(api_rsp, stack_bytes)
    builder_rbp = api_rsp + 0x238

    def ensure_mapped(address: int, size: int) -> None:
        start = address & ~0xFFF
        end = (address + max(size, 1) + 0xFFF) & ~0xFFF
        regions = list(uc.mem_regions())
        for page in range(start, end, 0x1000):
            if not any(low <= page <= high for low, high, _permissions in regions):
                uc.mem_map(page, 0x1000)
                regions.append((page, page + 0xFFF, 7))

    boundary: dict[str, Any] | None = None
    if args.boundary_dir is not None:
        boundary_dir = args.boundary_dir.resolve()
        boundary_events = select_boundary_events(
            boundary_dir, args.boundary_session, args.boundary_call
        )
        enter = next(event for event in boundary_events if event.get("kind") == "encrypt_enter")
        frame = next(event for event in boundary_events if event.get("kind") == "builder_frame")
        builder_rbp = int(frame["builder_rbp"], 16)
        restored_files: list[dict[str, Any]] = []
        for event in boundary_events:
            file_name = event.get("file")
            if not file_name:
                continue
            path = boundary_dir / file_name
            if not path.is_file():
                raise FileNotFoundError(path)
            data = path.read_bytes()
            if hashlib.sha256(data).hexdigest() != event.get("sha256"):
                raise ValueError(f"boundary file was overwritten or changed: {path.name}")
            kind = event.get("kind")
            if kind == "builder_frame":
                address = builder_rbp - 0x80
            elif kind == "context_dump":
                address = int(event["context_object"], 16)
            elif kind in {"ctx_ptr0", "ctx_ptr1", "ctx_ptr2"}:
                address = int(event["ptr"], 16)
            elif kind == "encrypt_string" and event.get("phase") == "input":
                address = int(event["data_pointer"], 16)
            else:
                continue
            ensure_mapped(address, len(data) + 1)
            uc.mem_write(address, data + (b"\x00" if kind == "encrypt_string" else b""))
            restored_files.append({
                "kind": kind,
                "label": event.get("label"),
                "address": hex(address),
                "bytes": len(data),
                "sha256": event.get("sha256"),
            })
            if kind == "encrypt_string" and event.get("phase") == "input":
                object_address = int(event["object_pointer"], 16)
                size = int(event["size"])
                capacity = int(event["capacity"])
                ensure_mapped(object_address, 32)
                uc.mem_write(
                    object_address,
                    struct.pack("<QQQQ", address, 0, size, capacity),
                )
        boundary = {
            "directory": str(boundary_dir),
            "session_index": args.boundary_session,
            "call_id": args.boundary_call,
            "enter": enter,
            "restored_files": restored_files,
        }

    execution_stack = 0x7FFE000000
    execution_stack_size = 0x200000
    uc.mem_map(execution_stack, execution_stack_size)
    entry_rsp = execution_stack + execution_stack_size - 0x1008
    uc.reg_write(UC_X86_REG_RSP, entry_rsp)
    uc.mem_write(entry_rsp, struct.pack("<Q", RETURN_SENTINEL))

    heap_base = 0x20000000000
    heap_size = 0x2000000
    uc.mem_map(heap_base, heap_size)
    heap_cursor = heap_base + 0x100000
    allocations: list[dict[str, Any]] = []
    nonce_allocations: list[int] = []

    def allocate(size: int, reason: str) -> int:
        nonlocal heap_cursor
        size = max(int(size), 1)
        pointer = (heap_cursor + 15) & ~15
        heap_cursor = pointer + size + 16
        if heap_cursor >= heap_base + heap_size:
            raise RuntimeError("diagnostic heap exhausted")
        uc.mem_write(pointer, b"\x00" * size)
        allocations.append({"pointer": hex(pointer), "bytes": size, "reason": reason})
        if size == 12 and reason == "MaxHook CRT allocator":
            nonce_allocations.append(pointer)
        return pointer

    def set_string(object_address: int, data: bytes, label: str) -> None:
        pointer = allocate(len(data) + 1, label)
        uc.mem_write(pointer, data)
        capacity = max(0x1F, len(data) | 0xF)
        uc.mem_write(object_address, struct.pack("<QQQQ", pointer, 0, len(data), capacity))

    if boundary is None:
        set_string(builder_rbp + 0xE0, args.input32.encode(), "input32")
        set_string(builder_rbp + 0x1A0, args.input64.encode(), "input64")
        set_string(builder_rbp + 0x100, args.plaintext.encode(), "plaintext")
        output_object = builder_rbp + 0x290
        input32_object = builder_rbp + 0xE0
        input64_object = builder_rbp + 0x1A0
        context_object = builder_rbp + 0x38
        plaintext_object = builder_rbp + 0x100
        uc.mem_write(output_object, b"\x00" * 0x80)
    else:
        enter = boundary["enter"]
        output_object = int(enter["output_object"], 16)
        input32_object = int(enter["input32_object"], 16)
        input64_object = int(enter["input64_object"], 16)
        context_object = int(enter["context_object"], 16)
        plaintext_object = int(enter["plaintext_object"], 16)
    if args.reconstruct_keystream_state:
        keystream_state = plaintext_object - 0x530
        ensure_mapped(keystream_state, 0x80)
        uc.mem_write(keystream_state, b"\x00" * 0x80)
        # Do not pre-seed overlapping VM register slots (+0xb5/+0xc5/+0x61):
        # the prologue legitimately reuses them. Repair only the exact loaded
        # host register at the proven pointer consumer below.
    else:
        keystream_state = None
    uc.reg_write(UC_X86_REG_RBP, builder_rbp)
    uc.reg_write(UC_X86_REG_RCX, output_object)
    uc.reg_write(UC_X86_REG_RDX, input32_object)
    uc.reg_write(UC_X86_REG_R8, input64_object)
    uc.reg_write(UC_X86_REG_R9, context_object)
    uc.mem_write(entry_rsp + 0x28, struct.pack("<Q", plaintext_object))

    # The captured R9 context contains a pointer into this high system range.
    system_page = 0x7FFFC5320000
    uc.mem_map(system_page, 0x10000)
    teb = 0x7FFDE00000
    uc.mem_map(teb, 0x10000)
    uc.reg_write(UC_X86_REG_GS_BASE, teb)
    uc.mem_write(teb + 0x30, struct.pack("<Q", teb))
    uc.mem_write(teb + 0x188, struct.pack("<Q", teb + 0x1000))
    # The VM reads TEB.ProcessEnvironmentBlock ([gs:0x58]) to locate the PEB.
    # Leave it zeroed on real hardware the loader fills it; in emulation we
    # point it at a minimal mapped PEB so [gs:0x58] is non-zero (the absence of
    # this field was the root cause of the base-slot zeroing cascade).
    peb = 0x7FFDE10000
    uc.mem_map(peb, 0x10000)
    uc.mem_write(teb + 0x58, struct.pack("<Q", peb))
    # PEB.ImageBaseAddress (0x10) is read; ProcessHeaps/BeingDebugged etc. are
    # anti-tamper probes.  Fill a small set of PEB fields the VM dereferences so
    # [gs:0x58]-derived table lookups land on mapped, non-zero memory.  These
    # values are NOT part of the key material (key = decoded input64), so any
    # plausible non-zero placeholder is sufficient to get past the probe.
    uc.mem_write(peb + 0x10, struct.pack("<Q", IMAGE_BASE))
    # PEB.BeingDebugged (0x02) must be 0; leave mapped page zeroed.
    # A scratch pointer region for PEB fields the VM indexes into (e.g. +0x158).
    peb_scratch = 0x7FFDE20000
    uc.mem_map(peb_scratch, 0x10000)
    for off in (0x118, 0x128, 0x158, 0x168, 0x178):
        uc.mem_write(peb + off, struct.pack("<Q", peb_scratch + off))

    # Do not inherit a held lock from an asynchronous snapshot.
    uc.mem_write(VM_RBP + 0xE7, b"\x00" * 4)

    disassembler = Cs(CS_ARCH_X86, CS_MODE_64)
    recent: deque[dict[str, Any]] = deque(maxlen=64)
    probes: list[dict[str, Any]] = []
    vm_pointer_slot_writes: list[dict[str, Any]] = []
    pointer61_patches: list[dict[str, Any]] = []
    watched_memory_accesses: deque[dict[str, Any]] = deque(maxlen=4096)
    heap_writes: deque[dict[str, Any]] = deque(maxlen=8192)
    heap_reads: deque[dict[str, Any]] = deque(maxlen=8192)
    dispatch_trace: deque[dict[str, Any]] = deque(maxlen=2048)
    dispatch_count = 0
    dispatch_target_counts: dict[str, int] = {}
    store32_trace: list[dict[str, Any]] = []
    generator_trace: list[dict[str, Any]] = []
    word_producer_trace: list[dict[str, Any]] = []
    fold_edx_trace: list[dict[str, Any]] = []
    fold_arith_trace: list[dict[str, Any]] = []
    vm_indirect_jumps: deque[dict[str, Any]] = deque(maxlen=4096)
    table_write_trace: deque[dict[str, Any]] = deque(maxlen=1024)
    table_write_count = 0
    table_write_high_index_count = 0
    trace_window: list[dict[str, Any]] = []
    stack_accesses: deque[dict[str, Any]] = deque(maxlen=8192)
    nonce_seed_log: list[dict[str, Any]] = []
    state = {"instructions": 0, "stopped_by_limit": False, "pending_pointer61_patch": None}
    patch_stack_remaining = args.patch_stack_times if args.patch_stack_value is not None else 0
    diff_jump_sources: dict[int, str] = {}
    fast_diff_key_reads: list[dict[str, Any]] = []
    fast_diff_nonce_reads: list[dict[str, Any]] = []
    ret_trampoline_patches: list[dict[str, Any]] = []
    ret_c25a53_events: list[dict[str, Any]] = []
    sha_component_events: list[dict[str, Any]] = []
    ispfp_stub_events: list[dict[str, Any]] = []
    host_call_stubs: list[dict[str, Any]] = []
    host_call_stub_pages: set[int] = set()
    null_read_stubs: list[dict[str, Any]] = []
    crt_1000_stubs: list[dict[str, Any]] = []
    security_cookie_stubs: list[dict[str, Any]] = []
    crt_helper_stubs: list[dict[str, Any]] = []
    failfast_code_writes: list[dict[str, Any]] = []
    skipped_int3: list[dict[str, Any]] = []
    tag_buffer_dump: list[dict[str, Any]] = []
    sha_std_test: list[dict[str, Any]] = []

    def _capture_tag_buffers(uc_: Uc) -> dict[str, Any]:
        def safe_read(a: int, n: int) -> str | None:
            try:
                return bytes(uc_.mem_read(a, n)).hex()
            except UcError:
                return None
        rsp = uc_.reg_read(UC_X86_REG_RSP)
        out: dict[str, Any] = {
            "instruction": state["instructions"],
            "rip": hex(uc_.reg_read(UC_X86_REG_RIP)),
            "rsp": hex(rsp),
            "registers": {name: hex(uc_.reg_read(reg)) for name, reg in REGISTERS.items()},
            "vip": None,
        }
        try:
            out["vip"] = hex(struct.unpack("<Q", bytes(uc_.mem_read(VM_RBP + 0x6D, 8)))[0])
        except UcError:
            pass
        # stack SHA ctx + 64B buffers
        out["stack_0x7ffe1fec00"] = safe_read(0x7FFE1FEC00, 0xE0)
        # heap SHA ctx and nonce / key / aad buffers observed in the tag phase
        out["heap_0x20000100000"] = safe_read(0x20000100000, 0x100)
        # allocations
        allocs = []
        for a in allocations:
            allocs.append({**a, "content": safe_read(int(a["pointer"], 16), min(a["bytes"], 160))})
        out["allocations"] = allocs
        return out
    sha_context_accesses: list[dict[str, Any]] = []
    if args.fast_diff_trace:
        source_doc = json.loads(args.diff_source_trace.read_text(encoding="utf-8"))
        source_items = source_doc.get("vm_indirect_jumps", source_doc)
        for item in source_items:
            operand = item.get("operand")
            if operand in REGISTERS:
                diff_jump_sources[int(item["source"], 16)] = operand
        if not diff_jump_sources:
            raise ValueError("--diff-source-trace contains no source/operand pairs")

    def emulate_return(value: int) -> None:
        rsp = uc.reg_read(UC_X86_REG_RSP)
        return_address = struct.unpack("<Q", bytes(uc.mem_read(rsp, 8)))[0]
        uc.reg_write(UC_X86_REG_RSP, rsp + 8)
        uc.reg_write(UC_X86_REG_RAX, value)
        uc.reg_write(UC_X86_REG_RIP, return_address)

    def on_code(_uc: Uc, address: int, size: int, _user: Any) -> None:
        state["instructions"] += 1
        nonlocal dispatch_count, patch_stack_remaining
        # Skip int3 (0xCC) soft traps in the tag phase (a real-process SEH handler
        # would skip them; the emulator lacks SEH and crashes on UC_ERR_EXCEPTION).
        if args.skip_int3 and state["instructions"] >= args.tag_phase_instruction:
            try:
                first_byte = bytes(uc.mem_read(address, 1))[0]
                if first_byte == 0xCC:
                    skipped_int3.append({
                        "instruction": state["instructions"],
                        "rip": hex(address),
                    })
                    uc.reg_write(UC_X86_REG_RIP, address + 1)
                    return
            except UcError:
                pass
        # At the tag-phase fail point, dump the buffers that would feed the tag SHA.
        if (
            args.dump_tag_buffers
            and state["instructions"] >= args.tag_phase_instruction
            and not tag_buffer_dump
        ):
            tag_buffer_dump.append(_capture_tag_buffers(uc))
        if (
            args.dump_tag_buffers
            and state["instructions"] >= args.tag_phase_instruction
            and address in (0x18041674C, 0x180416750, 0x180C0538C, 0x1805A1000)
        ):
            tag_buffer_dump.append(_capture_tag_buffers(uc))
        # Detect the exact instruction where the VM context base rbp diverges
        # from VM_RBP (0x18098c884) -- the root cause of the stack desync that
        # prevents reaching store32.
        rbp_now = uc.reg_read(UC_X86_REG_RBP)
        if rbp_now != VM_RBP and not state.get("rbp_divergence_recorded"):
            state["rbp_divergence_recorded"] = True
            state["rbp_divergence"] = {
                "instruction": state["instructions"],
                "rip": hex(address),
                "rbp": hex(rbp_now),
                "rsp": hex(uc.reg_read(UC_X86_REG_RSP)),
            }
        # After the VM wrapper restores all registers and returns into a stale
        # captured-stack address (not our sentinel), treat it as graceful
        # completion: execution has left the module with a populated output.
        # (round 222: this is a FALSE completion for return-oriented dispatch;
        #  disable when --seed-nonce is provided so execution continues to store32)
        if (state["instructions"] > 1_000_000
                and not (IMAGE_BASE <= address < IMAGE_BASE + 0x30000000)
                and address != RETURN_SENTINEL
                and not state.get("completed")
                and args.seed_nonce is None):
            state["completed"] = True
            uc.emu_stop()
        if args.seed_nonce is not None and not state.get("nonce_seeded"):
            # Seed the nonce buffer when the VM is about to write it: rdi points
            # at the 12-byte nonce allocation and rsi == 0xc (nonce length).
            rdi = uc.reg_read(UC_X86_REG_RDI)
            rsi = uc.reg_read(UC_X86_REG_RSI)
            nonce_buffer = nonce_allocations[-1] if nonce_allocations else None
            if nonce_buffer is not None and rdi == nonce_buffer and rsi == 0xc:
                uc.mem_write(nonce_buffer, args.seed_nonce)
                state["nonce_seeded"] = True
                nonce_seed_log.append({
                    "instruction": state["instructions"],
                    "rip": hex(address),
                    "nonce": args.seed_nonce.hex(),
                })
        if address in {0x18042B840, 0x18042B9B0, 0x18042BB00}:
            rcx_sha = uc.reg_read(UC_X86_REG_RCX)
            rdx_sha = uc.reg_read(UC_X86_REG_RDX)
            r8_sha = uc.reg_read(UC_X86_REG_R8)
            event = {
                "instruction": state["instructions"],
                "address": hex(address),
                "kind": ("init" if address == 0x18042B840 else
                         "update" if address == 0x18042B9B0 else "finalize"),
                "rcx": hex(rcx_sha), "rdx": hex(rdx_sha), "r8": hex(r8_sha),
                "nonce_seeded": bool(state.get("nonce_seeded")),
            }
            try:
                event["context_before_hex"] = bytes(uc.mem_read(rcx_sha, 0x70)).hex()
            except UcError:
                event["context_before_hex"] = None
            if address in (0x18042B9B0, 0x18042BB00):
                try:
                    data = bytes(uc.mem_read(rdx_sha, min(int(r8_sha), 512)))
                except UcError:
                    data = None
                event["data_hex"] = None if data is None else data.hex()
            if address == 0x18042B9B0:
                # Tag MAC input capture: stop at the first SHA update after the
                # nonce is seeded so the message layout of the authentication
                # construction can be read out at the exact update boundary.
                if (
                    args.stop_on_sha_update_after_nonce
                    and state.get("nonce_seeded")
                    and not state.get("stopped_on_sha_update")
                ):
                    state["stopped_on_sha_update"] = True
                    event["stopped_here"] = True
                    event["registers"] = {
                        name: hex(uc.reg_read(register))
                        for name, register in REGISTERS.items()
                    }
                    rsp_now = uc.reg_read(UC_X86_REG_RSP)
                    try:
                        event["stack_hex"] = bytes(uc.mem_read(rsp_now, 0x100)).hex()
                    except UcError:
                        event["stack_hex"] = None
                    try:
                        event["vip"] = hex(struct.unpack(
                            "<Q", bytes(uc.mem_read(VM_RBP + 0x6D, 8)))[0])
                    except UcError:
                        event["vip"] = None
                    uc.emu_stop()
            sha_component_events.append(event)
        # Test whether the module SHA-256 is standard: capture the module's own
        # SHA-update state (from the naturally-executing domain KDF) after each
        # write to the KDF SHA context. No nested emu_start needed.
        if args.test_sha_standard and address == 0x18042B9B0:
            rcx_sha_u = uc.reg_read(UC_X86_REG_RCX)
            rdx_sha_u = uc.reg_read(UC_X86_REG_RDX)
            r8_sha_u = uc.reg_read(UC_X86_REG_R8)
            try:
                data_u = bytes(uc.mem_read(rdx_sha_u, min(int(r8_sha_u), 512)))
            except UcError:
                data_u = None
            sha_std_test.append({
                "kind": "update_entry",
                "instruction": state["instructions"],
                "ctx": hex(rcx_sha_u),
                "data_len": int(r8_sha_u) if r8_sha_u else None,
                "data_hex": None if data_u is None else data_u.hex(),
                "ctx_before_state": bytes(uc.mem_read(rcx_sha_u, 32)).hex(),
            })
        # kernel32!IsProcessorFeaturePresent / kernel32!RtlCaptureContext
        # forwarder thunks: the on-disk kernel32 has an unrelocated IAT so jumping
        # through them reads garbage and crashes. Intercept, return a synthetic
        # value and continue at the address the real call would `ret` to (already
        # on top of the stack, per the VM's call-by-`ret` convention).
        if (
            args.stub_kernel32_ispfp is not None
            and address in (0x7FF84445D920, 0x7FF844476C70)
        ):
            uc.reg_write(UC_X86_REG_RAX, args.stub_kernel32_ispfp)
            rsp_ret = uc.reg_read(UC_X86_REG_RSP)
            try:
                return_target = struct.unpack("<Q", bytes(uc.mem_read(rsp_ret, 8)))[0]
            except UcError:
                return_target = None
            ispfp_stub_events.append({
                "instruction": state["instructions"],
                "address": hex(address),
                "feature_arg": hex(uc.reg_read(UC_X86_REG_RCX)),
                "return_value": args.stub_kernel32_ispfp,
                "rsp": hex(rsp_ret),
                "return_target": hex(return_target) if return_target else None,
            })
            if return_target is not None and (IMAGE_BASE <= return_target < IMAGE_BASE + 0x30000000):
                uc.reg_write(UC_X86_REG_RSP, rsp_ret + 8)
                uc.reg_write(UC_X86_REG_RIP, return_target)
        # Module __security_check_cookie at 0x180416750: the GS stack-cookie
        # check fails in the emulator because the async VM stack lacks the
        # runtime cookie, triggering __report_gsfailure. Force the pass path.
        if args.stub_security_cookie and address == 0x180416750:
            uc.reg_write(UC_X86_REG_RCX, 0)   # makes `test rcx,rcx; je` -> ret
            security_cookie_stubs.append({
                "instruction": state["instructions"],
                "rdx_before": hex(uc.reg_read(UC_X86_REG_RDX)),
            })
        # The int3 (0xCC) at 0x18041674d sits just before __security_check_cookie
        # (0x180416750) and fires as UC_ERR_EXCEPTION in the emulator. Skip it by
        # jumping straight to the cookie-check entry.
        if args.stub_security_cookie and address == 0x18041674D:
            uc.reg_write(UC_X86_REG_RIP, 0x180416750)
        # CRT fail-fast/init helper 0x1805a1000: bypass the broken module-IAT
        # host calls inside it by emulating an immediate return to its caller.
        if args.stub_crt_1000 and address == 0x1805A1000:
            rsp_crt = uc.reg_read(UC_X86_REG_RSP)
            try:
                crt_ret = struct.unpack("<Q", bytes(uc.mem_read(rsp_crt, 8)))[0]
            except UcError:
                crt_ret = None
            uc.reg_write(UC_X86_REG_RAX, 0)
            crt_1000_stubs.append({
                "instruction": state["instructions"],
                "rsp": hex(rsp_crt),
                "return_target": hex(crt_ret) if crt_ret else None,
            })
            if crt_ret is not None and (IMAGE_BASE <= crt_ret < IMAGE_BASE + 0x30000000):
                uc.reg_write(UC_X86_REG_RSP, rsp_crt + 8)
                uc.reg_write(UC_X86_REG_RIP, crt_ret)
        # CRT helpers 0x1805a1130 / 0x1805a11a4: make each return 0 immediately so
        # the broken module-IAT host calls inside them are skipped.
        if args.stub_crt_helpers and address in (0x1805A1130, 0x1805A11A4):
            rsp_h = uc.reg_read(UC_X86_REG_RSP)
            try:
                hret = struct.unpack("<Q", bytes(uc.mem_read(rsp_h, 8)))[0]
            except UcError:
                hret = None
            uc.reg_write(UC_X86_REG_RAX, 0)
            crt_helper_stubs.append({
                "instruction": state["instructions"],
                "address": hex(address),
                "rsp": hex(rsp_h),
                "return_target": hex(hret) if hret else None,
            })
            if hret is not None:
                uc.reg_write(UC_X86_REG_RSP, rsp_h + 8)
                uc.reg_write(UC_X86_REG_RIP, hret)
        if address == 0x180C25A53:
            rsp_ret = uc.reg_read(UC_X86_REG_RSP)
            try:
                ret_target = struct.unpack("<Q", bytes(uc.mem_read(rsp_ret, 8)))[0]
                try:
                    target_bytes = bytes(uc.mem_read(ret_target, 32)).hex()
                except UcError:
                    target_bytes = None
                ret_c25a53_events.append({
                    "instruction": state["instructions"],
                    "nonce_seeded": bool(state.get("nonce_seeded")),
                    "rsp": hex(rsp_ret),
                    "target": hex(ret_target),
                    "target_bytes32": target_bytes,
                    "vip": hex(struct.unpack(
                        "<Q", bytes(uc.mem_read(VM_RBP + 0x6D, 8))
                    )[0]),
                    "key_low32": hex(struct.unpack(
                        "<I", bytes(uc.mem_read(VM_RBP + 0x0A, 4))
                    )[0]),
                    "stack_qwords": [
                        hex(value) for value in struct.unpack(
                            "<16Q", bytes(uc.mem_read(rsp_ret, 0x80))
                        )
                    ],
                    "registers": {
                        name: hex(uc.reg_read(register))
                        for name, register in REGISTERS.items()
                    },
                })
            except UcError as exc:
                ret_c25a53_events.append({
                    "instruction": state["instructions"], "read_error": str(exc)
                })
        if (
            address == 0x180C25A53
            and args.patch_ret_target is not None
            and state.get("nonce_seeded")
        ):
            rsp_ret = uc.reg_read(UC_X86_REG_RSP)
            old_target = struct.unpack("<Q", bytes(uc.mem_read(rsp_ret, 8)))[0]
            uc.mem_write(rsp_ret, struct.pack("<Q", args.patch_ret_target))
            ret_trampoline_patches.append({
                "instruction": state["instructions"], "rsp": hex(rsp_ret),
                "old_target": hex(old_target), "target": hex(args.patch_ret_target),
                "mode": "replace_ret_target",
            })
        if (
            address == 0x180C25A53
            and args.patch_ret_stack_trampoline
            and state.get("nonce_seeded")
        ):
            rsp_ret = uc.reg_read(UC_X86_REG_RSP)
            trampoline = struct.unpack("<Q", bytes(uc.mem_read(rsp_ret, 8)))[0]
            target = struct.unpack("<Q", bytes(uc.mem_read(rsp_ret + 0x78, 8)))[0]
            code = b"\x48\xB8" + struct.pack("<Q", target) + b"\xFF\xE0"
            uc.mem_write(trampoline, code)
            ret_trampoline_patches.append({
                "instruction": state["instructions"], "rsp": hex(rsp_ret),
                "trampoline": hex(trampoline), "target": hex(target),
                "bytes": code.hex(),
            })
        pending = state.get("pending_pointer61_patch")
        if pending is not None:
            patched = int(args.patch_context_pointer61)
            uc.mem_write(VM_RBP + 0x61, struct.pack("<Q", patched))
            pointer61_patches.append({**pending, "patched_value": hex(patched),
                                      "applied_instruction": state["instructions"]})
            state["pending_pointer61_patch"] = None
        if args.reconstruct_keystream_state and state["instructions"] > 1_000_000:
            # These two equivalent handlers have already loaded the pointer
            # from context+0xb5 into a host register. Changing the context slot
            # at this point is too late and corrupts earlier VM uses. Repair
            # only an out-of-module loaded pointer, directly in that register.
            if address == 0x180BF1EB2:
                loaded = uc.reg_read(UC_X86_REG_R14)
                if not (IMAGE_BASE <= loaded < IMAGE_BASE + 0x30000000):
                    uc.reg_write(UC_X86_REG_R14, 0x1808374E0)
            elif address == 0x180A831DB:
                # This equivalent consumer resolves context+0x61, whose real
                # block-boundary value is consistently 0x180835f10 (not the
                # +0xb5 table used by the r14 consumer above).
                loaded = uc.reg_read(UC_X86_REG_R15)
                if not (IMAGE_BASE <= loaded < IMAGE_BASE + 0x30000000):
                    uc.reg_write(UC_X86_REG_R15, 0x180835F10)
        if (not args.fast_tag_replay and args.trace_window_start
                and state["instructions"] >= args.trace_window_start):
            entry: dict[str, Any] = {
                "instruction": state["instructions"],
                "rip": hex(address),
                "size": size,
            }
            try:
                entry["bytes"] = bytes(uc.mem_read(address, size)).hex()
            except UcError:
                entry["bytes"] = None
            # Disassembly (mnemonic + operands) for the window so the failing
            # trampoline region can be read directly instead of re-decoding bytes.
            try:
                insn_bytes = bytes(uc.mem_read(address, size))
                decoded = list(disassembler.disasm(insn_bytes, address))
                if decoded:
                    entry["mnemonic"] = decoded[0].mnemonic
                    entry["operands"] = decoded[0].op_str
            except UcError:
                pass
            entry["registers"] = {
                name: hex(uc.reg_read(register)) for name, register in REGISTERS.items()
            }
            # In the tag phase record a window of stack bytes so the SHA-data
            # buffer (staged at 0x7ffe1fec69) can be read even if we crash.
            if state["instructions"] >= 4_100_000:
                rsp_now = uc.reg_read(UC_X86_REG_RSP)
                try:
                    entry["stack_rsp"] = hex(rsp_now)
                    entry["stack_hex"] = bytes(uc.mem_read(rsp_now - 0x40, 0x100)).hex()
                except UcError:
                    entry["stack_hex"] = None
                try:
                    entry["data_buf_hex"] = bytes(uc.mem_read(0x7FFE1FEC69, 0x60)).hex()
                except UcError:
                    entry["data_buf_hex"] = None
            if address == 0x180C25A53:
                rsp_probe = uc.reg_read(UC_X86_REG_RSP)
                entry["rsp_probe"] = hex(rsp_probe)
                entry["stack_probe_hex"] = bytes(uc.mem_read(rsp_probe, 0x100)).hex()
            try:
                entry["vip"] = hex(
                    struct.unpack("<Q", bytes(uc.mem_read(VM_RBP + 0x6D, 8)))[0]
                )
            except UcError:
                entry["vip"] = None
            trace_window.append(entry)
        if not args.fast_tag_replay and address == STORE32 and len(store32_trace) < 4096:
            store32_trace.append({
                "instruction": state["instructions"],
                "rcx": hex(uc.reg_read(UC_X86_REG_RCX)),
                "edx": hex(uc.reg_read(UC_X86_REG_RDX) & 0xFFFFFFFF),
                "rsp": hex(uc.reg_read(UC_X86_REG_RSP)),
            })
        if not args.fast_tag_replay and address == GENERATOR_CANDIDATE and len(generator_trace) < 256:
            generator_trace.append({
                "instruction": state["instructions"],
                "rcx": hex(uc.reg_read(UC_X86_REG_RCX)),
                "rdx": hex(uc.reg_read(UC_X86_REG_RDX)),
                "rsp": hex(uc.reg_read(UC_X86_REG_RSP)),
            })
        if (not args.fast_tag_replay and address in WORD_PRODUCER_PUSH_SITES
                and len(word_producer_trace) < 4096):
            vip_off = WORD_PRODUCER_PUSH_SITES[address]
            try:
                vip = struct.unpack("<Q", bytes(uc.mem_read(VM_RBP + 0x6D, 8)))[0]
                bc_word = struct.unpack("<H", bytes(uc.mem_read(vip + vip_off, 2)))[0]
                slot_ptr = VM_RBP + bc_word
                slot_val = struct.unpack("<Q", bytes(uc.mem_read(slot_ptr, 8)))[0]
                word_producer_trace.append({
                    "instruction": state["instructions"],
                    "push_site": hex(address),
                    "vip_offset": hex(vip_off),
                    "bytecode_word": hex(bc_word),
                    "context_slot_offset": hex(bc_word),
                    "context_slot_value": hex(slot_val),
                })
            except UcError as exc:
                word_producer_trace.append({
                    "instruction": state["instructions"],
                    "push_site": hex(address),
                    "error": str(exc),
                })
        if not args.fast_tag_replay and address == FOLD_EDX_LOAD and len(fold_edx_trace) < 4096:
            fold_edx_trace.append({
                "instruction": state["instructions"],
                "edx": hex(uc.reg_read(UC_X86_REG_RDX) & 0xFFFFFFFF),
                "rsp": hex(uc.reg_read(UC_X86_REG_RSP)),
                "rdi": hex(uc.reg_read(UC_X86_REG_RDI)),
            })
        # Targeted fold-region arithmetic tracer (round 248): capture register
        # values at the genuine fold arithmetic ops to reveal the 6-value ->
        # register mapping.
        FOLD_ARITH_OPS = {0x180C2769B, 0x180C2769E, 0x180C276C5, 0x180C27936,
                          0x180C27743, 0x180C27747, 0x180C2774E, 0x180C27751,
                          0x180C27754, 0x180C277DF, 0x180C27953}
        if (not args.fast_tag_replay and address in FOLD_ARITH_OPS
                and len(fold_arith_trace) < 4096):
            fold_arith_trace.append({
                "instruction": state["instructions"],
                "rip": hex(address),
                "rax": hex(uc.reg_read(UC_X86_REG_RAX)),
                "rbx": hex(uc.reg_read(UC_X86_REG_RBX)),
                "rcx": hex(uc.reg_read(UC_X86_REG_RCX)),
                "rdx": hex(uc.reg_read(UC_X86_REG_RDX)),
                "rsi": hex(uc.reg_read(UC_X86_REG_RSI)),
                "rdi": hex(uc.reg_read(UC_X86_REG_RDI)),
                "rbp": hex(uc.reg_read(UC_X86_REG_RBP)),
                "r8": hex(uc.reg_read(UC_X86_REG_R8)),
                "r9": hex(uc.reg_read(UC_X86_REG_R9)),
                "r10": hex(uc.reg_read(UC_X86_REG_R10)),
                "r11": hex(uc.reg_read(UC_X86_REG_R11)),
                "r12": hex(uc.reg_read(UC_X86_REG_R12)),
                "r13": hex(uc.reg_read(UC_X86_REG_R13)),
                "r14": hex(uc.reg_read(UC_X86_REG_R14)),
                "r15": hex(uc.reg_read(UC_X86_REG_R15)),
            })
        if not args.fast_tag_replay and address == DISPATCHER:
            dispatch_count += 1
            item: dict[str, Any] = {
                "instruction": state["instructions"],
                "key_low32": None,
                "vip": None,
                "raw_dword": None,
                "raw_word_at_vip_plus4": None,
                "table": None,
                "handler_index": None,
                "handler_target": None,
                "next_vip": None,
            }
            try:
                key = struct.unpack("<I", bytes(uc.mem_read(VM_RBP + 0xA, 4)))[0]
                vip = struct.unpack("<Q", bytes(uc.mem_read(VM_RBP + 0x6D, 8)))[0]
                table = struct.unpack("<Q", bytes(uc.mem_read(VM_RBP + 0x85, 8)))[0]
                raw_dword = struct.unpack("<I", bytes(uc.mem_read(vip, 4)))[0]
                raw_word = struct.unpack("<H", bytes(uc.mem_read(vip + 4, 2)))[0]
                index = (key + raw_word) & 0xFFFF
                target = struct.unpack("<Q", bytes(uc.mem_read(table + index * 8, 8)))[0]
                item.update(
                    key_low32=hex(key),
                    vip=hex(vip),
                    raw_dword=hex(raw_dword),
                    raw_word_at_vip_plus4=hex(raw_word),
                    table=hex(table),
                    handler_index=hex(index),
                    handler_target=hex(target),
                    next_vip=hex(vip + raw_dword),
                )
                target_name = hex(target)
                dispatch_target_counts[target_name] = dispatch_target_counts.get(target_name, 0) + 1
            except UcError as exc:
                item["read_error"] = str(exc)
            dispatch_trace.append(item)
        if address == ALLOC_FUNCTION:
            requested = uc.reg_read(UC_X86_REG_RCX)
            pointer = allocate(requested, "MaxHook CRT allocator")
            recent.append({"address": hex(address), "stub": "alloc", "bytes": requested})
            emulate_return(pointer)
            return
        if address == FREE_FUNCTION:
            recent.append(
                {
                    "address": hex(address),
                    "stub": "free_noop",
                    "pointer": hex(uc.reg_read(UC_X86_REG_RCX)),
                }
            )
            emulate_return(1)
            return
        if address == MEMSET_FUNCTION:
            destination = uc.reg_read(UC_X86_REG_RCX)
            byte_value = uc.reg_read(UC_X86_REG_RDX) & 0xFF
            count = uc.reg_read(UC_X86_REG_R8)
            uc.mem_write(destination, bytes([byte_value]) * count)
            recent.append({"address": hex(address), "stub": "memset",
                           "destination": hex(destination), "value": byte_value,
                           "bytes": count})
            # memset returns its destination in RAX.
            rsp = uc.reg_read(UC_X86_REG_RSP)
            return_address = struct.unpack("<Q", bytes(uc.mem_read(rsp, 8)))[0]
            uc.reg_write(UC_X86_REG_RSP, rsp + 8)
            uc.reg_write(UC_X86_REG_RAX, destination)
            uc.reg_write(UC_X86_REG_RIP, return_address)
            return
        if (
            address == POP_R8_HANDLER
            and patch_stack_remaining > 0
            and args.patch_stack_value is not None
        ):
            # The pop-r8 handler at 0x1809c005e reads [rsp] as its operand and
            # stores it into [rdx] (the context slot).  Only patch when the
            # target slot is the base slot (context+0x26 = 0x18098c8aa) AND the
            # value about to be popped is 0 (the unrestored-stack gap), so we
            # do not corrupt the many earlier benign uses of this handler.
            target_slot = uc.reg_read(UC_X86_REG_RDX)
            rsp = uc.reg_read(UC_X86_REG_RSP)
            try:
                pending = struct.unpack("<Q", bytes(uc.mem_read(rsp, 8)))[0]
            except UcError:
                pending = None
            if target_slot == VM_RBP + 0x26 and pending == 0:
                old = hex(pending)
                uc.mem_write(rsp, struct.pack("<Q", args.patch_stack_value))
                patch_stack_remaining -= 1
                recent.append(
                    {
                        "address": hex(address),
                        "patch_stack": True,
                        "rsp": hex(rsp),
                        "target_slot": hex(target_slot),
                        "old_value": old,
                        "new_value": hex(args.patch_stack_value),
                        "instruction": state["instructions"],
                    }
                )
        if args.fast_diff_trace:
            operand = diff_jump_sources.get(address)
            if operand is not None:
                target = uc.reg_read(REGISTERS[operand])
                rsp = uc.reg_read(UC_X86_REG_RSP)
                item = {
                    "instruction": state["instructions"],
                    "source": hex(address),
                    "operand": operand,
                    "target": hex(target),
                    "key_low32": hex(struct.unpack(
                        "<I", bytes(uc.mem_read(VM_RBP + 0xA, 4))
                    )[0]),
                    "vip": hex(struct.unpack(
                        "<Q", bytes(uc.mem_read(VM_RBP + 0x6D, 8))
                    )[0]),
                }
                if not args.compact_fast_diff:
                    item.update({
                        "rbp": hex(uc.reg_read(UC_X86_REG_RBP)),
                        "rsp": hex(rsp),
                        "context_hex": bytes(uc.mem_read(VM_RBP, 0x200)).hex(),
                        "stack_top_hex": bytes(uc.mem_read(rsp, 0x100)).hex(),
                        "registers": {
                            name: hex(uc.reg_read(register))
                            for name, register in REGISTERS.items()
                        },
                    })
                if target == 0x18098ABF8:
                    try:
                        pointer45 = struct.unpack(
                            "<Q", bytes(uc.mem_read(VM_RBP + 0x45, 8))
                        )[0]
                        item["pointer45"] = hex(pointer45)
                        item["pointer45_block64_hex"] = bytes(
                            uc.mem_read(pointer45, 64)
                        ).hex()
                    except UcError as exc:
                        item["pointer45_error"] = str(exc)
                vm_indirect_jumps.append(item)
                if args.max_vm_jumps and len(vm_indirect_jumps) >= args.max_vm_jumps:
                    state["stopped_by_vm_jumps"] = True
                    uc.emu_stop()
                    return
            if state["instructions"] >= args.max_instructions:
                state["stopped_by_limit"] = True
                uc.emu_stop()
            return

        # Fast tag mode deliberately stops here: all required functional hooks
        # (SHA/nonce/allocator/host workarounds) have run, while expensive
        # Capstone decoding and VM-jump/probe logging below are skipped.
        if args.fast_tag_replay:
            if state["instructions"] >= args.max_instructions:
                state["stopped_by_limit"] = True
                uc.emu_stop()
            return

        if address in {PROBE_FIRST_DEREF, PROBE_SECOND_DEREF, PROBE_VALUE_SOURCE_LOAD}:
            r11 = uc.reg_read(UC_X86_REG_R11)
            entry = {"instruction": state["instructions"], "address": hex(address), "r11": hex(r11)}
            try:
                entry["qword_at_r11"] = hex(struct.unpack("<Q", bytes(uc.mem_read(r11, 8)))[0])
            except UcError:
                entry["qword_at_r11"] = None
            if address == PROBE_VALUE_SOURCE_LOAD:
                source = uc.reg_read(UC_X86_REG_R10)
                entry["source_r10"] = hex(source)
                try:
                    entry["qword_at_source_r10"] = hex(
                        struct.unpack("<Q", bytes(uc.mem_read(source, 8)))[0]
                    )
                except UcError:
                    entry["qword_at_source_r10"] = None
            if state["instructions"] >= 540_000:
                entry["registers"] = {
                    name: hex(uc.reg_read(register)) for name, register in REGISTERS.items()
                }
                entry["recent_instructions"] = list(recent)[-24:]
            probes.append(entry)
        try:
            blob = bytes(uc.mem_read(address, size))
            instruction = next(disassembler.disasm(blob, address))
            if (
                BUGLAND_BASE <= address < BUGLAND_BASE + len(bugland)
                and instruction.mnemonic == "jmp"
                and instruction.op_str in REGISTERS
            ):
                target = uc.reg_read(REGISTERS[instruction.op_str])
                item = {
                    "instruction": state["instructions"],
                    "source": hex(address),
                    "operand": instruction.op_str,
                    "target": hex(target),
                }
                try:
                    item.update(
                        key_low32=hex(
                            struct.unpack(
                                "<I", bytes(uc.mem_read(VM_RBP + 0xA, 4))
                            )[0]
                        ),
                        vip=hex(
                            struct.unpack(
                                "<Q", bytes(uc.mem_read(VM_RBP + 0x6D, 8))
                            )[0]
                        ),
                    )
                    if args.snapshot_vm_jumps:
                        rsp = uc.reg_read(UC_X86_REG_RSP)
                        item.update(
                            rbp=hex(uc.reg_read(UC_X86_REG_RBP)),
                            rsp=hex(rsp),
                            context_hex=bytes(uc.mem_read(VM_RBP, 0x200)).hex(),
                            stack_top_hex=bytes(uc.mem_read(rsp, 0x100)).hex(),
                            registers={
                                name: hex(uc.reg_read(register))
                                for name, register in REGISTERS.items()
                            },
                        )
                except UcError as exc:
                    if args.snapshot_vm_jumps:
                        item["snapshot_error"] = str(exc)
                vm_indirect_jumps.append(item)
            recent.append(
                {
                    "address": hex(address),
                    "bytes": blob.hex(),
                    "mnemonic": instruction.mnemonic,
                    "op_str": instruction.op_str,
                }
            )
        except Exception:
            recent.append({"address": hex(address), "bytes": None})
        if state["instructions"] >= args.max_instructions:
            state["stopped_by_limit"] = True
            uc.emu_stop()

    invalid: dict[str, Any] = {}
    synthetic_mappings: list[dict[str, Any]] = []
    synthetic_pages: set[int] = set()

    def on_invalid(
        _uc: Uc, access: int, address: int, size: int, value: int, _user: Any
    ) -> bool:
        item = {
            "access": access,
            "address": hex(address),
            "size": size,
            "value": hex(value),
            "rip": hex(uc.reg_read(UC_X86_REG_RIP)),
            "instruction": state["instructions"],
        }
        # Unicorn access 19/20 are unmapped read/fetch and 21 is unmapped
        # write. Only synthesize data reads: fabricating executable code or a
        # write target would hide control-flow corruption rather than expose a
        # missing runtime data dependency.
        if args.synthesize_unmapped_reads and access == 19:
            page = address & ~0xFFF
            if page not in synthetic_pages and len(synthetic_pages) < args.max_synthetic_pages:
                try:
                    uc.mem_map(page, 0x1000)
                    synthetic_pages.add(page)
                    synthetic_mappings.append({**item, "page": hex(page)})
                    return True
                except UcError:
                    pass
        # Tag-phase host-call blast-through: a FETCH_UNMAPPED at a small RVA-like
        # address means the VM dispatched into a host function whose raw module
        # IAT slot was never populated. Map a `xor eax,eax; ret` stub there so the
        # host call returns 0 and the VM's natural `ret`-based return resumes at
        # the saved return address on the stack.
        if (
            args.stub_host_calls_tag
            and access in (20, 21)
            and address < 0x1000000
            and state["instructions"] >= args.tag_phase_instruction
            and not state.get("completed")
        ):
            page = address & ~0xFFF
            rsp_now = uc.reg_read(UC_X86_REG_RSP)
            try:
                return_target = struct.unpack("<Q", bytes(uc.mem_read(rsp_now, 8)))[0]
            except UcError:
                return_target = None
            if page not in host_call_stub_pages and len(host_call_stub_pages) < 64:
                try:
                    uc.mem_map(page, 0x1000)
                except UcError:
                    pass
            # xor eax,eax ; ret
            uc.mem_write(address, b"\x31\xC0\xC3")
            host_call_stub_pages.add(page)
            item["stubbed_host_call"] = True
            item["return_target"] = hex(return_target) if return_target else None
            item["stub_page"] = hex(page)
            host_call_stubs.append(item)
            return True
        # Tag-phase null-pointer / tiny-address reads: the CRT helper with the
        # unrelocated IAT dereferences garbage (address 0 / small RVA). Synthesize
        # a zero result so the emulator can continue toward the tag SHA update.
        if (
            args.stub_host_calls_tag
            and access in (19, 20)
            and address < 0x10000
            and state["instructions"] >= args.tag_phase_instruction
            and not state.get("completed")
        ):
            page = address & ~0xFFF
            if page not in host_call_stub_pages and len(host_call_stub_pages) < 64:
                try:
                    uc.mem_map(page, 0x1000)
                except UcError:
                    pass
            try:
                uc.mem_write(page, b"\x00" * 0x1000)
            except UcError:
                pass
            host_call_stub_pages.add(page)
            null_read_stubs.append({**item, "stubbed_zero_read": True, "page": hex(page)})
            return True
        invalid.update(item)
        return False

    def on_vm_write(
        _uc: Uc, access: int, address: int, size: int, value: int, _user: Any
    ) -> None:
        # record every write into the VM context so we can trace arbitrary
        # slots (e.g. context+0xbd) that feed the pointer slots
        try:
            old_value = bytes(uc.mem_read(address, min(size, 8))).hex()
        except UcError:
            old_value = None
        item = {
            "instruction": state["instructions"],
            "rip": hex(uc.reg_read(UC_X86_REG_RIP)),
            "access": access,
            "address": hex(address),
            "size": size,
            "value": hex(value),
            "old_bytes": old_value,
            "slot_before_le_hex": None,
        }
        if address <= VM_POINTER_SLOT + 7 and address + size > VM_POINTER_SLOT:
            item["slot_before_le_hex"] = old_value
        if state["instructions"] >= 540_000:
            item["registers"] = {
                name: hex(uc.reg_read(register)) for name, register in REGISTERS.items()
            }
            item["recent_instructions"] = list(recent)[-16:]
        vm_pointer_slot_writes.append(item)
        pointer61 = VM_RBP + 0x61
        rip = uc.reg_read(UC_X86_REG_RIP)
        if (
            args.patch_context_pointer61 is not None
            and rip == 0x180B6264A
            and address <= pointer61
            and address + size >= pointer61 + 8
        ):
            # This exact handler write is the proven origin of the otherwise
            # unmapped 0x1c7aa206480 value at instruction 1,296,230. Earlier
            # writes overlap context+0x61 for unrelated VM slots and must not
            # be patched. Defer until the next instruction so Unicorn commits
            # the original write before we replace it.
            state["pending_pointer61_patch"] = {
                "instruction": state["instructions"],
                "rip": hex(rip),
                "attempted_value": hex(value),
            }

    def on_table_write(
        _uc: Uc, access: int, address: int, size: int, value: int, _user: Any
    ) -> None:
        nonlocal table_write_count, table_write_high_index_count
        start = max(address, HANDLER_TABLE_BASE)
        end = min(address + size, HANDLER_TABLE_BASE + HANDLER_TABLE_BYTES)
        if start >= end:
            return
        table_write_count += 1
        index = (address - HANDLER_TABLE_BASE) // 8
        if index > 0x64B:
            table_write_high_index_count += 1
        table_write_trace.append({
            "instruction": state["instructions"],
            "rip": hex(uc.reg_read(UC_X86_REG_RIP)),
            "address": hex(address),
            "size": size,
            "index": hex(index),
            "value": hex(value),
            "high_index": index > 0x64B,
        })

    def on_heap_write(
        _uc: Uc, access: int, address: int, size: int, value: int, _user: Any
    ) -> None:
        allocation = next(
            (
                item
                for item in reversed(allocations)
                if int(item["pointer"], 16)
                <= address
                < int(item["pointer"], 16) + item["bytes"]
            ),
            None,
        )
        heap_writes.append(
            {
                "instruction": state["instructions"],
                "rip": hex(uc.reg_read(UC_X86_REG_RIP)),
                "address": hex(address),
                "size": size,
                "value": hex(value),
                "allocation": allocation,
            }
        )

    def on_heap_read(
        _uc: Uc, access: int, address: int, size: int, value: int, _user: Any
    ) -> None:
        allocation = next(
            (
                item
                for item in reversed(allocations)
                if int(item["pointer"], 16)
                <= address
                < int(item["pointer"], 16) + item["bytes"]
            ),
            None,
        )
        heap_reads.append(
            {
                "instruction": state["instructions"],
                "rip": hex(uc.reg_read(UC_X86_REG_RIP)),
                "address": hex(address),
                "size": size,
                "allocation": allocation,
                "vip": hex(
                    struct.unpack("<Q", bytes(uc.mem_read(VM_RBP + 0x6D, 8)))[0]
                ),
                "key_low32": hex(
                    struct.unpack("<I", bytes(uc.mem_read(VM_RBP + 0xA, 4)))[0]
                ),
            }
        )

    def add_watched_range(label: str, address: int, size: int) -> None:
        if size <= 0:
            return

        def on_access(
            _uc: Uc,
            access: int,
            accessed_address: int,
            accessed_size: int,
            value: int,
            _user: Any,
        ) -> None:
            watched_memory_accesses.append(
                {
                    "instruction": state["instructions"],
                    "rip": hex(uc.reg_read(UC_X86_REG_RIP)),
                    "access": "read" if access != 17 else "write",
                    "label": label,
                    "address": hex(accessed_address),
                    "offset": accessed_address - address,
                    "size": accessed_size,
                    "value": hex(value),
                    "vip": hex(
                        struct.unpack(
                            "<Q", bytes(uc.mem_read(VM_RBP + 0x6D, 8))
                        )[0]
                    ),
                    "key_low32": hex(
                        struct.unpack(
                            "<I", bytes(uc.mem_read(VM_RBP + 0xA, 4))
                        )[0]
                    ),
                }
            )

        uc.hook_add(
            UC_HOOK_MEM_READ | UC_HOOK_MEM_WRITE,
            on_access,
            begin=address,
            end=address + size - 1,
        )

    if not args.fast_diff_trace:
        for label, object_address in {
            "output_object": output_object,
            "kid_object": input32_object,
            "key_material_object": input64_object,
            "context_object": context_object,
            "plaintext_object": plaintext_object,
        }.items():
            add_watched_range(
                label, object_address, 0x80 if label == "output_object" else 0x20
            )
            if label in {"kid_object", "key_material_object", "plaintext_object"}:
                data_pointer, _reserved, data_size, _capacity = struct.unpack(
                    "<QQQQ", bytes(uc.mem_read(object_address, 0x20))
                )
                add_watched_range(
                    label.removesuffix("_object") + "_data", data_pointer, data_size
                )

    if args.fast_diff_trace:
        # In synthetic runs the 32-byte decoded key is the 0x20-byte CRT
        # allocation at 0x200001000e0. A narrow hook is cheap and reveals the
        # first instruction that actually consumes key bytes.
        def on_fast_key_read(
            _uc: Uc, access: int, address: int, size: int, value: int, _user: Any
        ) -> None:
            fast_diff_key_reads.append({
                "instruction": state["instructions"],
                "rip": hex(uc.reg_read(UC_X86_REG_RIP)),
                "address": hex(address),
                "offset": address - 0x200001000E0,
                "size": size,
                "value": hex(value),
                "vm_jump_count": len(vm_indirect_jumps),
                "vip": hex(struct.unpack(
                    "<Q", bytes(uc.mem_read(VM_RBP + 0x6D, 8))
                )[0]),
                "key_low32": hex(struct.unpack(
                    "<I", bytes(uc.mem_read(VM_RBP + 0xA, 4))
                )[0]),
            })
            if args.stop_on_key_read:
                state["stopped_by_key_read"] = True
                uc.emu_stop()
        uc.hook_add(
            UC_HOOK_MEM_READ, on_fast_key_read,
            begin=0x200001000E0, end=0x200001000FF,
        )

        def on_fast_nonce_read(
            _uc: Uc, access: int, address: int, size: int, value: int, _user: Any
        ) -> None:
            fast_diff_nonce_reads.append({
                "instruction": state["instructions"],
                "rip": hex(uc.reg_read(UC_X86_REG_RIP)),
                "address": hex(address),
                "offset": address - 0x20000100160,
                "size": size,
                "vm_jump_count": len(vm_indirect_jumps),
                "vip": hex(struct.unpack(
                    "<Q", bytes(uc.mem_read(VM_RBP + 0x6D, 8))
                )[0]),
            })
            if args.stop_on_nonce_read and state.get("nonce_seeded"):
                state["stopped_by_nonce_read"] = True
                uc.emu_stop()
        uc.hook_add(
            UC_HOOK_MEM_READ, on_fast_nonce_read,
            begin=0x20000100160, end=0x2000010016B,
        )

        def on_sha_context_access(
            _uc: Uc, access: int, address: int, size: int, value: int, _user: Any
        ) -> None:
            # Watch the configured SHA context (either the fixed KDF stack context
            # or a user-supplied heap context) to capture the tag SHA update input.
            ctx_begin = args.watch_sha_context if args.watch_sha_context else 0x7FFE1FEC00
            if state["instructions"] >= 2688000 and len(sha_context_accesses) < 8192:
                sha_context_accesses.append({
                    "instruction": state["instructions"],
                    "rip": hex(uc.reg_read(UC_X86_REG_RIP)),
                    "access": "write" if access == 17 else "read",
                    "address": hex(address),
                    "offset": address - ctx_begin,
                    "size": size,
                    "value": hex(value),
                    "registers": {
                        name: hex(uc.reg_read(register))
                        for name, register in REGISTERS.items()
                    },
                })
            # If this is the tagged heap SHA context, also try to capture the
            # update call arguments at the SHA update entry (0x18042b9b0).
        uc.hook_add(
            UC_HOOK_MEM_READ | UC_HOOK_MEM_WRITE,
            on_sha_context_access,
            begin=args.watch_sha_context if args.watch_sha_context else 0x7FFE1FEC00,
            end=(args.watch_sha_context + 0x70) if args.watch_sha_context else 0x7FFE1FEC6F,
        )

    uc.hook_add(UC_HOOK_CODE, on_code)
    uc.hook_add(UC_HOOK_MEM_INVALID, on_invalid)
    if args.trace_failfast_code:
        def on_failfast_stack_write(
            _uc: Uc, access: int, address: int, size: int, value: int, _user: Any
        ) -> None:
            if size >= 4 and (value & 0xFFFFFFFF) == 0xC0000409:
                failfast_code_writes.append({
                    "instruction": state["instructions"],
                    "rip": hex(uc.reg_read(UC_X86_REG_RIP)),
                    "address": hex(address),
                    "size": size,
                    "value": hex(value),
                    "registers": {
                        name: hex(uc.reg_read(register))
                        for name, register in REGISTERS.items()
                    },
                    "vip": hex(struct.unpack(
                        "<Q", bytes(uc.mem_read(VM_RBP + 0x6D, 8)))[0]),
                })
        uc.hook_add(
            UC_HOOK_MEM_WRITE, on_failfast_stack_write,
            begin=execution_stack, end=execution_stack + execution_stack_size - 1,
        )
    if not args.fast_diff_trace and not args.fast_tag_replay:
        uc.hook_add(
            UC_HOOK_MEM_WRITE,
            on_vm_write,
            begin=VM_RBP,
            end=VM_RBP + 0x200,
        )
        uc.hook_add(
            UC_HOOK_MEM_WRITE,
            on_table_write,
            begin=HANDLER_TABLE_BASE,
            end=HANDLER_TABLE_BASE + HANDLER_TABLE_BYTES,
        )
        uc.hook_add(
            UC_HOOK_MEM_WRITE,
            on_heap_write,
            begin=heap_base,
            end=heap_base + heap_size - 1,
        )
        uc.hook_add(
            UC_HOOK_MEM_READ,
            on_heap_read,
            begin=heap_base,
            end=heap_base + heap_size - 1,
        )
    if args.watch_stack and not args.fast_diff_trace:
        def on_stack_access(
            _uc: Uc, access: int, address: int, size: int, value: int, _user: Any
        ) -> None:
            stack_accesses.append(
                {
                    "instruction": state["instructions"],
                    "rip": hex(uc.reg_read(UC_X86_REG_RIP)),
                    "access": "read" if access != 17 else "write",
                    "address": hex(address),
                    "size": size,
                    "value": hex(value),
                }
            )

        uc.hook_add(
            UC_HOOK_MEM_READ | UC_HOOK_MEM_WRITE,
            on_stack_access,
            begin=execution_stack,
            end=execution_stack + execution_stack_size - 1,
        )
    error = None
    try:
        uc.emu_start(ENCRYPT_ENTRY, 0, timeout=args.timeout_ms * 1000)
    except UcError as exc:
        if state.get("completed"):
            error = None
            state["stopped_by_limit"] = False
        else:
            error = str(exc)

    def object_words(address: int) -> list[str]:
        return [hex(value) for value in struct.unpack("<QQQQ", bytes(uc.mem_read(address, 32)))]

    allocation_pointer_xrefs: list[dict[str, Any]] = []
    scan_ranges = {
        "execution_stack": (execution_stack, execution_stack_size),
        "vm_context": (VM_RBP, 0x200),
        "builder_frame": (builder_rbp - 0x100, 0x600),
    }
    for allocation in allocations:
        pointer = int(allocation["pointer"], 16)
        needle = struct.pack("<Q", pointer)
        for range_name, (range_address, range_size) in scan_ranges.items():
            data = bytes(uc.mem_read(range_address, range_size))
            start = 0
            while True:
                offset = data.find(needle, start)
                if offset < 0:
                    break
                allocation_pointer_xrefs.append(
                    {
                        "allocation": allocation,
                        "range": range_name,
                        "address": hex(range_address + offset),
                        "offset": offset,
                    }
                )
                start = offset + 1

    fast_diff_allocation_contents = []
    if args.fast_diff_trace:
        for allocation in allocations:
            pointer = int(allocation["pointer"], 16)
            size = int(allocation["bytes"])
            try:
                content = bytes(uc.mem_read(pointer, min(size, 256))).hex()
            except UcError:
                content = None
            fast_diff_allocation_contents.append({
                **allocation,
                "captured_bytes": min(size, 256),
                "content_hex": content,
            })

    return {
        "schema": "maxhook.encrypt-boundary.emulation/v1",
        "inputs": {
            "dll": str(args.dll.resolve()),
            "dump_dir": str(args.dump_dir.resolve()),
            "bugland": str(args.bugland.resolve()),
            "capture_dir": str(args.capture_dir.resolve()),
            "request_id": args.request_id,
            "plaintext_bytes": (
                len(args.plaintext.encode())
                if boundary is None
                else next(
                    item["bytes"] for item in boundary["restored_files"]
                    if item["kind"] == "encrypt_string" and item["label"] == "plaintext_json"
                )
            ),
            "synthetic_key_material": boundary is None,
            "reconstructed_keystream_state": None if keystream_state is None else hex(keystream_state),
            "synchronized_boundary_capture": (
                None if boundary is None else {
                    "directory": boundary["directory"],
                    "session_index": boundary["session_index"],
                    "call_id": boundary["call_id"],
                    "restored_files": boundary["restored_files"],
                }
            ),
        },
        "runtime_overlays": overlays,
        "entry": hex(ENCRYPT_ENTRY),
        "builder_rbp": hex(builder_rbp),
        "captured_r9_object_words": object_words(context_object),
        "instruction_count": state["instructions"],
        "stopped_by_limit": state["stopped_by_limit"],
        "rbp_divergence": state.get("rbp_divergence"),
        "error": error,
        "invalid_memory": invalid or None,
        "synthetic_mappings": synthetic_mappings,
        "store32_trace": store32_trace,
        "generator_candidate_trace": generator_trace,
        "word_producer_trace": word_producer_trace,
        "fold_edx_trace": fold_edx_trace,
        "fold_arith_trace": fold_arith_trace,
        "probes": probes,
        "dispatcher": {
            "address": hex(DISPATCHER),
            "count": dispatch_count,
            "distinct_handler_targets": len(dispatch_target_counts),
            "top_handler_targets": sorted(
                dispatch_target_counts.items(), key=lambda pair: (-pair[1], pair[0])
            )[:64],
            "recent": list(dispatch_trace),
        },
        "vm_indirect_jumps": list(vm_indirect_jumps),
        "watched_memory_accesses": list(watched_memory_accesses),
        "heap_writes": list(heap_writes),
        "heap_reads": list(heap_reads),
        "stack_accesses": list(stack_accesses),
        "handler_table_writes": {
            "base": hex(HANDLER_TABLE_BASE),
            "bytes": HANDLER_TABLE_BYTES,
            "count": table_write_count,
            "high_index_gt_0x64b_count": table_write_high_index_count,
            "recent": list(table_write_trace),
        },
        "vm_pointer_slot": hex(VM_POINTER_SLOT),
        "vm_pointer_slot_writes": vm_pointer_slot_writes,
        "context_pointer61_patches": pointer61_patches,
        "nonce_seed_log": nonce_seed_log,
        "registers": {name: hex(uc.reg_read(register)) for name, register in REGISTERS.items()},
        "vm_context": {
            "rbp": hex(VM_RBP),
            "key_low32": hex(struct.unpack("<I", bytes(uc.mem_read(VM_RBP + 0xA, 4)))[0]),
            "vip": hex(struct.unpack("<Q", bytes(uc.mem_read(VM_RBP + 0x6D, 8)))[0]),
        },
        "output_object_words": {
            name: object_words(output_object + offset)
            for name, offset in {
                "kid": 0,
                "nonce": 0x20,
                "ciphertext": 0x40,
                "tag": 0x60,
            }.items()
        },
        "allocations": allocations,
        "fast_diff_allocation_contents": fast_diff_allocation_contents,
        "fast_diff_key_reads": fast_diff_key_reads,
        "fast_diff_nonce_reads": fast_diff_nonce_reads,
        "ret_trampoline_patches": ret_trampoline_patches,
        "ret_c25a53_events": ret_c25a53_events,
        "sha_component_events": sha_component_events,
        "sha_context_accesses": sha_context_accesses,
        "ispfp_stub_events": ispfp_stub_events,
        "host_call_stubs": host_call_stubs,
        "null_read_stubs": null_read_stubs,
        "crt_1000_stubs": crt_1000_stubs,
        "security_cookie_stubs": security_cookie_stubs,
        "crt_helper_stubs": crt_helper_stubs,
        "failfast_code_writes": failfast_code_writes,
        "skipped_int3": skipped_int3,
        "tag_buffer_dump": tag_buffer_dump,
        "sha_std_test": sha_std_test,
        "allocation_pointer_xrefs": allocation_pointer_xrefs,
        "recent_instructions": list(recent),
        "trace_window": (
            trace_window
            if args.trace_window_start
            else {"enabled": False, "start": None, "entries": 0}
        ),
        "interpretation": (
            "An invalid second dereference after PROBE_FIRST_DEREF, with a small first value, "
            "is evidence that the asynchronous .bugland epoch is not synchronized to this "
            "function-entry register/stack state; it is not evidence about the cipher algorithm."
        ),
    }


def main() -> int:
    args = parse_args()
    result = run(args)
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(f"[+] wrote {args.output.resolve()}")
    print(
        f"[+] instructions={result['instruction_count']} error={result['error']!r} "
        f"invalid={result['invalid_memory']}"
    )
    for probe in result["probes"]:
        print(f"[+] probe {probe}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
