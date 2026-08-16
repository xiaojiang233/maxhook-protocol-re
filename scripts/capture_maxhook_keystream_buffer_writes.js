'use strict';

// Find original basic blocks that write the 64-byte keystream buffer.
// The ONLY Interceptor is the verified encrypt entry; VM observation uses Stalker.

const MODULE_NAME = 'MaxHook.dll';
const ENCRYPT_RVA = 0x324610;
// The buffer is stack-frame local and changes after every game restart.
// It is 0x4f0 bytes before the plaintext std::string object at this entry.
const KS_FROM_PLAINTEXT_OBJECT = 0x4f0;
const KS_SIZE = 64;
const LOAD_RVA = 0xaa5bba;
const RING_SIZE = 512;
const MAX_SNAPSHOTS = 64;
let installed = false;
let callSequence = 0;
const activeByThread = new Map();

function emit(kind, fields, bytes) {
  const payload = Object.assign({ kind, thread_id: Process.getCurrentThreadId() }, fields || {});
  if (bytes !== null && bytes !== undefined) send(payload, bytes); else send(payload);
}
function pushRing(state, entry) {
  state.ring[state.head] = entry;
  state.head = (state.head + 1) % RING_SIZE;
  if (state.count < RING_SIZE) state.count++;
}
function readRing(state) {
  if (state.count < RING_SIZE) return state.ring.slice(0, state.count);
  return state.ring.slice(state.head).concat(state.ring.slice(0, state.head));
}
function snapshotBytes(buffer) {
  try { return Array.from(new Uint8Array(buffer.readByteArray(KS_SIZE))); } catch (_) { return null; }
}
function emitSnapshots(callId, snapshots) {
  for (let i = 0; i < snapshots.length; i++) {
    const json = JSON.stringify(snapshots[i]);
    const memory = Memory.allocUtf8String(json);
    emit('keystream_buffer_snapshot', { call_id: callId, label: 'keystream_buffer_snapshot',
      snapshot: i, total_snapshots: snapshots.length }, memory.readByteArray(json.length));
  }
}
function install(module) {
  if (installed) return;
  installed = true;
  const encrypt = module.base.add(ENCRYPT_RVA);
  const load = module.base.add(LOAD_RVA).toString();
  emit('keystream_buffer_writes_installed', { module: module.name, module_base: module.base.toString(),
    encrypt: encrypt.toString(), buffer_from_plaintext_object: -KS_FROM_PLAINTEXT_OBJECT,
    size: KS_SIZE, load });

  Interceptor.attach(encrypt, {
    onEnter(args) {
      this.callId = ++callSequence;
      this.traceThreadId = this.threadId;
      let plaintextObject;
      try { plaintextObject = this.context.rsp.add(0x28).readPointer(); }
      catch (error) {
        emit('keystream_buffer_writes_error', { call_id: this.callId,
          stage: 'plaintext_object', error: String(error) });
        return;
      }
      const buffer = plaintextObject.sub(KS_FROM_PLAINTEXT_OBJECT);
      const state = { callId: this.callId, buffer,
        ring: new Array(RING_SIZE), head: 0, count: 0,
        bytes: snapshotBytes(buffer), changes: [], snapshots: [], loadCount: 0 };
      emit('keystream_buffer_call', { call_id: this.callId,
        plaintext_object: plaintextObject.toString(), buffer: buffer.toString() });
      this.state = state;
      activeByThread.set(this.traceThreadId, state);
      const threadId = this.traceThreadId;
      try {
        Stalker.follow(threadId, { transform(iterator) {
          let instruction;
          let first = true;
          while ((instruction = iterator.next()) !== null) {
            const address = instruction.address.toString();
            if (first) {
              first = false;
              const blockAddress = address;
              iterator.putCallout(function (_context) {
                const current = activeByThread.get(threadId);
                if (current === undefined) return;
                const now = snapshotBytes(current.buffer);
                if (now !== null && current.bytes !== null) {
                  const changed = [];
                  for (let i = 0; i < KS_SIZE; i++) {
                    if (now[i] !== current.bytes[i]) changed.push([i, current.bytes[i], now[i]]);
                  }
                  if (changed.length !== 0) {
                    current.changes.push({ observer_block: blockAddress,
                      writer_block: current.count === 0 ? null : readRing(current).slice(-1)[0], changed });
                    if (current.changes.length > 128) current.changes.shift();
                  }
                }
                current.bytes = now;
                pushRing(current, blockAddress);
              });
            }
            if (address === load) {
              iterator.putCallout(function (context) {
                const current = activeByThread.get(threadId);
                if (current === undefined) return;
                const offset = context.rax.sub(current.buffer).toInt32();
                const index = current.loadCount++;
                if (offset !== 0 || current.snapshots.length >= MAX_SNAPSHOTS) return;
                current.snapshots.push({ load_index: index, buffer: snapshotBytes(current.buffer),
                  recent_changes: current.changes.slice(), history: readRing(current) });
                current.changes = [];
              });
            }
            iterator.keep();
          }
        }});
        this.tracing = true;
      } catch (error) {
        activeByThread.delete(this.traceThreadId);
        emit('keystream_buffer_writes_error', { call_id: this.callId, error: String(error) });
      }
    },
    onLeave(retval) {
      if (this.state === undefined) return;
      if (this.tracing) { try { Stalker.unfollow(this.traceThreadId); } catch (_) {} }
      activeByThread.delete(this.traceThreadId);
      emit('keystream_buffer_writes_leave', { call_id: this.callId,
        loads: this.state.loadCount, snapshots: this.state.snapshots.length, retval: retval.toString() });
      emitSnapshots(this.callId, this.state.snapshots);
    }
  });
}
function tryInstall() {
  if (!installed) { const module = Process.findModuleByName(MODULE_NAME); if (module !== null) install(module); }
}
tryInstall();
if (!installed) { const timer = setInterval(function () { tryInstall(); if (installed) clearInterval(timer); }, 100); }
