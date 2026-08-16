#!/usr/bin/env python3
"""Final attempt: execute the plaintext key-schedule with key+nonce as std::string
input, and capture the keystream.

The key-schedule wrappers process std::string {data_ptr, size, capacity}.  We
construct the key (input64 hex string) as a std::string and execute the key-schedule
entry 0x180322a20, tracing the store32 output.

Note: this is a focused attempt to see how far we get with the plaintext execution."""
import struct
from pathlib import Path
import sys
sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
from unicorn import Uc, UC_ARCH_X86, UC_MODE_64, UC_HOOK_CODE, UcError
from unicorn.x86_const import *
from capstone import CS_ARCH_X86, CS_MODE_64, Cs
import pefile

DLL = Path(r"E:\Coding\S1mple\target\MaxHook.runtime-unpacked.dll")
STORE32 = 0x18041A860

def main():
    pe = pefile.PE(str(DLL))
    raw = DLL.read_bytes()
    md = Cs(CS_ARCH_X86, CS_MODE_64)

    uc = Uc(UC_ARCH_X86, UC_MODE_64)
    image_size = (pe.OPTIONAL_HEADER.SizeOfImage + 0xFFF) & ~0xFFF
    uc.mem_map(0x180000000, image_size)
    uc.mem_write(0x180000000, raw[:pe.OPTIONAL_HEADER.SizeOfHeaders])
    for section in pe.sections:
        data = section.get_data()
        if data:
            uc.mem_write(0x180000000 + section.VirtualAddress, data)
    # also overlay the decrypted bugland
    bug = Path(r"E:\Coding\S1mple\target\runtime_bugland2.bin").read_bytes()
    uc.mem_write(0x180980000, bug)

    STACK = 0x7FF000000000
    uc.mem_map(STACK, 0x100000)
    uc.reg_write(UC_X86_REG_RSP, STACK + 0x80000)

    # construct the key std::string
    key_hex = b"32206F9C196327AD276821AC8EBC7F80FE82D84CF72A4F7C1BAF508C97D3AEA8"  # 64 chars
    heap = 0x20000000000
    uc.mem_map(heap, 0x10000)
    # std::string {data_ptr, size, capacity}
    uc.mem_write(heap + 0x100, key_hex)
    str_obj = heap + 0x200
    uc.mem_write(str_obj, struct.pack("<QQQ", heap + 0x100, len(key_hex), 79))

    # Set up: the key-schedule wrapper entry 0x180322a20 takes rcx=struct, rdx=?
    # From the wrapper: r8=rcx; rax=[rcx+8] (size); ... call helper with rcx=rdx
    # So rcx = input string object, rdx = another string object (output?)
    uc.reg_write(UC_X86_REG_RCX, str_obj)
    uc.reg_write(UC_X86_REG_RDX, str_obj)  # guess

    state = {"store32": []}
    def on_code(uc_, address, size_, user):
        if address == STORE32:
            dest = uc_.reg_read(UC_X86_REG_RCX)
            val = uc_.reg_read(UC_X86_REG_RDX) & 0xFFFFFFFF
            state["store32"].append((dest, val))
            uc_.emu_stop()
    uc.hook_add(UC_HOOK_CODE, on_code)

    try:
        uc.emu_start(0x180322a20, 0, timeout=2_000_000, count=50000)
    except UcError as e:
        print("UcError:", e)

    print("store32 captured:", len(state["store32"]))
    for d, v in state["store32"][:16]:
        print("  val=%#010x" % v)

if __name__ == "__main__":
    main()
