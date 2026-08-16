# MaxHook 协议栈 — writer trampoline ABI 完整恢复（第 255 轮复核）

日期：2026-08-14
范围：纯离线

## 一、writer trampoline 完整 ABI（里程碑 29 + 第 255 轮复核）

`symbolic_writer_trampoline.py` 恢复的完整虚拟栈 → 宿主寄存器映射（`0x180c278a7` 入口
`[rsp+n*8] = Sn`）：

```
S1  → R11      S2 → R12      S3 → R13      S4 → R14      S5 → R15
S6  → RDI      S7 → RSI      S8 → RBP      S9 → RBX
S10 → RDX = 真 32-bit keystream word    S11 → RCX = 目标地址
S12 → RAX      S13 → RFLAGS   S14 → RIP = 0x18041a860 (store32)
```

## 二、fold 完整动态路径（slot-change 历史）

```
0x180b8c7aa (word-producer, 6 push)
→ 0x180c27936 (shl rdx,1)
→ 0x180c276c5 (shr rdx,3)
→ 0x180c279e4
→ 0x180c2769b (add rdx,rbx)
→ 0x180c27945
→ 0x180c27b86
→ 0x180c2754f
→ 0x180c27582
→ 0x180c278a7 (trampoline 入口)
```

**关键**：S10（keystream word）在进入 `0x180c278a7` **之前**已作为虚拟栈第 10 个 qword 准备好。
fold 算术（`0x180c27936..0x180c2769b`）继续变换 RDX 并压入 trampoline frame。

## 三、完整 keystream 生成数据链（最终确认）

```
key+nonce → key-schedule (54 handler, 槽交换 ARX) → 6 fold 输入槽
→ word-producer (6 push) → fold 算术 (shl/shr/add/sub + 8 常量) → S10 (虚拟栈)
→ trampoline (0x180c278a7, 恢复寄存器, S10→RDX) → store32 (0x18041a860) → keystream
```

## 四、剩余缺口（精确）

S10（keystream word）的**精确 producer**——fold 算术如何把 6 个输入槽值变换为 S10。
fold 算术（shl/shr/add/sub + 8 常量）已确认，6 输入槽语义已确认，剩余是**精确的
寄存器/栈数据流**（6 值 → S10 的映射），需 VM 数据栈（8704B）或符号执行。

## 五、交付物

本报告 + `symbolic_writer_trampoline.py`（既有）+ `encrypt_vm_fold_arith.json`（fold 算术实测）。
