# MaxHook：nonce 后 VM stack trampoline 纯离线审计

日期：2026-08-14

## 1. 崩溃点

nonce buffer 已正确写入后，离线 replay 在：

```text
0x180c25a53 ret
instruction 4,163,003
```

handler 入口到 ret 的路径固定消费 `0x88` 字节，因此：

```text
ret target = qword[handler_entry_rsp + 0x88]
```

当前值：

```text
0x7ffe1feeb8
```

这里是旧 API stack 数据，不是可执行 VM code。

## 2. 有效 occurrence 对照

同一个 `0x180c25a53 ret` 的早期有效运行：

```text
instruction 596129  -> 0x1814fc181
instruction 882640  -> 0x1814f3dc6
instruction 3019341 -> 0x1814cbd40
instruction 3402025 -> 0x1814d5eb6
```

这些目标均是 `.bugland` 内以真实指令开始的动态 VM program blocks。

nonce 后 occurrence：

```text
instruction 4163003 -> 0x7ffe1feeb8  # stale stack data
```

## 3. 错误值的来源

ret handler 前一个关键 wrapper：

```text
outer target = 0x1809da83e
outer body   = 0x180c3b667
inner index  = 0x2ca
inner body   = 0x180a97f70
```

该路径：

```text
RSP delta = -0x130
```

最终 ret 使用的 qword 位于新 frame 的 `+0xa0`，但该地址在 handler 入口 RSP 以下，路径没有写入它；它依赖进入此路径前已经存在的深层 VM stack 内容。

因此当前缺口不是“ret 指令算错”，而是：

> 与 inner 0x2ca 配套的深层 VM stack/frame 没有被入口 capture 恢复。

## 4. 候选补丁实验

静态扫描得到 29 个包含 inner index `0x2ca` 的 generated-code blocks，并全部离线测试。

结果：

- 多数候选在 4.17M–4.28M 指令间因错误指针失败；
- `0x1812b8a4a` 和 `0x1812ceb5d` 可运行到 4.3M；
- `0x1812b8a4a` 可继续运行到 12M 指令、1560 次 word producer；
- 但所有候选均：

```text
nonce-buffer reads = 0
store32 hits       = 0
```

真实历史中的 stack-code 目标 `0x181523007` 也已测试，运行至 4.28M 后因后续 frame 指针错误失败。

结论：单独猜一个 generated-code 地址不足以恢复执行，不能作为实现。

## 5. 当前精确结论

```text
key absorption：已独立实现，替代 1664 VM jumps
nonce buffer：已正确写入
nonce consumption：尚未发生
离线阻断：inner 0x2ca 深层 VM stack/frame 缺失
```

下一步必须恢复 inner 0x2ca 的逻辑 frame 输入，或在高层直接重建其净 stack 语义，而不是继续替换单个返回地址。

## 6. 资产

```text
diff_ret_c25a53_vip_4163010.json
diff_trace_ret_handler_valid_596970.json
diff_trace_ret_handler_invalid_full_4163010.json
stack_producer_valid_summary.json
stack_producer_invalid_summary.json
inner_2ca_candidate_blocks.json
nonce_candidate_sweep_summary.json
ret_trampoline_semantic_candidates.json
```
