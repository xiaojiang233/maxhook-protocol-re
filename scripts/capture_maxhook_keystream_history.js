'use strict';

// Read-only execution history before each 64-byte plaintext XOR block.
// The ONLY Interceptor is the verified encrypt entry; all VM observations use Stalker.

const MODULE_NAME = 'MaxHook.dll';
const ENCRYPT_RVA = 0x324610;
const XOR_BYTE_RVA = 0x9c5561;
const VM_CONTEXT_RVA = 0x98c884;
const HISTORY_SIZE = 1024;
const MAX_SNAPSHOTS = 24;
let installed = false;
let callSequence = 0;
const activeByThread = new Map();

function emit(kind, fields, bytes) {
  const payload = Object.assign({ kind, thread_id: Process.getCurrentThreadId() }, fields || {});
  if (bytes !== null && bytes !== undefined) send(payload, bytes); else send(payload);
}
function pushRing(state, address) {
  state.history[state.historyHead] = address;
  state.historyHead = (state.historyHead + 1) % HISTORY_SIZE;
  if (state.historyCount < HISTORY_SIZE) state.historyCount++;
}
function readRing(state) {
  if (state.historyCount < HISTORY_SIZE) return state.history.slice(0, state.historyCount);
  return state.history.slice(state.historyHead).concat(state.history.slice(0, state.historyHead));
}
function emitSnapshots(callId, snapshots) {
  for (let i = 0; i < snapshots.length; i++) {
    const json = JSON.stringify(snapshots[i]);
    const buffer = Memory.allocUtf8String(json);
    emit('keystream_history_snapshot', { call_id: callId, label: 'keystream_history_snapshot',
      snapshot: i, total_snapshots: snapshots.length }, buffer.readByteArray(json.length));
  }
}
function install(module) {
  if (installed) return;
  installed = true;
  const encrypt = module.base.add(ENCRYPT_RVA);
  const xorByte = module.base.add(XOR_BYTE_RVA).toString();
  const vmContext = module.base.add(VM_CONTEXT_RVA);
  emit('keystream_history_installed', { module: module.name, module_base: module.base.toString(),
    encrypt: encrypt.toString(), xor_byte: xorByte, history_size: HISTORY_SIZE });

  Interceptor.attach(encrypt, {
    onEnter(args) {
      this.callId = ++callSequence;
      this.traceThreadId = this.threadId;
      const state = { callId: this.callId, history: new Array(HISTORY_SIZE), historyHead: 0,
        historyCount: 0, snapshots: [], xorCount: 0, currentSource: null };
      this.state = state;
      activeByThread.set(this.traceThreadId, state);
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
                if (current !== undefined) pushRing(current, blockAddress);
              });
            }
            if (address === xorByte) {
              iterator.putCallout(function (context) {
                const current = activeByThread.get(Process.getCurrentThreadId());
                if (current === undefined) return;
                const source = context.r12.toString();
                current.currentSource = source;
                const index = current.xorCount++;
                if ((index & 63) !== 0 || current.snapshots.length >= MAX_SNAPSHOTS) return;
                let contextBytes = null;
                try {
                  const raw = vmContext.readByteArray(0x300);
                  contextBytes = Array.from(new Uint8Array(raw), x => x.toString(16).padStart(2, '0')).join('');
                } catch (_) {}
                current.snapshots.push({ xor_index: index, source, destination: context.r8.toString(),
                  keystream_byte: (() => { try { return context.r8.readU8(); } catch (_) { return null; } })(),
                  history: readRing(current), context_hex: contextBytes });
              });
            }
            iterator.keep();
          }
        }});
        this.tracing = true;
      } catch (error) {
        activeByThread.delete(this.traceThreadId);
        emit('keystream_history_error', { call_id: this.callId, error: String(error) });
      }
    },
    onLeave(retval) {
      if (this.state === undefined) return;
      if (this.tracing) { try { Stalker.unfollow(this.traceThreadId); } catch (_) {} }
      activeByThread.delete(this.traceThreadId);
      emit('keystream_history_leave', { call_id: this.callId, xor_hits: this.state.xorCount,
        snapshots: this.state.snapshots.length, retval: retval.toString() });
      emitSnapshots(this.callId, this.state.snapshots);
    }
  });
}
function tryInstall() { if (!installed) { const module = Process.findModuleByName(MODULE_NAME); if (module !== null) install(module); } }
tryInstall();
if (!installed) { const timer = setInterval(function () { tryInstall(); if (installed) clearInterval(timer); }, 100); }
