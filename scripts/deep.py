# -*- coding: utf-8 -*-
import zlib, gzip, json, os, re, io

P = r"E:/Coding/S1mple/target/payload"

# 1. floodgate_netease gzip 解压
print("### floodgate_netease 解压")
for fn in ["floodgate_netease_0.bin", "floodgate_netease_1.bin"]:
    data = open(os.path.join(P, fn), 'rb').read()
    try:
        dec = gzip.decompress(data)
        print(fn, len(data), "->", len(dec), "bytes")
        print("  hex:", ' '.join(f"{b:02x}" for b in dec[:64]))
        print("  ascii:", ''.join(chr(b) if 0x20 <= b < 0x7f else '.' for b in dec[:120]))
        # 再试内层 zlib
        for off in (0, 1, 4):
            try:
                d2 = zlib.decompress(dec[off:])
                print(f"  inner zlib@{off}:", len(d2), d2[:200])
                break
            except Exception:
                pass
        try:
            j = json.loads(dec)
            print("  JSON:", str(j)[:300])
        except Exception:
            pass
    except Exception as e:
        print(fn, "gzip fail:", e)

# 2. s2cevent 大 config 的关键字段
print("\n### s2cevent config 顶层结构")
data = open(os.path.join(P, "heypixel_s2cevent_0.bin"), 'rb').read()
dec = zlib.decompress(data[5:])
j = json.loads(dec)
print("top keys:", list(j.keys()))
print("configs 数量:", len(j.get("configs", {})))
print("enabled 数量:", len(j.get("enabled", {})))
# configs 里第一个的完整结构
first = list(j.get("configs", {}).items())[0]
print("config 示例:", json.dumps(first[1], ensure_ascii=False)[:400])
# 找有没有协议/version/握手字段
for k in j:
    if any(w in k.lower() for w in ["proto", "version", "hand", "auth", "token", "key"]):
        print("关键字段:", k, "=", str(j[k])[:200])
