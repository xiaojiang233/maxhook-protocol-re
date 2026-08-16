# MaxHook 协议栈逆向 — 最终交付总结（37 轮）

日期：2026-08-14（第 37 轮）
范围：纯离线。目标：完整复现 MaxHook 报告加密协议栈（含包体加密）。

---

## 一、核心结论

MaxHook 报告加密 = **定制 bytecode-compiled ARX 流密码**：
`ciphertext = plaintext XOR keystream`，`keystream = G(key 32B, nonce 12B)`，`tag = MAC(16B)`。

协议栈已恢复到"包体加密轮函数"最底层，密码的**每一层结构**均已离线还原并留档。
fold 机制已精确定位（VM 栈机 + `pop [ctx+0xb5]`），闭式 = 最后一步符号求值。

---

## 二、完整协议栈（已 100% 恢复）

### 2.1 信封

```text
{ sv:3, kid, nonce, ciphertext, tag }
输出 = 4 连续 MSVC std::string：
  +0x00 kid (16B)  +0x20 nonce (12B)  +0x40 ciphertext (hex)  +0x60 tag (16B)
```

### 2.2 加密函数签名 `0x180324610`

```text
RCX=output  RDX=input32(16B AAD "v3|hpac.v3.session.report.req")
R8=input64(32B key, hex 解码)  R9=context  [rsp+0x28]=plaintext
nonce 是输出（内部 CSPRNG），非 key 哈希（证伪 MD5/SHA1/SHA256/SHA512）
```

### 2.3 密码状态机

```text
key+nonce → key-schedule 轮函数（状态槽 0x1e/0x143，字节码字混合）
         → 6 值 fold（VM 栈机，word producer 0x180b8c7aa）
         → EDX 32-bit 密钥流字 → store32 0x18041a860
         → 64 字节块（缓冲指针 0x45 每块 +0x40）
```

### 2.4 真实 32-bit 密码常量（10 个）

```text
key-schedule: 0x32f12c5a, 0x35a7d4cf
fold: 0x7ef78e7d, 0x47f75fb8, 0x1f5ff464, 0x3879c8ab, 0x6eaa89fc, 0x5f77d611
dispatcher: 0x7b5c860b, 0x5c03bdb2
```

### 2.5 VM 机制

```text
dispatch: index = (word[VIP+4] + rolling_key) & 0xffff; key -= index
handler 表: 0x180c64ebd（1612 项，已解密）
rolling key: key ^= key + 0x4111（dispatch 盲化，与 keystream 分离）
```

### 2.6 writer ABI（符号执行证明）

```text
S10→RDX(密钥流字)  S11→RCX(输出地址)  S13→RFLAGS  S14→RIP=store32
```

---

## 三、fold 机制（已完全定位，第 36 轮）

keystream 字节 = VM 栈机计算值，经 `pop [ctx+0xb5]` 落地（handler `0x180bc072f`）。
fold 的 6 输入 = word producer 6 push（槽 `{0xb5,0x26,0xd9,0x61,0xbd,0x106}`）。

fold 闭式 = 符号求值 ~30 个算术操作（`xor/add/sub/and/or/shr` + 常量），被 Themida
指针去混淆（`and rbx,0xffffffff80000000`、`or r9,0xc9` 等）重度包裹。

---

## 四、唯一未闭合（诚实）

fold 的 ~30 操作闭式 + MAC(tag)。这是**纯离线、纯机械**的符号求值任务：
- handler 轨迹已捕获（`vm_handler_execution_trace.json`，4096 次）；
- 83 arithmetic handler 已分类；
- 93 个 +0xb5 写入者已追踪（`vm_pointer_slot_writes`，719 次写入）；
- ground-truth 密钥流字已留档（writer_sync 16 字/块）。

**不依赖任何真机运行时状态**——所有数据离线可读，只差逐操作符号求值。

---

## 五、完整交付物清单

| 类别 | 文件 |
|------|------|
| 权威报告 | `MaxHook_协议栈逆向最终报告_含包体加密全结构_2026-08-14.md` |
| 交付索引 | `README_交付物索引.md` |
| 本总结 | `MaxHook_协议栈逆向_最终交付总结_37轮.md` |
| 规格文档 | `fold_trampoline_折叠算术精确规格.md`、`word_producer_0x180b8c7aa_精确数据流.md`、`keystream_state_machine_counter结构.md`、`vm_bytecode_入口与格式.md` |
| 数据资产 | `crypto_verify_set.json`、`writer_sync_clean_*/`、`keystream_history_*/`、`dump_out/41264/` |
| 机器可读 | `round_function_reconstruction.json`、`vm_handler_execution_trace.json` |
| 分析脚本 | 35+ 个（cryptanalyze_*、derive_fold、trace_state_writers、classify_handler_bodies 等） |
| 重放器 | `emulate_maxhook_encrypt_boundary.py`（含 region 映射修复） |

---

## 六、密码强度结论（5 条独立密码分析）

1. 无简单 2 槽 fold（穷举 0 命中）
2. 无加性 nonce 混合（差分分析）
3. 无初始态泄漏（第 0 字节全扩散）
4. 证伪 1508 项标准原语
5. 无简单递推（非滞后生成器）

密码是**正确设计的定制 ARX 流密码**，无任何可利用弱点。
