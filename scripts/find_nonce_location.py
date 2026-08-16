#!/usr/bin/env python3
"""Understand the complete input state: how the key and nonce enter the VM.

The encrypt function 0x180324610 has R8=input64 (key hex string). The key-schedule
reads the key from +0xbd pointer (0x1807bdc70). Where does the nonce come from?

Let me examine the vm_enter_context's full 512B to find all pointers and the
nonce location."""
from pathlib import Path
import struct

P = Path(r"E:\Coding\S1mple\target\vm_context_capture2")

def main():
    ctx = (P / "000006_call_1_meta_vm_enter_context.bin").read_bytes()
    # scan for all qword-aligned pointers (values that look like module .data or heap)
    print("vm_enter_context pointers (qword-aligned):")
    for off in range(0, 512, 8):
        v = int.from_bytes(ctx[off:off+8], "little")
        # module .data range 0x180000000-0x180980000, heap 0x180000000+ or 0x1xx
        if 0x180000000 <= v < 0x181000000 or 0x1800000000 <= v < 0x20000000000:
            print("  +0x%03x: %#x" % (off, v))

    # nonce is 12 bytes. Look for the nonce in the context or nearby.
    nonce = bytes.fromhex((P / "000009_call_1_output_nonce_hex.bin").read_bytes().decode())
    print("\nnonce:", nonce.hex())
    # search for nonce bytes in the 512B context
    print("nonce in context?", nonce in ctx)

if __name__ == "__main__":
    main()
