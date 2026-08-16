'use strict';

// VM 加密函数执行跟踪 (方案 2)
// 目标: 识别 0x180324610 -> VM 0x181523001 内部实际执行的原语
// 策略: onEnter 后 Stalker 跟踪当前线程, 统计 mnemonic 分布 + 唯一指令地址,
//       用于在离线侧反汇编分析 (查表/ARX/AES 轮函数特征)

const MODULE_NAME = 'MaxHook.dll';
const ENCRYPT_RVA = 0x324610;

let installed = false;
let traceActive = false;
let traceSeq = 0;

function emit(kind, fields, bytes) {
  const payload = Object.assign({ kind, thread_id: Process.getCurrentThreadId() }, fields || {});
  if (bytes !== null && bytes !== undefined) send(payload, bytes);
  else send(payload);
}

function safePointer(p) { try { return p.toString(); } catch (_) { return '<unavailable>'; } }

function install(module) {
  if (installed) return;
  installed = true;
  const address = module.base.add(ENCRYPT_RVA);
  emit('vm_trace_hook_installed', {
    module: module.name, module_base: module.base.toString(),
    encrypt_address: address.toString(), encrypt_rva: '0x' + ENCRYPT_RVA.toString(16)
  });

  Interceptor.attach(address, {
    onEnter(args) {
      this.callId = ++traceSeq;
      const tid = Process.getCurrentThreadId();
      // counts: Map<addr, count> — 执行次数是定位循环体的关键信号
      this.acc = { stats: {}, counts: new Map(), total: 0 };
      const acc = this.acc;
      const MAX_TOTAL = 3000000;
      const MAX_UNIQ = 40000;
      emit('vm_trace_begin', {
        call_id: this.callId,
        return_address: this.returnAddress.toString(),
        input32: safePointer(args[1]), input64: safePointer(args[2]),
        context: safePointer(args[3])
      });
      try {
        Stalker.follow(tid, {
          transform(iterator) {
            let insn;
            while ((insn = iterator.next()) !== null) {
              acc.total++;
              const m = insn.mnemonic;
              acc.stats[m] = (acc.stats[m] || 0) + 1;
              const a = insn.address.toString();
              const c = acc.counts.get(a);
              if (c !== undefined) acc.counts.set(a, c + 1);
              else if (acc.counts.size < MAX_UNIQ) acc.counts.set(a, 1);
              iterator.keep();
              if (acc.total >= MAX_TOTAL) {
                iterator.putCallout(() => {
                  try { Stalker.unfollow(); } catch (_) {}
                });
                break;
              }
            }
          }
        });
        traceActive = true;
      } catch (e) {
        emit('vm_trace_error', { call_id: this.callId, error: String(e) });
      }
    },
    onLeave(retval) {
      if (!this.acc) return;
      try { Stalker.unfollow(); } catch (_) {}
      traceActive = false;
      const acc = this.acc;
      const top = Object.entries(acc.stats).sort((a, b) => b[1] - a[1]).slice(0, 40);
      emit('vm_trace_summary', {
        call_id: this.callId,
        total_instructions: acc.total,
        unique_addresses: acc.counts.size,
        top_mnemonics: top.map(([m, n]) => `${m}:${n}`).join(','),
        retval: retval.toString()
      });
      // 按执行次数降序发送 "addr:count" — 高频 = 循环体核心
      const arr = Array.from(acc.counts.entries())
        .sort((a, b) => b[1] - a[1])
        .map(([a, c]) => `${a}:${c}`);
      for (let i = 0; i < arr.length; i += 512) {
        const s = arr.slice(i, i + 512).join('\n');
        const buf = Memory.allocUtf8String(s);
        emit('vm_trace_addrs', {
          call_id: this.callId, chunk: i / 512, total_chunks: Math.ceil(arr.length / 512)
        }, buf.readByteArray(s.length));
      }
    }
  });
}

function tryInstall() {
  if (installed) return;
  const module = Process.findModuleByName(MODULE_NAME);
  if (module !== null) install(module);
}

tryInstall();
if (!installed) {
  const timer = setInterval(function () {
    tryInstall();
    if (installed) clearInterval(timer);
  }, 100);
}
