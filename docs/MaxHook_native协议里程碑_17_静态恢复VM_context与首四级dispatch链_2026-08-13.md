# MaxHook Native 协议里程碑 17：静态恢复 VM context 与首四级 dispatch 链

时间：2026-08-13

## 结论

本轮不再依赖 Stalker `transform` 的首翻译顺序，也没有附加线上游戏进程。通过 `runtime_bugland2.bin`、已验证的 VM 序言符号结果和 bootstrap 明文代码，已经静态闭合：

1. 加密 VM 的 context 基址就是 `0x18098c884`；
2. 首个 VIP 是 `0x181555629`；
3. `bootstrap table[0x2ca]` 之后的前四级真实 VM dispatch 索引为：

```text
0x147 -> 0x321 -> 0x5d -> 0xe0
```

这些索引均由各 handler 的具体取数字段、rolling-key 算术和 handler table 实值静态计算得到，不是由地址文件中的“下一条首翻译地址”倒推。

## 一、VM context 地址的静态化简

bootstrap 的 call-next 序列先得到模块基址：

```text
0x180c43fdd  call 0x180c43fe2
0x180c441aa  sub rcx, 5
0x180c441ae  sub rcx, 0xc43fdd
```

所以此后 `RCX = 0x180000000`。`RBP` 的 32-bit 常量链化简为：

```text
(((0x38ffc137 + 1) & 0x7f2c79bd) - 0x379378b4) & 0xffffffff
= 0x0098c884
```

周围跨 `add rbp,rcx` 的 64-bit 加减项两两抵消，因此：

```text
RBP = module_base + 0x98c884
    = 0x18098c884
```

这与旧 dump/模拟中观察到的 context 地址一致，但现在地址来源已经由入口代码本身证明。

## 二、首个 VIP 也来自 VM 序言常量

VM 序言已证明在 `ENTRY_RSP-0x8` 写入 `0x1555629`。沿已选定的 bootstrap 路径精确计算栈深度，`0x180c449b0` 执行时：

```text
RSP = ENTRY_RSP - 0x98
[RSP+0x90] = [ENTRY_RSP-0x8] = 0x1555629
```

后续 `0x180c44a18/0x180c44a1b` 把它加上模块基址并写入 VM context，得到：

```text
[RBP+0x6d] = 0x180000000 + 0x1555629
           = 0x181555629
```

这也解释了为什么之前离线短跑到首 dispatcher 前，context 中会出现该 VIP，而旧异步末态 blob 中却是另一个稳定态 VIP。

## 三、首四级真实 dispatch 链

### 1. dispatcher `0x180a97f70`

该 dispatcher 明确读取：

```text
index   = word[VIP+0]
advance = i32[VIP+2]
```

`VIP=0x181555629` 的字节为：

```text
47 01 c5 db 00 00 ...
```

因此：

```text
index       = 0x0147
advance     = +0xdbc5
next VIP    = 0x1815631ee
table[147]  = 0x1809ac48d
stub        = jmp 0x1809f4736
```

同一 dispatcher 还把初始 `key_low32=0xffffffa5` 变换为 `0x02dba4ba`。

### 2. handler `0x1809f4736`

该 handler 的末段使用：

```text
index   = word[VIP+6]
advance = i32[VIP+2]
```

在 `VIP=0x1815631ee`：

```text
index       = 0x0321
advance     = -0x7e43
next VIP    = 0x18155b3ab
table[321]  = 0x180981ac9
stub        = jmp 0x1809da384
```

### 3. handler `0x1809da384`

该 handler 使用另一种紧凑字段布局：

```text
index   = word[VIP+0xc]
advance = i32[VIP+4]
```

在 `VIP=0x18155b3ab`：

```text
index       = 0x005d
advance     = +0xc173
next VIP    = 0x18156751e
table[05d]  = 0x18098257f
stub        = jmp 0x1809bfebb
```

这个 handler 同时清零了多项 VM context 状态，包括 rolling key、`context+0xf6` 等，是一段明确的 VM 初始化 handler。

### 4. handler `0x1809bfebb`

在 `VIP=0x18156751e`，先前初始化使 `context+0xf6=0`，因此该 handler 首次 key 更新为：

```text
key = word[VIP+0xa] = 0x36d2
```

随后 dispatcher 算术为：

```text
full  = word[VIP+0] - key + 0x5214a88c
      = 0x521500e0
index = full & 0xffff
      = 0x00e0
key'  = key - full
      = 0xadeb35f2
```

VIP 更新为：

```text
advance     = i32[VIP+6] = -0xa068
next VIP    = 0x18155d4b6
table[0e0]  = 0x1809a3b86
```

这第一次从加密 VM 的真实入口静态恢复出了 rolling-key 参与索引解码的完整实例。

## 四、验证方式

新增可重复执行的静态校验器：

```powershell
python target\analyze_maxhook_vm_initial_chain.py `
  --runtime-bugland target\runtime_bugland2.bin `
  --prologue-json target\maxhook_vm_prologue_symbolic.json `
  --output target\maxhook_vm_initial_chain.json
```

当前输出：

```text
context=0x18098c884 initial_vip=0x181555629 chain=0x147->0x321->0x5d->0xe0
```

SHA-256：

```text
analyze_maxhook_vm_initial_chain.py  65f3e34d401030163428927edff74f84ce67ec21d8d3ce0595f170fc6f9967a8
maxhook_vm_initial_chain.json        8e8f7d87d8bcb8bf1543e453ce0c7a9a9efa2dbb4b84707fea14c5385e1bca02
```

离线 Unicorn 短跑也逐级得到同一目标链；它仅作为交叉检查，不作为上述静态证明的前提。为便于继续核对，`emulate_maxhook_encrypt_boundary.py` 新增了 `vm_indirect_jumps[]` 输出，每个 VM 间接跳转记录 source/target/key/VIP。

## 五、边界与下一步

本里程碑证明的是解释器启动和前四级 dispatch，不等于已经恢复外层加密算法。当前尚未完成：

- `input64/KID/plaintext/nonce/output` 第一次实际解引用的 handler；
- 加密状态初始化、轮函数、tag 计算；
- 7 组验证集的 ciphertext/tag 全量正向匹配。

下一步从 `table[0xe0] = 0x1809a3b86` 对应 handler 继续做相同的字段/rolling-key 解析，并在离线运行中标注参数对象第一次被解引用的位置。只有恢复出可独立实现并通过 7/7 的算法，才算 native 外层加密流程真正解完。
