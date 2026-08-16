#!/usr/bin/env python3
"""Decode the key-schedule VM bytecode: read word[VIP+k] from .bugland, decrypt
using the rolling key from the handler trace, to recover the round constants.

Per round-26 finding: real_index = (word - key + 0x5214a88c) & 0xffff
Small values = context slot offsets; large values = encrypted opcode.
"""
import json
import struct
from pathlib import Path

BUGLAND = Path(r"E:\Coding\S1mple\target\dump_out\41264\region_0000000180980000.bin")
BUGLAND_BASE = 0x180980000
TRACE = Path(r"E:\Coding\S1mple\target\vm_handler_execution_trace.json")

def main():
    bug = BUGLAND.read_bytes()
    print("bugland size:", hex(len(bug)))
    trace = json.loads(TRACE.read_text(encoding="utf-8"))
    print("trace transitions:", len(trace))

    # For each transition, VIP and key are known. Read the word at VIP (+4 per
    # the dispatch formula word[VIP+4]) and decrypt.
    # dispatch: index = (word[VIP+4] + key) & 0xffff  (round 26 corrected formula)
    # Let's reconstruct the bytecode word stream.
    words = []
    for t in trace[:200]:
        vip = int(t["vip"], 16)
        key = int(t["key"], 16) & 0xffffffff
        # read word at VIP+4 (little-endian 16-bit)
        off = vip + 4 - BUGLAND_BASE
        if 0 <= off < len(bug) - 1:
            w = struct.unpack("<H", bug[off:off+2])[0]
            # decrypt using rolling key low16
            dec = (w - (key & 0xffff)) & 0xffff
            words.append((vip, w, key & 0xffff, dec))
        else:
            words.append((vip, None, key & 0xffff, None))

    print("\nfirst 30 (vip, raw_word, key_low16, decrypted):")
    for vip, w, k, dec in words[:30]:
        print("  0x%x  raw=%s key=%04x  dec=%s" % (
            vip, ("%04x" % w) if w is not None else "?", k,
            ("%04x" % dec) if dec is not None else "?"))

    # Check distribution of decrypted values: small = slot offset?
    decs = [d for _,_,_,d in words if d is not None]
    small = [d for d in decs if d < 0x300]
    print("\ndecrypted values < 0x300 (context slot offsets?):", len(small))
    print("unique small values:", sorted(set(small))[:60])

if __name__ == "__main__":
    main()
