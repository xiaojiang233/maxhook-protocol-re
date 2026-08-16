# MaxHook key-schedule 字节码程序 — 完整解码（第 122 轮）

日期：2026-08-14
范围：纯离线。数据源：活态 history（pid 42948）+ 解密 handler 表。

## 一、突破：完整解码 key-schedule 字节码程序

`reconstruct_dispatch_sequence.py` + `map_distinct_indices.py` 从活态 history 环缓冲 +
解密 handler 表，恢复出 key-schedule 的**完整 dispatch 索引序列**（202 次 handler 执行，
54 个 distinct 索引）。

## 二、解码的 54 个 handler（dispatch 索引 → body → 首指令）

关键 handler（密码核心）：

| 索引 | body | 角色 |
|------|------|------|
| `0x51f` (1311) | `0x180b8c7aa` | **字生产者**（最终密钥流字） |
| `0xe0` (224) | `0x180a02a99` | ARX 链 C |
| `0x5d` (93) | `0x1809bfebb` | ARX 链 B（keyed） |
| `0x43a` (1082) | `0x180b41fb8` | ARX 链 D |
| `0xb8` (184) | `0x18099089e` | ARX 链 A（字生产者） |
| `0x41a` (1050) | `0x1809a57e6` | dispatcher |
| `0x147` (327) | `0x1809f4736` | 链初始（milestone 17 证明） |
| `0x321` (801) | `0x1809da384` | 链初始 |

完整 54 个索引（执行顺序首见）：`0x628 0x5eb 0xe0 0x5d 0x43a 0xb8 0x356 0x219 0xf2 0x575
0x354 0x1f7 0x55f 0x309 0x5d5 0x2ce 0xd1 0x51f 0x41a 0x428 0x147 0x321 0x592 0x267 0x1e
0x12f 0x38e 0x536 0xd8 0x15d 0x165 0x59c 0x115 0x335 0x1de 0x26c 0x568 0x2c4 0x471 0x15a
0x3a6 0x3a1 0x14f 0x141 0x306 0x195 0x3ea 0x54d 0x134 0x181 0x81 0x264 0x562 0x3c`

## 三、意义

1. key-schedule 字节码程序**已完整解码**（54 个 handler 索引 + 执行序列），是确定性、
   纯离线解码（活态 history + handler 表，无需真机/活态 heap/key 字节）；
2. 这**纠正**了第 104 轮"操作码加密"的表述——dispatch 索引本身经 handler 表映射即为
   明文 handler，无需 rolling key 解密（rolling key 是 dispatch 内部的数据混合，非程序加密）；
3. 复现 key_schedule_expand() 的最后一步 = 按此 54-handler 序列 + 各 handler 的 ARX 语义 +
   key+nonce 初始状态执行，得到 47 字节状态 → fold → keystream。

## 四、剩余精确工程

1. 对 54 个 handler 逐一提取 ARX 语义（第 120 轮已覆盖核心 8 个，需扩展至全部 54）；
2. 确定 key+nonce 初始状态的写入（key-schedule 前缀，第 118 轮 4 次 dispatch 已证明）；
3. 代入执行 → 14 组校验对验证。

**第 123 轮补充**：`extract_handler_arx_semantics.py` 尝试用正则过滤提取 handler 的
context-slot 算术，结果 0 命中——因 Themida 把 context-slot 访问拆成多步寄存器间接
（`mov r13,rbp; add r13,0x6d; mov r13,[r13]; add r13,K; movzx r14,word [r13]`），
简单正则无法捕获。需**完整寄存器数据流符号执行**（如 milestone 17 的手工 `require()`
断言，或用符号执行器 angr/自定义 VM 状态跟踪）。这确认剩余工作是**符号执行 54 个
handler**（确定性、离线，但需符号执行工具，非正则可解）。

## 五、交付物

| 资产 | 路径 |
|------|------|
| dispatch 序列重建 | `reconstruct_dispatch_sequence.py` |
| distinct 索引映射 | `map_distinct_indices.py` |
| 本报告 | `MaxHook_keyschedule字节码程序_完整解码_2026-08-14.md` |
