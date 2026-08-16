# MaxHook native 协议里程碑 07：input64 会话复用与 keytrace 边界

日期：2026-08-13（Asia/Shanghai）

本轮只分析用户已经落盘的 `keytrace_capture` 和静态 DLL；没有重新 attach、PSS、抓包或访问服务器。

## 结论

`input64` 不是可以写死在复现器里的常量。新的一次 keytrace 会话中，8 次加密调用都使用同一份 64 字节 ASCII hex；与既有 boundary capture 的两个会话指纹不同。因此更准确的模型是：

```text
session exchange / MaxHook session state
        └── 生成或接收本会话 input64（64 ASCII hex）
                └── report/exchange encrypt boundary（同会话复用）
```

这证明了“每条消息重新从固定字符串派生 input64”的假设不成立，但还没有证明 input64 的生成公式或它就是最终密码 key。

## 1. 新捕获的可复核事实

分析器：

- [analyze_maxhook_keytrace.py](./analyze_maxhook_keytrace.py)
- [maxhook_keytrace_analysis.json](./maxhook_keytrace_analysis.json)

输入：`target/keytrace_capture/events.jsonl`。捕获共有两次 hook 安装：第一次调用在监控器配置阶段报错且没有有效 hex；第二次安装有 8 次完整调用。

第二次安装的摘要（原始 KID/key material 不写入报告）：

| 项目 | 结果 |
|---|---|
| 完整 input32 调用 | 8/8，32 bytes，hex 格式 |
| 完整 input64 调用 | 8/8，64 bytes，hex 格式 |
| input32 会话内唯一指纹 | `487eda0b7143` |
| input64 会话内唯一指纹 | `5b766aaad7df` |
| input32 会话内是否恒定 | 是 |
| input64 会话内是否恒定 | 是 |
| `MemoryAccessMonitor` 首次读 RIP | `0x180322e30` 共 15 次；另有 `0x7ff845af5d01` 1 次 |

这里的“恒定”只表示该次安装所覆盖的 8 个调用。既有 boundary capture 的会话指纹为 `3ba8c1977db4`、`ffea889b4fc2`，与本轮 `5b766aaad7df` 不同，形成三次独立会话材料变化的交叉证据。

原始采集器的限制必须保留：Frida `MemoryAccessMonitor` 对监控页通常只报告首次访问，不能据此声称“整个 VM 只读了两次 key”，也不能把一次 reader RIP 直接等同于 KDF。

## 2. `0x180322d10` 的静态边界

`0x180322e30` 位于静态函数 `0x180322d10` 的一个明确字节遍历循环：

```asm
0x180322e30  movzx edx, byte ptr [rdi]
             ... indirect predicate call ...
0x180322e81  inc   rdi
0x180322e84  cmp   rdi, rsi
0x180322e87  jne   0x180322e30
```

这条形态与字符串范围校验/比较类 helper 一致；它不是可辨认的 AES、ChaCha、HMAC 或 KDF 主循环。由于 predicate 通过混淆后的间接表调用，当前只能把它标为“输入字符串消费/验证边界”，不能凭这段代码命名具体字符集合。

静态 DLL SHA-256：

```text
f3ddac1dae9539f34e6b9d1fdea654f984cca4cff37851cadcbf6909b78af6a9
```

## 3. 对 native 协议复现的实际影响

可复现的部分继续保持：

- HTTP endpoint、envelope 字段和字段顺序；
- 明文 JSON 字段顺序与长度关系；
- `input32 == kid`；
- 同一 session 内 `input64` 复用；
- native encrypt 边界的调用 ABI。

仍不能从这些证据独立生成服务端可接受的新 envelope：

- input64 的会话生成/导入来源；
- VM 同刻 handler table 与 key/VIP 状态；
- 外层流状态、tag、AAD 以及内层 `report_packet`。

所以当前可用实现仍是“复用真实 MaxHook encrypt boundary”，而不是把 `input64` 固定写入 Python/Java 客户端。若要完全离线实现，下一条硬证据必须来自 session exchange 返回/导入点，或来自同刻 PSS/边界快照中 input64 的生产函数。

## 4. 复跑命令与完整性

```powershell
python E:\Coding\S1mple\target\analyze_maxhook_keytrace.py `
  --capture-dir E:\Coding\S1mple\target\keytrace_capture `
  --dll E:\Coding\S1mple\target\MaxHook.runtime-unpacked.dll `
  --output E:\Coding\S1mple\target\maxhook_keytrace_analysis.json
```

```text
analyze_maxhook_keytrace.py     F3F95B859B5C568FC86F02F298B11E60D80358D037EAA560A426C760631FD638
maxhook_keytrace_analysis.json  D1C0E898B2D020351CBA5681DF6F52BFF820136671EBA501572DD6CBC9F67842
```

本里程碑把 `input64` 的生命周期约束得更严，但没有把它误报成最终 key，也没有宣称恢复加密算法。
