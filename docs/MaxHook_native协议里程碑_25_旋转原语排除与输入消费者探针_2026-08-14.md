# MaxHook native 协议里程碑 25：旋转原语排除与输入消费者探针（2026-08-14）

## 一、决定性纠偏

本轮做了同一次调用内的统一捕获：输入明文、input64、输出 nonce/ciphertext/tag 与最后 768 个旋转命中共享同一个 call_id。结果证明：

- call 1：plaintext 745 B，nonce `f62ca3...`，keystream SHA-256 `3992d23b...`，rot hits 13,613；
- call 2：plaintext 1,387 B，nonce `bc5a8b...`，keystream SHA-256 `232988c7...`，rot hits 23,723；
- 两次调用最后 768 个旋转的 `(site, op, cl, before, after)` **768/768 完全相同**；
- 两次 keystream、nonce、plaintext 均不同；
- 两次尾窗站点分布也完全相同：`a164be=107, a59e63=104, b5f49c=390, af6547=162, b3cbf4=5`。

因此五个 `rol/ror dword [rax],cl` 站点已经可以从“外层密码核心候选”中排除。它们是真实执行的 VM 通用位操作/控制流混淆原语，但其操作数并未承载这两次调用的 nonce/keystream 差异。

这也解释了此前的高频固定旋转量和大量重复 18-step 模板：它们是 VM 解释/盲化机制的固定轨迹，不是 RC5 风格密码轮。

## 二、context 读取纠错

上一版尾窗脚本对所有非对齐 context 偏移都读 `u64`，导致相邻字段混合。例如 `context+0x6d` 的 VIP 与后续字段重叠，不能把这些大整数直接解释为独立槽值。

现已按字段宽度修正：

- `+0x0a` rolling key：u32
- `+0x5d/+0x162` flag：u8
- `+0x6d/+0x85` 指针：u64
- 其余已知槽按 u32/u64 单独读取

旋转 skeleton 校验也已修正：并非所有站点在 rotate 后立刻 `pushfq`；真实后值仍由 `iterator.keep()` 后 callout 验证，61,023 条旧样本和本轮 27,336 条样本均 mismatch=0。

## 三、新真机捕获

目录：`target/rot_tail_capture_20260814/`

| call | plaintext | rot hits | tail verified | mismatch |
|---:|---:|---:|---:|---:|
| 1 | 745 | 13,613 | 768 | 0 |
| 2 | 1,387 | 23,723 | 768 | 0 |

游戏在两次重型尾窗捕获后仍存活并 Responding=True。随后目标进程自行退出；下一次输入访问探针附加失败是 `process not found`，不是脚本或 Frida 崩溃。

机器可读分析：`target/rot_tail_capture_20260814/analysis.json`。

## 四、标准密码再验证

针对本轮两组同步样本重新测试：

- AES-GCM，AAD=null/empty/KID ASCII/KID binary：零命中；
- ChaCha20-Poly1305，同一组 AAD：零命中；
- AES-256-CTR，nonce(12B)+counter(4B)，BE/LE、counter 0..3：零命中。

与旧验证集结果一致。

## 五、真实输入消费者现状

离线模拟已闭合：

- KID/input64 字符串顺序扫描：`0x180322e30`；
- input64 偶/奇 hex 字符读取：`0x1804ad4e8 / 0x1804ad566`；
- 32-byte decoded key 写入：`0x18001c563`；
- decoded key heap：离线 `0x20000100000`；
- 到 1,296,634 指令崩溃前，decoded key 与 plaintext data 的读取次数仍为 0。

说明目前抓到的 VM 大段执行（包括五个 rotate handler）仍在环境解密、dispatch 或参数准备阶段；真正 keystream 生成在其后。

## 六、新增探针

新增 `target/capture_maxhook_input_access.js`：

- 只在明文 `.text` encrypt 入口 Interceptor；
- 用 MemoryAccessMonitor 同时监控 input32、input64、plaintext 三个真实 heap buffer；
- 输出首次访问 RIP、操作类型、buffer offset；
- 目标是直接定位真机 plaintext 的第一个消费者，从而绕过 1.3M 指令的离线缺失内存死结。

脚本已通过 Frida compile-only。因 javaw 在运行前已退出，尚未获得动态结果；下一次游戏进程启动后应优先运行此探针，而不是继续抓 rotate。

## 七、下一步优先级

1. 启动目标后运行 `capture_maxhook_input_access.js`，定位 plaintext/input64 的真机消费者 RIP。
2. 若消费者位于 `.text`，直接做窄函数级 Stalker；若在 `.bugland`，把消费者 RIP 加入 Stalker `putCallout`，抓其源/目标指针和值。
3. 同步监控输出对象或新分配 ciphertext buffer 的第一次写入，构建 `plaintext read -> state -> ciphertext write` 的最短动态切片。
4. 不再把五个 rotate handler 当密码轮函数证据；它们只保留为 VM ISA/控制流指纹。
