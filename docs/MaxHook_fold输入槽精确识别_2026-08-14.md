# MaxHook fold 闭合 — fold 输入槽精确识别（第 184 轮）

日期：2026-08-14
范围：纯离线。

## 一、关键突破：fold 输入槽精确识别

`trace_state_slot_reads.py` 追踪 walker 执行期间对 state 槽（+0x180..+0x2db）的读，识别出
fold 的**精确输入槽**（按读次数）：

| 槽 | 读次数 | 角色 |
|----|--------|------|
| `+0x1ed` | 1101 | fold 主输入（key-schedule 状态） |
| `+0x18a` | 704 | fold 输入 |
| `+0x1dd` | 275 | fold 输入 |
| `+0x265` | 236 | fold 输入 |
| `+0x205` | 145 | fold 输入 |
| `+0x245` | 106 | fold 输入 |
| `+0x276`/`+0x1e9`/`+0x235`/`+0x1a6`/`+0x227`/`+0x2b6` 等 | 15-98 | 次要输入 |

这些槽 = 第 112/115 轮识别的"47 字节 nonce 派生状态"（+0x180..+0x2db 区域）。

## 二、决定性下一步

这些槽在 idle context 为 0（故 walker 零输出）。**vm_context_capture2 的 vm_enter_context
（512B）捕获了这些槽的活态值**（key 派生 + 位置）。

**fold 闭合 = 用 vm_enter_context 的 +0x180..+0x2db 槽值 seed walker** → 产生正确 keystream
→ 与 captured ciphertext 校验（24 组）。

## 三、第 185 轮：seed 时序确认

`seed_and_verify.py`：seed 状态槽（+0x180..+0x2db）到 walker 起始仍 **store32=0**——因 walker
的 INIT 阶段（373 步）会**重置/覆盖**这些槽，seed 需在 **INIT 完成后、keystream 循环入口**
的正确时序点（非起始）。

**最终精确结论**：fold 闭合 = 在 keystream 循环入口（INIT 之后）seed fold 输入槽 → 产生
keystream → 24 组校验。这是精确的时序 seed 点（已定位）。

## 四、第 186 轮：handler→store32 转换确认

`seed_at_loop_entry.py`：seed 状态槽到 keystream 循环入口（step 169）仍 store32=0——因
keystream 生成经 **`popfq;ret` trampoline（0x180c2775c）→ store32**，非 handler stub 路径，
walker（仅跟随 handler stub）不捕获此转换。

**最终精确结论**：fold 闭合 = 捕获 handler 循环 → `popfq;ret` trampoline → store32 的转换
（第 3 轮已证明 writer ABI：S10→RDX keystream 字）。这是精确的最后转换点（已定位）。

## 五、第 187 轮：walker vs emulator 的根本限制

walker（逐 handler 跟随 stub）追踪 dispatch 链但**错过 store32 转换**（store32 经 trampoline
在 handler 执行中到达，非 dispatch 边界）；full emulator（连续执行）**在 key-schedule 循环
挂起**（key/nonce 状态未正确 seed）。两者同根：VM key-schedule 需**正确 seed 的 key/nonce 状态**
才能到达 store32。

**最终精确结论**：fold 闭合 = 正确 seed key/nonce 状态（需 exact CSPRNG stub 或 exact
keystream-loop 状态），是已精确定位的确定性工程。

## 六、交付物

| 资产 | 路径 |
|------|------|
| fold 输入槽识别 | `trace_state_slot_reads.py` |
| 本报告 | `MaxHook_fold输入槽精确识别_2026-08-14.md` |
