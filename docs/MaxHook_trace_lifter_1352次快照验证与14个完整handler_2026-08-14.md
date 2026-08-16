> **后续更新：** 本报告已被 `MaxHook_trace_lifter_1380次快照验证与step34_2026-08-14.md` 取代。

# MaxHook trace-guided lifter：1352 次快照验证与 14 个完整 handler

日期：2026-08-14

## 完成边界

协议端到端仍未闭合：

```text
independent key+nonce -> keystream: 0/24
independent tag:                    0/24
complete envelope:                 0/24
```

## 完整 handler 覆盖

当前 `dispatch_semantics_by_target` 注册 14 个 target：

```text
0x1809a57e1  0x1809803d9  0x18098c63d  0x180987adc
0x1809dee32  0x1809ceaf1  0x1809a3b86  0x18098257f
0x1809815b2  0x18098202a  0x180981a92  0x1809816a2
0x180981ac9  0x1809ac339
```

包括：

- chain A/B/C/D 完整 ARX、stack、dispatch 语义；
- chain E swap/pop handler；
- 两个 VM state reset handler；
- 6/8 槽 permutation handler；
- 早期 keyed dispatch 和 INIT handler。

## 动态验证

700k replay 快照中的验证结果：

```text
validated occurrences = 1352
failures              = 0
```

每次检查 context、已知 stack、RSP delta、next key、next VIP 和 dispatch target。

完整 4096 transition trace 的静态目标覆盖：

```text
covered steps           = 1802 / 4096
coverage                = 43.994140625%
covered distinct target = 14 / 177
```

## Step 13 重混淆 handler

连续 executor 仍停在：

```text
step         = 13
trace target = 0x18099cfa9
wrapper body = 0x180c2ea8b
VIP          = 0x1814e9ef4
```

已补齐两条完整动态路径：

1. 早期 occurrence：内部索引 `0x628`，进入 `0x180c04899`；
2. 当前 step 13：内部索引 `0x147`，进入 `0x1809f4736`。

step 13 的 inner body 已精确恢复：

```text
ctx[0x5d].u32 |= 0x44ea80b1
ctx[0xc5].u64  = new_rsp
dispatch index = word[VIP+6]
VIP           += i32[VIP+2]
rolling key    unchanged
```

wrapper 在进入 inner body 前对 logical stack frame 做重排；step 13 路径明确执行：

```text
bswap r8d
```

对应入口 top dword：

```text
0x95080000 -> 0x00000895
```

该 wrapper 不是单一 ARX handler，而是 native-stack 驱动的二级 VM 调度器。尚未把三种已观察路径统一成独立的一般语义，因此未注册，保持 fail-closed。

## 新增资产

```text
encrypt_vm_trace_handler_99cfa9_complete_165400.json
trace_handler_0x18099cfa9_dynamic_path_complete_first_occurrence.txt
encrypt_vm_trace_handler_99cfa9_trace_step13_complete_647750.json
trace_handler_0x18099cfa9_dynamic_path_complete_step13.txt
```

`emulate_maxhook_encrypt_boundary.py --snapshot-vm-jumps` 现同时采集全部寄存器，新的 700k replay 正在用于后续 handler 的入口 ABI 恢复。
