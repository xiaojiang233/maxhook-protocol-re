# MaxHook native 协议里程碑 11：确认 11 个克隆 dispatcher 代码段与旧表候选映射

日期：2026-08-13 18:25（Asia/Shanghai）  
范围：只读分析现有 `vm_trace_capture4` 和 `runtime_bugland2.bin`；未重新附加、未联网。

## 1. 结论

里程碑 10 得到的 11 个共同 `jmp reg → 下一个首次翻译地址` 中，间接跳转源不再只是“可能混有普通间接控制流”的候选。对每个跳转前的首次翻译分段做局部数据流模式扫描后，11/11 都明确派生并访问 VM context 的三个核心字段：

```text
[RBP+0x0a]  rolling key
[RBP+0x6d]  VIP
[RBP+0x85]  qword handler table pointer
```

而且每段都在尾部完成表项 qword 加载、VIP 更新和 `jmp <loaded register>`。因此，这 11 个跳转源可以确认是同一 Themida VM 的克隆 dispatcher 代码，不是一般控制流混淆产生的随机 `jmp reg`。但 transform 数据没有记录 `jmp reg` 的运行时目标，后继地址和旧表索引仍只是候选。

## 2. 共同 dispatch/首见地址前缀

5 次真实加密调用共同得到以下首次翻译前缀。`jmp reg` 后一行严格说是“下一个首次翻译地址”；即使它能反查到旧表入口，也不能仅凭 transform count=1 把它证明为直接 handler 目标：

| 段 | dispatcher 尾跳 | 下一个首次翻译地址 | 旧表候选索引 | 核心 context 签名 |
|---:|---|---|---:|---|
| 0 | `0x1809a585f jmp rax` | `0x18098b125` | `0x5` | `a,6d,85` |
| 1 | `0x180b6dc7a jmp r11` | `0x18098858f` | `0x355` | `a,5d,69,6d,85,162` |
| 2 | `0x180ae725d jmp r13` | `0x180efc825` | 未知 | `a,5d,6d,85,f6,162` |
| 3 | `0x180c04bc3 jmp r10` | `0x18098281b` | 未知 | `a,5d,69,6d,85` |
| 4 | `0x180a234d9 jmp rcx` | `0x1809d65f8` | `0x52e` | `a,5d,6d,85,f6,162` |
| 5 | `0x1809f2a47 jmp r15` | `0x1809da83e` | `0x166` | `a,5d,69,6d,85` |
| 6 | `0x180a7d782 jmp rdx` | `0x180aba715` | 未知 | `0,a,5d,69,6d,85,e5,f6,162` |
| 7 | `0x180aba95b jmp rbx` | `0x180988e62` | `0x536` | `a,6d,85` |
| 8 | `0x180af6759 jmp r14` | `0x1809a02e4` | `0x414` | `0,a,5d,69,6d,85,f6,162` |
| 9 | `0x180b19e04 jmp r9` | `0x180b5f316` | 未知 | `a,5d,6d,85,f6,162` |
| 10 | `0x1809b8b48 jmp rax` | `0x18098a6ba` | `0x26c` | `0,a,5d,69,6d,85,e5,f6,162` |

按旧 runtime 表反向映射得到的候选序列为：

```text
0005 → 0355 → ???? → ???? → 052e → 0166 → ???? → 0536 → 0414 → ???? → 026c
```

这 11 个首次翻译分段跨 5 次调用完全一致，说明对应代码布局和首次翻译路径高度稳定。它不证明每次运行时 handler 目标完全相同，也还不是完整加密轮。

## 3. 为什么 4 个索引仍未知

首翻译地址 `0x180efc825`、`0x18098281b`、`0x180aba715`、`0x180b5f316` 在旧 `runtime_bugland2.bin @ T=0x180c64ebd` 的 1612 个 qword 中没有反向条目。可能性包括：

- 当前捕获会话的表内容与旧异步 runtime dump 不同；
- 目标是表入口后的当前会话改写地址；
- 实际 `jmp reg` 目标已经在 translation cache 中，首翻译顺序跨过了它。

现有证据不能区分这三者，所以不能按地址相近、静态扫描或猜测补索引。要闭合它们，需要同会话 qword 表快照，或从对应 clone 的索引算术中恢复具体运行值。

## 4. 扩展到各调用的可见前缀

更新后的 [`recover_maxhook_vm_prefix_edges.py`](./recover_maxhook_vm_prefix_edges.py) 会对每个间接段自动检测 `mov reg,rbp → add reg,offset` 链：

| 调用 | 可见 `jmp reg` 段 | 同时命中 key/VIP/table 签名 |
|---|---:|---:|
| call 1 | 21 | 19 |
| call 2 | 22 | 20 |
| call 3 | 21 | 19 |
| call 4 | 22 | 20 |
| call 5 | 21 | 19 |

每次有 2 段没有被这个保守模式识别，原因是首次翻译序列会省略已在更高 translation-count 桶记录的中间指令；不能据此断言它们不是 dispatcher。共同前 11 段则 11/11 全部命中，证据最完整。

## 5. 新出现的 VM context 字段

除了已知 `+0x0a/+0x6d/+0x85`，克隆段反复派生：

```text
+0x5d, +0x69, +0xe5, +0xf6, +0x162
```

它们很可能是 VM 虚拟寄存器/flags/临时状态槽，但当前还没有读写值或稳定语义，报告只记录 offset，不命名。下一步将按各 handler 段对这些字段的读/写副作用聚类，从而区分 load/store/ALU/branch/状态更新 handler。

## 6. 对加密还原的实际意义

目前已经从“知道一个 dispatcher 公式”推进到“确认 11 个克隆 dispatcher 代码段和 7 个旧表候选映射”。这足以开始做代码段语义归一化，但还不能称为真实 opcode/index 流，更不能输出可复现加密函数，原因是：

- 这 11 周期位于 40k 地址截断前的固定前处理；
- 未获得每周期的 raw word、rolling key 与 VIP 实值；
- 明文/nonce 相关分歧大概率发生在截断点之后；
- tag 累积和收尾仍未定位。

最终完成条件不变：离线实现对 `crypto_verify_set.json` 7 组样本逐字节生成相同 ciphertext 与 tag。

## 7. 完整性

```text
recover_maxhook_vm_prefix_edges.py
4c1f293aef3807ce653ec8857de2f6a9b85bdb1cd16100346c55495a1af6a4f4

maxhook_vm_prefix_edges.json
49cb1843d0e8a6bc2fd3587157251fa0ecf4e526b63766af7e480b4b706c361e
```

脚本已通过语法编译、5 个真实捕获解析、精确 runtime 反汇编、首段静态连续性验证和两次输出哈希一致性验证。
