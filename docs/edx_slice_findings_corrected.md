# Corrected EDX/word-producer slice (offline, no attach)

Date: 2026-08-14 (round 3: corrections + continue the slice)

## Corrections to round-2 result

1. **BUGLAND end = 0x181EFC000**, not 0x180efc000 (arithmetic: `0x980000 +
   0x157c000 = 0x1efc000`). So `0x181ad61e7` IS inside `boot_unpacked.bin`
   (offset `0x11561e7`), and the word producer `0x180b8c7aa` (offset `0x20c7aa`)
   is also inside it.
2. **There is NO `call` to store32.** The writer is entered by `ret`: the
   trampoline `0x180c2775c` ends with `popfq; ret 0`, and (proven by
   `target/symbolic_writer_trampoline.py`):
   ```
   rdx    <- S10   (keystream word)
   rcx    <- S11   (destination pointer)
   rax    <- S12
   rflags <- S13
   rip    <- S14   = 0x18041a860 (store32)   <-- ret target
   ```
   `0x181ad61e7` is NOT a return-from-call; it is the next `.bugland` block
   (starts `pushfq; movabs rcx,0x147; ...` = the next VM dispatch) reached AFTER
   store32 returns.

## Word producer = 0x180b8c7aa (in boot_unpacked)

Dynamic upstream chain (writer_upstream_dynamic_long_windows.txt) ends:
```
... -> 0x180b8c7aa -> 0x180c27936 -> 0x180c276c5 -> 0x180c279e4 -> 0x180c2769b
    -> 0x180c27945 -> 0x180c27b86 -> 0x180c2754f -> 0x180c27582
    -> 0x180c278a7 -> 0x180c27bd0 -> 0x180c27a5b -> 0x180c27900
    -> 0x180c2775c (popfq; ret) -> 0x18041a860 (store32) -> 0x180c68543
```
And (writer_chain_dynamic_predecessor_windows.txt) the fixed tail before every
store32 hit is exactly:
```
0x180c278a7 -> 0x180c27786 -> 0x180c27652 -> 0x180c27bf9 -> 0x180c279b4
-> 0x180c27673 -> 0x180c27bd0 -> 0x180c27900 -> 0x180c2775c -> 0x18041a860
```

## RDX last-definition sites

- In the trampoline, the last write of RDX is `0x180c27be2: mov rdx, [rsp]`
  which loads **S10** (the producer-pushed word). There is no arithmetic on RDX
  after this until store32 reads EDX.
- In the producer block `0x180b8c7aa`, the value that becomes S10 is placed by
  one of its six `push qword ptr [reg]` sites:
  ```
  0x180b8c81b: push [rax]   0x180b8c882: push [rsi]   0x180b8c91a: push [rdi]
  0x180b8c9a6: push [r14]   0x180b8ca27: push [r8]    0x180b8caa0: push [rbx]
  ```
  Each `[reg]` = `word[VIP + k] + rbp` (a VM bytecode word resolved through the
  context). These are the cipher's S-box/state lookups feeding the word.
- RDX arithmetic inside `0x180b8c7aa` (before the pushes):
  ```
  0x180b8c864 xor rdi, rdx      0x180b8c88b sub rdx, rbx
  0x180b8c8ad xor rdx, r12      0x180b8c8cc and rdx, 0x3f
  0x180b8c8e0 sub rdx, 0x80     0x180b8c945 xor rdx, 0x90
  0x180b8c9b0 xor rdx, 0x3f     0x180b8ca42 mov rdx, 0x12   (branch-dependent clobber)
  0x180b8ca68 sub rdx, 0x90     0x180b8ca93 and rdx, rbx
  ```

## Slot-change evidence (keystream_slot_changes_capture_20260814)

The producer `0x180b8c7aa` writes the two destination slots A (+0xb5) / B
(+0x235): e.g. seq 849241 `A: 225->112`, 849696 `A: 16->112`, 851416 `A: 1->238`,
850875 `B: 58->16`. These confirm `0x180b8c7aa` is the byte producer whose output
ends up as the XOR byte, and (via the ret-trampoline S10) as the store32 EDX word.

## What is still not closed (honest)

The keystream word EDX = S10 is one of the six `push [word[VIP+k]+rbp]` operands
(or an arithmetic fold over them) inside `0x180b8c7aa`. To give the final closed
EDX expression we must symbolically evaluate `0x180b8c7aa` with the live context
(`rbp`=0x18098c884, VIP, and the S-box words at `word[VIP+k]+rbp`). Those word
operands are key-schedule outputs that are not constant across calls and are the
remaining cipher state. The slice now terminates at exactly these six loads
inside a single, fully-decoded handler (0x180b8c7aa), rather than at an abstract
"runtime .bugland continuation".
