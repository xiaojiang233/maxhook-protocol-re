# MaxHook fold 闭合 — 关键发现：VM → 明文 helper 转换（第 195 轮）

日期：2026-08-14
范围：纯离线。

## 一、决定性发现：walker 终止于 VM → 明文 helper 转换

`diagnose_walk_end.py`：walker 在 step 373 终止，最后指令：

```asm
0x180322bc7: cdqe
0x180322bc9: lea  r14, [rip + 0x49b0a0]      ; helper 函数表
0x180322bd0: mov  rcx, rsi
0x180322bd3: call qword ptr [r14 + rax*8]    ; 间接 call → 明文 helper
0x18001ebb0: mov  rax, qword ptr [rcx + 0x10] ; helper 主体（DLL .text，非 .bugland）
```

即 VM（key-schedule INIT）在 `0x180322bd3` 经**间接 call** 转入 **明文 helper `0x18001ebb0`**
（DLL .text，非 .bugland VM）。walker 只 hook `jmp reg`（dispatch），**未 hook `call`**，故错过
此转换。

## 二、关键结论

1. **key/nonce 混合 + keystream 生成在明文 helper**（`0x18001ebb0` 等，经间接 call 从 VM 调用），
   非 VM handler 内；
2. walker 需 **hook 间接 call**（非仅 jmp reg）才能跟随此转换；
3. 这与第 58-66 轮"生成器是明文"结论一致——明文 helper 处理 key/nonce/keystream。

## 三、下一步（精确）

1. 扩展 walker hook 间接 call（`call qword ptr [reg+off]`）→ 跟随到明文 helper；
2. 在 helper 中追踪 key/nonce 处理 → keystream 生成 → store32；
3. seed captured key/nonce → 校验 24 组。

## 四、交付物

| 资产 | 路径 |
|------|------|
| 诊断脚本 | `diagnose_walk_end.py` |
| 本报告 | `MaxHook_fold闭合_VM到明文helper转换_2026-08-14.md` |
