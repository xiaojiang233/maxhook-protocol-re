'use strict';

// Stalker + putCallout: 在 0x180322e30 (movzx edx,[rdi]) 每次执行时记录 rdi + [rdi]
// 不修改原始代码字节, 不触发 Themida 反篡改

const MODULE_NAME = 'MaxHook.dll';
const ENCRYPT_RVA = 0x324610;
const KEYREAD_RVA = 0x322e30;
let installed = false;
let callSeq = 0;

function emit(kind, fields, bytes) {
  const payload = Object.assign({ kind, thread_id: Process.getCurrentThreadId() }, fields || {});
  if (bytes !== null && bytes !== undefined) send(payload, bytes);
  else send(payload);
}

function install(module) {
  if (installed) return;
  installed = true;
  const encryptAddr = module.base.add(ENCRYPT_RVA);
  const keyReadAddr = module.base.add(KEYREAD_RVA);
  emit('keyread_installed', { module: module.name, encrypt: encryptAddr.toString(), keyread: keyReadAddr.toString() });

  Interceptor.attach(encryptAddr, {
    onEnter(args) {
      this.callId = ++callSeq;
      this.records = [];
      this.counter = 0;
      const rec = this.records;
      emit('keyread_begin', { call_id: this.callId, return_address: this.returnAddress.toString() });
      try {
        Stalker.follow(this.threadId, {
          transform(iterator) {
            let insn;
            while ((insn = iterator.next()) !== null) {
              if (insn.address.equals(keyReadAddr)) {
                const records = rec;
                iterator.putCallout(function (context) {
                  if (records.length >= 400) return;
                  let b = -1;
                  try { b = context.rdi.readU8(); } catch (_) {}
                  records.push({
                    rdi: context.rdi.toString(),
                    byte: b
                  });
                });
              }
              iterator.keep();
            }
          }
        });
        this.tracing = true;
      } catch (e) {
        emit('keyread_error', { call_id: this.callId, error: String(e) });
      }
    },
    onLeave(retval) {
      if (!this.tracing) return;
      try { Stalker.unfollow(); } catch (_) {}
      // 汇总: rdi 指针序列 + 读取字节
      const rec = this.records;
      const rdPtrs = rec.map(function (r) { return r.rdi; });
      const bytes = rec.map(function (r) { return r.byte < 0 ? '?' : r.byte.toString(16).padStart(2, '0'); });
      emit('keyread_summary', {
        call_id: this.callId,
        total_reads: rec.length,
        byte_stream: bytes.join(''),
        ptr_sequence: rdPtrs.slice(0, 40).join(','),
        ptr_count: rdPtrs.length,
        unique_ptrs: Array.from(new Set(rdPtrs)).length
      });
    }
  });
}

function tryInstall() {
  if (installed) return;
  const m = Process.findModuleByName(MODULE_NAME);
  if (m !== null) install(m);
}
tryInstall();
if (!installed) {
  const t = setInterval(function () { tryInstall(); if (installed) clearInterval(t); }, 100);
}
