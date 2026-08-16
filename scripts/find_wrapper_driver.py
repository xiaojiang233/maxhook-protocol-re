#!/usr/bin/env python3
"""Find the DRIVER function that calls the key-schedule wrappers (0x180322a20,
0x180322aa0, 0x180322ae0, ...).  Search the DLL .text for 'call' instructions
targeting these wrapper addresses (or lea/rip-relative references)."""
import struct
from pathlib import Path
import sys
sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
from capstone import CS_ARCH_X86, CS_MODE_64, Cs
import pefile

DLL = Path(r"E:\Coding\S1mple\target\MaxHook.runtime-unpacked.dll")

# The wrapper region: 0x180322a20 .. 0x180322e00 (a block of small wrapper fns)
WRAPPER_START = 0x180322a20
WRAPPER_END = 0x180322e00

def va_to_off(pe, va):
    for s in pe.sections:
        sec_va = 0x180000000 + s.VirtualAddress
        vs = max(s.Misc_VirtualSize, s.SizeOfRawData)
        if sec_va <= va < sec_va + vs:
            return s.PointerToRawData + (va - sec_va)
    return None

def main():
    pe = pefile.PE(str(DLL))
    raw = DLL.read_bytes()
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    md.detail = True

    # Scan the .text section for call/lea/jmp to wrapper addresses
    # The .text section is 0x180001000 .. 0x180980000 (large).  Scan for
    # 'call imm' where imm is in the wrapper range, and 'lea reg,[rip+disp]'
    # whose target is in the wrapper range.
    from capstone.x86_const import X86_OP_IMM, X86_OP_MEM, X86_REG_RIP

    results = []
    for s in pe.sections:
        name = s.Name.rstrip(b'\x00').decode('ascii', 'replace')
        if 'text' not in name.lower():
            continue
        sec_va = 0x180000000 + s.VirtualAddress
        sec_raw = raw[s.PointerToRawData : s.PointerToRawData + s.SizeOfRawData]
        print("scanning section %s (va %#x, %d bytes)" % (name, sec_va, len(sec_raw)))
        for insn in md.disasm(sec_raw, sec_va):
            # call imm to wrapper
            if insn.mnemonic == "call" and insn.operands and insn.operands[0].type == X86_OP_IMM:
                tgt = insn.operands[0].imm
                if WRAPPER_START <= tgt < WRAPPER_END:
                    results.append((insn.address, "call", tgt))
            # lea reg, [rip + disp] -> target in wrapper range
            if insn.mnemonic in ("lea", "mov") and len(insn.operands) >= 2:
                op = insn.operands[1]
                if op.type == X86_OP_MEM and op.mem.base == X86_REG_RIP:
                    tgt = insn.address + insn.size + op.mem.disp
                    if WRAPPER_START <= tgt < WRAPPER_END:
                        results.append((insn.address, "lea", tgt))
        # limit results
        if len(results) > 50:
            break

    print("\ncross-references to key-schedule wrappers (0x180322a20..0x180322e00):")
    for addr, kind, tgt in results[:50]:
        print("  %#x: %s -> %#x" % (addr, kind, tgt))

if __name__ == "__main__":
    main()
