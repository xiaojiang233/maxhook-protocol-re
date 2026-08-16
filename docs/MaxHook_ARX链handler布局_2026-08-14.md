# MaxHook ARX 链 handler dispatch 布局 — 精确提取（第 120 轮）

日期：2026-08-14
范围：纯离线。数据源：`.bugland` dump + handler 表 + 反汇编。

## 一、已精确识别的 handler VIP 偏移（ARX 链）

`classify_arx_handler_layouts.py` 反汇编各 handler 尾部，识别 `VIP = [context+0x6d]`
后的 `word[VIP+K]` 读取偏移：

| handler | body | 读取的 VIP 偏移 | 语义 |
|---------|------|----------------|------|
| A1 | `0x18099089e` | +4, +2 | 字生产者：push 2 槽值（`push [ctx+word[VIP+4]]`、`push [ctx+word[VIP+2]]`） |
| A2 | `0x180990a93` | (读 `word[0xe5]` 状态) | ARX 状态更新：`sub word[0xe5], r13w` |
| A3 | `0x180990b21` | +0, +6 | dispatch：idx=word[VIP+0]，读 word[VIP+6] |
| B1 | `0x1809bfebb` | +0x10, +0xa | idx=word[VIP+0x10]，key=word[VIP+0xa]（keyed） |
| B2 | `0x1809bff47` | (读 `word[0xe5]`) | ARX：`sub word[0xe5], ax` |
| B3 | `0x1809c012a` | — | `xor r13,r9` 折叠 |
| C1 | `0x180a02a99` | +6 | idx=word[VIP+6]，fold context+0xa |
| C2 | `0x180a02bcd` | +8 | `add word[0xe5], r14w` |
| C3 | `0x180a02c51` | +6 | `xor edi, [0xa]` 状态折叠 |

## 二、关键确认

1. **字节码是可静态解码的**：每个 handler 的 `word[VIP+K]` 偏移已可反汇编精确识别；
2. **VIP 偏移即字节码字索引**：`word[VIP+4]`/`word[VIP+2]` 等是字节码中的槽偏移（明文，第 104 轮）；
3. **keyed handler**（B1/C1）读 `word[VIP+0xa]` 作 rolling key（数据驱动，第 118 轮证明）。

## 三、完整解码的剩余工程

key-schedule 程序 = 这些 handler 的序列（控制流 key 无关，第 107 轮 623 稳定 4-gram）。
完整解码需：
1. 对全部 177 个 executed handler 做同样的 VIP 偏移提取（本脚本已覆盖 ARX 链核心 12 个）；
2. 按 dispatch 链顺序串联（第 118 轮 `walk_keyschedule_chain.py`）；
3. 代入 key+nonce 初始状态，执行 ARX 轮函数 → 47 字节状态 → fold → keystream。

这是**纯静态、确定性**任务，不依赖真机/活态 heap/key 字节。

## 四、交付物

| 资产 | 路径 |
|------|------|
| ARX handler 布局提取 | `classify_arx_handler_layouts.py` |
| 本报告 | `MaxHook_ARX链handler布局_2026-08-14.md` |
