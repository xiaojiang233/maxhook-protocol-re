> **后续更新：** 本报告已被 `MaxHook_trace_lifter_1275次快照验证与九个完整handler_2026-08-14.md` 取代。

# MaxHook trace-guided lifter：动态快照验证与前四个完整 handler

日期：2026-08-14  
范围：纯离线 Unicorn replay + `.bugland` 静态反汇编。

## 状态边界

本轮推进的是 INIT/VM trace 语义恢复，不代表端到端协议已经复现：

```text
independent key+nonce -> keystream: 0/24
independent tag:                    0/24
complete envelope:                 0/24
```

## 1. VM jump 快照采集

`emulate_maxhook_encrypt_boundary.py` 新增：

```text
--snapshot-vm-jumps
```

每个 VM 间接跳转记录：

- 0x200 字节 VM context；
- RSP；
- RSP 起始的 0x100 字节 native/VM stack；
- target、VIP、rolling key。

700000 指令 replay 产物：

```text
encrypt_vm_jump_snapshots_700k.json
instruction_count = 700000
VM jump snapshots = 2262
```

这使每个 handler 都能从真实入口 context/stack 单独执行，并与下一 jump 的真实 context/stack 做逐字节 before/after 校验。

## 2. 已恢复的完整 handler

| trace target | body | 完整语义 |
|---|---|---|
| `0x1809a57e1` | `0x180c02701` | ARX 状态写入、动态 stack push、槽减 8、flag 更新、dispatch、VIP advance |
| `0x1809803d9` | `0x180ac2b8c` | 条件状态更新、ARX fold、动态 stack push、槽减 8、dispatch、VIP advance |
| `0x18098c63d` | `0x1809a4f60` | 8 槽 push/pop permutation、flag 更新、dispatch、VIP advance |
| `0x180987adc` | `0x180bbe02d` | 6 槽 push/pop permutation、dispatch、VIP advance |

以上四个 target 已注册到：

```python
dispatch_semantics_by_target
```

## 3. 强验证结果

对 700k replay 中所有属于上述 target 且有下一 jump 快照的 occurrence，逐项检查：

```text
context first 0x200 bytes
stack top 0x100 bytes
RSP delta
dispatch target
next VIP
next rolling key
```

结果：

```text
0x1809803d9: 320/320
0x1809a57e1: 287/287
0x18098c63d:  49/49
0x180987adc:   7/7
-------------------
total:       663/663
failures:      0
```

这是直接 before/after 字节一致性，不是仅检查结构或手工计算少量 fixture。

## 4. executor 推进

此前阻断：

```text
step 0 -> 0x1809a57e1
```

现可连续执行并同步前 12 个 trace step。当前第一处 unsupported：

```text
step         = 12
instr        = 646493
source       = 0x180bbe7a5
target stub  = 0x1809dee32
handler body = 0x1809a57e6
VIP          = 0x1814e7bc9
key          = 0x284a0410
```

## 5. 新的验证基础设施

`trace_guided_vm_lifter.py` 新增：

- `state_from_jump_snapshot()`；
- `snapshot_trace_step()`；
- `validate_registered_handlers_against_snapshots()`；
- `snapshot_state_for_trace_start()`；
- 每步 entry/exit 的 key/VIP 同步检查；
- 每步 dispatch target 检查；
- context/stack/RSP 的 occurrence 级全量校验。

未知 target、context 越界、stack underflow、trace key/VIP 偏离均 fail-closed。

## 6. 下一步

从 `0x1809a57e6` 开始恢复 step 12 handler，使用同一流程：

1. 静态提取全部 context/stack 写入；
2. 实现语义；
3. 对 700k 快照中的全部 occurrence 做逐字节验证；
4. 注册 target；
5. executor 推进到下一个 unsupported。
