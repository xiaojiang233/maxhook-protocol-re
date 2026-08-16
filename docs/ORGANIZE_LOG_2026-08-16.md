# 整理日志 — 2026-08-16

## 背景
`E:\Coding\S1mple\target` 原约 17GB，含 MaxHook.dll 逆向分析的全部过程产物。
按用户要求：保留核心资料/脚本/dump/capture/日志，删除可再生成的大追踪，迁移到新仓库
`E:\Coding\MaxHookRe`（GitHub private: `xiaojiang233/maxhook-protocol-re`）。

## 保留（迁移至 MaxHookRe，进 git）

| 类别 | 数量 | 说明 |
|------|------|------|
| docs/ | 124 | 全部报告/交接/协议栈结论/round 进度 |
| scripts/ | 400 | 分析/捕获/反汇编/模拟器脚本 |
| binaries/ | 12 | MaxHook.dll、runtime-unpacked.dll、内存/bugland dump |
| captures/ | 2040 | 全部真实捕获（边界/keystream/live stack/pss 等）|
| verification/ | 49 | 验证集、参考实现、tag/SHA 搜索报告 |
| raw/ | 100 | 反汇编 .asm、字符串表、模块列表、misc |
| **合计** | 2785 文件 | 约 476 MB |

## 保留（本地，不进 git）
- `_bigdata/dump_out_41264/`：5.5GB / 10765 文件，原始进程 41264 内存区域 dump（唯一不可再生成）。gitignored。

## 删除（约 10.9GB）
- 全部模拟器追踪 JSON：`encrypt_vm_*`、`diff_*`、`boundary_call2_*`、`async_*`、`tag_attempt_*`（均可由 `scripts/emulate_maxhook_encrypt_boundary.py` 再生成）
- `remote-log-3h.txt`（169MB 原始日志）
- 零字节空文件、中间调试杂项（p2_*/sp1_*/pf_*/tsc*_out/tbl*/env2_out 等）
- 无关 jar 构建产物
- 顶层删除的 17 个无关目录（unlicense_env/unlicense_repo/.pydeps/maven/classes 等）约 128MB

## 结果
- `E:\Coding\S1mple\target`：已清空（0 文件 / 0 MB）
- `E:\Coding\MaxHookRe`：478 个目录/文件进 git，git status clean
- 单文件最大 63MB（disasm_text.asm），均满足 GitHub 100MB 限制
