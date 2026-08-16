'use strict';

// Locate the basic block that last changes each keystream byte slot before XOR.
// The ONLY Interceptor is the verified encrypt entry; VM observation uses Stalker.

const MODULE_NAME = 'MaxHook.dll';
const ENCRYPT_RVA = 0x324610;
const XOR_BYTE_RVA = 0x9c5561;
const VM_CONTEXT_RVA = 0x98c884;
const SLOT_A_OFFSET = 0xb5;
const SLOT_B_OFFSET = 0x235;
const CHANGE_HISTORY = 128;
const MAX_XOR_SAMPLES = 256;
let installed = false;
let callSequence = 0;
const activeByThread = new Map();

function emit(kind, fields, bytes) {
  const payload = Object.assign({ kind, thread_id: Process.getCurrentThreadId() }, fields || {});
  if (bytes !== null && bytes !== undefined) send(payload, bytes); else send(payload);
}
function pushChange(state, change) {
  state.changes.push(change);
  if (state.changes.length > CHANGE_HISTORY) state.changes.shift();
}
function emitSamples(callId, samples) {
  for (let i = 0; i < samples.length; i += 32) {
    const json = JSON.stringify(samples.slice(i, i + 32));
    const buffer = Memory.allocUtf8String(json);
    emit('keystream_slot_samples', { call_id: callId, label: 'keystream_slot_samples',
      chunk: i / 32, total_chunks: Math.ceil(samples.length / 32) },
      buffer.readByteArray(json.length));
  }
}
function install(module) {
  if (installed) return;
  installed = true;
  const encrypt = module.base.add(ENCRYPT_RVA);
  const xorByte = module.base.add(XOR_BYTE_RVA).toString();
  const slotA = module.base.add(VM_CONTEXT_RVA + SLOT_A_OFFSET);
  const slotB = module.base.add(VM_CONTEXT_RVA + SLOT_B_OFFSET);
  emit('keystream_slot_changes_installed', { module: module.name,
    module_base: module.base.toString(), encrypt: encrypt.toString(), xor_byte: xorByte,
    slot_a: slotA.toString(), slot_b: slotB.toString() });

  Interceptor.attach(encrypt, {
    onEnter(args) {
      this.callId = ++callSequence;
      this.traceThreadId = this.threadId;
      const state = { callId: this.callId, lastBlock: null, blockSequence: 0,
        valueA: slotA.readU8(), valueB: slotB.readU8(), changes: [], samples: [], xorCount: 0 };
      this.state = state;
      activeByThread.set(this.traceThreadId, state);
      const traceThreadId = this.traceThreadId;
      try {
        Stalker.follow(traceThreadId, { transform(iterator) {
          let instruction;
          let first = true;
          while ((instruction = iterator.next()) !== null) {
            const address = instruction.address.toString();
            if (first) {
              first = false;
              const blockAddress = address;
              iterator.putCallout(function (_context) {
                const current = activeByThread.get(traceThreadId);
                if (current === undefined) return;
                let a, b;
                try { a = slotA.readU8(); b = slotB.readU8(); } catch (_) { return; }
                if (a !== current.valueA) {
                  pushChange(current, { sequence: current.blockSequence, slot: 'A',
                    writer_block: current.lastBlock, observer_block: blockAddress,
                    before: current.valueA, after: a });
                  current.valueA = a;
                }
                if (b !== current.valueB) {
                  pushChange(current, { sequence: current.blockSequence, slot: 'B',
                    writer_block: current.lastBlock, observer_block: blockAddress,
                    before: current.valueB, after: b });
                  current.valueB = b;
                }
                current.lastBlock = blockAddress;
                current.blockSequence++;
              });
            }
            if (address === xorByte) {
              iterator.putCallout(function (context) {
                const current = activeByThread.get(traceThreadId);
                if (current === undefined) return;
                const index = current.xorCount++;
                if (current.samples.length >= MAX_XOR_SAMPLES) return;
                let destinationValue = null;
                try { destinationValue = context.r8.readU8(); } catch (_) {}
                current.samples.push({ xor_index: index, destination: context.r8.toString(),
                  plaintext_byte: context.r12.and(0xff).toInt32(), keystream_byte: destinationValue,
                  block_sequence: current.blockSequence, recent_changes: current.changes.slice() });
              });
            }
            iterator.keep();
          }
        }});
        this.tracing = true;
      } catch (error) {
        activeByThread.delete(this.traceThreadId);
        emit('keystream_slot_changes_error', { call_id: this.callId, error: String(error) });
      }
    },
    onLeave(retval) {
      if (this.state === undefined) return;
      if (this.tracing) { try { Stalker.unfollow(this.traceThreadId); } catch (_) {} }
      activeByThread.delete(this.traceThreadId);
      emit('keystream_slot_changes_leave', { call_id: this.callId,
        xor_hits: this.state.xorCount, samples: this.state.samples.length,
        retval: retval.toString() });
      emitSamples(this.callId, this.state.samples);
    }
  });
}
function tryInstall() {
  if (!installed) { const module = Process.findModuleByName(MODULE_NAME); if (module !== null) install(module); }
}
tryInstall();
if (!installed) { const timer = setInterval(function () { tryInstall(); if (installed) clearInterval(timer); }, 100); }
