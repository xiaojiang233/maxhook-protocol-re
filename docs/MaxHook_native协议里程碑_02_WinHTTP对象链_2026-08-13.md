# MaxHook native 协议里程碑 02：WinHTTP 对象链与 body 捕获点

日期：2026-08-13

本里程碑确认 MaxHook native 上报进入 Windows WinHTTP/WebIO 栈，并在 dump 中还原 request header、2659 字节发送长度、发送缓冲关联指针和响应 JSON 缓冲之间的对象关系。

它没有恢复已被清零的完整 request body，但把下一次动态捕获点从“猜测网络库”收敛为 `WinHttpSendRequest` 与 `WinHttpWriteData`。

## 1. WebIO request 对象

对象 VA：`0x1EFB545D010`。

证据文件：

```text
E:\Coding\S1mple\target\dump_out\41264\region_000001efb5437000.bin
文件偏移 0x26010
```

| 对象偏移 | 值 | 解释 |
|---:|---:|---|
| `+0x20` | `0xA63` | 2659，与 Content-Length 精确相等 |
| `+0x30` | `0x1EFA9337950` | 完整 request header 指针 |
| `+0x38` | `0xB3` | header 相关容量值，确切字段名待定 |
| `+0x40` | `0xA2` | 162，精确等于 header 字节数 |
| `+0xA8` | `0x7FF82EAF3D50` | `webio.dll + 0x13D50` |
| `+0xB0` | `0x1EFB545D0C0` | 内部节点指针 |
| `+0xC0` | `HRESQ...` | WebIO request 相关标记 |

request header 指针落到：

```http
POST /api/v3/report HTTP/1.1
Connection: Keep-Alive
Content-Type: application/json
Accept: application/json
Content-Length: 2659
Host: security.mcbjd.net
```

`modules_37988.txt` 给出的 `webio.dll` 基址是 `0x7FF82EAE0000`，因此模块归属可确定。

## 2. WinHTTP 发送对象

对象 VA：`0x1EFA5358330`。

证据文件：

```text
E:\Coding\S1mple\target\dump_out\41264\region_000001efa5314000.bin
文件偏移 0x44330
```

| 对象偏移 | 值 | 解释 |
|---:|---:|---|
| `+0xA8` | `0x7FF83CB61610` | `winhttp.dll + 0xF1610` |
| `+0xC8` | `0x1EFDB443730` | 与 2659-byte send 项关联的缓冲指针 |
| `+0xD0` | `0xA63` | 2659 |
| `+0xE0` | `0xA63` | 第二份长度/上限字段 |
| `+0xF0` | `0x1EFA5358330` | self/owner 指针 |
| `+0x100` | `0x7FF83CB5A4B0` | `winhttp.dll + 0xEA4B0` |
| `+0x110` | `0x7FF83CB5A288` | `winhttp.dll + 0xEA288` |

`winhttp.dll` 基址为 `0x7FF83CA70000`。同一 pointer/length 组合还保留在另一块运行时副本：

```text
0x1F0C0CE1328 : 0x1EFDB443730
0x1F0C0CE1330 : 0xA63
```

这不是仅凭一个 `2659` 数值归因：WebIO 对象同时保存精确 header 指针、header 长度 162 和 Content-Length 2659；WinHTTP 对象又保存 buffer-associated pointer 与两份 2659 长度，并带有多个 WinHTTP 模块内地址。

## 3. 发送缓冲为何没有完整 body

从 `0x1EFDB443730` 精确读取 2659 字节：

```text
0x00 数量       = 2656
非零字节        = 3
可打印字节      = 0
SHA-256         = d0e31972675159623806ff8a8f0b082bb88fb5ac211b47c3d7e68264327b3073
起始 12 bytes   = 01 00 00 00 03 00 00 00 04 00 00 00
```

该地址在 dump 时已不再保存 JSON。最合理的解释是原发送 buffer 在请求结束后被释放、清零或由分配器元数据覆盖。这解释了为何 request header 仍完整，而 request envelope 只剩响应缓冲覆盖后的 1606-byte 尾段。

“释放/清零”是从对象状态作出的推断；`+0xC8` 的确切私有字段名仍需 symbols 或动态调用参数确认。

## 4. 响应对象对照

相关 WinHTTP 对象位于 `0x1EFA5358510`。其 `+0xA8` 指向 `0x1EFB4FD3838`，该地址可直接读到完整响应：

```json
{"sv":3,"kid":"7E6757FD8090153938CFF989ADFEC119","nonce":"7c064bb3c59409649b2ab870","ciphertext":"eeded0bf945452ea1035206f189c788b0892b756c9f8f4d4d22977723dd3d35955d9939f8e1e3a5323cce34d707accc5f391241ab5ff9a4c63c30bb423b3571d28bfe4c778d83220","tag":"45eafe7f6c79dec182525fa4faa7a00c"}
```

对象 `+0xB0` 为 `0x2000`，与接收缓冲容量相符。发送和响应对象使用相近的 WinHTTP 内部节点布局，增强了对象链归因。

## 5. 新的动态捕获方案

下一次运行应在 WinHTTP API 入口复制调用参数，同时拦截：

```text
WinHttpConnect
WinHttpOpenRequest
WinHttpSendRequest
WinHttpWriteData
WinHttpReceiveResponse
WinHttpReadData
```

handle 关联：

```text
WinHttpConnect return handle -> host/port
WinHttpOpenRequest return handle -> verb/path/connection handle
WinHttpSendRequest -> headers、optional body、optional len、total len
WinHttpWriteData -> 后续 body chunks
```

筛选条件：

```text
host == security.mcbjd.net
path == /api/v3/report
total length == 2659
```

必须按 request handle 聚合 `WinHttpSendRequest.lpOptional` 与所有 `WinHttpWriteData` chunk。有效候选应满足：

```text
len(body) == 2659
body starts with {"sv":3,"kid":"
JSON keys are sv/kid/nonce/ciphertext/tag
```

捕获必须发生在函数入口，因为函数返回后调用方或 WinHTTP 可能立即复用/清零 buffer。

## 6. 对协议复现能力的影响

本里程碑前：只知道 request body 位于独立缓冲区，不知道真实传输栈和稳定截获位置。

本里程碑后：

- 已证明进入 WinHTTP/WebIO；
- 已定位 header request 对象及 header pointer/length；
- 已定位与 2659-byte send 项关联的 pointer/length 组合；
- 已用响应对象验证相近缓冲节点确实持有 envelope；
- 可以实施 API-entry capture，下一目标是取得完整 2659-byte raw body。

仍未完成：完整 request body、加密前 plaintext、算法/AAD、key/kid、nonce 生成规则，以及独立客户端生成服务端认可的请求。

## 7. 机器可读证据

```text
E:\Coding\S1mple\target\maxhook_pointer_xrefs.json
E:\Coding\S1mple\target\maxhook_request_object_xrefs.json
```

它们记录 request header、VM context、WebIO request 对象、WinHTTP 相关对象和 2659 长度候选的全 dump xref。
