# MaxHook 堆内 AES S-box 发现与证伪（第 109 轮）

日期：2026-08-14
范围：纯离线。

## 一、发现：dump 堆含 256 字节置换表（S-box）

`scan_dump_heap_sbox.py` 扫描 dump（pid 41264）6104 个 heap region，发现：

1. **`region_000001efaae7f000.bin`** 含**标准 AES S-box**（`637c777bf26b6fc5...` = AES S-box）
   及 AES 逆 S-box（`52096ad5...`），偏移 0x10a10/0x11b10；
2. **`region_000001efaad0b000.bin`** 含 4 个**非 AES 的高熵置换表**（`70822cec...`/`e00558d9...`/
   `38411676...`）；
3. **`region_000001efefd50000.bin`** 的"257 个置换"是**滑动恒等序列假阳性**（`000102...`/
   `010203...`/`020304...`，非真 S-box）。

## 二、AES 假设证伪（关键负结果）

因 16B tag 与 12B nonce 恰是 AES-GCM 经典布局，且堆内发现 AES S-box，测试 AES 假设：

`test_aes_gcm.py`（`cryptography` 库）对 writer_sync 真实 key+nonce + ground-truth：

| 假设 | 结果 | word0 |
|------|------|-------|
| AES-256-CTR (nonce‖counter=0) | ✗ | 0x3f0f28e9 |
| AES-256-CTR (counter=1 = GCM keystream) | ✗ | 0xf6e14658 |
| AES-256-ECB(nonce‖0) | ✗ | 0x3f0f28e9 |
| AES-256-CBC(nonce IV) | ✗ | 0x3f0f28e9 |
| **ground-truth** | — | **0xdfa1e432** |

全部不匹配。**结论**：堆内 AES S-box 来自进程内**其他密码库**（Java 游戏进程含大量 crypto 库），
**非 MaxHook 密码**。MaxHook 密码仍是**定制 bytecode-compiled ARX 流密码（无 S-box）**。

## 三、对第 103 轮结论的确认与细化

第 103 轮"无静态 S-box"结论**正确**：DLL 可写段 0 个置换表。堆内置换表是 (a) 进程其他库的
AES S-box，(b) 假阳性滑动恒等序列。MaxHook 密码本身无 S-box，是纯 ARX。

## 四、第 110 轮补充：4 个非 AES 置换表的深度检查

`deep_examine_sbox.py` 对 `region_000001efaad0b000.bin` 的 4 个置换表（偏移 0x8af80/0x8b080/
0x8b180/0x8b280，间距 0x100）深度检查：

| 表 | 首 16 字节 | 性质 |
|----|-----------|------|
| 0 | `70822cecb327c0e5e4855735ea0cae41` | 置换，非对合（sbox[sbox[x]]≠x） |
| 1 | `e00558d9674e81cbc90bae6ad5185d82` | 置换，非对合 |
| 2 | `38411676d99360f272c2ab9a750657a0` | 置换，非对合 |
| 3 | `702cb3c0e457eaae236b45a5ed4f1d92` | 置换，非对合 |

- 均**非 AES**、非恒等、非对合；4 表间**无简单 XOR 常量/加法移位关系**（t0^t1 非同字节）；
- 是 4 个真正独立的高熵置换表，**极可能来自进程内其他密码库**（Java 游戏进程加载大量 crypto 库），
  而非 MaxHook 的 ARX 密码（其 fold 是 `state ^= (const ^ state) - state`，无查表 S-box）。

**结论**：第 109-110 轮彻底排查了 dump 堆内所有 256 字节置换表——AES S-box（其他库）+
4 个未知置换表（其他库）+ 假阳性。MaxHook 密码**确无 S-box**，是纯 ARX（第 103 轮结论再次确认）。

## 五、交付物

| 资产 | 路径 |
|------|------|
| 堆 S-box 扫描 | `scan_dump_heap_sbox.py` |
| 堆 S-box 检查 | `examine_heap_sbox.py` |
| 深查 4 置换表 | `deep_examine_sbox.py` |
| AES 假设测试 | `test_aes_ctr.py`、`test_aes_gcm.py` |
| 本报告 | `MaxHook_堆内AES_Sbox发现与证伪_2026-08-14.md` |
