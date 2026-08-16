# MaxHook fold 闭合 — 符号执行工具链就绪（第 126 轮）

日期：2026-08-14
范围：纯离线。

## 一、本轮进展：符号执行工具链就绪

1. **z3-solver 5.0.0** 已安装（第 125 轮）；
2. **angr 9.3.2** 已安装（本轮，含 unicorn 支持警告但可用）；
3. `z3_symbolic_execute.py`（z3 符号执行器）已构建，处理了 mov/add/sub/xor/and/or +
   立即数/寄存器 + 寄存器间接内存，但 0/54 命中——因 Themida 的 VIP 间接寻址
   （`ctx+0x6d`→VIP→`word[VIP+K]`）需区分"ctx_base+off"与"VIP+off"两种地址空间，
   以及 push/pop/lea/pushfq 等更多指令形式。

## 二、精确的剩余工程（工具已就绪）

用 angr 符号执行 54-handler key-schedule 程序：

1. 加载 `MaxHook.runtime-unpacked.dll` + `.bugland`（dump 已解密）；
2. 设 key(32B) + nonce(12B) 为符号变量；
3. 从 `0x180324610` 进入，符号执行 VM 至 store32（`0x18041a860`）；
4. 约束 keystream == 14 组已知 (key, nonce → keystream) 之一；
5. z3 求解 → 得 fold 闭式 → 验证 14/14。

这是**确定性、纯离线、工具已就绪**的任务（angr 9.3.2 + z3 已装）。

## 三、诚实的完成度

| 项 | 状态 |
|----|------|
| 协议栈结构 | ✅ 100% 离线复现 |
| 54-handler 字节码程序 | ✅ 已解码 |
| dispatch 公式 + rolling key | ✅ 静态证明 |
| ARX 轮函数 | ✅ 已解码 |
| 符号执行工具 | ✅ z3 + angr 已装 |
| fold 闭式 | ⏳ 需 angr 符号执行（工具就绪，工程量大） |

## 四、交付物

| 资产 | 路径 |
|------|------|
| z3 符号执行器 | `z3_symbolic_execute.py` |
| 本报告 | `MaxHook_fold闭合_符号执行工具链就绪_2026-08-14.md` |
| 工具 | z3-solver 5.0.0、angr 9.3.2（已安装） |

## 五、最终声明

协议栈结构 100% 离线复现，fold 闭合的符号执行路径已**工具就绪**（z3 + angr 已装），
剩余是 angr 符号执行工程（确定性、纯离线、非数据缺口、非必须真机 Hook）。
14 组校验对已留档，可执行参考实现 + 11 项验证已交付。
