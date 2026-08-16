# MaxHook key-schedule 活态执行序列 — 稳定结构确认（第 107 轮）

日期：2026-08-14
范围：纯离线。数据源：`keystream_history_capture_20260814/` 3 个调用的 1024 项 call-history 环缓冲（pid 42948，活态）。

## 一、关键发现：623 个跨 key 稳定 4-gram

对 3 个调用（3 个不同 key）的 history 环缓冲做 4-gram 分析，发现 **623 个 4-gram 在 3 个调用间
完全一致**（key 无关的稳定结构），确认 key-schedule 执行序列是**确定性、key 无关**的（仅数据
依赖 key，控制流不依赖 key）。

## 二、稳定执行序列（第 99 轮 ARX 循环的活态确认）

**4 主链**（频率在 3 调用间完全一致）：

| 链 | 频率 | 序列 |
|----|------|------|
| A | 21/21/21 | `0x1809815b2 → 0x18099089e → 0x180990a93 → 0x180990b21` |
| B | 16/16/16 | `0x18098257f → 0x1809bfebb → 0x1809bff47 → 0x1809c012a` |
| C | 17/17/17 | `0x1809a3b86 → 0x180a02a99 → 0x180a02bcd → 0x180a02c51` |
| D | 11/11/11 | `0x18098202a → 0x180b41fb8 → 0x180b42104 → 0x180b42287` |

**VM dispatch 循环**（19/19/19 次，= 每调用 dispatch 次数）：

```text
0x1809803d9 → 0x180ac2b8c → 0x180ac2bbc → 0x180ac2cd9   (handler body → dispatch tail)
→ 0x1809a57e1 (dispatcher) → 0x180c02701 → 0x180c02983    (→ 下一个 handler)
```

## 三、结论

1. 第 99 轮提取的 ARX 循环（4 主链 A/B/C/D）在**活态 history** 中得到**完全独立确认**，
   频率（21/16/17/11）与静态反汇编 + idle emulation 三源一致。
2. key-schedule 执行序列是**确定性、key 无关**的（623 个稳定 4-gram）——仅状态数据依赖 key，
   控制流固定。这大幅简化复现：只需 key+nonce 初始状态 + 固定执行序列，无需分支追踪。
3. dispatch 循环结构（handler body → dispatch tail → dispatcher → next）已明确，
   与 handler trace（idle）的 177 target 交叉验证。

## 四、剩余缺口（精确、收窄）

key-schedule 执行序列（控制流）已 100% 恢复且确认 key 无关。唯一缺口仍是**初始状态**
（key+nonce → 各状态槽初始值），以及每条链内 handler body 的**逐字数据流**（哪几个状态槽值
经哪些算术 → keystream 字节）。后者需要 handler body 的精确操作数（已部分提取，第 99 轮），
前者需要 key-schedule 初始展开（数据缺口）。

## 五、交付物

| 资产 | 路径 |
|------|------|
| 活态序列分析脚本 | `analyze_live_history.py` |
| 本报告 | `MaxHook_keyschedule活态执行序列_2026-08-14.md` |
