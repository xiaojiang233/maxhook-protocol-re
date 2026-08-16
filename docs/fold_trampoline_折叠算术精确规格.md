# MaxHook fold/trampoline 折叠算术精确规格（离线符号化）

日期：2026-08-14（第 6 轮）
范围：纯离线。来源：`disasm_unpacked.asm`（`0x180c27500..0x180c27d00`）+ writer_sync 真实密钥流字。

## 一、结论

fold/trampoline 区域（`0x180c27500..0x180c27d00`）是**字生产者 6 个 context 槽值 → 最终 32-bit 密钥流字 EDX** 的折叠算术。
它被 Themida 重度混淆（大量寄存器/栈 shuffle + decoy 条件分支），但真实算术是**一小撮 add/sub/xor/shr/shl/not/neg** 操作，
配合 6 个真实 32-bit 常量。

## 二、真实 fold 算术操作（已识别，按地址）

| 地址 | 指令 | 语义 |
|------|------|------|
| `0x180c2769b` | `add rdx, rbx` | rdx += rbx（rbx = 6 值之一） |
| `0x180c2769e` | `sub rdx, 0x7ef78e7d` | rdx -= 常量 |
| `0x180c276c5` | `shr rdx, 3` | rdx >>= 3 |
| `0x180c27936` | `shl rdx, 1` | rdx <<= 1 |
| `0x180c27742` | `pop rdx` | 取栈值 |
| `0x180c27743` | `sub r13d, ebp` | r13 -= ebp（ebp = 6 值之一） |
| `0x180c27747` | `add r13d, 0x47f75fb8` | r13 += 常量 |
| `0x180c2774e` | `not r13d` | r13 = ~r13 |
| `0x180c27751` | `neg r13d` | r13 = -r13 |
| `0x180c27754` | `not r13d` | r13 = ~r13 |
| `0x180c277df` | `xor r14, 0x77914aff` | r14 ^= 常量 |
| `0x180c27953` | `add r10, 0x1bd67eac` | r10 += 常量 |

## 三、真实 32-bit fold 常量（完整集合）

```text
0x7ef78e7d   sub rdx, 0x7ef78e7d   （0x180c2769e，与 0x180c279f3 成对 add/sub）
0x47f75fb8   add r13d, 0x47f75fb8  （0x180c27747）
0x1f5ff464   sub r8, 0x1f5ff464    （0x180c27987）
0x3879c8ab   push 0x3879c8ab; not  （0x180c2799d）
0x6eaa89fc   mov ebp, 0x6eaa89fc   （0x180c279aa）
0x5f77d611   xor rsi, 0x5f77d611   （0x180c279a1c）
0x77914aff   xor r14, 0x77914aff   （0x180c277df）
0x1bd67eac   add r10, 0x1bd67eac   （0x180c27953）
```

（另有多个 decoy 常量，如 `0x57fb5fc2`/`0x793fa795`/`0x9761`/`0x601f`/`0x3616` 等，出现在
`push imm; pop reg` 的寄存器 shuffle 里，是 Themida 混淆，不参与最终 EDX 数据流。）

## 四、剩余唯一未闭环（精确、机械）

fold 的**数据流映射**：6 个 push 值（经 `0x180b8c7aa` 压入 VM 数据栈）→ 哪些寄存器（rbx/ebp/rbp/r13/rdx/r14...）→
经上述 ~12 个算术操作 → 最终 EDX。这是**纯机械的符号求值**：

1. 记录 6 个 push 的顺序与栈位置（已在 `word_producer_0x180b8c7aa_精确数据流.md` 证明）；
2. 追踪每个值经 trampoline 的 pop/寄存器 shuffle 后落入哪个 fold 寄存器；
3. 代入上述算术操作，得到 `EDX = fold(v1..v6, constants)` 的闭式；
4. 用 writer_sync 的真实密钥流字（`0xdfa1e432, 0xa6fadd74, ...` 16 字/块）校验。

## 五、真实密钥流字（writer_sync call_1，key=347230e6，nonce=96e71401fc4f5faa040e5ca1）

block 0 的 16 个 32-bit LE 字（`000011_call_1_meta_writer_sync_records.bin` index 12..27）：

```text
0xdfa1e432 0xa6fadd74 0x1cddedf4 0x0f7e9382
0x60cf0be6 0xb7c65896 0xb5a66525 0x5836cbdd
0x8281bbaf 0x597f058e 0x56736e8d 0x1ad8536c
0x1b8161d2 0xa25e379a 0x8a21bf2c 0xf548d1c9
```

（对应 `analysis.json` keystream `32e4a1df74ddfaa6...`，LE word 0 = 0xdfa1e432。）

## 七、key-schedule 轮函数核心（第 10 轮补充）

fold 区域之后（`0x180c27d03..0x180c27f97`）是**实际的 key-schedule 轮函数**，操作 context 状态槽 0x1e/0x143：

```text
0x180c27d03  r13 = [context+0xff]        ; VIP
0x180c27d11  r13 += 3
0x180c27d18  r11 = word[VIP+3]           ; 字节码常量
0x180c27d27  r11 ^= [context+0x1e]       ; 状态
0x180c27d34  r11 -= [context+0x143]      ; 状态
0x180c27d41  [context+0x1e] ^= r11       ; 轮更新：state ^= word[VIP+3] ^ state1 - state2

0x180c27f5b  r10 = word[VIP+0xa]         ; 字节码常量
0x180c27f7d  r10 += [context+0x1e]
0x180c27f8a  r10 += [context+0x143]
0x180c27f97  [context+0x1e] ^= r10       ; 轮更新：state ^= word[VIP+0xa] + state1 + state2
```

额外 32-bit 常量：`xor r9d, 0x5c03bdb2`（`0x180c27eba`）。

**关键结论**：密码轮函数的常量（`word[VIP+3]`、`word[VIP+5]`、`word[VIP+0xa]` 等）是**嵌入在 VM
字节码流本身**的，不是静态表。即密码是 **bytecode-compiled ARX**：轮函数 = 读取字节码字 +
对 context 状态槽 0x1e/0x143 做 add/sub/xor。要复现必须执行 VM 字节码（模拟器需到达 cipher core）。

## 八、剩余障碍的精确性质（第 10 轮确认）

离线重放最终态：`rbp=0x1a`（VM context 基址寄存器被污染成 26）、`rip=0x7ffe1feeb8`（RIP 落入栈内存）。
根因 = Themida VM 数据栈（native rsp）desync：VM 用 native 栈作数据栈，push/pop 配对离线错位，
`pop rbp` 读到陈旧值 0x1a，最终 `ret` 把栈数据当返回地址。key 已消费（rdi=0x20000100080），非 key 未 seed。

## 九、trampoline 区域的完整结构（第 15 轮）

trampoline 区域 `0x180c27400..0x180c27d00` 是**三种代码的混合**：

1. **VM dispatcher（表查找）**：`0x180c2749e` 计算 handler 索引
   `index = (word[VIP] ^ state + 0x7b5c860b) & 0xffff`，`rbx = [ctx+0xd7] + index*8`，
   `rdx = [rbx]` 加载 handler 地址（新常量 `0x7b5c860b` @ `0x180c274d2`）；
2. **指针去混淆**：`sub/xor 0x80/0x90/0x9e22/0x1d6e/0x65aa` 等 16-bit/32-bit 掩码；
3. **密码 fold**：`0x180c27bd0..0x180c27be2` 加载 S10 → EDX，经 `popfq;ret` 进 store32。

**关键结论**：密码 fold 是 dispatcher + 去混淆 + fold 三者交织中的一小部分。真正产生密钥流字 EDX
的算术在 `0x180c27bd0`（`push [rsp]`）→ `0x180c27be2`（`mov rdx,[rsp]` = S10）。S10 的值是 6 个
word-producer 槽值经 VM 字节码折叠的结果，折叠序列嵌入在 dispatcher 的字节码流中。

## 十、验证方法

用 dump 完整解密 `.bugland` + context 重放，在 6 个 push 位点 + fold 各算术操作 + store32 插桩，
记录每个操作的操作数，代入上述闭式，断言 fold 结果 == writer_sync 真实密钥流字。
若 fold 闭式正确，则 7 个验证集样本可 7/7 复现 ciphertext = plaintext XOR keystream。
