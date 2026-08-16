# Round 28: indirect `+0x60` writer dispatch

## Static resolution

The helper near `0x1800C2710` computes a dispatch index and calls:

```asm
0x1800c2788  lea r14, [rip + 0x6528d1]
               ; r14 = 0x180715060
0x1800c2890  lea rax, [rsi + 0x60]
0x1800c289f  mov rcx, rax
0x1800c28a2  call qword ptr [r14 + rdx*8]
```

The table at `0x180715060` is an image function-pointer table. Its first entries are valid module functions, and static scans resolve known local helper entries:

```text
index 0x0b1 (177) -> 0x1800C2410
index 0x387 (903) -> 0x1800C2710
index 0x3E6 (998) -> 0x1800C25E0
```

The actual `+0x60` writer index is data-dependent (`RDX` at `0x1800C28A2`) and is not a fixed table entry in the on-disk image. No SHA function (`0x18042B840`, `0x18042B9B0`, `0x18042BB00`) appears in this table scan, so the local static evidence does not connect this writer directly to SHA init/update/finalize.

## Object layout evidence

The same helper explicitly initializes:

```asm
movups [rsi+0x20], xmm0
movups [rsi+0x30], xmm0
movups [rsi+0x40], xmm0
movups [rsi+0x50], xmm0
movups [rsi+0x60], xmm0
movups [rsi+0x70], xmm0
movups [rsi+0x80], xmm0
```

and later passes `rsi+0x60` as the destination to an obfuscated writer. This is direct evidence for the 16-byte output field, but not for its byte source.

## No speculative vector test

Because the writer index and target are runtime-data-dependent, no SHA truncation or digest-to-tag candidate is justified by this round. `mac_tag()` remains fail-closed.

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
