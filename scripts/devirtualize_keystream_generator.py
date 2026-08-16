#!/usr/bin/env python3
"""
Static/dynamic offline devirtualizer for the MaxHook 1024-block keystream
generator trace.

Inputs (all local, no live interaction):
  - target/keystream_history_capture_20260814/  (52 history/context snapshots)
  - target/MaxHook.runtime-unpacked.dll         (PE, for disassembly)
  - target/writer_sync_clean_20260814_014351/   (writer oracle + analysis.json)
  - prior VM dispatch analysis (milestones 06/13/17/26/27/28)

Outputs a structured JSON report separating, for the repeated generator
trace, the VM bookkeeping from the cipher data operations, and proposes the
recoverable "actual data operations" chain.

Method
------
1. Identify the STABLE COMMON SUFFIX of the 1024-entry basic-block histories.
   This suffix is byte-for-byte identical across all 52 snapshots / 3 calls,
   so it is the loop body + dispatch tail that repeats every 64-byte block.

2. Classify the VM context (0x300 bytes @ 0x18098c884) into:
     CONSTANT        -> pointers, handler table, flags (bookkeeping)
     POSITION-DERIVED-> changes with xor_index but not nonce (counter state)
     MIXED           -> changes with both (live state)
   There are 0 NONCE-DERIVED bytes at the XOR point: the nonce has already
   been fully absorbed into the position-dependent stream state by the time
   the XOR executes, so the keystream state lives in the heap `source` buffer
   (r12) and the destination slots, not in a static context region.

3. Recover the actual data operations from the writer oracle + XOR site:
     (key, nonce, block_index) -> 32-bit keystream word (EDX)
       -> 0x18041a860 store_le32 -> 64-byte keystream buffer
       -> 0x1809c5561 xor byte [r8], r12b  (r12b=plaintext, [r8]=keystream)
       -> ciphertext
   The writer values already reconstruct the true keystream (analysis.json
   all_blocks_equal_keystream=true).

4. Disassemble the 124-block suffix and tag each block as:
     dispatch/stub        (jmp into handler table)
     handler arithmetic   (the cipher round: xor/add/and/or/shift on state)
     generator-loop body  (0x18099089e -> 0x180990a93 -> 0x180990b21)
     output/write         (store32 / byte-xor)
"""
from __future__ import annotations
import json, sys, hashlib, struct
from pathlib import Path
from collections import Counter, defaultdict

sys.path.insert(0, str(Path(r"E:\Coding\S1mple\target\.pydeps")))
from capstone import CS_ARCH_X86, CS_MODE_64, Cs

CAPTURE = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")
DLL = Path(r"E:\Coding\S1mple\target\MaxHook.runtime-unpacked.dll")
WRITER_ANALYSIS = Path(r"E:\Coding\S1mple\target\writer_sync_clean_20260814_014351\analysis.json")
CTX_BASE = 0x18098C884
IMAGE_BASE = 0x180000000

# Handler table entries already recovered (milestones 06/17/27)
HANDLER_TABLE = {
    0x147: ("dispatch#1 (unkeyed)", "0x1809ac48d", "0x1809f4736"),
    0x321: ("dispatch#2", "0x180981ac9", "0x1809da384"),
    0x05d: ("dispatch#3 (init)", "0x18098257f", "0x1809bfebb"),
    0x0e0: ("dispatch#4 (keyed)", "0x1809a3b86", "0x180a02a99"),
}
# Key code addresses identified in this analysis:
GENERATOR_LOOP = [0x18099089E, 0x180990A93, 0x180990B21]
XOR_SITE = 0x1809C5561
STORE32 = 0x18041A860
TRAMPOLINE = 0x180C2775C


def parse_sections(blob):
    pe = blob
    e_lfanew = struct.unpack_from("<I", pe, 0x3C)[0]
    num = struct.unpack_from("<H", pe, e_lfanew + 6)[0]
    opt_size = struct.unpack_from("<H", pe, e_lfanew + 20)[0]
    sec_off = e_lfanew + 24 + opt_size
    sections = []
    for i in range(num):
        o = sec_off + i * 40
        name = pe[o:o+8].rstrip(b"\x00").decode("latin1")
        vsize = struct.unpack_from("<I", pe, o + 8)[0]
        vaddr = struct.unpack_from("<I", pe, o + 12)[0]
        rsize = struct.unpack_from("<I", pe, o + 16)[0]
        roff = struct.unpack_from("<I", pe, o + 20)[0]
        sections.append((name, vaddr, vsize, roff, rsize))
    return sections


def rva_to_off(rva, sections):
    for name, vaddr, vsize, roff, rsize in sections:
        if vaddr <= rva < vaddr + max(vsize, rsize):
            return roff + (rva - vaddr)
    return None


def disasm(blob, sections, va, count=4):
    off = rva_to_off(va - IMAGE_BASE, sections)
    if off is None:
        return []
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    md.detail = True
    return list(md.disasm(blob[off:off + count * 15], va))


def load_snapshots():
    snaps = []
    for f in sorted(CAPTURE.glob("*.bin")):
        j = json.loads(f.read_text())
        j["_file"] = f.name
        j["call"] = int(f.name.split("_call_")[1].split("_")[0])
        j["ctx"] = bytes.fromhex(j["context_hex"])
        snaps.append(j)
    return snaps


def classify_context(snaps):
    by_call = defaultdict(list)
    for s in snaps:
        by_call[s["call"]].append(s)
    classes = {}
    for off in range(0x300):
        global_stable = len({s["ctx"][off] for s in snaps}) == 1
        within = {c: len({s["ctx"][off] for s in ss}) == 1 for c, ss in by_call.items()}
        within_stable = all(within.values())
        reps = {c: Counter(s["ctx"][off] for s in ss).most_common(1)[0][0]
                for c, ss in by_call.items()}
        cross_stable = len(set(reps.values())) == 1
        if global_stable:
            cls = "CONSTANT"
        elif within_stable and not cross_stable:
            cls = "NONCE-DERIVED"
        elif cross_stable and not within_stable:
            cls = "POSITION-DERIVED"
        else:
            cls = "MIXED"
        classes[off] = cls
    return classes


def block_class(va, blob, sections):
    """Classify a basic-block start address."""
    insns = disasm(blob, sections, va, count=2)
    if not insns:
        return "unmapped"
    first = insns[0]
    if first.mnemonic == "jmp":
        # stub / dispatch tail -> jmp into handler
        return "dispatch-stub"
    if va in GENERATOR_LOOP:
        return "generator-loop"
    # arithmetic-heavy block = cipher semantics; pointer setup = bookkeeping
    mnem = first.mnemonic
    op = first.op_str
    if mnem in ("xor", "add", "sub", "and", "or", "shl", "shr", "rol", "ror", "not", "neg"):
        return "cipher-arithmetic"
    if mnem == "mov":
        return "setup/move"
    if mnem == "push":
        return "stack"
    return f"other:{mnem}"


def main():
    snaps = load_snapshots()
    suffix = snaps[0]["history"][-124:]
    for s in snaps[1:]:
        assert s["history"][-124:] == suffix, s["_file"]

    blob = DLL.read_bytes()
    sections = parse_sections(blob)
    classes = classify_context(snaps)

    # count context classes
    cc = Counter(classes.values())
    nonce_off = [o for o in range(0x300) if classes[o] == "NONCE-DERIVED"]
    mixed_off = [o for o in range(0x300) if classes[o] == "MIXED"]

    # disassemble and classify the suffix
    suffix_blocks = []
    for i, va_s in enumerate(suffix):
        va = int(va_s, 16)
        insns = disasm(blob, sections, va, count=3)
        txt = [f"{x.mnemonic} {x.op_str}" for x in insns[:2]]
        cls = block_class(va, blob, sections)
        suffix_blocks.append({
            "depth_from_tail": i + 1,
            "address": va_s,
            "class": cls,
            "first_insns": txt,
        })

    # group suffix into contiguous class runs
    runs = []
    cur = None
    start = None
    for b in suffix_blocks:
        c = b["class"]
        if c != cur:
            if cur is not None:
                runs.append((start, b["depth_from_tail"] - 1, cur))
            cur = c
            start = b["depth_from_tail"]
    runs.append((start, suffix_blocks[-1]["depth_from_tail"], cur))

    # writer oracle summary
    writer = json.loads(WRITER_ANALYSIS.read_text())
    writer_summary = []
    for c in writer["calls"]:
        writer_summary.append({
            "call_id": c["call_id"],
            "plaintext_bytes": c["plaintext_bytes"],
            "writer_records": c["writer_records"],
            "discarded_leading_records": c["discarded_leading_records"],
            "blocks": len(c["blocks"]),
            "all_blocks_equal_keystream": c["all_blocks_equal_keystream"],
        })

    # XOR site semantics
    xor_insns = disasm(blob, sections, XOR_SITE, count=3)
    store_insns = disasm(blob, sections, STORE32, count=2)

    report = {
        "schema": "maxhook.devirtualizer/v1",
        "scope": "repeated 1024-block keystream generator trace (offline)",
        "inputs": {
            "snapshots": len(snaps),
            "calls": sorted(set(s["call"] for s in snaps)),
            "history_length": len(suffix),
            "common_suffix_length": len(suffix),
            "dll_sha256": hashlib.sha256(blob).hexdigest(),
        },
        "stable_common_suffix": {
            "note": ("The last 124 basic-block start addresses of the 1024-entry "
                     "history ring are IDENTICAL across all 52 snapshots and all 3 "
                     "calls. This is the per-block generator loop tail: it repeats "
                     "once per 64-byte keystream block."),
            "blocks": suffix,
            "class_runs": [{"depth_from_tail": a, "depth_to_tail": b, "class": c}
                           for a, b, c in runs],
        },
        "context_classification": {
            "base": hex(CTX_BASE),
            "size": 0x300,
            "counts": dict(cc),
            "nonce_derived_offsets": nonce_off,
            "mixed_offsets": mixed_off,
            "interpretation": (
                "0 NONCE-DERIVED bytes: at the XOR point the nonce has already been "
                "fully mixed into position-dependent stream state. The context is "
                "dominated by CONSTANT bytes (pointers to heap buffers, the handler "
                "table 0x180c64ebd, flags) and POSITION-DERIVED bytes (rolling key "
                "@+0x0a, VIP @+0x6d, and the 64-byte destination slots @+0xb5/+0x235 "
                "which hold the keystream byte being XORed)."),
            "key_fields": {
                "+0x0a": "rolling key (dword) - POSITION-DERIVED",
                "+0x6d": "VIP (qword) - POSITION-DERIVED",
                "+0x85": "handler table 0x180c64ebd - CONSTANT",
                "+0xb5": "destination slot A (keystream byte) - the XOR target",
                "+0x235": "destination slot B (keystream byte) - the XOR target",
                "+0x61": "runtime key-schedule pointer (milestone 28)",
                "+0xc5": "runtime keystream-source pointer (milestone 28)",
            },
        },
        "recovered_data_operations": {
            "chain": [
                "VM word generator -> EDX (32-bit true keystream word)",
                "0x180c2775c popfq; ret trampoline",
                "0x18041a860 store_le32(RCX=dest, EDX=keystream word)",
                "64-byte keystream buffer",
                "0x180aa5bba per-byte load",
                "destination slot 0x18098c939 / 0x18098cab9 (context +0xb5/+0x235)",
                "0x1809c5561 xor byte [r8], r12b   (r12b=plaintext, [r8]=keystream)",
                "ciphertext",
            ],
            "xor_site": {
                "address": hex(XOR_SITE),
                "semantics": "xor byte ptr [r8], r12b",
                "r12": "plaintext byte pointer (r12b = plaintext byte)",
                "r8": "destination context slot (pre-loaded with keystream byte)",
                "before": "[r8] = keystream byte",
                "after": "[r8] = ciphertext byte",
                "disasm": [f"{x.mnemonic} {x.op_str}" for x in xor_insns],
            },
            "store32": {
                "address": hex(STORE32),
                "semantics": "little-endian store of a 32-bit keystream word",
                "disasm": [f"{x.mnemonic} {x.op_str}" for x in store_insns],
            },
            "writer_oracle": writer_summary,
        },
        "bookkeeping_vs_cipher": {
            "bookkeeping": [
                "handler table pointer @+0x85 (constant 0x180c64ebd)",
                "VIP @+0x6d (advances every dispatch, not cipher state)",
                "rolling key @+0x0a (dispatch-index mixing, not keystream output)",
                "heap object pointers (plaintext/key/output std::string objects)",
                "dispatch stubs (jmp into handler table entries)",
            ],
            "cipher_semantics": [
                "destination slots @+0xb5 / @+0x235: hold the keystream byte",
                "handler arithmetic (xor/add/and/or/rotate) over context state",
                "generator loop 0x18099089e->0x180990a93->0x180990b21",
                "store32 0x18041a860 writing final keystream words",
                "xor 0x1809c5561 combining keystream with plaintext",
                "key-schedule pointers @+0x61 / @+0xc5 (runtime-only state)",
            ],
        },
        "limitations": [
            "The actual (key, nonce, block_index) -> 16 keystream words mapping "
            "is NOT recovered: the key-schedule state at context+0x61/+0xc5 is "
            "runtime-only (milestone 28) and absent from the offline dump.",
            "This devirtualizer recovers the DATA OPERATIONS (which slots hold "
            "keystream, where it is stored, where XORed) but not the round "
            "function that produces the keystream words.",
            "No live attach was performed; all analysis is offline.",
        ],
    }

    out = Path(r"E:\Coding\S1mple\target\maxhook_devirtualizer_report.json")
    out.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(f"wrote {out.resolve()}")

    # concise console summary
    print("\n=== SUMMARY ===")
    print(f"snapshots={len(snaps)} calls={sorted(set(s['call'] for s in snaps))}")
    print(f"stable common suffix = {len(suffix)} blocks (identical across all snapshots)")
    print(f"context: {dict(cc)}")
    print(f"  nonce-derived offsets: {len(nonce_off)}, mixed offsets: {len(mixed_off)}")
    print("suffix class runs (depth from tail):")
    for a, b, c in runs:
        print(f"  [-{b:3d} .. -{a:3d}] {c}")


if __name__ == "__main__":
    main()
