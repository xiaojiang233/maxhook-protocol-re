'use strict';

// Key 材料数据流追踪 (破加密的关键一步)
// 目标: 加密函数 VM 内部如何消费 input32(kid)/input64(密钥材料) — hex 解码 + 派生 key 的代码位置
// 方法: MemoryAccessMonitor 监控 input32/input64 的 heap buffer, 记录每次读取的 RIP

const MODULE_NAME = 'MaxHook.dll';
const ENCRYPT_RVA = 0x324610;
let installed = false;
let callSeq = 0;

function emit(kind, fields, bytes) {
  const payload = Object.assign({ kind, thread_id: Process.getCurrentThreadId() }, fields || {});
  if (bytes !== null && bytes !== undefined) send(payload, bytes);
  else send(payload);
}
function safePointer(p) { try { return p.toString(); } catch (_) { return '<unavailable>'; } }

function readU64(p) {
  const v = p.readU64().toString();
  const n = Number(v);
  return Number.isSafeInteger(n) && n >= 0 ? n : 0;
}

function readMsvcString(objPtr) {
  if (objPtr.isNull()) return { dataPtr: null, size: 0, hex: '' };
  try {
    const size = readU64(objPtr.add(0x10));
    const capacity = readU64(objPtr.add(0x18));
    if (size > 0x10000 || size > capacity + 0x10) return { dataPtr: null, size: 0, hex: '' };
    const dataPtr = capacity < 16 ? objPtr : objPtr.readPointer();
    let hex = '';
    if (size > 0 && !dataPtr.isNull()) {
      try {
        const b = dataPtr.readByteArray(Math.min(size, 64));
        hex = Array.from(new Uint8Array(b)).map(function (x) { return x.toString(16).padStart(2, '0'); }).join('');
      } catch (_) {}
    }
    return { dataPtr: size > 0 ? dataPtr : null, size, hex };
  } catch (_) { return { dataPtr: null, size: 0, hex: '' }; }
}

function install(module) {
  if (installed) return;
  installed = true;
  const address = module.base.add(ENCRYPT_RVA);
  emit('keytrace_installed', { module: module.name, encrypt_address: address.toString() });

  Interceptor.attach(address, {
    onEnter(args) {
      this.callId = ++callSeq;
      const i32 = readMsvcString(args[1]);
      const i64 = readMsvcString(args[2]);
      emit('keytrace_begin', {
        call_id: this.callId,
        input32_size: i32.size, input32_data: safePointer(i32.dataPtr), input32_hex: i32.hex,
        input64_size: i64.size, input64_data: safePointer(i64.dataPtr), input64_hex: i64.hex
      });
      // 监控 key 材料 buffer 的读取
      const ranges = [];
      if (i32.dataPtr && i32.size > 0) ranges.push({ base: i32.dataPtr, size: i32.size });
      if (i64.dataPtr && i64.size > 0) ranges.push({ base: i64.dataPtr, size: i64.size });
      this.access = [];
      const acc = this.access;
      try {
        MemoryAccessMonitor.enable(ranges, {
          onAccess(details) {
            acc.push({
              from: details.from.toString(),
              op: details.operation,
              addr: details.address.toString()
            });
          }
        });
        this.monitoring = true;
      } catch (e) {
        emit('keytrace_error', { call_id: this.callId, error: String(e) });
      }
    },
    onLeave(retval) {
      if (!this.monitoring) return;
      try { MemoryAccessMonitor.disable(); } catch (_) {}
      // 汇总: RIP -> 读取次数
      const stat = {};
      for (const a of this.access) {
        if (a.op !== 'read') continue;
        stat[a.from] = (stat[a.from] || 0) + 1;
      }
      const top = Object.entries(stat).sort((x, y) => y[1] - x[1]);
      emit('keytrace_summary', {
        call_id: this.callId,
        total_access: this.access.length,
        top_readers: top.slice(0, 40).map(([r, c]) => `${r}:${c}`).join(',')
      });
      // 发送全部去重 RIP (供离线反汇编)
      const arr = top.map(([r, c]) => `${r}:${c}`);
      for (let i = 0; i < arr.length; i += 400) {
        const s = arr.slice(i, i + 400).join('\n');
        const buf = Memory.allocUtf8String(s);
        emit('keytrace_addrs', { call_id: this.callId, chunk: i / 400 }, buf.readByteArray(s.length));
      }
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
