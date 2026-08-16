'use strict';

// 安全版: 只在加密函数执行窗口内 hook 0x180322d10, 避免高频回调崩溃

const MODULE_NAME = 'MaxHook.dll';
const ENCRYPT_RVA = 0x324610;
const FN_RVA = 0x322d10;
let installed = false;
let seq = 0;
let inEncrypt = false;
let strfnHook = null;

function emit(kind, fields, bytes) {
  const payload = Object.assign({ kind, thread_id: Process.getCurrentThreadId() }, fields || {});
  if (bytes !== null && bytes !== undefined) send(payload, bytes);
  else send(payload);
}
function safePointer(p) { try { return p.toString(); } catch (_) { return '<unavailable>'; } }
function dumpHex(p, maxlen) {
  if (p === null || p === undefined || p.isNull()) return '';
  try {
    const b = p.readByteArray(maxlen);
    return Array.from(new Uint8Array(b)).map(function (x) { return x.toString(16).padStart(2, '0'); }).join('');
  } catch (_) { return ''; }
}

function install(module) {
  if (installed) return;
  installed = true;
  const encryptAddr = module.base.add(ENCRYPT_RVA);
  const fnAddr = module.base.add(FN_RVA);

  // 外层: 加密窗口标志
  Interceptor.attach(encryptAddr, {
    onEnter() { inEncrypt = true; seq = 0; },
    onLeave() { inEncrypt = false; }
  });

  // 内层: key 材料消费函数, 仅窗口内记录
  strfnHook = Interceptor.attach(fnAddr, {
    onEnter(args) {
      if (!inEncrypt) return;
      if (seq >= 16) return;
      seq++;
      this.id = seq;
      this.rcx = args[0]; this.rdx = args[1]; this.r8 = args[2];
      emit('strfn_enter', {
        call_id: this.id,
        rcx: safePointer(this.rcx), rdx: safePointer(this.rdx), r8: safePointer(this.r8),
        rcx_hex: dumpHex(this.rcx, 64),
        rdx_hex: dumpHex(this.rdx, 64)
      });
    },
    onLeave(retval) {
      if (!inEncrypt || !this.id) return;
      emit('strfn_leave', {
        call_id: this.id,
        retval: safePointer(retval),
        rcx_hex_after: dumpHex(this.rcx, 64),
        rdx_hex_after: dumpHex(this.rdx, 64)
      });
    }
  });
  emit('strfn_installed', { module: module.name, encrypt: encryptAddr.toString(), fn: fnAddr.toString() });
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
