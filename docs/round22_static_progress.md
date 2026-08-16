# Round 22 static progress

## Scope
Pure offline analysis only. No injection, packet capture, or live hooking. Formal implementation remains fail-closed.

## Confirmed SHA pipeline

Static disassembly of `MaxHook.runtime-unpacked.dll` confirms three distinct functions:

```text
0x18042B840  SHA context init
0x18042B9B0  SHA update(context=RCX, data=RDX, length=R8)
0x18042BB00  SHA finalize/padding
```

The init writes the standard SHA-256 IV into the 112-byte context (`+0x50` onward), as observed dynamically. The update loop reads `[RDX + offset]` and writes bytes into the context buffer. The finalize routine pads based on context `+0x40`, updates the length field at `+0x48`, dispatches the final compression, and extracts digest bytes through additional obfuscated table calls.

This proves the hash primitive and lifecycle, but not the tag message layout or digest-to-16-byte-output mapping.

## Function-table evidence

The three SHA function addresses are stored contiguously in the image table:

```text
[0x1807DDA20] = 0x18042B840
[0x1807DDA28] = 0x18042B9B0
[0x1807DDA30] = 0x18042BB00
```

This is direct static evidence that init/update/finalize are grouped as one SHA component. No direct `E8 rel32` callers exist because the VM invokes these through table/indirect dispatch.

## Replay status

No readable `tag_fast_r19_livecontinuation.json` was produced in the current workspace. Therefore round 20's replay is not treated as a successful run. Existing readable replays still show:

```text
HMAC KDF SHA events: 4 updates / 2 inits
Tag phase: SHA init reached
Tag phase: SHA update not reached
Tag finalize: not dynamically reached
```

The known continuation `0x181AC0A58` remains the only live-history-backed continuation; `0x181BF2ACB` is data/trap bytes and is rejected.

## Offline search status

Existing searches remain zero-hit:

```text
tag_digest_pad_search_report.json: 3,879,750 tests, 0 first-sample hits
tag_kdf_label_search_report.json: 27,004,080 tests, 0 first-sample hits
```

These cover SHA/HMAC/BLAKE2s/Poly1305/AES-CMAC variants, counter-derived materials, many labels, message layouts, and digest/pad combinations. They do not replace the missing dynamic SHA-update input evidence.

## Current completion

```text
ciphertext reproduction: 20/20 objective set (7/7 reference harness)
counter0 writer: 3/3
SHA domain KDF: recovered
Tag SHA init: reached
Tag SHA update input: missing
tag: 0/24
complete envelope: 0/24
```

`target/maxhook_protocol_reference.py` remains unchanged in its fail-closed `mac_tag()` implementation.
