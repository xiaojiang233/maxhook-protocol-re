#!/usr/bin/env python3
"""Examine vm_context_capture2 (pid 44328): the synchronized key + VM context
+ output session.  This is the missing data that could close the fold."""
import json
from pathlib import Path

P = Path(r"E:\Coding\S1mple\target\vm_context_capture2")

def main():
    summ = json.load(open(P / "capture_summary.json", encoding="utf-8"))
    print("pid:", summ.get("pid"), "call_count:", summ.get("call_count"))

    # read call 1: key, nonce, vm context, ciphertext, tag
    key = (P / "000004_call_1_input_input64.bin").read_bytes()
    nonce = (P / "000009_call_1_output_nonce_hex.bin").read_bytes()
    ctx = (P / "000006_call_1_meta_vm_enter_context.bin").read_bytes()
    ct = (P / "000010_call_1_output_ciphertext_hex.bin").read_bytes()
    tag = (P / "000011_call_1_output_tag_hex.bin").read_bytes()
    pt = (P / "000005_call_1_input_plaintext_json.bin").read_bytes()

    print("\ncall 1:")
    print("  key (%dB):" % len(key), key.decode())
    print("  nonce (%dB):" % len(nonce), nonce.decode())
    print("  ciphertext hex (%dB):" % len(ct))
    print("  tag (%dB):" % len(tag), tag.decode())
    print("  plaintext (%dB):" % len(pt))
    print("  vm_enter_context (%dB):" % len(ctx))

    # decode ciphertext and compute keystream
    ct_bytes = bytes.fromhex(ct.decode())
    ks = bytes(a ^ b for a, b in zip(pt, ct_bytes))
    print("\n  keystream[0:16]:", ks[:16].hex())

    # The vm_enter_context is 512B (partial VM context). Check what it contains.
    print("\n  vm_enter_context structure (512B):")
    print("    first 64:", ctx[:64].hex())
    # Is it the VM context at 0x18098c884? Check handler table pointer at +0x85
    print("    +0x85 (handler table ptr):", ctx[0x85:0x8d].hex())
    print("    +0x6d (VIP):", ctx[0x6d:0x75].hex())
    print("    +0xa (key):", ctx[0xa:0xe].hex())
    print("    +0x162 (flag):", hex(ctx[0x162]))

if __name__ == "__main__":
    main()
