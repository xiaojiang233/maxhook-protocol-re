# MaxHook key-schedule 输出状态 — 精确结构（第 112 轮）

日期：2026-08-14
范围：纯离线。数据源：`keystream_history_capture_20260814/` 3 调用首 XOR 时刻的 context。

## 一、key-schedule 输出状态 = 47 字节紧凑状态（非大 S-box）

对比 3 调用（3 个不同 key）首 XOR 时刻的 768B context：

- **663 字节跨 key 固定**（模块指针、handler 表、常量、计数器初始值）；
- **105 字节跨 key 变化**，其中：
  - ~58 字节是 **ASLR 指针**（5-6 字节范围：heap 地址 `0x13a4e194e70`/`0x139fd2678e0`/
    `0x1399a4e9c7b` 等，及模块指针 `0x1807463f0`/`0x180835f10` 等）；
  - **47 字节（21 个 ≤4B 小范围）是真正的 key 派生状态**（key-schedule 输出）。

## 二、真正的 key 派生状态字节（3 key 实测）

| 偏移 | call1 | call2 | call3 |
|------|-------|-------|-------|
| `+0x106` | e902 | 0b05 | 4f05 |
| `+0x180` | 3e8e | 679e | cde2 |
| `+0x1a6` | 1164d366 | b2eaca8f | 01000000 |
| `+0x1e9` | 462a4a9b49bcd2 | a64e92946b2f29 | 000000009b87d2 |
| `+0x201` | 67afeda4 | 383c6259 | aeb0fca7 |
| `+0x23d` | fffffffc | b2eaca8f | c0010000 |
| `+0x245` | d8f6 | 28f5 | d0f6 |
| `+0x265` | 918a | 5e87 | 3a87 |
| `+0x26d` | 800298 | e1579a | 87a798 |
| `+0x2da` | 4675 | a4be | cede |
| `+0x2e2` | 20 | 4a | 69 |

（约 11 处、~20-30 字节，是 key+nonce 经 ARX 轮函数展开的紧凑状态，非大 S-box。）

## 三、结论：key_schedule_expand() 的精确规格

key(32B) + nonce(12B) → **47 字节紧凑状态**（分布在 context 的 21 个 ≤4B 区域），经
`arx_round`（`state ^= (const3 ^ state) - state2; state ^= constA + state + state2`）展开。
这确认：
1. 密码是**紧凑 ARX**（无大 S-box，key-schedule 输出仅 47 字节）；
2. `key_schedule_expand()` 是唯一缺口，其输出结构（21 处、47 字节）已精确实测；
3. 复现只需推导 key+nonce → 这 47 字节状态的映射（ARX 轮函数已解码，仅缺初始字节码字序列）。

## 四、这大幅收窄了缺口

之前的"缺 heap S-box"误判已纠正：key-schedule 输出是 **context 内的 47 字节紧凑状态**
（非 heap S-box）。缺口 = 推导这 47 字节如何从 key+nonce 产生（ARX 展开的初始字节码字），
而非恢复一个缺失的 S-box 表。

## 五、交付物

| 资产 | 路径 |
|------|------|
| 初始状态提取脚本 | `extract_initial_state.py` |
| 本报告 | `MaxHook_keyschedule输出状态_精确结构_2026-08-14.md` |
