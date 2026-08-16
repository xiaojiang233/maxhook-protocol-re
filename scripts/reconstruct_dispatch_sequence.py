#!/usr/bin/env python3
"""Reconstruct the full key-schedule dispatch chain from the LIVE history
(pid 42948) ring buffer, which records the actual executed handler addresses in
order.  Map each to its table index via the decrypted handler table, giving the
exact dispatch index sequence (the decoded bytecode program)."""
import json
import struct
from pathlib import Path
from collections import Counter, OrderedDict

BUGLAND = Path(r"E:\Coding\S1mple\target\dump_out\41264\region_0000000180980000.bin")
BUGLAND_BASE = 0x180980000
TABLE_VA = 0x180C64EBD
CAP = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")

def main():
    blob = BUGLAND.read_bytes()
    def rd64(va): return struct.unpack_from("<Q", blob, va - BUGLAND_BASE)[0]

    # build target -> index map
    target_to_index = {}
    for i in range(1612):
        t = rd64(TABLE_VA + i * 8)
        target_to_index.setdefault(t, []).append(i)

    # load live history (call 1)
    d = json.loads(sorted(CAP.glob("*call_1*.bin"))[0].read_bytes().decode("utf-8"))
    history = d["history"]
    print("history entries:", len(history))

    # Map each history entry that is a handler target to its table index.
    # The dispatcher (0x1809a57e1) appears between handlers; handler bodies are
    # the .bugland addresses in the handler table.
    seq = []
    for h in history:
        va = int(h, 16)
        if va in target_to_index:
            seq.append((va, target_to_index[va][0]))

    print("handler executions mapped to table index:", len(seq))
    # dedupe consecutive repeats (a handler body may appear multiple times as
    # the same block executes repeatedly)
    # print the sequence of (handler, index) in order
    print("\nfirst 60 (handler, table_index):")
    for va, idx in seq[:60]:
        print("  %#x -> idx %#x (%d)" % (va, idx, idx))

    # distinct indices executed (the opcode set)
    idxs = [idx for _, idx in seq]
    print("\ndistinct table indices executed:", len(set(idxs)))
    print("index values (sorted):", sorted(set(idxs)))

if __name__ == "__main__":
    main()
