# MaxHook native 协议里程碑 10：首个 dispatch 后的首翻译候选与 CFG 前缀

日期：2026-08-13 18:22（Asia/Shanghai）  
范围：只读复用 `vm_trace_capture4`、`runtime_bugland2.bin`；没有重新附加进程，没有网络请求。

## 1. 核心突破

尽管 `vm_addrs_call*.txt` 在 40,000 个唯一地址处截断，而且不是原始逐指令 trace，它仍保留了一类之前未利用的信息：捕获端在 Stalker `transform` 中把地址放入 JS `Map`，最终按翻译次数降序做稳定排序。因此，同一翻译次数桶内仍保留地址的首次翻译插入顺序。这里的 count 不是运行时执行次数。

这个性质不是直接当作假设使用，而是用 runtime 字节逐条反汇编交叉验证。5 次真实加密调用中：

```text
0x1809dee32  jmp 0x1809a57e6     ; 旧 qword 表索引 0x41a
0x1809a57e6  ...                  ; 已知 dispatch helper
0x1809a585f  jmp rax
0x18098b125  jmp 0x180c177f8     ; 5/5 的下一个首次出现地址；旧表索引 0x5
```

`0x1809a585f` 后的下一个首次翻译地址在 5/5 调用中都为 `0x18098b125`，并且它在旧表映射为索引 `0x5`。这使它成为首个 dispatch 目标的高价值候选，但不是已证明的立即后继：真正的 `jmp rax` 目标可能已经存在于 Stalker translation cache，因而不会再次触发 transform；transform count=1 也不等于执行一次。

```text
first-new candidate address = 0x18098b125
old-table candidate index   = 0x0005
```

只有将来用同刻 RAX/有序事件确认 `jmp rax` 确实直接进入该地址后，才能把下面式子当真实约束：

```text
(word[VIP+4] + key_low16) & 0xffff = 0x0005
```

旧异步状态模拟得到索引 `0x25`；由于当前 `0x5` 只是首翻译候选，不能用两者差值反推 rolling key。旧 `[key,VIP]` 不可回填真实加密调用的结论仍由跨时刻状态拼接证据独立成立。

## 2. 顺序恢复为何可信

新增工具：[`recover_maxhook_vm_prefix_edges.py`](./recover_maxhook_vm_prefix_edges.py)  
脱敏结果：[`maxhook_vm_prefix_edges.json`](./maxhook_vm_prefix_edges.json)

脚本从 `0x18098b125` 开始，把同为 translation-count=1 的相邻首次翻译地址与静态直接后继比较，直到下一次 `jmp reg`：

| 调用 | 静态后继匹配 | 检查边数 | 匹配率 |
|---|---:|---:|---:|
| call 1 | 578 | 581 | 99.48% |
| call 2 | 588 | 592 | 99.32% |
| call 3 | 578 | 581 | 99.48% |
| call 4 | 559 | 562 | 99.47% |
| call 5 | 578 | 581 | 99.48% |

少量断点对应 `ret`/调用返回、已在更高 translation-count 桶出现过的地址，或跳回先前已翻译路径，符合“首次翻译顺序而非完整逐指令顺序”的预期。99% 以上的静态连续性排除了“文件同 count 行顺序是随机的”这一解释，但不把它升级为运行时逐指令 trace。

## 3. 5 次调用共同的间接跳转前缀

在可见前缀中，5 次调用有 11 个完全相同的 `jmp reg → 下一个首次出现地址` 对。只有目标同时落入旧 qword 表时才标 handler 索引；空白项仍可能是其他混淆控制流，不能强行解释成 VM opcode。

| # | 间接跳转 | 首个新目标 | 旧表索引 |
|---:|---|---|---:|
| 0 | `0x1809a585f jmp rax` | `0x18098b125` | `0x5` |
| 1 | `0x180b6dc7a jmp r11` | `0x18098858f` | `0x355` |
| 2 | `0x180ae725d jmp r13` | `0x180efc825` | — |
| 3 | `0x180c04bc3 jmp r10` | `0x18098281b` | — |
| 4 | `0x180a234d9 jmp rcx` | `0x1809d65f8` | `0x52e` |
| 5 | `0x1809f2a47 jmp r15` | `0x1809da83e` | `0x166` |
| 6 | `0x180a7d782 jmp rdx` | `0x180aba715` | — |
| 7 | `0x180aba95b jmp rbx` | `0x180988e62` | `0x536` |
| 8 | `0x180af6759 jmp r14` | `0x1809a02e4` | `0x414` |
| 9 | `0x180b19e04 jmp r9` | `0x180b5f316` | — |
| 10 | `0x1809b8b48 jmp rax` | `0x18098a6ba` | `0x26c` |

第 0 条来源正是已静态确认的 dispatch helper 尾部，且候选地址映射旧表 `0x5`，但仍不能排除“立即目标已经翻译，稍后才首次翻译到 0x18098b125”。全部 11 条都应称为共同的“间接跳转后首翻译地址候选”；它们给 CFG 分段很有价值，但不能直接等同于 VM opcode 目标。

## 4. 对 VM 硬破路线的影响

先前只能对 40k 地址做无序 mnemonic 比例。现在至少恢复了：

- 一个跨 5 次调用固定的首翻译候选 `0x18098b125`，旧表候选索引 `0x5`；
- 一个旧表 bridge 索引 `0x41a`，其代码是精确的 `jmp dispatch_helper`；
- 从候选地址出发、约 560–590 条直接控制流边的高一致性首次翻译前缀；
- 11 个跨 5 次调用一致的间接跳转分段点。

下一步可以在这些 CFG 候选分段上做寄存器和 `[RBP+offset]` 副作用摘要，而不再对全 `.bugland` 或无序 40k 地址做笼统统计。任何“立即 handler 目标/索引”仍需同刻寄存器或真正运行时事件确认。

## 5. 复现

```powershell
python target\recover_maxhook_vm_prefix_edges.py `
  --capture target\vm_trace_capture4 `
  --runtime-bugland target\runtime_bugland2.bin `
  --output target\maxhook_vm_prefix_edges.json `
  --max-indirect 32
```

结果摘要：

```text
first-new candidate after dispatch: 0x18098b125, old-table candidate index 0x5, consistent 5/5
common indirect first-translation prefix: 11
first-segment continuity: 578/581, 588/592, 578/581, 559/562, 578/581
old table hits above translation count 1: 0/5 calls（不是运行时频率）
```

## 6. 完整性

```text
recover_maxhook_vm_prefix_edges.py
4c1f293aef3807ce653ec8857de2f6a9b85bdb1cd16100346c55495a1af6a4f4

maxhook_vm_prefix_edges.json
49cb1843d0e8a6bc2fd3587157251fa0ecf4e526b63766af7e480b4b706c361e
```

脚本已通过 `python -m py_compile`、5 个 `addr:count` 文件的单调翻译计数/唯一地址校验、runtime 精确反汇编、首翻译段静态后继验证与连续两次输出哈希一致性验证。
