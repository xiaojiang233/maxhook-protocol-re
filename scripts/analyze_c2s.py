# -*- coding: utf-8 -*-
import zlib, json, os, re
P = r"E:/Coding/S1mple/target/payload2"
def try_zlib(data):
    for off in (0, 1, 5):
        try:
            return off, zlib.decompress(data[off:])
        except Exception:
            pass
    return None, None
def walk(obj, d=0):
    lines = []
    if isinstance(obj, dict):
        for k, v in list(obj.items())[:25]:
            if isinstance(v, (dict, list)):
                lines.append("  "*d + f"{k}: ({type(v).__name__})")
                lines.extend(walk(v, d+1))
            else:
                vs = str(v)
                lines.append("  "*d + f"{k}: {vs[:100]}")
    elif isinstance(obj, list):
        lines.append("  "*d + f"[list {len(obj)}]")
        for i, v in enumerate(obj[:4]):
            if isinstance(v, (dict, list)):
                lines.extend(walk(v, d+1))
            else:
                lines.append("  "*d + f" [{i}] {str(v)[:80]}")
    return lines
for fn in sorted(os.listdir(P)):
    data = open(os.path.join(P, fn), 'rb').read()
    print("="*60)
    print(f"### {fn} ({len(data)}B)")
    print("hex:", ' '.join(f"{b:02x}" for b in data[:24]))
    off, dec = try_zlib(data)
    if dec:
        print(f"zlib@{off} -> {len(dec)}B: {dec[:150]}")
        try:
            j = json.loads(dec)
            for l in walk(j)[:40]:
                print("  ", l)
        except Exception:
            pass
    else:
        print("raw:", ''.join(chr(b) if 0x20 <= b < 0x7f else '.' for b in data[:100]))
