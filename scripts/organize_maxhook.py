#!/usr/bin/env python3
"""Organize MaxHook reverse-engineering artifacts into a clean repo layout.
Plan documented in MaxHookRe/_bigdata/organize_plan.md.
Usage: python organize_maxhook.py --plan-only   (dry run: write manifests, no file ops)
       python organize_maxhook.py --apply       (do the moves/copies)
"""
import os, shutil, json, sys
from pathlib import Path

SRC = Path(r"E:\Coding\S1mple\target")
DST = Path(r"E:\Coding\MaxHookRe")

# Directories never migrated (build/unrelated/venv/git junk)
SKIP_DIRS = {
    "unlicense_env", "unlicense_repo", ".pydeps", "__pycache__", "scripts",
    "classes", "test-classes", "generated-sources", "generated-test-sources",
    "maven-status", "surefire-reports", "maven-archiver", "reports", "payload",
    "payload2", "symbols", "monitor_out", "nonce_candidate_sweep", "etw_out",
    "vm_trace_capture", "vm_trace_capture2", "vm_trace_capture3", "vm_trace_capture4",
    "keystream_buffer_writes_manual_20260814_012111",
    "writer_calls_manual_20260814_013014",
    "writer_calls_v2_manual_20260814_013526",
    "block_generator_manual_20260814_012601",
}
# Capture dirs that are kept (real captures, not scratch)
KEEP_CAPTURE_DIRS = {
    "encrypt_boundary_capture2", "encrypt_boundary_capture",
    "keystream_history_capture_20260814", "crypto_capture", "crypto_capture2",
    "keyread_capture", "keystream_buffer_writes_capture_20260814",
    "keystream_buffer_writes_capture_20260814_run2",
    "keystream_source_capture_20260814", "keystream_slot_changes_capture_20260814",
    "rot_capture_20260814", "rot_tail_capture_20260814",
    "plaintext_chain_capture_20260814", "plaintext_chain_stalker_capture_20260814",
    "plaintext_chain_stalker_v2_capture_20260814", "plaintext_xor_capture_20260814",
    "input_access_capture_20260814_run2", "strfn_capture", "vm_context_capture",
    "vm_context_capture2", "writer_sync_clean_20260814_014351",
}

# All emulator/VM trace JSON prefixes -> always delete (re-generatable)
# EXCEPT tag_fast_* final replays which document current progress evidence.
TRACE_PREFIXES = ("encrypt_vm_","diff_","tag_attempt_","boundary_call2_","async_")

def classify(file: Path):
    name = file.name
    ext = file.suffix.lower()
    size = file.stat().st_size
    # all emulator trace JSON -> delete regardless of size (re-generatable)
    if ext == ".json" and name.startswith(TRACE_PREFIXES):
        return "delete", None
    # remote log 169MB -> delete
    if name == "remote-log-3h.txt":
        return "delete", None
    # zero byte -> delete
    if size == 0:
        return "delete", None
    # scratch intermediate outputs -> delete
    if name.startswith(("p2_","sp1_","pf_","pf2_","tsc","tbl","env2_out","replay_4160000_onward",
                        "terminal_ret","terminal_return","zd_out","rp1","p2f","p2r","p2d",
                        "p2api","p2om","p2pf","p2rt","p2vs","p2rl")) and ext in (".txt",):
        return "delete", None
    # binaries
    if ext in (".dll",):
        return "binaries", None
    if ext == ".bin":
        return "binaries", None
    if ext == ".jar":
        return "delete", None   # build artifacts, keep original jar? -> delete junk
    # docs
    if ext in (".md", ".html", ".txt"):
        # large disasm -> raw
        if name in ("disasm_unpacked.asm","disasm_text.asm"):
            return "raw", None
        if ext == ".txt":
            return "raw", None
        return "docs", None
    # scripts
    if ext in (".py", ".js"):
        return "scripts", None
    # asm / json
    if ext == ".asm":
        return "raw", None
    if ext == ".json":
        # verification & tag test vectors
        if any(k in name for k in ("crypto_verify_set","tag_test_vectors","tag_","poly1305","sha256_tag",
                                   "sha256_counter0","tag_digest","tag_kdf","replay_generator",
                                   "chain_walk","dispatch_layout","vm_analysis","maxhook_vm",
                                   "maxhook_winhttp","maxhook_url","round_function","keyschedule_arx",
                                   "process_modules","bootstrap_probe","handler_execution","ret_trampoline",
                                   "same_instance","offline_key","stable_fixups","writer_sync","vm_bytecode",
                                   "vm_cipher","maxhook_protocol")):
            return "verification", None
        # small analysis json
        if size < 20*1024*1024:
            return "analysis", None
        return "delete", None
    # unknown small
    if size < 20*1024*1024:
        return "analysis", None
    return "delete", None

def main():
    plan_only = "--plan-only" in sys.argv
    apply = "--apply" in sys.argv
    moved = []
    deleted = []
    skipped = []
    kept_capture_dirs = []
    # top-level files
    for f in sorted(SRC.iterdir()):
        if f.is_file():
            cat, sub = classify(f)
            if cat == "delete":
                deleted.append(str(f))
            else:
                subdir = {"binaries":"binaries","docs":"docs","scripts":"scripts",
                          "verification":"verification","analysis":"analysis","raw":"raw"}.get(cat,"analysis")
                moved.append((str(f), subdir))
    # capture dirs
    for d in sorted(SRC.iterdir()):
        if d.is_dir():
            if d.name in SKIP_DIRS:
                skipped.append(str(d))
            elif d.name in KEEP_CAPTURE_DIRS:
                kept_capture_dirs.append((str(d), "captures"))
            elif d.name == "target":  # nested target -> captures (native/pss live)
                kept_capture_dirs.append((str(d), "captures"))
    # write manifests
    Path(DST / "_bigdata").mkdir(exist_ok=True)
    (DST / "_bigdata" / "plan_move.json").write_text(json.dumps({
        "files": moved, "capture_dirs": kept_capture_dirs}, indent=2))
    (DST / "_bigdata" / "plan_delete.json").write_text(json.dumps(deleted, indent=2))
    (DST / "_bigdata" / "plan_skip.json").write_text(json.dumps(skipped, indent=2))
    total_keep = sum(os.path.getsize(x) for x, _ in moved) + sum(
        sum(os.path.getsize(os.path.join(d,f)) for f in os.listdir(d) if os.path.isfile(os.path.join(d,f)))
        for d,_ in kept_capture_dirs)
    total_del = sum(os.path.getsize(x) for x in deleted) if deleted else 0
    print(f"plan_only={plan_only} apply={apply}")
    print(f"  files to move: {len(moved)}  ({total_keep/1024/1024:.1f} MB)")
    print(f"  capture dirs to move: {len(kept_capture_dirs)}")
    print(f"  files to delete: {len(deleted)}  ({total_del/1024/1024:.1f} MB)")
    print(f"  dirs skipped: {len(skipped)}")
    if apply:
        for src, sub in moved:
            dst = DST / sub / os.path.basename(src)
            dst.parent.mkdir(parents=True, exist_ok=True)
            try:
                shutil.move(src, dst)
            except Exception as e:
                print("ERR", src, e)
        for src, sub in kept_capture_dirs:
            dst = DST / sub / os.path.basename(src)
            dst.parent.mkdir(parents=True, exist_ok=True)
            try:
                shutil.move(src, dst)
            except Exception as e:
                print("ERR", src, e)
        for src in deleted:
            try:
                os.remove(src)
            except Exception as e:
                print("ERR del", src, e)
        print("APPLY done")

if __name__ == "__main__":
    main()
