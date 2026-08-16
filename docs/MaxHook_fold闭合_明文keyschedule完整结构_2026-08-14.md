# MaxHook fold 闭合 — 明文 key-schedule 完整结构（第 197 轮）

日期：2026-08-14
范围：纯离线。

## 一、完整明文 key-schedule（DLL .text 0x180322b80+）

`disasm_keyschedule_full.py` 反汇编出完整 key-schedule，是**表驱动 ARX 状态机**：

### 表
| 表 | 地址（lea 计算） | 用途 |
|----|-----------------|------|
| helper 函数表 | `r14 = rip+0x49b0a0` = `0x1807bdc70` | `call [r14+rax*8]` 间接调用 |
| 数据表 1 | `r15 = rip+0x335fb8` = `0x180335fb8`（≈0x180658b58? 需校正） | `mov edx,[r15+rax*4]` |
| 数据表 2 | `r12 = rip+0x4a0f20` = `0x1807bdcb0` | `mov eax,[r12+rcx*4]` |

### ARX 操作序列（完整）
```
表查找 [r15+rax*4] / [r12+rcx*4]
rol/ror edx/eax/edi, cl（变量旋转）
xor 常量：0x44e924 0xffbb16db 0x7fcb1992 0xa4dbc339 0x3427daf 0xacec895a 0x5a89ecac
bswap / neg / inc / dec / not / cdqe
call [r14+rax*8]（helper 间接调用，结果 cmp rax,rbx）
```

## 二、关键结论

1. key-schedule 是**明文表驱动 ARX**（helper 表 + 2 数据表 + 旋转 + XOR 常量），
   **非 VM 内**——在 DLL .text（0x180322b80+）；
2. 此前 96 轮只反汇编 .bugland（VM）遗漏了这段明文 key-schedule；
3. 这解释了"生成器是明文"（第 58-66 轮）——key-schedule 也是明文，只是被表查找 + 旋转混淆。

## 三、下一步（精确、可立即执行）

1. 校正表地址（r15/r12 的 rip 相对偏移需按指令地址精确计算）；
2. dump helper 表 16 项 + 数据表内容；
3. 追踪 key/nonce 输入 → ARX 混合 → keystream → store32；
4. 24 组校验。

## 四、第 198 轮：表地址校正 + 表内容 dump

`dump_key_tables.py` 校正表地址并 dump：

| 表 | 地址 | 内容 |
|----|------|------|
| helper 函数表 | `0x1807bdc70` | 16 函数指针（`0x180376ac0`/`0x18001c570`/`0x1803d4050`/`0x1800493c0`/`0x180043540`/`0x1803dfa60`/`0x18005ef60`/`0x180367b20`/`0x18031a530`/`0x18037d240`/`0x18026ed30`/`0x18039be30`/`0x180383850`/`0x180036550`/`0x1803c6580`/`0x180392e90`） |
| 数据表 1 | `0x180658b48` | 旋转计数/索引（`0x407daf5`/`0xffff57ef`/`0x648000` 等） |
| 数据表 2 | `0x1807c3ad0` | 常量/偏移（`0x1a96198e`/`0x42a2611f`/`0xcf2ed70b` 等） |

**完整 key-schedule 组件已全部 dump**：helper 表 16 函数 + 2 数据表。剩余 = 追踪精确数据流
（表项 → helper → key/nonce 字节 → keystream），是机械任务。

## 五、第 199 轮：16 helper 函数分类

`disasm_new_helpers.py` 反汇编 16 helper 函数（表 `0x1807bdc70`）：

| helper | 地址 | 性质 |
|--------|------|------|
| [0] | `0x180376ac0` | ARX（movabs 常量 + xor + ror） |
| [1] | `0x18001c570` | `ret`（空）+ 后接函数（stack cookie） |
| [2] | `0x1803d4050` | ARX（movabs + xor + 表） |
| [3] | `0x1800493c0` | ARX（ror） |
| [4] | `0x180043540` | **struct setter**（写 3 qword） |
| [5] | `0x1803dfa60` | ARX（bswap + rol） |
| [6] | `0x18005ef60` | `mov al,1; ret`（布尔 true） |
| [7] | `0x180367b20` | ARX（ror + neg） |
| [8] | `0x18031a530` | 大函数（xmm，多参数） |
| [9] | `0x18037d240` | **getter**（`mov rax,[rcx+8]; add -0x10; ret`） |
| [10] | `0x18026ed30` | 比较（movabs + cmp） |
| [11] | `0x18039be30` | ARX（rol + neg） |
| [12] | `0x180383850` | **byte writer**（`mov byte [rcx],dl`） |
| [13] | `0x180036550` | test + 分支 |
| [14] | `0x1803c6580` | 多参数 |
| [15] | `0x180392e90` | 多寄存器保存（大函数） |

**结论**：helper 表 = CRT/utility（getter/setter/byte writer/布尔）+ **ARX 密码操作**（movabs
常量 + xor + rol/ror + neg + bswap）。key-schedule = 表驱动 dispatch 到这些 helper。

## 六、交付物

| 资产 | 路径 |
|------|------|
| 完整反汇编 | `disasm_keyschedule_full.py` |
| 本报告 | `MaxHook_fold闭合_明文keyschedule完整结构_2026-08-14.md` |
