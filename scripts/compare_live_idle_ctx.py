#!/usr/bin/env python3
"""Compare the live vm_enter_context (512B) with the idle dump context (768B)
to determine what the 512B covers and what's missing for the emulator.

Key slots to check:
  +0x0a key, +0x6d VIP, +0x85 handler table, +0x162 flag
  +0x180..+0x2db (key-schedule state region, round 112/115)
"""
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

    print("live vm_enter_context: %dB" % len(live))
    print("idle dump context: %dB" % len(idle))
    print()

    # Compare critical slots
    print("slot | live (512B) | idle (768B) | same?")
    for slot, name in [(0x0a, "key"), (0x6d, "VIP"), (0x85, "handler table"),
                       (0x162, "flag"), (0x26, "block counter"), (0xd9, "byte offset"),
                       (0x61, "state table ptr"), (0xbd, "key ptr"), (0x106, "state"),
                       (0x1e, "round state"), (0x143, "state2")]:
        lv = live[slot:slot+8].hex() if slot+8 <= len(live) else live[slot:].hex()
        iv = idle[slot:slot+8].hex() if slot+8 <= len(idle) else idle[slot:].hex()
        same = live[slot] == idle[slot]
        print("+0x%03x %-16s | %s | %s | %s" % (slot, name, lv, iv, same))

    # Check the key-schedule state region 0x180..0x2db in the live context
    print("\nkey-schedule state region 0x180..0x2db (live):")
    print("  ", live[0x180:0x2e0].hex())

if __name__ == "__main__":
    main()
