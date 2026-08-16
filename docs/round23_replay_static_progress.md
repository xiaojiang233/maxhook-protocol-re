# Round 23 replay/static progress

## New replay result

`tag_fast_r19_livecontinuation.json` is now present. It used the proven live continuation target:

```text
--patch-ret-target 0x181ac0a58
```

The replay advanced to instruction `4,270,406`, substantially beyond the earlier `4,157,xxx` endpoint. It still ended with:

```text
error = Invalid instruction (UC_ERR_INSN_INVALID)
```

No post-nonce `0x18042B9B0` update was captured. The last tag-phase SHA event remains the init at `0x18042B840`, context `0x200001000A0` in this allocator layout.

## Concrete failure path

The replay now records this sequence:

```text
4259510  IsProcessorFeaturePresent(PF_FASTFAIL_AVAILABLE=0x17) -> 1
4259511  enter 0x1805A1000
4259515  stub 0x1805A1130
4259542  stub 0x1805A11A4
...
4270382  security-cookie check at 0x180416750
```

At `0x1805A1000`, the existing emulator option `--stub-crt-1000` returns immediately. Its saved return target is:

```text
0x7FFE1FEC71
```

That is stack/data, not a module code address. Therefore the current stub does not restore a valid VM call/return frame; it deliberately converts the CRT path into a stale stack return. The later cookie/int3 activity is a consequence of that malformed return, not evidence that tag SHA update was reached.

## Static evidence for the failure helper

`0x1805A1000` is not a normal tag SHA function. Its direct code is:

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

This is a CRT fail-fast/reporting helper. It writes `STATUS_STACK_BUFFER_OVERRUN (0xC0000409)` and is not part of the SHA implementation. The true tag SHA update remains before/after a VM state that the current asynchronous replay does not restore correctly.

## Important correction

The replay did **not** prove that the tag path lacks a SHA update. It proved only:

1. nonce allocation and seed succeeded;
2. tag SHA context allocation/init succeeded;
3. the current IAT/anti-tamper workaround enters the CRT fail-fast helper;
4. the current immediate-return stub produces a non-code return target;
5. execution terminates before any captured post-nonce SHA update.

## Current status

```text
ciphertext: 20/20 objective set (7/7 reference harness)
counter0 writer: 3/3
SHA domain KDF: recovered
tag SHA init: reached
tag SHA update input: not captured
tag: 0/24
complete envelope: 0/24
```

`maxhook_protocol_reference.py` remains fail-closed; no guessed tag construction was installed.
