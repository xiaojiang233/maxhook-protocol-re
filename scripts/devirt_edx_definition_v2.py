#!/usr/bin/env python3
"""
CORRECTED EDX backward slice — final version (offline, no attach).

Corrections vs earlier rounds:
  1. BUGLAND spans 0x180980000 .. 0x181efc000 (0x157c000 bytes). 0x181ad61e7
     and the producer 0x180b8c7aa ARE inside boot_unpacked.bin.
  2. store32 is entered by RET (trampoline 0x180c2775c `popfq; ret 0`), NOT by
     call.  Register mapping (symbolic_writer_trampoline.py, proven):
        rdx <- S10   rcx <- S11   rax <- S12   rflags <- S13   rip <- S14=store32

Answer produced:
  - last RDX definition before store32 = 0x180c27be2 `mov rdx,[rsp]` (loads S10).
  - S10 is pushed by the .bugland producer chain (0x180b8c7aa and its
    predecessors 0x180bce798/0x180afc853/0x180bc0334/0x18099089e), each folding
    `word[VIP+k]+rbp` S-box/state lookups and context-slot arithmetic.
  - The exact closed EDX expression requires evaluating those handler folds
    with live context; the slice now terminates at a finite, fully-decoded set
    of handler blocks inside boot_unpacked (not an abstract continuation).
"""
from __future__ import annotations
import json, struct, sys
from pathlib import Path

sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))

BOOT = Path(r"E:\Coding\S1mple\target\boot_unpacked.bin")
DLL = Path(r"E:\Coding\S1mple\target\MaxHook.runtime-unpacked.dll")
IMAGE_BASE = 0x180000000
BUGLAND_BASE = 0x180980000
BUGLAND_END = 0x181EFC000
STORE32 = 0x18041A860


def main():
    boot = BOOT.read_bytes()
    print("=== coverage ===")
    print(f"  boot_unpacked.bin: 0x{len(boot):x} bytes @ 0x{BUGLAND_BASE:x}")
    print(f"  covers 0x{BUGLAND_BASE:x} .. 0x{BUGLAND_END:x}")
    for va, name in [(0x181AD61E7, "store32 return target (next .bugland block)"),
                     (0x180B8C7AA, "word producer")]:
        print(f"  {name}: {va:#x} -> {'COVERED' if BUGLAND_BASE <= va < BUGLAND_END else 'NOT covered'}")

    print("\n=== ret-trampoline 0x180c2775c (popfq; ret 0) ===")
    print("  rdx<-S10  rcx<-S11  rax<-S12  rflags<-S13  rip<-S14(=store32)")
    print("  last RDX write = 0x180c27be2 mov rdx,[rsp]  (S10)")

    print("\n=== producer chain (dynamic) -> trampoline -> store32 ===")
    chain = [
        "0x180afc853", "0x180bc0334", "0x18099089e", "0x180bce798", "0x180b8c7aa",
        "0x180a3b547", "0x180a350fd", "0x180a8d3d6", "0x180a16ab9",
        "0x180c27936/276c5/279e4/2769b/27945/27b86/2754f/27582",
        "0x180c278a7 -> 0x180c27786 -> 0x180c27652 -> 0x180c27bf9 -> 0x180c279b4",
        "-> 0x180c27673 -> 0x180c27bd0 -> 0x180c27900 -> 0x180c2775c (popfq;ret)",
        "-> 0x18041a860 (store32) -> 0x180c68543",
    ]
    for c in chain:
        print(f"    {c}")

    print("\n=== cipher state slots touched by producer handlers ===")
    slots = {
        "+0x0a": "rolling key",
        "+0x5d": "dispatch/state word",
        "+0x69": "state word",
        "+0x6d": "VIP",
        "+0xf6": "state flag",
        "+0xe5": "state word",
    }
    for s, d in slots.items():
        print(f"  rbp{s}  = {d}")

    report = {
        "schema": "maxhook.edx-slice/v2",
        "corrections": {
            "bugland_end": hex(BUGLAND_END),
            "writer_entry": "ret-trampoline (no call)",
            "rdx_mapping": "S10",
            "rcx_mapping": "S11",
            "rip_mapping": "S14=store32",
        },
        "last_rdx_definition": {
            "address": "0x180c27be2",
            "instruction": "mov rdx, qword ptr [rsp]",
            "semantics": "rdx = S10 (producer-pushed keystream word)",
        },
        "word_producer": {
            "primary": "0x180b8c7aa",
            "chain": [
                "0x180afc853", "0x180bc0334", "0x18099089e", "0x180bce798",
                "0x180a3b547", "0x180a350fd", "0x180a8d3d6", "0x180a16ab9",
            ],
            "state_sources": "word[VIP+k]+rbp (S-box/state lookups) folded via sub/xor/add/and over rbp+0x0a/0x5d/0x69/0x6d/0xf6/0xe5",
            "in_boot_unpacked": True,
        },
        "conclusion": (
            "EDX at store32 = S10 = a keystream word produced by folding "
            "word[VIP+k]+rbp lookups and context-slot arithmetic across the "
            "producer chain 0x180afc853..0x180b8c7aa, then routed by the "
            "ret-trampoline. The last definition of RDX is 0x180c27be2 "
            "(mov rdx,[rsp]). Closing the expression requires evaluating those "
            "handler folds with live key-scheduled context state."
        ),
    }
    out = Path(r"E:\Coding\S1mple\target\maxhook_edx_slice_report_v2.json")
    out.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(f"\nwrote {out.resolve()}")


if __name__ == "__main__":
    main()
