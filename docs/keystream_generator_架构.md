# MaxHook keystream 生成器架构（第 58 轮重大发现）

日期：2026-08-14
范围：纯离线。来源：`replay_keystream_generator.py`（既有脚本）+ `replay_generator_report.json`。

## 一、重大发现：生成器大部分是 PLAINTEXT

既有脚本 `replay_keystream_generator.py` 揭示了**关键的架构简化**：

keystream 生成器 `0x18041a8a0` 是**大部分明文**的（非全 VM 混淆），仅 4 个加密 dword 需恢复：

| 表 | 地址 | 性质 |
|----|------|------|
| 函数指针表 | `0x1807d7c70` | **明文**（16 项，含 store32 `0x18041a860` = 第 5 项） |
| 混淆常量表 | `0x1807d78c8` | **明文** |
| 索引表 | `0x1807d7cf0` | **加密**（4 dword = 唯一缺失） |

## 二、函数指针表（明文，16 项）

```text
[0]=0x1804167e0  [1]=0x18041a8a0  [2]=0x180417130  [3]=0x1804172e0
[4]=0x18041b180  [5]=0x18041a860(store32!)  [6]=0x18041b0a0  [7]=0x18041ae20
[8]=0x180416750  [9]=0x18041a840  [10]=0x1804160d0 [11]=0x18041b950
[12]=0x1800415d0 [13]=0x180089bc0  [14]=0x180416280 [15]=0x0
```

## 三、4 个加密索引（唯一缺失，可对 oracle 恢复）

dispatch 子调用读索引表固定偏移，加密值经已知双射 rol/ror 去混淆选函数表项：

```text
subcall 0/1: index_table[0x6]   = 0x92f10000 (on-disk encrypted)
subcall 2:   index_table[0x180] = 0x51d20196
subcall 3:   index_table[0x18]  = 0xcffffff
```

**恢复方法**（脚本 docstring）：`recover these 4 encrypted dwords offline (against the
writer_sync oracle)`——这是**有限、可搜索**的恢复（非全 VM 追踪）。

## 五、deobfuscation 分析（第 59 轮）

反汇编生成器 `0x18041a8a0`，确认 4 个 sub-call 的 dispatch 公式：

```text
cl = 0x405a9e0 - dword[shift_src]
eax = rol(bswap(rol(0x6000000, cl)), cl)
r8d = dword[index_table + eax*4]   ; 加密值
inc r8d                            ; +1
; rol/ror 序列（edx=0x5e9298bc-eax, eax2=eax+0x5e9298bc，两对 rol/ror）
fn_index = r8d
call [fn_table + fn_index*8]
```

实测（on-disk 加密值 → deobf）：

```text
subcall 0/1: index_table[0x6]   = 0xcffffff → fn 0xd（0x180089bc0，.data 地址，无效）
subcall 2:   index_table[0x180] = 0xed7c0feb → 0xed7c0fec（巨大，无效）
subcall 3:   index_table[0x18]  = 0x4 → fn 0x5 = store32（0x18041a860，✓ 正确！）
```

**结论**：on-disk 加密值**部分正确**（subcall 3 已正确解析到 store32），其余 3 个需**对
writer_sync oracle 恢复**（有限搜索：fn 表 16 项，正确值 = fn_index-1 经 rol/ror 反变换）。

## 七、deobfuscation 本质（第 63 轮）

精确计算 deobfuscation 反变换，发现其**本质是平凡的**：

```text
fn_index = enc + 1  （rol/ror 序列对特定 eax 净抵消为恒等或字节交换）
```

反变换验证（subcall 0, eax=0x6）：
```text
fn_index 13 → enc 0x0cffffff = on-disk 值 ✓（一致）
```

**正确加密值** = `fn_index - 1`（经 byte-swap，取决于 eax）。因此恢复 = 确定 3 个正确的
fn_index（subcall 0/1/2），每个 0..15（排除无效 13/15），加密值 = fn_index - 1。

**4 个 sub-call 的返回值组合**（第 61 轮 ARX）：
```text
subcall 0 → eax     subcall 1 → r14d    subcall 2 → r15d    subcall 3 → r12d
组合：and/or/shl/shr/xor + 混淆常量 → keystream 字
```

## 九、明文子函数识别（第 84 轮突破）

反汇编 fn 表明文函数，识别出 **ARX 密码原语**：

| entry | 地址 | 原语 |
|-------|------|------|
| 2 | `0x180417130` | **key XOR**（`xor r11b,[rcx+r9]` + `or al,r11b`） |
| 5 | `0x18041a860` | **store32**（写 4 字节 LE） |
| 6 | `0x18041b0a0` | **ARX round**（`and`/`sub`/`add`） |
| 9 | `0x18041a840` | **rotate**（`shl`/`shr`/`or` = ROL） |
| 8 | `0x180416750` | dispatch（读表跳转） |
| 12 | `0x1800415d0` | memset 类 helper |

**结论**：生成器是 **ChaCha/Salsa 类 ARX 密码**，明文子函数 = key XOR + ARX round + rotate + store32。
**4 个 sub-call 的正确 fn_index 极可能 = {2, 6, 9, 5}**（key XOR, ARX, rotate, store32），
subcall 3 = entry 5 已确认，subcall 0/1/2 = {2, 6, 9} 的排列（3! = 6 种）。

## 十、最终恢复（极小搜索）

确定 subcall 0/1/2 的 fn_index（各 ~13 有效项，13^3 ≈ 2197 组合），使生成器产 oracle keystream。
这是**纯离线、有限、可搜索**的任务。加密值 = fn_index - 1（byte-swap 取决于 eax）。


