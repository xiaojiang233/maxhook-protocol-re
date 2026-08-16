# MaxHook native 协议里程碑 16：静态证明 bootstrap dispatch 索引 0x2ca

日期：2026-08-13 18:52（Asia/Shanghai）  
范围：精确静态数据流、runtime qword 表和旧 Stalker 首翻译地址交叉验证；未附加进程、未访问游戏服务。

## 1. 核心突破

在纠正 `transform count ≠ runtime hit` 后，已经找到第一条完全不依赖 count 的真实 VM dispatch：

```text
handler table = 0x180c64ebd
bootstrap index = 0x02ca
table[0x2ca] = 0x1809894ba
0x1809894ba = jmp 0x180a97f70
```

最终间接跳转：

```asm
0x180c44ced  jmp qword ptr [rax]
```

此时静态证明 `RAX = table + 0x2ca*8`，所以目标确定为 `0x1809894ba`。`vm_trace_capture4` 的 5/5 调用在该跳转后下一个首次翻译地址也都是 `0x1809894ba`，与静态结果逐项吻合。

与里程碑 10 的 `0x5` 不同：`0x5` 仍只是首翻译候选；本里程碑的 `0x2ca` 来自完整栈/常量/表数据流，可作为真实 bootstrap 索引。

## 2. 索引来源

VM 序言在 `ENTRY_RSP-0x10` 保存：

```text
((0x6af57d4f >> 4) XOR 0x7b502d73) XOR 0x7dff786d
= 0x2ca
```

沿已经静态闭合的 setup 分支到 `0x180c44c9a` 时：

```text
RSP = ENTRY_RSP - 0x98
```

随后：

```asm
0x180c44c9a  push qword ptr [rsp+0x88]
```

因此实际读取地址为：

```text
(ENTRY_RSP-0x98)+0x88 = ENTRY_RSP-0x10
```

读出的就是 `0x2ca`。后续两次复制后：

```asm
0x180c44ca7  pop rbx
0x180c44cb6  shl rbx, 3
```

得到字节偏移 `0x2ca*8 = 0x1650`。

## 3. handler table 基址来源

`0x180c44a23–0x180c44a5a` 的 32-bit 混淆常量可化简为：

```text
term = ((0x6f7f2c0b + 0x7dfaef37) XOR 0x6c9c6b51)
     = 0x81e67013

rva  = 0x7edfdeaa - 0x5effc61f + term + 0x5effc61f
     = 0x00c64ebd
```

接着 `0x180c44a68–0x180c44aa1` 的加减常量成对抵消，只留下：

```asm
0x180c44a86  add rax, rcx
```

其中 RCX 是模块基址，所以：

```text
RAX = module_base + 0x00c64ebd
    = 0x180c64ebd
```

在 `0x180c44cd2 add rax,rbx` 后：

```text
RAX = 0x180c64ebd + 0x2ca*8
```

runtime dump 对应 qword 为 `0x1809894ba`，其精确字节解码为：

```asm
0x1809894ba  jmp 0x180a97f70
```

## 4. 这条证据解决了什么

- 证明 qword 表 `T=0x180c64ebd` 不只是旧异步 context 偶然指向的数据，而是加密 VM bootstrap 静态构造出的真实表；
- 证明表索引上界 `0x64b` 与 bootstrap 索引 `0x2ca` 相容；
- 给出第一个真实 handler/bridge 入口，不依赖 Stalker 执行频率；
- 证明旧 capture 的首次翻译顺序在该节点与真实静态目标一致，可继续作为 CFG 交叉校验，但不能单独当 runtime 目标证据；
- 把下一段分析起点固定为 `0x180a97f70`。

`0x180a97f70–0x180a98103` 自身是下一层 dispatcher：它读取 `[RBP+0x6d]` 的 VIP word、从 `[RBP+0x85]` 取表、更新 VIP，再 `jmp rdx`。下一步需要恢复该时刻 `[VIP]` 的真实 word，从而证明第二个索引，而不是用首翻译候选猜测。

## 5. 新工具与复现

分析器：[`analyze_maxhook_vm_bootstrap_dispatch.py`](./analyze_maxhook_vm_bootstrap_dispatch.py)  
结果：[`maxhook_vm_bootstrap_dispatch.json`](./maxhook_vm_bootstrap_dispatch.json)

```powershell
python target\analyze_maxhook_vm_bootstrap_dispatch.py `
  --runtime-bugland target\runtime_bugland2.bin `
  --capture target\vm_trace_capture4 `
  --output target\maxhook_vm_bootstrap_dispatch.json
```

```text
table=0x180c64ebd index=0x2ca
target=0x1809894ba body=0x180a97f70
capture first-translation cross-check=5/5
```

## 6. 完整性

```text
analyze_maxhook_vm_bootstrap_dispatch.py
022edd58921a634fcdab2f1c395ab3a30b9ff250bf9d5bf310398c0479a2b328

maxhook_vm_bootstrap_dispatch.json
dee71515cbe455ac34d5373317e3ad90dc8e4aa24aa871cb60c38de1ac1bb6fb
```

脚本已通过语法编译、精确指令签名、常量化简、栈偏移断言、qword 表边界/目标验证、5 调用交叉检查和两次输出哈希一致性验证。
