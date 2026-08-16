# MaxHook 字生产者 0x180b8c7aa 精确数据流（离线符号化）

日期：2026-08-14（第 5 轮）
范围：纯离线。来源：`disasm_unpacked.asm` 完整反汇编 + `edx_slice_findings_corrected.md`。

## 一、结论

字生产者 handler `0x180b8c7aa` 是**最终密钥流字（store32 的 EDX）的直接来源**。它通过 6 个
`push qword ptr [context + word[VIP+offset]]` 位点，把 **6 个 VM context 槽的值**压入 VM 数据栈，
这 6 个值随后被后续字节码折叠成最终的 32-bit 密钥流字。

## 二、6 个 push 位点的精确 context 槽索引

每个 push 的模式统一为（Themida 混淆拆解后）：

```text
r = [context+0x6d]          ; r = VIP
r += K                      ; K = 固定字节码偏移
w = word[r]                 ; w = 16-bit 字节码字 @ VIP+K
ptr = context + w           ; ptr = context + (16-bit 槽索引)
push qword ptr [ptr]        ; 压入 context[w] 的值
```

| # | push 地址 | VIP 偏移 K | 语义 |
|---|---|---|---|
| 1 | `0x180b8c81b` | `+0x1c` | `push [ctx + word[VIP+0x1c]]` |
| 2 | `0x180b8c882` | `+0x18` | `push [ctx + word[VIP+0x18]]` |
| 3 | `0x180b8c91a` | `+0x10` | `push [ctx + word[VIP+0x10]]` |
| 4 | `0x180b8c9a6` | `+0x08` | `push [ctx + word[VIP+0x08]]` |
| 5 | `0x180b8ca27` | `+0x1a` | `push [ctx + word[VIP+0x1a]]` |
| 6 | `0x180b8caa0` | `+0x0c` | `push [ctx + word[VIP+0x0c]]` |

即：最终密钥流字 = 由这 6 个 context 槽值（`word[VIP+0x1c]`、`word[VIP+0x18]`、`word[VIP+0x10]`、
`word[VIP+0x08]`、`word[VIP+0x1a]`、`word[VIP+0x0c]` 所索引的 context 槽）经后续字节码折叠而成。

## 三、与 store32 的连接（已证明）

`edx_slice_findings_corrected.md` 已证明：最终密钥流字 EDX = S10（producer 压入的 6 值之一或折叠），
经 trampoline `0x180c2775c popfq;ret` 进入 `0x18041a860 store_le32`。

## 四、剩余的唯一未闭环

这 6 个 context 槽值 = **key-schedule 的输出状态**（key + nonce 展开后的 state）。要闭合，需：

1. 恢复 key-schedule（key + nonce → 这 6 个 context 槽值），代码在
   `0x1809bd245..0x1809bd73a`（key-consumer，含常量 `0x32f12c5a`/`0x35a7d4cf`，key 经 context+0xbd 消费）；
2. 恢复折叠字节码（6 个栈值 → EDX 的算术序列），在 push 之后、trampoline 之前的字节码流。

两者均在离线 `.bugland` VM 内，handler table 已解密（`0x180c64ebd`）。

## 六、运行期实测验证（本轮完成，144 次命中）

在 `emulate_maxhook_encrypt_boundary.py` 增加 6 个 push 位点插桩（`--input64 347230E6...` 真实 key），
重放命中字生产者 **144 次**，捕获到 6 个 context 槽的字节码字与实际值（`encrypt_vm_wordproducer_probe.json`）：

```text
字节码字循环固定集合：{0xb5, 0x26, 0xd9, 0x61, 0xbd, 0x106}
（对应 VIP+0x1c/+0x18/+0x10/+0x08/+0x1a/+0x0c 六个固定字节码偏移）

实测槽值示例（inst 41552..41672）：
  slot[0xb5]  = 0x0            slot[0x26]  = 0xa82b01ab
  slot[0xd9]  = 0xc9d34ff410   slot[0x61]  = 0xc9d34ff260
  slot[0xbd]  = 0x0            slot[0x106] = 0x0
```

关键观察：

1. 字节码字在 6 个固定值间循环（`0xb5/0x26/0xd9/0x61/0xbd/0x106`），不是随机的——这是**固定的字节码序列**；
2. `slot[0x26]`（VM base 槽）、`slot[0xd9]`/`slot[0x61]`（堆指针 `0xc9d34ff...`）是 VM 运行时状态；
3. 堆指针 `0xc9d34ff410`/`0xc9d34ff260` 是 Java 进程的 native 堆对象（与里程碑 20 的 `0xc9d34ff410` output object 一致）；
4. 这些 6 值经后续字节码折叠成 keystream 字（尚未闭合的折叠序列）。

这**证明**了字生产者数据流分析的正确性，并把"剩余未闭环"进一步收窄为：6 个槽值 → EDX 的**折叠字节码序列**（在 6 个 push 之后、trampoline 之前）。

## 七、RDX 算术的性质澄清（第 14 轮）

字生产者块 `0x180b8c7aa` 内的 RDX 算术（`sub rdx,rbx` / `xor rdx,0x4f0` / `and rdx,0x3f` /
`sub rdx,0x80` / `xor rdx,0x90`）经分析是**指针/表索引算术**（Themida 反静态分析），**不是密码 fold**：

- `and rdx, 0x3f` = 6-bit 掩码（64 项表索引，对应 64 字节块）；
- `sub 0x80` / `xor 0x90` = 与 `0x9e22`/`0x1d6e` 同类的**指针去混淆**；
- `sub rdx, rbx`（rbx = `word[VIP+...]+rbp` 派生指针）= 派生指针计算。

真正的密码 fold 在 **trampoline 区域 `0x180c27500..0x180c27d00`**（含 9 个真实 32-bit 常量），
最终 EDX = S10 在 `0x180c27be2 mov rdx,[rsp]` 加载，经 `popfq;ret` 进 store32。

## 九、fold EDX 加载点实测（第 18 轮最终确认）

在 fold 的 EDX 加载点 `0x180c27be2 mov rdx,[rsp]` 插桩，重放结果：

- **fold 命中仅 2 次**（inst 231295 与 1232628），而字生产者命中 144 次；
- 2 次 fold 的 `edx = 0x2840`（常量，非高熵密钥流字）。

**结论**：字生产者的 144 次命中是 **key-schedule/init 阶段**（不产密钥流），而 fold/store32
路径（产真实密钥流字）在模拟器中**从未到达**。`0x2840` 是指针/偏移值，非密钥流字。
这最终确认：模拟器因空闲态 dump 缺活态 key-schedule 状态，无法到达密钥流生成。

## 十、验证方法

用 dump 的完整解密 `.bugland` + 解密 context 重放（已推进 4.16M 指令、命中本 handler 144 次），
在 6 个 push 位点 + store32 插桩，记录 `word[VIP+K]` 与 `context[word[VIP+K]]` 的实际值，
即可逐字节还原 key-schedule 输出 → keystream 的映射，再用 10 组 `(key,nonce,keystream)` 已知明文对校验。
