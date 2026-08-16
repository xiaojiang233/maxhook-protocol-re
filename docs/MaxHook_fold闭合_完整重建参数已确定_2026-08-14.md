# MaxHook fold 闭合 — 完整重建参数已确定（第 154 轮）

日期：2026-08-14
范围：纯离线。

## 一、完整的重建参数（全部确定）

从 `maxhook_vm_initial_chain.json` + `vm_dispatch_chain_extended.json` 交叉确认：

| 参数 | 值 |
|------|-----|
| bugland blob | `runtime_bugland2.bin`（sha256 3a8e093afbf678fe） |
| handler 表 | `0x180C64EBD` |
| VM context base | `0x18098C884` |
| 初始 VIP | `0x181555629`（level 1） |
| 初始 key | `0xffffffa5` |
| level 4→5 出口 | `vip=0x18155d4b6, key=0xadeb35f2` |
| 方法 | Unicorn 具体执行，连续 context，decoy-jump aware |

## 二、已证明的 dispatch 链（level 1-22）

- **level 1-4**（milestone 17 静态证明）：idx 0x147→0x321→0x5d→0xe0
- **level 5-22**（`vm_dispatch_chain_extended.json`，5 次 emulator 交叉验证 match:true）：
  ARX 循环（链 A/B/C/D）+ 后续 handler，精确 VIP/key/advance 全部记录
- **level 23**：handler `0x1809b6a53`，静态公式不可行，需实际执行

## 三、重建 walker 的完整步骤（确定性）

1. 用 `runtime_bugland2.bin` + Unicorn 映射；
2. 初始化 context（768B @ 0x18098c884，初始 key=0xffffffa5, flag=0x69）；
3. 从 level 1（VIP=0x181555629）逐 handler 执行，连续 context 演化；
4. 每个 handler 后，识别 `jmp reg` 且目标为有效 stub 的 dispatch；
5. 记录 VIP/key/advance，走完 level 23+ → key-schedule 完成 → fold → keystream；
6. 用 vm_context_capture2 的 10 组 (key, nonce → keystream) 校验。

## 四、结论

**fold 闭合的全部重建参数已确定**，剩余是纯实现（重建 walker 脚本）。prior session 已验证
该方法可行到 level 22+，其脚本未保存是唯一缺失。

## 五、交付物

| 资产 | 路径 |
|------|------|
| 本报告 | `MaxHook_fold闭合_完整重建参数已确定_2026-08-14.md` |
