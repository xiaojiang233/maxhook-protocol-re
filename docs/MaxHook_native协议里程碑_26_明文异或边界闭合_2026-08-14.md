# MaxHook native 协议里程碑 26：明文异或边界闭合（2026-08-14）

## 一、关键突破

通过仅在安全入口 `0x180324610` 使用一个 Interceptor、内部全部使用 Stalker `putCallout`，已经定位并闭合外层流密码的真实 plaintext XOR 边界：

```asm
0x1809c552a  mov r12, [r12]       ; 取当前 plaintext 指针
0x1809c552e  mov r12b, [r12]      ; 取 plaintext byte
...
0x1809c5561  xor byte [r8], r12b  ; keystream byte ^= plaintext byte
```

真机同步抓取 7 次调用，逐字节证明：

```text
source_byte == plaintext[i]
before      == plaintext[i] XOR ciphertext[i] == keystream[i]
after       == ciphertext[i]
after       == before XOR source_byte
```

所有已捕获字节的指令语义验证 7/7 调用、总计 6,784 字节全部通过，mismatch=0。

## 二、块结构

此 handler 处理完整 64-byte 块：

```text
captured = floor(plaintext_length / 64) * 64
```

| call | plaintext | captured | tail |
|---:|---:|---:|---:|
| 1 | 745 | 704 | 41 |
| 2 | 1291 | 1280 | 11 |
| 3 | 709 | 704 | 5 |
| 4 | 1361 | 1344 | 17 |
| 5 | 1291 | 1280 | 11 |
| 6 | 851 | 832 | 19 |
| 7 | 683 | 640 | 43 |

尾部 1–63 字节走另一个 tail handler，尚待定位。

## 三、双缓冲槽

完整块在两个固定 VM context 槽之间交替：

```text
source pointer slots: 0x18098c8c9 / 0x18098ca49
destination byte:     0x18098c939 / 0x18098cab9
```

每个 plaintext 字节执行时：

1. pointer slot 指向 copied plaintext 当前字节；
2. `0x1809c552e` 读取该字节；
3. destination context byte 已预先装入对应 keystream 字节；
4. `0x1809c5561` 原地 XOR，直接变为 ciphertext 字节；
5. 后续代码把 context 中的 ciphertext byte 输出到最终 buffer。

这给出新的最短恢复路径：不再追踪 plaintext 之后，而是向前追踪 `0x18098c939/0x18098cab9` 在 `0x1809c5561` 之前最后一次写入——那条链就是 keystream 生成器的最终输出。

## 四、捕获安全性

本轮所有脚本都经过静态审计：仅入口 `0x180324610` 一个 Interceptor。内部 memcpy、`.bugland` plaintext load/XOR 均为 Stalker callout。

- 游戏全程存活，Responding=True；
- 旧危险脚本 `capture_maxhook_plaintext_chain.js` 不得再运行；
- 安全替代：`capture_maxhook_plaintext_chain_stalker.js`、`capture_maxhook_plaintext_chain_stalker_v2.js`、`capture_maxhook_plaintext_xor.js`。

## 五、产物

- 真机记录：`target/plaintext_xor_capture_20260814/`
- 机器可读证明：`target/plaintext_xor_capture_20260814/analysis.json`
- 分析器：`target/analyze_plaintext_xor_capture.py`
- 捕获脚本：`target/capture_maxhook_plaintext_xor.js`

## 六、额外协议线索

离线模拟器的第二个 32-byte allocation 已证明不是 key，而是 domain/AAD label：

```text
v3|hpac.v3.session.report.req
```

decoded input64 key 位于第一分配；key pointer 被写入 context+0xbd，随后经 `0x1809bd556` 进入 VM。

## 七、下一步

1. 在 `0x1809c5561` 每次执行前，记录 destination byte 的上一次写入者。
2. 用 Stalker 对所有写 `0x18098c939/0x18098cab9` 的指令做小范围候选 callout，不使用内部 Interceptor。
3. 从“最后写入 keystream byte”向前追 key/nonce state；这比追全 VM 控制流显著更窄。
4. 定位 tail handler，闭合剩余 1–63 字节及 tag 路径。
