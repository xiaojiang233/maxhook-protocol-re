# MaxHookRe 整理计划

新仓库根：`E:\Coding\MaxHookRe`（GitHub private: `maxhook-protocol-re`，用户 xiaojiang233）

## 保留类别

| 子目录 | 内容 |
|--------|------|
| `docs/` | 所有 `<20MB` 的 `.md`/`.html` 报告、交接、协议栈结论、round 进度、README 索引 |
| `scripts/` | 所有 `.py`/`.js` 分析、捕获、反汇编、模拟器脚本 |
| `binaries/` | `MaxHook.dll`、`MaxHook.runtime-unpacked.dll`、关键 `.bin`（bugland/boot/context）|
| `captures/` | 所有真实捕获目录（encrypt_boundary_capture2、keystream_history、native_capture_live、pss_live、crypto_capture2 等）|
| `verification/` | 验证集 JSON、参考实现、test_tag/verify 脚本、harness |
| `search/` | SHA/HMAC/Poly1305/tag 搜索脚本与报告 |
| `raw/` | 小型反汇编 txt、disasm .asm、字符串表、模块列表、misc 数据 |
| `_bigdata/` | 5.5GB dump_out（gitignore，不进 git）|

## 删除类别（可再生成或无用）

- 所有 `>20MB` 的 `encrypt_vm_*`、`tag_attempt_*`、`diff_*_trace*` JSON 追踪（模拟器可再生成）
- `remote-log-3h.txt` (169MB)
- 零字节空文件
- `p2_*`/`sp1_*`/`pf_*`/`tsc*_out`/`tbl*`/`env2_out` 等中间调试杂项输出
- `disasm_text.asm` 已决定保留（进 git）
- `unlicense_repo`/`unlicense_env`/`.pydeps`/maven/classes 等构建产物与无关工具（不迁移）

## git 限制检查

- 单文件必须 <100MB（所有保留文件均满足）
- 仓库总大小目标 <1GB（实际预计约 200-300MB，主要来自 disasm+binaries）
