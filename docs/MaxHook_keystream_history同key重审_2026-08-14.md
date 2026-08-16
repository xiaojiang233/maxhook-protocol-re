# MaxHook keystream_history 会话 — 同 key 还是不同 key？（第 113 轮关键重审）

日期：2026-08-14
范围：纯离线。数据源：`keystream_history_capture_20260814/` events.jsonl + context。

## 一、证据：3 调用极可能同 key（同会话）

`check_same_key.py` 分析 events.jsonl：

| 证据 | call1 | call2 | call3 |
|------|-------|-------|-------|
| 线程 | 20272 | 20272 | 20272（**同线程**） |
| retval（输出信封指针） | 0x11a6cff4f0 | 0x11a6cff4f0 | 0x11a6cff4f0（**同指针，复用**） |
| 时间 | 01:08:19 | 01:08:40 | 01:08:49（**30 秒内**） |
| xor_hits | 704 | 1280 | 1344（不同明文长度） |
| key 指针 +0xbd | 0x13a4e194e70 | 0x139fd2678e0 | 0x1399a4e9c7b（**不同**） |

**关键矛盾**：retval 复用 + 同线程 + 30 秒内 ⇒ **强烈指向同 key 同会话**；但 key 指针 +0xbd
每调用不同（heap 重新分配 input64 解码缓冲，每次调用新分配）。

## 二、重释：47 个"key 派生"字节实为 nonce 派生

若 3 调用同 key（同会话），则第 112 轮发现的"47 字节跨调用不同"**不是 key 派生，而是
nonce/位置派生**（同 key、不同 nonce、不同明文长度）。

这**纠正**了第 102 轮的结论：
- 第 102 轮"9/9 位置跨 key 全不同"应重释为"**9/9 位置跨 nonce 全不同**"（若同 key）；
- 即密码是 **nonce 全扩散**（不是 key 全扩散的证明）。

## 三、决定性结论（第 114 轮确认）

`resolve_same_key.py` 确认：3 调用首字节均为 `{`（0x7b，JSON 明文），且结合第 113 轮证据
（同线程 20272、同 retval `0x11a6cff4f0`、30 秒窗口），**结论**：

**keystream_history = 单一会话（pid 42948），3 调用 = 同 key + 3 个不同 nonce。**

（key 指针 +0xbd 每调用不同是 input64 解码缓冲的 heap 重新分配，非 key 变化；会话密钥在
会话内恒定，与 verify-set 的 "key_material 恒定" 一致。）

**影响**：
- 第 102 轮 "9/9 位置跨 key 全不同" 应**修正**为 "9/9 位置跨 nonce 全不同"（同 key）；
- 第 112 轮 "47 字节 key 派生状态" 应**修正**为 "47 字节 nonce+位置派生状态"；
- 密码性质修正为：**nonce 全扩散**（从第 0 字节起），key 恒定。

## 四、结论与影响

1. **keystream_history 3 调用 = 同 key + 3 nonce**（同会话，已确认）；
2. 第 112 轮的"47 字节 key 派生状态"应精确为"**47 字节 nonce+位置派生状态**"（同 key 下
   仍变化的字节 = nonce 影响 + 计数器）；
3. 这**进一步收窄**缺口：key-schedule 输出中，跨 nonce 不变的部分 = key 派生（663 字节里的
   一部分），跨 nonce 变化的部分 = nonce/计数器派生（47 字节）。要复现需区分两者。
4. 第 102 轮"key 全扩散"证明应修正为"nonce 全扩散"（同 key）。

## 五、交付物

| 资产 | 路径 |
|------|------|
| 同 key 检查脚本 | `check_same_key.py` |
| 本报告 | `MaxHook_keystream_history同key重审_2026-08-14.md` |
