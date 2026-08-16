# Round 27: output-field static path

## Current replay artifact

No `tag_fast_r25_finalize.json` exists in the workspace. The latest readable seeded replay remains `tag_fast_r19_livecontinuation.json`; it has tag SHA init but no post-nonce SHA update/finalize event.

## New static evidence: a 16-byte field at `+0x60` is explicitly handled by the report/envelope object helpers

The disassembly around `0x1800C2410` contains a helper which receives an object in `RSI` and prepares several fields. In its successor/helper path:

```asm
0x1800c2682  mov rcx, rsi
0x1800c2685  mov rdx, rax
0x1800c2688  call qword ptr [rdi + r8*8]
0x1800c268c  xorps xmm0, xmm0
0x1800c268f  movups xmmword ptr [rsi + 0x20], xmm0
0x1800c2693  movups xmmword ptr [rsi + 0x30], xmm0
0x1800c2697  movups xmmword ptr [rsi + 0x40], xmm0
0x1800c269b  movups xmmword ptr [rsi + 0x50], xmm0
0x1800c269f  movups xmmword ptr [rsi + 0x60], xmm0
0x1800c26a3  movups xmmword ptr [rsi + 0x70], xmm0
0x1800c26a7  movups xmmword ptr [rsi + 0x80], xmm0
0x1800c26ae  mov qword ptr [rsi + 0x90], 0
```

This proves `object + 0x60` is a 16-byte field in a larger object layout and is explicitly zero-initialized together with neighboring 16-byte fields. It is consistent with the tag output field layout used by the boundary capture, but by itself it does not identify the producer of the final tag bytes.

A second helper at `0x1800C2710` writes computed values into fields at:

```asm
0x1800c27e4  lea rcx, [rsi + 0x20]
0x1800c282a  lea rcx, [rsi + 0x40]
0x1800c2890  lea rax, [rsi + 0x60]
0x1800c289f  mov rcx, rax
0x1800c28a2  call qword ptr [r14 + rdx*8]
```

The call at `0x1800C28A2` is the only statically visible direct preparation of the `+0x60` field in this local region. It is still an indirect table call; the target and its relation to SHA finalize are unresolved.

## Evidence boundary

This is not proof that:

```text
tag = SHA digest[:16]
```

The helper writes through an obfuscated table call, and the exact target is not statically resolved in this round. No vector test is justified from this evidence alone.

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

Formal `mac_tag()` remains fail-closed.
