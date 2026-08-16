# MaxHook native 协议里程碑 29：纠正 writer 调用语义并恢复虚拟栈 ABI（2026-08-14）

## 纠正两项关键误判

### 1. boot_unpacked 覆盖范围

```text
base = 0x180980000
size = 0x157c000
end  = 0x181efc000
```

因此 `0x181ad61e7`、`0x181afc7e7`、`0x181b7421e` 等均位于原版 `MaxHook.dll` 的 `.boot` 离线解压产物 `boot_unpacked.bin` 中。此前子报告将终点误算为 `0x180efc000`，进而错误称这些区域只能在运行态获得。

### 2. 0x181ad61e7 不是 call 后继

`capture_maxhook_writer_calls.js` 在 store32 入口读取 `context.rsp.readPointer()`，因此记录的 `return_address=0x181ad61e7` 只是 writer 入口 `[rsp]`。调用路径没有 `call` 指令，而是伪造完整寄存器帧后：

```text
0x180c27931 jmp 0x180c2775c
0x180c2775c popfq
0x180c2775d ret 0
                 -> 0x18041a860 store_le32
store32 ret      -> 0x181ad61e7 pushfq（VM 状态恢复续体）
```

因此虚构的 `0x181ad61e2 call store32` 和 `0x181ad61de EDX producer` 均不成立。

## 动态闭合的 writer 前缀

已有 `keystream_slot_changes_capture_20260814` 记录了真实块序列：

```text
0x180c278a7
-> 0x180c27786
-> 0x180c27652
-> 0x180c27bf9
-> 0x180c279b4
-> 0x180c27673
-> 0x180c27bd0   mov rdx,[rsp]
-> 0x180c27a5b   mov rcx,[rsp]
-> 0x180c27900
-> 0x180c2775c   popfq; ret
-> 0x18041a860   store_le32
-> 0x181ad61e7   continuation
```

## 符号执行恢复出的 trampoline ABI

`target/symbolic_writer_trampoline.py` 对全部 stack shuffle 做了手工语义提升并执行。以 `0x180c278a7` 入口 `[rsp+n*8] = Sn`：

```text
S1  -> R11
S2  -> R12
S3  -> R13
S4  -> R14
S5  -> R15
S6  -> RDI
S7  -> RSI
S8  -> RBP
S9  -> RBX
S10 -> RDX = 真 32-bit keystream word
S11 -> RCX = 目标地址
S12 -> RAX
S13 -> RFLAGS
S14 -> RIP = 0x18041a860
```

这证明 writer 前缀是一个通用“从 VM 虚拟栈恢复完整宿主寄存器帧并 RET 调用 native helper”的 trampoline。EDX 并不是在 `0x181ad61e7` 附近算出，而是在进入 `0x180c278a7` 之前已经作为虚拟栈第 10 个 qword 准备好。

## 更早的真实动态路径

已有 slot-change 历史将上游推进到：

```text
... 0x18099089e
-> 0x180bce798
-> 0x180b8c7aa
-> 0x180c27936
-> 0x180c276c5
-> 0x180c279e4
-> 0x180c2769b
-> 0x180c27945
-> 0x180c27b86
-> 0x180c2754f
-> 0x180c27582
-> 0x180c278a7
```

`0x180b8c7aa` 是 VM handler；尾部 `0x180b8d002 movsxd rdx,[rsi] / add [rbp+0x6d],rdx / jmp r14` 是 dispatch/VIP 更新，不是最终 keystream 算术。`0x180c27936..0x180c2769b` 继续变换 RDX 并把值/寄存器压入 trampoline frame。下一步必须从这些真实块和入口栈布局继续追踪 S10 的 producer，而不是再分析不存在的 call site。

## 新产物

- `target/symbolic_writer_trampoline.py`
- `target/symbolic_writer_trampoline_result.txt`
- `target/writer_chain_dynamic_predecessor_windows.txt`
- `target/writer_upstream_dynamic_long_windows.txt`
- `target/writer_exact_predecessor_blocks.txt`
- `target/writer_word_producer_path_disasm.txt`
