# MaxHook native 协议里程碑 24：旋转点真机前后值闭合（2026-08-14）

## 本轮结论

1. 修复并真机执行了 `capture_maxhook_rot.js`：只在明文入口 `0x180324610` 使用 Interceptor，在 `.bugland` 内仅用 Stalker `putCallout`，成功抓到五个旋转点的 `rax/cl/[rax]` 前值与真实执行后的 `[rax]`。
2. 30 秒内完成 3 次调用：分别捕获 13,613、23,687、23,723 条旋转；总计 61,023 条，`dropped=0`，前后值按 x86 32 位 ROL/ROR 公式验证 **61,023/61,023**，错配 0。游戏进程保持存活、Responding=True。
3. `dump_out/41264` 精确覆盖审计确认：共 10,765 文件（10,764 个 region bin），约 5.756 GB；地址 `0x1c700000000`、`0x86dfff0f8`、`0xc90000000`、`0x24d000000` 均不在任何 region 范围内。旧 dump 与 `vm_context_capture2` 确属不同会话。
4. 重要纠偏：五个旋转点是**通用 VM 位旋转原语**，不能再把全部命中直接等价为“密码轮”。证据：
   - 调用 2 与调用 3 的前 23,552 条旋转在忽略临时槽地址后语义完全相同；只有尾部约 171 条开始分叉，末尾又有 134 条共同后缀。
   - 大量高频固定模板（固定 count=18/11/21 等）重复数百至上千次，目标主要位于固定 VM context `0x18098c884` 附近，而非独立密码状态缓冲区。
   - 因此此前“5 个旋转点 = ARX 密码核心”的结论过强。它们证明 VM 使用数据相关旋转，但真正与 nonce/plaintext/output 相关的子区间必须通过跨调用差分和数据流进一步隔离。

## 捕获结果

- 输出目录：`target/rot_capture_20260814/`
- 机器可读摘要：`target/rot_capture_20260814/analysis.json`
- 可复用分析器：`target/analyze_rot_capture.py`

每次调用命中数：

| call | hits | verified | mismatch | dropped |
|---:|---:|---:|---:|---:|
| 1 | 13,613 | 13,613 | 0 | 0 |
| 2 | 23,687 | 23,687 | 0 | 0 |
| 3 | 23,723 | 23,723 | 0 | 0 |

调用 2 的站点分布：

| RVA | 指令 | hits |
|---|---|---:|
| `0xaf6547` | rol dword [rax], cl | 8,541 |
| `0xa164be` | rol dword [rax], cl | 7,468 |
| `0xa59e63` | ror dword [rax], cl | 2,909 |
| `0xb5f49c` | ror dword [rax], cl | 2,890 |
| `0xb3cbf4` | ror dword [rax], cl | 1,879 |

## 脚本修复点

原脚本存在三个关键问题：

1. 只抓旋转前值，没有后值；
2. transform 闭包直接引用循环变量 `insn`，执行 callout 时地址可能已变化；
3. 每调用仅保留 5,000 条，会截断真实的 13k–23k 序列。

现已改为：

- 每个站点捕获稳定的 site 元数据；
- 在 `iterator.keep()` 前后各插一个 callout，分别抓 before/after；
- 记录 `expected_after` 并现场验证；
- 以 thread-id 映射调用状态，避免 transform 生命周期错误；
- 上限提高至 200,000，并显式报告 dropped；
- Frida compile-only 已通过。

## dump 审计补充

`regions.csv` 有 10,584 行，而目录有 10,764 个 region bin；但按文件名直接解析全部 region 后，四个新会话地址仍均未覆盖。旧 dump 的主体堆地址集中在 `0x1ef.../0x1f0...`，与新会话栈 `0x86d...` 及相关对象/数据地址不一致。

注意：直接拿当前磁盘 `MaxHook.dll` 的文件偏移与旧运行时 region 比较只得到约 9.88% 相同，这是因为当前磁盘文件与旧的 `MaxHook.runtime-unpacked.dll` 并非同一布局/镜像，不能推翻里程碑 20 使用正确映射方法得到的 99.97% 四字节一致结论。

## 下一步

最高优先级不再是盲抓全部 rotate，而是隔离调用尾部的输入相关窗口：

1. 在同一脚本中同步记录 plaintext 长度、输出 nonce/ciphertext/tag，以便将调用 2/3 的差异与真实样本对齐。
2. 对最后约 256 个旋转命中额外抓取完整寄存器组、VM context 小窗口及 VIP/rolling-key；不要对全部 23k 命中做重型 dump。
3. 以调用 2/3 的共同前缀 23,552 为切点，追踪第一个分叉前后的非旋转 VM 原语（add/sub/xor/bswap、内存读写），确认分叉究竟来自消息长度、nonce、tag，还是仅 VM 控制流尾声。
4. 只有当某段状态能与 `plaintext XOR ciphertext` 或 nonce 建立对应关系后，才把它认定为外层密码核心；否则五个 rotate handler 只能视为通用 VM ISA 原语。
