# MaxHook trace-guided lifter：chain C 校正与 fail-closed executor

日期：2026-08-14  
范围：纯离线；数据源为 `runtime_bugland2.bin`、`vm_handler_execution_trace.json` 和静态反汇编。

## 结论边界

本轮**没有**复现 `key + nonce -> keystream`，也没有生成独立 tag/envelope。端到端状态仍是：

```text
independent keystream: 0/24
independent tag:       0/24
complete envelope:     0/24
```

本轮交付是 VM lifter 的语义纠错、真实 trace fixture，以及遇到未知 handler 时不猜测的执行框架。

## 1. chain C 的 `VIP+6` 已由指令路径确认

trace target：

```text
0x1809a3b86 -> jmp 0x180a02a99
```

关键指令：

```text
0x180a02acc  mov r11, [ctx+0x6d]       ; VIP
0x180a02ad9  add r11, 6
0x180a02ae0  movzx r14, word ptr [r11] ; raw = word[VIP+6]
```

首个真实 chain C trace fixture：

```text
trace index = 15
VIP         = 0x1814ebd29
word[VIP+6] = 0xd425
```

因此 `VIP+6` 不再是暂定猜测；它是 chain C 入口读取 raw word 的精确偏移。

## 2. 纠正旧的 chain C 简化式

旧 lifter 把 chain C 写成 `ctx[e5] += raw_word`，遗漏了 raw word 在写入前的变换和两个上下文副作用。静态指令路径给出的 pre-pop 语义是：

```python
raw = zext16(word[VIP+6])
transformed = raw ^ ctx[0x0a].u32
ctx[0x0a].u32 |= transformed
ctx[0x5d].u32 ^= 0x558a625a
if ctx[0x162].u8 > 0xfa:
    transformed -= 0x681b64d8
ctx[0xe5].u16 += transformed & 0xffff
ctx[0x0a].u32 -= 0x4dbfde8f
```

随后在 `0x180a02c1e` 出现：

```text
pop r9
mov [ctx + ((ctx[e5] + 0xd04c) & 0xffff)], r9
```

所以完整 chain C 仍依赖尚未闭合的 VM stack。`ctx[0x5d]` 的 bit0 条件加法位于该 pop/write 之后，lifter 现将它隔离为 post-stack 单元，避免把 partial prefix 冒充完整 handler：

```python
if ctx[0x5d].u32 & 1:
    ctx[0x5d].u32 += 0x6abd113b
```

## 3. 同步纠正 chain A 的 prefix

静态路径表明每个 chain A step 有两个槽交换，而不是一个：

```text
swap(ctx + word[VIP+4],    ctx + word[VIP+2])
swap(ctx + word[VIP+0x10], ctx + word[VIP+8])
```

状态字来自 `word[VIP+0x14]`，并先与 `ctx+0xf6` 混合；`ctx+0x162 > 0x30` 时还会加常量：

```python
transformed = zext16(word[VIP+0x14]) ^ ctx[0xf6].u32
ctx[0x0a].u32 += transformed
if ctx[0x162].u8 > 0x30:
    transformed += 0x531ca727
ctx[0xe5].u16 -= transformed & 0xffff
ctx[0x0a].u32 |= 0x33a09506
```

真实 fixture `VIP=0x1814ec9ab` 解码为：

```text
swap #1: 0x106 <-> 0x0bd
swap #2: 0x0b5 <-> 0x106
raw word: word[VIP+0x14] = 0xdae8
```

## 4. trace program executor

`trace_guided_vm_lifter.py` 现包含：

```python
dispatch_semantics_by_target[target](state, bytecode, step)
```

只有**完整 handler**才允许注册。chain A/C 当前都只恢复到 stack boundary，因此没有被错误注册。执行器在第一个未知 target 立即失败并输出：

```json
{
  "step_index": 0,
  "instr": 643030,
  "source": "0x180c02d8c",
  "target": "0x1809a57e1",
  "vip": "0x1814ef6e9",
  "key": "0xbfffdff7",
  "handler_body": "0x180c02701",
  "partial_semantics": null
}
```

这满足“未知 handler fail-fast，并给出 instr/VIP/key/body”的要求；没有生成 unconstrained 值。

## 5. 自动审计和测试

`trace_guided_vm_lifter_report.json` 当前结果：

```text
self tests:                         6/6 pass
chain A trace steps:                169
chain A swap operations:            338
chain A two-swap permutation:       bijection
chain A moved bytes:                96
chain C trace steps:                215
first chain C real VIP+6 fixture:    0xd425
executor first unsupported target:  pass
```

特别说明：`moved_bytes=96` 与旧报告相同并不意味着旧单-swap模型正确；加入每步第二个 swap 后，最终复合置换恰好仍移动 96 字节。报告现在输出完整的 two-swap permutation。

## 6. 下一步

第一处 executor 阻断已精确落在：

```text
target stub  = 0x1809a57e1
handler body = 0x180c02701
```

已导出其静态反汇编到：

```text
trace_handler_0x1809a57e1_body_disasm.txt
```

下一轮应恢复该 body 的完整状态/stack 语义，写 fixture，注册为 complete handler，然后运行 executor 到下一处 unsupported target。不要跳过 `0x180c02701` 去猜后续 cipher/tag。
