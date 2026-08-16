# MaxHook VM 字节码入口与格式（第 25 轮）

日期：2026-08-14（第 25 轮）
范围：纯离线。来源：`dump_out/41264/region_0000000180980000.bin` + 反汇编。

## 一、结论

密码是 **bytecode-compiled**：key-schedule + fold 是 `.bugland` 内的**静态 VM 字节码程序**，
16-bit 字，由 dispatcher `0x180a97f70` 逐字解释。字节码 100% 离线可读（dump 的 `.bugland`）。

## 二、VM 字节码入口（VIP）

- VIP = `context+0x6d` = `0x181d2879b`（dump 空闲态）
- VIP 在 `.bugland` 内偏移 = `0x13a879b`

## 三、字节码格式（16-bit 字）

dispatcher 核心（`0x180a9803c mov r11w, word ptr [rbx]`，rbx = VIP）读 16-bit 字，
`shl r11, 3`（×8）计算 handler 表（`0x180c64ebd`）索引，跳转到 handler。

字节码字两类：
- **小值**（`0x0045`/`0x00c5`/`0x00d9`/`0x000e`/`0x01cf`）= context 槽偏移（操作数）；
- **大值**（`0x2b5c`/`0x87ea`/`0x6b3b`/`0x7108`/`0x621a`）= opcode / handler 索引。

## 四、字节码样本（VIP 起 32 字）

```text
0x2b5c 0x01cf 0x0080 0x0045 0x87ea 0x6b3b 0x0000 0x7108
0x00c5 0x621a 0x00d9 0x3065 0x0000 0x00c5 0x154a 0x00c5
0x320d 0x0000 0x000e 0x1455 0xdc7b 0x809a 0x016f 0xdf6a
0x00c5 0x0152 0xcc0d 0xffff 0x5470 0x3171 0x696b 0x0000
```

可见熟悉的 context 槽偏移（0x0045、0x00c5、0x00d9、0x000e）与 opcode 混合。

## 五、闭合 fold 的正确路径（重新定性）

之前的"fold 需运行时 S-box 堆状态"结论**不完整**。正确路径是：

**S-box 状态 = 字节码程序 P 对 (key, nonce) 的计算结果**。字节码 P 是**静态的**（`.bugland` 内，
100% 离线可读）。因此 fold 闭式的正确路径是：

1. **静态解码字节码程序 P**（key-schedule + fold）：从 VIP 逐字解码 16-bit 字 → handler 表 →
   handler 语义；
2. 理解 handler 语义（1612 个，但 key-schedule 只用其中一小部分）；
3. 手工计算 `G(key, nonce) = P(key, nonce)`，无需运行时 S-box。

这是纯离线、纯机械的任务（解码静态字节码），**不依赖任何运行时状态**。之前的"堆状态缺失"是
对问题的错误定性——S-box 是字节码的**计算产物**，非必须抓取的数据。

## 七、字节码的加密（第 26 轮关键发现）

解码字节码字 → handler 表，发现**部分字映射到有效 handler、部分映射到垃圾值**：

```text
0x01cf -> 0x1809cefb3  ✓ 有效 handler
0x0080 -> 0x18098b0a2  ✓
0x0045 -> 0x180987a73  ✓（context 槽 0x45 的操作数）
0x00c5 -> 0x180987d4d  ✓（context 槽 0xc5 的操作数）
0x00d9 -> 0x18098519b  ✓
0x2b5c -> 垃圾（0x00458b4566000000）✗
0x87ea -> 0x0 ✗
0x6b3b -> 垃圾 ✗
0x7108 -> 垃圾 ✗
```

**结论**：字节码字是**用 rolling key 加密的**。大值（0x2b5c/0x87ea/0x6b3b/0x7108）是加密的 opcode，
需 rolling key 解密（`real_index = (word - key + 0x5214a88c) & 0xffff`，里程碑 17）；小值
（0x0045/0x00c5/0x00d9）恰好是明文 context 槽偏移（未被加密，或低 8 位巧合）。

这确认：静态解码字节码需**跟踪 rolling key 状态**（`context+0xa`，规则 `key ^= key + const`），
rolling key 随 dispatch 逐字前进。这解释了为何静态直接解码不可行——字节码加密依赖运行时 rolling key。

## 九、实际字节码执行轨迹（第 31 轮突破）

emulator 的 `vm_indirect_jumps` 捕获了**实际执行的 VM 字节码**（handler→handler 跳转图）：

- **4096 次 handler 跳转**（`vm_handler_execution_trace.json`）；
- **339 个 distinct handler**（1612 个总数中实际用到的）；
- 高频 handler：`0x180ac30e1`/`0x180c02d8c`/`0x1809803d9`/`0x1809a57e1`（~380 次，dispatch/循环）、
  `0x1809a3b86`/`0x180a02e9e`（215 次，算术）、`0x180aa7fa4`（202 次）等。

**这是闭合 fold 的关键数据**：字节码程序 = 4096 次 handler 执行的序列，每个 handler 是 VM 指令
（add/xor/load/store/dispatch）。解码 fold = 分析这 339 个 handler 的语义 + 4096 次执行序列，
手工复现 key-schedule → keystream 的计算。

## 十、handler 语义解码（第 32 轮突破）

反汇编 top handler，识别出 VM 指令语义：

**dispatcher `0x1809a57e1`（关键）**：
```text
edx = word[VIP+4]            ; 读 16-bit 字节码字 @ VIP+4
edx += [context+0xa]         ; + rolling key
[context+0xa] -= edx         ; 更新 rolling key（key -= index）
index = edx & 0xffff
handler = [context+0x85] + (index << 3)   ; handler 表查找
```

**精确 dispatch 公式**（纠正里程碑 17 的 `-key+0x5214a88c`）：
```text
index = (word[VIP+4] + rolling_key) & 0xffff
rolling_key 更新：key -= index
handler = table[0x85] + index*8
```

其他 handler：
- `0x180ac30e1`/`0x180c02d8c`/`0x180aa7fa4`/`0x1809c03a2` = `jmp reg` 派发尾；
- `0x1809803d9`/`0x1809a3b86` = **jump table**（17 项 jmp，dispatch 跳转表）；
- `0x180a02e9e` = 算术（读 `word[VIP+2]`，`sub [context+0xa]`）；
- `0x18098257f` = 条件 load（读 `word[VIP+9]`/`word[VIP+3]`，`sub`+`pushfq` 条件分支）。

**这使字节码解码完全可行**：dispatch 公式已精确（`index = (word[VIP+4]+key)&0xffff`，key 更新 `key-=index`），
handler 表已解密（`0x180c64ebd`），字节码 100% 离线可读。fold 闭合 = 追踪 4096 次 handler 执行的数据流。

## 十二、静态字节码解码的验证（第 33 轮）

用精确 dispatch 公式（`index=(word[VIP+4]+key)&0xffff`，`key-=index`）从 dump VIP 静态解码字节码，
部分字解码到有效 handler（`0x1809a2071`/`0x180980573`/`0x180992edf`/`0x18098257a`/`0x180981984`），
但多数解码到垃圾——因 dump VIP 是**空闲态**（非 key-schedule 初始 VIP），且 VIP 逐指令前进量依赖各
指令操作数大小（非固定）。

**结论**：静态逐字解码需正确初始 VIP + 逐指令 VIP 前进，而 emulator 的 `vm_indirect_jumps` 已直接
捕获**运行时实际 handler 序列**（4096 次），**无需手动解码**。`vm_handler_execution_trace.json` 就是
解码后的字节码。剩余工作是**分析 339 个 handler 语义 + 追踪 4096 次执行的数据流**（key+nonce →
key-schedule → fold → keystream），这是纯离线、纯机械的任务。

## 十四、handler 语义分类（第 34 轮）

反汇编 339 个 distinct handler 的 body（跳转目标），按语义分类（按执行次数）：

| 类别 | 执行次数 | 说明 |
|------|---------|------|
| load-store | 5264 | `mov reg,[context+offset]`（状态访问） |
| arithmetic | 2701 | `xor/add/sub/and/or/shr/rol`（密码算术 + 指针混淆） |
| stack | 73 | push/pop（VM 数据栈） |
| flags/compare | ~52 | pushfq/cmp（条件分支） |
| 其他 | ~76 | in/jbe/ud1 等（噪声） |

**83 个 arithmetic handler** 的 body 分析：多数是**指针去混淆**（`and rdi,0x400`、`or r8,0x7fffffff`、
`add rcx,0x20`、`and r12,0x3f` 等），`rol rbx,0x20` 是 32-bit 交换（非密码轮转，里程碑 23 确认）。
**真正的密码 fold 是 arithmetic handler 中操作 keystream 状态槽（0xb5/0x36/0x45/0x14a 等）的小子集**。

字生产者 `0x180b8c7aa`（stub `0x18098a77d`）确认在列表中。

## 十六、keystream 状态槽写入者追踪（第 35 轮）

追踪 70541 次 context 写入，得到各 keystream 状态槽的写入 handler：

| 槽 | 写入次数 | distinct 写入者 | top 写入者 |
|----|---------|----------------|-----------|
| +0xb5（keystream 字节） | 719 | 93 | `0x180bc072f`(62) `0x180bce813`(46) `0x180b6d426`(43) |
| +0x45（缓冲指针） | 1485 | 20 | `0x180aa7dc0`(246) `0x1809e6728`(196) `0x180bd46b7`(178) |
| +0x26（块计数） | 541 | 101 | `0x180bc086d`(62) `0x18099093c`(30) |
| +0xd9（字节偏移） | 607 | 107 | `0x180bc08f3`(62) `0x180bce79d`(44) |
| +0x36 | 145 | 7 | `0x180c3c91a`(44) |
| +0x14a | 94 | 8 | `0x1809c0078`(25) |

keystream 字节槽 +0xb5 的 93 个写入者 = 密码 fold 的多轮算术（每字节经多轮 add/xor/sub 产生）。
`0x180bd46b7`（字节泵，之前识别的）写 +0x45，是缓冲指针更新。

**fold 数据流已完全数据化**：93 个 +0xb5 写入者 + 719 次写入 = 完整 keystream 生成序列。
追踪这 719 次写入的操作数即可复现 fold。

## 十七、剩余工作（最终、已完全数据化）

1. 定位 key-schedule 的初始 VIP（非空闲态的 `0x181d2879b`，而是加密入口 `0x180324610` 设置的初始 VIP）；
2. 逐字解码字节码，映射到 handler；
3. 理解 key-schedule + fold 的 handler 语义；
4. 手工复现 `G(key, nonce)`，用 10 组已知明文对 + 7 验证集样本做 7/7 校验。
