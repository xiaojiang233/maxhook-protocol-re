# MaxHook native 协议里程碑 28：离线重放推进到密钥流生成环入口（2026-08-14）

## 结论

离线 Unicorn 重放（`emulate_maxhook_encrypt_boundary.py`）在两项关键修正后，从 1.3M 指令的“未映射堆”崩溃点推进到约 4.07M 指令，进入 `.bugland` 的逐字节密钥流生成环，并定位到第二处缺失的运行时状态槽。这是离线路径迄今最深的推进。

## 关键进展

### 1. 第一处未映射地址的根因修正

里程碑 20 记录的崩溃 `0x1c7aa206480` 并非加密 .data 表，而是 VM 把 `context+0x61` 当作普通数据槽反复写入运行时值，最终在 handler `0x180b6264a add qword [rcx], r9` 里写出了一个被后续当作指针解引用的值。

新增 `--patch-context-pointer61` 修正：

- 只 patch `rip == 0x180B6264A` 且写 `context+0x61` 的那一条指令；
- 用真实机器捕获到的槽值 `0x180835f10`（`keystream_history_capture_20260814` 4 个快照一致）替换；
- 共 4 次 patch，之后执行平稳越过原崩溃点。

### 2. 第二处缺失槽：context+0xc5

在 `0x180bf1eb2 mov r15d,[r15]`，`r15 = [context+0xc5] = 0`（离线未初始化），导致 `0x180a831db mov r15d,[r15]` 读 `[0]` 崩溃。

该 `0x180bf1d..` 段是 `.bugland` 逐字节密钥流生成环（与已定位的 `0x18099089e → 0x180990a93 → 0x180990b21` 同族），`context+0xc5` 是运行时 key-schedule 产生的密钥流源指针，离线无法从磁盘 dump 重建。

## 判定

- 离线环境解密/参数准备前段已完全贯通；
- 剩余阻塞不是“未映射内存”的机械问题，而是 **运行时 key-schedule 产生的密钥流状态**（context 槽 `+0x61`/`+0xc5` 及更广的状态表），这些值只存在于真机运行态，静态 dump 与磁盘镜像都不含。

因此纯离线重放无法到达 `0x1809c5561` XOR 边界或 `0x18041a860` store32 输出。结合里程碑 27（writer 输出 == 真密钥流 3/3）与多轮“标准原语 0 命中”的结论，最终算法恢复必须回到**真机、窄范围、单入口 Interceptor + Stalker** 捕获 VM 状态槽，而非继续扩展离线合成。

## 产物

- `target/emulate_maxhook_encrypt_boundary.py` 新增：
  - `--synthesize-unmapped-reads` / `--max-synthetic-pages`
  - `--patch-context-pointer61`
  - `STORE32` / `GENERATOR_CANDIDATE` 观察点（store32_trace / generator_candidate_trace）
  - `MEMSET_FUNCTION=0x1805D11B0` CRT 桩
- 运行结果：
  - `target/encrypt_vm_pointer61_exact.json`（精确 patch，4.07M，第二处崩溃）
  - `target/encrypt_vm_pointer61_plus_synth.json`（加合成读页）
  - `target/encrypt_vm_second_missing_trace.json`（第二处缺失数据流 trace）
- `target/generator_candidate_full_disasm.txt`：`0x18041a8a0` 完整反汇编（确认其调度索引依赖加密表 `0x1807d7cf0`，磁盘为加密垃圾，离线无法恢复正确 fn 索引，全部塌缩成 0xd）。
