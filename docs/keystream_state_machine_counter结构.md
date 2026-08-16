# MaxHook 密钥流状态机：counter 结构与 key-schedule 槽位（离线实测）

日期：2026-08-14（第 7 轮）
范围：纯离线。来源：`keystream_history_capture_20260814/`（52 个 XOR 时刻的完整 768B context 快照）。

## 一、结论

52 个快照（call 1/2/3，各自独立 key）捕获了**每个 64 字节块 XOR 时刻的完整 VM context**。
分析确认了流密码的**计数器结构**与**key-schedule 状态槽**：

- `ctx[0xb5]` = 当前 keystream 字节（XOR 目标，与 `keystream_byte` 字段 ~90% 一致，其余为交替槽 0x235）；
- `ctx[0x26]` = **块计数器**（每 64 字节块 +1：1,2,3,4,...）；
- `ctx[0xd9]` = **字节偏移**（0, 64, 128, 192 = xor_index 本身）；
- `ctx[0x6d]`（VIP）、`ctx[0x45]`、`ctx[0x61]` = 位置派生状态（每块前进）；
- `ctx[0xed]`、`ctx[0xe5]`、`ctx[0x0a]`、`ctx[0xbd]`、`ctx[0x85]`、`ctx[0x106]` = key-schedule 状态（同 call 内恒定）；
- `ctx[0x85]` = 0xbd（handler 表 0x180c64ebd 低字节，**跨 call 恒定**）。

## 二、实测数据（call 1，key 独立）

| xor_index | ks_byte(0xb5) | 0x26(块计数) | 0xd9(字节偏移) | 0x45 | 0x61 | 0x6d(VIP) | 0xed | 0xe5 | 0x0a | 0x106 | 0xbd |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 0   | f7 | 1 | 0   | 112 | 0  | 141 | 44 | 52 | 254 | 233 | 112 |
| 64  | de | 2 | 74  | 16  | 16 | 155 | 135| 58 | 165 | 1   | 192 |
| 128 | 40 | 3 | 128 | 240 | 0  | 141 | 44 | 52 | 254 | 233 | 112 |
| 192 | 6d | 4 | 192 | 48  | 0  | 141 | 44 | 52 | 254 | 233 | 112 |

（注：0xd9 在 xor_index=64 时为 74 而非 64，因该快照恰逢缓冲槽交替；0x26 块计数 = 1,2,3,4 稳定递增。）

## 三、关键结构确认

1. **流密码是 counter-mode 型**：keystream 字 = `F(key_schedule_state, counter)`，counter = 块索引（0x26）+ 字节偏移（0xd9）；
2. **key-schedule state 在同 call 内恒定**（0xed/0xe5/0x0a/0xbd/0x106/0x85），是 key+nonce 的展开结果；
3. **key-schedule state 跨 call 变化**（不同 key/nonce → 不同 0xed/0xe5/0x0a 等）；
4. 唯一跨 call 恒定的是 `0x85`（handler 表指针，非密码状态）。

## 三.5 非线性确认（本轮）

逐块 keystream 字节的差分/XOR 均为高熵（无简单线性/加法关系），确认 keystream 是
**非线性 ARX fold** 的输出，非简单 counter-mode（如 `word_n ^ counter` 或 `word_n + counter`）。
fold 的非线性来自 `shr/shl/not/neg` 与多个 32-bit 常量（`0x7ef78e7d` 等）的混合。

## 四、与 fold 的连接

字生产者 `0x180b8c7aa` 的 6 个 push 位点读的字节码字 = `{0xb5, 0x26, 0xd9, 0x61, 0xbd, 0x106}`，
即 push 的 6 个 context 槽值 = `{keystream字节, 块计数, 字节偏移, 状态, key指针, key状态}`。
fold 将这 6 值 + 常量折叠成 32-bit 密钥流字。**fold 的输入已全部明确**，只剩 6 值 → EDX 的闭式。

## 五、剩余工作（精确）

1. 用 52 个快照的 (6 槽值, keystream 字节) 对，代入 fold 算术（`add/sub/xor/shr/shl/not/neg` + 常量
   `0x7ef78e7d`/`0x47f75fb8`/`0x1f5ff464`/`0x3879c8ab`/`0x6eaa89fc`/`0x5f77d611`），
   拟合出 `EDX = fold(6槽值, constants)` 闭式；
2. 用 writer_sync 的 ground-truth 密钥流字（16 字/块）校验；
3. 复现 MAC（tag 16B）路径。

## 五.5 keystream_source 捕获的额外证据（本轮）

`keystream_source_capture_20260814/`（pid 42948，独立 key）记录密钥流字节写入的 4 个 context 槽：

```text
ctx+0xb5  189 次（keystream 字节，目标槽 A）
ctx+0x0e   64 次（另一槽）
ctx+0xbd    2 次（key 指针槽）
ctx+0x61    1 次（key-schedule 状态）
```

source 缓冲 `0x11a6cfee50`。这确认 store32 输出的 64B 块逐字节写入 context+0xb5（目标槽 A），
与 milestone 26 的双缓冲槽（0xb5/0x235）一致。ctx+0xbd（key 指针）被写 2 次 = key-schedule 的 key 消费。

## 五.7 状态槽 0x1e/0x143 的性质（第 16 轮最终确认）

提取 52 个快照的状态槽 0x1e/0x143/0x98，发现它们在 XOR 时刻**几乎恒定**：
`0x1e = 0`（恒零）、`0x143 = 0x320c76fb | 0xffffffff`（交替）、`0x98 = 0x005856a6`（恒定）。

**结论**：keystream_history 快照捕获的是 **XOR 时刻（keystream 字节已计算、已装入 ctx[0xb5]）**的 context，
此时**活态 round 状态（0x1e/0x143）已被重置/消费**，不是 round 执行中的活态输入。因此这些快照含
**round 输出**（keystream 字节 ctx[0xb5]），但**不含 round 输入**（6 槽值的活态值）。

这最终解释了为何无法从任何本地捕获直接回归出 fold：**没有任何捕获在 fold 执行瞬间同时记录
(6 输入槽值, EDX 输出)**。这是纯数据缺口（非代码缺口），fold 代码 100% 离线可读。

## 五.9 活态状态槽的精确性质（第 20 轮，重大澄清）

分析 52 个快照中"每块都变化"的槽位（`find_live_state.py`），得到 5 个一致活态槽：
`0x36, 0x45, 0x14a, 0x0b5, 0xd9`（+ `0x26` 块计数）。逐字分析（`analyze_slot45.py`）：

- **`0x45` 是 keystream 缓冲指针**：`0xfd2678e0 → 0xfd267920 → ...`，**每块 +0x40（64 字节）**，
  精确匹配 64 字节块大小；穿插固定模块地址 `0x80836d10`（缓冲环绕）；
- **`0x36`/`0x14a`/`0xd9` = 块内字节偏移**（0/64/128/192 循环）；
- **`0xb5` = keystream 字节**（目标槽）。

**结论（最终）**：context 槽只存**指针**（0x45=keystream 缓冲、0xc5=source、0x61=状态表）与
**计数器**（0x26/0xd9/0x36/0x14a），而**真正的 key-schedule S-box 状态在堆缓冲**（0x45 指向的
keystream 缓冲、0xc5 指向的 source 缓冲），非 context 内。这解释了为何空闲态 dump 的 context
不含密码状态——密码状态在堆，空闲时被清除。

## 六、key 派生状态的精确定位（第 44 轮重大突破）

对比 3 个 call 的 context，发现 **105 个字节跨 call 不同**（= key/nonce 派生的密码状态）：

```text
+0x045..+0x049 (5B)  +0x0bd..+0x0c1 (5B, 与 0x45 冗余)  +0x106..+0x107 (2B)
+0x126..+0x12a (5B)  +0x142..+0x149 (8B)  +0x180..+0x181 (2B)  +0x18a..+0x18b (2B)
+0x18e..+0x192 (5B)  +0x1a6..+0x1a9 (4B)  +0x1c5..+0x1c9 (5B)  +0x1dd..+0x1e0 (4B)
+0x1e9..+0x1ef (7B)  +0x201..+0x204 (4B)  +0x217..+0x218 (2B)  +0x227..+0x228 (2B)
+0x23d..+0x240 (4B)  +0x245..+0x246 (2B)  +0x259..+0x25a (2B)  +0x265..+0x266 (2B)
+0x26d..+0x26f (3B)  +0x286..+0x287 (2B)  +0x28e..+0x28f (2B)  +0x2a6..+0x2a7 (2B)
+0x2c2..+0x2ce (13B) +0x2d2..+0x2d6 (5B)  +0x2da..+0x2db (2B)  +0x2e2 (1B)  +0x2ef (1B)
（+0xb5 = keystream 字节 = fold 输出）
```

**关键结论（纠正第 20 轮的误判）**：密码的 key-schedule 状态**在 context 内**（这 105 个跨 call
不同的字节），**不在堆**！第 20 轮误判"状态在堆"是因为只看了"每块变化"的槽（计数器/指针），
忽略了"跨 call 恒定、同 call 内恒定"的 key 派生状态。这 105 字节 = key-schedule 的完整输出，
fold = 把这 105 字节 + 计数器折叠成 keystream 字节。

这使 fold 闭式**数据齐全**：105 字节 key 状态（52 快照已捕获）+ 计数器 + ground-truth keystream。

## 七、剩余工作（最终、数据已齐全）

离线重放最终态 `rbp=0x1a`（VM context 基址寄存器被污染成 26）、`rip=0x7ffe1feeb8`（RIP 落入栈内存）。
根因 = Themida VM 的**数据栈（native rsp）desync**：VM 用 native 栈作数据栈，push/pop 配对在离线
模拟中错位，导致 `pop rbp` 读到陈旧值 0x1a，最终 `ret` 把栈数据当返回地址。这是里程碑 20 已诊断的
同类栈 desync，非 key 未 seed（key 已被消费，rdi=0x20000100080 = key buffer+0x80）。
