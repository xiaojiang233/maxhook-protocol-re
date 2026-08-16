'use strict';

const connections = new Map();
const requests = new Map();
const algorithms = new Map();
const symmetricKeys = new Map();
let requestSequence = 0;
let winHttpInstalled = false;
let bcryptInstalled = false;

function key(handle) {
  return handle.toString();
}

function readWide(pointer, lengthChars) {
  if (pointer.isNull()) return '';
  try {
    if (lengthChars === 0xffffffff) return pointer.readUtf16String();
    return pointer.readUtf16String(lengthChars);
  } catch (_) {
    return '<unreadable>';
  }
}

function copyBytes(pointer, length) {
  if (pointer.isNull() || length === 0) return null;
  try {
    return pointer.readByteArray(length);
  } catch (_) {
    return null;
  }
}

function captureBacktrace(context) {
  try {
    return Thread.backtrace(context, Backtracer.ACCURATE).map(function (address) {
      const symbol = DebugSymbol.fromAddress(address);
      return {
        address: address.toString(),
        module: symbol.moduleName || '',
        name: symbol.name || '',
        text: symbol.toString()
      };
    });
  } catch (_) {
    return [];
  }
}

function captureRegisters(context) {
  const names = [
    'rax', 'rbx', 'rcx', 'rdx', 'rsi', 'rdi', 'rbp', 'rsp',
    'r8', 'r9', 'r10', 'r11', 'r12', 'r13', 'r14', 'r15', 'rip'
  ];
  const output = {};
  names.forEach(function (name) {
    try {
      if (context[name] !== undefined) output[name] = context[name].toString();
    } catch (_) {}
  });
  return output;
}

function captureStack(context, maximumLength) {
  let stackPointer;
  try { stackPointer = context.rsp; } catch (_) { return null; }
  try {
    const range = Process.findRangeByAddress(stackPointer);
    if (range === null) return null;
    const available = range.base.add(range.size).sub(stackPointer).toUInt32();
    const length = Math.min(maximumLength, available);
    return {
      pointer: stackPointer.toString(),
      range_base: range.base.toString(),
      range_size: range.size,
      length: length,
      bytes: copyBytes(stackPointer, length)
    };
  } catch (_) {
    return null;
  }
}

function backtraceTouchesMaxHook(backtrace) {
  return backtrace.some(function (frame) {
    return frame.module.toLowerCase() === 'maxhook.dll';
  });
}

function emitRaw(kind, fields, bytes) {
  const payload = Object.assign({
    kind: kind,
    thread_id: Process.getCurrentThreadId()
  }, fields || {});
  if (bytes !== null && bytes !== undefined) send(payload, bytes);
  else send(payload);
}

function requestInfo(handle) {
  const h = key(handle);
  return requests.get(h) || {
    id: 'unknown-' + h,
    handle: h,
    host: '',
    port: 0,
    verb: '',
    path: ''
  };
}

function isTarget(info, totalLength) {
  return info.host.toLowerCase() === 'security.mcbjd.net' ||
    info.path === '/api/v3/report' || totalLength === 2659;
}

function emit(kind, info, fields, bytes) {
  const payload = Object.assign({
    kind: kind,
    request_id: info.id,
    request_handle: info.handle,
    host: info.host,
    port: info.port,
    verb: info.verb,
    path: info.path,
    thread_id: Process.getCurrentThreadId()
  }, fields || {});
  if (bytes !== null && bytes !== undefined) send(payload, bytes);
  else send(payload);
}

function attach(module, name, callbacks) {
  const address = module.getExportByName(name);
  Interceptor.attach(address, callbacks);
  send({kind: 'hook_installed', export: name, address: address.toString()});
}

function installWinHttpHooks(module) {
  if (winHttpInstalled) return;
  winHttpInstalled = true;

  attach(module, 'WinHttpConnect', {
    onEnter(args) {
      this.host = readWide(args[1], 0xffffffff);
      this.port = args[2].toUInt32();
    },
    onLeave(retval) {
      if (!retval.isNull()) {
        connections.set(key(retval), {host: this.host, port: this.port});
      }
    }
  });

  attach(module, 'WinHttpOpenRequest', {
    onEnter(args) {
      this.connection = key(args[0]);
      this.verb = readWide(args[1], 0xffffffff);
      this.path = readWide(args[2], 0xffffffff);
      this.flags = args[6].toUInt32();
    },
    onLeave(retval) {
      if (retval.isNull()) return;
      const connection = connections.get(this.connection) || {host: '', port: 0};
      const info = {
        id: String(++requestSequence),
        handle: key(retval),
        connection_handle: this.connection,
        host: connection.host,
        port: connection.port,
        verb: this.verb,
        path: this.path,
        flags: this.flags
      };
      requests.set(info.handle, info);
      if (isTarget(info, 0)) emit('request_open', info, {flags: info.flags});
    }
  });

  attach(module, 'WinHttpSendRequest', {
    onEnter(args) {
      const info = requestInfo(args[0]);
      const headerLength = args[2].toUInt32();
      const optionalLength = args[4].toUInt32();
      const totalLength = args[5].toUInt32();
      const headers = readWide(args[1], headerLength);
      if (!isTarget(info, totalLength)) return;
      const backtrace = captureBacktrace(this.context);
      const registers = captureRegisters(this.context);
      const stack = captureStack(this.context, 0x8000);
      emit('send_begin', info, {
        headers: headers,
        optional_length: optionalLength,
        total_length: totalLength,
        optional_pointer: args[3].toString(),
        caller: this.returnAddress.toString(),
        backtrace: backtrace,
        registers: registers
      });
      if (stack !== null) {
        emit('send_stack', info, {
          stack_pointer: stack.pointer,
          stack_range_base: stack.range_base,
          stack_range_size: stack.range_size,
          stack_length: stack.length
        }, stack.bytes);
      }
      if (optionalLength !== 0) {
        emit('send_optional', info, {
          chunk_length: optionalLength,
          total_length: totalLength,
          buffer_pointer: args[3].toString()
        }, copyBytes(args[3], optionalLength));
      }
    }
  });

  attach(module, 'WinHttpWriteData', {
    onEnter(args) {
      const info = requestInfo(args[0]);
      const length = args[2].toUInt32();
      if (!isTarget(info, length)) return;
      const backtrace = captureBacktrace(this.context);
      const registers = captureRegisters(this.context);
      const stack = captureStack(this.context, 0x8000);
      emit('write', info, {
        chunk_length: length,
        buffer_pointer: args[1].toString(),
        caller: this.returnAddress.toString(),
        backtrace: backtrace,
        registers: registers
      }, copyBytes(args[1], length));
      if (stack !== null) {
        emit('write_stack', info, {
          stack_pointer: stack.pointer,
          stack_range_base: stack.range_base,
          stack_range_size: stack.range_size,
          stack_length: stack.length
        }, stack.bytes);
      }
    }
  });

  attach(module, 'WinHttpReceiveResponse', {
    onEnter(args) {
      const info = requestInfo(args[0]);
      if (isTarget(info, 0)) emit('receive_begin', info, {});
    }
  });

  attach(module, 'WinHttpReadData', {
    onEnter(args) {
      this.info = requestInfo(args[0]);
      this.buffer = args[1];
      this.requested = args[2].toUInt32();
      this.readPointer = args[3];
      this.target = isTarget(this.info, 0);
    },
    onLeave(retval) {
      if (!this.target || retval.toInt32() === 0 || this.readPointer.isNull()) return;
      let length = 0;
      try { length = this.readPointer.readU32(); } catch (_) { return; }
      emit('read', this.info, {
        chunk_length: length,
        requested_length: this.requested,
        buffer_pointer: this.buffer.toString()
      }, copyBytes(this.buffer, length));
    }
  });
}

function readAuthenticatedCipherInfo(pointer) {
  if (pointer.isNull()) return null;
  try {
    const size = pointer.readU32();
    if (size < 48 || size > 256) return {size: size, invalid_size: true};
    const noncePointer = pointer.add(8).readPointer();
    const nonceLength = pointer.add(16).readU32();
    const aadPointer = pointer.add(24).readPointer();
    const aadLength = pointer.add(32).readU32();
    const tagPointer = pointer.add(40).readPointer();
    const tagLength = pointer.add(48).readU32();
    return {
      size: size,
      version: pointer.add(4).readU32(),
      nonce_pointer: noncePointer.toString(),
      nonce_length: nonceLength,
      nonce: copyBytes(noncePointer, nonceLength),
      aad_pointer: aadPointer.toString(),
      aad_length: aadLength,
      aad: copyBytes(aadPointer, aadLength),
      tag_pointer: tagPointer.toString(),
      tag_length: tagLength
    };
  } catch (_) {
    return {unreadable: true};
  }
}

function installBcryptHooks(module) {
  if (bcryptInstalled) return;
  bcryptInstalled = true;

  attach(module, 'BCryptOpenAlgorithmProvider', {
    onEnter(args) {
      this.output = args[0];
      this.algorithm = readWide(args[1], 0xffffffff);
      this.implementation = readWide(args[2], 0xffffffff);
      this.flags = args[3].toUInt32();
      this.backtrace = captureBacktrace(this.context);
    },
    onLeave(status) {
      if (status.toInt32() !== 0 || this.output.isNull()) return;
      let handle;
      try { handle = this.output.readPointer(); } catch (_) { return; }
      algorithms.set(key(handle), this.algorithm);
      if (!backtraceTouchesMaxHook(this.backtrace)) return;
      emitRaw('bcrypt_open_algorithm', {
        status: status.toInt32(),
        algorithm_handle: key(handle),
        algorithm: this.algorithm,
        implementation: this.implementation,
        flags: this.flags,
        backtrace: this.backtrace
      });
    }
  });

  attach(module, 'BCryptGenerateSymmetricKey', {
    onEnter(args) {
      this.algorithmHandle = key(args[0]);
      this.output = args[1];
      this.secretPointer = args[4];
      this.secretLength = args[5].toUInt32();
      this.secret = copyBytes(this.secretPointer, this.secretLength);
      this.flags = args[6].toUInt32();
      this.backtrace = captureBacktrace(this.context);
    },
    onLeave(status) {
      if (status.toInt32() !== 0 || this.output.isNull()) return;
      let handle;
      try { handle = this.output.readPointer(); } catch (_) { return; }
      symmetricKeys.set(key(handle), {
        algorithm: algorithms.get(this.algorithmHandle) || '',
        secret_length: this.secretLength
      });
      if (!backtraceTouchesMaxHook(this.backtrace)) return;
      emitRaw('bcrypt_generate_symmetric_key', {
        status: status.toInt32(),
        algorithm_handle: this.algorithmHandle,
        algorithm: algorithms.get(this.algorithmHandle) || '',
        key_handle: key(handle),
        secret_pointer: this.secretPointer.toString(),
        secret_length: this.secretLength,
        flags: this.flags,
        backtrace: this.backtrace
      }, this.secret);
    }
  });

  attach(module, 'BCryptImportKey', {
    onEnter(args) {
      this.algorithmHandle = key(args[0]);
      this.blobType = readWide(args[2], 0xffffffff);
      this.output = args[3];
      this.inputPointer = args[6];
      this.inputLength = args[7].toUInt32();
      this.input = copyBytes(this.inputPointer, this.inputLength);
      this.flags = args[8].toUInt32();
      this.backtrace = captureBacktrace(this.context);
    },
    onLeave(status) {
      if (status.toInt32() !== 0 || this.output.isNull()) return;
      let handle;
      try { handle = this.output.readPointer(); } catch (_) { return; }
      symmetricKeys.set(key(handle), {
        algorithm: algorithms.get(this.algorithmHandle) || '',
        blob_type: this.blobType
      });
      if (!backtraceTouchesMaxHook(this.backtrace)) return;
      emitRaw('bcrypt_import_key', {
        status: status.toInt32(),
        algorithm_handle: this.algorithmHandle,
        algorithm: algorithms.get(this.algorithmHandle) || '',
        key_handle: key(handle),
        blob_type: this.blobType,
        input_pointer: this.inputPointer.toString(),
        input_length: this.inputLength,
        flags: this.flags,
        backtrace: this.backtrace
      }, this.input);
    }
  });

  ['BCryptEncrypt', 'BCryptDecrypt'].forEach(function (name) {
    attach(module, name, {
      onEnter(args) {
        this.name = name;
        this.keyHandle = key(args[0]);
        this.inputPointer = args[1];
        this.inputLength = args[2].toUInt32();
        this.input = copyBytes(this.inputPointer, this.inputLength);
        this.auth = readAuthenticatedCipherInfo(args[3]);
        this.ivPointer = args[4];
        this.ivLength = args[5].toUInt32();
        this.iv = copyBytes(this.ivPointer, this.ivLength);
        this.outputPointer = args[6];
        this.outputCapacity = args[7].toUInt32();
        this.resultPointer = args[8];
        this.flags = args[9].toUInt32();
        this.backtrace = captureBacktrace(this.context);
        this.target = backtraceTouchesMaxHook(this.backtrace);
      },
      onLeave(status) {
        if (!this.target) return;
        let resultLength = 0;
        try { resultLength = this.resultPointer.readU32(); } catch (_) {}
        const auth = this.auth;
        const fields = {
          status: status.toInt32(),
          key_handle: this.keyHandle,
          key: symmetricKeys.get(this.keyHandle) || null,
          input_pointer: this.inputPointer.toString(),
          input_length: this.inputLength,
          input_hex: this.input === null ? null : Array.from(new Uint8Array(this.input)).map(x => x.toString(16).padStart(2, '0')).join(''),
          iv_pointer: this.ivPointer.toString(),
          iv_length: this.ivLength,
          iv_hex: this.iv === null ? null : Array.from(new Uint8Array(this.iv)).map(x => x.toString(16).padStart(2, '0')).join(''),
          output_pointer: this.outputPointer.toString(),
          output_capacity: this.outputCapacity,
          result_length: resultLength,
          flags: this.flags,
          auth_info: auth === null ? null : {
            size: auth.size,
            version: auth.version,
            nonce_pointer: auth.nonce_pointer,
            nonce_length: auth.nonce_length,
            nonce_hex: auth.nonce ? Array.from(new Uint8Array(auth.nonce)).map(x => x.toString(16).padStart(2, '0')).join('') : null,
            aad_pointer: auth.aad_pointer,
            aad_length: auth.aad_length,
            aad_hex: auth.aad ? Array.from(new Uint8Array(auth.aad)).map(x => x.toString(16).padStart(2, '0')).join('') : null,
            tag_pointer: auth.tag_pointer,
            tag_length: auth.tag_length,
            tag_hex: auth.tag_pointer && auth.tag_length ? Array.from(new Uint8Array(copyBytes(ptr(auth.tag_pointer), auth.tag_length) || new ArrayBuffer(0))).map(x => x.toString(16).padStart(2, '0')).join('') : null
          },
          backtrace: this.backtrace
        };
        emitRaw(name === 'BCryptEncrypt' ? 'bcrypt_encrypt' : 'bcrypt_decrypt', fields,
          copyBytes(this.outputPointer, resultLength));
      }
    });
  });
}

function tryInstall() {
  if (!winHttpInstalled) {
    try { installWinHttpHooks(Process.getModuleByName('winhttp.dll')); } catch (_) {}
  }
  if (!bcryptInstalled) {
    try { installBcryptHooks(Process.getModuleByName('bcrypt.dll')); } catch (_) {}
  }
  if (!winHttpInstalled || !bcryptInstalled) setTimeout(tryInstall, 250);
}

tryInstall();
