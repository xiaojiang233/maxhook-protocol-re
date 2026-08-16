'use strict';

// Capture the native 64-byte block generator proven to feed the VM keystream.
// The ONLY Interceptor is the verified encrypt entry; internal sites use Stalker.

const MODULE_NAME = 'MaxHook.dll';
const ENCRYPT_RVA = 0x324610;
const GENERATOR_RVA = 0x41a8a0;
const STORE32_RVA = 0x41a860;
const MAX_BLOCKS = 128;
let installed = false;
let callSequence = 0;
const activeByThread = new Map();

function emit(kind, fields, bytes) {
  const payload = Object.assign({ kind, thread_id: Process.getCurrentThreadId() }, fields || {});
  if (bytes !== null && bytes !== undefined) send(payload, bytes); else send(payload);
}
function readHex(address, size) {
  try {
    return Array.from(new Uint8Array(address.readByteArray(size)),
      value => value.toString(16).padStart(2, '0')).join('');
  } catch (_) { return null; }
}
function emitBlocks(callId, blocks) {
  const json = JSON.stringify(blocks);
  const memory = Memory.allocUtf8String(json);
  emit('block_generator_records', { call_id: callId, label: 'block_generator_records',
    blocks: blocks.length }, memory.readByteArray(json.length));
}
function install(module) {
  if (installed) return;
  installed = true;
  const encrypt = module.base.add(ENCRYPT_RVA);
  const generator = module.base.add(GENERATOR_RVA).toString();
  const store32 = module.base.add(STORE32_RVA).toString();
  emit('block_generator_installed', { module: module.name, module_base: module.base.toString(),
    encrypt: encrypt.toString(), generator, store32 });

  Interceptor.attach(encrypt, {
    onEnter(args) {
      this.callId = ++callSequence;
      this.traceThreadId = this.threadId;
      const state = { callId: this.callId, blocks: [], current: null };
      this.state = state;
      activeByThread.set(this.traceThreadId, state);
      try {
        Stalker.follow(this.traceThreadId, { transform(iterator) {
          let instruction;
          while ((instruction = iterator.next()) !== null) {
            const address = instruction.address.toString();
            if (address === generator) {
              iterator.putCallout(function (context) {
                const current = activeByThread.get(Process.getCurrentThreadId());
                if (current === undefined || current.blocks.length >= MAX_BLOCKS) return;
                if (current.current !== null) {
                  current.current.output_hex = readHex(ptr(current.current.output), 64);
                  current.blocks.push(current.current);
                }
                current.current = { index: current.blocks.length,
                  input: context.rcx.toString(), output: context.rdx.toString(),
                  input_hex: readHex(context.rcx, 64), output_before_hex: readHex(context.rdx, 64),
                  stores: [] };
              });
            } else if (address === store32) {
              iterator.putCallout(function (context) {
                const current = activeByThread.get(Process.getCurrentThreadId());
                if (current === undefined || current.current === null) return;
                const destination = context.rcx;
                const output = ptr(current.current.output);
                const offset = destination.sub(output).toInt32();
                current.current.stores.push({ destination: destination.toString(), offset,
                  value: context.rdx.and(0xffffffff).toString() });
              });
            }
            iterator.keep();
          }
        }});
        this.tracing = true;
      } catch (error) {
        activeByThread.delete(this.traceThreadId);
        emit('block_generator_error', { call_id: this.callId, error: String(error) });
      }
    },
    onLeave(retval) {
      if (this.state === undefined) return;
      if (this.tracing) { try { Stalker.unfollow(this.traceThreadId); } catch (_) {} }
      if (this.state.current !== null && this.state.blocks.length < MAX_BLOCKS) {
        this.state.current.output_hex = readHex(ptr(this.state.current.output), 64);
        this.state.blocks.push(this.state.current);
      }
      activeByThread.delete(this.traceThreadId);
      emit('block_generator_leave', { call_id: this.callId,
        blocks: this.state.blocks.length, retval: retval.toString() });
      emitBlocks(this.callId, this.state.blocks);
    }
  });
}
function tryInstall() {
  if (!installed) { const module = Process.findModuleByName(MODULE_NAME); if (module !== null) install(module); }
}
tryInstall();
if (!installed) { const timer = setInterval(function () { tryInstall(); if (installed) clearInterval(timer); }, 100); }
