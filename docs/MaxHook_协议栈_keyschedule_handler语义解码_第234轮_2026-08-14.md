# MaxHook 协议栈 — key-schedule handler 语义解码（第 234 轮）

日期：2026-08-14
范围：纯离线（静态反汇编）

## 一、chain A 核心语义（slot-swap + ARX）

chain A（`0x18099089e → 0x180990a93 → 0x180990b21`，keystream 生成中执行 1300 次）的精确
数据流已解码：

### body 1 `0x18099089e`：**上下文槽交换**
```
r13 = [ctx+0x6d]           ; VIP
r12 = ctx + word[VIP+4]    ; 槽 A（由字节码字 word[VIP+4] 索引）
rbx = ctx + word[VIP+2]    ; 槽 B（由字节码字 word[VIP+2] 索引）
push [r12]; push [rbx]; pop [r12]; pop [rbx]   ; 交换 slot[A] 和 slot[B]
```

### body 2 `0x180990a93`：**状态累加 + rolling key 混合**
```
sub word[ctx+0xe5], r13w   ; 状态累加字 -= word（ARX）
or  [ctx+0xa], 0x33a09506  ; rolling key |= 常量
sub di, 0xec45; ...        ; 指针去混淆 + 状态回写
```

### body 3 `0x180990b21`：**字节码字读取 + 混合**
```
r13 = ctx + word[VIP+0]    ; 读 word[VIP+0] 索引的槽
or r14, r13                ; 混合
or r13, 0x6f7595a8          ; 指针混淆常量
r13 = ctx + word[VIP+6]    ; 读 word[VIP+6] 索引的槽
```

## 二、结论：key-schedule = 字节码驱动的槽交换 + ARX

key-schedule 的完整语义已解码：
1. **读字节码字**（`word[VIP+K]`，K = 0/2/4/6/0xa/0x10 等）；
2. **字节码字作上下文槽索引**（`ctx + word`）；
3. **交换/混合槽**（swap + sub/or/xor + 常量）；
4. **推进 VIP**（`add [r10], 8` 等）。

常量 `0x33a09506`/`0x6f7595a8` 是 key-schedule 轮 + 指针混淆的混合。全部 22 个 ARX 常量已定位
（第 222 轮），handler 语义已解码（本轮到 chain A）。

### 二·一 第 235 轮：chain C 完整语义（状态累加 + rolling key 减 + 混合）

chain C（`0x180a02a99 → 0x180a02bcd → 0x180a02c51 → 0x180a02c94`）的精确 ARX：

| body | 操作 | 语义 |
|------|------|------|
| `0x180a02bcd` | `add word[ctx+0xe5], r14w` | 状态累加字 += word（ARX） |
| `0x180a02bcd` | `sub dword[ctx+0xa], 0x4dbfde8f` | rolling key -= 常量 |
| `0x180a02c94` | `add dword[ctx+0x5d], 0x6abd113b` | 状态字 += 常量 |
| `0x180a02c94` | `xor edi, [ctx+0xa]` | 混合 |

**完整 ARX 递推**（chain A + C 组合）：
```
state[0xe5]  = state[0xe5] - word   (chain A) / + word (chain C)
rolling_key[0xa] = rolling_key[0xa] | 0x33a09506 (chain A) / - 0x4dbfde8f (chain C)
state[0x5d]  = state[0x5d] + 0x6abd113b  (chain C)
```

即 key-schedule 是**数据驱动的槽交换 + 累加/减 + 常量混合**的 ARX，字节码字决定操作哪些槽。

## 三、剩余缺口（精确）

124-handler keystream 循环的 handler 语义已解码（chain A/D/B/C 全部），剩余是**执行完整序列
的数据流**（各 slot 的实际值），需 VM 数据栈（8704B，本地 dump 未覆盖）或完整符号执行。

## 四、交付物

本报告 `MaxHook_协议栈_keyschedule_handler语义解码_第234轮_2026-08-14.md`。
