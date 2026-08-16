# MaxHook native 协议里程碑 12：首个跨调用分支与可证明的零写语义

日期：2026-08-13 18:31（Asia/Shanghai）  
范围：只读分析既有 `vm_trace_capture4`；没有重新附加、没有网络请求。

## 1. 结论

5 次真实加密调用的克隆 dispatcher 首次翻译前缀在段 0–10 完全一致。第 11 号 dispatcher 源地址仍全部相同：

```text
0x1809d9fae  jmp r12
```

但 call 2 随后的首次翻译分段比 call 1/3/4/5 多出恰好 12 个地址。随后 5 次调用的首次翻译集合在下一 dispatcher `0x180a73ede` 重新汇合，之后段 12–20 的 dispatcher 源与首翻译地址又完全相同。

这 12 条不是随机地址差集，而是一条可从 runtime 字节完整跟随的单入口、单出口 trampoline。若运行进入该 trampoline，它的净效果可静态化简为：

```text
qword [RBX] = 0
RDI 恢复为进入 trampoline 前的值
RSP 恢复为进入 trampoline 前的值
```

因此，已经恢复出第一个跨调用变化的已翻译 VM 支路语义候选：一次 8-byte 清零写。旧捕获没有真正的 runtime hit 事件，不能仅凭 transform count 证明该 store 的执行次数。

## 2. 两个路径簇

新增验证器：[`analyze_maxhook_vm_branch_variants.py`](./analyze_maxhook_vm_branch_variants.py)  
脱敏输出：[`maxhook_vm_branch_variants.json`](./maxhook_vm_branch_variants.json)

| 路径簇 | 调用 | dispatcher 11 到 12 的首翻译地址数 | 相对多数路径 |
|---|---|---:|---|
| A | call 1/3/4/5 | 342 | 基线 |
| B | call 2 | 354 | 完整包含 A，额外 12 条 |

集合关系是严格的：`B = A ∪ extra12`，没有 A 独有地址。它证明 call 2 额外翻译到该 trampoline，并回到共同代码布局；是否实际完成整条路径仍应由 runtime 事件验证。

## 3. extra12 的精确控制流

```asm
0x180c2c30c  push rdi
0x180c2c30d  jmp  0x180c2c6ac

0x180c2c6ac  push 0x6fcf2b9c
0x180c2c6b1  push qword ptr [rsp]
0x180c2c6b4  mov  rdi, qword ptr [rsp]
0x180c2c6b8  add  rsp, 8
0x180c2c6bf  add  rsp, 8
0x180c2c6c6  xor  edi, 0x6fcf2b9c     ; EDI = 0，且清零 RDI 高 32 位
0x180c2c6cc  jmp  0x180c2c32a

0x180c2c32a  mov  qword ptr [rbx], rdi ; 写 8-byte 0
0x180c2c32d  mov  rdi, qword ptr [rsp] ; 恢复原 RDI
0x180c2c331  add  rsp, 8               ; 恢复栈
```

`0x180c2c335` 起的后续代码在两类调用中都已翻译且 transform count=2，所以不在 extra12 集合里；这解释了 trampoline 的静态出口如何回到共同代码。

## 4. 不能过度解释的部分

目前不知道：

- 触发 B 路径的具体条件；
- RBX 在该时刻指向哪个对象/字段；
- 这个清零属于 key schedule、nonce 状态、输出结构初始化，还是 VM 自身临时槽清理。

地址捕获没有寄存器值，而且同 translation-count 的首翻译序列会省略已在 cache 中的公共地址；因此不能从 dispatcher 尾部看到 RBX 的完整建立链。这个差异发生在不同调用之间，但也可能由调用序号、对象复用、翻译 cache 状态或其他会话状态触发，当前不能直接称为“明文分支”或“nonce 分支”。

## 5. 对下一步的价值

这次结果证明首次出现顺序不只可以恢复 dispatcher，还可以从跨调用差分中提取实际副作用。后续处理将：

1. 对周期 0–20 的每个分段做跨调用集合差分；
2. 优先提取像 extra12 这样能完整闭合的单入口/单出口支路；
3. 将可证明副作用映射到 VM context offset 或参数/输出对象；
4. 找到首次接触 plaintext、nonce、key-material 和 ciphertext buffer 的分段。

## 6. 复现与完整性

```powershell
python target\analyze_maxhook_vm_branch_variants.py `
  --capture target\vm_trace_capture4 `
  --runtime-bugland target\runtime_bugland2.bin `
  --output target\maxhook_vm_branch_variants.json
```

```text
analyze_maxhook_vm_branch_variants.py
e67f9c5601248e045d406caa51a991675a485535547709ec298f48aaa7ba9d0b

maxhook_vm_branch_variants.json
737945c00c4d0ff76f7babe797790e7f0f8c4b3b13c78317c7db96e44e8c03f2
```

脚本已通过语法编译、5 调用首次翻译集合聚类、extra 集合严格覆盖验证、runtime CFG 全覆盖、零写模式识别和连续两次输出哈希一致性验证。
