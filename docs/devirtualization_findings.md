# MaxHook 1024-block keystream generator trace — offline devirtualization

Date: 2026-08-14 (offline only; no hooks, no process attach)

## 1. Objective and result

Propose and implement an offline devirtualizer for the repeated 1024-block
keystream generator trace, separating VM bookkeeping from cipher semantics and
recovering the *actual data operations* (which context slots hold keystream,
where it is produced, stored, and XORed into plaintext).

Deliverables (this session):

- `target/devirtualize_keystream_generator.py` — main devirtualizer
- `target/maxhook_devirtualizer_report.json` — machine-readable report
- `target/devirt_explore.py` — stable-common-suffix + context-stability explorer
- `target/devirt_suffix.py` — suffix disassembler / class-runs
- `target/devirt_context.py` — context byte classification (bookkeeping vs state)
- `target/devirt_xor_site.py` — XOR-site + store32 disassembly + oracle cross-check
- `target/devirt_verify_ks.py` — proves `keystream_byte == context[destination]`
- `target/devirt_handlers.py` — full disassembly of every cipher handler

## 2. What the data actually is

`keystream_history_capture_20260814/` holds 52 snapshots (call 1: 11, call 2: 20,
call 3: 21). Each snapshot is taken at XOR byte index = 0, 64, 128, … (once per
64-byte block), and contains:

| field | meaning (confirmed) |
|---|---|
| `xor_index` | byte offset into the keystream stream (every 64) |
| `source` | `r12` = pointer whose **low byte is the plaintext byte** |
| `destination` | `r8` = context slot `+0xb5` (0x18098c939) or `+0x235` (0x18098cab9) |
| `keystream_byte` | `[r8]` read *before* the XOR = the **true keystream byte** |
| `history` | 1024 basic-block start addresses (Stalker `putCallout` ring) |
| `context_hex` | 0x300 bytes of the VM context at 0x18098c884 |

Proved relations (machine-checked):

- `keystream_byte == context[destination - 0x18098c884]` in **52/52** snapshots.
- `source & 0xff` = plaintext byte (e.g. call-1 block 0: `0x7b` = `{`, then
  `a b e 0 e 3 b 0 c 9 …` = the `report_packet` hex chars at offsets 64,128,…).
- `ciphertext = keystream_byte XOR (source&0xff)` — matches milestone 26.

## 3. The stable common suffix

The last **124** entries of the 1024-entry history are **byte-for-byte
identical across all 52 snapshots and all 3 calls** (verified by assertion in
`devirt_explore.py` / `devirtualize_keystream_generator.py`). The common prefix
is length 0, i.e. the divergence is entirely in the front of the ring (the
per-block data-dependent path), while the tail is the invariant loop body +
dispatch epilogue that repeats once per 64-byte block.

The suffix alternates in a clean `dispatch-stub → cipher-arithmetic →
setup/move → generator-loop → …` cadence. This is the VM interpreter main loop:
each handler block ends by `jmp`-ing through a stub into the next handler table
entry, and the generator-loop blocks (0x18099089e → 0x180990a93 → 0x180990b21)
are the per-byte generator body.

## 4. Distinguishing VM bookkeeping from cipher semantics

Two orthogonal signals separate them:

### 4a. Context-byte stability classification

Classifying each of the 768 context bytes across the 52 snapshots:

| class | bytes | meaning |
|---|---:|---|
| CONSTANT | 519 | pointers, handler table (0x180c64ebd), flags — **bookkeeping** |
| POSITION-DERIVED | 209 | rolling key @+0x0a, VIP @+0x6d, keystream slots — **cipher state** |
| MIXED | 40 | live mixed state |
| NONCE-DERIVED | **0** | — |

The **0 NONCE-DERIVED bytes** is the key insight: by the time the XOR executes,
the nonce is already fully absorbed into position-dependent stream state, so the
context holds no "nonce-only" region. The keystream state lives in the heap
`source` buffer (`r12`) and the two destination slots, not in a static context
array. `context+0x61` and `context+0xc5` are runtime key-schedule/keystream-source
pointers (milestone 28) that are absent from the offline dump.

### 4b. Suffix-block classification

Handlers fall into three semantic groups (full disassembly in
`devirt_handlers.py`):

1. **Bookkeeping / dispatch**: stubs that `jmp` into the handler table; `mov`s
   that load `rbp+0x6d` (VIP), `rbp+0x85` (table), `rbp+0x0a` (key) — these
   advance the VM program counter and select the next handler, never touching
   the cipher output.
2. **Cipher arithmetic**: handlers that `xor/add/sub/and/or/rol` over context
   slots `+0x5d`, `+0x69`, `+0xe5`, `+0xa`, `+0xf6` with 32-bit immediates
   (e.g. `0x31d126f2`, `0x636b513`, `0x5b03772f`, `0x453d7de7`, …). These are
   the round/state-update operations.
3. **Output / data movement**: the plaintext-XOR handler `0x1809c544c` ending in
   `mov r12,[r12]; mov r12b,[r12]; xor byte [r8],r12b` at 0x1809c5561, and the
   little-endian `store32` 0x18041a860 that writes the finished 32-bit keystream
   word.

## 5. Recovered actual data operations (the concrete chain)

```
(key, nonce, block_index)
  -> VM word generator (handler arithmetic over context slots)
  -> EDX = 32-bit TRUE keystream word
  -> 0x180c2775c  popfq; ret trampoline
  -> 0x18041a860  store_le32(RCX=dest, EDX=word)      [writer oracle]
  -> 64-byte keystream buffer
  -> 0x180aa5bba  per-byte load
  -> context slot 0x18098c939 / 0x18098cab9  (+0xb5 / +0x235)
  -> 0x1809c5561  xor byte [r8], r12b   (r12b=plaintext, [r8]=keystream)
  -> ciphertext
```

The writer oracle (`writer_sync_clean_20260814_014351/analysis.json`) already
proves the `store32` words reconstruct the exact keystream
(`all_blocks_equal_keystream=true` for calls 1–3). This session additionally
proved the *other* endpoint: the byte at the XOR site's destination slot is the
same keystream (52/52).

## 6. What is NOT recovered (honest boundary)

- The round function `(key, nonce, block_index) -> 16 keystream words` is still
  unknown. The key-schedule state at `context+0x61`/`+0xc5` is runtime-only
  (milestone 28) and is not reconstructible from the static dump; the generator
  loop dispatches through the encrypted handler table 0x1807d7cf0 whose disk
  image is garbage, so offline replay collapses to slot 0xd.
- Therefore this devirtualizer recovers **data operations** (which slots hold
  keystream, where it is stored, where XORed) but not the **round function**.
- No live attach was performed; everything is offline and reproducible.

## 7. Recommended next step (offline, no attach)

Because the generator's keystream word is emitted through a single narrow sink
(`store32 0x18041a860`) whose input is already proven to be the true keystream,
the minimal remaining work is to recover the *producer* of EDX: instrument
(broad, offline) the last writer of the 64-byte keystream buffer per word, then
symbolically fold the `0x1809c544c`-family handlers from that sink backwards
until the state at `+0x61`/`+0xc5` is reached. This is a data-flow slice of the
already-recovered generator loop, not a full VM reconstruction.
