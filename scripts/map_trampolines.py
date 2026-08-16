"""Map the trampoline structure of .bugland handlers.

Each handler-table entry points to a 1-instruction trampoline (rol/shl/sbb/...
then jmp).  Follow the jmp chains to find the REAL handler bodies and their
address distribution.  This tells us where the cipher core actually lives.
"""

from __future__ import annotations
import struct
from pathlib import Path
from collections import Counter

from capstone import Cs, CS_ARCH_X86, CS_MODE_64, CS_OP_IMM

DLL = Path(r"E:\Coding\S1mple\target\MaxHook.runtime-unpacked.dll")
BUG = Path(r"E:\Coding\S1mple\target\runtime_bugland2.bin")
BUG_BASE = 0x180980000
BUG_SIZE = BUG.stat().st_size
BUG_END = BUG_BASE + BUG_SIZE
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
        name = data[off:off+8].rstrip(b"\x00").decode("latin1")
        vsize = struct.unpack_from("<I", data, off + 8)[0]
        va = struct.unpack_from("<I", data, off + 12)[0]
        rawsize = struct.unpack_from("<I", data, off + 16)[0]
        rawptr = struct.unpack_from("<I", data, off + 20)[0]
        secs.append(dict(name=name, va=va, vsize=vsize, rawsize=rawsize, rawptr=rawptr))
    return data, secs


def va_to_off(data, secs, va):
    rva = va - 0x180000000
    for s in secs:
        if s["va"] <= rva < s["va"] + max(s["vsize"], s["rawsize"]):
            return s["rawptr"] + (rva - s["va"])
    return None


def jmp_target(va):
    """Return (target_va, True) if va is a 1-insn trampoline ending in jmp."""
    code = bug[va - BUG_BASE: va - BUG_BASE + 15]
    for ins in md.disasm(code, va):
        if ins.mnemonic == "jmp" and ins.operands and ins.operands[0].type == CS_OP_IMM:
            return ins.operands[0].imm
        # if we see 2+ instructions before a jmp, it's a real body, stop
    return None


def main():
    data, secs = read_sections()
    tbl_off = va_to_off(data, secs, TABLE_VA)

    depth_counter = Counter()
    body_vas = []
    max_chain = 0
    chains_outside = 0

    for i in range(N_HANDLERS):
        stub_va = struct.unpack_from("<Q", data, tbl_off + i * 8)[0]
        cur = stub_va
        depth = 0
        seen = set()
        while depth < 40 and BUG_BASE <= cur < BUG_END:
            if cur in seen:
                break
            seen.add(cur)
            nxt = jmp_target(cur)
            if nxt is None:
                break
            cur = nxt
            depth += 1
        depth_counter[depth] += 1
        max_chain = max(max_chain, depth)
        body_vas.append(cur)

    print(f"trampoline chain depth distribution (depth -> count):")
    for d in sorted(depth_counter):
        print(f"  depth {d:2d}: {depth_counter[d]:4d} handlers")
    print(f"max chain depth = {max_chain}")

    # where do final bodies live?
    in_bug = sum(1 for v in body_vas if BUG_BASE <= v < BUG_END)
    print(f"\nfinal body addresses: {in_bug}/{N_HANDLERS} inside .bugland range")
    # histogram of body VA high bits
    hi = Counter((v >> 24) & 0xff for v in body_vas)
    print("body VA top-byte histogram:")
    for h, c in sorted(hi.items()):
        print(f"  0x{h:02x}000000: {c}")

    # Are final bodies within .bugland or elsewhere (e.g., .data)?
    outside = [v for v in body_vas if not (BUG_BASE <= v < BUG_END)]
    print(f"\n{len(outside)} bodies outside .bugland:")
    for v in outside[:30]:
        print(f"  0x{v:x}")

    # For bodies inside bugland, classify the real ops over a longer window
    print("\n=== real body op classification (depth-resolved) ===")
    alu_counter = Counter()
    for i in range(N_HANDLERS):
        stub_va = struct.unpack_from("<Q", data, tbl_off + i * 8)[0]
        cur = stub_va
        seen = set()
        while BUG_BASE <= cur < BUG_END and cur not in seen:
            seen.add(cur)
            nxt = jmp_target(cur)
            if nxt is None:
                break
            cur = nxt
        if not (BUG_BASE <= cur < BUG_END):
            continue
        body = bug[cur - BUG_BASE: cur - BUG_BASE + 128]
        for ins in md.disasm(body, cur):
            if ins.mnemonic in ("add", "sub", "xor", "and", "or", "not", "rol", "ror",
                                "shl", "shr", "sal", "sar", "mul", "imul", "neg",
                                "adc", "sbb"):
                alu_counter[ins.mnemonic] += 1
            if ins.mnemonic == "ret":
                break
    print("ALU opcode counts across depth-resolved bodies:")
    for m, c in alu_counter.most_common():
        print(f"  {c:6d}  {m}")


if __name__ == "__main__":
    main()
