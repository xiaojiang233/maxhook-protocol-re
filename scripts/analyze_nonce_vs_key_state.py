#!/usr/bin/env python3
"""Compare the 10 vm_enter_context snapshots (same key, 10 nonces) to separate
key-derived (constant) vs nonce-derived (varying) VM context bytes.

This is now possible because we KNOW the key (32206F9C...) and have the live
context at encryption entry for 10 different nonces."""
from pathlib import Path
import json

P = Path(r"E:\Coding\S1mple\target\vm_context_capture2")

def main():
    # load all 10 vm_enter_context + nonces
    ctxs = []
    nonces = []
    for i in range(1, 11):
        ctxf = sorted(P.glob("*call_%d*vm_enter_context*" % i))
        noncef = sorted(P.glob("*call_%d*nonce*" % i))
        if ctxf and noncef:
            ctxs.append(ctxf[0].read_bytes())
            nonces.append(bytes.fromhex(noncef[0].read_bytes().decode()))
    print("loaded %d vm_enter_context snapshots" % len(ctxs))
    print("nonces:")
    for n in nonces:
        print("  ", n.hex())

    # Compare bytes across the 10 snapshots
    n = len(ctxs)
    constant = []   # same across all 10
    varying = []    # differs
    for i in range(512):
        vals = {c[i] for c in ctxs}
        if len(vals) == 1:
            constant.append(i)
        else:
            varying.append(i)
    print("\nconstant across 10 nonces (key-derived or static): %d bytes" % len(constant))
    print("varying (nonce-derived): %d bytes" % len(varying))

    # group varying into ranges
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

    print("\nnonce-derived byte ranges (offset: values across 10 nonces):")
    for a, b in ranges(varying):
        vals = [ctxs[j][a:b+1].hex() for j in range(n)]
        uniq = sorted(set(vals))
        print("  +0x%03x..+0x%03x (%dB): %d distinct" % (a, b, b-a+1, len(uniq)))
        if len(uniq) <= 3:
            for v in uniq:
                print("      %s" % v)

if __name__ == "__main__":
    main()
