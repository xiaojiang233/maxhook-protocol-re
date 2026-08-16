# -*- coding: utf-8 -*-
"""解析布吉岛 heypixel/floodgate payload bin"""
import zlib, gzip, json, os, re, struct, binascii

PAYLOAD_DIR = r"E:/Coding/S1mple/target/payload"

def hex_dump(data, n=48):
    return ' '.join(f"{b:02x}" for b in data[:n])

def ascii_str(data, n=400):
    s = ''.join(chr(b) if 0x20 <= b < 0x7f else '.' for b in data[:n])
    return s

def try_zlib(data):
    for offset in (0, 1, 5):
        try:
            d = zlib.decompress(data[offset:])
            return offset, d
        except Exception:
            pass
    return None, None

def try_json(data):
    try:
        return json.loads(data)
    except Exception:
        return None

def walk_json(obj, depth=0, max_depth=6):
    lines = []
    if isinstance(obj, dict):
        for k, v in list(obj.items())[:40]:
            if isinstance(v, (dict, list)):
                lines.append("  "*depth + f"{k}: ({type(v).__name__})")
                lines.extend(walk_json(v, depth+1, max_depth))
            else:
                vs = str(v)
                if len(vs) > 120: vs = vs[:120] + "..."
                lines.append("  "*depth + f"{k}: {vs}")
    elif isinstance(obj, list):
        lines.append("  "*depth + f"[list len={len(obj)}]")
        for i, v in enumerate(obj[:5]):
            if isinstance(v, (dict, list)):
                lines.extend(walk_json(v, depth+1, max_depth))
            else:
                lines.append("  "*depth + f"  [{i}]: {str(v)[:100]}")
    return lines

for fn in sorted(os.listdir(PAYLOAD_DIR)):
    path = os.path.join(PAYLOAD_DIR, fn)
    data = open(path, 'rb').read()
    print("="*70)
    print(f"### {fn} ({len(data)} bytes)")
    print("hex:", hex_dump(data))
    print("ascii:", ascii_str(data)[:200])
    # zlib 尝试
    off, dec = try_zlib(data)
    if dec:
        print(f"[zlib @{off}] decoded {len(dec)} bytes, hex: {hex_dump(dec, 32)}")
        print("  ascii:", ascii_str(dec)[:300])
        j = try_json(dec)
        if j:
            print("  JSON structure:")
            for line in walk_json(j)[:60]:
                print("   ", line)
        else:
            # 可能 protobuf 或自定义二进制，找可读串
            strs = re.findall(rb'[\x20-\x7e]{4,}', dec)
            print("  strings:", [s.decode(errors='replace')[:80] for s in strs[:15]])
    else:
        j = try_json(data)
        if j:
            print("  JSON structure:")
            for line in walk_json(j)[:40]:
                print("   ", line)
        else:
            strs = re.findall(rb'[\x20-\x7e]{4,}', data)
            print("  strings:", [s.decode(errors='replace')[:80] for s in strs[:12]])
