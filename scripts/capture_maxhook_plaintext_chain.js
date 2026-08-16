'use strict';

// Follow plaintext through the CRT memcpy copy, then identify the first reader
// of the copied buffer. Interceptors are restricted to plaintext .text code.

const MODULE_NAME = 'MaxHook.dll';
const ENCRYPT_RVA = 0x324610;
const MEMCPY_RVA = 0x5d0c30;
const MAX_STRING_BYTES = 32 * 1024 * 1024;
let installed = false;
let callSequence = 0;
const activeByThread = new Map();

function emit(kind, fields) {
  send(Object.assign({ kind, thread_id: Process.getCurrentThreadId() }, fields || {}));
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
  return { data: capacity < 16 ? objectPointer : objectPointer.readPointer(), size, capacity };
}
function stopMonitor(state) {
  if (!state.monitoring) return;
  try { MemoryAccessMonitor.disable(); } catch (_) {}
  state.monitoring = false;
}
function monitorRange(state, label, base, size) {
  stopMonitor(state);
  state.monitorLabel = label;
  state.monitorBase = base;
  state.monitorSize = size;
  try {
    MemoryAccessMonitor.enable([{ base, size }], { onAccess(details) {
      const current = activeByThread.get(Process.getCurrentThreadId());
      if (current === undefined) return;
      const event = {
        call_id: current.callId,
        label: current.monitorLabel,
        operation: details.operation,
        from: details.from.toString(),
        address: details.address.toString(),
        offset: details.address.sub(current.monitorBase).toString()
      };
      current.accesses.push(event);
      emit('plaintext_chain_access', event);
    }});
    state.monitoring = true;
    emit('plaintext_chain_monitor', { call_id: state.callId, label,
      base: base.toString(), size });
  } catch (error) {
    emit('plaintext_chain_error', { call_id: state.callId, stage: label, error: String(error) });
  }
}

function install(module) {
  if (installed) return;
  installed = true;
  const encrypt = module.base.add(ENCRYPT_RVA);
  const memcpy = module.base.add(MEMCPY_RVA);
  emit('plaintext_chain_installed', { module: module.name, module_base: module.base.toString(),
    encrypt: encrypt.toString(), memcpy: memcpy.toString() });

  Interceptor.attach(memcpy, {
    onEnter(args) {
      const state = activeByThread.get(this.threadId);
      if (state === undefined) return;
      const destination = args[0], source = args[1];
      let size = null;
      try { size = Number(args[2].toString()); } catch (_) {}
      if (!source.equals(state.plaintextData) || size !== state.plaintextSize) return;
      this.matched = true;
      this.state = state;
      this.destination = destination;
      state.copyDestination = destination;
      stopMonitor(state);
      emit('plaintext_copy_enter', { call_id: state.callId, source: source.toString(),
        destination: destination.toString(), size });
    },
    onLeave(retval) {
      if (!this.matched) return;
      emit('plaintext_copy_leave', { call_id: this.state.callId,
        destination: this.destination.toString(), retval: retval.toString() });
      monitorRange(this.state, 'plaintext_copy', this.destination, this.state.plaintextSize);
    }
  });

  Interceptor.attach(encrypt, {
    onEnter(args) {
      this.callId = ++callSequence;
      this.traceThreadId = this.threadId;
      let plaintextObject = ptr(0), plaintext;
      try { plaintextObject = this.context.rsp.add(0x28).readPointer();
        plaintext = readMsvcString(plaintextObject); }
      catch (error) { emit('plaintext_chain_error', { call_id: this.callId,
        stage: 'read_plaintext', error: String(error) }); return; }
      const state = { callId: this.callId, plaintextData: plaintext.data,
        plaintextSize: plaintext.size, copyDestination: null, accesses: [], monitoring: false };
      this.state = state;
      activeByThread.set(this.traceThreadId, state);
      emit('plaintext_chain_begin', { call_id: this.callId,
        plaintext_object: plaintextObject.toString(), plaintext_data: plaintext.data.toString(),
        plaintext_size: plaintext.size });
      monitorRange(state, 'plaintext_original', plaintext.data, plaintext.size);
    },
    onLeave(retval) {
      if (this.state === undefined) return;
      stopMonitor(this.state);
      activeByThread.delete(this.traceThreadId);
      emit('plaintext_chain_leave', { call_id: this.callId,
        copy_destination: this.state.copyDestination === null ? null : this.state.copyDestination.toString(),
        accesses: this.state.accesses, retval: retval.toString() });
    }
  });
}
function tryInstall() { if (!installed) { const module = Process.findModuleByName(MODULE_NAME); if (module !== null) install(module); } }
tryInstall();
if (!installed) { const timer = setInterval(function () { tryInstall(); if (installed) clearInterval(timer); }, 100); }
