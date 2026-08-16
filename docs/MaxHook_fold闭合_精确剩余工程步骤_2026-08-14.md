# MaxHook fold 闭合 — 精确剩余工程步骤（交接文档）

日期：2026-08-14
范围：纯离线。本文精确指定 fold 闭合（byte 级密钥流复现）的剩余工程步骤，供后续会话执行。

---

## 一、已完成（无需重做）

- 协议栈结构 100% 复现（13 项组件，见权威报告）
- 执行链完整走通（373 步，`walk_chain_v2.py`）
- fold 输入槽精确识别（`+0x1ed`/`+0x18a`/`+0x1dd`/`+0x265`/`+0x205`/`+0x245`）
- writer ABI 证明（S10→RDX→store32）
- 24 组校验对（5 会话）

## 二、剩余 3 步（确定性、纯离线）

### 步骤 1：定位 nonce PRNG 熵源

nonce 是 12B，VM 内部自定义 PRNG（非 cpuid，非 import）。方法：
1. 在 full emulator（`emulate_maxhook_encrypt_boundary.py`）加 memory-write hook 到
   output_object+0x20（nonce 字段）；
2. 追踪写 nonce 前的指令序列，定位熵源（可能是 `GetTickCount`/`QueryPerformanceCounter`
   经 VM 内部解析，或自定义 LCG seed 自多源）；
3. 记录熵源指令地址。

### 步骤 2：stub PRNG 返回 captured nonce

1. 在熵源指令地址 hook，注入 captured nonce（如 `c38d500ac2ae8d2611ae1749`）；
2. 使 nonce 字段 = captured nonce（确定性）。

### 步骤 3：执行 → 校验

1. 运行 full emulator（或 walker）用 stub 后 PRNG + 正确 key/nonce；
2. 捕获 store32（`0x18041a860`）→ keystream；
3. 与 captured ciphertext 校验（24 组，`ciphertext = plaintext XOR keystream`）。

## 三、关键提示（避免走弯路）

1. **walker 与 emulator 的差异**：walker（逐 handler 跟随 stub）追踪 dispatch 链但错过
   store32（经 `popfq;ret` trampoline 在 handler 内到达）；full emulator（连续）在
   key-schedule 循环挂起。需结合两者：用 walker 的正确 INIT 演化 + emulator 的 store32 hook。
2. **seed 时序**：fold 输入槽（+0x180..+0x2db）需在 **INIT 完成后、keystream 循环入口**
   （walker step ~169）seed，非起始（INIT 会重置）。
3. **flag 字节 +0x162**：位置依赖（0xC3 稳态 / 0x69 边界），walker 已正确演化，勿手动改。
4. **正确 blob**：`runtime_bugland2.bin`（sha256 3a8e093a...），非 dump region（关键值等价但
   prior session 用的是前者）。

## 四、数据速查

| 项 | 值 |
|----|-----|
| key (vm_context_capture2 call 1) | `32206F9C196327AD276821AC8EBC7F80FE82D84CF72A4F7C1BAF508C97D3AEA8` |
| nonce (call 1) | `c38d500ac2ae8d2611ae1749` |
| ground-truth keystream[0:8] | `9bd9300fdf47a800` |
| key (writer_sync call 1) | `347230E63EEC999571342BE4417C430A6EBC3C82F27142361C1B5FEF02B4ACD9` |
| nonce (writer_sync call 1) | `96e71401fc4f5faa040e5ca1` |
| ground-truth word0 | `0xdfa1e432` |
| store32 | `0x18041A860` |
| trampoline | `0x180c2775c` (popfq;ret) |
| handler 表 | `0x180C64EBD`（1612 项） |

## 五、交付物

| 资产 | 路径 |
|------|------|
| 本交接文档 | `MaxHook_fold闭合_精确剩余工程步骤_2026-08-14.md` |
| walker | `walk_chain_v2.py` |
| full emulator | `emulate_maxhook_encrypt_boundary.py` |
| 权威报告 | `MaxHook_协议栈逆向最终报告_权威版_2026-08-14.md` |
