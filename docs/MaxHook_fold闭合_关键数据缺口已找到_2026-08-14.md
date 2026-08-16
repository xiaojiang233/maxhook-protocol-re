# MaxHook fold 闭合 — 关键数据缺口已找到（第 140 轮突破）

日期：2026-08-14
范围：纯离线。

## 一、重大突破：vm_context_capture2 = 同步的 key + 活态 VM context + 完整输出

第 139 轮结论"数据缺口"被**推翻**。发现 `vm_context_capture2/`（pid 44328，10 调用）：

- **10 调用同 key** `32206F9C196327AD276821AC8EBC7F80FE82D84CF72A4F7C1BAF508C97D3AEA8`；
- **10 个不同 nonce**，完整 ciphertext + tag + plaintext；
- **`vm_enter_context.bin`（512B）= 加密入口时刻的活态 VM context**（与 key 同步！）。

## 二、活态 VM context 实测（加密入口时刻）

| 槽 | 值（多数调用） | 备注 |
|----|---------------|------|
| `+0x85` handler 表 | `0x180c64ebd` | ✓ 正确 |
| `+0x6d` VIP | `0x181458154` | 有效 bugland 地址 |
| `+0xa` key | `0xffffa301` | **非**空闲态 dump 的 `0xffffffa5`！ |
| `+0x162` flag | `0x41` | **非** 0x69/0xC3/0xf9！ |

（调用 5/9 的 flag/key/vip 略不同，反映 VM context 跨调用的持久演化。）

## 三、这推翻了此前的结论

1. **第 139 轮"数据缺口"** 错误——本地**有**同步的 key + 活态 VM context（`vm_context_capture2`）；
2. 之前假设 flag 字节是 0x69/0xC3，**实际是 0x41**（加密入口时刻）；
3. 之前假设 key 槽是 0xffffffa5（空闲态），**实际活态是 0xffffa301**。

## 四、fold 闭合的立即路径

用 `emulate_maxhook_encrypt_boundary.py --vm-context-snapshot vm_enter_context.bin
--input64 32206F9C... --input32 ... --plaintext ...` 即可：
1. 用活态 VM context（含正确 flag=0x41、key=0xffffa301）驱动 key-schedule；
2. 产生 keystream → 与 captured ciphertext 校验。

**第 141 轮补充**：
1. `vm_context_capture2` **完全完整**：10 调用 × (key + vm_enter_context + ciphertext +
   plaintext + nonce + tag) 全部齐备（数据缺口**已关闭**）；
2. emulator 实际运行仍**挂起**（key-schedule 循环不收敛，Unicorn timeout 未生效），
   这是 **emulator 收敛问题**（需正确 seed 活态 context 到 VM 的 768B 状态），非数据缺口。

**第 142 轮补充**：`vm_enter_context.bin` 是 **512B**（非完整 768B VM context），是加密入口
时刻的上下文切片。emulator 写 `snapshot[:512]` 到 VM_RBP，但完整 key-schedule 状态需 768B，
故 512B 切片可能缺关键 key-schedule 状态（后 256B），导致 key-schedule 循环不收敛。

**第 143 轮补充（关键诊断）**：`compare_live_idle_ctx.py` 实测：
- 512B live context **含** key-schedule 状态（+0x180..+0x2db 已填充活态值），非缺 256B；
- 关键差异：live `key=0xffffa301 flag=0x41` vs idle `key=0xffffffa5 flag=0x69`；
- **根本问题**：vm_enter_context 是**加密入口时刻（key-schedule 已完成）**的状态，但 emulator
  从 `0x180324610` 进入会**重跑 key-schedule**（用错误初始状态覆盖活态 context），故循环不收敛。

**第 144 轮验证**：核心事实确认——1 key（`32206F9C...`）跨 10 调用、10 nonce、10 ciphertext、
10 tag、10 vm_enter_context，plaintext/ciphertext 长度一致。vm_context_capture2 是**完整、
同步**的数据集（此前 43 轮被遗漏）。VM context 是**持久跨调用**（entry 时刻保留上一调用的
key-schedule 残留 `key=0xffffa301 flag=0x41`）。

## 五、交付物

| 资产 | 路径 |
|------|------|
| 本报告 | `MaxHook_fold闭合_关键数据缺口已找到_2026-08-14.md` |
| 检查脚本 | `examine_vm_context2.py`、`verify_vm_context2.py` |
| 数据 | `vm_context_capture2/`（10 调用，key + context + output） |
