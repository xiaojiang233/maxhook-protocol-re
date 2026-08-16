# MaxHook trace-guided lifter：二级 wrapper 闭合并推进至 step 34

日期：2026-08-14

## 状态边界

```text
independent key+nonce -> keystream: 0/24
independent tag:                    0/24
complete envelope:                 0/24
```

## 1. `0x18099cfa9` 二级 VM wrapper 已闭合

三条 700k replay occurrence 均已获取完整动态路径：

| outer VIP | bswap logical stack slot | inner index | inner VIP RVA |
|---|---:|---:|---:|
| `0x181546f23` | 9 | `0x628` | `0x153990c` |
| `0x1814ee7d1` | 12 | `0x147` | `0x14e67b4` |
| `0x1814e9ef4` | 0 | `0x147` | `0x14e6a34` |

统一 frame 规则：

```text
1. 对 descriptor 指定的 logical qword 低 32 位执行 bswap；
2. 保留 qword[0..11]；
3. 复制 qword[11]；
4. 保留 qword[12..15]；
5. 丢弃 qword[16]；
6. 插入 inner index 和 inner VIP RVA；
7. 接回原 qword[17..]；
8. RSP -= 16；ctx+0xc5 = new RSP。
```

inner `0x628`：

```text
ctx[0x5d] |= 0x783ee292
ctx[0x0a] -= 0x660f5ddb
dispatch = word[innerVIP+0xe]
innerVIP += i32[innerVIP+0x12]
```

inner `0x147`：

```text
ctx[0x5d] |= 0x44ea80b1
rolling key unchanged
dispatch = word[innerVIP+6]
innerVIP += i32[innerVIP+2]
```

结果：wrapper `3/3` occurrence 的完整 context、0x100 stack、RSP、key、VIP、target 均匹配。

## 2. 新增完整 handler

本轮同时恢复：

- `0x1809d5d81 -> 0x180a73b12`
  - bytecode 驱动的 stack skip；
  - 动态 slot 增量；
  - key/state/flag 更新；
  - dispatch/VIP。
- `0x180988d5e -> 0x1809a37ff`
  - 两级 ARX fold；
  - 动态 sign-extended context write；
  - target cache `ctx+0xed`；
  - dispatch/VIP。

## 3. 当前验证

```text
registered targets             = 17
snapshot validated occurrences = 1380
snapshot failures              = 0
4096-trace covered steps       = 1836 / 4096
trace target coverage          = 44.82421875%
```

## 4. 连续 executor

此前：

```text
first unsupported = step 13 / 0x18099cfa9
```

现在：

```text
first unsupported = step 34
instr             = 652043
target            = 0x18098858a
body              = 0x180addfc6
VIP               = 0x1814f1745
key               = 0x10240
```

`0x18098858a` 是另一类多 inner-body wrapper；当前 step 34 路径选择 chain W：

```text
inner index = 0x1f7
inner body  = 0x180a725cb
```

入口/出口 stack 与 RSP 在该 occurrence 中不变，下一工作是恢复其 per-VIP inner descriptor 和 chain W 状态语义。

## 5. 新增分析工具和资产

```text
analyze_nested_wrapper_trace.py
nested_wrapper_step13_summary.json
nested_wrapper_second_summary.json
encrypt_vm_trace_handler_99cfa9_second_356000.json
encrypt_vm_trace_handler_99cfa9_trace_step13_complete_647750.json
encrypt_vm_jump_snapshots_registers_700k.json
```
