# MaxHook key-schedule 静态解码路径 — 突破与精确下一步（第 118 轮）

日期：2026-08-14
范围：纯离线。

## 一、重大发现：key-schedule 可静态解码（非数据缺口）

重读 `analyze_maxhook_vm_initial_chain.py`（milestone 17）发现，它已**静态证明**了
VM dispatch 的完整机制（非 idle emulation 的 imprecise 追踪）：

1. **dispatch 公式**：`index = (word[VIP+idx_off] - key + 0x5214a88c) & 0xffff`（keyed handler）；
   `index = word[VIP+idx_off]`（unkeyed handler）；
2. **rolling key 是数据驱动的**：`key = word[VIP+key_off]`（从字节码自身读取），
   `key_after = key_before - index_full`（非简单 `key ^= key+0x4111` 递推！）；
3. **VIP 前进**：`VIP += i32[VIP+adv_off]`；
4. **handler 表查找**：`handler = table[index]`（table `0x180c64ebd`）。

这**纠正**了此前"rolling key imprecise"的结论——正确的公式已静态证明，此前 imprecise
是因为用了错误的 `key ^= key+0x4111` 递推（非数据驱动）。

## 二、第 118 轮实测：复现已证明的 4 次 dispatch

`walk_keyschedule_chain.py` 复现 milestone 17 的 4 次 dispatch，**完全一致**：

```
dispatch1: idx=0x147 (327)  adv=0xDBC5  tgt=0x1809ac48d
dispatch2: idx=0x321 (801)  adv=-0x7e43 tgt=0x180981ac9
dispatch3: idx=0x05d (93)   adv=0xc173  tgt=0x18098257f
dispatch4: idx=0x0e0 (224)  adv=-0xa068 tgt=0x1809a3b86  key_after=0xadeb35f2
```

第 4 次 dispatch 进入 `0x1809a3b86` = **ARX 链 C 的起点**（第 99/107 轮确认）。

## 三、精确的下一步（机械、离线、可解）

扩展链需**分类每个 handler 的 dispatch 布局**（idx_off, adv_off, key_off 三元组）。已证明的：

| handler body | idx_off | adv_off | key_off |
|--------------|---------|---------|---------|
| `0x1809f4736` | +6 | +2 | 无 |
| `0x1809da384` | +0xc | +4 | 无 |
| `0x1809bfebb` | +0 | +6 | +0xa（keyed） |
| `0x180a02a99`（链 C） | +6 | （待定） | 有（fold context+0xa） |

**方法**：对每个 handler（从 handler 表 target 反汇编尾部），识别其 dispatch stub 的
`mov word [rX]`（idx 读取）/`movsxd [rY]`（advance 读取）/`movzx [rZ]`（key 读取）偏移，
即可逐步走完整个 key-schedule 程序。这是纯静态、纯机械的任务（字节码 100% 离线可读）。

**第 119 轮补充**：`classify_all_dispatch_layouts.py` 尝试用简单启发式（`shl reg,3` 前驱
`movzx word ptr`）自动分类，结果 177/177 全部 `(None,None,None)`——dispatch 尾部是 Themida
重度混淆的（非简单 `shl,3` 模式），需像 milestone 17 那样**逐 handler 手工分析**（用
`require()` 断言精确指令序列）。这确认：路径正确（4 次 dispatch 已静态证明），但剩余是
**大量逐 handler 手工分类**（~177 个 handler），非单轮简单启发式可解。

## 四、结论

**缺口从"数据缺口"更正为"机械静态解码任务"**：key-schedule 字节码可**完全离线静态解码**
（dispatch 公式已证明，rolling key 数据驱动，handler 表已解密），无需真机、无需活态 heap、
无需 key 字节。需做的是分类 ~1612 个 handler 的 dispatch 布局并走链（工程量大但可解）。

## 五、交付物

| 资产 | 路径 |
|------|------|
| 链行走脚本 | `walk_keyschedule_chain.py` |
| 本报告 | `MaxHook_keyschedule静态解码路径_2026-08-14.md` |
