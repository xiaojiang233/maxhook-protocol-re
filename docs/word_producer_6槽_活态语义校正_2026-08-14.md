# MaxHook 字生产者 6 槽 — 活态实测语义校正（第 100 轮）

日期：2026-08-14
范围：纯离线。数据源：`keystream_history_capture_20260814/`（pid 42948，52 快照，含 context_hex + keystream_byte + source/destination）。

## 一、本轮关键校正：source/destination 语义

此前轮次对快照字段语义有混淆。经交叉核对 `devirt_xor_site.py` / `devirt_verify_ks.py`
（XOR 位点 `0x1809c5561 xor byte [r8], r12b`）确认：

| 字段 | 语义 | 实测 |
|------|------|------|
| `source` | r12 = **明文字节指针**（非状态缓冲） | `0x13a4e19207b`（heap 明文副本） |
| `destination` | r8 = **context 槽 +0xb5 / +0x235** | `0x18098c939` / `0x18098cab9` |
| `keystream_byte` | `[r8]` 在 XOR 前读出的值 = **真实密钥流字节** | 与 ctx[0xb5] 一致 ~100% |

## 二、6 个字生产者槽在活态下的真实值（pid 42948 call 1）

字生产者 `0x180b8c7aa` 的 6 个 push 槽 `{0xb5, 0x26, 0xd9, 0x61, 0xbd, 0x106}` 在**活态**下：

| 槽 | 活态语义 | 实测值（call 1） |
|----|---------|-----------------|
| `+0xb5` | **密钥流字节输出** | = keystream_byte（f7/de/40/6d/84/...） |
| `+0x26` | **块计数器** | 0,1,2,3,4,5,6,7,8,9,0xa,0xb（每 64B 块 +1） |
| `+0xd9` | **块内字节偏移** | 0x00,0x40,0x80,0xc0 循环（4 字 × 4 字节） |
| `+0x61` | **S-box 状态表指针**（模块 .data） | `0x180835f10`（xor=64 时；其余为 0） |
| `+0xbd` | **key 缓冲指针**（heap） | `0x13a4e192070`（固定，除 xor=64 为 0x1c0） |
| `+0x106` | 状态值 | 0xe9（大部分）/ 0x01（xor=64） |

**计数器结构完全解码**：块计数器 + 块内字节偏移（0/64/128/192 循环）+ S-box 指针 + key 指针。
这与报告 2.4 节一致，但本轮确认了 `+0x61`=S-box 指针（模块 .data `0x180835f10`）与
`+0xbd`=key 指针（heap）的**精确身份**。

## 三、校正此前结论

1. **"key 状态在 heap、不在 context"**（round 96 `find_true_key_bytes.py` 结论）需细化：
   - **计数器/指针状态在 context**（`+0x26/+0xd9/+0x45/+0x36/+0x14a/+0x61/+0xbd/+0x106`）；
   - **S-box 内容在模块 .data `0x180835f10`**（非 heap，非 context）；
   - **key 本身在 heap `0x13a4e192070`**（32 字节，本地 dump 未覆盖）。
2. 因此"唯一缺 heap 状态缓冲"应更精确为：**唯一缺 = S-box 内容（`0x180835f10`）+ key 字节（`0x13a4e192070`）**。
   S-box 是**模块静态数据**，可能可从 runtime-unpacked DLL 的 `.data` 段直接读出（无需活态）！

## 四、S-box 假设验证（本轮实测，已证伪）

读 `MaxHook.runtime-unpacked.dll` 的 `0x180835f10`（`check_sbox_static.py`）：

- `0x180835f10` 是**代码指针表**（8 字节指针 → `0x180068a70`/`0x18051d3e0`/`0x180c70180`/
  `0x1804b52b0` 等，均在 .bugland 之外的其他节），**非字节 S-box**；
- 即 `+0x61` 指向一个 **dispatch/指针表**（VM 相关），非密码 S-box。

因此"静态 S-box 可离线读出"的假设**不成立**。真实的密码 S-box 要么在 heap（key 派生、
pid 42948 未 dump），要么经该指针表间接寻址。缺口仍为：**S-box 内容 + key 字节**（均在
pid 42948 heap，本地 dump 未覆盖）。
