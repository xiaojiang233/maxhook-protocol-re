# MaxHook：ChaCha20 密文闭合与 tag 离线排除进度

日期：2026-08-14

## 已闭合

独立实现已经确认：

```text
derived_key = HMAC-SHA256(raw_key, b"v3|hpac.v3.session.report.req")
ciphertext  = plaintext XOR ChaCha20(derived_key, nonce, counter=1)
```

验证结果：

```text
crypto_verify_set.json                 7/7
vm_context_capture2                   10/10
writer_sync_clean_20260814_014351      3/3
TOTAL                                 20/20
```

参考实现：

```text
target/maxhook_protocol_reference.py
target/verify_recovered_chacha20.py
```

## tag 当前仍未闭合

以下纯离线搜索均为 0 命中：

1. 标准 ChaCha20-Poly1305，常见 AAD（空、domain、kid、kid hex 及组合）；
2. Poly1305 大范围布局搜索：696,026 条消息布局 × 35 种 key mode × 4 种输出字节序；
3. 常见 HMAC/哈希/CMAC 搜索：36,624,840 次；
4. Poly1305 `r` / `s` 分离来源搜索：2,206,208 次；
5. digest 与 ChaCha/key-derived pad 的 XOR/加减组合：3,879,750 次；
6. 1,216 个 auth/mac/tag KDF label 变体、12,164 个候选 key、27,004,080 次 MAC 测试。

对应脚本/报告：

```text
target/search_poly1305_layout.py
target/poly1305_layout_search_report.json
target/search_generic_mac.py
target/generic_mac_search_report.json
target/search_poly1305_components.py
target/poly1305_component_search_report.json
target/search_tag_digest_pad.py
target/tag_digest_pad_search_report.json
target/search_tag_kdf_labels.py
target/tag_kdf_label_search_report.json
```

这些负结果说明 tag 不是已枚举的标准 AEAD/HMAC/CMAC 简单组合；不能用猜测值补实现。
`mac_tag()` 继续 fail-closed。

## 下一步

优先从现有离线 VM 资产恢复 tag 的真实数据流，而不是继续无边界盲枚举：

1. 定位 nonce 后阶段的认证状态写入/16-byte raw tag 形成点；
2. 利用现有 builder/context/trace 快照识别 tag 源缓冲区；
3. 对候选算法先在 7 组 verify set 验证，再扩展全部本地向量；
4. tag 闭合后实现完整 envelope。
