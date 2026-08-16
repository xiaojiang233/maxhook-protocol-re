#!/usr/bin/env python3
"""Map the VM context byte-by-byte: separate nonce-dependent cipher state from
position-dependent (counter) state from pure bookkeeping.

Strategy: 3 calls, each with a distinct nonce, each with many snapshots at
different xor_index (positions). For each context byte we can compute:
  - cross-call variance (nonce dependence)
  - within-call variance (position/counter dependence)
  - stability (bookkeeping / pointers / constants)

A byte that is:
  - stable everywhere        -> bookkeeping (pointer, constant, flags)
  - varies within-call only  -> counter/position state
  - varies across calls only -> nonce-derived state
  - varies both              -> mixed (state mixing)
"""
from __future__ import annotations
import json
from pathlib import Path
from collections import Counter, defaultdict

CAPTURE = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")
CTX_BASE = 0x18098C884
KNOWN = {
    0x0A: "rolling key (dword) - from milestone 17",
    0x6D: "VIP (qword) - from milestone 17",
    0x85: "handler table (qword) - from milestone 06",
    0xF6: "init flag (byte) - from milestone 17",
    0xB5: "dst1 = XOR destination (r8)",
    0x235: "dst2 = XOR destination (r8)",
    0xE5: "handler 0x1809bff47 refs rsi=rbp+0xe5",
    0x5D: "handler 0x180a02c94 refs r11=rbp+0x5d",
}


def main():
    snaps = []
    for f in sorted(CAPTURE.glob("*.bin")):
        j = json.loads(f.read_text(encoding="utf-8"))
        j["call"] = int(f.name.split("_call_")[1].split("_")[0])
        j["ctx"] = bytes.fromhex(j["context_hex"])
        snaps.append(j)

    by_call = defaultdict(list)
    for s in snaps:
        by_call[s["call"]].append(s)

    # classify each byte
    classes = {}
    for off in range(0x300):
        all_vals = [s["ctx"][off] for s in snaps]
        global_stable = len(set(all_vals)) == 1
        within = {}
        cross = {}
        for call, ss in by_call.items():
            wv = {s["ctx"][off] for s in ss}
            within[call] = len(wv) == 1
        within_stable = all(within.values())
        # cross-call: compare per-call representative values
        reps = {}
        for call, ss in by_call.items():
            reps[call] = Counter(s["ctx"][off] for s in ss).most_common(1)[0][0]
        cross_stable = len(set(reps.values())) == 1

        if global_stable:
            cls = "CONSTANT"
        elif within_stable and not cross_stable:
            cls = "NONCE-DERIVED"
        elif cross_stable and not within_stable:
            cls = "POSITION-DERIVED"
        else:
            cls = "MIXED"
        classes[off] = cls

    from collections import Counter as C2
    cnt = C2(classes.values())
    print("context byte classification (0x300 bytes):")
    for k in ["CONSTANT", "NONCE-DERIVED", "POSITION-DERIVED", "MIXED"]:
        print(f"  {k:16s}: {cnt.get(k,0):4d} bytes")

    # print runs of each class with known fields annotated
    print("\nclassified runs:")
    runs = []
    cur_cls = None
    start = None
    for off in range(0x300):
        c = classes[off]
        if c != cur_cls:
            if cur_cls is not None:
                runs.append((start, off - 1, cur_cls))
            cur_cls = c
            start = off
    runs.append((start, 0x2ff, cur_cls))
    for a, b, c in runs:
        annot = ""
        for k, v in KNOWN.items():
            if a <= k <= b:
                annot += f" [{v}]"
        print(f"  +0x{a:03x}..+0x{b:03x} {c:16s} ({b-a+1:3d}B){annot}")

    # Focus: the NONCE-DERIVED region (likely the key-scheduled state / S-box)
    print("\n=== NONCE-DERIVED bytes (constant within a call, differ across calls) ===")
    nonce_bytes = [off for off in range(0x300) if classes[off] == "NONCE-DERIVED"]
    print(f"  count={len(nonce_bytes)}")
    if nonce_bytes:
        # group runs
        nr = []
        s = nonce_bytes[0]; p = nonce_bytes[0]
        for o in nonce_bytes[1:]:
            if o == p + 1: p = o
            else: nr.append((s, p)); s = o; p = o
        nr.append((s, p))
        for a, b in nr:
            print(f"    +0x{a:03x}..+0x{b:03x} ({b-a+1}B)")

    # For each call, dump the nonce-derived region values
    print("\n=== nonce-derived values per call (first 48 bytes of that region) ===")
    if nonce_bytes:
        for call, ss in sorted(by_call.items()):
            vals = [ss[0]["ctx"][o] for o in nonce_bytes]
            print(f"  call {call}: " + bytes(vals).hex())

    # The MIXED region is the live state (keystream). Show its extent.
    mixed = [o for o in range(0x300) if classes[o] == "MIXED"]
    print(f"\n=== MIXED (live state) bytes = {len(mixed)} ===")

    # Dump full context for the LAST snapshot as a reference hexdump with classes
    print("\n=== full context hexdump of last snapshot (class annotations) ===")
    last = snaps[-1]
    for base in range(0, 0x300, 16):
        row = last["ctx"][base:base+16]
        hexs = " ".join(f"{b:02x}" for b in row)
        cls = "".join(classes[base+i][0] for i in range(16))
        print(f"  +0x{base:03x}: {hexs}  [{cls}]")


if __name__ == "__main__":
    main()
