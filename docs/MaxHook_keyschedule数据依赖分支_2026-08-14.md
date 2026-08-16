# MaxHook key-schedule 精确剩余 — 数据依赖分支（第 128 轮）

日期：2026-08-14
范围：纯离线。

## 一、关键发现：dispatch 链已扩展到 level 22，level 23 遇数据依赖分支

读 `vm_dispatch_chain_extended.json`（既有产物）发现，此前已有 session 用 **Unicorn 具体执行
+ 持久 context** 把 dispatch 链静态走到了 **level 22**，且 level 5-22 的 key_after 全部与
emulator 交叉验证一致（`match: true`）。

**level 23 分歧**（`divergence` 字段）：
- handler `0x1809b6a53` 的 dispatch `jmp r9`，索引表达式 `((word[VIP+6]-key)-0x6554fdd7)&0xffff`
  得 index=0x798，table[0x798]=`0x9024b4ff5f`（无效，非 handler stub）；
- **根因**：level 22 在 `0x1809d2df4` 写 `context+0x162 |= 0xf1`（`0x69→0xf9` 自修改标志字节），
  且 level 22 有**数据依赖分支**（`cmp` at `0x1809d2d81`），该分支取决于 key 派生的 context 状态。

## 二、对之前结论的精确修正

1. **第 107 轮"623 稳定 4-gram = 控制流 key 无关"** 仅适用于 **ARX 循环（level 5-18）**；
   完整 key-schedule（level 19-23+）有**数据依赖分支**（level 22 的 `cmp` 依赖 key 派生状态）。
2. **第 118 轮"静态可完全解码"** 需细化为：level 5-22 可静态解码（已证），level 23+ 需
   **key 派生的 context 状态**（数据依赖分支）才能确定正确 dispatch 路径。

**第 129 轮补充**（`examine_level22_branch.py`）：level 22 的 `cmp` at `0x1809d2d81` 是
`cmp qword ptr [r11], rdx`——比较**context 槽值**（`[r11]` = `[ctx+0x6d]+4` 间接读的槽）与
**常量派生值**（`rdx = 0x20|0x88+4` 混淆）。即分支判断"某状态槽 == 某常量"，该槽值由 key
派生（key-schedule 状态），故**分支确实 key 依赖**。这确认了 level 23 分歧的根因是
**key 派生的数据依赖分支**，非位置/计数器。

**第 130 轮重要修正**（`analyze_level22_cmp.py`）：`cmp qword ptr [r11], rdx` 之后**无任何
条件跳转**（后续 30 条指令无 `jcc`），代码线性继续——故该 `cmp` 是**decoy**（置标志但标志
从未被消费）。level 23 分歧的**真正根因**是**自修改标志字节**：`0x1809d2df4 or byte ptr
[r12], sil`（`sil=0xf1`）写 `context+0x162 |= 0xf1`（`0x69→0xf9`），该标志字节门控 level 23
的 dispatch 路径。即：**非 key 依赖的条件分支，而是自修改标志字节**（其值取决于先前
key-schedule 状态，故最终仍 key 派生，但机制是标志字节门控而非 cmp 分支）。

## 三、精确的剩余工作

要继续 level 23+，需 level 22 时刻的**真实 context 状态**（含被自修改的 `+0x162` 标志字节 +
key 派生的分支输入）。这恰是 `keystream_history`（pid 42948）的 52 个快照所捕获的（活态 context），
但那些快照是 **XOR 时刻**（key-schedule 已完成），非 level 22 时刻。

因此：
- **静态路径**：level 5-22 已证，level 23+ 需 key 依赖状态（数据缺口，但**非"必须真机"**——
  需的是 level 22 时刻的 context 快照，本地 keystream_history 快照是 XOR 时刻，非 level 22）；
- **Unicorn 具体执行**：已有框架（`vm_dispatch_chain_extended.json` 的 method），继续需正确
  的 level-22 context 状态。

## 四、结论

fold 闭合的精确剩余 = **level 22 时刻的 key 派生 context 状态**（含自修改标志字节），以越过
level 23 的数据依赖分支。这是**数据缺口**（本地快照是 XOR 时刻非 level 22 时刻），非代码缺口、
非必须真机 Hook（正确路径 = 静态符号执行 level 5-22 已解码部分 + level 23+ 的 key 派生状态）。

## 五、交付物

| 资产 | 路径 |
|------|------|
| 本报告 | `MaxHook_keyschedule数据依赖分支_2026-08-14.md` |
| 既有产物（发现来源） | `vm_dispatch_chain_extended.json` |
