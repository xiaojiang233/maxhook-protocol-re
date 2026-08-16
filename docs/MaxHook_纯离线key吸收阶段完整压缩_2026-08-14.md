# MaxHook：纯离线 key absorption 阶段完整压缩

日期：2026-08-14

## 边界

本报告只覆盖 decoded 32-byte key 进入后续 VM state 的 absorption 阶段；尚未生成独立 keystream/tag。

## 1. 实际输入块是 64 bytes

VM 逐字节处理的块不是只有 key，而是：

```text
block = key[32] || zero[32]
```

离线读取确认：

```text
bbbb...bbbb (32 bytes)
0000...0000 (32 bytes)
```

总共执行：

```text
64 rounds * 26 VM jumps = 1664 VM jumps
```

## 2. 整个阶段的 key 依赖可化简为两个 XOR 数组

在第 64 轮结束后的边界，比较基线 key `bb*32` 与随机 key `00 01 ... 1f`：

```text
context bytes:    完全相同
registers:        完全相同
VIP/key/target:   完全相同
RSP:              完全相同
other stack:      完全相同
```

唯一不同的是两个 64-byte stack arrays：

```python
block = key + bytes(32)
stack[0x50:0x90] = bytes(x ^ 0x5c for x in block)
stack[0x90:0xd0] = bytes(x ^ 0x36 for x in block)
```

对随机 key `00..1f` 的完整结果：

```text
stack+0x50:
5c5d5e5f58595a5b5455565750515253
4c4d4e4f48494a4b4445464740414243
+ 32 bytes 0x5c

stack+0x90:
36373435323330313e3f3c3d3a3b3839
26272425222320212e2f2c2d2a2b2829
+ 32 bytes 0x36
```

## 3. 独立实现

`offline_key_absorption_reference.py` 已实现：

```python
def absorb_key(key, baseline_state):
    block = key + bytes(32)
    for i, value in enumerate(block):
        stack[0x50+i] = value ^ 0x5c
        stack[0x90+i] = value ^ 0x36
```

它直接替换 1664 个 VM jumps。

随机 key `000102...1f` 与完整 Unicorn VM replay 的边界状态比较：

```text
context match:     pass
stack match:       pass
registers match:   pass
control match:     pass
完整状态 match:   pass
```

## 4. key absorption 轮内部结构

每个输入 byte：

```text
ctx+0x45 指向当前 byte
ctx+0x0e = zero_extend(byte)
26 个固定 VM jumps
```

每轮持久结果：

```text
array_A[index] = byte ^ 0x5c
array_B[index] = byte ^ 0x36
```

前 32 轮处理 key，后 32 轮处理 zero padding。

## 5. nonce 离线状态

动态 nonce seed 已修正为使用实际 12-byte allocation：

```text
nonce buffer = 0x20000100160
seed instruction = 3,988,473
```

分别写入 zero nonce 和 byte0=1 nonce 后，buffer 内容正确。

但当前 replay 在：

```text
instruction = 4,163,009
RIP         = 0x7ffe1feec4
invalid read= 0x361a8e81
```

崩溃前没有任何 nonce-buffer read。因此 nonce 尚未进入密码状态；当前需要修复的是 seed 后的离线 VM stack/control 路径，而不是继续猜 nonce 算法。

## 6. 资产

```text
offline_key_absorption_reference.py
offline_key_absorbed_baseline_state.json
verify_offline_key_absorption.py
offline_key_absorption_report.json
diff_key_sequence001f_2350k.json
diff_key_baseline_2350k_block.json
```
