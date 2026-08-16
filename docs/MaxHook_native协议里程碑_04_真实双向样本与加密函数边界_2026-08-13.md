# MaxHook native 协议里程碑 04：真实双向样本与加密函数边界

日期：2026-08-13（Asia/Shanghai）

本里程碑把上一阶段的“响应样本 + 请求尾残片 + 待运行探针”推进为：22 组完整 pre-TLS 请求、22 组完整 pre-TLS 响应、20 个逐次验证的 report builder 栈帧，以及一个同时被 session exchange 和 report 复用的 VM 保护 native 加密函数边界。

结论先行：外层协议、session/report 的 KID 切换、客户端字段序列化顺序、native 输入/输出对象布局现在都可以独立复核；AEAD 算法、KDF、AAD 和真实 key 仍未闭合，当前还不能诚实地宣称已实现可与服务器互通的替代客户端。

## 1. 安全边界与原始采集状态

原始采集目录：

```text
E:\Coding\S1mple\target\target\native_capture_live
```

其中包含会话 envelope、设备/进程遥测和运行时地址，属于敏感材料，不应上传或公开。本文及新生成的分析 JSON 不保存原始 KID、nonce、ciphertext、tag、请求体、响应体、句柄或指针，只保存长度、哈希、地址常量和结构验证结果。

本次动态采集已经停止。由于用户反馈该次运行后服务器进入“黑屋”状态，后续工作切换为纯离线模式：不再 attach、不再读取当前游戏 PID、不再自动重连或重试 PSS。若启动命令行中的登录令牌曾出现在诊断输出，应退出游戏/启动器并重新登录以轮换会话。

原始 `events.jsonl` SHA-256：

```text
00496476be8f3af977c85cc85ac7b4b6f08c514237c6ba13d7262655490ee480
```

## 2. 22 组完整双向 envelope

可复跑分析器：

- [analyze_maxhook_live_capture.py](./analyze_maxhook_live_capture.py)
- [maxhook_live_capture_analysis.json](./maxhook_live_capture_analysis.json)

复跑命令：

```powershell
python E:\Coding\S1mple\target\analyze_maxhook_live_capture.py `
  E:\Coding\S1mple\target\target\native_capture_live `
  --output E:\Coding\S1mple\target\maxhook_live_capture_analysis.json
```

本机验证结果：

```text
events                  146
requests                 22
valid request envelopes  22/22
valid response envelopes 22/22
request/response KID     22/22 matched per transaction
report builder frames    20/20 fully validated
```

端点顺序和数量：

| 顺序 | 端点 | 次数 | 请求 ciphertext 字节 |
|---|---|---:|---:|
| 1 | `/api/v3/session/bootstrap/redeem` | 1 | 123 |
| 2 | `/api/v3/session/exchange` | 1 | 666 |
| 3–22 | `/api/v3/report` | 20 | 683–8156 |

响应 ciphertext 字节：bootstrap 为 1452，exchange 为 901；前 9 个 report 响应为 71，后 11 个为 72。

所有消息仍满足：

```text
sv=3
kid=32 hex chars
nonce=24 hex chars = 12 bytes
ciphertext=even-length hex
tag=32 hex chars = 16 bytes
```

但真实客户端请求与服务器响应的成员顺序不同：

```json
// 客户端请求，22/22
{"ciphertext":"...","kid":"...","nonce":"...","sv":3,"tag":"..."}

// 服务器响应，22/22
{"sv":3,"kid":"...","nonce":"...","ciphertext":"...","tag":"..."}
```

如果最终算法把序列化前缀或字段顺序纳入 AAD，不能把这两个顺序混用。

## 3. session exchange 后发生 report KID 切换

为了不泄露原始值，只记录原始大写 KID ASCII 的 SHA-256：

| 请求区间 | 端点 | KID 指纹前缀 |
|---|---|---|
| request 1–2 | bootstrap + exchange | `2170a47b8c77` |
| request 3–22 | report | `906afdaa3121` |

每个事务的 request/response KID 都相同，但 report 从 request 3 开始使用新的稳定 KID。因此可硬确认 session exchange 与后续 report 密钥标识建立/切换存在时序关系；尚不能仅凭这一点断言 exchange 明文中传输的是裸对称 key，也不能断言 KID 本身参与 KDF。

## 4. WinHTTP caller 与 report builder 调用链

22 次 `WinHttpSendRequest` 的 MaxHook 直接 caller 都是：

```text
0x180333271
```

caller 所在函数及关键调用：

```text
0x180332770-0x180333c82
0x18033326e  call qword ptr [rsp + rax*8]
0x180333271  return after WinHttpSendRequest
```

20 个 report 全部来自 TID 17352；bootstrap/exchange 来自 TID 11436。第一份 report 栈的机器可读调用链保存在 [maxhook_live_report_stack_callchain.json](./maxhook_live_report_stack_callchain.json)。其中：

```text
captured RSP + 0x1b0 = 0x1803d0ad4
0x1803d0acf            call 0x180332770
caller function        0x1803cd330-0x1803d18b9
builder RBP            captured WinHTTP RSP + 0x238
```

直接发送参数为：

```asm
0x1803d0aba  lea rcx, [rbp+0x210]
0x1803d0ac1  lea r8,  [rbp+0x580]
0x1803d0ac8  lea r9,  [rbp+0x120]  ; complete envelope std::string
0x1803d0acf  call 0x180332770
```

## 5. 20/20 个 report native 字段对象完全闭合

栈对象是 MSVC `std::string` 布局：union/pointer 在 `+0x00`，size 在 `+0x10`，capacity 在 `+0x18`。

在全部 20 个 report 中，下列字段逐次成立：

| builder RBP 偏移 | 对象 | 硬验证 |
|---:|---|---|
| `+0x120` | 完整 request envelope | size 等于实际 body 长度；pointer 等于 WinHTTP send buffer |
| `+0x290` | KID hex | size 恒为 32 |
| `+0x2B0` | nonce hex | size 恒为 24 |
| `+0x2D0` | ciphertext hex | size 逐次等于 envelope ciphertext 字符数 |
| `+0x2F0` | tag hex | size 恒为 32 |

这不是通过“看起来像”判断：分析器从每份捕获栈读取 size/capacity/pointer，再与该次实际发送 envelope 的字段长度和 send pointer 比较，20/20 全部通过。

## 6. 加密前明文与 VM 保护加密函数边界

report builder 中已定位到如下直接调用：

```asm
0x1803cf7c4  mov [rsp+0x20], rsi       ; rsi = RBP+0x100
0x1803cf7c9  lea rcx, [rbp+0x290]      ; output envelope struct
0x1803cf7d0  lea rdx, [rbp+0x0E0]      ; 32-char string
0x1803cf7d7  lea r8,  [rbp+0x1A0]      ; 64-char string
0x1803cf7de  mov r9, rdi                ; freshly built context/object at RBP+0x38
0x1803cf7e1  call 0x180324610
0x1803cf7e6  lea rcx, [rbp+0x100]
0x1803cf7ed  call 0x18031b970          ; plaintext string destructor
```

`0x180324610` 的第一条有效指令是：

```asm
0x180324610  jmp 0x181523001
```

目标位于 `.bugland`，所以该函数是 VM 保护的 native 加密/封装边界，而非系统 CNG wrapper。

20 份 report 在 WinHTTP 发送时仍保留以下后调用状态：

- `RBP+0xE0` size 恒为 32；
- `RBP+0x1A0` size 恒为 64；
- `RBP+0x100` size 已被析构清零；
- `RBP+0x100` capacity 每次都足以容纳该次 ciphertext 字节数；
- `RBP+0x100` union 残留 20/20 都包含 JSON schema 片段 `_id":"`。

因此第 5 参数可以硬归类为加密前 JSON `std::string`。32 字符输入很可能是 KID，64 字符输入很可能是 32 字节 hex 编码的密钥/KDF 材料，但“很可能”尚不是内容相等证明：本次栈捕获只保存了 heap pointer，未保存它们指向的 heap 内容。

## 7. session exchange 复用同一个加密函数

exchange builder：

```text
function                   0x18033ef60-0x180348545
native encrypt call        0x18034406d -> 0x180324610
WinHTTP wrapper call       0x18034503f -> 0x180332770
return after wrapper       0x180345044
builder RBP                captured WinHTTP RSP + 0x238
```

exchange 加密调用参数与 report 同构：

```asm
RCX = RBP+0xBA0  ; output: KID/nonce/ciphertext/tag 四个连续字符串
RDX = RBP+0x200  ; 32-char string
R8  = RBP+0x580  ; 64-char string
R9  = RBP+0x50   ; fresh context/object
[RSP+0x20] = RBP+0x220 ; plaintext JSON string
```

发送时栈验证结果：

| 对象 | 捕获 size | envelope 期望 |
|---|---:|---:|
| output KID | 32 | 32 |
| output nonce | 24 | 24 |
| output ciphertext | 1332 | 1332 |
| output tag | 32 | 32 |
| final envelope | 1473 | 1473，且 pointer 等于 send buffer |
| plaintext | size 0 / retained capacity 717 | ciphertext 为 666 字节，容量足够 |

这证明 `0x180324610` 不是 report 专用序列化器，而是 session exchange 和 report 共用的 envelope 加密边界。

bootstrap 的发送栈也保留一组连续的 `32/24/246/32` 字符串对象和完整 387 字节 envelope 对象；但其 builder 已在发送前部分退栈，当前没有与 `0x180324610` 同等级的直接 callsite 证据，因此只把它记录为结构同构，不把它强行归因给同一调用点。

## 8. CNG 与 64-hex key 候选的离线验证

本次真实动态采集得到：

```text
MaxHook-attributed BCrypt events: 0
```

结合 `0x180324610 -> .bugland`，当前更支持自实现/静态链接密码实现或 VM 内部 KDF，而不是直接调用已 hook 的 BCrypt encrypt API；这仍不是“绝对不使用任何 Windows 密码服务”的证明。

基于 `R8` 输入 size=64 的新约束，新增：

- [scan_maxhook_hex_key_candidates.py](./scan_maxhook_hex_key_candidates.py)
- [maxhook_hex64_keyscan.json](./maxhook_hex64_keyscan.json)

复跑命令：

```powershell
python E:\Coding\S1mple\target\scan_maxhook_hex_key_candidates.py `
  --dump-dir E:\Coding\S1mple\target\dump_out\41264 `
  --network-evidence E:\Coding\S1mple\target\maxhook_network_evidence.json `
  --output E:\Coding\S1mple\target\maxhook_hex64_keyscan.json
```

完整结果：

```text
files scanned                    10,765
bytes scanned             5,756,531,235
bounded 64-hex occurrences          674
unique 64-hex candidates              290
old-session envelopes                 18
AEAD attempts against first sample 73,920
authenticated hits                     0
elapsed                         130.546 s
```

每个候选测试 hex 解码值及其可解释 SHA-256 变体，算法包括 AES-GCM、AES-CCM、ChaCha20-Poly1305、AES-GCM-SIV，AAD 包括空值、字段值/二进制值、常见拼接和 JSON 前缀。

零命中只排除“旧 dump 中保留下来的严格 64-hex 候选可直接/简单 hash 成已测试 AEAD key，并使用已测试 AAD”的组合。它不能排除：

- 64 字符输入只是 KDF input/salt/public material；
- key 在调用中继续与 32 字符输入或方向标签派生；
- 未测试的精确 AAD 或字段顺序；
- 自定义 AEAD、非标准 ChaCha 轮数或组合 MAC；
- 正确临时字符串在旧 dump 捕获点前已经析构。

## 9. PSS 失败根因与离线修复

实际失败发生在 PSS VA clone 已创建之后：脚本把固定地址 VM key/VIP 在 clone 中不可读视为致命错误，于是在遍历同步线程 context 之前抛出异常，导致本应有价值的 `CONTEXT_ALL` 也被一起丢弃。

[capture_vm_pss.py](./capture_vm_pss.py) 已修改为：

- clone tuple 可读：正常使用 clone 同步值评分；
- clone tuple 不可读：记录 `clone_sample_error`，保留所有 PSS thread context 和稀疏 dump；
- fallback 的触发样本明确标为 `trigger_active_fallback_not_clone_synchronous`，不伪装成同步值；
- 不再因为这一项缺失而丢弃整次捕获。

修复后只执行了本机 `--self-test`，验证 PSS clone marker、5 个线程、1232 字节 `CONTEXT64` 均成功；没有再次触碰游戏进程。考虑到服务器状态，当前不建议立即重跑 live PSS。

## 10. 当前离“其他程序复现 native 协议”还差什么

已经具备：

1. 三个 endpoint 和调用顺序；
2. 完整双向外层 JSON framing；
3. 每消息 12-byte nonce、16-byte tag 和可变长 ciphertext；
4. session KID 到 report KID 的切换时序；
5. 完整 request/response 测试样本；
6. report/exchange 共用的 native 加密函数地址和参数对象布局；
7. 加密前 plaintext `std::string` 的精确参数位置。

仍缺：

1. `RBP+0xE0/0x200` 的 32 字符实际内容及其与 output KID 的逐字比较；
2. `RBP+0x1A0/0x580` 的 64 字符实际内容；
3. `RBP+0x100/0x220` 在析构前的完整 plaintext；
4. `0x180324610` 内部的 KDF、AEAD 算法、AAD 和方向 key 规则；
5. 用外部程序重算至少一个捕获 tag，并由第二个样本交叉验证。

下一步最有效的目标已从“泛抓整个 VM”缩窄为一个函数入口：在不触发新的在线实验前，先沿 `.bugland` 入口 `0x181523001` 和它进入的 dispatcher 做离线数据流恢复；若未来由用户明确决定进行一次新的隔离测试，也只需在 `0x180324610` 调用前复制上述三个 `std::string` 的 heap 内容，无需再全量跟踪 WinHTTP 或 PSS。

## 11. 本里程碑产物哈希

```text
analyze_maxhook_live_capture.py
ED8FF90366EC2709928173289E4098F0F0B2044690697954DD9E0E8691A52270

maxhook_live_capture_analysis.json
FF513E570284BBA5409C04407C2ED307C9AB63228B59BAF879D65E942AAFC338

scan_maxhook_hex_key_candidates.py
9C802209EAAEBE8F440B96B223745BA670E0218EF0C68B21CC12AA3CD127974E

maxhook_hex64_keyscan.json
44C8C43A41B89BD486F2C9DC687F837A38F16D0DE19B55A534E2B4C8B58F6D7A

capture_vm_pss.py
8A7C5E61EC9D22D8062671A87D819657DDF34FE08698630EE033F974993BE1D5
```

## 12. 下一次最小函数级采集器（仅离线实现，未运行）

为了不再泛抓整个 VM，新增加密边界专用工具：

- [capture_maxhook_encrypt_boundary.js](./capture_maxhook_encrypt_boundary.js)
- [capture_maxhook_encrypt_boundary.py](./capture_maxhook_encrypt_boundary.py)

它只 attach `MaxHook+0x324610`，按本里程碑已经证明的 ABI 读取：

```text
input32
input64
plaintext_json（第 5 参数，[callee RSP+0x28]）
kid_hex / nonce_hex / ciphertext_hex / tag_hex（返回后 output+0x00/20/40/60）
```

`std::string` 读取器同时处理 MSVC SSO 与 heap 两种布局，并检查 `size <= capacity`、32 MiB 上限和空指针。每项内容作为独立本地二进制文件保存，summary 只记录文件、长度和 SHA-256。由于这三项足以包含明文和真实 key/KDF 材料，attach 模式必须显式传 `--ack-sensitive-local-capture`，输出目录不得上传。

当前只做了安全的离线编译验证：

```powershell
node --check E:\Coding\S1mple\target\capture_maxhook_encrypt_boundary.js
uv run --with frida -- python E:\Coding\S1mple\target\capture_maxhook_encrypt_boundary.py --compile-only
```

结果：Python `py_compile` 通过，Node 语法检查通过，Frida Compiler 17.x 接受并生成 7937 字符 bundle。没有 attach 当前游戏进程，也没有执行 live capture。

```text
capture_maxhook_encrypt_boundary.js
DE8D4CFD6AA5022606DADF5FBE8CDB07A530B5341B346B8E8A107E322DF50BBF

capture_maxhook_encrypt_boundary.py
0BD29217725552C8A5BF8093CE5E62A6798A04B143D363D538BB16C0C57DD09E
```
