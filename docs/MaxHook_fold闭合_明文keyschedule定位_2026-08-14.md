# MaxHook fold 闭合 — 明文 key-schedule 代码定位（第 196 轮重大突破）

日期：2026-08-14
范围：纯离线。

## 一、重大突破：明文 key-schedule 代码在 DLL .text（0x180322bc7）

`disasm_helper.py` 反汇编发现：

1. **helper 函数表 `0x1807bdc70`**（= 之前误认的"key 指针"）实为**函数指针表**，entry 如
   `0x18001ebb0`（`mov rax,[rcx+0x10]; ret` = 简单 getter）；
2. **调用点 `0x180322bc7`**（DLL .text，非 .bugland）是**明文 key-schedule**，含：
   - `call [r14+rax*8]`（间接调用 helper）
   - `sub ecx, [r15+rax*4]` / `mov edx, [r12+rax*4]`（表查找）
   - `xor ecx, 0x44e924` / `xor edx, 0x7fcb1992` / `xor ecx, 0xffbb16db`（XOR 常量）
   - `ror/rol edx, cl`（旋转）

## 二、关键结论

1. **key/nonce 混合在明文代码 `0x180322bc7`**（DLL .text，非 VM handler），此前只反汇编
   `.bugland`（0x180980000+）故遗漏；
2. `0x1807bdc70` 是 **helper 函数表**（非 key 缓冲），纠正第 157/161 轮误判；
3. key-schedule 的明文部分含表查找 + XOR 常量 + 旋转（ARX 结构，与密码定性一致）。

## 三、下一步（精确）

1. 完整反汇编 `0x180322bc7` 周围的明文 key-schedule 代码（DLL .text）；
2. 识别 helper 表 16 项（`0x1807bdc70`）+ 数据表（`[r15]/[r12]` 指向）；
3. 追踪 key/nonce 数据流 → keystream → store32 → 校验 24 组。

## 四、交付物

| 资产 | 路径 |
|------|------|
| 反汇编脚本 | `disasm_helper.py` |
| 本报告 | `MaxHook_fold闭合_明文keyschedule定位_2026-08-14.md` |
