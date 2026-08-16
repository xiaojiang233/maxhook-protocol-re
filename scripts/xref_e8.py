import sys, os, struct

base = r"E:\Coding\S1mple\target"
sys.path.insert(0, os.path.join(base, ".pydeps"))

import pefile

dll = os.path.join(base, "MaxHook.runtime-unpacked.dll")
pe = pefile.PE(dll, fast_load=True)
image_base = pe.OPTIONAL_HEADER.ImageBase

data = open(dll, "rb").read()

sections = []
for s in pe.sections:
    name = s.Name.rstrip(b'\x00').decode('latin1')
    va = image_base + s.VirtualAddress
    vsize = s.Misc_VirtualSize
    raw = s.PointerToRawData
    rsize = s.SizeOfRawData
    sections.append((name, va, vsize, raw, rsize))

# locate .text
text = [s for s in sections if s[0] == '.text'][0]
name, text_va, text_vsize, text_raw, text_rsize = text
code = data[text_raw : text_raw + text_rsize]

# Scan for E8 (call rel32) and find all call targets.
# This is a raw byte scan: E8 disp32 -> target = (addr + 5 + disp32) & 0xffffffff
targets = {
    0x5d0b10: "memcpy_entry (0x5d0b10)",
    0x5d0b00: "rep_movsb_fallback (0x5d0b00)",
    0x5d10a0: "memmove_backward (0x5d10a0)",
    0x5d11b0: "memset_entry (0x5d11b0)",
    0x5d11a0: "rep_stosb_fallback (0x5d11a0)",
    0x5d0a10: "memcmp_entry (0x5d0a10)",
}

found = {k: [] for k in targets}

i = 0
n = len(code)
while i < n - 5:
    b = code[i]
    if b == 0xE8:
        disp = struct.unpack_from('<i', code, i+1)[0]
        ins_addr = text_va + i
        tgt = (ins_addr + 5 + disp) & 0xFFFFFFFFFFFFFFFF
        rva = tgt - image_base
        if rva in targets:
            found[rva].append(ins_addr)
    i += 1

print("Raw E8 scan over .text (bytes 0x%x):" % text_rsize)
for rva, label in targets.items():
    xs = found[rva]
    print(f"\n{label}: {len(xs)} call site(s)")
    for a in xs:
        print(f"    call site VA 0x{a:x}  RVA 0x{a-image_base:x}")

# Also scan whole file (all sections) for E8 targeting these, in case callers live in .boot/.bugland
print("\n\n=== Full-file E8 scan (all sections) ===")
for rva, label in targets.items():
    xs = []
    for name, va, vsize, raw, rsize in sections:
        seg = data[raw:raw+rsize]
        i = 0
        while i < len(seg) - 5:
            if seg[i] == 0xE8:
                disp = struct.unpack_from('<i', seg, i+1)[0]
                ins_addr = va + i
                tgt = (ins_addr + 5 + disp) & 0xFFFFFFFFFFFFFFFF
                if tgt - image_base == rva:
                    xs.append(ins_addr)
            i += 1
    print(f"{label}: {len(xs)} call site(s)")
    for a in xs:
        print(f"    call site VA 0x{a:x}  RVA 0x{a-image_base:x}")
