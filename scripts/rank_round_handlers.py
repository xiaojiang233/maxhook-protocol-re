"""Identify the 'round function' handlers: real bodies with many ALU ops.

Most handlers are 1 trampoline -> a short body with add/sub constant blinding.
The cipher core (if it exists as distinct handlers) would be a few bodies with
long xor/add/sub chains touching multiple registers and producing keystream.

Rank bodies by: total ALU op count in first N instructions, and by whether they
chain many XORs (the keystream XOR with plaintext/key material).
"""

from __future__ import annotations
import struct
from pathlib import Path
from collections import Counter

from capstone import Cs, CS_ARCH_X86, CS_MODE_64, CS_OP_IMM

DLL = Path(r"E:\Coding\S1mple\target\MaxHook.runtime-unpacked.dll")
BUG = Path(r"E:\Coding\S1mple\target\runtime_bugland2.bin")
BUG_BASE = 0x180980000
TABLE_VA = 0x180C64EBD
N_HANDLERS = 1612

md = Cs(CS_ARCH_X86, CS_MODE_64)
md.detail = True
bug = BUG.read_bytes()


def read_sections():
    data = DLL.read_bytes()
    pe_off = struct.unpack_from("<I", data, 0x3C)[0]
    nsec = struct.unpack_from("<H", data, pe_off + 6)[0]
    opt_off = pe_off + 24
    opt_size = struct.unpack_from("<H", data, pe_off + 20)[0]
    sec_off = opt_off + opt_size
    secs = []
    for i in range(nsec):
        off = sec_off + i * 40
        vsize = struct.unpack_from("<I", data, off + 8)[0]
        va = struct.unpack_from("<I", data, off + 12)[0]
        rawsize = struct.unpack_from("<I", data, off + 16)[0]
        rawptr = struct.unpack_from("<I", data, off + 20)[0]
        secs.append(dict(va=va, vsize=vsize, rawsize=rawsize, rawptr=rawptr))
    return data, secs


def va_to_off(data, secs, va):
    rva = va - 0x180000000
    for s in secs:
        if s["va"] <= rva < s["va"] + max(s["vsize"], s["rawsize"]):
            return s["rawptr"] + (rva - s["va"])
    return None


def resolve(va):
    """Follow single-instruction trampoline to real body."""
    seen = set()
    while BUG_BASE <= va < BUG_BASE + len(bug) and va not in seen:
        seen.add(va)
        code = bug[va - BUG_BASE: va - BUG_BASE + 15]
        ins = list(md.disasm(code, va))
        if len(ins) == 2 and ins[1].mnemonic == "jmp" and ins[1].operands[0].type == CS_OP_IMM:
            va = ins[1].operands[0].imm
            continue
        # 1 insn (jmp) -> follow
        if len(ins) == 1 and ins[0].mnemonic == "jmp" and ins[0].operands[0].type == CS_OP_IMM:
            va = ins[0].operands[0].imm
            continue
        break
    return va


def main():
    data, secs = read_sections()
    tbl_off = va_to_off(data, secs, TABLE_VA)

    ALU = {"add", "sub", "xor", "and", "or", "not", "rol", "ror", "shl", "shr",
           "sal", "sar", "mul", "imul", "neg", "adc", "sbb"}

    scored = []
    for i in range(N_HANDLERS):
        stub = struct.unpack_from("<Q", data, tbl_off + i * 8)[0]
        body_va = resolve(stub)
        body = bug[body_va - BUG_BASE: body_va - BUG_BASE + 256]
        insns = list(md.disasm(body, body_va))
        # cut at first ret/jmp-to-dispatcher (unconditional jump back)
        cut = len(insns)
        for k, ins in enumerate(insns):
            if ins.mnemonic in ("ret",):
                cut = k + 1
                break
        insns = insns[:cut]
        alu_count = sum(1 for ins in insns if ins.mnemonic in ALU)
        xor_count = sum(1 for ins in insns if ins.mnemonic == "xor")
        scored.append((i, body_va, len(insns), alu_count, xor_count, insns))

    # rank by alu_count
    print("=== Top 30 bodies by ALU op count (round-function candidates) ===")
    scored.sort(key=lambda x: -x[3])
    for i, va, n, alu, xr, insns in scored[:30]:
        print(f"idx={i:04x} va=0x{va:x} off=0x{va-BUG_BASE:x} insns={n:3d} alu={alu:3d} xor={xr:3d}")

    print("\n=== Top 20 bodies by XOR count ===")
    scored.sort(key=lambda x: -x[4])
    for i, va, n, alu, xr, insns in scored[:20]:
        print(f"idx={i:04x} va=0x{va:x} off=0x{va-BUG_BASE:x} insns={n:3d} alu={alu:3d} xor={xr:3d}")

    # Dump the full disasm of the top-3 ALU bodies to see if any looks like a cipher round
    scored.sort(key=lambda x: -x[3])
    print("\n=== Full disasm of top 5 ALU bodies ===")
    for rank, (i, va, n, alu, xr, insns) in enumerate(scored[:5]):
        print(f"\n--- idx={i:04x} va=0x{va:x} (alu={alu}, xor={xr}) ---")
        for ins in insns[:60]:
            print(f"  0x{ins.address:x}: {ins.mnemonic} {ins.op_str}")


if __name__ == "__main__":
    main()
