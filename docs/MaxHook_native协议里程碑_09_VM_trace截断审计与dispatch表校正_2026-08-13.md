# MaxHook native 协议里程碑 09：VM trace 截断审计、dispatch 表校正与可证边界

日期：2026-08-13 18:14（Asia/Shanghai）  
范围：只读分析既有 Stalker 捕获、静态反汇编与旧 runtime dump；没有重新附加游戏进程，没有访问或请求服务端。

## 1. 结论先行

两批 `vm_trace_capture3/4` 不能作为完整的逐地址执行轨迹使用。更关键的修正是：捕获器在 `Stalker.follow(... transform(iterator) ...)` 回调里累计 `total_instructions`、mnemonic 和 `addr:count`，所以它们表示代码块翻译/重翻译时处理的指令实例，不是运行时 instruction hit。地址明细只保留最先翻译到的 `MAX_UNIQ` 个唯一地址。旧批 6/6 恰为 30,000，新批 5/5 恰为 40,000，均撞上各自的历史上限；每次约 202k 是 transform 处理量，不能称为函数实际执行指令数。

因此，先前从 `vm_addrs_call*.txt` 得出的“完整 VM 地址集”“完整轮函数比例”“高频循环体”必须降级为“被 Stalker 翻译到的截断代码地址集合”。`analyze_vm_trace.py` 给出的约 33% ARX 类静态指令占比只能描述这批被记住的唯一地址，不能证明加密本体就是私有 ARX 流密码。

旧 runtime 的 qword handler 表仍有价值，但必须使用正确术语：真正的运行时 qword dispatch 表是 `T=0x180c64ebd`，连续索引 `0x0000..0x064b` 共 1612 项；`0x180c0c000-0x180c0d300` 是可执行 VM 代码区，不是这张 qword 表。

## 2. 新增可复现工具与结果

覆盖审计器：[`analyze_maxhook_vm_trace_coverage.py`](./analyze_maxhook_vm_trace_coverage.py)  
脱敏输出：[`maxhook_vm_trace_coverage.json`](./maxhook_vm_trace_coverage.json)

复现命令：

```powershell
python target\analyze_maxhook_vm_trace_coverage.py `
  --capture target\vm_trace_capture3 `
  --capture target\vm_trace_capture4 `
  --capture-cap target\vm_trace_capture3=30000 `
  --capture-cap target\vm_trace_capture4=40000 `
  --capture-script target\capture_maxhook_vm_trace.js `
  --runtime-bugland target\runtime_bugland2.bin `
  --disassembly target\disasm_unpacked.asm `
  --output target\maxhook_vm_trace_coverage.json
```

校验结果：

| 捕获 | 调用数 | transform 指令实例范围 | 地址交集 | 地址并集 | 变动成员 | 是否全撞地址上限 |
|---|---:|---:|---:|---:|---:|---|
| `vm_trace_capture3` | 6 | 202,217–202,756 | 29,869 | 30,120 | 251 | 是，30,000 |
| `vm_trace_capture4` | 5 | 202,251–202,958 | 39,867 | 40,133 | 266 | 是，40,000 |

新批 call 1 与 call 5 的 `addr:count` 映射逐项完全相同，但 transform 指令实例总数相差 562；旧批也有多组相同情况。这证明 retained-address 映射没有覆盖全部翻译行为，但不能据此推断运行时多执行了 562 条指令。

## 3. 旧 qword 表与真实 trace 的关系

从 `runtime_bugland2.bin` 的 `0x180c64ebd` 读取 1612 个 qword，全部指向 `.bugland`。以静态反汇编中 676,864 个 `.bugland` 指令起点为总体，对 trace 地址交集做均匀覆盖基线：

| 捕获 | trace 交集中命中的旧表入口 | 均匀期望 | 观测/期望 | 近似 z |
|---|---:|---:|---:|---:|
| `vm_trace_capture3` | 92 | 57.61 | 1.60× | 4.64 |
| `vm_trace_capture4` | 113 | 74.62 | 1.51× | 4.58 |

这表明旧表入口地址在真实加密 VM 的已翻译代码集合中有统计富集，支持“部分 handler 代码地址跨会话仍有结构价值”。但它仍不能证明这些地址是由某次具体 dispatch 索引选中的：

- 新批单次调用命中旧表入口 135 或 136 个，所有命中的 transform 次数都恰为 1；这不等于运行时只执行一次；
- 已知 dispatch helper `0x1809a57e6` 与最终 `jmp rax @ 0x1809a585f` 的 transform 次数也为 1；
- 地址文件没有运行时 instruction 顺序、分支边或寄存器值；
- 旧表入口本身也是普通代码标签，混淆控制流可以从别处经过它。

所以目前不能从这 135/136 个候选中挑出 `jmp rax` 的真实后继，更不能由出现顺序还原 opcode 流。

## 4. 当前可证 dispatcher 语义

在旧同步不足的 runtime 中，已经静态确认的 helper 语义仍成立：

```text
VIP   = qword [RBP+0x6d]
raw   = word  [VIP+4]
T     = qword [RBP+0x85]
index = (raw + dword [RBP+0x0a]) & 0xffff
handler = qword [T + index*8]
VIP  += signed dword [VIP]
jmp handler
```

但旧 dump 的 `[RBP+0x0a]`、`[RBP+0x6d]` 与真实加密调用并非同刻状态。旧模拟产生的高索引越界已证明是跨时刻状态拼接，不能用于给 7 组验证集还原 rolling key。

## 5. 对当前“算法已经解到哪”的校正

已经闭合的事实：

- 外层加密函数边界、5 个参数、KID、32-byte 会话 key-material、12-byte nonce、等长 ciphertext、16-byte tag；
- 7 组同会话 `(key-material, nonce, plaintext, ciphertext, tag)` 正向验证集；
- VM 入口 `0x181523001`、外层 dispatcher `0x180c43fdd`、一个可证的动态 dispatch helper；
- 标准 AES/ChaCha/Salsa/RC4 等候选与已测试派生均未匹配。

尚未闭合的核心：

- `kid || key-material` 在 VM 内的实际 key schedule；
- nonce 如何进入状态；
- 每字节/每块的 keystream 生成；
- tag 的认证输入、AAD 与累积/收尾规则；
- 内层 `report_packet` 是否复用同一 VM 原语。

因此，当前不能把“私有 ARX 流密码”当作已经证明的算法名。严谨表述应是：标准候选未命中，被翻译代码区域含大量算术/位运算，但 VM 解释器开销和截断地址明细尚未被剥离，真实轮函数仍待恢复。

## 6. 下一步

离线优先路线：

1. 以 trace 中已翻译地址约束静态 CFG，确认哪些旧表入口能通过直接控制流回到 dispatch helper；
2. 对这些入口提取基本块的寄存器/VM-context 读写摘要，按 `[RBP+offset]` 副作用聚类 handler 语义；
3. 不再从旧异步 `[key,VIP]` 启动 VM，只把旧 dump 用作代码与表结构来源；
4. 用 7 组验证集作为唯一最终门槛：正向输出必须逐字节匹配 ciphertext 与 tag。

如果将来有安全、隔离的本地复现环境，最小新增动态证据应是 `0x1809a585f` 前后的有序基本块与同刻 `RAX/RBP/[RBP+0x0a]/[RBP+0x6d]/[RBP+0x85]`，而不是再抓无序唯一地址集。当前不建议在已进入风险状态的线上游戏会话重复附加。

## 7. 完整性

```text
analyze_maxhook_vm_trace_coverage.py
3ffbcbdb4f724bd28ba558c414e9c14fa7d679d21dc4ee7cfc252036b5d7a539

maxhook_vm_trace_coverage.json
39276d42303aab87ed11d30df720c6f822f8f1d4890bf6708e00e86d18663629

capture_maxhook_vm_trace.js
9ffee774d0283d4b55e08b2846427bf339c494a258a9bfac7889790791452c43

runtime_bugland2.bin
3a8e093afbf678fec5b4a84e5759b4d030f8ad39b52eac81a872dfe581449f26

disasm_unpacked.asm
2a38e29563adff0a142e18687de08d74e625623180ebd08fd2cba30f802697d4
```

脚本已通过 `python -m py_compile`、两批真实捕获解析、声明地址数与文件行数一致性校验、旧表 1612 项范围校验和连续两次输出 SHA-256 完全一致的确定性验证。
