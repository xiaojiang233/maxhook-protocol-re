'use strict';

// Safe plaintext copy-chain tracer.
// The ONLY Interceptor is the previously verified encrypt entry. Every internal
// observation (including UCRT memcpy) uses Stalker putCallout.

const MODULE_NAME = 'MaxHook.dll';
const ENCRYPT_RVA = 0x324610;
const MEMCPY_ENTRY_RVA = 0x5d0b10;
const MEMCPY_RETURN_RVAS = [0x5d0b30, 0x5d0b42, 0x5d0b53, 0x5d0b65, 0x5d0b7f,
  0x5d0b92, 0x5d0ba5, 0x5d0bb8, 0x5d0bcb, 0x5d0bde, 0x5d0bf2, 0x5d0bff,
  0x5d0c0e, 0x5d0c1c, 0x5d0c23, 0x5d0c29, 0x5d0c2e, 0x5d0c4c,
  0x5d0e0d, 0x5d0f40, 0x5d1096, 0x5d117c];
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
  if (size > capacity || size > MAX_STRING_BYTES) throw new Error('invalid std::string');
  return { data: capacity < 16 ? objectPointer : objectPointer.readPointer(), size };
}
function stopMonitor(state) {
  if (!state.monitoring) return;
  try { MemoryAccessMonitor.disable(); } catch (_) {}
  state.monitoring = false;
}
function monitorCopiedBuffer(state) {
  stopMonitor(state);
  const base = state.copyDestination;
  const size = state.plaintextSize;
  try {
    MemoryAccessMonitor.enable([{ base, size }], { onAccess(details) {
      const current = activeByThread.get(Process.getCurrentThreadId());
      if (current === undefined) return;
      const item = { call_id: current.callId, operation: details.operation,
        from: details.from.toString(), address: details.address.toString(),
        offset: details.address.sub(base).toString(), copy_destination: base.toString(), size };
      current.downstream.push(item);
      emit('plaintext_copy_access', item);
    }});
    state.monitoring = true;
    emit('plaintext_copy_monitor', { call_id: state.callId, base: base.toString(), size });
  } catch (error) {
    emit('plaintext_chain_error', { call_id: state.callId, stage: 'monitor_copy', error: String(error) });
  }
}

function install(module) {
  if (installed) return;
  installed = true;
  const encrypt = module.base.add(ENCRYPT_RVA);
  const memcpyEntry = module.base.add(MEMCPY_ENTRY_RVA).toString();
  const memcpyReturns = new Set(MEMCPY_RETURN_RVAS.map(rva => module.base.add(rva).toString()));
  emit('plaintext_chain_stalker_installed', { module: module.name,
    module_base: module.base.toString(), encrypt: encrypt.toString(),
    memcpy_entry: memcpyEntry, memcpy_returns: Array.from(memcpyReturns) });

  Interceptor.attach(encrypt, {
    onEnter(args) {
      this.callId = ++callSequence;
      this.traceThreadId = this.threadId;
      let plaintextObject = ptr(0), plaintext;
      try {
        plaintextObject = this.context.rsp.add(0x28).readPointer();
        plaintext = readMsvcString(plaintextObject);
      } catch (error) {
        emit('plaintext_chain_error', { call_id: this.callId, stage: 'read_plaintext', error: String(error) });
        return;
      }
      const state = { callId: this.callId, plaintextData: plaintext.data,
        plaintextSize: plaintext.size, copyDestination: null, inMatchedMemcpy: false,
        monitoring: false, downstream: [] };
      this.state = state;
      activeByThread.set(this.traceThreadId, state);
      emit('plaintext_chain_begin', { call_id: this.callId,
        plaintext_object: plaintextObject.toString(), plaintext_data: plaintext.data.toString(),
        plaintext_size: plaintext.size });
      try {
        Stalker.follow(this.traceThreadId, { transform(iterator) {
          let instruction;
          while ((instruction = iterator.next()) !== null) {
            const address = instruction.address.toString();
            if (address === memcpyEntry) {
              iterator.putCallout(function (context) {
                const current = activeByThread.get(Process.getCurrentThreadId());
                if (current === undefined) return;
                let length = null;
                try { length = Number(context.r8.toString()); } catch (_) {}
                if (!context.rdx.equals(current.plaintextData) || length !== current.plaintextSize) return;
                current.copyDestination = context.rcx;
                current.inMatchedMemcpy = true;
                emit('plaintext_copy_enter', { call_id: current.callId,
                  source: context.rdx.toString(), destination: context.rcx.toString(), size: length });
              });
            } else if (memcpyReturns.has(address)) {
              iterator.putCallout(function (_context) {
                const current = activeByThread.get(Process.getCurrentThreadId());
                if (current === undefined || !current.inMatchedMemcpy || current.copyDestination === null) return;
                current.inMatchedMemcpy = false;
                emit('plaintext_copy_complete', { call_id: current.callId,
                  destination: current.copyDestination.toString(), size: current.plaintextSize });
                monitorCopiedBuffer(current);
              });
            }
            iterator.keep();
          }
        }});
        this.tracing = true;
      } catch (error) {
        activeByThread.delete(this.traceThreadId);
        emit('plaintext_chain_error', { call_id: this.callId, stage: 'stalker_follow', error: String(error) });
      }
    },
    onLeave(retval) {
      if (this.state === undefined) return;
      if (this.tracing) { try { Stalker.unfollow(this.traceThreadId); } catch (_) {} }
      stopMonitor(this.state);
      activeByThread.delete(this.traceThreadId);
      emit('plaintext_chain_leave', { call_id: this.callId,
        copy_destination: this.state.copyDestination === null ? null : this.state.copyDestination.toString(),
        downstream: this.state.downstream, retval: retval.toString() });
    }
  });
}
function tryInstall() { if (!installed) { const module = Process.findModuleByName(MODULE_NAME); if (module !== null) install(module); } }
tryInstall();
if (!installed) { const timer = setInterval(function () { tryInstall(); if (installed) clearInterval(timer); }, 100); }
