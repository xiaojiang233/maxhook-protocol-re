# MaxHook key-schedule 字节码结构 — 明文操作数确认（第 104 轮）

日期：2026-08-14
范围：纯离线。数据源：`vm_handler_execution_trace.json`（4096 转换）+ `.bugland` region（`region_0000000180980000.bin`）。

## 一、关键发现：字节码操作数是明文

读取 handler trace 的 VIP（字节码指令指针，均在 `.bugland` `0x180980000..0x181efc000` 内）
处的 16-bit 字，发现 key-schedule 字节码是**明文操作数 + 加密操作码**的混合：

**明文槽偏移（直接出现在字节码，高频率）**：

| 字 | 频率 | 语义（= 字生产者 6 槽 + 其他） |
|----|------|------|
| `0x00b5` | 320 | +0xb5 密钥流字节槽 |
| `0x00d9` | 279 | +0xd9 块内字节偏移 |
| `0x0026` | 221 | +0x26 块计数器 |
| `0x0061` | 214 | +0x61 指针表槽 |
| `0x0106` | 207 | +0x106 状态值槽 |
| `0x00bd` | 164 | +0xbd key 指针槽 |
| `0x00c5` | 888 | +0xc5（循环/状态槽） |
| `0x016f` | 1411 | +0x16f（最高频，循环操作数） |
| `0x015a/0x0136/0x0152/0x000e/0x0097/0x0126/0x00a7/0x010e/0x009f/0x014a/0x045/0x01e` | ~40-230 | 其他状态槽 |

**加密操作码（高位 16-bit 值）**：`0x7dce`/`0x809a`/`0xb1d8`/`0x8000`/`0x13bf`/`0x6a07`/`0x475f`/
`0x7efa`/`0x5662`/`0x5ea7`/`0x5c55`/`0xc0c0`/`0xf0cb` 等（各 ~42-180 次）——这些是加密的算术操作码。

**哨兵**：`0xffff`（963×）、`0x0000`（998×）。

## 二、结论

1. key-schedule 字节码**离线可读**（`.bugland` dump 100% 覆盖），6 个字生产者槽偏移
   `{0xb5, 0x26, 0xd9, 0x61, 0xbd, 0x106}` 以**明文**形式嵌入字节码（与第 99 轮 ARX 循环
   的槽位语义完全一致，交叉验证）。
2. 加密部分仅是**算术操作码**（`0x7dce` 等高位字），操作数（槽偏移）是明文。
3. 完整复现 = 用 rolling key 序列（trace 的 `key` 字段）解密操作码 → 得到完整 key-schedule
   字节码程序 → 执行 → fold → store32。这是纯机械步骤，数据全部离线就绪。

## 三、与之前结论的关系

- 第 26 轮"字节码 16-bit 字加密"结论**部分修正**：操作码加密，**操作数明文**。
- 第 58-66 轮"生成器明文"与第 99 轮"ARX 循环"结论**再次交叉验证**：字节码中的明文槽偏移
  = 我提取的 ARX 循环槽位，两源独立一致。

## 四、第 106 轮补充：handler 表完整性与 dispatch 公式验证

`test_dispatch_formula.py` / `solve_rolling_key.py` 实测：

1. **handler 表完整性确认**：trace 的 177 个 distinct handler target **全部在解密 handler 表
   `0x180c64ebd`（1612 项）内**（177/177 命中），证明 handler 表有效且完整。
2. **dispatch 公式仍 imprecise**：公式 A `(word[VIP+4]+key)&0xffff` 仅 1/4096 命中，公式 B
   `(word[VIP]-key+0x5214a88c)&0xffff` 0/4096 命中。且从 (index - word) 反推的 key 与 trace 的
   `key` 字段不匹配（1/4096）。
3. **结论**：trace 的 `key` 字段是 emulator 在**空闲态 dump** 上的 rolling-key 追踪值，非精确
   dispatch rolling key（因 idle context 的 VIP/状态与真实加密不同步）。这再次确认：要精确解码
   操作码需活态 dispatch 轨迹，而本地唯一含活态 context 的会话（keystream_history pid 42948）
   只抓了 context 快照，未抓 dispatch 轨迹。

## 五、交付物

| 资产 | 路径 |
|------|------|
| 字节码解码脚本 | `decode_keyschedule_bytecode.py` |
| 字节码字流分析 | `analyze_bytecode_words.py` |
| dispatch 公式验证 | `test_dispatch_formula.py`、`solve_rolling_key.py` |
| 本报告 | `MaxHook_keyschedule字节码结构_2026-08-14.md` |
