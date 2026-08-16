# MaxHook native 协议里程碑 20：patch 实验纠正 base 并推进到 32-byte key 消费者

时间：2026-08-13（Asia/Shanghai）
范围：完全离线 Unicorn 重放（session 2 / call 4），带 `--patch-stack-value` 栈槽 patch 实验。

## 结论

里程碑 19 把 545691 崩溃归因于"base 槽被零写"，并把成功组 base 记为 `0x1807b6980`。本轮 patch 实验**纠正了 base 值**，并把执行推进到里程碑 18 遗留目标——**32-byte hex 解码 key buffer（离线 `0x20000100000`）的第一位消费者**：

1. 正确 base 是 **`0x1807b5dd0`**（一个明文指针表基址，磁盘值 `0x1806a1ed0`），不是里程碑 19 的 `0x1807b6980`；
2. `0x1807b6980` 区域是**加密/混淆表**（磁盘上 `0x1807b6ad8 = 0x10f8e912a3b29232` 是垃圾，不是指针），用它做 base 会把 VM 导向加密表项，546528 处 `mov eax,[0x10f8e912a3b29236]` 崩溃；
3. 用正确 base `0x1807b5dd0` 反复 patch，执行从 545691 推进到 **1,296,634 指令**，在 probe 1291463 观察到 `[[context+0x45]] = 0x20000100000`（即解码 key buffer 被解引用）；
4. base 槽零写是**反复发生**的（不是单次），对应 `0x1809c0078`（`pop r8; mov [rdx],r8`）handler 从 VM 数据栈弹出 0 而非有效 base。

## 一、patch 实验机制

新增 `--patch-stack-value / --patch-stack-times`：在 `0x1809c005e`（`pop r8`）执行前，若目标槽 `rdx == context+0x26`（0x18098c8aa，base 槽）且即将弹出的 `[rsp] == 0`，则把 `[rsp]` patch 成给定值。

```powershell
python target\emulate_maxhook_encrypt_boundary.py `
  --boundary-dir target\encrypt_boundary_capture2 `
  --boundary-session 2 --boundary-call 4 `
  --patch-stack-value 0x1807b5dd0 --patch-stack-times 100 `
  --output target\encrypt_vm_patch_base_5dd0_x100.json
```

## 二、base 值的两轮纠正

### 第一轮（错）：base = 0x1807b6980

- 越过 545691，推进到 546528；
- `[[context+0x45]] = [0x1807b6ad8] = 0x10f8e912a3b29232`（加密垃圾）；
- 546523 `mov r8,[rax]` 得 `0x10f8e912a3b29236`，546528 `mov eax,[r8]` 崩溃。

磁盘验证（`MaxHook.runtime-unpacked.dll` `.data`）：

```text
0x1807b6930 = 0x18088f9a8   （有效模块指针，纯文本表项）
0x1807b6ad8 = 0x10f8e912a3b29232  （加密垃圾）
0x1807b6ee4 = 0xa0d2d95a7c958fdf  （加密垃圾）
```

`0x1807b6980` 区域 59% qword 是模块指针、41% 是加密值——**混合的、运行时部分解密的表**。用它当 base 会命中未解密项。

### 第二轮（对）：base = 0x1807b5dd0

成功组真实数据流（`encrypt_vm_ctxwrites.json`）：

```text
530377  0x1809e6728  [context+0x45] = 0x1807b5dd0   （真实 base）
531068  0x180bd46b7  [slot] = 0x16c
531339  0x180a728e5  [slot] <<= 2 -> 0xb60
531621  0x180bb255c  [slot] += base -> 0x1807b6930   （可读目标）
532016  0x1809bd54c  r11=[context+0x45]=0x1807b6930
532018  0x1809bd556  r11=[0x1807b6930]=0x18088f9a8   （有效指针）
```

故成功组的 `base + index*scale` 用的是 `0x1807b5dd0`，里程碑 19 的 `0x1807b6980` 是**另一处**（514336 组）的 base，两处不是同一个表。

## 三、用正确 base 反复 patch 的推进

| patch 次数 | 崩溃/停止指令 | 观察 |
|---|---|---|
| 1（base=0x1807b6980） | 546528 | 读到加密表项 |
| 1（base=0x1807b5dd0） | 832202 | 再次 `[context+0x45]=0x158` 崩溃（同模式复发） |
| 100（base=0x1807b5dd0） | 1,296,634 | 到达 key buffer 消费者 |

1.3M 指令时关键 probe：

```text
1291461  0x1809bd54c  r11=0x18098c949  qword=[context+0x45]
1291463  0x1809bd556  r11=0x7ffe1fecd0  qword=0x20000100000  <== 解码 key buffer
```

`0x20000100000` 正是里程碑 18 的 32-byte hex 解码 heap 缓冲。VM 已开始消费它。

## 四、根因仍未闭环

base 槽零写是**反复**的：`0x1809c0078` handler（`pop r8; mov [rdx],r8`）从 VM 数据栈（native RSP）弹出 0 而非有效 base。VM 用 native 栈作为数据栈（pushfq/pop 序列可见），栈槽缺值是**栈 desync**（push 与 pop 的栈位置错位）或**加密 .data 项传播的 0**。

`0x1809c0078` 是通用"把弹出值写入 context 槽"handler（全程执行 ~20 次，每次槽位/值不同），不是专门清零 base。某次字节码序列把有效 base 推入 VM 栈但后来从不同栈位置弹出 0。

## 五、下一步

1. **修根因（优先）**：用 `--watch-stack` 追踪 VM 数据栈 push/pop 配对，定位 base 指针被 push 到何处、pop 从何处读 0，判定是栈 desync 还是加密数据。修栈缺口即可一次性越过，不必 100 次 patch。
2. **继续 patch 前推**：把 base 槽零写 patch 次数加大（或改成"每当 base 槽即将被 0 覆盖就拦截"），看能否一路推进到 plaintext XOR / tag 生成 / OUTPUT 写入。
3. **加密 .data 现实**：`0x1807b6980` 区域是运行时解密表，磁盘/dump 无解密版；若 VM 路径命中它，离线模拟无法自愈。需判断 1.3M 处崩溃 `0x1c7aa206480` 是否又是加密表项。

## 六、工具变更

`emulate_maxhook_encrypt_boundary.py` 新增：

- `--patch-stack-value` / `--patch-stack-times`：目标化栈槽 patch（仅 base 槽且 pending==0）；
- `--watch-stack`：记录执行栈区域全部 read/write 到 `stack_accesses[]`。

## 七、根因精确定位（补充：stack desync 的精确指令链）

用 `--watch-stack`（trace window 530000–545691）追踪 `0x7ffe1fec68` 的完整生命周期，把"栈 desync"收敛到**两条精确指令**：

```text
539296  0x1812af9e2  pop rdx        ; rdx = [0x7ffe1fec68] = 0（陈旧值）
   ↓ rdx=0 传播
539375  0x180c6a131  mov [rsp],rdx  ; 把 0 写回 VM 数据栈，覆盖 base
   ↓
543459  0x1809c005e  pop r8         ; r8 = [0x7ffe1fec50] = 0
543464  0x1809c0078  mov [rdx],r8   ; context+0x26（base 槽）= 0
   ↓
545689  0x1809bd54c  [context+0x45] = 0x158（base 缺失）
545691  0x1809bd556  [0x158] CRASH
```

关键证据（`stack_accesses[]`）：

```text
539291  0x1812af9d0  write 0x7ffe1fec68 = 0x0
539296  0x1812af9e2  read  0x7ffe1fec68 = 0x0     <- pop rdx 读到 0
539300  0x1812af9f1  write 0x7ffe1fec68 = 0x1807b6980  <- base 此刻才被写入（太晚）
```

`pop rdx`（539296）在 base 写入（539300）**之前**就读了栈槽，读到的是上一轮残留的 0。这是 `.bugland` handler 代码（`0x1812af9xx`）内部的 push/pop 配对错位——即真正的**栈 desync**，不是加密 `.data` 的传播。base 值 `0x1807b6980` 本身在 539300 已被正确写入栈，只是被更早的 pop 顺序破坏。

### 真正的根因：TEB.PEB 指针未初始化（已定位并修复）

继续向上追 0 的起源，在 **539286** 找到：

```text
539286  0x180f11e32  65 48 8b 14 25 58 00 00 00  mov rdx, qword ptr gs:[0x58]
   ; rdx = [gs:0x58] = TEB.ProcessEnvironmentBlock（PEB 指针）= 0（模拟器未初始化）
```

`[gs:0x58]` 是 **TEB.ProcessEnvironmentBlock**（PEB 指针）。原模拟器只初始化了 `teb+0x30`（Self）和 `teb+0x188`，**漏了 `teb+0x58`**，导致 VM 读到的 PEB 指针 = 0，这个 0 一路传播成 base 槽零写。

**修复**：在 `emulate_maxhook_encrypt_boundary.py` 增加 PEB 初始化：

```python
peb = 0x7FFDE10000
uc.mem_map(peb, 0x10000)
uc.mem_write(teb + 0x58, struct.pack("<Q", peb))   # TEB.PEB
uc.mem_write(peb + 0x10, struct.pack("<Q", IMAGE_BASE))  # PEB.ImageBaseAddress
```

修复后（无任何 patch），崩溃点从 `[0x158]`（545691）推进到 `[0x4]`（546528）：

```text
修复前：545691  [context+0x45]=0x158 → [0x158] CRASH（base=0）
修复后：545689  [context+0x45]=0x7ffde10158（= PEB + 0x158）
        545691  [0x7ffde10158]=0 → 546528 [0x4] CRASH（PEB 内容未填充）
```

**结论修正**：崩溃 lookup 的 base 是 **PEB 指针**（`[gs:0x58]`），不是 `.data` 表 `0x1807b5dd0`（那是一个更早、不同 lookup 的 base）。PEB 指针本身是 ASLR 随机化地址，VM 很可能用它作为**密钥派生/抗篡改的熵源**。剩余工作是填充 PEB 内容（`PEB+0x158` 等字段应为非零结构指针）。

### 后续：546528 处二次崩溃 = rolling key 解密 desync

PEB 修复越过 545691 后，`[context+0x45]` 在 546245 又被 `0x1809e6728`（`add [r13], rsi`，rsi = `[context+0x81] ^ 0x59623cb8`）写成 `0x4`，546528 `mov eax,[0x4]` 崩溃。数据流：

```text
545297  0x180bceca2  [context+0x45] = 0x7ffde10158   （PEB+0x158，正确）
545975  0x180ade406  [context+0x45] = 0               （又被零写）
546218  0x1809e669e  [context+0x81] = 0x59623cbc
546245  0x1809e6728  [context+0x45] = 0 + (0x59623cbc ^ 0x59623cb8) = 0x4
546528  0x1809bdeac  [0x4] CRASH
```

关键：`[context+0x81] = 0x59623cbc` 与 XOR 常量 `0x59623cb8` 只差 `0x4`，解密结果 `0x4` 是**无效指针**。说明 `[context+0x81]`（rolling key 派生值）本身在模拟里是错的——rolling key 槽 `context+0xa`（`0x18098c88e`）的状态链（546078 `0xa020f892` → 546126 `0xeda9fbd2` → 546194 `0xb4cba7dc`）与真机偏离，导致指针解密失败。

**根因归纳**：这是**多层级的系统性偏离**，不是单一缺口：
1. TEB.PEB（`[gs:0x58]`）——已修复；
2. PEB 内容（`PEB+0x158` 等）——未填充；
3. rolling key 状态机（`context+0xa` 链）——依赖正确执行前序字节码，而前序字节码又依赖 1/2 的正确性；
4. `.data` 加密表（`0x1807b6980` 区域）——磁盘/dump 均无解密版。

每一层修好后暴露下一层，是典型 Themida 多层虚拟化+抗篡改的剥离过程。离线模拟要跑到加密核心（plaintext XOR / tag / OUTPUT），需要逐层补齐环境或逐层拦截。

### PEB 内容填充 = 等价于 100 次 patch（重大简化）

填充 PEB 若干字段（`peb+0x118/0x128/0x158/0x168/0x178` 指向映射 scratch）后，**无需任何 patch**，执行推进到 **1,296,634 指令**（与上一轮 100 次 patch 的 `0x1807b5dd0` 方案完全一致），在 probe 1291463 解引用 key buffer `0x20000100000`。这证明：

- PEB 填充是 base 槽零写的**正确根因修复**，一处修复等价于 100 次打地鼠 patch；
- 下一步崩溃点统一为 `0x1c7aa206480`（`0x180a831db mov r15d,[r15]`）。

### 新发现：系统性 `0x180 → 0x1c7` 指针前缀损坏

崩溃值 `0x1c7aa206480` 的完整来源（`vm_pointer_slot_writes`，`context+0x61 = 0x18098c8e5`）：

```text
1286653  0x1809d0fd6  -> 0x1c7e0f7e75a
1286824  0x1809d139c  -> 0x1c7a46a3b54
1292791  0x180bdfb58  -> 0x1c7abd7e2b9
1293144  0x1809e6728  -> 0x1c7ba35ca8b
...      全部以 0x1c7 开头
1296230  0x180b6264a  -> 0x1c7aa206480  （最终崩溃值）
```

该槽 `[context+0x61]` 在 1.28M 指令后**始终**持有 `0x1c7xxxxxxxxxx`，而模块指针应为 `0x180xxxxxxxxx`（module base 0x180000000）。`0x1c7 - 0x180 = 0x47`——**高 12 位被系统性加了 0x47**。

这是**确定性、一致性的损坏**（不是随机偏离），强烈暗示存在**单一可修的错误常量/缺失初始化**：某个 rolling key 或表项值在模拟里偏了 0x47（或其等价量），导致所有指针解密的前缀从 `0x180` 漂移到 `0x1c7`。

**下一步（高价值）**：定位 `0x1c7` 前缀第一次进入 `[context+0x61]` 的那个 handler（inst 1286653 `0x1809d0fd6` 之前），找出偏 0x47 的常量/初始化，可能一次性修复所有后续 rolling-key 指针解密。

### 追踪 0x1c7 前缀到唯一起源：inst 34216 rolling key 更新

全量 `vm_pointer_slot_writes` 搜索第一个 `0x1c7` 前缀值，定位到 **inst 34216**：

```text
34216  0x180a50c3d  xor dword [r14], r11d   ; r14=context+0xa（rolling key 槽）
   [rolling_key] = 0x6e3ac3ba ^ 0x6e3b04cb = 0x0001c771
```

`r11d = 0x6e3b04cb` 的构造链（trace 34180-34216）：

```text
34200  0x180a50be9  add r11d, [rax]   ; r11d = 0x4111 + [rolling_key] = 0x4111 + 0x6e3ac3ba = 0x6e3b04cb
34216  0x180a50c3d  xor [r14], r11d   ; [rolling_key] ^= r11d  -> 0x1c771
```

即 rolling key 更新规则为 **`key ^= key + const`**（const=0x4111，字节码派生）。`0x6e3ac3ba ^ 0x6e3b04cb = 0x1c771` 是**小值**，因为 `key` 与 `key+0x4111` 只差低 14 位。

**关键判断点（待定）**：`0x1c771` 是该 rolling key 更新规则的**合法结果**（`key ^= key+small_const` 天然产生小值），还是**错误值**？这决定了 `0x1c7...` 指针前缀是"合法 relocation 基址"还是"损坏"。判定方法：对比早期（inst 34216 之前）成功 lookup 的 rolling key 是否也经历同样的 `key ^= key+const` 序列，以及 `0x1c7...` 地址是否本应是 `0x180...` + relocation delta。

### 关键结论：模拟器执行正确，`0x1c7...` 是合法结果，崩溃是缺映射

追踪 `0x4111`（rolling key 更新常量）来源（trace 34170-34180）：

```text
34173  0x180a50b5b  mov r11, [r11]     ; r11 = [context+0x6d] = VIP = 0x181539a2d
34174  0x180a50b5e  add r11, 0xc       ; r11 = VIP + 0xc = 0x181539a39
34178  0x180a50b7a  movzx r11, [r11]   ; r11 = word [0x181539a39] = 0x4111
34200  0x180a50be9  add r11d, [rax]    ; r11d = 0x4111 + rolling_key_old
34216  0x180a50c3d  xor [r14], r11d    ; rolling_key ^= r11d -> 0x1c771
```

`0x4111` 是 **VM 字节码里的字面常量**（从 `VIP+0xc` 读出，`.bugland` 固定内容），**不是损坏值**。因此整个 `key ^= key + 0x4111` 序列是**合法 VM 字节码**，`0x1c771` 是**正确结果**。

**这推翻了"加密 .data 导致偏离"的假设**：模拟器在 inst 34216 之前执行 VM 字节码是**正确的**，`0x1c7...` 指针是合法计算的结果，不是损坏。真正的问题是 `0x1c7aa206480`（约 7.8 TB 高地址）在模拟器里**未映射**，而真机该地址有内容。

`0x1c7...` 高地址可能的身份：1) Themida 的**重定位镜像**（relocated image）；2) 运行时分配的**表**（dispatch 表/解密字节码）；3) loader 建立的其他映射。下一步：确定 `0x1c7...` 基址真机内容，若是重定位镜像可用 reloc 信息重建映射。

### 最终判定：`0x1c7...` 是 Java 进程堆地址，模拟器未映射

`runtime_overlays` 显示模拟器只映射了 MaxHook 模块（`0x180000000`-`0x182f30000`）+ 合成栈/堆/PEB。而崩溃指针 `0x1c7aa206480`（约 1.95 TB）与函数实参指针 `0xc9d34ff410`（约 13.9 TB，output object）**同属 64 位用户态高地址**（javaw.exe 进程内存）。

关键事实链：
1. `0x4111` 是合法 VM 字节码常量（`VIP+0xc` 读出），rolling key `0x1c771` 是正确结果；
2. `0x1c7e0f7e75a` 由 `pop rsi` 从 VM 数据栈取出（1286033 `0x180990af0`），是 VM 合法计算并压栈的值；
3. 所有 `0x1c7...` 值共享 `0x1c7` 前缀 = 单一堆区域（Java 进程在 ~1.95 TB 的 native 堆分配）；
4. 模拟器未映射该区域 → 1296634 解引用崩溃。

**结论**：加密函数（`0x180324610`）运行时访问 **Java 进程的 native 堆**（约 1.95 TB 区域）作为工作状态/表，而 offline 模拟器只映射了 capture 里的少量对象（`0xc9d34ff410` 等），**没有完整 Java 堆**。这是比"加密 .data"更根本的缺口：VM 的运行时工作内存驻留在 Java 进程堆里。

**下一步（决定性）**：确定 `0x1c7...` 区域真机内容——两个方向：
1. 从 live capture 恢复该堆区域（Frida 抓取 `0x1c7...` 附近内存）；
2. 判定该区域是否为 VM 自己的表（可由模拟器合成，如 dispatch 表/字节码表）。

### 重大纠正：模拟器 dispatch 插桩地址错误（不影响执行正确性）

对比里程碑 16/17 静态分析发现，模拟器的 `DISPATCHER = 0x180C43FDD` **错了**：

```asm
0x180c43fdd  call 0x180c43fe2   ; 这是 bootstrap call-next 桩（序言），不是 VM dispatcher
0x180a97f70  mov r14, rbp       ; 这才是真实 VM dispatcher（读 [context+0x5d] 标志/VIP word）
```

因此之前的 `dispatch_trace`（inst 75612+ 的"垃圾 index"）是**插桩噪声**（记录的是 bootstrap 桩的 call-next，且 index 公式 `(key+word[VIP+4])&0xffff` 也与里程碑 17 的真实公式 `index=(word[VIP+0]-key+0x5214a88c)&0xffff` 不符），**不是执行偏离**。

**关键验证**：模拟器的 rolling key 链与里程碑 17 静态分析**逐项吻合**：

```text
里程碑17:  key_low32 0xffffffa5 -> 0x02dba4ba -> ... -> 0xadeb35f2（第4级 dispatch）
模拟器:    717  ->0xde50121（old 0xffffffa5）
          724  ->0x2dba4ba（=0x02dba4ba ✓）
          1256 ->0xadeb35f2（✓ 与里程碑17 第4级 key' 一致）
```

**结论修正**：模拟器**执行是正确的**（至少前 4 级 dispatch 与静态分析一致），`0x1c7...` 崩溃是**第 4 级 dispatch 之后**（inst >~1256）由某个**错误输入**（PEB 内容/Java 堆/加密表）引起的真实偏离，不是插桩或执行逻辑 bug。

已修正 `emulate_maxhook_encrypt_boundary.py`：`DISPATCHER` 从 `0x180C43FDD` 改为 `0x180A97F70`（另存 `BOOTSTRAP_STUB=0x180C43FDD`）。下一步应扩展里程碑 17 的静态链分析到第 4 级之后，定位 rolling key 首次偏离的确切 handler。

### 加密核心不可达 + 流密码结构确认（Round 8）

关键发现：

1. **加密核心在 1.3M 指令崩溃点之外，模拟器不可达**：plaintext 数据（`0x24d278e7680`）和 32-byte key buffer（`0x20000100000`）在整个 1.3M 指令执行中**读取次数均为 0**。模拟器在到达 keystream 生成/plaintext XOR 之前就崩溃了。

2. **流密码结构确认**（从 verify set 直接计算）：
   - `ciphertext 长度 == plaintext 长度`（745=745, 1273=1273），无 padding → **流密码**；
   - `keystream = plaintext XOR ciphertext`，高熵无重复结构（安全密码，无简单弱点）；
   - 结构 = `keystream = f(key=32B, nonce=12B, counter)` + `tag = MAC(...)`（16B），形似 ChaCha20-Poly1305 但为标准密码 0 命中的**自定义私有流密码**。

3. **排除 ARX 密码**：`.bugland` 全文仅 2 条 `rol rbx,0x20`（32 位交换，非密码轮转），排除 ChaCha/Salsa 类 ARX 轮函数。

4. **handler 表 1612 个全唯一 stub**：`table[0x0000..0x064b]` 全部指向 `.bugland`，1612 个不同 handler。算法恢复需从这 1612 个 handler 中识别加密原语（XOR/ADD/SUB 组合），是海量工程。

**结论**：算法恢复的**唯一路径是静态分析 handler 语义**（模拟器因偏离无法到达加密核心）。已启动 subagent 扩展里程碑 17 静态链分析（第 5 级 dispatch 起），定位 rolling key 首次偏离点。

### 静态链扩展到 ordinal 23，定位偏离在 ordinal 22-23 附近（Round 9）

subagent 扩展静态 dispatch 链到 ordinal 23（`vm_dispatch_chain_extended.json`），关键结果：

1. **ordinal 5-22 的 rolling key 与模拟器逐项吻合**（如 0xadeb35f2 → 0x4a59da5 → 0xe5fe8c5f → 0x45e38ccd，对应模拟器 inst 1256→1453→1747→1989），**证明模拟器执行正确到 ordinal 22**。

2. **ordinal 23（handler `0x1809b6a53`）是偏离点**：该 handler 读 `[context+0x69]`（`and edi,[r8]`）和 `[context+0xf6]`（`add r9d,[r8]`），dispatch index 依赖这两个 context 槽。`context+0xf6` 在模拟器写历史中**始终为 0**（初始化后从未被设为非零）。

3. **存在 0x04 系统性偏差**：模拟器 ordinal 22 的 rolling key `0x7c2c16c3`（inst 5346）与 subagent 静态预测 `0x7c2866c3` 相差 0x04（第二字节 0x2c vs 0x28）。这与之前观察到的 `0x59623cbc ^ 0x59623cb8 = 0x4` 一致——**偏离是小的系统性 0x04 偏差，不是大随机损坏**。

**下一步（高价值）**：精确定位这个 0x04 偏差的来源。它可能是：1) 某个 handler 读的 context 槽（`context+0x69`/`context+0xf6` 或其它）初始值偏 0x04；2) 某个字节码常量在模拟器里被错误解释（如结构体偏移 +0x04）。定位这个 0x04 就能一次性修复偏离，推进到加密核心。

### 精确定位：ordinal 22 偏离 0x04（Round 10）

subagent 最终结果（`vm_dispatch_chain_extended.json` 终版）给出干净 key 序列，**ordinal 22（handler `0x1809d2bc2`）是首次精确偏离点**：

```text
ord22 静态 key_after = 0x7c2c16c7
      模拟器（inst 5346, rip 0x1809d2f07）= 0x7c2c16c3
      差 = 0x04
```

ordinal 5-21 的 key_after 与模拟器**完全一致**（0x4a59da5, 0xe5fe8c5f, 0x45e38ccd, 0xf897, 0x4a5218a, 0xe5ff11f0, ...），首次在 ord22 出现 0x04 偏差。

handler `0x1809d2bc2` 的 rolling key 更新链（关键指令）：

```asm
0x1809d2c22  mov r15d, [r11]        ; r15 = dword[VIP+4]（字节码常量）
0x1809d2c6f  xor r15d, [rsi]        ; r15 ^= [context+0x5d]
0x1809d2c96  or  [r9], r15d         ; [context+0xa]（rolling key）|= r15
0x1809d2cfe  sub [rbx], r15d        ; [context+0x81] -= r15
0x1809d2d2a  add [r8], r15d         ; [context+0x69] += r15
0x1809d2d3e  and [r9], edi          ; [rolling key] &= 0x5057667
```

rolling key 更新依赖 `dword[VIP+4]`（字节码）和 `[context+0x5d]`、`[context+0x81]`、`[context+0x69]` 三个 context 槽。0x04 偏差来源必是其中之一。

**下一步（极聚焦）**：对比 ord22 时 `dword[VIP+4]`、`[context+0x5d]`、`[context+0x81]`、`[context+0x69]` 在静态预测与模拟器实测之间的差异，找出偏 0x04 的那个值，即可一次性修复偏离。

### 纠正：ord22 的 0x04 "偏差"是 subagent 分析错误，模拟器实际正确（Round 11）

逐指令验证 ord22（handler `0x1809d2bc2`）的最终 rolling key 更新（`0x1809d2f07 xor [r9], r8d`）：

```text
r8 = word[VIP+8] ^ 0x7929e6fd
   = 0xe659 ^ 0x7929e6fd        （word[0x18154c79b]=0xe659，与 bugland 文件逐字节一致）
   = 0x792900a4
[rolling_key] = 0x5051667 ^ 0x792900a4 = 0x7c2c16c3
```

**模拟器读取的 `word[VIP+8]=0xe659` 与 bugland 文件逐字节一致**，整个计算链正确，`0x7c2c16c3` 是**正确结果**。

**结论修正**：Round 10 的"ord22 偏离 0x04"是 **subagent 静态分析的错误**（它用了错误的常量/VIP，得到 0x7c2c16c7），**不是模拟器 bug**。模拟器实际正确执行到 ord22（甚至更远，它一路跑到 1.3M 指令）。真正的偏离在 ord23 之后更远处，由某个错误输入（外部数据/加密表）引起。

**下一步（重新聚焦）**：模拟器正确，偏离在 ord23 之后更远处。需继续静态分析到 ord23 之后（subagent 在 ord23 因读到运行时值 `context+0xf6` 而停止），或重新审视 1.3M 崩溃点 `0x1c7aa206480` 的输入来源（哪个 context 槽被外部数据污染）。

### 确认模拟器正确到 ord23（Round 12）

subagent 最终报告声称"ord23 偏离"，但交叉验证发现这是**其 ord22 的 0x04 key 误差（0x7c2c16c7）传导到 ord23 的结果**。模拟器实测（trace 5379-5385）：

```text
5379  0x1809d2fa3  jmp rdi     -> 0x1809d37ea（stub）
5380  0x1809d37ea  jmp 0x1809b6a53   （ord23 handler，与静态分析一致）
5381  0x1809b6a53  ...         （模拟器继续执行 ord23，未偏离）
```

模拟器**正确执行到 ord23 并继续**（一路到 1.3M 指令）。subagent 用错误 key `0x7c2c16c7` 算得 ord23 index `0x798`（`table[0x798]=0x9024b4ff5f` 非 stub），而模拟器用正确 key `0x7c2c16c3` 得有效 dispatch。

**关键方法论发现（subagent 报告）**：
1. handler 内含 **decoy `jmp reg`**（寄存器是垃圾值），必须只接受目标是有效表 stub 的跳转；
2. **context 自修改**：ord22 在 `0x1809d2df4` 把 `context+0x162` 从 0x69 改成 0xf9（`or byte [r12],0xf1`），该标志字节 gate 着 ord23 的混淆分支——**静态 .bin 里的 context 字段值 ≠ 运行期值**；
3. ord22 有数据依赖条件分支 `0x1809d2d81 cmp [r11], rdx`，结果依赖运行期 context 值。

**最终结论**：模拟器**正确执行 VM 字节码**（控制流 + rolling key + 字节码读取全部验证，通过 ord23）。真正偏离（`0x1c7...` 崩溃）在 1.3M 指令更远处，由某个**运行期数据**（加密 .data / runtime-mutated context）引起，模拟器无法离线复现。

### 里程碑 21：真机只读抓取，确认偏离根因是「初始 context 就错」（Round 13）

真机 Frida 只读抓取（`capture_maxhook_vm_context.js` + `vm_context_capture2/`）抓到了**加密入口时刻（onEnter）的 VM context `0x18098c884` 完整 512 字节快照**，取得决定性突破：

1. **`0x18098c884` 是模块内持久 context，跨调用保留**（不是每次重新初始化）。10 次调用的入口 context 大部分是同一稳定态：
   ```text
   key(rolling)=0xffff01a3  VIP=0x181454d15  flag0x162=0x41
   ```
   仅 call5/call9 抓到中间态（onEnter 异步，偶发抓到 VM 已在跑的时刻）。

2. **真机入口 context ≠ 磁盘初始态**：与 `runtime_bugland2.bin` 的 0x18098c884 逐 4 字节对比，**59/128 字段不同**。磁盘上是里程碑17的"初始态"（key=0xffffffa5、VIP=0x181555629），真机入口已经是 key=0xffff01a3、VIP=0x181454d15，且 context 内大量字段指向**已解密的模块地址/栈地址**。

3. **偏离根因就此确认**：离线模拟器从磁盘读的是**加密/初始态 context**，而真机 VM 用的是**跨调用残留的、已解密的 context**。模拟器"前 4 级 dispatch 能对"是因为序言会重新初始化部分字段，但那些"序言不碰、跨调用保留"的字段（59 个差异中的大部分）模拟器用了磁盘加密值 → 跑到 1.3M 指令必然解出垃圾指针 0x1c7... 崩溃。

4. **附带的工程事实**：`.bugland` 里 VM handler 用 Interceptor.attach 会改指令触发 Themida 自校验 → **直接崩游戏**（实测）。所以中段 hook 不可行，只能 hook 明文 `.text` 入口。真机实际栈地址是 `0x86dfff0f8`（非旧 dump 的 `0x7ffe1fec00`，旧 dump 栈地址已失效）。

**下一步**：把真机入口 context（`vm_context_capture2/` 的 512B 快照）灌进离线模拟器，替换磁盘初始态，从头跑，验证能否跨过 1.3M 偏离点。

### 里程碑 22：入口 context 灌入无效 + 关键新线索（Round 14）

1. **灌真机入口 context 快照 → 无效**：新增 `--vm-context-snapshot` 参数，把真机 512B context 灌进模拟器后重跑，结果与之前**完全一致**（inst 1296634、0x1c7aa206480 崩溃）。原因：VM 序言会重新初始化 rolling key/VIP，灌入的"上次调用残留态"被覆盖；且真机入口抓的 0xffff01a3 是"上次加密结束态"，非"本次运行需要态"。

2. **静态 dump 的 .data 仍是加密态**：`dump_out/41264/region_00000001806e0000.bin` 与磁盘 DLL `.data` 99.97% 相同（419733/419840 个 4 字节一致），0x1807b6980 仍是加密值 0xf2475c2d71cd5177。确认 dump 时机是静态（VM 未运行），`.data` 解密态从未被离线捕获。

3. **关键新线索（推翻"非 ARX"结论）**：旧 Stalker vm_trace（`vm_trace_capture4/`）的 mnemonic 分布显示 VM 运行中有 **ror:4590、rol:4300、bswap:4025、vmovdqu:246、vmovdqa:160**。Round 8 说"`.bugland` 全文仅 2 条 rol"是**静态误判**——实际 VM 运行时有大量位旋转/字节序操作，加密核心很可能是 **ARX 类自定义密码（RC5/RC6/Blowfish/自定义 Feistel）**。无 aesenc/aesdec（排除 AES-NI）。

4. **方向 A（Stalker）可行性确认**：旧 vm_trace 脚本用 Stalker.follow 在 `.bugland` VM 上跑通 5 次 call（202958 条指令）**未崩**，证明 Stalker（影子内存、不改原指令）安全。但旧脚本用 transform 回调统计 count，受里程碑15"翻译次数≠执行次数"限制，count 最多 3，无用。正确做法是 **putCallout**（真实执行时触发），旧 `capture_maxhook_crypto.js` 已证明 putCallout 能抓真实运行时数据（成功抓 96 字节 keyread 流）。

**下一步**：方向 A 用 Stalker + putCallout 对 rol/ror/bswap 指令在真实执行时抓操作数，还原 ARX 轮函数；方向 B（子代理并行）从验证集 keystream 做密码分析。

### 里程碑 23：静态密码分析收敛，密码是自定义字节码化流密码（Round 15）

子代理 B 产出 `vm_cipher_static_analysis.json`（8 个分析脚本），得出 5 条可证伪的约束，并纠正了 2 处假设：

1. **keystream 非线性**：7 组同 key 样本的 keystream 前缀 GF(2) 秩 = 7（满秩），证明 keystream **不是 nonce 的仿射/线性函数** —— 排除 LFSR / 线性 / 纯 T-function / XOR 反馈类。nonce 不直接 XOR 进 keystream，无加性计数器，无周期块，tag 是真 MAC（≠任何 keystream 窗口）。

2. **无 S-box / 无 GF(2^8) 乘法**：`.bugland` 全文 0 个 AES S-box、0 个 256 字节置换表、0 个 xtime 常量（xor 0x1b/0x87/0x11b）—— 排除 AES-like / Present / 自定义 SPN / GCM-style。

3. **纠正"非 ARX"误判（双重纠正）**：
   - 上一轮我判"ARX（rol/ror）"是错的——那 2 条 `rol rbx,0x20` 是 trampoline stub 死代码，非轮转。
   - 但子代理 B 判"0 个有效轮转"也不全对——我交叉验证（机器码 `d3 /0`/`d3 /1` + Stalker 翻译）确认存在 **5 条真实 `rol/ror dword [rax], cl`**（数据依赖旋转，RC5 类原语），地址 0x180a164be/0x180b3cbf4/0x180b5f49c/0x180af6547/0x180a59e63。
   - **综合结论**：轮函数主体是 add/sub/xor/and/or/not + 极少量 rol/ror（零散原语，非 ChaCha/Salsa 密集轮转）。

4. **1612 handler = 单层 trampoline stub**：每个表项是 1 指令 stub（`rol rbx,0x20; jmp X` 等死代码）+ jmp 到散布的 body。`movzx` 是字节码取指（`movzx reg,[VIP]` disp=0），非 S-box 查表。

5. **rolling key 与 keystream 分离**：context+0xa rolling key 是 32 位 dispatch 盲化令牌（`key^=key+const`），与密码 keystream 生成器是两套机制。

**最终定性**：密码是 Themida **自定义字节码编译流密码**，状态机 = VM 字节码流本身，由 add/sub/xor/and/or/not + 少量 rol 组成，无任何标准密码结构。全量还原的**唯一路径**仍是：正确模拟到 plaintext XOR 点（卡在 1.3M 的 1.95TB Java heap 缺失映射），或做 key-buffer taint 追踪。仅凭 7 组同 key 样本（无 key 差分、无 plaintext 差分）无法黑盒唯一还原 nonce 混合。

## 八、完整性

SHA-256：

```text
emulate_maxhook_encrypt_boundary.py  见仓库当前提交
encrypt_vm_patch_experiment2.json     （base 0x1807b6980，1 patch）
encrypt_vm_patch_base_5dd0.json       （base 0x1807b5dd0，1 patch）
encrypt_vm_patch_base_5dd0_x100.json  （base 0x1807b5dd0，100 patch，1.3M 指令）
```
