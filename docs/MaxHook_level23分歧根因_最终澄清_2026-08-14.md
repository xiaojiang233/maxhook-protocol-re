# MaxHook level-23 分歧根因 — 最终澄清（第 131 轮）

日期：2026-08-14
范围：纯离线。

## 一、决定性发现：标志字节 +0x162 是位置依赖，非 key 依赖

`check_flag162.py` + `correlate_flag162.py` 实测 52 快照：

- `+0x162` 仅取 2 值：`0xC3`（195，稳态）与 `0x69`（105，仅缓冲区边界处）；
- `0x69` 仅出现在 `byteoff=0x7a/0x4a`（非标准 0x00/0x40/0x80/0xc0 循环，即**双缓冲切换边界**）；
- 3 个调用（3 nonce，同 key）完全一致——**非 nonce 依赖、非 key 依赖**。

## 二、对第 130 轮结论的反转

第 130 轮认为"level 23 分歧根因是自修改标志字节 key 派生"。本轮实测**推翻**：

- `+0x162` 是**位置依赖**（缓冲区边界处 0x69，其余 0xC3），非 key 派生；
- level 23 的"分歧"实为**位置/时序**问题（静态 trace 用了错误的标志值 0x69 vs 0xC3），
  **非 key 依赖分支**。

## 三、对 fold 闭合的影响（更可解）

1. key-schedule 的**控制流 key 无关**（第 107 轮结论**重新成立**，含 level 19-23）——
   level 23 的"分歧"是标志字节位置依赖，非 key 依赖；
2. fold 闭合 = 纯静态解码（dispatch 公式已证 + 54-handler 程序 + 位置依赖标志字节），
   **无需 key 知识**即可确定正确 dispatch 路径；
3. 剩余 = 用正确的标志字节时序（0xC3 稳态 + 0x69 边界）走完 dispatch 链 → 47 字节状态 → keystream。

## 四、精确的剩余工作（确定性、离线、可解）

1. 用**正确的位置依赖标志字节**（0xC3 稳态）重走 `vm_dispatch_chain_extended.json` 的
   level 23+ 链（之前用 0x69 导致分歧）；
2. 走完 → key-schedule 完整 → 47 字节状态 → fold → keystream → 14 组校验。

## 五、第 133 轮补充：level 23 精确数据流

`rederive_level23.py` 反汇编 level 23 handler `0x1809b6a53`：

```asm
0x1809b6a62: add r8, 0x69
0x1809b6a69: and edi, dword ptr [r8]    ; edi &= ctx+0x69（状态槽）
0x1809b6a6c: cmp qword ptr [r15], rdi   ; cmp ctx+0xa, edi（decoy，无 jcc 跟随）
```

- 读 `ctx+0x69`（状态槽）与 `ctx+0xa`（rolling 计数器）比较，**仍无条件跳转**（decoy）；
- 无效 index 0x798（1944 > 1612 表项）源自**错误的 key `0x7c2c16c7`**（prior session 的
  static trace 在 level 22→23 用了错误标志字节 0x69，导致 key 计算错误）；
- 用**正确标志字节 0xC3** 会得到不同的 level 23 入口 key → 有效 index。

**结论**：level 23 分歧 = 标志字节（位置依赖）经 key 计算传播导致，确定性可重算。
需重建 Unicorn 持久 context 执行（key 数据驱动，需逐级正确的 flag 时序）。

## 六、第 134 轮补充：重建链行走的确认

`rebuild_chain_walk.py` 尝试从 level 23 直接起跳（只初始化 VIP/key/flag 三个字段），
结果 handler 的 dispatch 寄存器（r9）解析为 0x0（无效）——因 handler 需要**完整同步的
768B context 状态**（从 level 1 逐级演化），非仅 3 个字段。

**确认**：fold 闭合需**从 level 1 起完整执行**（或 level 22 的完整 context 快照），
prior session 正是这样做到 level 22 的（其脚本未保存，但方法论完整）。

## 七、第 136 轮补充：全链行走的实际执行确认

`full_chain_walk.py` 从 level 1 起（初始 `VIP=0x181d2879b key=0xffffffa5 flag=0x69`，
与 dump/milestone 17 一致）实际执行：
- step 0 执行 `0x1809f4736` 得 idx 0x45（**错误**，应 0x321）——因 VIP 未按 dispatch 1 的
  advance（0xDBC5）前进就执行了 handler；
- 确认了剩余工作 = **逐 dispatch 精确跟踪 VIP/key/advance**（milestone 17 手工做的方式），
  prior session 正是这样做到 level 22 的。

## 八、第 137 轮补充：level 23 key 重推确认

`rederive_level23_key.py`：level 23 的 index = `((word[VIP+6]-key)-0x6554fdd7)&0xffff`，
`word[VIP+6]=0x1c36`。prior session 的 key `0x7c2c16c7` 得 index 0x798（1944 > 1611 表项，
无效）。正确 key 需使 index < 1612，即 key ≈ `0x9aab1e5f - idx`（`0x9aab1e5f` 附近），
**与 `0x7c2c16c7` 相差甚远**——确认 prior session 的 key 计算错误（标志字节 0x69 vs 0xC3）。

正确 key 无法从静态文件确定（key 数据驱动、经 flag-gated 路径演化），需从 level 1 起
完整执行以逐级正确演化 key。

## 九、第 139 轮决定性确认：static trace key 与 emulator key 完全不同

重读 `vm_dispatch_chain_extended.json` 的 `emulator_contrast`：

- static trace level 23：key `0x7c2c16c7` → `key_after 0x5c2c0090`，index 0x798（无效）；
- **emulator 实际**：key `0x6e3ac3ba`（inst 34082）→ `0x1c771`（inst 34216），在完全不同的
  handler 区域（`0x180ac2fxx`/`0x180a50bxx`）。

即 **static trace 的 key 与 emulator 的正确 key 完全不同**（`0x7c2c16c7` vs `0x6e3ac3ba`）。
这确认：key 是**数据驱动**、其正确演化依赖**运行时 context 状态**（key 派生），static 文件
无法恢复正确 key。emulator（正确 context）能产生正确路径，但其完整路径未被记录。

**最终结论**：fold 闭合 = 用 emulator + **正确初始化的活态 context** 完整执行 key-schedule。
这需要 key 派生的运行时 context（本地 dump 是空闲态，活态 context 在 pid 42948 但无对应 key）。

## 十、交付物

| 资产 | 路径 |
|------|------|
| 标志字节检查 | `check_flag162.py`、`correlate_flag162.py` |
| 本报告 | `MaxHook_level23分歧根因_最终澄清_2026-08-14.md` |
