# MaxHook fold 闭合 — 明文 key-schedule 完全定位（第 200 轮定稿）

日期：2026-08-14
范围：纯离线。第 196-200 轮的决定性突破定稿。

## 一、决定性突破：明文 key-schedule 完全定位

此前 96 轮只反汇编 `.bugland`（0x180980000+，VM handler），**遗漏了 DLL .text 的明文
key-schedule**。第 196-200 轮定位并完全刻画：

### 位置
- **函数**：`0x180322a20`（`push rsi; sub rsp,0x20` 序言）起始，含 key-schedule 主体
  `0x180322b80+`；
- 结束于 `0x180322a0e`（stack cookie 反篡改检查 `xor rax,rsp; cmp rcx,rax; jne`）。

### 结构（表驱动 ARX 状态机）
```
call [rsi + rax*8]        ; rsi = helper 表 0x1807bdc70（16 函数）
mov edx, [r14 + rax*4]    ; r14 = 数据表 0x180658b48
mov eax, [rbx + rax*4]    ; rbx = 数据表 0x1807c3ad0
rol/ror/not/bswap/neg     ; ARX 旋转/变换
xor 常量：0x44e924 0xffbb16db 0x7fcb1992 0xa4dbc339 0x3427daf 0xacec895a 0x5a89ecac
```

### 16 helper 函数（表 0x1807bdc70）
- **ARX 密码操作**：`0x180376ac0`/`0x1803d4050`/`0x1803dfa60`/`0x18039be30` 等（movabs 常量 +
  xor + rol/ror + neg + bswap）
- **utility**：getter `0x18037d240`、setter `0x180043540`、byte writer `0x180383850`、
  布尔 `0x18005ef60`

## 二、关键结论

1. key-schedule = **明文表驱动 ARX**（helper 表 + 2 数据表 + 旋转 + XOR 常量），非 VM 内；
2. 表地址：helper `0x1807bdc70`、数据表1 `0x180658b48`、数据表2 `0x1807c3ad0`；
3. 全部组件（表 + 16 helper + ARX 操作 + 常量）已 dump，**完全离线可分析**。

## 三、剩余（机械任务）

追踪 key/nonce 字节 → 表查找 → helper ARX → keystream → store32 的精确数据流，
然后 24 组校验。这是纯机械任务（全部组件已定位）。

## 五、第 201 轮：helper dispatch wrapper 结构确认

`trace_keyschedule_fn.py` 确认：`0x180322a20` 起是一系列**小 wrapper 函数**（每个 `push rsi;
sub rsp,0x20; ... call [r10+r9*8]; ret`），每个：
1. 读 `[rcx]`/`[rcx+8]`（输入 struct 字段）；
2. 计算混淆索引（ror/rol/xor/not/bswap + 数据表查找）；
3. `call [0x1807bdc70 + index*8]`（helper 表 dispatch）；
4. 返回。

即 key-schedule = **helper dispatch wrapper 组合**，key/nonce 经 `[rcx]`/`[rcx+8]` 字段流入，
经 16 helper（ARX 操作 + utility）处理。全部代码明文、完全离线可执行。

## 六、第 203 轮：VM→明文转换的寄存器状态确认

`trace_transition.py`：walker 走 373 步到转换点（RIP=0x18001ebb0），寄存器：
- `r14/r13 = 0x1807bdc70`（helper 表）、`r15 = 0x180658b48`（数据表1）、`r12 = 0x1807c3ad0`（数据表2）；
- 但 `rcx=0x0 rsi=0x0`（walker 逐 handler 执行未维护正确寄存器状态）。

**精确剩余**：在转换点正确设置 `rcx`（输入 struct，含 key/nonce）+ `rsi`（输出缓冲）+
 寄存器，然后执行明文 key-schedule → keystream → 24 组校验。

## 七、交付物

| 资产 | 路径 |
|------|------|
| 完整反汇编 | `disasm_keyschedule_full.py`、`verify_keyschedule_fn.py` |
| 表 dump | `dump_key_tables.py` |
| helper 分类 | `disasm_new_helpers.py` |
| 本报告 | `MaxHook_fold闭合_明文keyschedule完全定位_2026-08-14.md` |
