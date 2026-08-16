'use strict';

// Stalker 只读抓取 VM 五个通用 32-bit ROL/ROR 原语的真实操作数。
//
// 目标：在原语真实执行时记录 rax、cl、[rax] 前后值，并验证旋转语义。
// 这些站点属于通用 VM ISA；需通过跨调用差分进一步隔离与外层密码相关的子区间。
//
// 严格只读：putCallout 里只 readU32/readU8，绝不写。Stalker 影子内存执行不改原指令。

const MODULE_NAME = 'MaxHook.dll';
const ENCRYPT_RVA = 0x324610;

// 已交叉验证的真实 rol/ror/bswap 指令地址（磁盘明文 + Stalker 翻译过）。
// 用 RVA（相对 module.base），避免硬编码绝对地址。
const ROT_SITES = [
  { rva: 0xa164be, op: 'rol' },
  { rva: 0xb3cbf4, op: 'ror' },
  { rva: 0xb5f49c, op: 'ror' },
  { rva: 0xaf6547, op: 'rol' },
  { rva: 0xa59e63, op: 'ror' },
];

let installed = false;
let callSeq = 0;
let rotHits = 0;
const MAX_SAMPLES_PER_CALL = 200000;
const activeByThread = new Map();

function rotate32(value, count, op) {
  const n = count & 31;
  const x = value >>> 0;
  if (n === 0) return x;
  if (op === 'rol') return ((x << n) | (x >>> (32 - n))) >>> 0;
  return ((x >>> n) | (x << (32 - n))) >>> 0;
}

function emit(kind, fields, bytes) {
  const payload = Object.assign({ kind, thread_id: Process.getCurrentThreadId() }, fields || {});
  if (bytes !== null && bytes !== undefined) send(payload, bytes);
  else send(payload);
}

function safeHex(v) { try { return v.toString(); } catch (_) { return '<unavailable>'; } }

function install(module) {
  if (installed) return;
  installed = true;
  const encryptAddr = module.base.add(ENCRYPT_RVA);
  const rotSites = new Map();
  ROT_SITES.forEach(function (site) {
    const address = module.base.add(site.rva);
    rotSites.set(address.toString(), {
      address: address.toString(),
      rva: '0x' + site.rva.toString(16),
      op: site.op
    });
  });
  emit('rot_hook_installed', {
    module: module.name,
    module_base: module.base.toString(),
    encrypt: encryptAddr.toString(),
    rot_sites: Array.from(rotSites.values())
  });

  Interceptor.attach(encryptAddr, {
    onEnter(args) {
      this.callId = ++callSeq;
      this.traceThreadId = this.threadId;
      this.traceState = { callId: this.callId, samples: [], pending: null, dropped: 0 };
      activeByThread.set(this.traceThreadId, this.traceState);
      emit('rot_trace_begin', { call_id: this.callId });

      try {
        Stalker.follow(this.traceThreadId, {
          transform(iterator) {
            let insn;
            while ((insn = iterator.next()) !== null) {
              const site = rotSites.get(insn.address.toString());
              if (site !== undefined) {
                // Callout 1 executes immediately before the native rotate.
                iterator.putCallout(function (context) {
                  const state = activeByThread.get(Process.getCurrentThreadId());
                  if (state === undefined) return;
                  if (state.samples.length >= MAX_SAMPLES_PER_CALL) {
                    state.dropped++;
                    state.pending = null;
                    return;
                  }
                  const rax = context.rax;
                  const cl = context.rcx.and(0xff).toInt32();
                  let before = null;
                  try { before = rax.readU32() >>> 0; } catch (_) {}
                  const sample = {
                    seq: state.samples.length,
                    rip: site.address,
                    rva: site.rva,
                    op: site.op,
                    rax: rax.toString(),
                    cl: cl,
                    count: cl & 31,
                    before: before,
                    expected_after: before === null ? null : rotate32(before, cl, site.op),
                    after: null,
                    verified: null
                  };
                  state.samples.push(sample);
                  state.pending = sample;
                  rotHits++;
                });
                iterator.keep();
                // Callout 2 executes after the rotate, before the following instruction.
                iterator.putCallout(function (context) {
                  const state = activeByThread.get(Process.getCurrentThreadId());
                  if (state === undefined || state.pending === null) return;
                  const sample = state.pending;
                  state.pending = null;
                  try {
                    sample.after = context.rax.readU32() >>> 0;
                    sample.verified = sample.expected_after === sample.after;
                  } catch (_) {}
                });
              } else {
                iterator.keep();
              }
            }
          }
        });
        this.tracing = true;
      } catch (e) {
        activeByThread.delete(this.traceThreadId);
        emit('rot_trace_error', { call_id: this.callId, error: String(e) });
      }
    },
    onLeave(retval) {
      if (this.tracing) { try { Stalker.unfollow(this.traceThreadId); } catch (_) {} }
      activeByThread.delete(this.traceThreadId);
      const state = this.traceState || { samples: [], dropped: 0 };
      const s = state.samples;
      emit('rot_trace_leave', {
        call_id: this.callId,
        rot_hits: s.length,
        dropped: state.dropped,
        verified_hits: s.filter(function (x) { return x.verified === true; }).length,
        mismatch_hits: s.filter(function (x) { return x.verified === false; }).length,
        total_rot_hits: rotHits,
        retval: retval.toString()
      });
      // Send samples in chunks to keep individual Frida messages bounded.
      for (let i = 0; i < s.length; i += 256) {
        const chunk = s.slice(i, i + 256);
        const json = JSON.stringify(chunk);
        const buf = Memory.allocUtf8String(json);
        emit('rot_samples', {
          call_id: this.callId,
          label: 'rot_samples',
          chunk: i / 256,
          total_chunks: Math.ceil(s.length / 256)
        }, buf.readByteArray(json.length));
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
