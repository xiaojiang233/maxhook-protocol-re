'use strict';

// Focused read-only trace of the proven copied-plaintext consumer.
// The ONLY Interceptor is the verified encrypt entry; .bugland sites use Stalker.

const MODULE_NAME = 'MaxHook.dll';
const ENCRYPT_RVA = 0x324610;
const LOAD_PTR_RVA = 0x9c552a;   // mov r12, [r12]
const LOAD_BYTE_RVA = 0x9c552e;  // mov r12b, [r12]
const XOR_BYTE_RVA = 0x9c5561;   // xor byte [r8], r12b
const MAX_STRING_BYTES = 32 * 1024 * 1024;
const MAX_RECORDS = 100000;
let installed = false;
let callSequence = 0;
const activeByThread = new Map();

function emit(kind, fields, bytes) {
  const payload = Object.assign({ kind, thread_id: Process.getCurrentThreadId() }, fields || {});
  if (bytes !== null && bytes !== undefined) send(payload, bytes); else send(payload);
}
function u64Number(address) {
  const value = Number(address.readU64().toString());
  if (!Number.isSafeInteger(value) || value < 0) throw new Error('unsafe uint64');
  return value;
}
function readMsvcString(objectPointer) {
  const size = u64Number(objectPointer.add(0x10));
  const capacity = u64Number(objectPointer.add(0x18));
  if (size > capacity || size > MAX_STRING_BYTES) throw new Error('invalid string');
  const data = capacity < 16 ? objectPointer : objectPointer.readPointer();
  return { object: objectPointer, data, size, capacity,
    bytes: size === 0 ? new ArrayBuffer(0) : data.readByteArray(size) };
}
function emitString(callId, phase, label, objectPointer) {
  try {
    const value = readMsvcString(objectPointer);
    emit('encrypt_string', { call_id: callId, phase, label,
      object_pointer: value.object.toString(), data_pointer: value.data.toString(),
      size: value.size, capacity: value.capacity }, value.bytes);
  } catch (error) {
    emit('encrypt_string_error', { call_id: callId, phase, label, error: String(error) });
  }
}
function emitRecords(callId, records) {
  for (let i = 0; i < records.length; i += 256) {
    const json = JSON.stringify(records.slice(i, i + 256));
    const buffer = Memory.allocUtf8String(json);
    emit('plaintext_xor_records', { call_id: callId, label: 'plaintext_xor_records',
      chunk: i / 256, total_chunks: Math.ceil(records.length / 256) },
      buffer.readByteArray(json.length));
  }
}

function install(module) {
  if (installed) return;
  installed = true;
  const encrypt = module.base.add(ENCRYPT_RVA);
  const loadPtr = module.base.add(LOAD_PTR_RVA).toString();
  const loadByte = module.base.add(LOAD_BYTE_RVA).toString();
  const xorByte = module.base.add(XOR_BYTE_RVA).toString();
  emit('plaintext_xor_installed', { module: module.name, module_base: module.base.toString(),
    encrypt: encrypt.toString(), load_ptr: loadPtr, load_byte: loadByte, xor_byte: xorByte });

  Interceptor.attach(encrypt, {
    onEnter(args) {
      this.callId = ++callSequence;
      this.traceThreadId = this.threadId;
      this.output = args[0];
      let plaintextObject = ptr(0);
      try { plaintextObject = this.context.rsp.add(0x28).readPointer(); } catch (_) {}
      this.plaintextObject = plaintextObject;
      emitString(this.callId, 'input', 'input32', args[1]);
      emitString(this.callId, 'input', 'input64', args[2]);
      emitString(this.callId, 'input', 'plaintext_json', plaintextObject);
      const state = { callId: this.callId, records: [], pending: null, dropped: 0 };
      this.state = state;
      activeByThread.set(this.traceThreadId, state);
      try {
        Stalker.follow(this.traceThreadId, { transform(iterator) {
          let instruction;
          while ((instruction = iterator.next()) !== null) {
            const address = instruction.address.toString();
            if (address === loadPtr) {
              iterator.putCallout(function (context) {
                const current = activeByThread.get(Process.getCurrentThreadId());
                if (current === undefined || current.records.length >= MAX_RECORDS) return;
                let pointerValue = null;
                try { pointerValue = context.r12.readPointer().toString(); } catch (_) {}
                current.pending = { seq: current.records.length,
                  pointer_slot: context.r12.toString(), pointer_value: pointerValue };
              });
            } else if (address === loadByte) {
              iterator.putCallout(function (context) {
                const current = activeByThread.get(Process.getCurrentThreadId());
                if (current === undefined || current.pending === null) return;
                current.pending.source = context.r12.toString();
                try { current.pending.source_byte = context.r12.readU8(); }
                catch (_) { current.pending.source_byte = null; }
              });
            } else if (address === xorByte) {
              iterator.putCallout(function (context) {
                const current = activeByThread.get(Process.getCurrentThreadId());
                if (current === undefined) return;
                if (current.records.length >= MAX_RECORDS) { current.dropped++; return; }
                const record = current.pending || { seq: current.records.length };
                current.pending = null;
                record.destination = context.r8.toString();
                record.xor_byte = context.r12.and(0xff).toInt32();
                try { record.before = context.r8.readU8(); } catch (_) { record.before = null; }
                current.records.push(record);
                current.pendingPost = record;
              });
              iterator.keep();
              iterator.putCallout(function (context) {
                const current = activeByThread.get(Process.getCurrentThreadId());
                if (current === undefined || current.pendingPost === null) return;
                const record = current.pendingPost; current.pendingPost = null;
                try { record.after = context.r8.readU8(); } catch (_) { record.after = null; }
                record.verified = record.before === null || record.after === null ? null :
                  ((record.before ^ record.xor_byte) & 0xff) === record.after;
              });
              continue;
            }
            iterator.keep();
          }
        }});
        this.tracing = true;
      } catch (error) {
        activeByThread.delete(this.traceThreadId);
        emit('plaintext_xor_error', { call_id: this.callId, error: String(error) });
      }
    },
    onLeave(retval) {
      if (this.state === undefined) return;
      if (this.tracing) { try { Stalker.unfollow(this.traceThreadId); } catch (_) {} }
      activeByThread.delete(this.traceThreadId);
      emitString(this.callId, 'output', 'kid_hex', this.output);
      emitString(this.callId, 'output', 'nonce_hex', this.output.add(0x20));
      emitString(this.callId, 'output', 'ciphertext_hex', this.output.add(0x40));
      emitString(this.callId, 'output', 'tag_hex', this.output.add(0x60));
      emit('plaintext_xor_leave', { call_id: this.callId, records: this.state.records.length,
        dropped: this.state.dropped,
        verified: this.state.records.filter(x => x.verified === true).length,
        mismatch: this.state.records.filter(x => x.verified === false).length,
        retval: retval.toString() });
      emitRecords(this.callId, this.state.records);
    }
  });
}
function tryInstall() { if (!installed) { const module = Process.findModuleByName(MODULE_NAME); if (module !== null) install(module); } }
tryInstall();
if (!installed) { const timer = setInterval(function () { tryInstall(); if (installed) clearInterval(timer); }, 100); }
