#!/usr/bin/env python3
"""Verify vm_context_capture2 (pid 44328) completeness: 10 calls, each with
key + vm_enter_context + ciphertext + tag.  This is the synchronized data that
closes the fold."""
import json
from pathlib import Path
import re

P = Path(r"E:\Coding\S1mple\target\vm_context_capture2")

def main():
    summ = json.load(open(P / "capture_summary.json", encoding="utf-8"))
    calls = summ.get("calls", [])
    print("total calls:", len(calls))

    # map files per call from summary
    for c in calls:
        cid = c["call_id"]
        files = {}
        for s in c.get("strings", []):
            files[(s["phase"], s["label"])] = s["file"]
        key_f = files.get(("input", "input64"))
        nonce_f = files.get(("output", "nonce_hex"))
        ct_f = files.get(("output", "ciphertext_hex"))
        tag_f = files.get(("output", "tag_hex"))
        pt_f = files.get(("input", "plaintext_json"))
        # find vm_enter_context file
        ctx_f = None
        for f in P.glob("*call_%s*vm_enter_context*" % cid):
            ctx_f = f.name
        print("\ncall %s:" % cid)
        if key_f:
            key = (P / key_f).read_bytes().decode()
            print("  key:", key)
        if ctx_f:
            ctx = (P / ctx_f).read_bytes()
            print("  vm_ctx: flag=%#x key=%s vip=%s" % (
                ctx[0x162], ctx[0xa:0xe].hex(), ctx[0x6d:0x75].hex()))
        if nonce_f:
            print("  nonce:", (P / nonce_f).read_bytes().decode())
        if ct_f and pt_f:
            ct = bytes.fromhex((P / ct_f).read_bytes().decode())
            pt = (P / pt_f).read_bytes()
            ks = bytes(a ^ b for a, b in zip(pt, ct))
            print("  keystream[0:8]:", ks[:8].hex())

if __name__ == "__main__":
    main()
