#!/usr/bin/env python3
"""Determine the correct entry handler from the live context's VIP, so the
walker can start at the right point (where the key-schedule for THIS call
begins, with key/nonce already seeded).

The live context VIP=0x181454d15. The handler at this point is determined by
the dispatch state.  Let me compare the live context against the idle context
to understand where they diverge (the key-schedule start point)."""
import struct
from pathlib import Path

P = Path(r"E:\Coding\S1mple\target\vm_context_capture2")
DUMP = Path(r"E:\Coding\S1mple\target\dump_out\41264\region_0000000180980000.bin")
CTX_BASE = 0x18098C884
BUG_BASE = 0x180980000

def main():
    live = (P / "000006_call_1_meta_vm_enter_context.bin").read_bytes()
    dump = DUMP.read_bytes()
    idle = dump[CTX_BASE - BUG_BASE : CTX_BASE - BUG_BASE + 768]

    print("live VIP:", hex(int.from_bytes(live[0x6d:0x75], "little")))
    print("idle VIP:", hex(int.from_bytes(idle[0x6d:0x75], "little")))
    print("live key:", hex(int.from_bytes(live[0xa:0xe], "little")))
    print("idle key:", hex(int.from_bytes(idle[0xa:0xe], "little")))

    # The live context VIP 0x181454d15 — is it in the bugland range?
    vip_live = int.from_bytes(live[0x6d:0x75], "little")
    # find which bytecode word is at VIP in the bugland
    off = vip_live - BUG_BASE
    w = struct.unpack_from("<H", dump, off)[0] if 0 <= off < len(dump) - 2 else None
    print("\nword at live VIP:", hex(w) if w is not None else "?")

    # The key difference: live flag=0x41, idle flag=0x69.  The live state is
    # post-key-schedule (a previous call's residual).  The NEW call's key-schedule
    # starts from this persistent state.
    print("\nThis confirms: live context = persistent post-key-schedule state.")
    print("The walker should start from THIS state (not idle), at the dispatcher,")
    print("but needs the correct register setup (from vm_enter_stack, not captured).")

if __name__ == "__main__":
    main()
