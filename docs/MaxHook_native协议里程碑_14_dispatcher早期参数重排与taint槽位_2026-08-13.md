# MaxHook native 协议里程碑 14：dispatcher 早期参数重排与 taint 槽位

日期：2026-08-13 18:37（Asia/Shanghai）  
范围：只读静态反汇编、离线 taint 执行；未重新附加、未联网。

## 1. 结论

已经继续符号化外层 dispatcher 的线性早期 setup：

```text
0x180c43fdd call 0x180c43fe2
...
0x180c441a8 pop r9
```

开头的 `call 0x180c43fe2` 是 call-next：目标恰好是下一条指令，只用于把 RIP/返回地址压栈，不是会返回的普通 helper。

这段 125 条指令没有解引用 KID、key-material、context、plaintext 或 output 对象；它只保存寄存器并重排 taint。结束时的精确输入位置是：

```text
OUTPUT     → R8
KID        → RDX，同时备份于 [ENTRY_RSP-0x30]
KEYMAT     → [ENTRY_RSP-0x98]
CONTEXT    → [ENTRY_RSP-0x90]
PLAINTEXT  → [ENTRY_RSP+0x28]
```

setup 结束 RSP 为 `ENTRY_RSP-0x98`。因此 KEYMAT 正好位于当前 `[RSP]`，CONTEXT 位于 `[RSP+0x08]`；这给后续首次解引用搜索提供了精确栈坐标。

## 2. 新工具

Taint 执行器：[`analyze_maxhook_vm_setup_taint.py`](./analyze_maxhook_vm_setup_taint.py)  
脱敏结果：[`maxhook_vm_setup_taint.json`](./maxhook_vm_setup_taint.json)

复现：

```powershell
python target\analyze_maxhook_vm_setup_taint.py `
  --runtime-bugland target\runtime_bugland2.bin `
  --output target\maxhook_vm_setup_taint.json
```

脚本断言：

- `0x180c43fdd` 的 call 必须精确指向下一条 `0x180c43fe2`；
- 125 条指令必须全部被 taint 语义覆盖；
- x86 `POP [RSP+disp]` 按递增后的 RSP 计算目标；
- 结束寄存器 taint 只能是 `R8=OUTPUT`、`RDX=KID`；
- 四个关键栈槽必须逐项匹配；
- 本段不得出现以输入对象为地址的外部读写。

## 3. 对此前参数布局的补充

入口 ABI 仍是：

```text
RCX=OUTPUT, RDX=KID, R8=KEYMAT, R9=CONTEXT, [ENTRY_RSP+0x28]=PLAINTEXT
```

里程碑 13 证明 VM 序言不改这些寄存器；本里程碑进一步证明 dispatcher 的第一个线性 setup 把参数改排成栈帧状态，而不是立即做 key schedule。特别是 `R8` 在此后不再代表 KEYMAT，而代表 OUTPUT。继续静态 taint 时若仍把 R8 当 key-material，会产生错误归因。

正确的下一阶段 taint 起点应改为：

```text
current RSP = ENTRY_RSP-0x98
[RSP+0x00] = KEYMAT
[RSP+0x08] = CONTEXT
[RSP+0x68] = KID backup
[RSP+0xc0] = PLAINTEXT
RDX        = KID
R8         = OUTPUT
```

`[RSP+0xc0]` 来自 `ENTRY_RSP+0x28 - (ENTRY_RSP-0x98)`。

## 4. 下一步

接下来需要从 `0x180c441aa` 开始沿真实分支路径继续 taint，定位：

1. `[RSP]` 的 KEYMAT std::string 首次被取出和解引用；
2. `[RSP+0xc0]` 的 PLAINTEXT std::string 首次被取出；
3. R8/OUTPUT 的四个连续 std::string 首次写入；
4. 这些对象指针被写入 VM context 的哪几个 offset。

找到这些点后，才能把已恢复的 handler 周期与 key schedule/nonce/plaintext/output 语义对应起来。

## 5. 完整性

```text
analyze_maxhook_vm_setup_taint.py
f66ce43e6f2b29f837b3d165c6b4913b8d260b6e041e6afd1eb4adcf69f2d1f1

maxhook_vm_setup_taint.json
2b45e4ad1525954f67e9a127b45ed9ec46ebf1898110723f2ac18a13ac6596f6
```

脚本已通过语法编译、125 指令全覆盖、精确 taint 断言与连续两次输出哈希一致性验证。
