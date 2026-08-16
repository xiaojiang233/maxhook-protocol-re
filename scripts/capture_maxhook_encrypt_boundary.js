'use strict';

// Narrow research hook for the already recovered MaxHook envelope boundary.
// It intentionally does not hook WinHTTP, JVM, CNG, or the VM dispatcher.

const MODULE_NAME = 'MaxHook.dll';
const ENCRYPT_RVA = 0x324610;
const MAX_STRING_BYTES = 32 * 1024 * 1024;
let installed = false;
let callSequence = 0;

function emit(kind, fields, bytes) {
  const payload = Object.assign({
    kind: kind,
    thread_id: Process.getCurrentThreadId()
  }, fields || {});
  if (bytes !== null && bytes !== undefined) send(payload, bytes);
  else send(payload);
}

function safePointer(value) {
  try { return value.toString(); } catch (_) { return '<unavailable>'; }
}

function u64Number(pointer) {
  const text = pointer.readU64().toString();
  const value = Number(text);
  if (!Number.isSafeInteger(value) || value < 0) {
    throw new Error('unsafe uint64 size: ' + text);
  }
  return value;
}

function readMsvcString(objectPointer) {
  if (objectPointer.isNull()) throw new Error('null std::string object');
  const size = u64Number(objectPointer.add(0x10));
  const capacity = u64Number(objectPointer.add(0x18));
  if (size > capacity) throw new Error('std::string size exceeds capacity');
  if (size > MAX_STRING_BYTES) throw new Error('std::string exceeds safety limit');
  const dataPointer = capacity < 16 ? objectPointer : objectPointer.readPointer();
  if (size !== 0 && dataPointer.isNull()) throw new Error('null std::string data');
  const bytes = size === 0 ? new ArrayBuffer(0) : dataPointer.readByteArray(size);
  return {
    object: objectPointer.toString(),
    data: dataPointer.toString(),
    size: size,
    capacity: capacity,
    bytes: bytes
  };
}

function emitString(callId, phase, label, objectPointer) {
  try {
    const value = readMsvcString(objectPointer);
    emit('encrypt_string', {
      call_id: callId,
      phase: phase,
      label: label,
      object_pointer: value.object,
      data_pointer: value.data,
      size: value.size,
      capacity: value.capacity
    }, value.bytes);
    return true;
  } catch (error) {
    emit('encrypt_string_error', {
      call_id: callId,
      phase: phase,
      label: label,
      object_pointer: safePointer(objectPointer),
      error: String(error)
    });
    return false;
  }
}

function install(module) {
  if (installed) return;
  installed = true;
  if (Process.pointerSize !== 8) {
    emit('fatal', {error: 'this hook requires an x64 process'});
    return;
  }
  if (ENCRYPT_RVA >= module.size) {
    emit('fatal', {
      error: 'encrypt RVA is outside the loaded module',
      module_size: module.size
    });
    return;
  }
  const address = module.base.add(ENCRYPT_RVA);
  let prologue = null;
  try { prologue = address.readByteArray(16); } catch (_) {}
  emit('encrypt_hook_installed', {
    module: module.name,
    module_base: module.base.toString(),
    module_size: module.size,
    encrypt_rva: '0x' + ENCRYPT_RVA.toString(16),
    address: address.toString()
  }, prologue);

  Interceptor.attach(address, {
    onEnter(args) {
      this.callId = ++callSequence;
      this.output = args[0];
      this.input32 = args[1];
      this.input64 = args[2];
      this.contextObject = args[3];
      this.plaintext = ptr(0);
      try { this.plaintext = this.context.rsp.add(0x28).readPointer(); } catch (_) {}
      emit('encrypt_enter', {
        call_id: this.callId,
        return_address: this.returnAddress.toString(),
        output_object: safePointer(this.output),
        input32_object: safePointer(this.input32),
        input64_object: safePointer(this.input64),
        context_object: safePointer(this.contextObject),
        plaintext_object: safePointer(this.plaintext)
      });
      emitString(this.callId, 'input', 'input32', this.input32);
      emitString(this.callId, 'input', 'input64', this.input64);
      emitString(this.callId, 'input', 'plaintext_json', this.plaintext);
      // 额外: dump builder 栈帧与 context 对象内容 (key 派生关键)
      const builderRbp = this.context.rbp;
      emit('builder_frame', {
        call_id: this.callId,
        builder_rbp: safePointer(builderRbp)
      }, (() => {
        try { return builderRbp.sub(0x80).readByteArray(0x380); } catch (_) { return null; }
      })());
      emit('context_dump', {
        call_id: this.callId,
        context_object: safePointer(this.contextObject),
        context_size: 0x100
      }, (() => {
        try { return this.contextObject.readByteArray(0x100); } catch (_) { return null; }
      })());
      // context 内部 heap 指针内容 (key 材料候选: +0x00/+0x10 是 26B/27B 串)
      ['ctx_ptr0', 'ctx_ptr1', 'ctx_ptr2'].forEach((label, idx) => {
        try {
          const target = this.contextObject.add(idx * 0x10).readPointer();
          emit(label, { call_id: this.callId, ptr: safePointer(target), size: 0x100 },
            target.readByteArray(0x100));
        } catch (_) { /* 不可读则跳过 */ }
      });
    },
    onLeave(retval) {
      emitString(this.callId, 'output', 'kid_hex', this.output);
      emitString(this.callId, 'output', 'nonce_hex', this.output.add(0x20));
      emitString(this.callId, 'output', 'ciphertext_hex', this.output.add(0x40));
      emitString(this.callId, 'output', 'tag_hex', this.output.add(0x60));
      emit('encrypt_leave', {
        call_id: this.callId,
        retval: retval.toString()
      });
    }
  });
}

function tryInstall() {
  if (installed) return;
  const module = Process.findModuleByName(MODULE_NAME);
  if (module !== null) install(module);
}

tryInstall();
if (!installed) {
  const timer = setInterval(function () {
    tryInstall();
    if (installed) clearInterval(timer);
  }, 100);
}
