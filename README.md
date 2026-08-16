# MaxHook Protocol Reverse-Engineering — Research Archive

纯离线逆向分析 `MaxHook.dll` 报告加密协议的工作成果归档。

## 状态（最终）

```
ciphertext：20/20 恢复（HMAC-SHA256 KDF + ChaCha20 counter=1）
counter0 writer：3/3 证据
标准 SHA-256 domain KDF：已恢复
tag SHA context init：已到达（模拟器）
tag SHA update 输入：未捕获
tag SHA finalize：未捕获
tag：0/24
完整 envelope：0/24
```

> 唯一未闭合项：16-byte `tag` 构造。所有未恢复路径在参考实现中保持 **fail-closed**（`mac_tag()` 抛 `NotImplementedError`），无任何猜测实现。

## 目录结构

| 目录 | 内容 |
|------|------|
| `docs/` | 全部报告/交接/协议栈结论/round 进度文档 |
| `scripts/` | 分析/捕获/反汇编/模拟器 Python & JS 脚本 |
| `binaries/` | `MaxHook.dll`、`MaxHook.runtime-unpacked.dll`、内存/bugland dump |
| `captures/` | 真实捕获数据（边界、keystream history、live stack、pss 等）|
| `verification/` | 验证集、参考实现、tag/SHA 搜索报告 |
| `raw/` | 反汇编 .asm、字符串表、模块列表、misc 数据 |
| `_bigdata/` | 5.5GB 原始进程内存 dump（gitignored，不进 git）|

## 权威交付物

- `docs/README_交付物索引.md` — 交付物索引
- `verification/maxhook_protocol_reference.py` — **可执行参考实现**（ciphertext 7/7）
- `verification/crypto_verify_set.json` — 验证样本集
- `docs/MaxHook_tag恢复进展_2026-08-14_会话.md` — tag 恢复最新进展
- `binaries/MaxHook.runtime-unpacked.dll` — 反混淆运行时（base 0x180000000）

## 关键技术锚点

- 报告加密入口：`0x180324610`（VM 保护）
- SHA 函数表：`[0x1807DDA20]=0x18042B840`(init)、`[0x1807DDA28]=0x18042B9B0`(update)、`[0x1807DDA30]=0x18042BB00`(finalize)
- live 续路径：`0x181AC0A58`
- domain label：`v3|hpac.v3.session.report.req`
- 大函数表：`0x1807BDC70`；writer 表：`0x180715060`

## 模拟器运行

主模拟器在 `scripts/emulate_maxhook_encrypt_boundary.py`。
需要本地 `.pydeps`（capstone/unicorn），当前未纳入本仓库（依赖可重装）。

```bash
python scripts/emulate_maxhook_encrypt_boundary.py --help
```

## 整理说明

本次整理由 `_bigdata/organize_maxhook.py` 执行：
- 保留：脚本、文档、DLL/dump、真实捕获、验证集、反汇编、tag 最终 replay
- 删除：可再生成的模拟器追踪 JSON（encrypt_vm_*/diff_*/boundary_call2_*/async_* 等，共 ~10.9GB）
- `_bigdata/dump_out_41264`：5.5GB 原始内存 dump，gitignored 本地保留
