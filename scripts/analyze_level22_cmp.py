#!/usr/bin/env python3
"""Determine whether the level-22 branch is key-dependent or position-dependent
by concretely tracing register values at the cmp 0x1809d2d81.

From the chain JSON, level 22 handler body = 0x1809d2bc2, and it reads:
  r11 = [ctx+0x6d] (VIP), then +4 -> word[VIP+4]
The cmp is `cmp qword ptr [r11], rdx`.

We need the concrete values. The keystream_history snapshots have the live
context at XOR time. The level-22 branch happens DURING key-schedule (before
XOR). But the branch compares a slot that might be the block counter or a
key-derived value.

Let me determine: what does `rdx` equal (the constant), and what slot does [r11]
point to (via word[VIP+4]).
"""
import struct
from pathlib import Path
import sys
sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
from capstone import CS_ARCH_X86, CS_MODE_64, Cs

BUGLAND = Path(r"E:\Coding\S1mple\target\dump_out\41264\region_0000000180980000.bin")
BUGLAND_BASE = 0x180980000

def main():
    blob = BUGLAND.read_bytes()
    md = Cs(CS_ARCH_X86, CS_MODE_64)

    # Disassemble the full level-22 handler body 0x1809d2bc2 to understand the
    # dataflow into the cmp at 0x1809d2d81.
    # We need: what r11 and rdx are at the cmp.
    # rdx: or rdx,0x20 (0x1809d2bc8); xor rdx,0x88 (0x1809d2bff); add rdx,4 (0x1809d2c0d)
    #   But rdx's INITIAL value matters (from level 21's output).
    # r11: mov r11,rbp (0x1809d2bc5); add r11,0x6d (0x1809d2bdd); mov r11,[r11] (0x1809d2bee)
    #      add r11,4 (0x1809d2c06) -> r11 = VIP + 4
    # So cmp compares [VIP+4] (qword) against rdx.
    # But wait, [r11] at the cmp is a qword ptr deref of r11=VIP+4? No:
    #   r11 = VIP (after mov r11,[r11]), then add r11,4 -> r11 = VIP+4
    #   cmp qword ptr [r11], rdx = cmp qword[VIP+4], rdx
    # [VIP+4] is a qword read of bytecode data at VIP+4.

    # Determine rdx's constant: from level 21's key_after = 0x53890e3b (per chain JSON)
    # Actually rdx at entry to level 22 is unknown. But the or/xor/add transforms
    # are applied. If rdx started as 0, result = 0x20 | ... xor 0x88 + 4.
    # Let's just note the structure and check: is the cmp a decoy (both branches
    # converge) or a real branch?

    # Disassemble around the cmp and following jcc to see branch targets
    off = 0x1809d2d81 - BUGLAND_BASE
    code = blob[off:off + 0x80]
    insns = list(md.disasm(code, 0x1809d2d81))
    print("=== from cmp 0x1809d2d81 (following branch) ===")
    for insn in insns[:30]:
        mark = ""
        if insn.mnemonic.startswith("j") and insn.mnemonic != "jmp":
            mark = "  <-- conditional branch target: %s" % insn.op_str
        print("  %#x: %s %s%s" % (insn.address, insn.mnemonic, insn.op_str, mark))

if __name__ == "__main__":
    main()
