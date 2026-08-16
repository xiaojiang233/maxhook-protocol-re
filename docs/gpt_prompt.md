你正在继续一个 MaxHook.dll 加密协议纯离线逆向任务。请直接从当前工作区和现有资产继续，不要重新从零分析，也不要进行新的活态注入或抓包。

# 一、最终目标

完整独立实现：

1. raw key + nonce -> keystream
2. ciphertext 生成
3. 16-byte tag 生成
4. 完整 JSON envelope：
   {"sv":3,"kid":"...","nonce":"...","ciphertext":"...","tag":"..."}
5. 最终对本地要求的 24 组向量全部匹配
6. 所有未恢复路径必须 fail-closed
7. 未完成前不得宣称完整复现

当前准确状态不是完成状态，主要剩余问题是 tag。

# 二、用户要求和限制

用户希望：

- 继续纯离线研究；
- 不进行新的真机注入、活态 hook、抓包；
- 不得复用捕获的 ciphertext/tag 伪装成实现；
- 说话尽量通俗，但分析过程可以深入；
- 不要把 goal 标记为 blocked；
- 不要触碰仓库中无关的 Java、pom.xml 等脏改动。

当前 Git 工作区原本就存在很多无关改动，例如：

- pom.xml
- src/main/java/... 大量 Java 文件
- .idea 文件
- 其他临时文件

这些不是本任务产生的，禁止修改、还原、暂存或提交。

# 三、环境

操作系统：

Windows，PowerShell

工作目录：

E:\Coding\S1mple

主要分析目录：

E:\Coding\S1mple\target

核心文件：

E:\Coding\S1mple\target\MaxHook.dll
E:\Coding\S1mple\target\MaxHook.runtime-unpacked.dll
E:\Coding\S1mple\target\runtime_bugland2.bin

更适合当前离线 replay 的 bugland：

E:\Coding\S1mple\target\dump_out\41264\region_0000000180980000.bin

Python：

D:\Python312\python.exe

已安装的主要 Python 包包括：

- pefile
- capstone
- unicorn
- cryptography
- pycryptodome

仓库根目录没有 `.codegraph`，因此不用 CodeGraph。

# 四、重要地址

```text
encrypt entry     = 0x180324610
VM context        = 0x18098c884
handler table     = 0x180c64ebd
store32           = 0x18041a860
writer trampoline = 0x180c2775c
SHA init          = 0x18042b840
SHA update        = 0x18042b9b0
```

nonce 后关键 ret：

```text
0x180c25a53
```

此前离线 replay 的错误 ret target：

```text
0x7ffe1feeb8
```

最新从真实、已存在的历史快照中恢复出的实际 target：

```text
0x181ac0a58
```

证据：

在目录：

E:\Coding\S1mple\target\keystream_history_capture_20260814

共 52 个 snapshot 中，所有 `0x180c25a53` 后继地址均为：

```text
0x181ac0a58
```

也就是：

```text
52/52 occurrences
0x180c25a53 -> 0x181ac0a58
```

# 五、已经完整恢复的算法部分

## 1. 输入结构

```text
raw key = input64 的 64 个 hex ASCII 字符解码后得到 32 bytes
kid     = input32，32 个 hex ASCII 字符，对应 16 bytes
nonce   = 12 bytes
tag     = 16 bytes
```

AAD/domain：

```python
DOMAIN_LABEL = b"v3|hpac.v3.session.report.req"
```

长度是 29 bytes。

## 2. 精确 KDF

已通过 SHA 调用顺序和中间 digest 离线证明：

```python
derived_key = HMAC_SHA256(
    raw_key,
    b"v3|hpac.v3.session.report.req"
)
```

这是精确结果，不再是假设。

## 3. 精确 payload cipher

已证明：

```python
ciphertext = plaintext XOR ChaCha20(
    key=derived_key,
    nonce=nonce,
    initial_counter=1
)
```

具体为标准 RFC 8439 / IETF ChaCha20：

```text
20 rounds
32-bit counter
96-bit nonce
little-endian words
payload counter starts at 1
```

参考实现：

E:\Coding\S1mple\target\maxhook_protocol_reference.py

验证器：

E:\Coding\S1mple\target\verify_recovered_chacha20.py

运行：

```powershell
python E:\Coding\S1mple\target\verify_recovered_chacha20.py
```

当前结果：

```text
crypto_verify_set:                     7/7
vm_context_capture2:                  10/10
writer_sync_clean_20260814_014351:     3/3
TOTAL:                                20/20
```

注意：

- 当前直接整理进该验证器的是 20 组；
- 用户最终要求仍是本地 24 组全部通过；
- 不能把 20/20 表述成最终 24/24。

# 六、最新重要突破：counter=0 也被真实 writer 证明

真实 writer 捕获目录：

E:\Coding\S1mple\target\writer_sync_clean_20260814_014351

原分析脚本把 payload block 前的 12 个 writer records 当作“不完整前导数据”丢弃。

重新比较后发现，这 12 个 word 精确等于：

```python
chacha20_block(derived_key, counter=0, nonce)
```

的前 48 bytes。

例如 call 1：

```text
counter0 block:
bd055da56cc6d68f4d9dbd6a94f98fc7
4babcd2f8ef51968d435b91b35d48e93
05e3aa3013fb9a18c74118a2941e6484
beba96500ff9dd7db6646f972513df83
```

捕获的前 12 个 records 依次为：

```text
bd055da5
6cc6d68f
4d9dbd6a
94f98fc7
4babcd2f
8ef51968
d435b91b
35d48e93
05e3aa30
13fb9a18
c74118a2
941e6484
```

即 counter=0 block 的 words 0..11，三组 writer 调用都匹配。

初始缺失的 4 个 word 是 Stalker 开始跟踪较晚造成的，不代表算法未生成。

因此现在已有真实证据表明：

```text
counter 0 block 在 payload counter=1 之前被生成
```

这通常是认证材料，但当前不能仅凭这一点宣称 tag 是标准 Poly1305，因为标准 Poly1305 搜索并未命中。

# 七、tag 当前状态

```text
independent tag = 0/24
complete envelope = 0/24
```

`mac_tag()` 当前必须继续抛出 NotImplementedError，保持 fail-closed。

已经离线排除：

1. 标准 ChaCha20-Poly1305：
   - 空 AAD
   - DOMAIN_LABEL
   - kid raw
   - kid hex
   - domain/kid 的常见组合

2. 大范围 Poly1305 搜索：
   - 696,026 条消息布局
   - 35 种 key mode
   - 4 种 tag 字节变换
   - 0 命中

3. 常见 HMAC/hash/CMAC：
   - HMAC-MD5/SHA1/SHA2/SHA3/BLAKE2
   - SHA key prefix/suffix/sandwich
   - keyed BLAKE2
   - AES-CMAC
   - 36,624,840 次
   - 0 命中

4. Poly1305 r/s 分离来源：
   - 2,206,208 次
   - 0 命中

5. digest 与 ChaCha/key-derived pad 的：
   - XOR
   - uint128 LE/BE 加减
   - 3,879,750 次
   - 0 命中

6. 独立 MAC key label：
   - 1,216 个 label
   - 12,164 个 key
   - 27,004,080 次
   - 0 命中

7. 完整 64-byte ChaCha block 作为 HMAC/hash key：
   - counters 0..15
   - raw/derived key
   - reverse/word-swap
   - 10,641,600 次
   - 0 命中

8. GHASH/GCM 常见形式：
   - raw key
   - derived key
   - kid
   - ChaCha counter0 的 lo/hi/mid/xor halves
   - 0 命中

9. unkeyed MD5/SHA/BLAKE 常见消息布局：
   - 0 命中

相关脚本：

```text
E:\Coding\S1mple\target\search_poly1305_layout.py
E:\Coding\S1mple\target\search_generic_mac.py
E:\Coding\S1mple\target\search_poly1305_components.py
E:\Coding\S1mple\target\search_tag_digest_pad.py
E:\Coding\S1mple\target\search_tag_kdf_labels.py
```

相关报告：

```text
E:\Coding\S1mple\target\poly1305_layout_search_report.json
E:\Coding\S1mple\target\generic_mac_search_report.json
E:\Coding\S1mple\target\poly1305_component_search_report.json
E:\Coding\S1mple\target\tag_digest_pad_search_report.json
E:\Coding\S1mple\target\tag_kdf_label_search_report.json
E:\Coding\S1mple\target\MaxHook_ChaCha20密文闭合与tag离线排除_2026-08-14.md
```

不要重复跑相同的盲猜搜索，除非加入了明确的新证据。

# 八、最新 emulator 进展

离线 emulator：

E:\Coding\S1mple\target\emulate_maxhook_encrypt_boundary.py

正确的基础参数必须包括：

```text
--bugland target\dump_out\41264\region_0000000180980000.bin
--reconstruct-keystream-state
--seed-nonce ...
```

只使用默认 `runtime_bugland2.bin` 会较早在约 1.297M 指令失败。

最新命令：

```powershell
python target\emulate_maxhook_encrypt_boundary.py `
  --bugland target\dump_out\41264\region_0000000180980000.bin `
  --reconstruct-keystream-state `
  --max-instructions 5000000 `
  --timeout-ms 180000 `
  --fast-diff-trace `
  --compact-fast-diff `
  --seed-nonce 010000000000000000000000 `
  --patch-ret-target 0x181ac0a58 `
  --output target\diff_nonce_ret_livehistory_181ac0a58_5m.json
```

结果：

```text
instruction_count = 4,264,717
error = Invalid memory fetch
target RIP = 0x00000000000b8c12
```

这是比原来的 4,163,003 ret 阻断多推进约 101k 指令。

输出：

E:\Coding\S1mple\target\diff_nonce_ret_livehistory_181ac0a58_5m.json

## 极重要的新 SHA 事件

使用真实历史 target `0x181ac0a58` 后，出现了新的 SHA init：

```text
instruction = 4,150,611
address     = 0x18042b840
kind        = init
context     = 0x20000100180
context size allocation = 112 bytes
```

这发生在 nonce seed 之后：

```text
nonce seed instruction = 3,988,473
```

之前的 6 个 SHA init/update 事件已经完整解释为 domain KDF 的 HMAC-SHA256。

因此这个新增的第 7 个 SHA init 很可能属于 tag/authentication 阶段。

但目前只捕获到 init，还没有捕获其 update 输入，所以不能直接断言 tag 是哪种 SHA MAC。

最新 emulator 仍然：

```text
fast_diff_nonce_reads = 0
store32_trace         = 0
```

但出现：

```text
word_producer_trace = 360
```

最终崩溃状态：

```text
RIP = 0xb8c12
VIP = 0x181b08049
key_low32 = 0xffff0171
last VM target = 0x18098852b
```

这说明 `0x181ac0a58` 比此前猜测的 target 明显更接近真实路径，但深层 stack/frame 仍不完整，导致最后跳到小地址 `0xb8c12`。

不要把 `0x181ac0a58` 直接当作完整修复；它只是有 52/52 live-history 证据的正确 ret continuation，后续逻辑 frame 仍需恢复。

# 九、trace-window 文件注意事项

最新还生成了：

E:\Coding\S1mple\target\diff_nonce_ret_livehistory_181ac0a58_trace4260k.json

命令使用：

```text
--trace-window-start 4260000
```

但是 fast-diff trace 中 `trace_window` 项主要只有 instruction 序号，未包含预期的完整 mnemonic/register 数据。

如果要分析最终 `0xb8c12` 跳转来源，需要：

1. 改进 emulator 的 fast-diff trace_window，使它记录：
   - address
   - bytes
   - mnemonic
   - operands
   - registers
   - RSP 附近 stack
2. 或仅在 4.25M 后开启完整 trace，避免生成数百 MB 的无关日志。

上一轮在读取该 trace-window 后被用户中止，当前没有需要等待的已知 shell 命令。

# 十、优先下一步

不要继续大规模盲猜 MAC。

优先顺序：

## 1. 固化 counter0 writer 证据

写一个验证脚本，针对 writer_sync 的 3 个调用证明：

```text
前导 records == ChaCha20 counter0 block 的已捕获部分
payload records == counters 1..N
```

建议文件：

```text
E:\Coding\S1mple\target\verify_writer_counter0.py
```

## 2. 修复 trace-window 输出

检查：

```text
E:\Coding\S1mple\target\emulate_maxhook_encrypt_boundary.py
```

约 716–739 行的 trace-window 逻辑。

目标是精确记录 4,260,000–4,264,717 指令，找出：

```text
谁把跳转目标算成了 0xb8c12
正确目标依赖哪个 stack/context 值
```

## 3. 继续推进新增 SHA context

重点监控：

```text
SHA context = 0x20000100180
SHA init    = instruction 4,150,611
```

需要捕获该 context 后续：

```text
0x18042b9b0 SHA update 的 data pointer 和 length
SHA final/digest 输出位置
```

如果能得到 update 数据，就可直接确定 tag 的 MAC message 布局。

建议给 emulator 增加：

```text
--stop-on-sha-update-after-nonce
--watch-sha-context 0x20000100180
```

并在出现 nonce 后的新 SHA update 时立即停止和输出：

- buffer hex
- length
- SHA context
- registers
- stack
- surrounding VM jump history

## 4. 恢复后续深层 VM stack/frame

正确 ret continuation 已有：

```text
0x181ac0a58
```

现在缺的是 continuation 所依赖的逻辑 frame，不是继续猜其他 generated-code 地址。

可比较：

- live history 中 `0x181ac0a58` 之后的 handler 地址序列；
- emulator 中 patch 后的 handler 地址序列；
- 找到首次分歧；
- 在首次分歧处比较 context slot、RSP 和 stack qwords。

live history 来源：

```text
E:\Coding\S1mple\target\keystream_history_capture_20260814\*.bin
```

这些 history 中包含从：

```text
0x180c25a53
0x181ac0a58
```

一直到 payload XOR/word producer 的真实 handler 序列。

# 十一、现有核心文件

```text
E:\Coding\S1mple\target\maxhook_protocol_reference.py
E:\Coding\S1mple\target\verify_recovered_chacha20.py
E:\Coding\S1mple\target\emulate_maxhook_encrypt_boundary.py
E:\Coding\S1mple\target\trace_guided_vm_lifter.py
E:\Coding\S1mple\target\offline_key_absorption_reference.py
E:\Coding\S1mple\target\verify_offline_key_absorption.py
E:\Coding\S1mple\target\analyze_writer_sync.py
E:\Coding\S1mple\target\capture_maxhook_writer_sync.js
```

向量和捕获：

```text
E:\Coding\S1mple\target\crypto_verify_set.json
E:\Coding\S1mple\target\vm_context_capture2
E:\Coding\S1mple\target\writer_sync_clean_20260814_014351
E:\Coding\S1mple\target\keystream_history_capture_20260814
E:\Coding\S1mple\target\encrypt_boundary_capture2
```

历史报告：

```text
E:\Coding\S1mple\target\MaxHook_纯离线key吸收阶段完整压缩_2026-08-14.md
E:\Coding\S1mple\target\MaxHook_离线差分定位32字节key吸收轮_2026-08-14.md
E:\Coding\S1mple\target\MaxHook_nonce后栈trampoline离线审计_2026-08-14.md
E:\Coding\S1mple\target\MaxHook_ChaCha20密文闭合与tag离线排除_2026-08-14.md
```

# 十二、准确完成度

```text
key absorption:                 完成
exact domain HMAC-SHA256 KDF:   完成
ChaCha20 keystream:             完成
ciphertext reproduction:        当前整理的 20/20
counter0 generation evidence:   writer 3/3 的已捕获部分匹配
independent tag:                0/24
complete envelope:              0/24
```

最终目标尚未完成。

请从“修复 emulator trace-window、分析 0xb8c12 首次分歧、捕获 nonce 后 SHA update 输入”开始继续。