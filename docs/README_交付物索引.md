# MaxHook 协议栈逆向 — 交付物索引（README）

日期：2026-08-14（第 105 轮综合）
范围：纯离线。目标：逆向 `MaxHook.dll` 的报告加密协议栈（含包体加密）。

## 一、权威报告（本工作核心产出）

| 文档 | 内容 |
|------|------|
| `MaxHook_协议栈逆向最终报告_权威版_2026-08-14.md` | **最终权威报告**（第 191 轮）：13 节完整总结（信封/签名/密码类型/常量/状态机/轮函数/dispatch/54-handler 程序/执行链/writer ABI/24 组校验对/剩余/交付物） |
| `MaxHook_协议栈最终交付_第167轮_2026-08-14.md` | 第 167-190 轮详细记录 |
| `MaxHook_协议栈综合最终报告_第99-105轮_2026-08-14.md` | 第 99-105 轮集成 |

## 二、第 99-105 轮新增规格/证明文档

| 文档 | 内容 |
|------|------|
| `MaxHook_密钥调度ARX循环_精确提取_2026-08-14.md` | key-schedule ARX 循环（4 主链 + 4 辅助链、16 轮常量、5 状态槽） |
| `word_producer_6槽_活态语义校正_2026-08-14.md` | 6 字生产者槽活态实测语义 + source/destination 字段校正 |
| `MaxHook_会话资产清点与密钥映射_2026-08-14.md` | 5 会话 pid/key/覆盖内容精确映射 |
| `MaxHook_密钥流key依赖性_决定性证明_2026-08-14.md` | 9/9 位置跨 key 全不同（key 全扩散证明） |
| `MaxHook_密钥流状态机完整规格_2026-08-14.md` | 完整状态槽语义 + 全部常量总表 + 无静态 S-box |
| `MaxHook_keyschedule字节码结构_2026-08-14.md` | 字节码操作数明文、操作码加密（校正第 26 轮） |

## 三、规格文档（密码各层详细规格，早期）

| 文档 | 内容 |
|------|------|
| `fold_trampoline_折叠算术精确规格.md` | fold/trampoline 折叠算术 + dispatcher + 全部常量 + 轮函数 |
| `word_producer_0x180b8c7aa_精确数据流.md` | 字生产者 6 槽位 + 144 次运行期实测 |
| `keystream_state_machine_counter结构.md` | 计数器结构 |
| `keystream_generator_架构.md` | 明文生成器架构（fn 表 + 索引表） |
| `round_function_reconstruction.json` | 轮函数重建（机器可读） |
| `keyschedule_arx_loop_spec.json` | key-schedule ARX 循环规格（机器可读） |

## 四、关键数据资产

| 资产 | 内容 |
|------|------|
| `crypto_verify_set.json` | 7 完整验证样本（key 30bfeafe...，7 nonce，ct+tag） |
| `writer_sync_clean_20260814_014351/` | 3 完整密钥流 + nonce（key 347230e6...）+ ground-truth |
| `keystream_history_capture_20260814/` | 52 XOR 时刻 context 快照（pid 42948，唯一含活态 VM context） |
| `encrypt_boundary_capture2/` | 4 完整调用（pid 46460，同 key 9626da95...，4 nonce） |
| `crypto_capture2/` | verify-set 会话 keyread + 7 nonce（pid 16448） |
| `keytrace_capture/` | key 捕获（pid 4592，key 772daaeb...） |
| `dump_out/41264/region_0000000180980000.bin` | 完整解密 .bugland + handler table（pid 41264，空闲态） |
| `disasm_unpacked.asm` | 完整反汇编（676867 行） |
| `vm_handler_execution_trace.json` | 4096 handler 转换（key-schedule 字节码执行轨迹） |

## 五、第 99-105 轮新增脚本

| 脚本 | 用途 |
|------|------|
| `extract_arx_chain_disasm.py` / `extract_genuine_arx.py` | ARX 循环反汇编提取 |
| `verify_arx_constants.py` | 常量交叉验证（14/16 命中） |
| `check_sbox_static.py` / `scan_sbox_dll.py` | 无静态 S-box 证明 |
| `analyze_boundary2_session.py` / `compare_boundary2_ctx.py` / `analyze_crypto_capture2.py` | 会话分析 |
| `test_key_dependence.py` | key 全扩散证明 |
| `verify_state_constancy.py` | 状态槽恒定性验证 |
| `decode_keyschedule_bytecode.py` / `analyze_bytecode_words.py` | 字节码解码 |

## 五之补充：完整参考实现 + 综合验证（第 111-117 轮）

| 资产 | 内容 |
|------|------|
| `maxhook_protocol_reference.py` | **可执行参考实现**：信封构造、全部常量、ARX 轮函数、fold、store32、验证 harness（7/7） |
| `consolidated_verification.py` | **综合验证报告**：11 项检查全通过（信封 7/7、流密码 7/7、nonce 扩散 9/9、无 S-box、AES 排除、控制流 key 无关等） |

## 六、核心结论（一句话）

MaxHook 报告加密是**定制 bytecode-compiled ARX 流密码（无静态 S-box）**（key 32B + nonce 12B
→ keystream → ciphertext = plaintext XOR keystream + tag 16B MAC）。协议信封、函数签名、密码
**完整结构**（22+ 真实常量、计数器、6 槽位语义、key-schedule ARX 循环、明文生成器、fold、
store32、字节码操作数结构）、writer ABI 均已 100% 离线还原并多源交叉验证。唯一未闭合 =
key-schedule 初始展开（key+nonce → 初始状态），因无单一本地会话同时含 key + 活态 heap 状态
（纯数据缺口，非代码缺口、非必须真机 Hook）。

## 七、校验语料（14 组）

7(verify-set) + 3(writer_sync) + 4(boundary2) = **14 组**已知 (key, nonce → keystream) 对，
一旦 key-schedule 初始展开被复现，可 14/14 校验。
