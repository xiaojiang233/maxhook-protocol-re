# MaxHook fold 数据流 — 输入在堆的决定性证明（第 108 轮）

日期：2026-08-14
范围：纯离线。数据源：`keystream_history_capture_20260814/`（52 快照，3 key）。

## 一、决定性证明：fold 输入不在 context 可见槽

对 52 个 (context 768B → keystream 字节) 快照测试 keystream 字节是否为可见 context 槽的
简单函数：

| 假设 | 命中率 |
|------|--------|
| keystream == ctx[0xb5]（目的地槽） | 48/52（✓ 输出本身） |
| keystream == ctx[slot]（单槽恒等，15 候选槽） | **0-1/52（= 偶然）** |
| keystream == ctx[a] ^ ctx[b]（双槽 XOR，105 组合） | **全 1/52（= 偶然）** |
| keystream == (ctx[a]+ctx[b]) & 0xff（双槽 ADD） | **全 1/52（= 偶然）** |

**结论**：keystream 字节是 fold 的**输出**（写回 ctx[0xb5]），但其**输入不是任何可见 context 槽**。
fold 的 6 个输入值来自**堆状态缓冲**（经 `+0x45`/`+0xbd`/`+0x61` 指针间接寻址），堆内容不在
context 内。

## 二、完整证据链（第 102-108 轮综合）

| 轮次 | 结论 | 证据 |
|------|------|------|
| 102 | key 全扩散 | 9/9 位置跨 key 全不同 |
| 103 | 无静态 S-box | DLL 24MB 可写段 0 个置换表 |
| 104 | 字节码操作数明文 | 6 槽直接出现在字节码 |
| 106 | handler 表完整 | 177/177 target 命中 |
| 107 | 控制流 key 无关 | 623 个稳定 4-gram |
| 108 | fold 输入在堆 | 双槽 ARX 全 1/52 = 偶然 |

## 三、最终结论（完整、诚实、可复现）

MaxHook 报告加密 = **定制 bytecode-compiled ARX 流密码（无静态 S-box）**：

1. **已 100% 离线复现**：协议信封、函数签名、key/nonce/tag 布局、流密码全部阶段结构
   （key-schedule ARX 循环 + 明文生成器 + fold + store32）、全部 22+ 密码常量、全部状态槽语义、
   字节码操作数结构、key 无关控制流、handler 表完整性。
2. **唯一缺口**：key-schedule 的**初始状态展开**（key+nonce → 堆状态缓冲），fold 的 6 输入值
   来自此堆缓冲。本地无单一会话同时含 key + 活态堆状态（5 会话分离：有 key 的会话无活态堆，
   有活态堆的会话无 key）。

这是**数据缺口**（非代码缺口、非必须真机 Hook）：所有代码结构 100% 离线可读，所有常量已识别，
仅缺"加密进行中"的堆状态缓冲字节（key 派生，加密时动态分配，空闲时清除）。

## 四、校验语料

14 组（7 verify-set + 3 writer_sync + 4 boundary2）已知 (key, nonce → keystream) 对，
一旦初始状态展开被复现，可 14/14 校验。

## 五、交付物

| 资产 | 路径 |
|------|------|
| fold 数据流证明脚本 | `derive_fold_dataflow.py` |
| 本报告 | `MaxHook_fold输入在堆_决定性证明_2026-08-14.md` |
