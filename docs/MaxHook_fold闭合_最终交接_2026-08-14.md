# MaxHook fold 闭合 — 最终交接（第 204 轮，含明文 key-schedule 完整数据）

日期：2026-08-14
范围：纯离线。

## 一、已完整定位（第 196-203 轮决定性突破）

### 明文 key-schedule（DLL .text，此前 96 轮遗漏）
- **位置**：`0x180322a20` 起的 helper dispatch wrapper 组合，key-schedule 主体 `0x180322b80+`
- **helper 表**：`0x1807bdc70`（16 函数，已分类 ARX 操作 + utility）
- **数据表**：`0x180658b48`（表1）、`0x1807c3ad0`（表2）
- **ARX 操作**：rol/ror/not/bswap/neg + XOR 常量（`0x44e924`/`0xffbb16db`/`0x7fcb1992`/
  `0xa4dbc339`/`0xacec895a` 等）
- **转换点**：VM INIT 373 步 → `0x180322bd3` 间接 call → 明文 key-schedule

### 转换点寄存器（第 203 轮实测）
```
r14/r13 = 0x1807bdc70 (helper 表)   r15 = 0x180658b48 (数据表1)
r12 = 0x1807c3ad0 (数据表2)          rcx=0 rsi=0 (需正确设置)
```

## 二、剩余精确步骤（3 步）

1. **确定输入 struct（rcx）布局**：wrappers 读 `[rcx]`/`[rcx+8]`，rcx = encrypt 的 R9（context
   对象）或派生结构，含 key/nonce 字段；
2. **正确设置转换点寄存器**：rcx=struct（含 key `32206F9C...` + nonce `c38d500a...`）+
   rsi=输出缓冲 + rdx/r8；
3. **执行明文 key-schedule**（Unicorn 具体执行，纯明文无 VM）→ 捕获 keystream → 24 组校验。

## 三、数据速查

| 项 | 值 |
|----|-----|
| key | `32206F9C196327AD276821AC8EBC7F80FE82D84CF72A4F7C1BAF508C97D3AEA8` |
| nonce | `c38d500ac2ae8d2611ae1749` |
| ground-truth keystream[0:8] | `9bd9300fdf47a800` |
| helper 表 | `0x1807bdc70` |
| 数据表1/2 | `0x180658b48` / `0x1807c3ad0` |
| key-schedule 入口 | `0x180322a20` |
| 转换 call | `0x180322bd3` |

## 五、第 206 轮：输入 struct = MSVC std::string 确认

- helper `0x18001ebb0` = `mov rax,[rcx+0x10]; ret`（读 capacity）；
- wrappers 读 `[rcx]`（data 指针）、`[rcx+8]`（size）；
- context 对象（R9）是 report-builder（含 "session_" 字段），非 key/nonce 缓冲。

**结论**：key-schedule 输入 struct = **MSVC std::string**（`{data_ptr, size, capacity}`），
key-schedule 处理 key（input64 hex string）+ plaintext 等 std::string 对象。helper 做 getter/
setter（读 data/size/capacity）。剩余 = 用 key+nonce 构造 std::string 输入，执行 → keystream。

## 六、第 207 轮：执行确认

`execute_keyschedule.py`：单 wrapper `0x180322a20` 执行无错误但 0 store32——key-schedule 是
**深调用链**（多 wrapper → helper → ARX），keystream 生成在链深处，非单 wrapper。剩余 =
执行完整 wrapper 链（正确 std::string 输入 key+nonce）→ keystream → 24 组校验。

## 七、第 210 轮：rsi（输入 struct 指针）来源确认

`trace_rsi_source.py`：转换点 `0x180322b70: mov rsi,rcx`，rsi 应 = 输入 struct（key/nonce），
但 walker 逐 handler 执行**丢失寄存器状态**，rsi = 垃圾 `0x2f354a6e`。rsi 由 VM INIT 阶段
正确建立（指向 key/nonce struct），需**连续执行**（非逐 handler）保留。

**精确剩余**：正确保留 VM INIT 建立的寄存器状态（rsi=输入 struct）→ 转换 → 执行明文
key-schedule → keystream。需 full emulator 收敛（或修正 walker 保留完整寄存器）。

## 八、第 211 轮：INIT 路径分歧确认

`continuous_execution.py`：连续执行 112,793 指令到转换点（RIP=0x18001ebb0），寄存器与 walker
一致（rcx=0 rsi=0）——**非 walker 伪影，是 INIT 路径分歧**：walker 的 373 步 INIT 在某处
与真实路径分歧（flag 字节/状态演化不完全正确），导致转换点 rcx=0（真实 encrypt 不会 crash）。

**精确剩余**：修正 INIT 路径分歧（正确 flag 字节/状态演化）→ 转换点 rcx/rsi 正确 →
执行明文 key-schedule → keystream。

## 九、第 212 轮：INIT 分歧极微小（flag 0x40 vs 0x41）

`trace_flag_evolution.py`：walker INIT 的 flag 字节 +0x162 演化到 **0x40**，vm_enter_context
（真实）为 **0x41**——**分歧极微小（1 bit）**。walker INIT ~95% 正确，分歧是某状态槽初始化的
细微差异。rcx=0 因 walker INIT 长度/终止与真实略不同。

**精确剩余**：修正 flag 演化的 1-bit 差异（0x40→0x41）→ 转换点 rcx 正确 → 执行明文
key-schedule → keystream。

## 十、第 213 轮：live context 起点确认

`walk_from_live.py`：从 live context（vip=0x181454d15, key=0xffff01a3, flag=0x41）起，
dispatcher `jmp reg` → tgt=0x0（VIP 是 mid-execution，dispatcher 无法从中间恢复）。

**精确剩余**：fold 闭合需从 key-schedule 起点（非 mid-execution VIP）以正确 flag 演化执行，
或修正 INIT flag 1-bit 差异。全部组件已定位，剩余是精确的状态初始化/演化修正。

## 十一、交付物

| 资产 | 路径 |
|------|------|
| 本交接文档 | `MaxHook_fold闭合_最终交接_2026-08-14.md` |
| key-schedule 反汇编 | `disasm_keyschedule_full.py`、`trace_keyschedule_fn.py` |
| 表 dump | `dump_key_tables.py` |
| helper 分类 | `disasm_new_helpers.py` |
| 转换点追踪 | `trace_transition.py` |
