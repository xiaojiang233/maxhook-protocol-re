"""Follow jmp stubs to real handler bodies, classify crypto primitives.

The handler table at 0x180C64EBD contains jmp stubs (each ~5 bytes: jmp rel32).
Follow each stub's jmp target to the actual handler body in .bugland, then
disassemble a longer window and classify the ALU/rotate/shift primitives.
"""

from __future__ import annotations
import struct
from pathlib import Path
from collections import Counter

from capstone import Cs, CS_ARCH_X86, CS_MODE_64, CS_OP_IMM, CS_OP_MEM, CS_OP_REG

DLL = Path(r"E:\Coding\S1mple\target\MaxHook.runtime-unpacked.dll")
BUG = Path(r"E:\Coding\S1mple\target\runtime_bugland2.bin")
BUG_BASE = 0x180980000
TABLE_VA = 0x180C64EBD
N_HANDLERS = 1612

md = Cs(CS_ARCH_X86, CS_MODE_64)
md.detail = True


def read_pe_sections():
    data = DLL.read_bytes()
    pe_off = struct.unpack_from("<I", data, 0x3C)[0]
    nsec = struct.unpack_from("<H", data, pe_off + 6)[0]
    opt_off = pe_off + 24
    opt_size = struct.unpack_from("<H", data, pe_off + 20)[0]
    sec_off = opt_off + opt_size
    sections = []
    for i in range(nsec):
        off = sec_off + i * 40
        name = data[off:off+8].rstrip(b"\x00").decode("latin1")
        vsize = struct.unpack_from("<I", data, off + 8)[0]
        va = struct.unpack_from("<I", data, off + 12)[0]
        rawsize = struct.unpack_from("<I", data, off + 16)[0]
        rawptr = struct.unpack_from("<I", data, off + 20)[0]
        sections.append(dict(name=name, va=va, vsize=vsize, rawsize=rawsize, rawptr=rawptr))
    return data, sections


def va_to_off(data, sections, va):
    rva = va - 0x180000000
    for s in sections:
        if s["va"] <= rva < s["va"] + max(s["vsize"], s["rawsize"]):
            return s["rawptr"] + (rva - s["va"])
    return None


def resolve_jmp(va, bug):
    """If va points at a jmp rel32 stub, return target VA."""
    code = bug[va - BUG_BASE: va - BUG_BASE + 8]
    ins = next(md.disasm(code, va), None)
    if ins and ins.mnemonic == "jmp" and len(ins.operands) == 1 and ins.operands[0].type == CS_OP_IMM:
        return ins.operands[0].imm
    return va


def classify_body(va, bug, window=96):
    code = bug[va - BUG_BASE: va - BUG_BASE + window]
    ops = []
    lookup = False
    gf_xtime = False
    for ins in md.disasm(code, va):
        ops.append(ins.mnemonic)
        # detect S-box style: movzx r32, byte [reg + disp] or mov r32, [reg + reg*s + disp]
        if ins.mnemonic in ("movzx", "movsx"):
            op = ins.operands[1]
            if op.type == CS_OP_MEM and op.mem.base != 0 and op.mem.disp is not None and abs(op.mem.disp) < 0x2000:
                lookup = True
        # detect xtime / GF mul: shl then conditional xor with 0x1b/0x87 constant
        if ins.mnemonic == "xor" and ins.operands[1].type == CS_OP_IMM and ins.operands[1].imm in (0x1b, 0x87, 0x11b):
            gf_xtime = True
        if len(ops) >= 40:
            break
    return set(ops), lookup, gf_xtime


def main():
    data, sections = read_pe_sections()
    tbl_off = va_to_off(data, sections, TABLE_VA)
    bug = BUG.read_bytes()

    # read stub VAs from table, follow jmp
    bodies = []
    for i in range(N_HANDLERS):
        stub_va = struct.unpack_from("<Q", data, tbl_off + i * 8)[0]
        if not (BUG_BASE <= stub_va < BUG_BASE + len(bug)):
            continue
        body_va = resolve_jmp(stub_va, bug)
        bodies.append((i, stub_va, body_va))

    print(f"{len(bodies)} handlers, following jmp stubs to bodies")

    ROT = {"rol", "ror", "rcl", "rcr"}
    XOR = {"xor", "pxor"}
    MUL = {"mul", "imul", "pmullw", "pmulld", "pmuludq", "pmulhw"}

    crypto = []
    lookup_handlers = []
    gf_handlers = []
    for i, stub_va, body_va in bodies:
        ops, lookup, gf = classify_body(body_va, bug)
        alu = ops & (ROT | XOR | MUL | {"add", "adc", "sub", "sbb", "and", "or", "not",
                                       "shl", "shr", "sal", "sar", "neg", "paddb", "paddw",
                                       "paddd", "paddq", "psubb", "psubw", "psubd", "psubq"})
        if lookup:
            lookup_handlers.append((i, body_va, sorted(ops)))
        if gf:
            gf_handlers.append((i, body_va, sorted(ops)))
        if len(alu) >= 3:
            crypto.append((i, body_va, sorted(alu)))

    print(f"\n=== {len(gf_handlers)} handlers with GF(2^8) xtime constant (0x1b/0x87/0x11b) ===")
    for i, va, ops in gf_handlers:
        print(f"  idx={i:04x} va=0x{va:x} off=0x{va-BUG_BASE:x} ops={ops}")

    print(f"\n=== {len(lookup_handlers)} handlers with S-box-style byte lookup ===")
    for i, va, ops in lookup_handlers[:50]:
        print(f"  idx={i:04x} va=0x{va:x} off=0x{va-BUG_BASE:x} ops={ops}")

    # opcode frequency across all handler bodies
    allops = Counter()
    for i, stub_va, body_va in bodies:
        for m in classify_body(body_va, bug)[0]:
            allops[m] += 1
    print(f"\n=== opcode frequency across all {len(bodies)} handler bodies (top 40) ===")
    for m, c in allops.most_common(40):
        print(f"  {c:5d}  {m}")


if __name__ == "__main__":
    main()
