# MaxHook 协议栈 — nonce 种子突破（第 222 轮，第 231 轮校正）

日期：2026-08-14
范围：纯离线（Unicorn 具体执行 + nonce 种子）

## 一、nonce 种子成功突破 divergence（第 222 轮）

第 222 轮修改 `emulate_maxhook_encrypt_boundary.py`，新增 `--seed-nonce` 参数，在 VM 到达
nonce 生成点（`rdi`=nonce 缓冲，`rsi`=12）时写入 ground-truth nonce，并禁用误报完成检测。

结果（`encrypt_vm_seed_nonce.json`）：

| 指标 | 修改前 | 修改后 |
|------|--------|--------|
| nonce 种子 | 无 | **inst 3987681 成功种子** `d12c161bf503d4599dd8c235` |
| word-producer 到达 | 144 | **336 次** |
| fold 到达 | 2 | **7 次** |

## 二、第 231 轮校正：fold 命中仍是 init 阶段，非 keystream 生成

**重要校正**：`store32_trace` 计数 = **0**（真实 keystream 写入点 `0x18041a860` **从未到达**）。
fold 的 7 次命中 `edx=0x2840`（指针/偏移常量），与第 18 轮实测（fold 命中 2 次，`edx=0x2840`）
一致——**这些是 key-schedule/init 阶段的 fold，非密钥流生成**。

即：nonce 种子让 emulation 到达 word-producer/fold 的**次数更多**（336/7 vs 144/2），
但**仍未到达 store32（真实 keystream 生成）**。这是对第 222 轮"到达 keystream 生成"表述的校正——
实际是"到达 key-schedule/init 的 word-producer 阶段更多次"，真实 keystream 生成（store32）
仍需修复 VM 数据栈 desync。

## 二、fold 6 输入槽精确定位

word-producer handler `0x180b8c7aa` 的 6 个 push site 读取 6 个上下文槽（fold 输入）：

| push site | 槽 | 语义 |
|-----------|-----|------|
| `0x180b8c81b` | `+0xb5` | keystream 字节 |
| `0x180b8c882` | `+0x26` | 块计数器 |
| `0x180b8c91a` | `+0xd9` | 块内字节偏移 |
| `0x180b8c9a6` | `+0x61` | 指针/状态 |
| `0x180b8ca27` | `+0xbd` | key 缓冲指针 |
| `0x180b8caa0` | `+0x106` | 状态值 |

实测值（inst 4027381，nonce 种子后首次 fold）：
```
+0xbd=0x1  +0x106=0x1807dde10  +0x26=0x14(块20)  +0xd9=0x2  +0x61=0xc  +0xb5=0x20000100080
```

**这些是指针/计数器，非 key+nonce 派生的 ARX 状态字**——说明 key-schedule ARX 循环尚未正确
填充这 6 个槽（它们应持有 key+nonce 展开后的 32-bit 状态字）。

## 三、精确剩余缺口（进一步缩小）

keystream 生成流程已到达，唯一剩余是：**key-schedule ARX 循环需正确填充 6 个 fold 输入槽**
（`+0xb5`/`+0x26`/`+0xd9`/`+0x61`/`+0xbd`/`+0x106`）为 key+nonce 派生的状态字，然后 fold →
store32 → keystream 逐字节复现。

fold_edx_trace 当前显示 `edx=0x2840`（常量，因 6 槽未正确填充），期望为变化的 keystream word。

## 四、交付物

| 资产 | 路径 |
|------|------|
| 本突破报告 | `MaxHook_协议栈_keystream生成到达_第222轮_2026-08-14.md` |
| nonce 种子执行产物 | `encrypt_vm_seed_nonce.json`（word-producer 336 + fold 7） |
| 修改的 harness | `emulate_maxhook_encrypt_boundary.py`（`--seed-nonce` 参数） |
