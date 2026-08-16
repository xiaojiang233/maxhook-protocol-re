'use strict';

// Identify every caller of the proven 4-byte keystream writer.
// The ONLY Interceptor is the verified encrypt entry; writer observation uses Stalker.

const MODULE_NAME = 'MaxHook.dll';
const ENCRYPT_RVA = 0x324610;
const WRITER_RVA = 0x41a860;
const KS_FROM_PLAINTEXT_OBJECT = 0x4f0;
const KS_SIZE = 64;
const MAX_RECORDS = 4096;
let installed = false;
let callSequence = 0;
const activeByThread = new Map();

function emit(kind, fields, bytes) {
  const payload = Object.assign({ kind, thread_id: Process.getCurrentThreadId() }, fields || {});
  if (bytes !== null && bytes !== undefined) send(payload, bytes); else send(payload);
}
function emitRecords(callId, records) {
  const json = JSON.stringify(records);
  const memory = Memory.allocUtf8String(json);
  emit('writer_call_records', { call_id: callId, label: 'writer_call_records',
    records: records.length }, memory.readByteArray(json.length));
}
function install(module) {
  if (installed) return;
  installed = true;
  const encrypt = module.base.add(ENCRYPT_RVA);
  const writer = module.base.add(WRITER_RVA).toString();
  emit('writer_calls_installed', { module: module.name, module_base: module.base.toString(),
    encrypt: encrypt.toString(), writer, buffer_from_plaintext_object: -KS_FROM_PLAINTEXT_OBJECT });

  Interceptor.attach(encrypt, {
    onEnter(args) {
      this.callId = ++callSequence;
      this.traceThreadId = this.threadId;
      let plaintextObject;
      try { plaintextObject = this.context.rsp.add(0x28).readPointer(); }
      catch (error) { emit('writer_calls_error', { call_id: this.callId, error: String(error) }); return; }
      const buffer = plaintextObject.sub(KS_FROM_PLAINTEXT_OBJECT);
      const end = buffer.add(KS_SIZE);
      const state = { callId: this.callId, buffer, end, records: [], dropped: 0,
        currentBlock: null, previousBlock: null };
      this.state = state;
      activeByThread.set(this.traceThreadId, state);
      emit('writer_calls_begin', { call_id: this.callId, plaintext_object: plaintextObject.toString(),
        buffer: buffer.toString() });
      try {
        Stalker.follow(this.traceThreadId, { transform(iterator) {
          let instruction;
          let first = true;
          while ((instruction = iterator.next()) !== null) {
            const address = instruction.address.toString();
            if (first) {
              first = false;
              const blockAddress = address;
              iterator.putCallout(function (_context) {
                const current = activeByThread.get(Process.getCurrentThreadId());
                if (current === undefined) return;
                current.previousBlock = current.currentBlock;
                current.currentBlock = blockAddress;
              });
            }
            if (address === writer) {
              iterator.putCallout(function (context) {
                const current = activeByThread.get(Process.getCurrentThreadId());
                if (current === undefined) return;
                if (context.rcx.compare(current.buffer) < 0 || context.rcx.compare(current.end) >= 0) return;
                if (current.records.length >= MAX_RECORDS) { current.dropped++; return; }
                let returnAddress = null;
                try { returnAddress = context.rsp.readPointer().toString(); } catch (_) {}
                current.records.push({ index: current.records.length,
                  destination: context.rcx.toString(), offset: context.rcx.sub(current.buffer).toInt32(),
                  value: context.rdx.and(0xffffffff).toString(), return_address: returnAddress,
                  caller_block: current.previousBlock, writer_block: current.currentBlock,
                  rsp: context.rsp.toString() });
              });
            }
            iterator.keep();
          }
        }});
        this.tracing = true;
      } catch (error) {
        activeByThread.delete(this.traceThreadId);
        emit('writer_calls_error', { call_id: this.callId, error: String(error) });
      }
    },
    onLeave(retval) {
      if (this.state === undefined) return;
      if (this.tracing) { try { Stalker.unfollow(this.traceThreadId); } catch (_) {} }
      activeByThread.delete(this.traceThreadId);
      emit('writer_calls_leave', { call_id: this.callId, records: this.state.records.length,
        dropped: this.state.dropped, retval: retval.toString() });
      emitRecords(this.callId, this.state.records);
    }
  });
}
function tryInstall() {
  if (!installed) { const module = Process.findModuleByName(MODULE_NAME); if (module !== null) install(module); }
}
tryInstall();
if (!installed) { const timer = setInterval(function () { tryInstall(); if (installed) clearInterval(timer); }, 100); }
