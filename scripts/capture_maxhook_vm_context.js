'use strict';

// 只读抓取 MaxHook 加密 VM 的运行时状态，用于离线 Unicorn 模拟器跨过偏离点。
//
// 严格只读：所有内存访问都用 Memory.readByteArray / readPointer / readU64，
// 绝不 write、不 patch、不 Interceptor.replace，避免触发 Themida 反篡改。
//
// 抓取内容（在加密入口 onEnter 那一刻，以及可选的中段 hook 点）：
//   1. VM context @ module_base + 0x98c884（0x200 字节）—— 离线模拟器缺的关键块
//   2. VM 数据栈（调用线程栈底附近 0x7ffe1fec00..0x7ffe1ff000，约 0x4000 字节）
//   3. 原有的输入/输出字符串与 context 对象（保持与 encrypt_boundary_capture2 一致）
//
// 用法（frida -l 或 frida python 注入）：
//   默认只在加密入口抓初始态；
//   如需"VM 执行到中段"的快照，把下面 SNAPSHOT_RVA 设成崩溃点附近 handler 的 RVA。

const MODULE_NAME = 'MaxHook.dll';
const ENCRYPT_RVA = 0x324610;            // 加密入口
const VM_CONTEXT_RVA = 0x98c884;         // VM context（模块内固定地址，里程碑17证明）
const VM_CONTEXT_BYTES = 0x200;
const STACK_LOW = 0x7ffe1fec00;          // VM 数据栈抓取下界
const STACK_HIGH = 0x7ffe1ff000;         // VM 数据栈抓取上界
const MAX_STRING_BYTES = 32 * 1024 * 1024;

// 中段 hook 点：已禁用。
// 原因：.bugland 里的 VM handler 用 Interceptor.attach 会改指令触发 Themida 自校验，
// 直接崩游戏（实测）。因此只保留加密入口（.text 明文区）的安全 hook。
// 之前设 0xbdbb07 会崩，现已置 null。
const MID_SNAPSHOT_RVA = null;

// 中段快照点要记录的寄存器（用于离线模拟器精确对齐同一时刻）。
const REG_NAMES = ['rax','rbx','rcx','rdx','rsi','rdi','r8','r9','r10','r11','r12','r13','r14','r15'];

let installed = false;
let midInstalled = false;
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

function safeBytes(address, size) {
  try { return address.readByteArray(size); } catch (_) { return null; }
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
      call_id: callId, phase: phase, label: label,
      object_pointer: value.object, data_pointer: value.data,
      size: value.size, capacity: value.capacity
    }, value.bytes);
    return true;
  } catch (error) {
    emit('encrypt_string_error', {
      call_id: callId, phase: phase, label: label,
      object_pointer: safePointer(objectPointer), error: String(error)
    });
    return false;
  }
}

// 只读抓 VM context + 数据栈，emit 成带地址的事件。
// 栈范围基于真实 rsp 动态算：抓 rsp 上下各一段，而不是硬编码 0x7ffe1fec00。
function emitVmState(kind, callId, moduleBase, rspValue) {
  const ctxAddr = moduleBase.add(VM_CONTEXT_RVA);
  emit(kind + '_context', {
    call_id: callId,
    address: ctxAddr.toString(),
    size: VM_CONTEXT_BYTES
  }, safeBytes(ctxAddr, VM_CONTEXT_BYTES));

  // 数据栈：抓 rsp 以下 0x200 到 rsp 以上 0x2000（覆盖 VM 数据栈的压栈区）。
  // rsp 是 UInt64/ptr，做加减要小心。
  const rspPtr = rspValue === undefined ? null : ptr(rspValue);
  if (rspPtr !== null) {
    const low = rspPtr.sub(0x200);
    const size = 0x2200;
    emit(kind + '_stack', {
      call_id: callId,
      address: low.toString(),
      size: size,
      rsp_at_capture: rspPtr.toString()
    }, safeBytes(low, size));
  }
}

function install(module) {
  if (installed) return;
  installed = true;
  if (Process.pointerSize !== 8) {
    emit('fatal', { error: 'this hook requires an x64 process' });
    return;
  }
  if (ENCRYPT_RVA >= module.size) {
    emit('fatal', { error: 'encrypt RVA is outside the loaded module', module_size: module.size });
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
    vm_context_rva: '0x' + VM_CONTEXT_RVA.toString(16),
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

      // 关键新增：只读抓 VM context 初始态 + 数据栈（基于真实 rsp）
      emitVmState('vm_enter', this.callId, module.base, this.context.rsp.toString());
    },
    onLeave(retval) {
      emitString(this.callId, 'output', 'kid_hex', this.output);
      emitString(this.callId, 'output', 'nonce_hex', this.output.add(0x20));
      emitString(this.callId, 'output', 'ciphertext_hex', this.output.add(0x40));
      emitString(this.callId, 'output', 'tag_hex', this.output.add(0x60));
      emit('encrypt_leave', { call_id: this.callId, retval: retval.toString() });
    }
  });

  // 可选：VM 中段快照点。VM 执行到该 handler 时，抓"推进后"的 context + 栈 + 寄存器。
  if (MID_SNAPSHOT_RVA !== null && MID_SNAPSHOT_RVA < module.size) {
    const midAddress = module.base.add(MID_SNAPSHOT_RVA);
    try {
      Interceptor.attach(midAddress, {
        onEnter() {
          const ctx = this.context;
          // 只读抓取：context + 栈 + 关键寄存器，不修改任何状态。
          const regs = {};
          REG_NAMES.forEach(function (name) {
            try { regs[name] = ctx[name].toString(); } catch (_) {}
          });
          regs.rsp = ctx.rsp.toString();
          regs.rbp = ctx.rbp.toString();
          regs.rip = ctx.pc.toString();
          emit('vm_mid_hit', {
            address: midAddress.toString(),
            rva: '0x' + MID_SNAPSHOT_RVA.toString(16),
            registers: regs
          });
          emitVmState('vm_mid', 0, module.base);
        }
      });
      midInstalled = true;
      emit('vm_mid_installed', {
        address: midAddress.toString(),
        rva: '0x' + MID_SNAPSHOT_RVA.toString(16)
      });
    } catch (error) {
      emit('vm_mid_install_error', {
        address: midAddress.toString(),
        error: String(error)
      });
    }
  }
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
