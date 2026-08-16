# MaxHook native 协议续攻进度

更新日期：2026-08-13（Asia/Shanghai）

目标：不用原 DLL，使用 Python、curl 或其他 HTTP 客户端构造并发送与 MaxHook 一致的 native 上报。

> **2026-08-13 18:00 后续更新：** 本文早期章节基于首次 5.36 GiB dump，当时只有响应和请求尾残片。现已取得 22 组完整双向 pre-TLS 样本，并定位 report/session exchange 共用的 VM 保护加密边界；随后从 14 组真实函数边界调用确认 `input32 == kid`、`input64` 为随 session_id/KID 切换的 64-hex 会话材料，用同步入口参数把 VM 离线执行推进到 545,691 条指令，并闭合 dispatcher 的 key/VIP/handler-index 取指规则。最新事实以 [里程碑 04](./MaxHook_native协议里程碑_04_真实双向样本与加密函数边界_2026-08-13.md)、[里程碑 05](./MaxHook_native协议里程碑_05_会话密钥输入与VM同步阻断_2026-08-13.md)、[里程碑 06](./MaxHook_native协议里程碑_06_VM_dispatch取指与handler表阻断_2026-08-13.md)、[里程碑 07](./MaxHook_native协议里程碑_07_input64会话复用与keytrace边界_2026-08-13.md) 和 [里程碑 08](./MaxHook_native协议里程碑_08_验证集与unlicense适配性_2026-08-13.md) 为准；下文“未取得完整请求”“请求顺序推测”等旧状态只保留为研究过程记录，不再代表当前结论。

## 结论摘要

MaxHook 的 native 上报地址和 HTTP wire format 已经确定：

```text
https://security.mcbjd.net/api/v3/report
```

已捕获的请求为 HTTP/1.1 `POST`，body 是紧凑 JSON 加密 envelope。当前已完整捕获 bootstrap、exchange 和 20 次 report 的请求/响应，也已确定加密函数调用边界；仍不能生成一份预期会被服务端接受的新请求，因为 KDF、AEAD/AAD、真实 key 和明文内容尚未闭合。

真实客户端请求的 envelope 顺序为：

```json
{"ciphertext":"<hex>","kid":"<32 hex>","nonce":"<24 hex>","sv":3,"tag":"<32 hex>"}
```

旧 dump 中捕获的目标请求 `Content-Length` 是 2659；本次新采集中完整 report 长度实际覆盖 1507–16453 字节，证明 2659 只是某一条消息的实例长度，不是协议常量。客户端请求顺序与服务器响应顺序不同，详见里程碑 04。

## 1. MaxHook native HTTP 协议

### 1.1 请求

证据文件：

```text
E:\Coding\S1mple\target\dump_out\41264\region_000001efa9307000.bin
region base = 0x1EFA9307000
```

请求头起点：文件偏移 `0x30950`，VA `0x1EFA9337950`。

```http
POST /api/v3/report HTTP/1.1
Connection: Keep-Alive
Content-Type: application/json
Accept: application/json
Content-Length: 2659
Host: security.mcbjd.net
```

精确偏移：

| 项 | 文件偏移 | VA |
|---|---:|---:|
| Request line | `0x30950` | `0x1EFA9337950` |
| Connection | `0x3096E` | `0x1EFA933796E` |
| Content-Type | `0x30986` | `0x1EFA9337986` |
| Accept | `0x309A6` | `0x1EFA93379A6` |
| Content-Length | `0x309C0` | `0x1EFA93379C0` |
| Host | `0x309D6` | `0x1EFA93379D6` |
| 头后位置 | `0x309F2` | `0x1EFA93379F2` |

重要纠错：`0x309F2` 后的 2659 字节不是 body。该处有 2005 个零字节，内容以 UTF-16 的 `Sun:Sunday:Mon:Monday...` 为主，不含 envelope 键或硬件字段。请求库把 header 和 body 放在不同缓冲区，不能按文件邻接关系切 body。

### 1.2 请求 envelope 的长度模型（历史 dump 推算，已由里程碑 04 纠正）

当时依据响应样本推测的布局如下；真实客户端请求顺序后来已实证为 `ciphertext,kid,nonce,sv,tag`，本小节只保留对旧 `Content-Length=2659` 的长度核算：

```text
{"sv":3,"kid":"<32>","nonce":"<24>","ciphertext":"<2518>","tag":"<32>"}
```

长度核算：

```text
固定 JSON 开销（含 kid/nonce/tag 值，不含 ciphertext 值） = 141
ciphertext hex 长度                                  = 2518
总长度                                               = 2659
密文字节数                                           = 1259
```

字段长度和顺序来自 22 份严格合法的完整 envelope。它们全是 285 字节、`sv=3`、kid 32 hex、nonce 24 hex、tag 32 hex；其中至少 17 个唯一值可直接绑定到 HTTP 200 响应。没有发现第二种字段顺序。

### 1.3 请求体尾段（强关联，不是完整 body）

证据文件：

```text
E:\Coding\S1mple\target\dump_out\41264\region_000001efa4d9d000.bin
region base = 0x1EFA4D9D000
```

在响应缓冲被复用后保留了一段大 envelope 尾部：

| 项 | 值 |
|---|---|
| ciphertext 可见尾段起点 | 文件 `0x2683`，VA `0x1EFA4D9F683` |
| 可见 ciphertext | 1563 个连续 hex 字符 |
| 首 32 字符 | `8414a40cf4d475ff84307ab27f076f68` |
| 末 32 字符 | `dad589c2767d5b7c074ce2dc2aeb95` |
| tag | `0c6754d737bb12a18db4b7b75915f479` |
| JSON 结束 `}` | 文件 `0x2CC8`，VA `0x1EFA4D9FCC8` |
| 可见尾段总长度 | 1606 字节 |

闭合关系：

```text
缺失字段前导                         = 98
缺失 ciphertext                     = 955
缺失前缀                            = 1053
可见尾段                            = 1606
1053 + 1606                         = 2659
```

这使它成为本次 2659 字节请求的最强 body 候选，但缺失了 `sv/kid/nonce` 和 ciphertext 前 955 个字符。不能把这 1606 字节补零后当作有效请求。

另有一段从文件 `0x2CDB` 开始的 1041 hex 尾段，tag 为 `23ae48f45c9064b4a8a588cd8cc77b2d`；它无法绑定到唯一请求，暂不用于协议复现。

### 1.4 响应

同一文件中，响应头位于 `0x248D`（VA `0x1EFA4D9F48D`），JSON 位于 `0x2532`（VA `0x1EFA4D9F532`）。

```http
HTTP/1.1 200
Server: nginx/1.31.3
Date: Thu, 13 Aug 2026 04:38:47 GMT
Content-Type: application/json
Transfer-Encoding: chunked
Connection: keep-alive
```

首个 chunk 大小是 `0x11d`，即 285 字节。完整响应 body：

```json
{"sv":3,"kid":"7E6757FD8090153938CFF989ADFEC119","nonce":"7c064bb3c59409649b2ab870","ciphertext":"eeded0bf945452ea1035206f189c788b0892b756c9f8f4d4d22977723dd3d35955d9939f8e1e3a5323cce34d707accc5f391241ab5ff9a4c63c30bb423b3571d28bfe4c778d83220","tag":"45eafe7f6c79dec182525fa4faa7a00c"}
```

响应 ciphertext 是 144 hex，即 72 字节密文。

时间关联也成立：响应 `Date` 为 UTC 04:38:47，即北京时间 12:38:47；相关 region 在北京时间约 12:38:46 落盘。历史缓冲还显示约 30 秒一次的周期以及少量短间隔突发。

### 1.5 可能的明文字段

以下字符串位于同一 32 KiB 页：

```text
E:\Coding\S1mple\target\dump_out\41264\region_0000005962cf8000.bin
region base = 0x5962CF8000
```

| 字符串 | 文件偏移 | VA |
|---|---:|---:|
| `motherboard_count` | `0x7530` | `0x5962CFF530` |
| `mac_count` | `0x7550` | `0x5962CFF550` |
| `disk_count` | `0x7560` | `0x5962CFF560` |
| `cpu_count` | `0x7570` | `0x5962CFF570` |
| `https://security.mcbjd.net` | `0x7870` | `0x5962CFF870` |

这些是 native report schema/采集项的强线索，但尚未看到它们组成连续明文 JSON，也没有证明四个字段一定出现在本次 2659 字节请求里。

## 2. 外部客户端复现状态

### 2.1 已经可以复现

- TLS 目标：`security.mcbjd.net:443`
- HTTP 方法与路径：`POST /api/v3/report`
- HTTP/1.1 headers：Host、Keep-Alive、JSON Content-Type/Accept
- body 是无空格的紧凑 JSON envelope
- 字段顺序：`sv, kid, nonce, ciphertext, tag`
- 捕获样本中的 `sv=3`
- kid/nonce/tag 的编码和长度
- 捕获请求的总 body 长度 2659
- chunked HTTP 200 响应的解析

### 2.2 还不能复现服务端认可的请求

缺少以下四类材料：

1. 一份完整 raw 请求 body；
2. ciphertext 对应的加密前 plaintext；
3. 准确算法及 AAD/填充/字节序；
4. kid 对应的会话密钥来源，以及 nonce 是否必须新鲜。

`nonce=12 bytes`、`tag=16 bytes` 很像常见 AEAD envelope，但这只是形态推断，不能据此把算法写死为 AES-GCM。当前没有足够证据判断 AES-GCM、ChaCha20-Poly1305 或自定义封装。

### 2.3 可用于验证 HTTP 层的 Python 骨架

下面的代码只能验证 wire format、服务端连通性和错误响应，不能生成有效认证数据。默认不应拿已捕获 nonce/tag 做重放假设。

```python
import http.client
import json

envelope = {
    "sv": 3,
    "kid": "0" * 32,
    "nonce": "0" * 24,
    "ciphertext": "0" * 2518,
    "tag": "0" * 32,
}
body = json.dumps(envelope, separators=(",", ":")).encode("ascii")
assert len(body) == 2659

conn = http.client.HTTPSConnection("security.mcbjd.net", 443, timeout=10)
conn.request(
    "POST",
    "/api/v3/report",
    body=body,
    headers={
        "Connection": "Keep-Alive",
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Content-Length": str(len(body)),
        "Host": "security.mcbjd.net",
    },
)
response = conn.getresponse()
print(response.status, response.reason)
print(response.read())
```

该骨架目前只作为本地/授权环境中的协议探针模板；没有在本轮主动向服务端发送伪造数据。

## 3. 获得完整 native 协议的最短路径

优先目标不再是盲目长跑 Unicorn，而是在真实进程中同时取得“序列化前明文、加密参数、最终 send buffer”。

### 路线 A：发送边界抓完整 body

1. 在约 `:16/:46` 的已观察周期窗口，高频扫描或下断 `POST /api/v3/report`、`Content-Length: 2659`、`{"sv":3`；
2. 先确认实际传输栈是否调用 `WinHttpSendRequest` / `WinHttpWriteData`；
3. 若未命中，不继续假设 WinHTTP，改查实际 native/JDK HTTP/TLS send 路径；
4. 在 TLS 之前复制 buffer、长度、调用栈和所属线程；
5. 对同一次请求关联 header buffer 与独立 body buffer。

普通 Npcap/TCP ETW 位于 TLS 之后，只能稳定拿到 IP、SNI、长度和时序，拿不到 2659 字节明文 body。

### 路线 B：加密函数边界做差分

对最终 body buffer 建硬件写断点或页保护监视，回溯最后写入 `tag` 和 ciphertext 的函数。单次调用同时保存：

- 输入明文地址与长度；
- 输出 ciphertext 地址与长度；
- kid、nonce、tag；
- 所有 GPR、XMM/YMM、RFLAGS、RSP 周围栈；
- 调用前后相关堆页。

拿到两到三组完整输入/输出后，再识别算法、AAD 和 key schedule；不要只根据 nonce/tag 长度猜算法。

### 路线 C：同步 VM 快照后续跑

旧 `runtime_bugland2.bin` 是第二次 monitor 会话的末态，不是初始化态。把它重新放回 `0x180C0EB27`，却只恢复 RBP，没有恢复同刻 RIP、RSP、RFLAGS、GPR 和栈，属于跨时刻状态拼接。

两次“随机垃圾跳转”已经被精确证明为 handler table 越界：

- table `T=[rbp+0x85]=0x180C64EBD`；
- 真实连续表只有 index `0..0x64B`，共 1612 项；
- 一次错误 index 是 `0x4819`，表槽恰好等于崩溃地址 `0x34681024448F2404`；
- 另一次错误 index 是 `0xCC71`，表槽恰好等于 `0xCEB869F6DC4B65BB`。

因此当前证据不能支持“rolling key 架构性无法同步”。它只证明旧模拟使用了错误 epoch 的线程状态。

下一次应在 stable→active 边沿做一次性同步快照：同时保存 `.bugland`、VM context、候选线程 `CONTEXT_ALL`、栈和相关 heap，再从该快照的 RIP 继续。Windows PSS 的 VA clone + thread context 适合做这个操作，不需要长期附加 debugger。

## 4. 已修正的模拟器问题

`E:\Coding\S1mple\target\phase2_final3.py` 已做以下诊断性修正：

- 标明 `runtime_bugland2.bin` 是晚期快照，不能冒充入口初态；
- x64 栈入口对齐为 `RSP % 16 == 8`，提供 32 字节 shadow space；
- 从 PE 入口运行时把 DllMain 参数放入 RCX/RDX/R8；
- FILETIME 改为一次写入 64-bit，`VirtualProtect` 的 oldProtect 改写 32-bit；
- 实现 `memcpy`、`memset`、`RtlCopyMemory`、`RtlZeroMemory`；
- RDTSC/CPUID 扫描覆盖完整 `.bugland`，不再只扫前 3 MiB；
- 每个 16 KiB `vmsnap` 全部映射，不再只保留首个 4 KiB；
- 未映射读写默认立即停止并报告缺失依赖；只有显式设置 `PHASE2_ZERO_FILL_UNMAPPED=1` 才使用旧的补零兼容模式；
- 外部模块占位改为 INT3，避免未实现的模块内部调用在 NOP 海中假装成功；
- API 名先去掉 `module!` 前缀再精确匹配。

旧日志中的“块”是 `emu_start(timeout=30000)` 的 30ms 时间片，不是 VM basic block。后续统计必须使用确定的指令数或 VM dispatcher 边界。

## 5. 三条协议必须分开

当前进程内存在三条独立反作弊/完整性链，不能互相借用字段或密钥：

```text
MaxHook native DLL
  -> 自行获取 JVM / 安装 hook
  -> security.mcbjd.net/api/v3/report

NetEase EnvSDK/acSDK
  -> JNI bridge + libenvsdk.dll
  -> acsdk.gameyw.netease.com / NOS 规则

HeyPixel Java 协议
  -> heypixel:s2cevent / RemoteAssetMessage
  -> Forge mod、路径、SHA-256、OSHI 硬件信息
```

Java 侧 `ClientNetworkBootstrap` 对 MaxHook 只做资源释放和 `System.load()`。MaxHook 无 JNI 导出，但导入 `jvm.dll!JNI_GetCreatedJavaVMs`，说明它在加载后主动进入 JVM。EnvSDK 则有明确的 `Java_com_netease_mc_mod_network_common_Library_*` JNI 导出，是另一套实现。

acSDK dump 中已恢复的 VM DLL 名单、YARA 规则和 `scanCommonKeySimul` 名单属于 EnvSDK/acSDK，不应标成 MaxHook VM 内部检测名单。它们可用于理解同一客户端的检测面，但不能证明 MaxHook 的 2659 字节 body 包含这些内容。

## 6. 可复核产物

| 文件 | 用途 |
|---|---|
| `E:\Coding\S1mple\target\analyze_maxhook_network.py` | 扫描全量 region，提取 request/response/envelope/尾段并拒绝伪 body |
| `E:\Coding\S1mple\target\maxhook_network_evidence.json` | 网络证据的机器可读输出 |
| `E:\Coding\S1mple\target\phase2_final3.py` | 修正后的 VM 诊断模拟器 |
| `E:\Coding\S1mple\target\runtime_bugland2.bin` | 第二次 monitor 会话重放至末尾的 `.bugland` 状态，MD5 `50553cb377759aac47affd99a5cc09f6` |

网络扫描器已实际跑过：扫描 10,764 个 region、5,755,867,136 字节，得到 1 个目标请求头、20 个 HTTP 200 标记、18 个唯一完整 envelope，以及 2 个大尾段候选。`analyze_maxhook_network.py` 和 `phase2_final3.py` 均已通过 Python 语法编译检查。

## 7. 当前里程碑定义

| 里程碑 | 状态 |
|---|---|
| 精确 host/path/method/headers | 已完成 |
| JSON envelope schema/字段长度 | 已完成 |
| 完整响应样本 | 已完成 |
| 捕获请求的完整 2659-byte body | 未完成；已有 1606-byte 强关联尾段 |
| 明文 report schema | 部分；有四个 count 字段线索 |
| 加密算法/AAD | 未完成 |
| kid/key/nonce 生成规则 | 未完成 |
| 独立客户端生成有效请求 | 未完成 |
| 独立客户端解析 HTTP/envelope | 可完成；缺少解密 key |

下一关键交付应是同一次 native 上报的三元组：`plaintext + crypto parameters + final 2659-byte body`。取得该三元组后，才适合把协议实现固化为独立 Python/Rust/Java 客户端并做离线测试向量。
