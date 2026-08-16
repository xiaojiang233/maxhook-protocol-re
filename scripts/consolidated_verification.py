#!/usr/bin/env python3
"""MaxHook evidence audit.

This script deliberately distinguishes observed facts from an independent
end-to-end protocol reproduction. It must not report success for ciphertext or
tag generation until the reference implementation actually matches vectors.
"""
import importlib.util
import json
from pathlib import Path

T = Path(r"E:\Coding\S1mple\target")


def load_reference():
    spec = importlib.util.spec_from_file_location(
        "maxhook_protocol_reference", T / "maxhook_protocol_reference.py"
    )
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def main():
    proven = []
    unresolved = []

    verify = json.loads((T / "crypto_verify_set.json").read_text("utf-8"))
    samples = verify["samples"]

    layout_ok = sum(
        1 for s in samples
        if len(s["key_material_64hex"]) == 64
        and len(s["nonce_24hex"]) == 24
        and len(s["tag_32hex"]) == 32
        and len(s["kid"]) == 32
        and len(bytes.fromhex(s["ciphertext_hex"])) == len(s["plaintext"].encode())
    )
    proven.append(("envelope field lengths and ct/plaintext lengths", f"{layout_ok}/{len(samples)}"))

    # Observed stream-XOR relation: this derives a keystream; it does not prove F(key,nonce).
    entropy_ok = 0
    for s in samples:
        pt = s["plaintext"].encode()
        ct = bytes.fromhex(s["ciphertext_hex"])
        ks = bytes(a ^ b for a, b in zip(pt, ct))
        entropy_ok += len(set(ks[:32])) > 10
    proven.append(("observed ct = pt XOR recovered byte stream (nontrivial prefix)", f"{entropy_ok}/{len(samples)}"))

    trace = json.loads((T / "vm_handler_execution_trace.json").read_text("utf-8"))
    proven.append(("captured VM transition evidence", f"{len(trace)} transitions"))

    writer = json.loads((T / "writer_sync_clean_20260814_014351" / "analysis.json").read_text("utf-8"))
    writer_ok = sum(bool(c.get("all_blocks_equal_keystream")) for c in writer["calls"])
    proven.append(("store32 writer blocks equal pt XOR ct", f"{writer_ok}/{len(writer['calls'])}"))

    # Stack attachment audit: metadata exists but no bytes/file were saved.
    events = [json.loads(line) for line in (T / "vm_context_capture2" / "events.jsonl").read_text("utf-8").splitlines()]
    stack_events = [e for e in events if e.get("kind") == "vm_enter_stack"]
    stack_with_file = [e for e in stack_events if e.get("file") and (T / "vm_context_capture2" / e["file"]).is_file()]
    unresolved.append(("VM stack bytes attached to vm_enter_stack events", f"{len(stack_with_file)}/{len(stack_events)}"))

    # Every offline replay currently has no real store32 observation.
    replay_names = [
        "encrypt_vm_clean_complete.json",
        "encrypt_vm_seed_nonce.json",
        "encrypt_vm_fold_arith.json",
    ]
    replay_counts = {}
    for name in replay_names:
        d = json.loads((T / name).read_text("utf-8"))
        replay_counts[name] = len(d.get("store32_trace", []))
    unresolved.append(("offline replay store32 hits", json.dumps(replay_counts, sort_keys=True)))

    # SHA-256 evidence is presence/initialization only, not attribution to tag.
    clean = json.loads((T / "encrypt_vm_clean_complete.json").read_text("utf-8"))
    sha_iv = {
        0x6A09E667, 0xBB67AE85, 0x3C6EF372, 0xA54FF53A,
        0x510E527F, 0x9B05688C, 0x1F83D9AB, 0x5BE0CD19,
    }
    seen_iv = {
        int(w["value"], 16) & 0xFFFFFFFF
        for w in clean.get("heap_writes", [])
        if w.get("rip") == "0x18042b970"
    }
    proven.append(("standard SHA-256 IV initialization observed", f"{len(sha_iv & seen_iv)}/8"))
    unresolved.append(("SHA-256 attribution to envelope tag", "not proven"))

    # Reference must fail closed instead of emitting guessed crypto output.
    ref = load_reference()
    rejects = []
    for name, fn, args in [
        ("key_schedule_expand", ref.key_schedule_expand, (b"\0" * 32, b"\0" * 12)),
        ("fold", ref.fold, ([0] * 6,)),
        ("mac_tag", ref.mac_tag, (b"\0" * 32, b"\0" * 12, b"", ref.AAD)),
    ]:
        try:
            fn(*args)
            rejects.append((name, False))
        except NotImplementedError:
            rejects.append((name, True))
    proven.append(("reference fails closed for unresolved crypto", f"{sum(ok for _, ok in rejects)}/{len(rejects)}"))

    unresolved.append(("independent key+nonce -> keystream reproduction", "0/24"))
    unresolved.append(("independent tag reproduction", "0/24"))

    print("=" * 78)
    print("MaxHook evidence audit (not an end-to-end crypto verifier)")
    print("=" * 78)
    print("PROVEN / OBSERVED")
    for name, value in proven:
        print(f"  [OK] {name}: {value}")
    print("\nUNRESOLVED")
    for name, value in unresolved:
        print(f"  [--] {name}: {value}")
    print("=" * 78)
    print("END-TO-END STATUS: NOT REPRODUCED (ciphertext 0/24, tag 0/24)")


if __name__ == "__main__":
    main()
