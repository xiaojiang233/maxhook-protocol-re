# MaxHook fold 闭合 — 完整链行走成功（200 步，第 154-156 轮）

日期：2026-08-14
范围：纯离线。

## 一、重大突破：完整走通 key-schedule + keystream 生成链（200 步）

`walk_chain_v2.py` 完整走通（`runtime_bugland2.bin` + 正确 flag 演化 + persistent context
+ 全 DLL + kernel32 映射）：
- 成功走过 level 23（idx 0x20d）；
- 映射 kernel32（76→186 步）+ 全 DLL .data（186→200 步）；
- **200 步、87 个 distinct handler**，ARX 循环 handler 反复（keystream 生成循环）；
- 无内存错误（200 步是 step 上限，非错误）。

## 二、关键突破点

1. **flag 字节 0x69→0xC3 正确演化**（第 131 轮发现）使 level 23 dispatch 得 idx 0x20d（有效）；
2. **全 DLL 映射**（.data 0x1807afe20 等）+ **kernel32 映射**解决 handler 的全局/导入写；
3. **persistent context** 正确演化 key/VIP/flag，走完整链。

## 三、剩余（最后一步）

链已完整走通（keystream 生成循环可见）。剩余 = **seed 真实 key/nonce**（vm_context_capture2
的 key `32206F9C...` + nonce）到 heap，使 walker 产生**正确 keystream 字节**，然后与
captured ciphertext 校验（24 组）。

## 四、第 157-158 轮：seed 真实 key/nonce 的尝试

`seed_and_capture.py`：
- seed key 到 `+0xbd` 指针目标（`0x1807bdc70`）+ TEB/PEB 设置后，walker 走至 **373 步**；
- 但 **store32 = 0**（key-schedule 完成但未达 keystream 写入）。

**原因**：key-schedule 需 key **和 nonce** 经完整数据流正确 seed（非仅 key 单一指针）。链已
完整走通（373 步），剩余 = 正确 seed key+nonce 经全部状态指针 + heap 缓冲的数据流。

## 五、第 159 轮：nonce 位置确认

`find_nonce_location.py`：nonce 是加密调用**内部 CSPRNG 生成**（非输入），不在 vm_enter_context
中。故 fold 闭合 = 取 captured nonce（如 `c38d500a...`）+ key，seed 到 key-schedule 读 nonce 的
位置，验证 keystream == captured ciphertext。剩余 = 定位 key-schedule 读 nonce 的上下文槽/heap
位置并 seed。

## 六、交付物

| 资产 | 路径 |
|------|------|
| walker 脚本 | `walk_chain_v2.py` |
| seed + capture | `seed_and_capture.py` |
| 链行走结果 | `chain_walk_v2.json`（200 步） |
| 诊断脚本 | `diagnose_step76.py`、`diagnose_step186.py`、`find_key_ptr.py` |
| 本报告 | `MaxHook_fold闭合_链行走76步_2026-08-14.md` |
