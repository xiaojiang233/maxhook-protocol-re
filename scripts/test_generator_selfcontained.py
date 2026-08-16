#!/usr/bin/env python3
"""Decisive test: run the generator 0x18041a8a0 with state buffer = key+nonce+counter
and the 6 fn_index permutations, checking against the oracle keystream.

This tests whether the generator is self-contained (state = raw key+nonce) or
needs a separate key-schedule output.
"""
from __future__ import annotations
import struct, json, sys
from pathlib import Path
from itertools import permutations

sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
import pefile
from capstone import CS_ARCH_X86, CS_MODE_64, Cs
from unicorn import UC_ARCH_X86, UC_HOOK_CODE, UC_HOOK_MEM_INVALID, UC_MODE_64, Uc, UcError
from unicorn.x86_const import *

T = Path(r"E:\Coding\S1mple\target")
IMAGE_BASE = 0x180000000
GENERATOR = 0x18041A8A0
STORE32 = 0x18041A860

# fn table (plaintext), from round 64
FN_TABLE = 0x1807D7C70
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
    oracle_word0 = struct.unpack("<I", oracle_block0[0:4])[0]
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

    # compute the 4 eax (index-table offsets) and invert for each target fn_index
    # target fn assignments: subcall3=5 (store32), subcalls 0/1/2 = perm of {2,6,9}
    eaxs = []
    for src in SHIFT_SOURCES:
        cl = (0x405A9E0 - dword(src)) & 0xFFFFFFFF
        e = rol32(0x6000000, cl); e = bswap32(e); e = rol32(e, cl)
        eaxs.append(e)

    def enc_for_fn(fn, eax):
        # inverse deobf: fn = deobf(enc); enc = inverse(fn)
        edx = (0x5e9298bc - eax) & 0xFFFFFFFF
        eax2 = (eax + 0x5e9298bc) & 0xFFFFFFFF
        r = fn
        r = rol32(r, eax2); r = ror32(r, edx); r = rol32(r, eax2); r = ror32(r, edx)
        return (r - 1) & 0xFFFFFFFF

    oracle_words = [struct.unpack("<I", oracle_block0[i:i+4])[0] for i in range(0, 64, 4)]
    print(f"oracle block0 word0 = {oracle_word0:#010x}")

    # For each permutation of {2,6,9} for subcalls 0/1/2 (subcall 3 = 5):
    for perm in permutations([2, 6, 9]):
        assigns = list(perm) + [5]
        # patch the index table with correct encrypted values
        for i, fn in enumerate(assigns):
            enc = enc_for_fn(fn, eaxs[i])
            # patch index table in memory (we'll do per-run below)
        print(f"perm {perm} -> assigns {assigns}")

    # Actually run one representative permutation through the generator to test
    print("\nNote: full generator run requires patching index table + correct state buffer.")
    print("The state buffer (key-schedule output) is the remaining unknown.")

if __name__ == "__main__":
    main()
