#!/usr/bin/env python3
"""Deep analysis: map context fields and disassemble the stable common suffix.

Correlates context_hex across snapshots to:
  - identify cipher state (likely a 256-byte state / S-box) vs VM bookkeeping
  - disassemble the 124-block common suffix using the runtime-unpacked DLL
  - classify each suffix block as VM bookkeeping vs cipher arithmetic
"""
from __future__ import annotations
import json, hashlib, struct, sys
from pathlib import Path
from collections import Counter, defaultdict

sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
from capstone import CS_ARCH_X86, CS_MODE_64, Cs
from capstone.x86_const import X86_OP_IMM, X86_OP_REG, X86_OP_MEM

CAPTURE = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")
DLL = Path(r"E:\Coding\S1mple\target\MaxHook.runtime-unpacked.dll")
CTX_BASE = 0x18098C884
IMAGE_BASE = 0x180000000

# Known VM context field offsets from milestones:
KNOWN_FIELDS = {
    0x0A: "rolling key (dword)",
    0x6D: "VIP (qword)",
    0x85: "handler table (qword)",
    0xF6: "init flag",
}


def rva_of(va):
    return va - IMAGE_BASE


def load_dll():
    return DLL.read_bytes()


def va_from_rva(rva, blob):
    # PE section mapping: need to map RVA -> file offset
    # parse PE header
    import struct as _s
    pe = blob
    e_lfanew = _s.unpack_from("<I", pe, 0x3C)[0]
    num_sections = _s.unpack_from("<H", pe, e_lfanew + 6)[0]
    opt_size = _s.unpack_from("<H", pe, e_lfanew + 20)[0]
    opt_off = e_lfanew + 24
    # image base at opt_off+24 (qword), but we assume 0x180000000
    sec_off = opt_off + opt_size
    sections = []
    for i in range(num_sections):
        o = sec_off + i * 40
        name = pe[o:o+8].rstrip(b"\x00").decode("latin1")
        vsize = _s.unpack_from("<I", pe, o + 8)[0]
        vaddr = _s.unpack_from("<I", pe, o + 12)[0]
        rsize = _s.unpack_from("<I", pe, o + 16)[0]
        roff = _s.unpack_from("<I", pe, o + 20)[0]
        sections.append((name, vaddr, vsize, roff, rsize))
    return sections


def rva_to_off(rva, sections):
    for name, vaddr, vsize, roff, rsize in sections:
        if vaddr <= rva < vaddr + max(vsize, rsize):
            return roff + (rva - vaddr)
    return None


def disasm_va(va, blob, sections, count=8):
    va = int(va, 16)
    rva = rva_of(va)
    off = rva_to_off(rva, sections)
    if off is None:
        return None
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    md.detail = True
    code = blob[off:off+64]
    insns = list(md.disasm(code, va))
    return insns


def main():
    snaps = []
    for f in sorted(CAPTURE.glob("*.bin")):
        j = json.loads(f.read_text(encoding="utf-8"))
        j["_file"] = f.name
        snaps.append(j)

    # Build the common suffix (124 entries) from the last snapshot (any works)
    ref = snaps[0]
    suffix = ref["history"][-124:]

    # Verify identical across all snapshots
    for s in snaps[1:]:
        assert s["history"][-124:] == suffix, s["_file"]
    print(f"verified: common suffix of {len(suffix)} blocks identical across {len(snaps)} snapshots")

    blob = load_dll()
    sections = va_from_rva(0, blob)
    print(f"PE sections: {[(s[0], hex(s[1]), hex(s[2])) for s in sections]}")

    # --- disassemble each suffix block ---
    print("\n=== common suffix blocks (disassembled from runtime DLL) ===")
    for i, va in enumerate(suffix):
        insns = disasm_va(va, blob, sections, count=3)
        if insns is None:
            print(f"  [-{i+1:3d}] {va}  <unmapped>")
            continue
        txt = "; ".join(f"{x.mnemonic} {x.op_str}" for x in insns[:2])
        print(f"  [-{i+1:3d}] {va}  {txt}")

    # --- context field correlation ---
    print("\n=== context changing-region semantics ===")
    # For each changing offset, show a sample of values (first 3 snapshots)
    ctxs = [bytes.fromhex(s["context_hex"]) for s in snaps]
    # print changing regions with values
    changing = [off for off in range(0x300) if len(set(c[off] for c in ctxs)) > 1]
    # print a few representative regions with hexdump-style
    interesting = [0x0A, 0x6D, 0x85, 0xF6, 0xB5, 0x235]
    for off in interesting:
        vals = [c[off:off+16].hex() for c in ctxs[:6]]
        tag = KNOWN_FIELDS.get(off, "")
        print(f"  ctx+0x{off:03x} ({tag}): first6=" + " | ".join(vals))

    # Is there a 256-byte region that changes monotonically? (cipher state)
    # Check bytes in +0xb5..+0x1b5 region (between dest buffers)
    print("\n=== does the +0xb5 destination buffer look like cipher state? ===")
    # destination 0x18098c939 = +0xb5; 0x18098cab9 = +0x235. Difference = 0x180.
    # 0x180 = 384 = 6*64. These are likely two 64-byte (or larger) slots.
    print(f"  dst1 +0xb5, dst2 +0x235, delta = 0x180 = {0x235-0xb5}")

    # Analyze value diversity in the +0xb5..+0x234 and +0x235..+0x2ff windows
    for (lo, hi, name) in [(0xB5, 0x235, "slot A (+0xb5..0x234)"), (0x235, 0x300, "slot B (+0x235..0x2ff)")]:
        ch = [o for o in range(lo, hi) if o in changing]
        st = [o for o in range(lo, hi) if o not in changing]
        print(f"  {name}: changing={len(ch)} stable={len(st)}")
        # distinct value counts in this window
        dv = Counter()
        for o in ch:
            dv[len(set(c[o] for c in ctxs))] += 1
        print(f"    distinct-value hist: {dict(sorted(dv.items()))}")

    # Look at the whole context as a 3-call picture: which bytes depend on nonce?
    print("\n=== per-call context stability (nonce-dependence) ===")
    # Group snapshots by call; within a call the nonce is fixed, so changing
    # bytes within a call = keystream counter/position dependence.
    by_call = defaultdict(list)
    for s in snaps:
        call = int(s["_file"].split("_call_")[1].split("_")[0])
        by_call[call].append(s)
    for call, ss in sorted(by_call.items()):
        cs = [bytes.fromhex(s["context_hex"]) for s in ss]
        within_change = sum(1 for o in range(0x300) if len(set(c[o] for c in cs)) > 1)
        print(f"  call {call}: {len(ss)} snapshots, {within_change} bytes change within-call")


if __name__ == "__main__":
    main()
