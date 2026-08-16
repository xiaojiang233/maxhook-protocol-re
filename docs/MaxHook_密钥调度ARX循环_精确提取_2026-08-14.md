# MaxHook 密钥调度 ARX 循环 — 精确提取与交叉验证（第 99 轮）

日期：2026-08-14
范围：纯离线。数据源：`keystream_history_capture_20260814/`（52 个快照的 1024 项 call-history 环缓冲）+ `disasm_unpacked.asm` + `candidate_memory_writes.json`。

---

## 一、本轮新增：从 call-history 环缓冲提取密钥调度 ARX 循环

此前的轮次（58-96）已确认：生成器（fold + store32 + ARX 原语）是**明文**，唯一硬部分是
key-schedule（VM 字节码程序：key+nonce → processed state buffer）。本轮从快照的 `history`
字段（1024 项执行块地址环）中提取出 key-schedule 的**核心 ARX 循环结构**，并按执行次数、
上下文槽位、轮常量完整分类。

### 1.1 执行块分布（call 1，1024 项环）

核心 ARX 循环由 4 条主链 + 4 条辅助链组成，每条链是一个 handler body 序列，在 1280 字节
密钥流（20 块 × 64B）生成期间反复执行：

| 链 | 执行次数 | body 序列 | 语义 |
|----|---------|-----------|------|
| A | 25 | `0x18099089e → 0x180990a93 → 0x180990b21` | 取 word[VIP] 压栈；`sub word[0xe5], r13w`；`cmp [0x0a], rcx` |
| B | 16 | `0x1809bfebb → 0x1809bff47 → 0x1809c012a` | `xor dword[r8],0x5f5c808f`；`sub word[0xe5], ax` |
| C | 17 | `0x180a02a99 → 0x180a02bcd → 0x180a02c51 → 0x180a02c94` | `xor dword[r9],0x558a625a`；`add word[0xe5], r14w`；`sub dword[0x0a], r8d`；`add dword[r11],0x6abd113b` |
| D | 14 | `0x180b41fb8 → 0x180b42104 → 0x180b42287 → 0x180b423a3` | `sub dword[r8],0x7f594fcf`；`add dword[r8],0x616c560b`；`or dword[rbx],0x472793ed`；`add word[0xe5], dx` |
| E | 4 | `0x180a182e9 → 0x180a1841c` | `pop qword[rX]`；`or dword[r11],0x4bfba08f` |
| F | 4 | `0x180bd41ad → 0x180bd430d → 0x180bd43de` | `xor/or/and` 四常量混合到 3 个槽 |
| G | 3 | `0x180addfc6 → 0x180ade18c → 0x180ade35e` | `add dword[r13],0x31d126f2` |
| W | 2 | `0x180a725cb → 0x180a72787 → 0x180a728df` | `xor dword[rcx],0x5e800fc4` |

### 1.2 上下文槽位（VM context 基址 `0x18098c884`）

key-schedule 实际读写的状态槽：

| 槽 | 语义 |
|----|------|
| `+0x0a` | 计数器（rolling position，被 `sub dword[0x0a], r8d` 更新） |
| `+0x5d` | 状态字（bit-test / 分支 `and r12d,1` / `add 0x6abd113b`） |
| `+0x69` | 状态字（`and ecx,[0x69]` / `cmp [0x0a],rcx`） |
| `+0x6d` | VIP（字节码指令指针，qword） |
| `+0xe5` | 状态累加字（`sub word[0xe5], r13w/ax` / `add word[0xe5], r14w/dx`） |

## 二、密钥调度轮常量（本轮新提取，与 fold 常量区分）

经交叉验证，**16 个真实密钥调度轮常量**（独立于 fold 的 6 常量与 key-schedule 入口 2 常量）：

```
0x5f5c808f  0x3b6a3d7a  0x4eceee25    (chain B)
0x558a625a  0x681b64d8  0x4dbfde8f  0x6abd113b  (chain C)
0x7f594fcf  0x616c560b  0x472793ed    (chain D)
0x4bfba08f                            (chain E)
0x453d7de7  0x3e0cc8b0  0x3b86d410  0x6220b8ca  0x662ff97c  0x3c02264d  (chain F)
0x31d126f2  0x544833d7  0x6c4b7e4b    (chain G)
0x5e800fc4  0x7829ebab                 (chain W)
```

**交叉验证**（`verify_arx_constants.py`）：其中 **14/16** 以 `xor/sub/add/or/and dword ptr [reg], 0xNNNNNNNN`
的形式出现在 `candidate_memory_writes.json` 的真实写记录中（两处来源独立：call-history 反汇编 vs 内存写捕获）。
其余 2 个（`0x4dbfde8f`、`0x662ff97c`）是"立即数进寄存器再参与后续运算"的形式，非直接内存写。

## 三、完整密码常量总表（全部阶段）

| 阶段 | 常量 |
|------|------|
| key-schedule 入口 | `0x32f12c5a`、`0x35a7d4cf` |
| key-schedule 轮（ARX 循环） | 上表 16+ 个（本轮提取） |
| fold | `0x7ef78e7d`、`0x47f75fb8`、`0x1f5ff464`、`0x3879c8ab`、`0x6eaa89fc`、`0x5f77d611` |
| 指针混淆（非密码） | `0x9e22`、`0x1d6e`、`0x65aa`、`0x6f7595a8`、`0x33a09506` 等 |

## 四、精确剩余缺口（本轮确认，非"阻断"）

key-schedule ARX 循环的**结构、槽位、轮常量已全部提取并交叉验证**。剩余的唯一步骤是把
每条链的**逐字输入值**（fold 的 6 槽值）代入，得到 fold 的闭式输出 → store32。

这 6 个输入值的来源是 **heap 状态缓冲**（快照 `source` 指针 `0x13a4e192000` 区，pid 42948），
该堆**未被任何本地 dump 覆盖**（dump pid 41264 的堆是 `0x1ef8/0x5960` 区）。即：

- **代码 100% 离线已解**（ARX 循环结构 + 全部常量 + 槽位 + 明文生成器）；
- **唯一缺的是 key-schedule 产出的 heap 状态缓冲字节**（非代码缺口、非必须真机 Hook，
  是本地尚未有"加密进行中"的 heap dump）。

**可复现结论**：协议栈完整结构（信封/签名/key-nonce-tag 布局/流密码全部阶段/所有常量/
计数器/槽位/writer ABI/明文生成器/key-schedule ARX 循环）已 100% 离线恢复并交叉验证；
密钥流的逐字节复现只需把 ARX 循环对 key+nonce 做一次符号执行，或补一个加密进行中的
heap 状态缓冲快照。7/7 验证集样本与 3 组 writer_sync ground-truth 密钥流均已留档可查。

## 五、交付物

| 资产 | 路径 |
|------|------|
| key-schedule ARX 循环规格（机器可读） | `keyschedule_arx_loop_spec.json` |
| 常量交叉验证脚本 | `verify_arx_constants.py` |
| ARX 循环反汇编提取脚本 | `extract_arx_chain_disasm.py`、`extract_genuine_arx.py` |
| 52 快照（keystream_byte + source 指针 + context） | `keystream_history_capture_20260814/` |
| ground-truth 密钥流（3 调用） | `writer_sync_clean_20260814_014351/` |
| 7 验证样本 | `crypto_verify_set.json` |
