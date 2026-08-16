import csv, os, struct, sys

dirp = r"E:\Coding\S1mple\target\dump_out\41264"
csvp = os.path.join(dirp, "regions.csv")

targets = [
    ("0x1c7aa206480", 0x1c7aa206480),
    ("0x1c7e0f7e75a", 0x1c7e0f7e75a),
    ("0x86dfff0f8",   0x86dfff0f8),
    ("0xc9d34ff410",  0xc9d34ff410),
    ("0x24d278e7680", 0x24d278e7680),
    # prefix-only probes (high 3 bytes as first 3 bytes of an 8-byte LE value)
    ("prefix 0x1c7 (bytes c7 01 00)", None),
    ("prefix 0x86d (bytes 6d 08 00)", None),
    ("prefix 0xc9  (bytes c9 00 00)", None),
    ("prefix 0x24d (bytes 4d 02 00)", None),
]

pat = {t[0]: struct.pack("<Q", t[1]) for t in targets if t[1] is not None}

# prefix byte patterns (LE 3-byte prefixes of high-address pointers, but pointers are
# stored LE so a pointer 0x1c7xxxxxxx appears as bytes ...07 0c 01 at end; instead
# we search the raw 3-byte "0x1c7" as it appears in high-order: 0x1c7 -> bytes c7 01 00)
prefix_pats = {
    "prefix 0x1c7": bytes([0xc7,0x01,0x00]),
    "prefix 0x86d": bytes([0x6d,0x08,0x00]),
    "prefix 0xc9":  bytes([0xc9,0x00,0x00]),
    "prefix 0x24d": bytes([0x4d,0x02,0x00]),
}

# Load regions
rows = list(csv.DictReader(open(csvp, newline="")))

def scan_file(path, base, needles, out):
    try:
        data = open(path, "rb").read()
    except Exception as e:
        return
    for name, nb in needles.items():
        idx = data.find(nb)
        if idx >= 0:
            absv = base + idx
            out.setdefault(name, []).append((path, idx, absv))

# Decide scope: scan ALL regions but streaming
results = {}
for r in rows:
    b = int(r["base"], 16)
    fname = r["file"]
    p = os.path.join(dirp, fname)
    if not os.path.exists(p):
        continue
    scan_file(p, b, pat, results)
    scan_file(p, b, prefix_pats, results)

for name in list(pat.keys()) + list(prefix_pats.keys()):
    hits = results.get(name, [])
    print(f"{name}: {len(hits)} hit(s)")
    for path, idx, absv in hits[:20]:
        print(f"    {os.path.basename(path)} +0x{idx:X} -> abs 0x{absv:X}")
    if len(hits) > 20:
        print(f"    ... and {len(hits)-20} more")
