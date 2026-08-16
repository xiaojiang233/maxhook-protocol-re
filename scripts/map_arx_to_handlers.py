"""Determine which handler-table entries own the 5 rotate sites + 2 shift sites.

Map each ARX instruction address back to a handler-table index (0x0000..0x064b)
by finding which stub's jmp-target body contains it.  This tells us whether the
rotation is one primitive handler (cloned) or distinct, and how it's dispatched.
"""

from __future__ import annotations
import struct
from pathlib import Path

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


def resolve_body(va):
    """Follow trampoline to the body (1 jmp hop)."""
    seen = set()
    while BUG_BASE <= va < BUG_BASE + len(bug) and va not in seen:
        seen.add(va)
        code = bug[va - BUG_BASE: va - BUG_BASE + 15]
        insns = list(md.disasm(code, va))
        # 1 insn jmp OR 2 insns where 2nd is jmp
        if insns and insns[-1].mnemonic == "jmp" and insns[-1].operands[0].type == CS_OP_IMM:
            # if the jmp is the ONLY insn, it's a pure trampoline -> follow
            if len(insns) == 1:
                va = insns[0].operands[0].imm
                continue
            else:
                # insns[0] is a real op (e.g. rol), body starts here
                return va
        return va
    return va


def main():
    data, secs = read_sections()
    tbl_off = va_to_off(data, secs, TABLE_VA)

    # build map: body VA -> handler index (first matching)
    targets = [0x180a164be, 0x180b3cbf4, 0x180b5f49c, 0x180af6547, 0x180a59e63,
               0x180b3c56f, 0x1809d817b]

    # For each handler, resolve body start, then check if target falls within
    # body start .. body start+256
    print("ARX instruction -> owning handler index:")
    for tgt in targets:
        owners = []
        for i in range(N_HANDLERS):
            stub = struct.unpack_from("<Q", data, tbl_off + i * 8)[0]
            if not (BUG_BASE <= stub < BUG_BASE + len(bug)):
                continue
            body = resolve_body(stub)
            if body <= tgt < body + 256:
                owners.append((i, stub, body))
        print(f"  0x{tgt:x}: {[(f'idx={i:04x} stub=0x{s:x} body=0x{b:x}') for i,s,b in owners]}")

    # also print the handler bodies (resolved) that contain each target, first 8 insns
    print("\nBody starts for the 5 rotate sites (first 10 resolved insns):")
    for tgt in targets[:5]:
        for i in range(N_HANDLERS):
            stub = struct.unpack_from("<Q", data, tbl_off + i * 8)[0]
            if not (BUG_BASE <= stub < BUG_BASE + len(bug)):
                continue
            body = resolve_body(stub)
            if body <= tgt < body + 256:
                code = bug[body - BUG_BASE: body - BUG_BASE + 48]
                print(f"\n  idx={i:04x} stub=0x{stub:x} body=0x{body:x}")
                for ins in md.disasm(code, body):
                    print(f"    0x{ins.address:x}: {ins.mnemonic} {ins.op_str}")
                break


if __name__ == "__main__":
    main()
