#!/usr/bin/env python3
"""Follow the handler stubs to their bodies and classify the bodies."""
from __future__ import annotations
import json, sys
from pathlib import Path
from collections import Counter
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE / ".pydeps"))
from capstone import CS_ARCH_X86, CS_MODE_64, Cs
import pefile

DLL = HERE / "MaxHook.runtime-unpacked.dll"
IMAGE_BASE = 0x180000000

def main():
    d = json.loads(Path(r"E:\Coding\S1mple\target\encrypt_vm_mapped.json").read_text(encoding="utf-8"))
    jumps = d.get("vm_indirect_jumps", [])
    handlers = Counter()
    for j in jumps:
        handlers[j.get("source")] += 1
        handlers[j.get("target")] += 1

    blob = DLL.read_bytes()
    pe = pefile.PE(str(DLL))
    md = Cs(CS_ARCH_X86, CS_MODE_64)

    # For each handler, follow jmp addr to find body, classify body's first real insn
    body_classes = Counter()
    body_examples = {}
    for h_str, cnt in handlers.items():
        h = int(h_str, 16)
        rva = h - IMAGE_BASE
        sec = None
        for s in pe.sections:
            va = IMAGE_BASE + s.VirtualAddress
            if va <= h < va + s.Misc_VirtualSize:
                sec = s; break
        if sec is None:
            continue
        off = sec.get_offset_from_rva(rva)
        insns = list(md.disasm(blob[off:off+0x20], h))
        if not insns:
            continue
        first = insns[0]
        body_addr = h
        if first.mnemonic == "jmp" and first.op_str.startswith("0x"):
            body_addr = int(first.op_str, 16)
        # disassemble the body
        rva2 = body_addr - IMAGE_BASE
        sec2 = None
        for s in pe.sections:
            va = IMAGE_BASE + s.VirtualAddress
            if va <= body_addr < va + s.Misc_VirtualSize:
                sec2 = s; break
        if sec2 is None:
            continue
        off2 = sec2.get_offset_from_rva(rva2)
        bins = list(md.disasm(blob[off2:off2+0x40], body_addr))
        if not bins:
            continue
        # classify body by first non-jmp instruction
        for insn in bins:
            m = insn.mnemonic
            if m == "jmp":
                continue
            if m in ("xor", "add", "sub", "and", "or", "shl", "shr", "rol", "ror", "not", "neg"):
                body_classes["arithmetic"] += cnt
                body_examples.setdefault("arithmetic", (body_addr, insn.mnemonic, insn.op_str))
            elif m in ("mov", "movzx", "movsxd", "lea"):
                body_classes["load-store"] += cnt
                body_examples.setdefault("load-store", (body_addr, insn.mnemonic, insn.op_str))
            elif m in ("push", "pop"):
                body_classes["stack"] += cnt
            elif m == "cmp":
                body_classes["compare"] += cnt
            elif m == "pushfq" or m == "popfq":
                body_classes["flags"] += cnt
            else:
                body_classes[f"other:{m}"] += cnt
            break

    print("handler BODY classification (by execution count):")
    for cls, cnt in body_classes.most_common():
        print(f"  {cls}: {cnt}")
    print()
    print("examples (first non-jmp insn):")
    for cls, ex in body_examples.items():
        print(f"  {cls}: {ex[0]:#x} {ex[1]} {ex[2]}")

if __name__ == "__main__":
    main()
