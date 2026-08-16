'use strict';

// Locate the real consumers of plaintext and key material. Interceptor is used
// only at the plaintext encrypt entry; MemoryAccessMonitor is read-only.

const MODULE_NAME = 'MaxHook.dll';
const ENCRYPT_RVA = 0x324610;
const MAX_STRING_BYTES = 32 * 1024 * 1024;
let installed = false;
let callSequence = 0;

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
  if (objectPointer.isNull()) throw new Error('null string');
  const size = u64Number(objectPointer.add(0x10));
  const capacity = u64Number(objectPointer.add(0x18));
  if (size > capacity || size > MAX_STRING_BYTES) throw new Error('invalid string');
  const data = capacity < 16 ? objectPointer : objectPointer.readPointer();
  return { data, size, capacity };
}
function install(module) {
  if (installed) return;
  installed = true;
  const encrypt = module.base.add(ENCRYPT_RVA);
  emit('input_access_installed', { module: module.name, module_base: module.base.toString(), encrypt: encrypt.toString() });
  Interceptor.attach(encrypt, {
    onEnter(args) {
      this.callId = ++callSequence;
      this.plaintextObject = ptr(0);
      try { this.plaintextObject = this.context.rsp.add(0x28).readPointer(); } catch (_) {}
      let input32 = null, input64 = null, plaintext = null;
      try { input32 = readMsvcString(args[1]); } catch (_) {}
      try { input64 = readMsvcString(args[2]); } catch (_) {}
      try { plaintext = readMsvcString(this.plaintextObject); } catch (_) {}
      const ranges = [], labels = [];
      function add(label, value) {
        if (value === null || value.size === 0) return;
        ranges.push({ base: value.data, size: value.size });
        labels.push({ label, base: value.data.toString(), end: value.data.add(value.size).toString(), size: value.size });
      }
      add('input32', input32); add('input64', input64); add('plaintext', plaintext);
      this.accesses = [];
      const accesses = this.accesses;
      emit('input_access_begin', { call_id: this.callId, ranges: labels });
      try {
        MemoryAccessMonitor.enable(ranges, { onAccess(details) {
          let label = 'unknown', offset = null;
          for (const item of labels) {
            const base = ptr(item.base), end = ptr(item.end);
            if (details.address.compare(base) >= 0 && details.address.compare(end) < 0) {
              label = item.label; offset = details.address.sub(base).toString(); break;
            }
          }
          accesses.push({ label, operation: details.operation, from: details.from.toString(),
            address: details.address.toString(), offset });
        }});
        this.monitoring = true;
      } catch (error) { emit('input_access_error', { call_id: this.callId, error: String(error) }); }
    },
    onLeave(retval) {
      if (this.monitoring) { try { MemoryAccessMonitor.disable(); } catch (_) {} }
      const accesses = this.accesses || [];
      const counts = {};
      accesses.forEach(function (x) { const key = x.label + '|' + x.operation + '|' + x.from; counts[key] = (counts[key] || 0) + 1; });
      emit('input_access_summary', { call_id: this.callId, total_accesses: accesses.length,
        distinct_sites: Object.keys(counts).length, sites: Object.entries(counts).sort((a,b) => b[1]-a[1]),
        accesses, retval: retval.toString() });
    }
  });
}
function tryInstall() { if (!installed) { const module = Process.findModuleByName(MODULE_NAME); if (module !== null) install(module); } }
tryInstall();
if (!installed) { const timer = setInterval(function () { tryInstall(); if (installed) clearInterval(timer); }, 100); }
