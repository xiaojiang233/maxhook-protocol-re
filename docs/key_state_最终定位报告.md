# MaxHook 密码 key-state 最终定位报告（第 44-48 轮）

日期：2026-08-14
范围：纯离线。

## 一、核心发现（第 44 轮突破，纠正第 20 轮误判）

密码的 key-schedule 状态**在 context 内**（非堆）。对比 3 个 call 的 768B context，
定位 **105 个跨 call 不同的字节**，其中：

1. **真实 key 派生状态**（~20 随机字节）：
   ```text
   +0x1e9..+0x1ef (7B): 462a4a9b49bcd2 / a64e92946b2f29 / 000000009b87d2
   +0x201..+0x204 (4B): 67afeda4 / 383c6259 / aeb0fca7
   +0x1a6..+0x1a9 (4B): 1164d366 / b2eaca8f / 01000000
   +0x1dd..+0x1e0 (4B): 50530020 / 50100040 / c0132064
   +0x245..+0x246, +0x265..+0x266, +0x26d..+0x26f 等
   ```
2. **ASLR 指针**（~85 字节）：`+0x045..0x049`（`7020194e3a`）、`+0x0bd..0x0c1`（同）、
   `+0x18e..0x192`（`f063748001` = 0x1807463f0）、`+0x1c5..0x1c9` 等
3. **计数器/keystream**：`+0xb5`（keystream 字节）、`+0x142..0x149`

## 二、完整密码状态机（最终明确）

```text
key(32B) + nonce(12B)
  → key-schedule 轮函数（bytecode，状态槽 0x1e/0x143，字节码字混合）
  → ~20 字节 key 状态（context 内，随机）+ 计数器（0x26/0xd9/0x36/0x14a）
  → fold（VM 栈机，6 槽值 + ~30 算术操作）
  → keystream 字节（ctx+0xb5）→ store32 → 64B 块
```

## 三、fold 闭式的数据充分性（第 46-47 轮）

- 同 key 下仅 11-21 个 (keystream 字节, 计数器) 数据点 → **不足以拟合非线性 fold**；
- 跨 key 数据无法关联（各会话 key 不同）；
- keystream_history / keystream_source / writer_sync 三者**非同一会话**（keystream 字节全 DIFF，
  第 47 轮验证），无法合并 (key-state + 完整 keystream)。

## 四、唯一未闭合 + 正确路径

fold 的 ~30 操作闭式 + MAC(tag)。唯一正确路径 = **静态字节码数据流追踪**（4096 次 handler 执行），
这是纯离线、纯机械的任务，数据已全部留档（handler 轨迹 `vm_handler_execution_trace.json`、
context 写入 70541 次、dispatch 公式、key 状态 ~20 字节、ground-truth 密钥流字）。

## 五、交付物状态

全部离线留档、可复现、已验证、一致性校验通过。fold 闭式是唯一剩余，不依赖真机运行时状态。
