# MaxHook native 协议里程碑 06：VM dispatcher 取指规则与动态 handler 表阻断

日期：2026-08-13（Asia/Shanghai）

本里程碑沿交接文档的 VM 硬破路线，给加密入口 `0x181523001` 的 dispatcher 建立了可复核的取指/选 handler 记录，并用两份不同 epoch 的 `.bugland` 做交叉实验。

结论先行：dispatcher 的核心选择规则已经从静态代码闭合；入口第一次选择能命中合法 handler，但随后的字节码 index 已超过旧 dump 中已经解密的连续 handler 表范围，槽值为 0 或非代码地址。两份 epoch 输入得到逐项相同的状态序列和失败点，说明当前离线仿真的实际缺口是函数入口同刻的动态 handler-table 解密态，而不是 `input64`、plaintext 或 R9 context。

这仍不能等价于已经恢复加密算法；当前不能生成服务器可接受的新 envelope。

## 1. 证据与复跑产物

本轮只读取本地旧产物和实机已落盘的 boundary capture，没有重新 attach、PSS、抓包或联网。

复跑器：

- [emulate_maxhook_encrypt_boundary.py](./emulate_maxhook_encrypt_boundary.py)

同步参数输入：

```powershell
python E:\Coding\S1mple\target\emulate_maxhook_encrypt_boundary.py `
  --boundary-dir E:\Coding\S1mple\target\encrypt_boundary_capture2 `
  --boundary-session 2 `
  --boundary-call 4 `
  --output E:\Coding\S1mple\target\maxhook_encrypt_vm_dispatch_trace.json
```

第二个 epoch 对照：

```powershell
python E:\Coding\S1mple\target\emulate_maxhook_encrypt_boundary.py `
  --boundary-dir E:\Coding\S1mple\target\encrypt_boundary_capture2 `
  --boundary-session 2 `
  --boundary-call 4 `
  --bugland E:\Coding\S1mple\target\dump_out\41264\region_0000000180980000.bin `
  --output E:\Coding\S1mple\target\maxhook_encrypt_vm_dispatch_trace_dump_epoch.json
```

分析 JSON：

- [maxhook_encrypt_vm_dispatch_trace.json](./maxhook_encrypt_vm_dispatch_trace.json)
- [maxhook_encrypt_vm_dispatch_trace_dump_epoch.json](./maxhook_encrypt_vm_dispatch_trace_dump_epoch.json)

两份 `.bugland` 的原始 SHA-256：

```text
runtime_bugland2.bin                                  3a8e093afbf678fec5b4a84e5759b4d030f8ad39b52eac81a872dfe581449f26
dump_out\41264\region_0000000180980000.bin             6cef8bf7d7ae2b31ed25ef8d0fe315478a4131967b34007b68d0ef82d8cdd41d
```

## 2. dispatcher 静态规则

在 `.bugland` 中的 dispatcher helper `0x1809A57E6` 反汇编为：

```asm
VIP       = qword ptr [RBP+0x6D]
raw_word  = word ptr [VIP+4]
key       = dword ptr [RBP+0x0A]
key       = key - (key + raw_word)       ; 低 32 位，结果等于 -raw_word
index     = (key_old + raw_word) & 0xFFFF
handler   = qword ptr [qword ptr [RBP+0x85] + index*8]
advance   = sign_extend(dword ptr [VIP])
VIP      += advance
jmp handler
```

对应机器码片段：

```text
0x1809A57E9  mov rdx,[rbp+6d]
0x1809A57FD  movzx rdx,word ptr [rdx]
0x1809A5819  add edx,dword ptr [rbp+a]
0x1809A5826  sub dword ptr [rbp+a],edx
0x1809A5829  and rdx,0xffff
0x1809A5830  shl rdx,3
0x1809A5834  add r13,rdx
0x1809A5837  mov rax,[r13]
0x1809A584F  movsxd r13,dword ptr [VIP]
0x1809A585C  add qword ptr [rbp+6d],r13
0x1809A585F  jmp rax
```

`0x180C43FDD` 是加密入口先进入的 VM/dispatcher 外层；复跑器在该入口记录上述字段。由于 handler 自身还会修改 VIP，JSON 中的 `raw_dword_at_vip` 只表示取指时的原始 dword，不把 `VIP+raw_dword` 当成最终下一条地址。

## 3. 第一次取指：规则命中合法 handler

真实 boundary 参数恢复后，第一个 dispatcher 事件为：

```text
instruction       = 82
key_low32         = 0xFFFFFFA5
VIP                = 0x181D2879B
word[VIP+4]        = 0x0080
handler index      = 0x0025
handler-table      = 0x180C64EBD
handler target     = 0x1809A2071
```

`0x1809A2071` 位于 `.bugland`，不是随机地址；该入口继续跳入 handler 实现块 `0x1809855B0`。这验证了：

1. `[RBP+0x0A]` 确实是 dispatcher key；
2. `[RBP+0x6D]` 确实是 VIP；
3. `word[VIP+4]` 参与 16-bit handler index；
4. `[RBP+0x85]` 在本次入口被设为 handler table `0x180C64EBD`。

## 4. 第二次取指：旧 epoch 表槽为空

相同离线输入继续执行后，第二个 dispatcher 事件为：

```text
instruction       = 75612
key_low32         = 0xFFFF0439
VIP                = 0x18153E32F
word[VIP+4]        = 0x5EAC
handler index      = 0x62E5
handler-table      = 0x180C64EBD
handler target     = 0x0000000000000000
```

后续取指得到的 index 与 table 值如下（均为同一旧 epoch）：

| VM 指令计数 | index | table slot 值 | 判定 |
|---:|---:|---:|---|
| 75,612 | `0x62E5` | `0x0` | 空槽 |
| 86,826 | `0x667F` | `0x0` | 空槽 |
| 100,473 | `0x45AE` | `0x10000DB7BF49` | 非 `.bugland` 代码地址 |
| 116,451 | `0x001D` | `0x18098ADF3` | 合法 handler |
| 139,146 | `0xD536` | `0xF359D7C5288C77A8` | 非代码值 |
| 150,922 | `0x4962` | `0xC38149EB8949005C` | 非代码值 |
| 164,508 | `0x452C` | `0xEC81485A6FF05C32` | 非代码值 |
| 180,951 | `0x0068` | `0x180988E9E` | 合法 handler |
| 195,168 | `0x379E` | `0x1EA406B941240C89` | 非代码值 |
| 206,000 | `0xE27F` | `0x15B2749F5157ADA1` | 非代码值 |

旧 `runtime_bugland2.bin` 的 table 从 index `0x0000` 到 `0x064B` 才是连续指向 `.bugland` 的已解密项；`0x62E5` 等高 index 不在这段连续范围内。它们在旧快照中表现为空槽或残留数据，正是先前“垃圾跳转”的来源。

## 5. 两个 epoch 的交叉实验

分别把 `runtime_bugland2.bin` 和 `dump_out\41264\region_0000000180980000.bin` 放入同一个 PE/栈/context 仿真器：

```text
instructions executed        = 545,691
dispatcher events            = 11
distinct handler targets     = 10
last failing RIP             = 0x1809BD556
bad dereference              = [0x158]
VM pointer slot final value  = 0x158
```

两份输入的前 11 条 dispatcher 记录逐字段一致，最终错误也一致。这个结果比“换一份 dump 仍崩溃”更具体：旧 epoch 的 handler table/VM 状态在本次入口上并没有提供新的可执行信息，不能通过简单替换 `.bugland` 文件解决。

本轮还在 Unicorn 的 `0x180C64EBD .. +0x80000` 范围安装了写监视器。`maxhook_encrypt_vm_table_write_trace.json` 的结果是：

```text
handler-table writes             = 0
handler-table high-index writes  = 0
VM pointer-slot writes           = 252
```

这只说明“当前离线输入在仿真期间没有重新填充该表”，不能证明真实进程永远不写表；结合第二次 dispatcher 已进入 `0x62E5/0x667F` 等高 index，最保守的解释仍是入口 epoch 与旧表不相容。它同时排除了一个较简单的误区：把当前失败归因于仿真器漏掉了一次明显的 table write。

写监视产物：

- [maxhook_encrypt_vm_table_write_trace.json](./maxhook_encrypt_vm_table_write_trace.json)

## 6. 对“可复现 native 协议”的影响

现在可以把实现边界写成：

```text
已确定：HTTP、endpoint、envelope 字段、字段顺序、plaintext JSON、
        input32 == kid、input64 的会话生命周期、native encrypt 调用 ABI

未确定：input64 的生成/解包、h2_cantor 内层算法、report_packet、
        外层私有流密码、tag 计算、AAD、函数入口同刻动态 handler table
```

当前“方案 1”仍是唯一可立即工作于本地 proxy 的路线：复用真实 MaxHook 加密边界输出，不能用 Python 标准库凭已知 envelope 字段直接重算。

## 7. 下一步

纯离线可做的下一步是：

1. 以 `index=0x25` 的合法 handler 为起点，跟随其所有间接跳转和 `[RBP+0x6D]`/`[RBP+0x0A]` 写入，建立 handler 语义摘要；
2. 从静态初始化路径识别高 index handler table 的解密/填充循环，判断动态 table 是否能由静态 blob + 入口 seed 独立重建；
3. 对 `vm_trace_capture3/4` 的真实地址集合做 handler-entry 归一化，和离线 `index=0x25` 路径交叉校验；
4. 在服务器状态恢复、授权和隔离测试明确前，不再进行新的 live attach。

本里程碑证明了 VM 取指规则和具体状态阻断，但没有证明任何标准密码算法，也没有把私有流密码还原完成。
