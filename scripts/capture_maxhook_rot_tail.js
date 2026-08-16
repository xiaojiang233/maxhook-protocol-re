'use strict';

// Read-only tail-window tracer for the five generic VM rotate primitives.
// Interceptor is used only at the plaintext .text encrypt entry. All .bugland
// observations use Stalker callouts in shadow-translated code.

const MODULE_NAME = 'MaxHook.dll';
const ENCRYPT_RVA = 0x324610;
const VM_CONTEXT_RVA = 0x98c884;
const DETAIL_START_HIT = 12000;
const DETAIL_RING_SIZE = 768;
const MAX_SAMPLES_PER_CALL = 200000;
const MAX_STRING_BYTES = 32 * 1024 * 1024;
const REG_NAMES = ['rax','rbx','rcx','rdx','rsi','rdi','rbp','rsp','r8','r9','r10','r11','r12','r13','r14','r15'];
const CONTEXT_SLOTS = [
  { offset: 0x0a, size: 4 }, { offset: 0x26, size: 8 },
  { offset: 0x45, size: 8 }, { offset: 0x5d, size: 1 },
  { offset: 0x61, size: 8 }, { offset: 0x69, size: 4 },
  { offset: 0x6d, size: 8 }, { offset: 0x81, size: 4 },
  { offset: 0x85, size: 8 }, { offset: 0xbd, size: 8 },
  { offset: 0xe5, size: 4 }, { offset: 0xf6, size: 8 },
  { offset: 0x162, size: 1 }
];
const ROT_SITES = [
  { rva: 0xa164be, op: 'rol' },
  { rva: 0xb3cbf4, op: 'ror' },
  { rva: 0xb5f49c, op: 'ror' },
  { rva: 0xaf6547, op: 'rol' },
  { rva: 0xa59e63, op: 'ror' },
];

let installed = false;
let callSequence = 0;
const activeByThread = new Map();

function emit(kind, fields, bytes) {
  const payload = Object.assign({ kind, thread_id: Process.getCurrentThreadId() }, fields || {});
  if (bytes !== null && bytes !== undefined) send(payload, bytes); else send(payload);
}

function safePointer(value) { try { return value.toString(); } catch (_) { return '<unavailable>'; } }
function u64Number(address) {
  const value = Number(address.readU64().toString());
  if (!Number.isSafeInteger(value) || value < 0) throw new Error('unsafe uint64');
  return value;
}
function readMsvcString(objectPointer) {
  if (objectPointer.isNull()) throw new Error('null std::string object');
  const size = u64Number(objectPointer.add(0x10));
  const capacity = u64Number(objectPointer.add(0x18));
  if (size > capacity || size > MAX_STRING_BYTES) throw new Error('invalid std::string size');
  const dataPointer = capacity < 16 ? objectPointer : objectPointer.readPointer();
  return { object: objectPointer.toString(), data: dataPointer.toString(), size, capacity,
    bytes: size === 0 ? new ArrayBuffer(0) : dataPointer.readByteArray(size) };
}
function emitString(callId, phase, label, objectPointer) {
  try {
    const value = readMsvcString(objectPointer);
    emit('encrypt_string', { call_id: callId, phase, label, object_pointer: value.object,
      data_pointer: value.data, size: value.size, capacity: value.capacity }, value.bytes);
  } catch (error) {
    emit('encrypt_string_error', { call_id: callId, phase, label,
      object_pointer: safePointer(objectPointer), error: String(error) });
  }
}
function rotate32(value, count, op) {
  const n = count & 31, x = value >>> 0;
  if (n === 0) return x;
  return op === 'rol' ? ((x << n) | (x >>> (32 - n))) >>> 0
                      : ((x >>> n) | (x << (32 - n))) >>> 0;
}
function readContextSlots(base) {
  const result = {};
  CONTEXT_SLOTS.forEach(function (slot) {
    const key = '0x' + slot.offset.toString(16);
    try {
      const address = base.add(slot.offset);
      if (slot.size === 1) result[key] = address.readU8();
      else if (slot.size === 4) result[key] = address.readU32();
      else result[key] = address.readU64().toString();
    } catch (_) { result[key] = null; }
  });
  return result;
}
function captureDetail(context, state, sample, vmContext) {
  if (state.hitCount < DETAIL_START_HIT) return;
  const registers = {};
  REG_NAMES.forEach(function (name) {
    try { registers[name] = context[name].toString(); } catch (_) { registers[name] = null; }
  });
  let stack = null;
  try { stack = context.rsp.readByteArray(0x80); } catch (_) {}
  const detail = {
    seq: sample.seq, rip: sample.rip, rva: sample.rva, op: sample.op,
    rax: sample.rax, cl: sample.cl, count: sample.count, before: sample.before,
    registers, context_slots: readContextSlots(vmContext), stack_hex: stack === null ? null :
      Array.from(new Uint8Array(stack), function (x) { return x.toString(16).padStart(2, '0'); }).join('')
  };
  if (state.details.length < DETAIL_RING_SIZE) state.details.push(detail);
  else { state.details[state.detailCursor] = detail; state.detailCursor = (state.detailCursor + 1) % DETAIL_RING_SIZE; }
  state.pendingDetail = detail;
}
function orderedRing(state) {
  if (state.details.length < DETAIL_RING_SIZE || state.detailCursor === 0) return state.details;
  return state.details.slice(state.detailCursor).concat(state.details.slice(0, state.detailCursor));
}
function emitJsonChunks(kind, callId, label, values, chunkSize) {
  for (let i = 0; i < values.length; i += chunkSize) {
    const json = JSON.stringify(values.slice(i, i + chunkSize));
    const buffer = Memory.allocUtf8String(json);
    emit(kind, { call_id: callId, label, chunk: i / chunkSize,
      total_chunks: Math.ceil(values.length / chunkSize) }, buffer.readByteArray(json.length));
  }
}

function install(module) {
  if (installed) return;
  installed = true;
  const encryptAddress = module.base.add(ENCRYPT_RVA);
  const vmContext = module.base.add(VM_CONTEXT_RVA);
  const sites = new Map();
  ROT_SITES.forEach(function (site) {
    const address = module.base.add(site.rva);
    let skeleton = null;
    try { skeleton = Array.from(new Uint8Array(address.sub(1).readByteArray(4))); } catch (_) {}
    sites.set(address.toString(), { address: address.toString(), rva: '0x' + site.rva.toString(16), op: site.op });
    const opcode = site.op === 'rol' ? 0x00 : 0x08;
    if (skeleton === null || skeleton[0] !== 0x9d || skeleton[1] !== 0xd3 ||
        skeleton[2] !== opcode)
      emit('rot_skeleton_mismatch', { rva: '0x' + site.rva.toString(16), bytes: skeleton });
  });
  emit('rot_tail_hook_installed', { module: module.name, module_base: module.base.toString(),
    encrypt: encryptAddress.toString(), detail_start_hit: DETAIL_START_HIT,
    detail_ring_size: DETAIL_RING_SIZE, rot_sites: Array.from(sites.values()) });

  Interceptor.attach(encryptAddress, {
    onEnter(args) {
      this.callId = ++callSequence;
      this.output = args[0]; this.input32 = args[1]; this.input64 = args[2];
      this.plaintext = ptr(0);
      try { this.plaintext = this.context.rsp.add(0x28).readPointer(); } catch (_) {}
      emitString(this.callId, 'input', 'input32', this.input32);
      emitString(this.callId, 'input', 'input64', this.input64);
      emitString(this.callId, 'input', 'plaintext_json', this.plaintext);
      const state = { samples: [], details: [], detailCursor: 0, pending: null,
        pendingDetail: null, hitCount: 0, dropped: 0 };
      this.state = state; this.traceThreadId = this.threadId;
      activeByThread.set(this.traceThreadId, state);
      emit('rot_tail_begin', { call_id: this.callId, plaintext_size: (() => {
        try { return u64Number(this.plaintext.add(0x10)); } catch (_) { return null; }
      })() });
      try {
        Stalker.follow(this.traceThreadId, { transform(iterator) {
          let instruction;
          while ((instruction = iterator.next()) !== null) {
            const site = sites.get(instruction.address.toString());
            if (site === undefined) { iterator.keep(); continue; }
            iterator.putCallout(function (context) {
              const current = activeByThread.get(Process.getCurrentThreadId());
              if (current === undefined) return;
              current.hitCount++;
              if (current.samples.length >= MAX_SAMPLES_PER_CALL) { current.dropped++; return; }
              const rax = context.rax;
              const cl = context.rcx.and(0xff).toInt32();
              let before = null; try { before = rax.readU32() >>> 0; } catch (_) {}
              const sample = { seq: current.samples.length, rip: site.address, rva: site.rva,
                op: site.op, rax: rax.toString(), cl, count: cl & 31, before,
                expected_after: before === null ? null : rotate32(before, cl, site.op),
                after: null, verified: null };
              current.samples.push(sample); current.pending = sample;
              captureDetail(context, current, sample, vmContext);
            });
            iterator.keep();
            iterator.putCallout(function (context) {
              const current = activeByThread.get(Process.getCurrentThreadId());
              if (current === undefined || current.pending === null) return;
              const sample = current.pending; current.pending = null;
              try { sample.after = context.rax.readU32() >>> 0;
                sample.verified = sample.after === sample.expected_after; } catch (_) {}
              if (current.pendingDetail !== null && current.pendingDetail.seq === sample.seq) {
                current.pendingDetail.after = sample.after;
                current.pendingDetail.verified = sample.verified;
                current.pendingDetail = null;
              }
            });
          }
        }});
        this.tracing = true;
      } catch (error) {
        activeByThread.delete(this.traceThreadId);
        emit('rot_tail_error', { call_id: this.callId, error: String(error) });
      }
    },
    onLeave(retval) {
      if (this.tracing) { try { Stalker.unfollow(this.traceThreadId); } catch (_) {} }
      activeByThread.delete(this.traceThreadId);
      const state = this.state;
      emitString(this.callId, 'output', 'kid_hex', this.output);
      emitString(this.callId, 'output', 'nonce_hex', this.output.add(0x20));
      emitString(this.callId, 'output', 'ciphertext_hex', this.output.add(0x40));
      emitString(this.callId, 'output', 'tag_hex', this.output.add(0x60));
      const details = orderedRing(state);
      emit('rot_tail_leave', { call_id: this.callId, rot_hits: state.samples.length,
        detail_count: details.length, detail_first_seq: details.length ? details[0].seq : null,
        detail_last_seq: details.length ? details[details.length - 1].seq : null,
        verified_hits: state.samples.filter(x => x.verified === true).length,
        mismatch_hits: state.samples.filter(x => x.verified === false).length,
        dropped: state.dropped, retval: retval.toString() });
      emitJsonChunks('rot_tail_details', this.callId, 'rot_tail_details', details, 32);
    }
  });
}

function tryInstall() { if (!installed) { const module = Process.findModuleByName(MODULE_NAME); if (module !== null) install(module); } }
tryInstall();
if (!installed) { const timer = setInterval(function () { tryInstall(); if (installed) clearInterval(timer); }, 100); }
