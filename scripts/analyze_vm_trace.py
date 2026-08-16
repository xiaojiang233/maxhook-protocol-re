#!/usr/bin/env python3
"""离线分析 capture_maxhook_vm_trace 的截断翻译地址集合。

输入:  vm_trace_capture 目录 (capture_summary.json + vm_addrs_call*.txt)
输出:  静态指令混合报告 (stdout) + vm_analysis.json

静态特征:
  - AES 类(查表): movzx eax, byte ptr [reg+reg*1] 密集 + 大量 xor/shift
  - ChaCha/Salsa(ARX): add/xor/rol(rotate) 三组合密集, 无大表
  - 是否访问大表: lea 目标跨度 > 256B 的表基址

重要：旧捕获器在 Stalker transform(iterator) 中计数，因此 count 是
翻译/重翻译次数，不是执行频率。这里不能据 ARX 比例判定密码算法。
"""

from __future__ import annotations

import argparse
import json
import pathlib
import re
from collections import Counter

from capstone import Cs, CS_ARCH_X86, CS_MODE_64

LOOKUP_HINTS = ("byte ptr", "dword ptr", "qword ptr")
ARX = {"add", "xor", "rol", "ror", "shl", "shr"}
AES_ROUND = {"aesenc", "aesdec", "aesenclast", "aesdeclast", "aeskeygenassist"}
TABLE_MEM = re.compile(r"movzx \w+, (byte|word) ptr \[([^\]]+)\]")


def analyze_addrs_file(path: pathlib.Path, boot: bytes, bugland_base: int) -> dict:
    pairs = []
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line.startswith("0x"):
            continue
        try:
            if ":" in line:
                a, c = line.split(":")
                pairs.append((int(a, 16), int(c)))
            else:
                pairs.append((int(line, 16), 1))
        except ValueError:
            pass
    # count 是 transform 次数，不是执行频率；排序仅保持输入兼容。
    pairs.sort(key=lambda x: -x[1])
    addrs = [a for a, _ in pairs]
    counts = {a: c for a, c in pairs}
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    md.skipdata = True
    stats = Counter()
    table_reads = 0
    arx_count = 0
    mem_access = 0
    insns = []
    for a in addrs:
        off = a - bugland_base
        if not (0 <= off < len(boot)):
            continue
        dis = list(md.disasm(boot[off:off + 16], a, count=1))
        if not dis:
            continue
        insn = dis[0]
        stats[insn.mnemonic] += 1
        if insn.mnemonic in AES_ROUND:
            stats["__AES_NI__"] += 1
        if insn.mnemonic in ARX:
            arx_count += 1
        op = insn.op_str
        if any(h in op for h in LOOKUP_HINTS):
            mem_access += 1
        if TABLE_MEM.search(insn.op_str):
            table_reads += 1
        insns.append((a, insn.mnemonic, insn.op_str, counts.get(a, 1)))
    total = sum(stats.values())
    return {
        "unique_addrs": len(addrs),
        "total_insn_decoded": total,
        "mnemonic_top": stats.most_common(25),
        "arx_count": arx_count,
        "arx_ratio": round(arx_count / total, 3) if total else 0,
        "table_lookup_reads": table_reads,
        "mem_access_count": mem_access,
        "aes_ni": stats.get("__AES_NI__", 0),
        "sample_insns": insns[:60],
        "translation_count_ge_100": [
            (a, m, op, c) for a, m, op, c in insns if c >= 100
        ][:40],
    }


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("capture_dir", type=pathlib.Path)
    ap.add_argument("--bugland", type=pathlib.Path,
                    default=pathlib.Path(r"E:/Coding/S1mple/target/runtime_bugland2.bin"))
    ap.add_argument("--output", type=pathlib.Path, default=pathlib.Path("vm_analysis.json"))
    args = ap.parse_args()

    boot = args.bugland.read_bytes()
    summary = json.loads((args.capture_dir / "capture_summary.json").read_text(encoding="utf-8"))
    print(f"=== VM 翻译覆盖分析: {summary.get('trace_calls', 0)} 次加密调用 ===\n")
    results = []
    for s in summary.get("summaries", []):
        print(
            f"--- call {s.get('call_id')}: transform 指令实例 "
            f"{s.get('total_instructions')} 唯一地址 {s.get('unique_addresses')} ---"
        )
        print(f"  translated mnemonic Top: {s.get('top_mnemonics')}")
        af = s.get("addrs_file")
        if af and pathlib.Path(af).exists():
            r = analyze_addrs_file(pathlib.Path(af), boot, 0x180980000)
            results.append({"call_id": s.get("call_id"), **r})
            print(f"  [离线解码] 唯一可解码 {r['total_insn_decoded']}")
            print(f"  ARX(add/xor/rol...) 占比: {r['arx_ratio']} ({r['arx_count']})")
            print(f"  查表读取 (movzx [mem]): {r['table_lookup_reads']}")
            print(f"  内存访问: {r['mem_access_count']}  AES-NI: {r['aes_ni']}")
            print(f"  前 20 条指令:")
            for a, m, op, c in r["sample_insns"][:20]:
                print(f"    {a:#x}: {m:8s} {op}  [transform x{c}]")
        print()

    # 只能输出静态覆盖结论，不能从 transform 频率判定算法。
    if results:
        r0 = results[0]
        verdict = "截断翻译地址的静态指令混合；不能据此判定加密算法"
        print(f"=== 判定: {verdict} ===")
        (args.output).write_text(json.dumps({
            "schema": "maxhook.vm.translated-static-mix/v2",
            "verdict": verdict,
            "counter_semantics": "Stalker transform/retranslation count, not runtime hit count",
            "calls": results,
            "bugland_sha256": __import__("hashlib").sha256(boot).hexdigest()[:16],
        }, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(f"已写 {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
