# MaxHook native 协议里程碑 05：会话密钥输入与 VM 同步阻断

日期：2026-08-13（Asia/Shanghai）

本里程碑分析两次实机落盘的 native 加密边界样本，并把 report 外层加密函数的参数语义、明文协议层次和离线 VM 执行阻断点推进到可复核状态。

结论先行：`input32` 是原样传出的 KID；`input64` 是随会话切换的 64 个 hex 字符（32 bytes）密钥材料。它不是固定机器密钥，也不能作为裸 AES-256/ChaCha20 key 直接使用。函数内部仍有一层 VM 保护的派生或自定义变换。利用同一函数入口时刻抓到的真实 builder frame、R9 context 和参数对象进行离线仿真后，仍在 `.bugland` 全局状态的同一二次解引用处停止，因此当前缺口已经精确收敛为“函数入口同刻的 VM 全局 epoch”，不是参数对象或 `input64` 抓错。

当前仍不能生成一份可由服务器接受的新请求；不能把本里程碑描述为完整替代客户端已经实现。

## 1. 安全边界

原始目录：

```text
E:\Coding\S1mple\target\encrypt_boundary_capture
E:\Coding\S1mple\target\encrypt_boundary_capture2
```

它们包含真实会话材料、明文 report、nonce、ciphertext 和 tag，属于敏感数据，不应上传或公开。本里程碑和分析 JSON 只记录结构、长度、截断后的 SHA-256 指纹和否定性测试结果，不复制原始 KID、`input64`、nonce、ciphertext、tag、session_id 或 report_packet。

由于此前实机动态诊断后服务器进入“黑屋”，本轮只读取已经落盘的文件，并进行离线分析和 Unicorn 仿真；没有重新 attach 进程、抓包、重连、发送请求或调用服务端接口。

目录清单摘要（对按文件名、大小、文件 SHA-256 排序后的 manifest 再取 SHA-256）：

| 目录 | 文件数 | manifest SHA-256 |
|---|---:|---|
| `encrypt_boundary_capture` | 31 | `5f51f90a39b70ae4ba14a6578c6d966ba3b19f85ae1b70cc9b1474e241f62467` |
| `encrypt_boundary_capture2` | 109 | `42790604d4a7f58b1b87a9b26195975fe2cd0ce1a024b07896683974ca36eb7d` |

第二个目录混入了三轮 hook 会话，且不同轮次的 `call_id` 和文件名发生重用；两个早期调用的部分文件已被后续轮次覆盖。因此分析器以每个 `encrypt_hook_installed` 事件分隔会话，并逐项校验 `events.jsonl` 中记录的 SHA-256，不能仅按文件名中的 `call_id` 配对。

## 2. 可复跑分析器与样本有效性

新增：

- [analyze_maxhook_encrypt_boundary.py](./analyze_maxhook_encrypt_boundary.py)
- [maxhook_encrypt_boundary_analysis.json](./maxhook_encrypt_boundary_analysis.json)

复跑：

```powershell
python E:\Coding\S1mple\target\analyze_maxhook_encrypt_boundary.py
```

分析器识别 4 个 hook 会话、16 个逻辑调用。每个完整调用要求以下 7 个文件都存在，且文件 SHA-256 与对应事件一致：

```text
input32
input64
plaintext_json
kid_hex
nonce_hex
ciphertext_hex
tag_hex
```

最终有 14 个调用完整且哈希有效；被覆盖的 2 个调用不参与任何密码测试。

## 3. native 加密函数参数语义闭合

里程碑 04 已定位调用：

```cpp
encrypt(
    output_four_strings,
    input32_string,
    input64_string,
    context_object,
    plaintext_json_string
);
```

14/14 个有效调用现在满足：

```text
input32 长度 = 32 ASCII hex
output kid 长度 = 32 ASCII hex
lower(input32) == lower(output kid)

input64 长度 = 64 ASCII hex = 32 decoded bytes
outer nonce 长度 = 24 ASCII hex = 12 bytes
tag 长度 = 32 ASCII hex = 16 bytes
ciphertext hex decoded length == plaintext byte length
```

因此函数的更准确语义是：

```cpp
encrypt_envelope(
    out,
    kid_hex_32,             // 原样传到 out.kid
    session_secret_hex_64,  // 会话密钥材料/种子
    context,
    plaintext
);
```

“密文与明文等长，16-byte tag 独立输出”与 AEAD/流式加密相符，但只凭长度还不能断言具体算法。

## 4. `input64` 是会话动态材料

只列截断指纹，不列原值：

| 采集会话 | report seq | session_id 指纹 | KID 指纹 | `input64` 指纹 |
|---|---|---|---|---|
| capture 1 / session 0 | 90–93 | `0363db54847a` | `02b94b079d31` | `3ba8c1977db4` |
| capture 2 / session 0 | 117–122 | `0363db54847a` | `02b94b079d31` | `3ba8c1977db4` |
| capture 2 / session 2 | 8–11 | `59d16ad520c8` | `5de50abd5021` | `ffea889b4fc2` |

指纹算法是对应 ASCII hex 转大写后取 SHA-256 的前 12 个 hex 字符。前两轮虽然重新安装了 hook，但 session_id、KID 和 `input64` 均不变，属于同一业务会话；最后一轮 report seq 重置，session_id、KID 和 `input64` 同时切换。

可证明的是：`input64` 至少绑定业务会话，不是单次 report 随机数，也不是不变的机器全局密钥。结合 `/session/bootstrap/redeem`、`/session/exchange` 和 report KID 切换证据，最合理的当前模型是它由 session exchange 产生或解包。尚未证明它是服务端直接下发值还是本地 KDF 产物。

## 5. 外层 plaintext 的协议结构

14/14 个 plaintext 都是紧凑 JSON，且键顺序完全一致：

```json
{
  "device_id": "<16 hex>",
  "h2_cantor": "h2:<32 hex>:<64 hex>",
  "nonce": "<32 hex>",
  "report_packet": "<even-length hex>",
  "seq": 0,
  "session_id": "<32 hex>",
  "sv": 3,
  "timestamp": 0
}
```

实际序列化无空白；上例只为可读性展开。

各会话内：

- `device_id` 固定；
- `session_id` 固定；
- `seq` 连续递增；
- JSON 内部 16-byte `nonce` 每条变化；
- `h2_cantor` 每条变化，格式严格为 `h2:<16 bytes hex>:<32 bytes hex>`；
- `report_packet` 是 hex 编码的二进制层，样本解码长度为 196–520 bytes，经验熵为 6.8766–7.6208 bits/byte；
- JSON 内部 nonce 与外层 envelope 的 12-byte nonce 不相等；
- `input64` 不等于任何 JSON 字符串字段。

所以 native report 至少包含两层变换：

```text
检测/遥测结构
  -> 高熵二进制 report_packet + h2_cantor
  -> 外层 plaintext JSON
  -> encrypt_envelope(session_secret_hex_64, ...)
  -> {ciphertext,kid,nonce,sv,tag}
```

`h2_cantor` 后 32 bytes 不是 report_packet（raw/hex ASCII）的直接 SHA-256，也不是把 `input64`、KID、内部 nonce 和 report_packet 用已测试的直接拼接 SHA-256/HMAC-SHA256 得到的值。其具体算法仍待闭合。

## 6. direct key / 常见 KDF / context 扫描结果

分析器先利用已知 plaintext/ciphertext 计算首块 keystream，再测试候选，而不是仅调用带 tag 的 AEAD 解密。因此 0 命中不能归咎于 AAD 猜错。

针对一个完整同步调用测试：

- 127 个 direct/常见 KDF 候选；
- `input64` raw hex bytes、ASCII 两半、SHA-256/SHA-512/MD5；
- KID 与 `input64` 的两种顺序、空/冒号/NUL 分隔；
- HMAC-SHA256；
- HKDF-SHA256 的常见 salt/info 组合；
- PBKDF2-SHA256（1/1000/4096/10000 次）；
- 同步抓到的 builder frame、R9 context 和 `ctx_ptr0..2` 中 3,055 个唯一 16/24/32-byte 滑动窗口候选；
- AES counter（counter 0–3，大小端）；
- SM4 counter（counter 0–3，大小端）；
- ChaCha20-IETF（counter 0–2）。

结果：

```text
hits = 0
```

这排除了所列的直接 key 与常见派生组合，尤其排除了“`input64` hex decode 后直接作为标准 AES-GCM/ChaCha20 key”。它不排除 VM 内的自定义 KDF、非标准 counter/nonce 布局、其他算法、白盒 key schedule 或尚未抓到的会话状态。

## 7. 同步参数驱动的 VM 离线执行

离线仿真器：

- [emulate_maxhook_encrypt_boundary.py](./emulate_maxhook_encrypt_boundary.py)
- [maxhook_encrypt_vm_emulation_boundary_session2_call4.json](./maxhook_encrypt_vm_emulation_boundary_session2_call4.json)
- [maxhook_encrypt_vm_emulation_boundary_dump_epoch.json](./maxhook_encrypt_vm_emulation_boundary_dump_epoch.json)

仿真恢复了：

- `MaxHook.runtime-unpacked.dll` 全 PE；
- dump 中除 `.bugland` 外的模块区段；
- 两份不同来源的 `.bugland` 候选 epoch；
- 同一 `encrypt` 函数入口时刻的 builder frame；
- R9 context 的 0x100 bytes；
- `ctx_ptr0..2` 指向的 0x100-byte 块；
- 入口时刻的真实 input32、input64、plaintext 对象及其 heap 数据；
- 原始对象地址和 builder RBP；
- 隔离的本地 allocator/free stub。

复跑（只在离线文件上运行）：

```powershell
python E:\Coding\S1mple\target\emulate_maxhook_encrypt_boundary.py `
  --boundary-dir E:\Coding\S1mple\target\encrypt_boundary_capture2 `
  --boundary-session 2 `
  --boundary-call 4 `
  --output E:\Coding\S1mple\target\maxhook_encrypt_vm_emulation_boundary_session2_call4.json
```

真实同步参数版本执行结果：

```text
executed instructions = 545691
last RIP             = 0x1809BD556
VM slot address      = 0x18098C8C9
VM slot value        = 0x158
failing operation    = qword dereference of address 0x158
Unicorn result       = UC_ERR_READ_UNMAPPED
```

`runtime_bugland2.bin` 与 `dump_out\41264\region_0000000180980000.bin` 两份 `.bugland` 输入均在第 545,691 条指令得到逐项相同的 probe 序列和同一 `0x158` 失败。

对照实验中，旧仿真器使用合成 input32/input64/plaintext，但同样在 `0x1809BD556` 对 `0x158` 二次解引用失败（执行 546,483 条指令）。恢复真实同步参数只改变了中间路径长度，没有改变最终状态依赖。

因此现在可以排除：

- R9 context 完全伪造导致失败；
- `input64` 值错误导致这个失败；
- plaintext 对象布局错误导致这个失败；
- builder frame 缺失导致这个失败。

仍缺的是函数入口同一时刻的 VM 全局状态，至少包括以 `0x18098C884` 为基址的 context 和它引用的相关 `.bugland` 槽/页。旧 PSS/monitor 的 `.bugland` 是另一时刻的最终态，不能与本次入口参数跨时刻拼接。

这个失败是恢复算法的状态同步阻断证据，不是密码算法失败或 rolling key 不存在的证据。

## 8. 下一步最小闭环

纯离线可继续的优先级：

1. 从 `/session/exchange` 的 plaintext/response 和 report builder 的上游赋值链，恢复 `input64` 的产生位置与生命周期；
2. 继续识别 `report_packet` 与 `h2_cantor` 的内层构造函数，先闭合内层层级；
3. 从 VM trace 的 545,691 条路径中定位写入 `VM_RBP+0x45`（即 `0x18098C8C9`）的最后一条指令和预期指针来源，缩小需要同步恢复的页集合；
4. 在服务器状态和授权明确恢复前，不再实机 attach；若未来确需一次新采集，目标应是 encrypt entry 同刻的最小 VM context/引用页，而不是全进程长期监控。

最终可复现实现仍需同时闭合：

```text
session bootstrap/exchange
  -> input64/session secret 的导出或 KDF
  -> report_packet + h2_cantor
  -> 外层 nonce/key/AAD/AEAD
  -> 精确 envelope 序列化
```

## 9. 产物 SHA-256

| 文件 | SHA-256 |
|---|---|
| `analyze_maxhook_encrypt_boundary.py` | `25b172ba9b121ada70ac63c34cd524664c5ca27ef93226e60264ffb62e9269aa` |
| `maxhook_encrypt_boundary_analysis.json` | `7bacf0667fe174a41c7796736848a65175108f3ebc5220f4fa03fc9ef6795910` |
| `emulate_maxhook_encrypt_boundary.py` | `4c6bbdfa404d492f345d9983d74b3d26329e254e0bfef955ce7bbc6e92970d2c` |
| `maxhook_encrypt_vm_emulation_boundary_session2_call4.json` | `7d1eda5d015dbaf1f346eb045d6eb570326c8200dbd87001950a79bdf68bcbe8` |
| `maxhook_encrypt_vm_emulation_boundary_dump_epoch.json` | `ec1a4b3e86208489a5e77dd6299ee7b96c0207a8c6dde3cce937c99d8c07cd23` |

