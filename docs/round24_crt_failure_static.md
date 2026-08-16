# Round 24: CRT fail-fast path static conclusion

## Current replay evidence

`tag_fast_r19_livecontinuation.json` is the latest readable replay:

```text
instructions = 4,270,406
nonce seed   = instruction 3,983,297
SHA tag init = instruction 4,145,435, context 0x200001000a0
SHA tag update after nonce = not reached
error        = UC_ERR_INSN_INVALID
```

The nonce buffer contains the seeded bytes at `0x20000100080`:

```text
4161c9f147ead90ff21c08b3
```

The tag SHA context allocation is 112 bytes at `0x200001000a0`. This proves the replay reaches allocation and initialization, but it does not produce the tag SHA message.

## Exact failing sequence

The diagnostic dump records:

```text
0x7ff84445d920  IsProcessorFeaturePresent(0x17) -> 1
0x1805a1000      CRT helper entered
0x1805a1130      helper stub
0x1805a11a4      helper stub
...
0x180416750      security-cookie path
0x18041674c..f   skipped int3 bytes
0x180416750      security-cookie path again
```

At `0x1805a1000`, the saved top-of-stack value is:

```text
[RSP] = 0x7ffe1fec71
```

This is not a code address. It is a stack/data address. The current `--stub-crt-1000` implementation only performs a normal `ret` when the saved return address is inside the image; otherwise it leaves RIP at `0x1805a1000`. The subsequent path is therefore a fail-fast/anti-tamper path, not a valid continuation into SHA update.

## Static proof that 0x1805a1000 is not SHA/tag code

```asm
0x1805a1000  test eax,eax
0x1805a1002  je   0x1805a100b
0x1805a1004  mov ecx,2
0x1805a1009  int 0x29
0x1805a100b  lea rcx,[...]
0x1805a1012  call 0x1805a1130
...
0x1805a104d  mov dword ptr [...],0xc0000409
...
0x1805a10b4  call 0x1805a11a4
0x1805a10be  ret
```

The literal `0xc0000409` is `STATUS_STACK_BUFFER_OVERRUN`; the function is a CRT failure reporter. It is not the tag function and should not be treated as a normal host call whose return value can be fabricated without restoring the VM frame.

## Static SHA boundary remains

```text
0x18042b840  standard SHA-256 init
0x18042b9b0  update(RCX=context, RDX=data, R8=length)
0x18042bb00  finalize/padding
```

The function table entries are:

```text
[0x1807dda20] = 0x18042b840
[0x1807dda28] = 0x18042b9b0
[0x1807dda30] = 0x18042bb00
```

## Strict result

This round does not recover the tag. It does establish that the current blocker is a malformed VM/CRT continuation frame, not absence of a tag SHA implementation:

```text
ciphertext: 20/20
counter0 writer: 3/3
SHA KDF: recovered
SHA tag init: reached
tag SHA update input: missing
tag: 0/24
envelope: 0/24
```

`maxhook_protocol_reference.py` remains fail-closed.
