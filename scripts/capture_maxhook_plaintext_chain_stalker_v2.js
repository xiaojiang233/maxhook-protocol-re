'use strict';

// Safe plaintext copy-chain tracer v2. The ONLY Interceptor is the verified
// encrypt entry. Internal control-flow is observed using Stalker callouts.

const MODULE_NAME = 'MaxHook.dll';
const ENCRYPT_RVA = 0x324610;
const MEMCPY_ENTRY_RVA = 0x5d0b10;
const MEMCPY_RETURN_RVAS = [0x5d0b30,0x5d0b42,0x5d0b53,0x5d0b65,0x5d0b7f,
  0x5d0b92,0x5d0ba5,0x5d0bb8,0x5d0bcb,0x5d0bde,0x5d0bf2,0x5d0bff,
  0x5d0c0e,0x5d0c1c,0x5d0c23,0x5d0c29,0x5d0c2e,0x5d0c4c,
  0x5d0e0d,0x5d0f40,0x5d1096,0x5d117c];
const MAX_STRING_BYTES = 32 * 1024 * 1024;
const MAX_BLOCKS = 200000;
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
  const end = base.add(state.plaintextSize);
  try {
    MemoryAccessMonitor.enable([{ base, size: state.plaintextSize }], { onAccess(details) {
      const current = activeByThread.get(Process.getCurrentThreadId());
      if (current === undefined) return;
      // MemoryAccessMonitor works at page granularity; reject neighboring bytes.
      if (details.address.compare(base) < 0 || details.address.compare(end) >= 0) return;
      const item = { call_id: current.callId, operation: details.operation,
        shadow_from: details.from.toString(), original_block: current.currentBlock,
        previous_block: current.previousBlock, address: details.address.toString(),
        offset: details.address.sub(base).toString(), copy_destination: base.toString(),
        size: current.plaintextSize };
      current.downstream.push(item);
      emit('plaintext_copy_access', item);
    }});
    state.monitoring = true;
    state.afterCopy = true;
    emit('plaintext_copy_monitor', { call_id: state.callId, base: base.toString(), size: state.plaintextSize });
  } catch (error) {
    emit('plaintext_chain_error', { call_id: state.callId, stage: 'monitor_copy', error: String(error) });
  }
}
function updateBlock(threadId, blockAddress) {
  const state = activeByThread.get(threadId);
  if (state === undefined || !state.afterCopy) return;
  state.previousBlock = state.currentBlock;
  state.currentBlock = blockAddress;
  if (state.blocks.length < MAX_BLOCKS) state.blocks.push(blockAddress);
}

function install(module) {
  if (installed) return;
  installed = true;
  const encrypt = module.base.add(ENCRYPT_RVA);
  const memcpyEntry = module.base.add(MEMCPY_ENTRY_RVA).toString();
  const memcpyReturns = new Set(MEMCPY_RETURN_RVAS.map(rva => module.base.add(rva).toString()));
  emit('plaintext_chain_v2_installed', { module: module.name, module_base: module.base.toString(),
    encrypt: encrypt.toString(), memcpy_entry: memcpyEntry });

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
        monitoring: false, afterCopy: false, currentBlock: null, previousBlock: null,
        blocks: [], downstream: [] };
      this.state = state;
      activeByThread.set(this.traceThreadId, state);
      emit('plaintext_chain_begin', { call_id: this.callId,
        plaintext_object: plaintextObject.toString(), plaintext_data: plaintext.data.toString(),
        plaintext_size: plaintext.size });
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
              iterator.putCallout(function (_context) { updateBlock(traceThreadId, blockAddress); });
            }
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
                current.currentBlock = null;
                current.previousBlock = null;
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
        block_count: this.state.blocks.length, downstream: this.state.downstream,
        retval: retval.toString() });
    }
  });
}
function tryInstall() { if (!installed) { const module = Process.findModuleByName(MODULE_NAME); if (module !== null) install(module); } }
tryInstall();
if (!installed) { const timer = setInterval(function () { tryInstall(); if (installed) clearInterval(timer); }, 100); }
