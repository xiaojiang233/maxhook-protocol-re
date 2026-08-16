#!/usr/bin/env python3
"""Classify all 339 distinct VM handlers by their semantic (arithmetic vs
bookkeeping), to focus the fold analysis on the cipher arithmetic."""
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

    # classify each handler by its first 2 instructions
    classes = Counter()
    for h_str, cnt in handlers.items():
        h = int(h_str, 16)
        rva = h - IMAGE_BASE
        sec = None
        for s in pe.sections:
            va = IMAGE_BASE + s.VirtualAddress
            if va <= h < va + s.Misc_VirtualSize:
                sec = s; break
        if sec is None:
            classes["unmapped"] += cnt
            continue
        off = sec.get_offset_from_rva(rva)
        insns = list(md.disasm(blob[off:off+0x20], h))
        if not insns:
            classes["unmapped"] += cnt
            continue
        first = insns[0]
        # classify
        if first.mnemonic == "jmp":
            op = first.op_str
            if op.startswith("0x"):
                classes["jump-table"] += cnt  # jmp to fixed address
            else:
                classes["jmp-reg"] += cnt      # jmp reg (dispatch tail)
        elif first.mnemonic in ("xor", "add", "sub", "and", "or", "shl", "shr", "rol", "ror", "not", "neg"):
            classes["arithmetic"] += cnt
        elif first.mnemonic in ("mov", "movzx", "movsxd", "lea"):
            classes["load-store"] += cnt
        elif first.mnemonic in ("push", "pop"):
            classes["stack"] += cnt
        elif first.mnemonic == "cmp":
            classes["compare"] += cnt
        else:
            classes[f"other:{first.mnemonic}"] += cnt

    print("handler classification by total execution count:")
    for cls, cnt in classes.most_common():
        print(f"  {cls}: {cnt}")

if __name__ == "__main__":
    main()
