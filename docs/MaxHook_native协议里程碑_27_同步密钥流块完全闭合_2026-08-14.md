# MaxHook native 协议里程碑 27：同步密钥流块完全闭合（2026-08-14）

## 1. 结论

同步捕获 `writer_sync_clean_20260814_014351` 首次在同一次 encrypt 调用内同时保存：

- 32-byte session key（input64 hex decode）；
- 12-byte nonce；
- plaintext；
- ciphertext；
- 16-byte tag；
- `0x18041a860` 的全部 32-bit little-endian writer values。

对 3 个完整调用正确按 VM 写入顺序对齐后，writer 输出与真实密钥流逐字节完全相同：

```text
keystream = plaintext XOR ciphertext
```

| call | plaintext bytes | writer records | 丢弃的 setup 残段 | 密钥流块 | 结果 |
|---:|---:|---:|---:|---:|---|
| 1 | 745 | 204 | 12 | 12 | 全部相同 |
| 2 | 1353 | 364 | 12 | 22 | 全部相同 |
| 3 | 1127 | 300 | 12 | 18 | 全部相同 |

机器可读证明：`target/writer_sync_clean_20260814_014351/analysis.json`，三个调用均为 `all_blocks_equal_keystream=true`。

## 2. 之前误判的原因

每次 Stalker 开始时先捕获到一个 setup/前序 pass 的尾部 12 words：

```text
offsets = 16,20,...,60
```

真正 block 从随后第一个 offset 0 开始，并按 VM 的 wrap 顺序写入：

```text
16,20,...,60, 0,4,8,12
```

因此必须：

1. 丢弃开头 12 条 setup 残段；
2. 之后每 16 条组成一个 block；
3. 按每条记录自身的 offset 放回 64-byte buffer。

按此对齐后，包括最后 partial plaintext block 所需的 keystream prefix，也全部一致。

## 3. 确认的数据链

```text
VM word generator
  -> EDX (32-bit true keystream word)
  -> 0x180c2775c popfq; ret trampoline
  -> 0x18041a860 store_le32(RCX, EDX)
  -> 64-byte keystream buffer
  -> 0x180aa5bba per-byte load
  -> 0x180aa5bce VM slot store
  -> 0x1809c5561 XOR plaintext byte
  -> ciphertext
```

所以 `0x18041a860` 虽只是通用 little-endian store helper，但传入的 EDX 已经是最终真实 keystream word，不是中间状态。

## 4. 同步向量

共同 key：

```text
347230E63EEC999571342BE4417C430A6EBC3C82F27142361C1B5FEF02B4ACD9
```

KID：

```text
1DC2157CAEF692F074DE2CEEECAF4E86
```

三个 nonce / tag：

```text
nonce 96e71401fc4f5faa040e5ca1
tag   e264c3dc50a0137264f503bbffafb33c

nonce 3fa29634397f82181677262f
tag   dfa36e37f2de2148171f0ccbdca9ef62

nonce 8260e5b4587f7b01e697ddf2
tag   753b60438772d0814a42f0a2a746f3da
```

## 5. 安全说明

该同步捕获使用全线程 Stalker，单次调用延长至约 4–6 秒，随后游戏会话进入服务端“黑屋”。高度疑似协议/心跳时序超时，而非内部 Interceptor 自检。已停止所有实时探针，后续优先离线分析。

目录含 session key 和 plaintext，不得上传。call 4 未完成，不可使用。

## 6. 剩余任务

1. 从 `0x180c2775c` 向前恢复 EDX 的 VM 生成链，即 `(key, nonce, block_index) -> 16 words`。
2. 恢复 tag/MAC finalize。
3. 实现 tail（密钥流 block 已覆盖 tail prefix，主要剩 MAC 长度处理）。
4. 独立实现并验证 `crypto_verify_set.json` 7/7。
