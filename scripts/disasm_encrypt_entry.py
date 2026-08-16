#!/usr/bin/env python3
"""
Disassemble the MaxHook encrypt entry 0x180324610 (.text) to locate where the
key (input64) and nonce are written into the VM context (key-schedule seed).

This is the single remaining step to close the packet-body encryption: find
the seed write point, then feed real key+nonce into the offline replay.
"""
from __future__ import annotations
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE / ".pydeps"))
from capstone import CS_ARCH_X86, CS_MODE_64, Cs

DLL = HERE / "MaxHook.runtime-unpacked.dll"
IMAGE_BASE = 0x180000000
ENTRY = 0x180324610

def main():
    blob = DLL.read_bytes()
    import pefile
    pe = pefile.PE(str(DLL))
    # find section
    for s in pe.sections:
        va = IMAGE_BASE + s.VirtualAddress
        if va <= ENTRY < va + s.Misc_VirtualSize:
            sec = s
            break
    rva = ENTRY - IMAGE_BASE
    off = sec.get_offset_from_rva(rva)
    code = blob[off:off + 0x600]
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    md.detail = True
    for insn in md.disasm(code, ENTRY):
        print(f"0x{insn.address:x}: {insn.mnemonic:<8} {insn.op_str}")
        if insn.address > ENTRY + 0x500:
            break

if __name__ == "__main__":
    main()
