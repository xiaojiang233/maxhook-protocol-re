'use strict';

// Synchronized clean-session capture: key/nonce/plaintext/envelope plus every
// 32-bit word written to the 64-byte working/keystream buffer.
// The ONLY Interceptor is the verified encrypt entry; writer observation is Stalker.

const MODULE_NAME = 'MaxHook.dll';
const ENCRYPT_RVA = 0x324610;
const WRITER_RVA = 0x41a860;
const KS_FROM_PLAINTEXT_OBJECT = 0x4f0;
const KS_SIZE = 64;
const MAX_STRING_BYTES = 32 * 1024 * 1024;
const MAX_RECORDS = 4096;
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
  if (size > capacity || size > MAX_STRING_BYTES) throw new Error('invalid std::string');
  const data = capacity < 16 ? objectPointer : objectPointer.readPointer();
  return { data, size, capacity, bytes: size === 0 ? new ArrayBuffer(0) : data.readByteArray(size) };
}
function emitString(callId, phase, label, objectPointer) {
  try {
    const value = readMsvcString(objectPointer);
    emit('writer_sync_string', { call_id: callId, phase, label,
      object_pointer: objectPointer.toString(), data_pointer: value.data.toString(),
      size: value.size, capacity: value.capacity }, value.bytes);
  } catch (error) {
    emit('writer_sync_error', { call_id: callId, stage: label, error: String(error) });
  }
}
function emitRecords(callId, records) {
  const json = JSON.stringify(records);
  const memory = Memory.allocUtf8String(json);
  emit('writer_sync_records', { call_id: callId, label: 'writer_sync_records',
    records: records.length }, memory.readByteArray(json.length));
}
function install(module) {
  if (installed) return;
  installed = true;
  const encrypt = module.base.add(ENCRYPT_RVA);
  const writer = module.base.add(WRITER_RVA).toString();
  emit('writer_sync_installed', { module: module.name, module_base: module.base.toString(),
    encrypt: encrypt.toString(), writer, buffer_from_plaintext_object: -KS_FROM_PLAINTEXT_OBJECT });

  Interceptor.attach(encrypt, {
    onEnter(args) {
      this.callId = ++callSequence;
      this.traceThreadId = this.threadId;
      this.output = args[0];
      let plaintextObject;
      try { plaintextObject = this.context.rsp.add(0x28).readPointer(); }
      catch (error) { emit('writer_sync_error', { call_id: this.callId, stage: 'plaintext_object', error: String(error) }); return; }
      emitString(this.callId, 'input', 'input32', args[1]);
      emitString(this.callId, 'input', 'input64', args[2]);
      emitString(this.callId, 'input', 'plaintext_json', plaintextObject);
      const buffer = plaintextObject.sub(KS_FROM_PLAINTEXT_OBJECT);
      const state = { callId: this.callId, buffer, end: buffer.add(KS_SIZE),
        records: [], dropped: 0, currentBlock: null, previousBlock: null };
      this.state = state;
      activeByThread.set(this.traceThreadId, state);
      emit('writer_sync_begin', { call_id: this.callId, plaintext_object: plaintextObject.toString(), buffer: buffer.toString() });
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
                current.records.push({ index: current.records.length,
                  offset: context.rcx.sub(current.buffer).toInt32(),
                  value: context.rdx.and(0xffffffff).toString(),
                  caller_block: current.previousBlock, writer_block: current.currentBlock });
              });
            }
            iterator.keep();
          }
        }});
        this.tracing = true;
      } catch (error) {
        activeByThread.delete(this.traceThreadId);
        emit('writer_sync_error', { call_id: this.callId, stage: 'stalker', error: String(error) });
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
      emit('writer_sync_leave', { call_id: this.callId, records: this.state.records.length,
        dropped: this.state.dropped, retval: retval.toString() });
      emitRecords(this.callId, this.state.records);
    }
  });
}
function tryInstall() { if (!installed) { const module = Process.findModuleByName(MODULE_NAME); if (module !== null) install(module); } }
tryInstall();
if (!installed) { const timer = setInterval(function () { tryInstall(); if (installed) clearInterval(timer); }, 100); }
