"""Map the full address-space layout of the executed VM code (Stalker trace).

Determine the address ranges where the 5 rotate sites + shift sites + bswap
sites live, relative to the .bugland section and the handler-table stub range.
This reveals whether the ARX primitives are in the dispatcher, the handlers, or
a separate 'helper' region.
"""

from __future__ import annotations
import struct
from pathlib import Path
from collections import Counter

from capstone import Cs, CS_ARCH_X86, CS_MODE_64

TRACE_DIR = Path(r"E:\Coding\S1mple\target\vm_trace_capture4")
BUG = Path(r"E:\Coding\S1mple\target\runtime_bugland2.bin")
BUG_BASE = 0x180980000
BUG_END = BUG_BASE + BUG.stat().st_size

md = Cs(CS_ARCH_X86, CS_MODE_64)
bug = BUG.read_bytes()


def load_addrs(call=1):
    p = TRACE_DIR / f"vm_addrs_call{call}.txt"
    out = []
    for line in p.read_text().splitlines():
        line = line.strip()
        if not line:
            continue
        va_str, _, cnt = line.partition(":")
        out.append((int(va_str, 16), int(cnt)))
    return out


def main():
    addrs = load_addrs(1)
    print(f"{len(addrs)} unique addresses in call1")

    # address distribution: histogram by 1MB bucket
    buckets = Counter()
    for va, _ in addrs:
        buckets[va >> 20] += 1
    print("\naddress distribution (1MB buckets):")
    for b in sorted(buckets):
        lo = b << 20
        print(f"  0x{lo:012x}-0x{lo+0xfffff:012x}: {buckets[b]:6d}")

    # how many inside .bugland (0x180980000..0x180ef7c000)?
    in_bug = sum(1 for va, _ in addrs if BUG_BASE <= va < BUG_END)
    print(f"\n{in_bug}/{len(addrs)} addresses inside .bugland "
          f"(0x{BUG_BASE:x}..0x{BUG_END:x})")

    # The 5 rotate + 2 shift sites: which bucket?
    arx = [0x180a164be, 0x180b3cbf4, 0x180b5f49c, 0x180af6547, 0x180a59e63,
           0x180b3c56f, 0x1809d817b]
    print("\nARX site locations:")
    for va in arx:
        inb = "inside .bugland" if BUG_BASE <= va < BUG_END else "OUTSIDE .bugland"
        print(f"  0x{va:x}  -> {inb}")

    # what is the actual .bugland VA range from the PE? re-derive
    dll = Path(r"E:\Coding\S1mple\target\MaxHook.runtime-unpacked.dll").read_bytes()
    pe_off = struct.unpack_from("<I", dll, 0x3C)[0]
    nsec = struct.unpack_from("<H", dll, pe_off + 6)[0]
    opt_off = pe_off + 24
    opt_size = struct.unpack_from("<H", dll, pe_off + 20)[0]
    sec_off = opt_off + opt_size
    print("\nPE sections (VA ranges):")
    for i in range(nsec):
        off = sec_off + i * 40
        name = dll[off:off+8].rstrip(b"\x00").decode("latin1")
        vsize = struct.unpack_from("<I", dll, off + 8)[0]
        va = struct.unpack_from("<I", dll, off + 12)[0]
        base = 0x180000000 + va
        print(f"  {name:8s} 0x{base:x}..0x{base+vsize:x} (vsize 0x{vsize:x})")


if __name__ == "__main__":
    main()
