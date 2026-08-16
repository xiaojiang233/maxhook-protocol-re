#!/usr/bin/env python3
"""Run the generator with correct fn_index (patch index table) and state buffer
= key+nonce, to test if the generator is self-contained."""
from __future__ import annotations
import struct, json, sys
from pathlib import Path
from itertools import permutations

sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
import pefile
from unicorn import UC_ARCH_X86, UC_HOOK_CODE, UC_HOOK_MEM_INVALID, UC_MODE_64, Uc, UcError
from unicorn.x86_const import *

T = Path(r"E:\Coding\S1mple\target")
IMAGE_BASE = 0x180000000
GENERATOR = 0x18041A8A0
STORE32 = 0x18041A860
IDX_TABLE = 0x1807D7CF0
SHIFT_SOURCES = [0x180894B04, 0x180894AEC, 0x180894B00, 0x180894AE8]

def rol32(x, n): n &= 0x1F; return ((x << n) | (x >> (32 - n))) & 0xFFFFFFFF
def ror32(x, n): n &= 0x1F; return ((x >> n) | (x << (32 - n))) & 0xFFFFFFFF
def bswap32(x): return int.from_bytes(x.to_bytes(4, "little"), "big")

def map_pe(uc, path, base):
    pe = pefile.PE(str(path))
    image_size = (pe.OPTIONAL_HEADER.SizeOfImage + 0xFFF) & ~0xFFF
    uc.mem_map(base, image_size)
    raw = path.read_bytes()
    uc.mem_write(base, raw[: pe.OPTIONAL_HEADER.SizeOfHeaders])
    for s in pe.sections:
        d = s.get_data()
        if d:
            uc.mem_write(base + s.VirtualAddress, d)
    return pe

def main():
    analysis = json.loads((T / "writer_sync_clean_20260814_014351/analysis.json").read_text(encoding="utf-8"))
    oracle_block0 = bytes.fromhex(analysis["calls"][0]["blocks"][0]["hex"])
    key = bytes.fromhex("347230E63EEC999571342BE4417C430A6EBC3C82F27142361C1B5FEF02B4ACD9")
    nonce = bytes.fromhex("96e71401fc4f5faa040e5ca1")

    dll = T / "MaxHook.runtime-unpacked.dll"
    pe = pefile.PE(str(dll))
    raw = dll.read_bytes()
    def dword(va):
        for s in pe.sections:
            sv = IMAGE_BASE + s.VirtualAddress
            if sv <= va < sv + max(s.Misc_VirtualSize, s.SizeOfRawData):
                return struct.unpack("<I", raw[s.PointerToRawData + (va - sv): s.PointerToRawData + (va - sv) + 4])[0]
        return 0

    eaxs = []
    for src in SHIFT_SOURCES:
        cl = (0x405A9E0 - dword(src)) & 0xFFFFFFFF
        e = rol32(0x6000000, cl); e = bswap32(e); e = rol32(e, cl)
        eaxs.append(e)

    def enc_for_fn(fn, eax):
        edx = (0x5e9298bc - eax) & 0xFFFFFFFF
        eax2 = (eax + 0x5e9298bc) & 0xFFFFFFFF
        r = fn
        r = rol32(r, eax2); r = ror32(r, edx); r = rol32(r, eax2); r = ror32(r, edx)
        return (r - 1) & 0xFFFFFFFF

    # For each permutation of {2,6,9} (subcall3 = 5):
    for perm in permutations([2, 6, 9]):
        assigns = list(perm) + [5]
        # build a fresh Unicorn instance, patch index table, run generator
        uc = Uc(UC_ARCH_X86, UC_MODE_64)
        map_pe(uc, dll, IMAGE_BASE)
        # stack
        uc.mem_map(0x7FFE000000, 0x200000)
        rsp = 0x7FFE000000 + 0x1F000
        uc.reg_write(UC_X86_REG_RSP, rsp)
        # state buffer = key(32) + nonce(12) + counter(4) = 48 bytes
        state_buf = 0x20000000000
        output_buf = 0x20000010000
        uc.mem_map(state_buf, 0x10000)
        uc.mem_map(output_buf, 0x10000)
        state_data = key + nonce + struct.pack("<I", 0)
        uc.mem_write(state_buf, state_data + b"\x00" * (0x10000 - len(state_data)))
        uc.mem_write(output_buf, b"\x00" * 0x10000)
        # patch index table (4 dwords)
        for i, fn in enumerate(assigns):
            enc = enc_for_fn(fn, eaxs[i])
            uc.mem_write(IDX_TABLE + eaxs[i]*4, struct.pack("<I", enc))
        # TEB/PEB
        teb = 0x7FFDE00000
        uc.mem_map(teb, 0x10000)
        uc.reg_write(UC_X86_REG_GS_BASE, teb)
        uc.mem_write(teb + 0x30, struct.pack("<Q", teb))
        peb = 0x7FFDE10000
        uc.mem_map(peb, 0x10000)
        uc.mem_write(teb + 0x58, struct.pack("<Q", peb))
        uc.mem_write(peb + 0x10, struct.pack("<Q", IMAGE_BASE))
        # entry
        uc.reg_write(UC_X86_REG_RCX, state_buf)
        uc.reg_write(UC_X86_REG_RDX, output_buf)
        store32_vals = []
        def on_code(_uc, addr, size, _ud):
            if addr == STORE32:
                store32_vals.append(_uc.reg_read(UC_X86_REG_RDX) & 0xFFFFFFFF)
        uc.hook_add(UC_HOOK_CODE, on_code)
        try:
            uc.emu_start(GENERATOR, 0, timeout=20_000_000, count=50000)
        except UcError as e:
            pass
        out = bytes(uc.mem_read(output_buf, 64))
        word0 = struct.unpack("<I", out[0:4])[0]
        match = out[:64] == oracle_block0
        print(f"perm {perm} assigns {assigns}: store32_hits={len(store32_vals)} word0={word0:#010x} oracle={struct.unpack('<I', oracle_block0[0:4])[0]:#010x} {'MATCH!' if match else ''}")

if __name__ == "__main__":
    main()
