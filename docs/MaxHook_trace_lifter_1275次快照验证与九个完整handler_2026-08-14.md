> **后续更新：** 本报告已被 `MaxHook_trace_lifter_1352次快照验证与14个完整handler_2026-08-14.md` 取代。

# MaxHook trace-guided lifter：1275 次动态快照验证与九个完整 handler

日期：2026-08-14  
范围：纯离线静态反汇编、Unicorn replay、真实 VM jump before/after 快照。

## 完成边界

本轮显著推进 VM INIT/key-schedule 语义，但协议端到端仍未闭合：

```text
independent key+nonce -> keystream: 0/24
independent tag:                    0/24
complete envelope:                 0/24
```

## 已注册的完整 handler

| trace target | body/family | 快照验证次数 |
|---|---|---:|
| `0x1809803d9` | `0x180ac2b8c` | 320 |
| `0x1809a57e1` | `0x180c02701` | 287 |
| `0x1809a3b86` | chain C / `0x180a02a99` | 170 |
| `0x18098257f` | chain B / `0x1809bfebb` | 158 |
| `0x18098202a` | chain D / `0x180b41fb8` | 133 |
| `0x1809815b2` | chain A / `0x18099089e` | 117 |
| `0x18098c63d` | `0x1809a4f60` 8-slot permutation | 49 |
| `0x1809dee32` | `0x1809a57e6` keyed dispatch | 34 |
| `0x180987adc` | `0x180bbe02d` 6-slot permutation | 7 |

总计：

```text
validated occurrences = 1275
context mismatches     = 0
stack mismatches       = 0
RSP delta mismatches   = 0
next key mismatches    = 0
next VIP mismatches    = 0
dispatch mismatches    = 0
```

## 验证强度

每个 occurrence 均从 jump 入口快照重建：

- VM context 前 0x200 字节；
- RSP 和 stack top 0x100 字节；
- 当前 VIP、rolling key、target。

执行独立 Python handler 后，与下一 jump 快照比较：

1. context 逐字节一致；
2. 已知 stack 范围一致；
3. RSP 变化一致；
4. next rolling key 一致；
5. next VIP 一致；
6. handler table 选择的 next target 一致。

对于会 pop 的 handler，旧快照没有包含 pop 后新暴露的更深栈尾；validator 只比较数学上仍已知的重叠区域，不把未知尾部误报为 mismatch。

## ARX families 的重要纠正

chain A/B/C/D 现均为完整 handler，不再只是 pre-stack prefix：

- 已包含动态 e5-derived pop/write；
- 已包含条件 slot `+8`；
- 已包含 rolling-key dispatch suffix；
- 已包含 VIP advance；
- 已通过全部可用 occurrence 快照。

其中 chain C 的 `word[VIP+6]`、chain A 的双 swap 和 `word[VIP+0x14]` 等纠错继续成立。

## executor 当前位置

从 700k snapshot 对应的真实 step 0 context/stack 起始，executor 已同步通过前 13 个 trace steps。当前第一处 unsupported：

```text
step         = 13
instr        = 646522
source       = 0x1809a585f
target stub  = 0x18099cfa9
handler body = 0x180c2ea8b
VIP          = 0x1814e9ef4
key          = 0xffff02f7
```

该 handler 是跨多个碎片、使用 native stack 编排的重度混淆路径。已生成：

```text
trace_handler_0x18099cfa9_cfg_disasm.txt
trace_handler_0x18099cfa9_dynamic_path_partial.txt
encrypt_vm_trace_handler_99cfa9_165k.json
```

700k 快照中该 target 有 3 个 occurrence，净效果包含：

- RSP `-0x10`（净 push 两个 qword）；
- `ctx+0xc5` 减 `0x10`；
- `ctx+0x5d` 更新；
- 数据依赖的 rolling-key 更新；
- VIP/dispatch 更新。

尚未用输出快照硬编码该净变化；必须继续从真实动态指令路径恢复一般语义。

## 核心产物

```text
trace_guided_vm_lifter.py
trace_guided_vm_lifter_report.json
encrypt_vm_jump_snapshots_700k.json
emulate_maxhook_encrypt_boundary.py
```

## 下一步

1. 补采 `instr=646522` 路径到下一 indirect jump 的完整 register trace；
2. 化简 `0x180c2ea8b` 的 native-stack 虚拟化片段；
3. 对其 3 个 occurrence 做独立 before/after 验证；
4. 注册后继续推进 executor；
5. 并行扩展已出现的其余简单 handler families，最终执行完整 4096 trace。
