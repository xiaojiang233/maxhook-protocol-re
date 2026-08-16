#!/usr/bin/env python3
"""Compare context_dump.bin (256B) across the 4 calls of encrypt_boundary_capture2.
Find which bytes are key-derived (constant across calls) vs nonce/counter-derived."""
from pathlib import Path

P = Path(r"E:\Coding\S1mple\target\encrypt_boundary_capture2")

# map call_id -> context_dump filename (files use sequence numbers, but the meta
# context_dump is named 000007_call_1, 000018_call_2, 000029_call_3, 000040_call_4
# per the earlier listing; verify by glob)
import glob
ctxs = {}
for f in sorted(P.glob("*context_dump.bin")):
    # filename like 000007_call_1_meta_context_dump.bin
    cid = f.name.split("_call_")[1].split("_")[0]
    ctxs[cid] = f.read_bytes()

print("context dumps found for calls:", sorted(ctxs.keys()))
for cid in sorted(ctxs.keys()):
    print("call %s (256B):" % cid)
    print("  ", ctxs[cid].hex())

# compare bytes across calls
cids = sorted(ctxs.keys())
if len(cids) >= 2:
    print("\nbyte-wise comparison across calls:")
    const = []
    for i in range(256):
        vals = [ctxs[c][i] for c in cids]
        if len(set(vals)) == 1:
            const.append(i)
    print("constant-across-calls bytes:", len(const), [hex(i) for i in const])
    # changing bytes = nonce/counter-derived or ASLR
    for i in range(256):
        vals = [ctxs[c][i] for c in cids]
        if len(set(vals)) > 1:
            print("  +0x%02x: %s" % (i, " ".join("%02x" % v for v in vals)))
