#!/usr/bin/env python3
"""Precisely extract the GENUINE key-schedule ARX operations from the
call-history chain bodies, filtering Themida decoy instructions.

A "genuine" op = an arithmetic/mov instruction whose memory operand touches a
context slot via rbp+offset (the 768-byte VM context at 0x18098c884), OR a
memory write with an immediate constant (the key-schedule round constants).

Decoys are: xor r,r / mov r,0 / and r,0x400 / or r,0x800 / pushfq / register
shuffling that gets overwritten before use.  We identify genuine ops by the
context-slot pattern `rbp +/- 0xNN` in the operand.
"""
from __future__ import annotations
import re
from pathlib import Path

HERE = Path(__file__).resolve().parent
DISASM = HERE / "disasm_unpacked.asm"

# handler bodies (start addrs) grouped by chain, from the call-history trace
CHAINS = {
    "A": [0x18099089e, 0x180990a93, 0x180990b21],
    "B": [0x1809bfebb, 0x1809bff47, 0x1809c012a],
    "C": [0x180a02a99, 0x180a02bcd, 0x180a02c51, 0x180a02c94],
    "D": [0x180b41fb8, 0x180b42104, 0x180b42287, 0x180b423a3],
    "E": [0x180a182e9, 0x180a1841c],
    "F": [0x180bd41ad, 0x180bd430d, 0x180bd43de],
    "G": [0x180addfc6, 0x180ade18c, 0x180ade35e],
    "W": [0x180a725cb, 0x180a72787, 0x180a728df],
}

# how many instructions to dump per body
BODY_LINES = 60


def load_lines() -> list[str]:
    return open(DISASM, "r", encoding="utf-8", errors="replace").read().splitlines()


def main():
    lines = load_lines()
    # index: addr -> line number
    idx = {}
    for i, ln in enumerate(lines):
        m = re.match(r"^(0x[0-9a-fA-F]+):", ln)
        if m:
            a = int(m.group(1), 16)
            idx.setdefault(a, i)

    # VM context base (rbp) — from reports
    RBP = 0x18098C884

    # A genuine op touches rbp +/- disp (context slot) in a memory operand,
    # or is a mov/arith with an immediate 0xNNNNNNNN constant.
    ARITH = {"add", "sub", "xor", "and", "or", "shl", "shr", "rol", "ror", "not", "neg", "mov", "movzx", "movsxd", "lea", "cmp", "inc", "dec", "imul"}

    def classify(ln: str) -> str | None:
        # strip address prefix
        body = ln.split(":", 1)[1].strip()
        # skip .byte
        if body.startswith("."):
            return None
        parts = body.split(None, 1)
        if not parts:
            return None
        mnem = parts[0]
        ops = parts[1] if len(parts) > 1 else ""
        # decoy detection
        if mnem in ("jmp", "jcc", "je", "jne", "jz", "jnz", "ja", "jb", "jg", "jl", "nop", "pushfq", "popfq", "ret", "call", "syscall"):
            return None
        if re.match(r"^(xor|mov)\s+r\w+, r\w+$", f"{mnem} {ops}") and mnem in ("xor", "mov") and "ptr" not in ops:
            # xor reg,reg / mov reg,reg shuffle — likely decoy unless it's mov r,0
            return None
        if re.match(r"^(xor|and|or|sub|add)\s+r\w+, 0x(400|800|80|20|40|1|0)$", f"{mnem} {ops}"):
            return None  # VM flag/mask decoys
        # genuine if it references rbp (context) with a displacement
        if "rbp" in ops:
            return body
        # genuine if arithmetic with a big immediate constant
        if mnem in ARITH and re.search(r"0x[0-9a-fA-F]{8}", ops):
            return body
        return None

    for chain, addrs in CHAINS.items():
        print(f"\n{'='*70}\nCHAIN {chain}\n{'='*70}")
        for a in addrs:
            if a not in idx:
                print(f"  [body {a:#x}: not found]")
                continue
            start = idx[a]
            print(f"\n  --- body {a:#x} ---")
            for ln in lines[start:start + BODY_LINES]:
                c = classify(ln)
                if c:
                    print(f"    {c}")


if __name__ == "__main__":
    main()
