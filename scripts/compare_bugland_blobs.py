#!/usr/bin/env python3
"""Compare the 3 bugland blobs and determine which is the correctly-decrypted
runtime form (with the valid handler table + proven dispatch chain)."""
import struct
from pathlib import Path

TABLE_VA = 0x180C64EBD
BUG_BASE = 0x180980000
CTX_BASE = 0x18098C884

def check(path, label):
    blob = Path(path).read_bytes()
    def rd64(va): return struct.unpack_from("<Q", blob, va - BUG_BASE)[0]
    def rd16(va): return struct.unpack_from("<H", blob, va - BUG_BASE)[0]
    # handler table first 4 entries
    e0 = rd64(TABLE_VA)
    e1 = rd64(TABLE_VA + 8)
    # context key + VIP + flag
    key = struct.unpack_from("<I", blob, CTX_BASE + 0xa - BUG_BASE)[0]
    flag = blob[CTX_BASE + 0x162 - BUG_BASE]
    vip = rd64(CTX_BASE + 0x6d)
    # first dispatch index (word at initial VIP 0x180000000+0x1555629)
    vip0 = 0x180000000 + 0x1555629
    idx0 = rd16(vip0)
    print("%s:" % label)
    print("  table[0]=%#x table[1]=%#x" % (e0, e1))
    print("  ctx key=%#x flag=%#x vip=%#x" % (key, flag, vip))
    print("  word[initial_vip]=%#x" % idx0)

check(r"E:\Coding\S1mple\target\dump_out\41264\region_0000000180980000.bin", "dump region")
check(r"E:\Coding\S1mple\target\runtime_bugland.bin", "runtime_bugland.bin")
check(r"E:\Coding\S1mple\target\runtime_bugland2.bin", "runtime_bugland2.bin")
