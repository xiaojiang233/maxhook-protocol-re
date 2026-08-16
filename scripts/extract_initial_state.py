#!/usr/bin/env python3
"""Extract the state at the FIRST XOR (xor_index=0) of each call in the live
keystream_history session. This is the state right after key-schedule completes,
closest to the 'initial state' I need to derive key_schedule_expand().

Compare the first-XOR state across the 3 calls (3 keys) to find:
- key-derived bytes (differ across calls)
- fixed structure (module pointers, constants)
"""
import json
from pathlib import Path

CAP = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")

def load_first(call):
    for f in sorted(CAP.glob("*call_%s*.bin" % call)):
        d = json.loads(f.read_text(encoding="utf-8"))
        if d["xor_index"] == 0:
            return d["keystream_byte"], bytes.fromhex(d["context_hex"])
    return None, None

def main():
    states = {}
    for call in (1, 2, 3):
        kb, ctx = load_first(call)
        states[call] = (kb, ctx)
        print("call %d: first XOR keystream byte = 0x%02x" % (call, kb))

    # Compare bytes across the 3 first-XOR states
    c1, c2, c3 = states[1][1], states[2][1], states[3][1]
    print("\nbyte-wise comparison of first-XOR context (768B):")
    key_derived = []   # differ across calls
    fixed = []         # same across all 3 calls
    for i in range(768):
        vals = {c1[i], c2[i], c3[i]}
        if len(vals) == 1:
            fixed.append(i)
        else:
            key_derived.append(i)
    print("fixed (same across 3 keys): %d bytes" % len(fixed))
    print("key-derived (differ): %d bytes" % len(key_derived))

    # print the key-derived byte ranges
    def ranges(lst):
        out = []
        s = p = lst[0]
        for o in lst[1:]:
            if o == p + 1:
                p = o
            else:
                out.append((s, p)); s = p = o
        out.append((s, p))
        return out

    print("\nkey-derived ranges (offset: c1 c2 c3):")
    for a, b in ranges(key_derived):
        print("  +0x%03x..+0x%03x: %s | %s | %s" % (
            a, b, c1[a:b+1].hex(), c2[a:b+1].hex(), c3[a:b+1].hex()))

if __name__ == "__main__":
    main()
