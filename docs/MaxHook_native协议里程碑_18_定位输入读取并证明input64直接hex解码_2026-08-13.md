# MaxHook Native 协议里程碑 18：定位输入读取并证明 input64 直接 hex 解码

时间：2026-08-13

## 结论

使用同步的 `encrypt_boundary_capture2` 第 2 个 session / call 4，在完全离线的 Unicorn 环境中加入精确内存访问观察后，已经证明：

1. KID 的 32 个 ASCII 字符首先由 `0x180322e30` 顺序扫描；
2. 动态 `input64` 的 64 个 ASCII 字符也先由 `0x180322e30` 顺序扫描；
3. 随后 `input64` 在 `0x1804ad4e8` / `0x1804ad566` 按偶、奇字符成对读取；
4. 新分配的 32-byte heap 缓冲区中得到的结果逐字节等于 `bytes.fromhex(input64)`。

因此，`input64` 作为会话动态值进入加密流程时的第一步不是未知 KDF，也不是哈希；它被直接从 64-char hex 解码为 32-byte 原始会话材料。后续是否还有 KDF/扩展，需要继续追踪这个 32-byte 缓冲区。

## 一、实测读取序列

### KID

```text
RIP       = 0x180322e30
offset    = 0,1,2,...,31
read size = 1 byte
```

共 32 次，无遗漏、无重复。

### input64 第一遍

```text
RIP       = 0x180322e30
offset    = 0,1,2,...,63
read size = 1 byte
```

结合 `0x180322d10–0x180322e92` 的明文代码，这是对字符范围逐项调用谓词的扫描/验证阶段；该阶段不产生 32-byte 输出。

### input64 第二遍

```text
偶数 offset: 0x1804ad4e8
奇数 offset: 0x1804ad566
顺序:        0,1,2,...,63
```

两字符经过 `0x1804ad790` 的字符到 nibble 映射后，由 `0x18001c563` 向新分配的 32-byte 缓冲逐字节写入。

## 二、hex 解码闭合

该 call 的捕获输入：

```text
input64 ASCII:
9626DA95F889109AD83C2238CA7959639CB76FDCA6569283A1E727C376CF9D40
```

离线执行得到的 32-byte heap 内容：

```text
96 26 da 95 f8 89 10 9a d8 3c 22 38 ca 79 59 63
9c b7 6f dc a6 56 92 83 a1 e7 27 c3 76 cf 9d 40
```

校验关系：

```python
heap_bytes == bytes.fromhex(input64_ascii)  # True
```

不是仅比较前缀：32/32 字节全部相等。

## 三、离线执行状态

本次用于确定性验证的运行：

```text
instruction_count = 350000
error             = null
invalid_memory    = null
```

到 350K 为止的关注访问统计：

```text
KID data read           32
input64 data read      128  (64 扫描 + 64 解码)
context object read      2
plaintext read           0
output envelope access   0
```

所以这项结果定位的是密钥材料预处理，不声称已经走到 plaintext 加密或 tag 生成。

## 四、工具与复现

`emulate_maxhook_encrypt_boundary.py` 新增：

- `watched_memory_accesses[]`：输入对象、输入数据、output envelope 的 read/write；
- `heap_writes[]`：运行期分配缓冲区的写入及所属 allocation。

验证器：

```powershell
python target\analyze_maxhook_vm_input_accesses.py `
  --emulation-json target\encrypt_vm_watched_350k.json `
  --boundary-dir target\encrypt_boundary_capture2 `
  --boundary-session 2 `
  --boundary-call 4 `
  --output target\maxhook_vm_input_accesses.json
```

输出：

```text
kid_scan=32 key_scan=64 key_decode=64 decoded=9626da95...cf9d40
```

SHA-256：

```text
analyze_maxhook_vm_input_accesses.py  b875abcb65f955089471ca2eb1d47644387f659f4f19b538137602af9bfeb6b9
maxhook_vm_input_accesses.json        ee2efe86eeb14def745426a4f7c3c442b49fa1b7eef1a6575540dc46985566b7
encrypt_vm_watched_350k.json          8318c170d559a786b6f014a3b1b18b16e54fc9f7abba8c086bdde67b89230eea
emulate_maxhook_encrypt_boundary.py   e7acdfdca6213ad97252504fa050d19593ad7c1be41a6b7780417fa7545061b4
```

## 五、下一步

当前最短路径已经从“继续盲拆 VM handler”变为追踪具体缓冲：

```text
input64 ASCII
  -> 0x1804ad4e8/0x1804ad566
  -> decoded key buffer @ 离线 0x20000100000 (32 bytes)
  -> 待定位第一位 consumer
```

下一步应监控这个 allocation 的读取，并记录读取者 RIP、VIP、rolling key 及目标输出写入。若它被复制到 VM context/另一个 state buffer，则继续给目标 buffer 传播标签；直至定位 plaintext XOR/轮函数和 tag 状态。
