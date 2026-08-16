'use strict';

// 合并捕获: 一次拿齐同会话的全部加密材料
// 1. 加密边界参数 (plaintext/input32/input64/output envelope)
// 2. Stalker 抓 0x180322e30 读的字节流 (h2_cantor 拼接 96 hex)

const MODULE_NAME = 'MaxHook.dll';
const ENCRYPT_RVA = 0x324610;
const KEYREAD_RVA = 0x322e30;
let installed = false;
let callSeq = 0;

function emit(kind, fields, bytes) {
  const payload = Object.assign({ kind, thread_id: Process.getCurrentThreadId() }, fields || {});
  if (bytes !== null && bytes !== undefined) send(payload, bytes);
  else send(payload);
}
function safePointer(p) { try { return p.toString(); } catch (_) { return '<unavailable>'; } }
function readU64(p) { const n = Number(p.readU64().toString()); return Number.isSafeInteger(n) && n >= 0 ? n : 0; }

function readStr(objPtr) {
  if (objPtr.isNull()) return { hex: '', size: 0, data: '0x0' };
  try {
    const size = readU64(objPtr.add(0x10));
    const capacity = readU64(objPtr.add(0x18));
    if (size > 0x40000) return { hex: '', size: 0, data: '0x0' };
    const dataPtr = capacity < 16 ? objPtr : objPtr.readPointer();
    let hex = '';
    if (size > 0 && !dataPtr.isNull()) {
      try {
        const b = dataPtr.readByteArray(size);
        hex = Array.from(new Uint8Array(b)).map(function (x) { return x.toString(16).padStart(2, '0'); }).join('');
      } catch (_) {}
    }
    return { hex, size, data: dataPtr.toString() };
  } catch (_) { return { hex: '', size: 0, data: '0x0' }; }
}

function install(module) {
  if (installed) return;
  installed = true;
  const encryptAddr = module.base.add(ENCRYPT_RVA);
  const keyReadAddr = module.base.add(KEYREAD_RVA);
  emit('crypto_installed', { module: module.name, encrypt: encryptAddr.toString(), keyread: keyReadAddr.toString() });

  Interceptor.attach(encryptAddr, {
    onEnter(args) {
      this.callId = ++callSeq;
      this.output = args[0];
      this.input32 = args[1];
      this.input64 = args[2];
      this.contextObj = args[3];
      this.plaintext = ptr(0);
      try { this.plaintext = this.context.rsp.add(0x28).readPointer(); } catch (_) {}

      // Stalker 抓 keyread 字节流 (最先建立, 避免被 readStr/emit 延迟错过)
      this.byteStream = [];
      const bs = this.byteStream;
      try {
        Stalker.follow(this.threadId, {
          transform(iterator) {
            let insn;
            while ((insn = iterator.next()) !== null) {
              if (insn.address.equals(keyReadAddr)) {
                const stream = bs;
                iterator.putCallout(function (context) {
                  if (stream.length >= 256) return;
                  let b = -1;
                  try { b = context.rdi.readU8(); } catch (_) {}
                  stream.push(b);
                });
              }
              iterator.keep();
            }
          }
        });
        this.tracing = true;
      } catch (e) {
        emit('crypto_error', { call_id: this.callId, error: String(e) });
      }

      emit('crypto_begin', { call_id: this.callId, return_address: this.returnAddress.toString() });
      try { var s = readStr(this.input32); emit('mat_input32', { call_id: this.callId, hex: s.hex, size: s.size, data: s.data }); } catch (e) { emit('mat_error', { call_id: this.callId, f: 'input32', e: String(e) }); }
      try { var s2 = readStr(this.input64); emit('mat_input64', { call_id: this.callId, hex: s2.hex, size: s2.size, data: s2.data }); } catch (e) { emit('mat_error', { call_id: this.callId, f: 'input64', e: String(e) }); }
      try { var s3 = readStr(this.plaintext); emit('mat_plaintext', { call_id: this.callId, hex: s3.hex, size: s3.size, data: s3.data }); } catch (e) { emit('mat_error', { call_id: this.callId, f: 'plaintext', e: String(e) }); }
      emit('mat_context', { call_id: this.callId, context: safePointer(this.contextObj) });
    },
    onLeave(retval) {
      if (this.tracing) { try { Stalker.unfollow(); } catch (_) {} }
      const bs = this.byteStream || [];
      const bsHex = bs.map(function (b) { return b < 0 ? '?' : b.toString(16).padStart(2, '0'); }).join('');
      emit('crypto_leave', {
        call_id: this.callId,
        kid_hex: readStr(this.output).hex,
        nonce_hex: readStr(this.output.add(0x20)).hex,
        ciphertext_hex: readStr(this.output.add(0x40)).hex,
        tag_hex: readStr(this.output.add(0x60)).hex,
        keyread_bytes: bs.length,
        keyread_hex: bsHex
      });
    }
  });
}

function tryInstall() {
  if (installed) return;
  const m = Process.findModuleByName(MODULE_NAME);
  if (m !== null) install(m);
}
tryInstall();
if (!installed) {
  const t = setInterval(function () { tryInstall(); if (installed) clearInterval(t); }, 100);
}
