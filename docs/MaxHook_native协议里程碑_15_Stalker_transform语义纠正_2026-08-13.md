# MaxHook native 协议里程碑 15：Stalker transform 语义纠正与证据重新分级

日期：2026-08-13 18:46（Asia/Shanghai）  
范围：审计本地捕获器源码、官方 Frida JavaScript API 说明、重跑全部离线分析；未附加进程、未联网游戏服务。

## 1. 必须纠正的根本问题

旧捕获器 [`capture_maxhook_vm_trace.js`](./capture_maxhook_vm_trace.js) 在 `Stalker.follow()` 的 `transform(iterator)` 回调中执行：

```javascript
while ((insn = iterator.next()) !== null) {
  acc.total++;
  acc.stats[insn.mnemonic]++;
  acc.counts.set(insn.address, old + 1);
  iterator.keep();
}
```

Frida 官方 API 对 transform 的定义是：当 Stalker 要重新编译即将执行的 basic block 时，同步调用 transform。官方把 `events.block` 描述为 coarse execution trace，把 `events.compile` 描述为 coverage。参见 [Frida JavaScript API / Stalker](https://frida.re/docs/javascript-api/#stalker)。

因此旧字段的真实含义是：

| 旧名称/注释 | 正确含义 |
|---|---|
| `total_instructions` | transform 处理的翻译/重翻译指令实例数 |
| `addr:count` | 地址进入 transform 的次数 |
| `top_mnemonics` | 被翻译代码实例的 mnemonic 混合 |
| `unique_addresses` | 在 MAX_UNIQ 前被记住的唯一翻译地址 |
| “执行次数/高频循环体” | 错误注释；没有 runtime hit 计数 |

每次约 202k 不能称为函数实际执行 202k 条指令；`count=1/2/3` 也不能解释为地址运行一/二/三次。

## 2. 哪些结论被撤回或降级

撤回：

- 不能由 mnemonic transform 计数声称动态 ARX 比例或“私有 ARX 流密码”；
- 不能把 `count>1` 当循环热度；
- 不能用所有旧表入口 `count=1` 排除实际 `jmp reg` 目标已在 translation cache；
- 不能把 `0x1809a585f` 后的下一行直接证明为 handler `index=0x5`；
- 不能把后续 7 个旧表反查值称为真实 opcode/index 流；
- 不能把 call 2 的 extra12 transform 集合称为已计数的运行时执行次数。

降级后的严谨表述：

- `0x18098b125 / old index 0x5` 是 5/5 一致的“dispatch 后下一个首次翻译候选”；
- 11 个 `jmp reg` 源地址的代码确实具备 `[RBP+0x0a/+0x6d/+0x85]`、表项加载、VIP 更新结构，所以“克隆 dispatcher 代码段”仍成立；
- 7 个旧表索引是首翻译地址的候选映射，不是已证运行时目标；
- extra12 是 call 2 独有的已翻译 trampoline；若运行进入，其静态净效果为 `qword[RBX]=0`，但旧数据没有 store hit 事件。

## 3. 哪些结论不受影响

以下都来自静态字节、ABI hook 或独立样本，不依赖 transform count：

- 外层加密函数地址与 5 参数布局；
- 7 组 `(key-material, nonce, plaintext, ciphertext, tag)` 验证集；
- qword table `T=0x180c64ebd` 的 1612 项结构；
- dispatcher 的 key/VIP/table 取值公式；
- 旧模拟因异步 key/VIP/寄存器/栈拼接而越界；
- VM 序言 80 条符号执行、全部 ABI 寄存器保持；
- dispatcher 早期 125 条 taint 重排：OUTPUT→R8，KEYMAT/CONTEXT/PLAINTEXT 的精确栈槽；
- `0x180c2c30c...` trampoline 本身的静态零写语义。

## 4. 已修正工具

- [`analyze_maxhook_vm_trace_coverage.py`](./analyze_maxhook_vm_trace_coverage.py)：schema v2，全部改称 translation statistics；
- [`recover_maxhook_vm_prefix_edges.py`](./recover_maxhook_vm_prefix_edges.py)：schema v2，只输出 first-translation candidates；
- [`analyze_maxhook_vm_branch_variants.py`](./analyze_maxhook_vm_branch_variants.py)：schema v2，区分 extra translated block 与 runtime hit；
- [`analyze_vm_trace.py`](./analyze_vm_trace.py)：删除“按 ARX 比例判密码算法”的判定，改为静态翻译地址混合报告；
- 总交接及里程碑 09–12 已同步改写，里程碑 13–14 的静态结论无需改变。

当前确定性输出：

```text
analyze_vm_trace.py
9dc518a13180cfab6dd93dc24d9f0b6210e73e9064473c08333b1c4f7e7e30ad
vm_analysis_translation_corrected.json
b8a86683a38601e7cf5f9df592447bc7e75486f4078ad91e6910d8117f446834

analyze_maxhook_vm_trace_coverage.py
3ffbcbdb4f724bd28ba558c414e9c14fa7d679d21dc4ee7cfc252036b5d7a539
maxhook_vm_trace_coverage.json
39276d42303aab87ed11d30df720c6f822f8f1d4890bf6708e00e86d18663629

recover_maxhook_vm_prefix_edges.py
4c1f293aef3807ce653ec8857de2f6a9b85bdb1cd16100346c55495a1af6a4f4
maxhook_vm_prefix_edges.json
49cb1843d0e8a6bc2fd3587157251fa0ecf4e526b63766af7e480b4b706c361e

analyze_maxhook_vm_branch_variants.py
e67f9c5601248e045d406caa51a991675a485535547709ec298f48aaa7ba9d0b
maxhook_vm_branch_variants.json
737945c00c4d0ff76f7babe797790e7f0f8c4b3b13c78317c7db96e44e8c03f2
```

## 5. 正确的动态证据方案

如将来有隔离、授权的本地环境，需要 runtime 顺序时应使用 Frida 的事件机制：

```javascript
Stalker.follow(tid, {
  events: {
    call: false,
    ret: false,
    exec: false,
    block: true,
    compile: false
  },
  onReceive(events) {
    const blocks = Stalker.parse(events, {
      annotate: true,
      stringify: true
    });
  }
});
```

`block:true` 给 coarse runtime block trace；`exec:true` 数据量极大，不建议直接启用。若只要覆盖，应使用 `compile:true` 并明确称 compile coverage。

鉴于之前线上会话进入风险状态，本报告没有创建或运行新的线上附加任务。当前继续路线仍是离线静态 taint：从 `0x180c441aa` 向后找 KEYMAT/PLAINTEXT/OUTPUT 第一次解引用。
