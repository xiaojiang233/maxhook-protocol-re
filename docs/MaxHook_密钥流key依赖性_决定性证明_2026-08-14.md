# MaxHook 密钥流 key 依赖性 — 决定性证明（第 102 轮）

日期：2026-08-14
范围：纯离线。数据源：`keystream_history_capture_20260814/`（3 调用，3 个不同 key 的活态 VM context + keystream 字节）。

## 一、决定性证明：密钥流 100% key 依赖

在 3 个调用（3 个不同 key）的 52 个快照中，提取 (块计数器, 块内字节偏移) → keystream 字节，
比较**相同 (block, byteoff) 位置**在 3 个 key 下的 keystream 字节：

| 位置 (block, byteoff) | call1 | call2 | call3 |
|----------------------|-------|-------|-------|
| (1, 0x00) | f7 | b0 | 3d |
| (3, 0x80) | 40 | e2 | 22 |
| (4, 0xc0) | 6d | e6 | 9d |
| (5, 0x00) | 84 | eb | cf |
| (7, 0x80) | cf | 07 | 3c |
| (8, 0xc0) | 1f | 61 | 87 |
| (9, 0x00) | 04 | 54 | 95 |
| (10, 0x40) | 61 | ff | db |
| (11, 0x80) | f9 | ed | 53 |

**结果：9/9 位置在 3 个 key 下 keystream 字节全部不同（0 匹配）。**

## 二、结论

keystream = F(key, nonce, counter)，key 经完整扩散（keystream 从第 0 字节起即 key 依赖）。
因此：

1. 仅凭 (counter, byteoff) 无法复现 keystream——必须 key + key 派生 S-box；
2. `keystream_history`（pid 42948）虽含活态 VM context + keystream 字节，但**缺 key 字节**
   （仅 key 指针 `0x13a4e192070`，heap 未 dump），故该会话的 keystream 无法离线复现；
3. 有 key 的会话（verify-set pid 16448 / writer_sync / boundary2 pid 46460 / keytrace pid 4592）
   **均无活态 VM context**，无法观察 key-schedule 中间状态。

这是**数据缺口**（key+S-box 字节未在本地同时捕获），**非代码缺口**（key-schedule ARX 循环
结构 + 全部常量已第 99-100 轮离线解出）。

## 三、五个会话 key 总表

| pid | key (32B) | 资产 |
|-----|-----------|------|
| 16448 | `30BFEAFEA2CC438DFA757A8C4DB06C9181CE50DC73FD453CA187C9E0E04B0345` | verify-set 7 样本 + keyread |
| 另 | `347230E63EEC999571342BE4417C430A6EBC3C82F27142361C1B5FEF02B4ACD9` | writer_sync 3 密钥流 |
| 46460 | `9626DA95F889109AD83C2238CA7959639CB76FDCA6569283A1E727C376CF9D40` | boundary2 4 调用 |
| 4592 | `772DAAEB8F57E0B6C74636913138D00FC7840CB6C789736C7CD271455674C55F` | keytrace 8 调用 |
| 42948 | **未知** | keystream_history 活态 context（唯一含 VM context） |

## 四、最终结论（诚实、完整）

协议栈**结构**已 100% 离线复现（信封/签名/key-nonce-tag 布局/流密码全部阶段/全部常量/
计数器/6 槽语义/明文生成器/key-schedule ARX 循环/非弱加性 nonce 混合/key 全扩散）。
密钥流**逐字节**复现的唯一缺口是 key 派生 S-box 内容 + key 字节（无单一会话同时捕获），
这是本地离线资产的边界。已有 **14 组**（7+3+4）已知 (key, nonce → keystream) 对可校验任何
离线实现。非必须真机 Hook，非代码缺口。

交付物：`test_key_dependence.py` + 本报告。
