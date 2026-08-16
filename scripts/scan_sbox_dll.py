#!/usr/bin/env python3
"""Fast targeted scan for 256-byte permutation tables (S-box candidates) in the
runtime-unpacked DLL's writable data sections."""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
import pefile

DLL = Path(r"E:\Coding\S1mple\target\MaxHook.runtime-unpacked.dll")
IMAGE_BASE = 0x180000000

def main():
    pe = pefile.PE(str(DLL))
    raw = DLL.read_bytes()
    total = 0
    found = []
    for s in pe.sections:
        name = s.Name.decode(errors="replace").strip("\x00")
        # only writable data sections
        if not (s.Characteristics & 0x80000000):  # MEM_WRITE
            continue
        data = s.get_data()
        if not data or len(data) < 256:
            continue
        base_va = IMAGE_BASE + s.VirtualAddress
        n = len(data)
        total += n
        # Slide over 256-byte windows checking distinct-count
        for off in range(0, n - 255):
            window = data[off:off + 256]
            if len(set(window)) == 256:
                found.append((base_va + off, name))
                if len(found) >= 50:
                    break
        if len(found) >= 50:
            break
    print("scanned %d bytes of writable data" % total)
    print("256-byte permutations found:", len(found))
    for va, name in found:
        print("  0x%x (%s)" % (va, name))

    # Also look for the specific S-box pointer context slot referenced 0x180835f10
    # already checked: it's a pointer table.  Also check 0x180835f10 vicinity.
    # Additionally, scan for 512-byte tables (16x32 or 64x8) with high entropy.
    # Report any region with >=200 distinct bytes in a 256B window (high entropy).
    print("\nhigh-entropy (>=200 distinct/256B) windows in writable data:")
    cnt = 0
    for s in pe.sections:
        name = s.Name.decode(errors="replace").strip("\x00")
        if not (s.Characteristics & 0x80000000):
            continue
        data = s.get_data()
        if not data or len(data) < 256:
            continue
        base_va = IMAGE_BASE + s.VirtualAddress
        for off in range(0, len(data) - 255, 64):
            window = data[off:off + 256]
            if len(set(window)) >= 200:
                print("  0x%x (%s) distinct=%d" % (base_va + off, name, len(set(window))))
                cnt += 1
                if cnt >= 30:
                    break
        if cnt >= 30:
            break

if __name__ == "__main__":
    main()
