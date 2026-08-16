#!/usr/bin/env python3
"""angr-based symbolic execution of a key-schedule handler to extract its
context-slot ARX semantics.

The handler body reads context slots (rbp+off), does ARX, writes back.  We
symbolically execute the handler with the context slots as symbolic values and
observe which slots are written and with what expression.

This automates the manual decoding done in rounds 234-235, and can extend to
all 54 handlers.

Approach:
  1. Map the .bugland blob + DLL into angr.
  2. Symbolize the context (rbp=0x18098c884, slots symbolic).
  3. Execute the handler body, collect writes to context slots.
"""
from __future__ import annotations
import struct
from pathlib import Path
import sys

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE / ".pydeps"))

import angr  # noqa: E402
import claripy  # noqa: E402

BUGLAND = HERE / "runtime_bugland2.bin"
BUG = 0x180980000
CTX_BASE = 0x18098C884

def main():
    blob = BUGLAND.read_bytes()

    # Create the angr project from the raw blob loaded at BUG.
    # angr needs an entry point and memory.  Use a blank state.
    proj = angr.Project(str(HERE / "MaxHook.runtime-unpacked.dll"), auto_load_libs=False)

    # We'll map the bugland separately by executing from a concrete address.
    # Simpler: use a SimState with symbolic memory.

    # Handler to analyze: chain A body 0x18099089e (slot swap).
    HANDLER = 0x18099089E

    # Create a blank state with the handler's code region.
    # Since angr already loaded the DLL (which covers 0x180000000..), we need
    # the bugland region too.  The DLL's .text covers up to ~0x180980000, and
    # bugland is 0x180980000+.  Let's just use a concrete emulation approach
    # with claripy symbols for the context.

    print("angr symbolic executor for handler %#x" % HANDLER)
    print("=" * 60)

    # The context base is 0x18098c884.  We symbolize the context slots that
    # the handler reads and track writes.

    # For a focused, robust approach: symbolize a few context slots and
    # execute the handler body concretely otherwise.

    # State setup
    st = proj.factory.blank_state(addr=HANDLER)
    st.regs.rbp = CTX_BASE

    # Symbolize context slots the handler reads: +0x6d (VIP), and the slots
    # indexed by bytecode words.  For chain A body, it reads [ctx+0x6d] (VIP)
    # then word[VIP+4], word[VIP+2], and the two context slots they index.
    # We symbolize VIP's target memory too.

    # Symbolize the VIP (a qword pointer)
    vip = claripy.BVS("vip", 64)
    st.memory.store(CTX_BASE + 0x6d, vip)

    # Symbolize a few slots for the bytecode words to index into
    for off in (0xa, 0x5d, 0x69, 0xe5, 0xb5, 0x26, 0xd9, 0x61, 0xbd, 0x106, 0x1e, 0x143):
        st.memory.store(CTX_BASE + off, claripy.BVS("ctx_%03x" % off, 64))

    # The bytecode memory (pointed to by VIP) — symbolize a page
    st.memory.store(vip, claripy.BVS("bytecode", 64 * 8))

    # Execute the handler body until ret/jmp
    sm = proj.factory.simulation_manager(st)
    # Run a bounded number of steps
    sm.run(n=200)

    print("states after run:", len(sm.active))
    for s in sm.active:
        print("RIP:", hex(s.solver.eval(s.regs.rip)))
        # Check the context slot values (writes)
        for off in (0xa, 0x5d, 0x69, 0xe5):
            val = s.memory.load(CTX_BASE + off, 8, endness="Iend_LE")
            try:
                print("  ctx+%03x = %s" % (off, s.solver.eval(val)))
            except Exception as e:
                print("  ctx+%03x = symbolic" % off)

if __name__ == "__main__":
    main()
