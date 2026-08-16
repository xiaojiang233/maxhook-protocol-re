# MaxHook native 协议里程碑 08：7 组验证集闭合、key 会话隔离与 Unlicense 适配性

日期：2026-08-13 18:01（Asia/Shanghai）  
范围：只读本地文件、静态反汇编、离线结构验证；没有重新附加进程，也没有向服务端发送请求。

## 1. 结论先行

用户交接的 `crypto_verify_set.json` 已通过独立校验器验证：7 组样本完整、属于同一会话、所有输出 KID 与输入 KID 相同，密文长度逐组等于 UTF-8 明文长度。7 组的外层 nonce、密文和 tag 均各不相同；明文内 16-byte nonce 与外层 12-byte nonce 逐组都不同。因此，这份文件已经可以作为 VM 正向加密实现的回归门槛，但不能把它误当成当前旧 dump 的同刻 VM 状态。

新的验证集 key-material 指纹（对 32-byte hex 解码结果取 SHA-256 前 12 个 hex）为 `a340fb925d80`。旧 boundary capture 的指纹是 `3ba8c1977db4`、`ffea889b4fc2`，keytrace 会话的指纹为另一值；在现有 280 个 boundary/keytrace/VM/WinHTTP 原始产物中未发现验证集的原始 key 或 KID。因此，旧 `runtime_bugland2.bin` 不能直接拿来声称“已经复现这 7 组”。

## 2. 验证集结构结果

校验器：[`analyze_maxhook_crypto_verify_set.py`](./analyze_maxhook_crypto_verify_set.py)  
脱敏结果：[`maxhook_crypto_verify_set_analysis.json`](./maxhook_crypto_verify_set_analysis.json)  
输入文件：`crypto_verify_set.json`（含敏感原文，仅保留在本机）。

| 项目 | 结果 |
|---|---:|
| 样本数 | 7 |
| `seq` | 74–80 |
| 唯一 KID | 1 |
| 唯一解码 key-material | 1 |
| 唯一 session/device 指纹 | 各 1 |
| 密文长度 = 明文 UTF-8 长度 | 7/7 |
| `output_kid == kid` | 7/7 |
| 外层 nonce | 12 bytes，7/7 唯一 |
| 明文内 nonce | 16 bytes，7/7 与外层不同 |
| ciphertext/tag | 各 7/7 唯一 |

这进一步支持“无填充的逐字节流式变换 + 独立认证 tag”的描述；它本身不能区分 VM 内部具体轮函数，也不能证明 tag 的 AAD/序列化输入。

输入文件 SHA-256：

`60cd72bab10bcf529c3e9307ff5b4606be1fedaf2474d38d2515f6efa3ef7f6e`

脱敏分析 JSON SHA-256：

`f9ef566fc19975c6c0a6da02d9a99bfb1a144d6042559a39d461d2a043fd47a8`

## 3. 修正 `0x180322d10` 的语义判断

交接文档把 `0x180322e30` 描述成“96 hex 的 hex 解码/字符变换函数”。静态代码不支持这个结论。当前反汇编显示：

```text
0x180322d10  保存 RCX/RDX/R8b
0x180322d9c  通过混淆间接表得到两个范围端点
0x180322e19  比较两个端点；相等则直接返回
0x180322e30  movzx edx, byte ptr [rdi]
0x180322e79  间接调用谓词；AL=0 则退出
0x180322e81  inc rdi
0x180322e84  cmp rdi, rsi
0x180322e87  jne 0x180322e30
```

它逐字节读取范围并调用一个间接谓词，期间没有把字节写入 key schedule 或输出缓冲；末尾还从 `r13` 取结果码返回。即使运行时该范围碰巧覆盖 `kid + input64` 的 96 个 ASCII hex，也只能说明这一步在做校验/匹配/分类，不能说明它完成了 hex 解码或派生实际密码 key。

这条修正很重要：下一阶段不应把时间花在“还原 `0x180322d10` 的 hex 解码结果”上，而应继续追踪 `0x181523001` VM 入口内对 input32/input64 的实际消费，以及同一会话的 VM 全局 handler-table 状态。

## 4. `unlicense` 的适配性审计

本地已存在仓库副本：`target/unlicense_repo`，HEAD 为 `95c8dc6`（0.4.0）。上游 README 将它定义为 Themida/WinLicense 2.x/3.x 的动态 unpacker/import fixer，支持 32/64-bit PE（包括 DLL），自动找 OEP、恢复混淆导入。它通过 Frida 启动目标；DLL 路径由 `rundll32.exe` 加载。上游明确警告工具会执行目标，建议在 VM 中使用。

对本项目的判断：

1. `MaxHook.runtime-unpacked.dll` 已经有 `.bugland`、`.boot` 和可反汇编的 dispatcher/handler 区，当前缺口是 VM 的动态状态/字节码语义，不是 OEP 或普通 IAT 修复。
2. `unlicense` 的 `winlicense3.py` 负责找 IAT、解包/修复 PE；代码没有 Themida VM 字节码反编译器，也没有本协议的 key/nonce/tag 识别逻辑。
3. 直接对 MaxHook 原 DLL 运行它会执行目标，可能触发初始化、反调试或网络行为；在没有隔离快照和明确授权前，本轮不运行、不安装依赖、不启动 `rundll32`。

所以它可以作为“从原始壳重新取得干净 runtime dump”的备选工具，但不能替代当前 VM 解译工作，也不能直接生成本协议的复现器。

上游资料：[`unlicense README`](https://github.com/ergrelet/unlicense)、[`winlicense3.py`](https://github.com/ergrelet/unlicense/blob/main/unlicense/winlicense3.py)、[`application.py`](https://github.com/ergrelet/unlicense/blob/main/unlicense/application.py)。

## 5. 可执行的下一步

当前离线工作应按以下顺序推进：

1. 把验证集只作为 oracle，不再从样本猜标准密码；先为 VM emulator 建立 `encrypt(key_material, kid, plaintext, context, nonce) -> ciphertext/tag` 的接口，验证阶段要求 7/7 全部匹配。
2. 对旧 dump 的 `0x181523001` 路径，先恢复 handler-table 的初始化/解密来源和 `[RBP+0x0A]`、`[RBP+0x6D]` 的同刻状态，再做 handler 语义归一化；当前旧 epoch 的高 index 槽越界仍是硬阻断。
3. 若要让验证集真正可用于 VM 运行，必须取得同一验证集会话的入口状态（至少 input 对象、R9 context、RIP/RSP/RFLAGS/GPR、VM 全局页和 handler table），或取得一个与验证集 key 指纹一致的完整 boundary/PSS 快照。仅有 plaintext/ciphertext 对不会补出 VM 状态。
4. 任何未来实机采集都只做一次 transition-triggered PSS/边界快照；不做长期 Suspend 轮询，不做在线重放。

## 6. 复核哈希

| 文件 | SHA-256 |
|---|---|
| `analyze_maxhook_crypto_verify_set.py` | `eb53b03336762066b11d63b0f6e4747233dc6e737df84f28cad315cd2e4dcc6e` |
| `MaxHook.runtime-unpacked.dll` | `f3ddac1dae9539f34e6b9d1fdea654f984cca4cff37851cadcbf6909b78af6a9` |
| `unlicense_repo/unlicense/application.py` | `b90bb15baa59ecc5dde91d98052c096fbadb0becf3fad1c6c10f5670e9ec34f5` |
