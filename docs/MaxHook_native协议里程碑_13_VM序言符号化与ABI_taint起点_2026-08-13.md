# MaxHook native 协议里程碑 13：VM 序言精确符号化与 ABI taint 起点

日期：2026-08-13 18:33（Asia/Shanghai）  
范围：只读精确反汇编和离线符号执行；未重新附加、未联网。

## 1. 核心结论

已经对外层加密 VM 序言 `0x181523001–0x181523158` 的 80 条指令做逐条符号执行，并正确实现 x86-64 `POP r/m64` 使用 RSP 时“先递增再计算目标有效地址”的特殊语义。

到 `jmp 0x180c43fdd` 前：

- RAX、RBX、RCX、RDX、RSI、RDI、RBP、R8–R15 全部与 VM 入口值逐项相同；
- RSP 只下移 `0x20`；
- 序言没有对 KID、key-material、context、plaintext 做 hash、hex decode 或 key schedule；
- ABI 参数原样进入外层 dispatcher。

这把加密输入的静态 taint 起点精确固定为：

```text
RCX                    output envelope object
RDX                    KID std::string object
R8                     64-hex key-material std::string object
R9                     context object
[ENTRY_RSP+0x28]       plaintext std::string object
[DISPATCHER_RSP+0x48]  同一个 plaintext object
```

捕获脚本 `capture_maxhook_encrypt_boundary.js:110` 也从入口 `RSP+0x28` 读取 plaintext，与符号结果一致。

## 2. dispatcher 入口栈

VM 序言把入口 RSP 下移 `0x20`，构造如下控制槽：

| dispatcher RSP 偏移 | 值 |
|---:|---|
| `+0x00` | `0x324610`（外层加密边界 RVA） |
| `+0x08` | 入口 RFLAGS |
| `+0x10` | `0x2ca` |
| `+0x18` | `0x01555629` |
| `+0x20` | 原始返回地址，即 `[ENTRY_RSP+0x00]` |
| `+0x48` | 第 5 参数 plaintext object，即 `[ENTRY_RSP+0x28]` |

其中 `0x2ca` 来自序言常量表达式：

```text
((0x6af57d4f >> 4) XOR 0x7b502d73) XOR 0x7dff786d = 0x2ca
```

这些更像 VM 控制元数据；输入对象本身没有在序言中被读取。

## 3. 新工具

符号执行器：[`analyze_maxhook_vm_prologue.py`](./analyze_maxhook_vm_prologue.py)  
脱敏输出：[`maxhook_vm_prologue_symbolic.json`](./maxhook_vm_prologue_symbolic.json)

复现：

```powershell
python target\analyze_maxhook_vm_prologue.py `
  --runtime-bugland target\runtime_bugland2.bin `
  --output target\maxhook_vm_prologue_symbolic.json
```

运行断言包括：

- 精确解码到 `0x181523158 jmp 0x180c43fdd`；
- 序言每条指令都必须由符号执行器支持，遇到未知语义立即失败；
- 目标跳转必须是已知 dispatcher；
- 最终 15 个通用寄存器全部报告是否保持入口值；
- 输出无 key/KID/plaintext 内容。

## 4. 对后续 handler taint 的影响

此前只能说“hook 参数布局 7/7 一致”。现在静态证明参数没有在 VM 序言里换位或派生，所以后续 dispatcher/handler 分段可直接以 `RCX/RDX/R8/R9/[RSP+0x48]` 为初始 taint 源。

这也排除了一条错误路线：无需继续把 `0x181523001–0x181523158` 当 key derivation 搜索区。实际 key-material 读取、hex 解析和 nonce/plaintext 处理必然发生在 `0x180c43fdd` 之后的克隆 dispatcher/handler 路径，或其调用的明文 helper 中。

下一步应沿已恢复的首次执行顺序，寻找这些 taint 源第一次被解引用的位置，尤其是：

- 从 R8 的 std::string 取 data pointer/size；
- 从 `[dispatcher_rsp+0x48]` 取 plaintext object；
- RCX output object 的 `+0x00/+0x20/+0x40/+0x60` 四个 std::string 写入；
- nonce 生成后进入 VM 状态的位置。

## 5. 完整性

```text
analyze_maxhook_vm_prologue.py
d97f92d210bcc5abc4d7dec27e65436cd40ff11868efdad861313d21d53d479e

maxhook_vm_prologue_symbolic.json
c40e9de68bbd0428d472451422d9b202fc4ae0bb76b15fd31b39c964b1766cf6
```

脚本已通过语法编译、80 指令全覆盖、寄存器保持断言、栈布局验证和连续两次输出哈希一致性验证。
