#!/usr/bin/env python3
"""Full disassembly of the cipher-arithmetic blocks in the stable common suffix,
plus the generator loop body, to recover the actual data operations (round
function) of the keystream generator.

Each handler block is fully disassembled (until the next dispatch-stub or a
ret/jmp into the table), so the arithmetic on context state is visible.
"""
from __future__ import annotations
import json, sys, struct
from pathlib import Path
from collections import defaultdict

sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
from capstone import CS_ARCH_X86, CS_MODE_64, Cs

DLL = Path(r"E:\Coding\S1mple\target\MaxHook.runtime-unpacked.dll")
IMAGE_BASE = 0x180000000
CAPTURE = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")

# distinct handler bodies (not stubs) seen in the suffix
HANDLERS = {
    0x1809BFEBB: "handler#0x05d (init/rolling-key fold)",
    0x180A02A99: "handler#0x0e0 (keyed arithmetic)",
    0x18099089E: "generator loop head",
    0x180990A93: "generator loop body",
    0x180990B21: "generator loop tail",
    0x180B41FB8: "mask/spread handler A",
    0x180B42104: "mask/spread handler B",
    0x180B42287: "mask/spread handler C",
    0x180B423A3: "mask/spread handler D",
    0x180BD41AD: "handler (r10=rbp+0xa)",
    0x180BD430D: "handler (r8 +/- 0x90)",
    0x180BD438F: "handler (r10=rbp+0xa)",
    0x180BD43DE: "handler (r12=0x400)",
    0x180A182E9: "handler (rsi=0)",
    0x180A1841C: "handler (r11=rbp+0x5d)",
    0x180ADDFC6: "handler (add rbx,rcx)",
    0x180ADE18C: "handler (r9=rbp+0x5d)",
    0x180ADE38E: "handler (r13=rbp)",
    0x180BB20F1: "handler (rcx=rbp+0x6d)",
    0x180BB24CB: "handler (sub rdi,rbx)",
    0x1809BA2F0: "handler (r9=0)",
    0x1809BA397: "handler (r14=rbp+0x6d)",
    0x1809BA63E: "handler (sub rbx,0x90)",
    0x1809E62CD: "handler (r14=0x53ce3dd)",
    0x1809E6430: "handler (rdi=1)",
    0x180AA57D7: "handler (r11=0xc9)",
    0x180AA58BF: "handler (add rbx,r13)",
    0x180BCE721: "handler (rdx=0)",
    0x180BCE798: "handler (push [rdx])",
    0x180BCE861: "handler (r10=rbp+0xa)",
    0x180BCEB64: "handler (xor r15,0x800)",
    0x1809C5184: "handler (rbx=rbp)",
    0x1809C544C: "handler (xor rcx,0xffff)",
}


def parse_sections(blob):
    pe = blob
    e_lfanew = struct.unpack_from("<I", pe, 0x3C)[0]
    num = struct.unpack_from("<H", pe, e_lfanew + 6)[0]
    opt_size = struct.unpack_from("<H", pe, e_lfanew + 20)[0]
    sec_off = e_lfanew + 24 + opt_size
    sections = []
    for i in range(num):
        o = sec_off + i * 40
        name = pe[o:o+8].rstrip(b"\x00").decode("latin1")
        vsize = struct.unpack_from("<I", pe, o + 8)[0]
        vaddr = struct.unpack_from("<I", pe, o + 12)[0]
        rsize = struct.unpack_from("<I", pe, o + 16)[0]
        roff = struct.unpack_from("<I", pe, o + 20)[0]
        sections.append((name, vaddr, vsize, roff, rsize))
    return sections


def rva_to_off(rva, sections):
    for name, vaddr, vsize, roff, rsize in sections:
        if vaddr <= rva < vaddr + max(vsize, rsize):
            return roff + (rva - vaddr)
    return None


def disasm_n(blob, sections, va, n):
    off = rva_to_off(va - IMAGE_BASE, sections)
    if off is None:
        return []
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    md.detail = True
    return list(md.disasm(blob[off:off + n * 15], va))


def main():
    blob = DLL.read_bytes()
    sections = parse_sections(blob)
    md = Cs(CS_ARCH_X86, CS_MODE_64)

    # Load suffix
    snaps = []
    for f in sorted(CAPTURE.glob("*.bin")):
        j = json.loads(f.read_text())
        snaps.append(j)
    suffix = [int(x, 16) for x in snaps[0]["history"][-124:]]

    # Full disassembly of each handler body: from the handler entry, disassemble
    # until we hit a jmp (dispatch) or a ret. Limit to 24 insns.
    print("=== full disassembly of cipher handlers in the suffix ===\n")
    seen = set()
    for va in suffix:
        if va in HANDLERS and va not in seen:
            seen.add(va)
            name = HANDLERS[va]
            insns = disasm_n(blob, sections, va, 30)
            print(f"--- {name} @ {va:#x} ---")
            for x in insns:
                marker = " <DISPATCH>" if x.mnemonic == "jmp" else ""
                print(f"    {x.address:#x}: {x.mnemonic} {x.op_str}{marker}")
                if x.mnemonic == "jmp":
                    break
            print()


if __name__ == "__main__":
    main()
