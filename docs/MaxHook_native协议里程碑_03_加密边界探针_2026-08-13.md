# MaxHook native 协议里程碑 03：加密边界探针

日期：2026-08-13（Asia/Shanghai）

本里程碑的目标不是给未知算法贴标签，而是把下一次运行变成可产出独立复现所需参数的确定性实验。当前已经能同时观察 WinHTTP 发送边界与 Windows CNG 边界；如果 MaxHook 使用自实现密码代码，WinHTTP 调用栈仍会给出最后一个 native 调用点。

## 1. 当前可硬确认的线格式

请求目标：

```text
POST https://security.mcbjd.net/api/v3/report
Content-Type: application/json
Accept: application/json
Content-Length: 2659
```

完整响应样本与请求残片共同支持以下外层结构：

```json
{"sv":3,"kid":"32 hex","nonce":"24 hex","ciphertext":"even-length hex","tag":"32 hex"}
```

18 个唯一完整响应样本有以下不变量：

- `sv` 全部为 `3`；
- `kid` 全部为 `7E6757FD8090153938CFF989ADFEC119`；
- `nonce` 全部不同，解码后均为 12 字节；
- `ciphertext` 全部为 144 个 hex 字符，即 72 字节；
- `tag` 全部为 16 字节。

这组尺寸与多种 AEAD 都兼容，尤其是 AES-GCM、AES-GCM-SIV、ChaCha20-Poly1305、AES-CCM；尺寸本身不能证明其中任何一种。`kid` 在多次响应间稳定、nonce 每次变化，更像“密钥标识 + 每消息 nonce”，但这仍是结构推断，不是算法证明。

## 2. 已排除的简单密钥假设

可重复执行的统一分析入口：

- [analyze_maxhook_crypto.py](./analyze_maxhook_crypto.py)
- [maxhook_crypto_analysis.json](./maxhook_crypto_analysis.json)

```powershell
python E:\Coding\S1mple\target\analyze_maxhook_crypto.py
```

本机完整复跑耗时约 47 秒，结果为：明显派生 key 命中 0、内存常驻 key 命中 0、系统模块指针命中 2（均为 WinHTTP，见第 3 节）。统一结果使用 schema `maxhook.crypto.analysis/v1`，同时保存输入范围、尝试数和原始 opcode 偏移，便于在另一份 dump 上直接比较。

### 2.1 内存原始 key 扫描

证据文件：[maxhook_response_keyscan.json](./maxhook_response_keyscan.json)

扫描范围：

- 两个 MaxHook 相关 native 栈区；
- MaxHook `.data`；
- MaxHook `.rdata`。

对齐提取 16/24/32 字节原始候选以及可识别的 hex key 候选，共测试 `957,233` 个唯一 key。针对一份已知响应，用 9 组 AAD 候选测试 AES-GCM 与 ChaCha20-Poly1305 tag，命中数为零。

该结果只能排除“key 以扫描方式覆盖到的明文、对齐形式常驻这些区域，并使用已测试算法/AAD”的组合。它不能排除派生 key、临时 key、未对齐/分散 key、密钥句柄、自实现算法或不同 AAD。

### 2.2 `kid` 与明显字符串的直接派生

证据文件：[maxhook_derived_keyscan.json](./maxhook_derived_keyscan.json)

额外构造 88 个可解释候选，包括：

- `kid` 大小写 ASCII、16 字节 hex 解码值及逆序；
- domain、path、完整 URL、`sv`；
- 上述材料的 MD5、SHA-1、SHA-256、SHA-512 截取；
- 少量 `kid + domain/path` 的显式组合。

针对 18 个唯一响应，测试算法为 AES-GCM、AES-CCM、AES-GCM-SIV、ChaCha20-Poly1305；AAD 候选包括空值、字段值、二进制值、常见拼接形式与 JSON 字段前缀。总计 `4,692` 个“key/算法/AAD”族，零命中。

因此不能把 `kid` 本身或它的最明显 hash 当成协议 key。继续盲目扩充口令字典的价值很低，下一步应抓真正的派生/加密边界。

## 3. MaxHook 映像内的系统密码 API 指针筛查

证据文件：[maxhook_system_crypto_pointer_scan.json](./maxhook_system_crypto_pointer_scan.json)

对所有已转储 `0x180...` MaxHook 映像区按全部 8 种字节对齐扫描 qword，目标范围包括：

- `bcryptPrimitives.dll`；
- `bcrypt.dll`；
- `ncrypt.dll`；
- `ncryptsslp.dll`；
- `winhttp.dll`。

结果只有两个 WinHTTP 命中：

| MaxHook 内地址 | 目标 | 解释 |
|---|---|---|
| `0x180960220` | `winhttp+0x17ea0` | 精确为静态导入 `WinHttpCloseHandle` |
| `0x18098c0f8` | `winhttp+0x0` | WinHTTP 模块基址 |

没有任何指向四个系统密码模块的常驻指针。这不是“未使用 CNG”的证明：MaxHook 可能在调用时临时解析、通过其他模块间接调用，或 dump 时已清理；但现有内存不能支持“它明确使用 BCrypt”这一说法。

原始 DLL 与运行态 `.bugland` 也没有找到可信的 AES-NI 指令族签名字节（AESENC/AESDEC/AESKEYGENASSIST/PCLMULQDQ）。少量 SHA 指令 opcode 命中落在打包/数据语境，不能当成可执行密码实现证据。经典 AES S-box、ChaCha `expand 32-byte k`、SHA-256 常量的泛进程命中也已证实大量来自 JDK/Java heap，不能归因给 MaxHook。

## 4. 新的动态加密/发送联合探针

文件：

- [capture_maxhook_winhttp.js](./capture_maxhook_winhttp.js)
- [capture_maxhook_winhttp.py](./capture_maxhook_winhttp.py)

WinHTTP 部分会关联 `WinHttpConnect -> WinHttpOpenRequest -> WinHttpSendRequest/WinHttpWriteData`，只保留目标 host/path 或总长 2659 的请求，并输出：

- 完整 pre-TLS body 分块和重组体；
- `Content-Length` 与实际捕获长度；
- envelope 结构校验；
- `WinHttpSendRequest` 的准确 native backtrace、直接 caller 和线程 ID；
- API 入口的 x64 GPR 与从当时 `RSP` 到栈区末端、最多 32 KiB 的原始栈片段；
- pre-TLS 响应分块。

CNG 部分会 hook：

- `BCryptOpenAlgorithmProvider`；
- `BCryptGenerateSymmetricKey`；
- `BCryptImportKey`；
- `BCryptEncrypt`；
- `BCryptDecrypt`。

只有 backtrace 包含 `MaxHook.dll` 的 CNG 操作才输出材料，避免把 JDK TLS、WinHTTP TLS 和其他进程噪声误判为 native report 加密。输出包括算法名、key handle、导入/生成的 secret/blob、输入输出、IV、认证结构中的 nonce/AAD/tag，以及完整 backtrace。

采集主程序会自动按 `key_handle` 关联 key 生成/导入事件，并要求 `BCryptEncrypt` 输出与最终 envelope 的 ciphertext 逐字相等；如果 CNG 事件提供 nonce/tag，也必须与 envelope 一致。只有全部条件成立时，`capture_summary.json.reproducible_test_vectors[]` 才会产生记录，其中直接包含 plaintext、key capture 文件、算法、AAD、nonce、ciphertext 和 tag。该关联器已用合成 key/encrypt/envelope 三事件通过正向测试；没有精确匹配时数组保持为空。

这形成两个互补结论路径：

1. 若出现 MaxHook 归因的 `bcrypt_encrypt`，可直接用 algorithm/key/nonce/AAD/tag/plaintext 生成外部测试向量；
2. 若没有 CNG 事件但出现 2659 body，发送 backtrace 中最后一个 MaxHook frame 就是自实现加密之后的边界，可据此对该地址做窄范围 trace/断点。

运行方式（需在与游戏相同完整性级别的管理员终端）：

```powershell
uv run --with frida -- python E:\Coding\S1mple\target\capture_maxhook_winhttp.py `
  --process javaw.exe `
  --output E:\Coding\S1mple\target\native_capture_live
```

也可明确指定 PID：

```powershell
uv run --with frida -- python E:\Coding\S1mple\target\capture_maxhook_winhttp.py `
  --pid 12345 `
  --duration 180 `
  --output E:\Coding\S1mple\target\native_capture_live
```

静态与编译验证：

- `node --check capture_maxhook_winhttp.js`：通过；
- Frida 17.17.0 `Compiler.build(...)`：通过，生成 24,029 字节 agent bundle；
- Python `py_compile`：通过；
- synthetic 2659-byte envelope 重组校验：通过；
- synthetic CNG key/encrypt/envelope 自动关联：通过。

本机非管理员实际 attach 自测被 Windows 拒绝：`VirtualAllocEx returned 0x00000005`。工具已把这一错误翻译为明确的“使用同完整性级别管理员终端”提示。当前没有运行中的 `javaw.exe`，所以尚未取得真实加密事件；不能把“hook 可安装/可编译”写成“已捕获 key”。

## 5. 报告 worker 的 clear/VM 根已定位

机器可读证据：[maxhook_report_thread_chain.json](./maxhook_report_thread_chain.json)

从包含 URL 和 native 字段名的栈 `region_0000005962cf8000.bin` 可以严格还原以下线程调用链：

```text
线程 callable 0x1EFB5672040
  [0x00] = 0x1804BB1B0     clear thread wrapper
  [0x08] = 0x1EFA78E4E60  argument

argument 0x1EFA78E4E60
  [0x00] = 0x18089BA70
  [0x08] = 0x1804B67A0     clear worker entry

0x1804B67A0: jmp 0x181A841D3
```

同一栈帧还有：

- `stack+0x7948 = 0x1804BB305`，恰好是 wrapper 内 `call qword ptr [rax]` 后的返回地址；
- `stack+0x79A8 = 0x1805AF5B7`，恰好是通用线程 bootstrap 调用后的返回地址；
- `stack+0x7980 = 0x1EFB5672040`，与上述 callable 对象逐字一致。

原始 DLL 反汇编精确给出 `0x1804B67A0: e9 2e da 5c 01`，目标为 `0x181A841D3`。因此报告 worker 的 VM 根现在可硬定位为：

```text
clear 0x1804B67A0 -> VM 0x181A841D3
```

这比从全局 `REAL_ENTRY` 重启 VM 更有针对性。`capture_vm_pss.py` 的线程评分已经接入这条证据：RIP 等于 worker clear/VM entry 加 140 分；栈中出现 `0x1804BB305` 或 `0x1804B67A0` 加至少 100 分，并在 `threads[].report_stack_markers` 中保存地址。WinHTTP 探针输出的 GPR/栈片段可以直接确认发送是否来自同一 worker。

## 6. 请求首段恢复尝试及纠偏

已知请求尾残片在响应缓冲附近，按 2659 总长度和相同 schema 可得到一个数学闭合模型：固定 JSON 开销 141 字节、ciphertext 2518 个 hex 字符（1259 字节明文/密文字节，若为流式 AEAD）。

我进一步按该模型反推同一缓冲中的原始 body 起点，并检查响应头前的 551 字节窗口。该窗口实际是指针表、TLS record 和其他 WebIO 数据，不是请求 JSON 开头。因此目前仍只有请求尾段，不能凭地址邻接补造 `sv/kid/nonce` 或缺失的前 955 个 ciphertext 字符。

这也说明：长度闭合是强结构证据，但不是“该响应缓冲曾完整连续保存整个请求”的证明。真正的完整 body 仍应在 `WinHttpSendRequest/WinHttpWriteData` 入口捕获。

## 7. 同步 VM 快照链已经接上模拟器

文件：

- [capture_vm_pss.py](./capture_vm_pss.py)
- [phase2_final3.py](./phase2_final3.py)

`capture_vm_pss.py` 使用 Windows PSS VA clone，在 stable→active 边沿一次性捕获 `.bugland`、所有线程 `CONTEXT_ALL`、候选线程栈与 KUSER。它不使用 `DebugActiveProcess`，实测 PSS 捕获约 2–4 ms。

`phase2_final3.py` 现在支持环境变量 `PHASE2_CONTEXT_JSON`，从 `maxhook.pss.capture/v1` 恢复：

- 同一捕获点的 `.bugland`；
- `RIP/RSP/RFLAGS` 与全部 GPR；
- 被选中线程的栈映射。

两文件均通过 `py_compile`。这修复了旧方案把第二次 monitor 最终内存与全局入口寄存器拼接的根本问题。后续若 WinHTTP backtrace 给出具体 VM gateway，可把 PSS 触发条件从泛 stable→active 收窄到该调用周期。

## 8. 下一轮成功判据

下一次游戏运行后，只要得到以下任一项，就算新的“大进度”：

1. 完整 2659 字节 request envelope，拿到真实请求 `kid/nonce/ciphertext/tag`；
2. 一条 MaxHook 归因的 CNG encrypt 事件，能离线重算 tag；
3. 无 CNG 事件，但发送 backtrace 精确落到 MaxHook RVA，可对自实现函数做局部 trace；
4. 同一请求同时获得加密前 input 与发送后 envelope，形成独立实现的第一个完整测试向量。

在出现上述证据前，当前最诚实的状态是：网络 framing 已可复现，密码 envelope 已精确，算法/key/AAD/明文序列化仍未闭合。
