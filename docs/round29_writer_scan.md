# Round 29: writer-table target scan

## Result

The table at `0x180715060` contains image-local function pointers. A scan of the first 0x1000 entries found 0xB9 image-local targets and disassembled their first instructions looking for direct 16-byte stores.

Representative targets include:

```asm
0x1800381F0  movups [rcx], xmm0; mov qword [rcx+0x10], 0; ret
0x1800D7E80  movups xmm0, [rdx]; movups [rcx], xmm0; ret
0x180043540  mov qword [rcx], rdx; mov qword [rcx+8], rdx; mov qword [rcx+0x10], r8; ret
0x1800C4690  mov qword [rcx], rdx; mov qword [rcx+8], r8; mov qword [rcx+0x10], r9; ret
```

These are generic object/field helpers. The table also contains many scalar setters, zero initializers, and obfuscated longer helpers. The actual writer index at `0x1800C28A2` is computed at runtime from data-dependent `RDX`; no captured tag-phase dynamic index is available.

## Consequence

Static table scanning does not identify a unique tag writer or connect it to SHA digest bytes. In particular, there is no evidence sufficient to install `digest[:16]`, `digest[16:]`, or another truncation into `mac_tag()`.

The 16-byte `object+0x60` field remains proven as an output slot, but its producer is unresolved.

## Status

```text
ciphertext: 20/20
counter0 writer: 3/3
SHA KDF: recovered
tag SHA init: reached
tag SHA update: missing
tag SHA finalize: missing for tag context
tag: 0/24
complete envelope: 0/24
```

Formal implementation remains fail-closed.
