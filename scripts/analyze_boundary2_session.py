#!/usr/bin/env python3
"""Extract and verify the 4 complete calls in encrypt_boundary_capture2 (pid 46460).
This session has 4 calls with the SAME key and complete (nonce, ciphertext, tag).
Compute keystream = plaintext XOR ciphertext and check for cross-call relationships."""
import json
from pathlib import Path

P = Path(r"E:\Coding\S1mple\target\encrypt_boundary_capture2")

def main():
    summary = json.load(open(P / "capture_summary.json", encoding="utf-8"))
    calls = []
    for c in summary["calls"]:
        cid = c["call_id"]
        files = {(s["phase"], s["label"]): s["file"] for s in c["strings"]}
        key = (P / files[("input", "input64")]).read_bytes()
        nonce = (P / files[("output", "nonce_hex")]).read_bytes()
        ct = (P / files[("output", "ciphertext_hex")]).read_bytes()
        tag = (P / files[("output", "tag_hex")]).read_bytes()
        pt = (P / files[("input", "plaintext_json")]).read_bytes()
        # ciphertext_hex is hex-encoded; decode
        ct_bytes = bytes.fromhex(ct.decode())
        # keystream = plaintext XOR ciphertext (first len(pt) bytes)
        ks = bytes(a ^ b for a, b in zip(pt, ct_bytes))
        calls.append({
            "cid": cid, "key": key.decode(), "nonce": nonce.decode(),
            "pt": pt, "ct": ct_bytes, "tag": tag.decode(), "ks": ks,
            "nonce_bytes": bytes.fromhex(nonce.decode()),
        })
        print("call %s: key=%s nonce=%s pt=%d ct=%d" % (
            cid, key.decode()[:12] + "...", nonce.decode(), len(pt), len(ct_bytes)))
        print("         ks[0:16] = %s" % ks[:16].hex())
        print("         pt[0:32] = %s" % pt[:32].decode(errors="replace"))

    # Verify all 4 keys are identical
    keys = {c["key"] for c in calls}
    print("\nkeys identical across calls:", len(keys) == 1, "->", list(keys)[0][:12] + "...")

    # Check: nonces all distinct
    nonces = [c["nonce"] for c in calls]
    print("nonces:", nonces)

    # keystream relationship: KS1 ^ KS2 should relate to nonce if weak mixing
    if len(calls) >= 2:
        k1 = calls[0]["ks"]; k2 = calls[1]["ks"]
        n1 = calls[0]["nonce_bytes"]; n2 = calls[1]["nonce_bytes"]
        diff = bytes(a ^ b for a, b in zip(k1, k2))
        print("\nKS1^KS2 first 16:", diff[:16].hex())
        print("N1^N2:", (bytes(a ^ b for a, b in zip(n1, n2))).hex())
        print("KS1^KS2 == N1^N2 (weak additive nonce)?", diff[:len(n1)] == bytes(a^b for a,b in zip(n1,n2)))

if __name__ == "__main__":
    main()
