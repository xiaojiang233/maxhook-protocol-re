"""Distinguish bytecode-fetch movzx from true S-box table lookups.

A true S-box has a 256-byte constant table in memory.  Look for the actual
crypto table in .bugland/.data: an all-256-unique-bytes 256-byte permutation.

Also examine the 2 `rol rbx,0x20` sites and the exact `movzx` operand registers
in a few handlers to see if the base is VIP (bytecode) or a table pointer.
"""

from __future__ import annotations
import struct
from pathlib import Path
from collections import Counter

from capstone import Cs, CS_ARCH_X86, CS_MODE_64, CS_OP_IMM, CS_OP_MEM, CS_OP_REG

DLL = Path(r"E:\Coding\S1mple\target\MaxHook.runtime-unpacked.dll")
BUG = Path(r"E:\Coding\S1mple\target\runtime_bugland2.bin")
BUG_BASE = 0x180980000

md = Cs(CS_ARCH_X86, CS_MODE_64)
md.detail = True


def find_256byte_sboxes(buf: bytes, label: str):
    """Find windows of 256 bytes that are a permutation of 0..255 (S-box)."""
    hits = []
    # also allow affine/random 256-byte tables that are just used as lookup
    for off in range(0, len(buf) - 256):
        window = buf[off:off+256]
        if len(set(window)) == 256:  # a permutation -> S-box
            hits.append(off)
        # also detect inverse-ish: not needed
    print(f"[{label}] {len(hits)} permutation-of-256 tables found")
    for off in hits[:20]:
        print(f"  off=0x{off:x}")
    return hits


def find_aes_sbox(buf: bytes):
    aes_sbox = bytes.fromhex(
        "637c777bf26b6fc53001672bfed7ab76ca82c97dfa5947f0add4a2af9ca472c0"
        "b7fd9326363ff7cc34a5e5f171d8311504c723c31896059a071280e2eb27b275"
        "09832c1a1b6e5aa0523bd6b329e32f8453d100ed20fcb15b6acbbe394a4c58cf"
        "d0efaafb434d338545f9027f503c9fa851a3408f929d38f5bcb6da2110fff3d2"
        "cd0c13ec5f974417c4a77e3d645d197360814fdc222a908846eeb814de5e0bdb"
        "e0323a0a4906245cc2d3ac629195e479e7c8376d8dd54ea96c56f4ea657aae08"
        "ba78252e1ca6b4c6e8dd741f4bbd8b8a703eb5664803f60e613557b986c11d9e"
        "e1f8981169d98e949b1e87e9ce5528df8ca1890dbfe6426841992d0fb054bb16")
    # search for the AES sbox bytes in the file (inverse not needed)
    idx = buf.find(aes_sbox)
    print(f"[AES sbox exact] found at off=0x{idx:x}" if idx >= 0 else "[AES sbox exact] NOT FOUND")
    return idx


def main():
    bug = BUG.read_bytes()
    dll = DLL.read_bytes()

    print("=== S-box / permutation table hunt ===")
    find_aes_sbox(bug)
    # only scan a bounded region to save time: full bugland 22.5MB
    find_256byte_sboxes(bug, "bugland-full")

    # find rol rbx,0x20 (opcode 48 c1 c3 20) in bugland
    print("\n=== rol rbx,0x20 sites (48 c1 c3 20) ===")
    pat = bytes.fromhex("48c1c320")
    cur = 0
    n = 0
    while True:
        cur = bug.find(pat, cur)
        if cur < 0:
            break
        va = BUG_BASE + cur
        print(f"  off=0x{cur:x} va=0x{va:x}")
        n += 1
        cur += 1
    print(f"  total {n} sites")

    # also any rol/ror with immediate 32-bit swap across all forms
    print("\n=== all rol/ror (any reg, imm) in bugland ===")
    for m in md.disasm(bug[:2000000], BUG_BASE):  # scan first 2MB as sample
        if m.mnemonic in ("rol", "ror"):
            print(f"  va=0x{m.address:x}  {m.mnemonic} {m.op_str}")

    # Dump a few movzx operand details from handlers to see base register
    print("\n=== movzx operand detail (first 20 movzx in first 60 handlers) ===")
    # re-read handler table
    data = dll
    pe_off = struct.unpack_from("<I", data, 0x3C)[0]
    nsec = struct.unpack_from("<H", data, pe_off + 6)[0]
    opt_off = pe_off + 24
    opt_size = struct.unpack_from("<H", data, pe_off + 20)[0]
    sec_off = opt_off + opt_size
    sections = []
    for i in range(nsec):
        off = sec_off + i * 40
        vsize = struct.unpack_from("<I", data, off + 8)[0]
        va = struct.unpack_from("<I", data, off + 12)[0]
        rawsize = struct.unpack_from("<I", data, off + 16)[0]
        rawptr = struct.unpack_from("<I", data, off + 20)[0]
        sections.append(dict(va=va, vsize=vsize, rawsize=rawsize, rawptr=rawptr))

    def va_to_off(va):
        rva = va - 0x180000000
        for s in sections:
            if s["va"] <= rva < s["va"] + max(s["vsize"], s["rawsize"]):
                return s["rawptr"] + (rva - s["va"])
        return None

    tbl_off = va_to_off(0x180C64EBD)
    seen = 0
    for i in range(60):
        stub_va = struct.unpack_from("<Q", data, tbl_off + i * 8)[0]
        if not (BUG_BASE <= stub_va < BUG_BASE + len(bug)):
            continue
        # follow jmp
        code = bug[stub_va - BUG_BASE: stub_va - BUG_BASE + 8]
        ins = next(md.disasm(code, stub_va), None)
        body = stub_va
        if ins and ins.mnemonic == "jmp" and ins.operands[0].type == CS_OP_IMM:
            body = ins.operands[0].imm
        bodycode = bug[body - BUG_BASE: body - BUG_BASE + 96]
        for m in md.disasm(bodycode, body):
            if m.mnemonic == "movzx" and seen < 20:
                # operand[1] is source
                src = m.operands[1]
                if src.type == CS_OP_MEM:
                    base = md.reg_name(src.mem.base) if src.mem.base else "?"
                    disp = src.mem.disp
                    print(f"  idx={i:04x} va=0x{m.address:x}  movzx {m.op_str}  mem.base={base} disp={disp:#x}")
                    seen += 1
            if seen >= 20:
                break
        if seen >= 20:
            break


if __name__ == "__main__":
    main()
