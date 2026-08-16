#!/usr/bin/env python3
"""Determine where the key-schedule reads the key, so we can seed the real key
(vm_context_capture2 key 32206F9C...) into the walker to produce keystream.

The key pointer is at context+0xbd. Check its value in vm_enter_context."""
from pathlib import Path

P = Path(r"E:\Coding\S1mple\target\vm_context_capture2")

def main():
    ctx = (P / "000006_call_1_meta_vm_enter_context.bin").read_bytes()
    # key pointer at +0xbd (8 bytes)
    key_ptr = int.from_bytes(ctx[0xbd:0xc5], "little")
    print("key pointer (+0xbd):", hex(key_ptr))
    # also +0x45 (state buffer pointer), +0x61 (state table), +0xc5 (keystream source)
    print("+0x45 (state ptr):", hex(int.from_bytes(ctx[0x45:0x4d], "little")))
    print("+0x61 (state table):", hex(int.from_bytes(ctx[0x61:0x69], "little")))
    print("+0xc5 (keystream src):", hex(int.from_bytes(ctx[0xc5:0xcd], "little")))

    # key (from input64)
    key = bytes.fromhex((P / "000004_call_1_input_input64.bin").read_bytes().decode())
    print("\nkey (32B):", key.hex())

if __name__ == "__main__":
    main()
