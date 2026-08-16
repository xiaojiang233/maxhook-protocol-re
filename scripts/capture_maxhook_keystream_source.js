'use strict';

// Trace the final keystream-byte load/store proven by slot-change capture.
// The ONLY Interceptor is the verified encrypt entry; VM sites use Stalker.

const MODULE_NAME = 'MaxHook.dll';
const ENCRYPT_RVA = 0x324610;
const LOAD_RVA = 0xaa5bba;   // mov al, byte ptr [rax]
const STORE_RVA = 0xaa5bce;  // mov dword ptr [rbx], r10d
const XOR_RVA = 0x9c5561;    // xor byte ptr [r8], r12b
const MAX_RECORDS = 100000;
let installed = false;
let callSequence = 0;
const activeByThread = new Map();

function emit(kind, fields, bytes) {
  const payload = Object.assign({ kind, thread_id: Process.getCurrentThreadId() }, fields || {});
  if (bytes !== undefined && bytes !== null) send(payload, bytes); else send(payload);
}
function flushRecords(callId, records) {
  for (let i = 0; i < records.length; i += 256) {
    const json = JSON.stringify(records.slice(i, i + 256));
    const memory = Memory.allocUtf8String(json);
    emit('keystream_source_records', { call_id: callId, label: 'keystream_source_records',
      chunk: i / 256, total_chunks: Math.ceil(records.length / 256) },
      memory.readByteArray(json.length));
  }
}
function install(module) {
  if (installed) return;
  installed = true;
  const encrypt = module.base.add(ENCRYPT_RVA);
  const load = module.base.add(LOAD_RVA).toString();
  const store = module.base.add(STORE_RVA).toString();
  const xor = module.base.add(XOR_RVA).toString();
  emit('keystream_source_installed', { module: module.name, module_base: module.base.toString(),
    encrypt: encrypt.toString(), load, store, xor });

  Interceptor.attach(encrypt, {
    onEnter(args) {
      this.callId = ++callSequence;
      this.traceThreadId = this.threadId;
      const state = { callId: this.callId, pending: [], records: [], xorIndex: 0, dropped: 0 };
      this.state = state;
      activeByThread.set(this.traceThreadId, state);
      try {
        Stalker.follow(this.traceThreadId, { transform(iterator) {
          let instruction;
          while ((instruction = iterator.next()) !== null) {
            const address = instruction.address.toString();
            if (address === load) {
              iterator.putCallout(function (context) {
                const current = activeByThread.get(Process.getCurrentThreadId());
                if (current === undefined || current.records.length >= MAX_RECORDS) return;
                const record = { source: context.rax.toString() };
                try { record.source_byte = context.rax.readU8(); } catch (_) { record.source_byte = null; }
                current.pending.push(record);
              });
            } else if (address === store) {
              iterator.putCallout(function (context) {
                const current = activeByThread.get(Process.getCurrentThreadId());
                if (current === undefined || current.pending.length === 0) return;
                const record = current.pending[current.pending.length - 1];
                record.destination = context.rbx.toString();
                record.store_value = context.r10.and(0xffffffff).toString();
                try { record.destination_before = context.rbx.readU32(); } catch (_) { record.destination_before = null; }
                current.pending.splice(current.pending.length - 1, 1);
                current.records.push(record);
                current.pendingPost = record;
              });
              iterator.keep();
              iterator.putCallout(function (context) {
                const current = activeByThread.get(Process.getCurrentThreadId());
                if (current === undefined || current.pendingPost === null) return;
                try { current.pendingPost.destination_after = context.rbx.readU32(); } catch (_) {
                  current.pendingPost.destination_after = null;
                }
                current.pendingPost = null;
              });
              continue;
            } else if (address === xor) {
              iterator.putCallout(function (context) {
                const current = activeByThread.get(Process.getCurrentThreadId());
                if (current === undefined) return;
                const index = current.xorIndex++;
                for (let i = current.records.length - 1; i >= 0; i--) {
                  const record = current.records[i];
                  if (record.xor_index !== undefined) continue;
                  if (context.r8.equals(ptr(record.destination))) {
                    record.xor_index = index;
                    record.plaintext_byte = context.r12.and(0xff).toInt32();
                    try { record.keystream_byte = context.r8.readU8(); } catch (_) { record.keystream_byte = null; }
                    break;
                  }
                }
              });
            }
            iterator.keep();
          }
        }});
        this.tracing = true;
      } catch (error) {
        activeByThread.delete(this.traceThreadId);
        emit('keystream_source_error', { call_id: this.callId, error: String(error) });
      }
    },
    onLeave(retval) {
      if (this.state === undefined) return;
      if (this.tracing) { try { Stalker.unfollow(this.traceThreadId); } catch (_) {} }
      activeByThread.delete(this.traceThreadId);
      const matched = this.state.records.filter(r => r.xor_index !== undefined).length;
      emit('keystream_source_leave', { call_id: this.callId, loads_stores: this.state.records.length,
        xor_hits: this.state.xorIndex, matched, dropped: this.state.dropped, retval: retval.toString() });
      flushRecords(this.callId, this.state.records);
    }
  });
}
function tryInstall() {
  if (!installed) { const module = Process.findModuleByName(MODULE_NAME); if (module !== null) install(module); }
}
tryInstall();
if (!installed) { const timer = setInterval(function () { tryInstall(); if (installed) clearInterval(timer); }, 100); }
