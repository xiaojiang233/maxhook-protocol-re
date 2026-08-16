# -*- coding: utf-8 -*-
"""
phase2_final3.py — 跳过 PHASE1，使用运行时 .bugland 快照做诊断模拟。

重要限制：runtime_bugland2.bin 是一次较晚运行时刻的内存终态，不是模块入口态。
除非同时通过 PHASE2_* 寄存器参数恢复同一时刻的完整线程上下文和栈，否则从
PE_MODULE_ENTRY 重启只能用于定位缺失依赖，不能证明 VM rolling key 的性质。
"""
import json, struct, time, os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from unicorn import *
from unicorn.x86_const import *
from winenv import WinEnv

path = r'E:/MCLDownload/Game/.minecraft/native/MaxHook.dll'
data = open(path, 'rb').read()
CAPTURE_JSON_PATH = os.environ.get('PHASE2_CONTEXT_JSON', '')
CAPTURE_JSON = None
if CAPTURE_JSON_PATH:
    with open(CAPTURE_JSON_PATH, encoding='utf-8') as capture_stream:
        CAPTURE_JSON = json.load(capture_stream)
    if CAPTURE_JSON.get('schema') != 'maxhook.pss.capture/v1':
        raise ValueError(f"unsupported capture schema: {CAPTURE_JSON.get('schema')!r}")
default_bugland = r'E:/Coding/S1mple/target/runtime_bugland2.bin'
if CAPTURE_JSON:
    capture_bugland = CAPTURE_JSON.get('memory', {}).get('bugland', {}).get('file')
    if capture_bugland:
        default_bugland = os.path.join(os.path.dirname(CAPTURE_JSON_PATH), capture_bugland)
BUGLAND_PATH = os.environ.get('PHASE2_BUGLAND', default_bugland)
boot = open(BUGLAND_PATH, 'rb').read()
BASE = 0x180000000
STACK_BASE = 0x7FFE000000
STACK_SIZE = 0x800000
RSP = STACK_BASE + STACK_SIZE - 0x1008  # x64 函数入口要求 RSP % 16 == 8
PE_MODULE_ENTRY = 0x180C0EB27
REAL_ENTRY = int(os.environ.get('PHASE2_ENTRY', hex(PE_MODULE_ENTRY)), 0)
VM_RBP = int(os.environ.get('PHASE2_RBP', '0x18098C884'), 0)
MAX_BLOCKS = int(os.environ.get('PHASE2_MAX_BLOCKS', '200'), 0)
LOG_EVERY = max(1, int(os.environ.get('PHASE2_LOG_EVERY', '1'), 0))
CHUNK = int(os.environ.get('PHASE2_CHUNK', '100000000'), 0)
EMU_TIMEOUT_US = int(os.environ.get('PHASE2_TIMEOUT_US', '30000'), 0)
ZERO_FILL_UNMAPPED = os.environ.get('PHASE2_ZERO_FILL_UNMAPPED', '0') == '1'
MEM_DUMP_PATH = os.environ.get(
    'PHASE2_MEM_DUMP',
    r'E:/Coding/S1mple/target/vm_final_mem.bin',
)
ANALYZE_DUMP = os.environ.get('PHASE2_ANALYZE_DUMP', '1') != '0'
TIME_FILETIME = int(os.environ.get('PHASE2_FILETIME', '0'), 0)
if not TIME_FILETIME:
    TIME_FILETIME = int(time.time() * 10000000) + 116444736000000000

e_lfanew = struct.unpack('<I', data[0x3C:0x40])[0]
coff = e_lfanew + 4
_, nsects, _, _, _, _, _ = struct.unpack('<HHIIIHH', data[coff:coff+20])
opt = coff + 20
sec_off = opt + 240
sections = []
for i in range(nsects):
    name = data[sec_off+i*40:sec_off+i*40+8].rstrip(b'\x00').decode(errors='replace')
    vsize, vaddr, rsize, raddr = struct.unpack('<IIII', data[sec_off+i*40+8:sec_off+i*40+24])
    sections.append((name, vaddr, vsize, raddr, rsize))

print(f"[*] 构建内存 (跳过 PHASE1, bugland={BUGLAND_PATH})", flush=True)
uc = Uc(UC_ARCH_X86, UC_MODE_64)
TOTAL = (max(vaddr + vsize for _, vaddr, vsize, _, _ in sections) + 0xFFF) & ~0xFFF
uc.mem_map(BASE, TOTAL)
uc.mem_write(BASE, data)
for name, vaddr, vsize, raddr, rsize in sections:
    va = BASE + vaddr
    if rsize > 0: uc.mem_write(va, data[raddr:raddr+rsize])
    if vsize > rsize: uc.mem_write(va + rsize, b'\x00' * (vsize - rsize))
# .bugland 用解压产物
uc.mem_write(BASE + 0x980000, boot)
uc.mem_map(STACK_BASE, STACK_SIZE)
uc.reg_write(UC_X86_REG_RSP, RSP)
# 返回地址 + 32 字节 shadow space。DllMain 的参数属于寄存器，不属于栈参数。
uc.mem_write(RSP, struct.pack('<QQQQQ', 0, 0, 0, 0, 0))
if REAL_ENTRY == PE_MODULE_ENTRY:
    uc.reg_write(UC_X86_REG_RCX, BASE)
    uc.reg_write(UC_X86_REG_RDX, 1)  # DLL_PROCESS_ATTACH
    uc.reg_write(UC_X86_REG_R8, 0)
print(f"[*] 内存构建完成 TOTAL={TOTAL:#x}", flush=True)

env = WinEnv(uc, RSP, log=lambda *a: None)
K32 = 0x7FFC00000000; NTD = 0x7FFB00000000; WHT = 0x7FFA00000000
WS2 = 0x7FF900000000; IPH = 0x7FF800000000; VER = 0x7FF700000000
ADV = 0x7FF600000000; USR = 0x7FF500000000; OLE = 0x7FF400000000; JVM = 0x7FF300000000
for name, base in [('kernel32.dll', K32), ('ntdll.dll', NTD), ('winhttp.dll', WHT),
                   ('ws2_32.dll', WS2), ('iphlpapi.dll', IPH), ('version.dll', VER),
                   ('advapi32.dll', ADV), ('user32.dll', USR), ('ole32.dll', OLE)]:
    env.map_dll(name, base)

def make_fake_dll_pe():
    n = 1; sect_vsize = 0x2000; sect_rsize = 0x2000
    exp_rva = 0x1000 + 0x40; name_table = exp_rva + 0x40
    func_table = name_table + n*4; ord_table = func_table + n*4; str_base = ord_table + n*2
    blob = bytearray(sect_rsize + 0x200)
    blob[0:2] = b'MZ'; blob[0x3C:0x40] = struct.pack('<I', 0x40)
    blob[0x40:0x44] = b'PE\x00\x00'; blob[0x44:0x46] = struct.pack('<H', 0x8664)
    blob[0x46:0x48] = struct.pack('<H', 1)
    blob[0x54:0x56] = struct.pack('<H', 0xF0); blob[0x56:0x58] = struct.pack('<H', 0x22)
    o = 0x60
    blob[o:o+2] = struct.pack('<H', 0x20B); blob[o+16:o+20] = struct.pack('<I', 0x1000)
    blob[o+24:o+32] = struct.pack('<Q', JVM); blob[o+32:o+36] = struct.pack('<I', 0x1000)
    blob[o+36:o+40] = struct.pack('<I', 0x200); blob[o+56:o+60] = struct.pack('<H', 6)
    blob[o+64:o+68] = struct.pack('<I', sect_vsize)
    blob[o+112:o+116] = struct.pack('<I', exp_rva); blob[o+116:o+120] = struct.pack('<I', 0x40+n*12+64)
    sct = o + 240
    blob[sct:sct+8] = b'.text\x00\x00\x00'
    blob[sct+8:sct+12] = struct.pack('<I', sect_vsize); blob[sct+12:sct+16] = struct.pack('<I', 0x1000)
    blob[sct+16:sct+20] = struct.pack('<I', sect_rsize); blob[sct+20:sct+24] = struct.pack('<I', 0x200)
    blob[sct+36:sct+40] = struct.pack('<I', 0x60000020)
    bo = 0x200
    blob[bo+0x00:bo+0x04] = struct.pack('<I', 0); blob[bo+0x0C:bo+0x10] = struct.pack('<I', 1)
    blob[bo+0x10:bo+0x14] = struct.pack('<I', n)
    blob[bo+0x14:bo+0x18] = struct.pack('<I', func_table); blob[bo+0x18:bo+0x1C] = struct.pack('<I', name_table)
    blob[bo+0x1C:bo+0x20] = struct.pack('<I', ord_table)
    blob[bo+0x00] = 0x31; blob[bo+0x01] = 0xC0; blob[bo+0x02] = 0xC3
    blob[bo+(func_table-0x1000):bo+(func_table-0x1000)+4] = struct.pack('<I', 0x1000)
    nmb = b'JNI_GetCreatedJavaVMs\x00'
    blob[bo+(name_table-0x1000):bo+(name_table-0x1000)+4] = struct.pack('<I', str_base)
    blob[bo+(ord_table-0x1000):bo+(ord_table-0x1000)+2] = struct.pack('<H', 0)
    blob[bo+(str_base-0x1000):bo+(str_base-0x1000)+len(nmb)] = nmb
    return bytes(blob)

jvm_blob = make_fake_dll_pe()
env._ensure_map(JVM, JVM + 0x3000)
env.uc.mem_write(JVM + 0x1000, jvm_blob[0x200:0x200+0x2000])
env.dlls['jvm.dll'] = {'base': JVM, 'size': 0x3000, 'exports': {'JNI_GetCreatedJavaVMs': 0x1000}, 'orde': {}, 'path': '', 'image_base': JVM}

F = 0x7FF200000000
env._ensure_map(F, F + 0x100000)
def rd(addr, n=8): return int.from_bytes(uc.mem_read(addr, n), 'little')
def wr(addr, v): uc.mem_write(addr, struct.pack('<Q', v & 0xFFFFFFFFFFFFFFFF))
def wr32(addr, v): uc.mem_write(addr, struct.pack('<I', v & 0xFFFFFFFF))

def _copy_memory(a):
    dst, src, count = a[0], a[1], a[2]
    if count:
        uc.mem_write(dst, bytes(uc.mem_read(src, count)))
    return dst

def _zero_memory(a):
    dst, count = a[0], a[1]
    if count:
        uc.mem_write(dst, b'\x00' * count)
    return dst

def _set_memory(a):
    dst, value, count = a[0], a[1] & 0xFF, a[2]
    if count:
        uc.mem_write(dst, bytes([value]) * count)
    return dst

base_ft = TIME_FILETIME
def _time_ft(a):
    global base_ft
    base_ft += 10000
    wr(a[0], base_ft)
    return 0
def _tick():
    env.ticks += 16
    return env.ticks
def _qpc(a):
    env.qpc += 100000
    wr(a[0], env.qpc)
    return 0

env.api_impl.update({
 'GetProcAddress': lambda a: _gp(a),
 'GetModuleHandleA': lambda a: _gmh(a, 0),
 'GetModuleHandleW': lambda a: _gmh(a, 1),
 'LoadLibraryA': lambda a: _ll(a, 0),
 'LoadLibraryW': lambda a: _ll(a, 1),
 'GetModuleFileNameA': lambda a: _gmn(a, 0),
 'GetModuleFileNameW': lambda a: _gmn(a, 1),
 'VirtualAlloc': lambda a: _va(a),
 'VirtualFree': lambda a: 1,
 'VirtualProtect': lambda a: (wr32(a[3], 0x40), 1)[1],
 'HeapAlloc': lambda a: env.alloc(a[2] or 1),
 'HeapFree': lambda a: 1,
 'GetProcessHeap': lambda a: F + 0x9000,
 'GetSystemTimeAsFileTime': lambda a: _time_ft(a),
 'GetSystemTimePreciseAsFileTime': lambda a: _time_ft(a),
 'GetTickCount': lambda a: _tick(),
 'GetTickCount64': lambda a: _tick(),
 'QueryPerformanceCounter': lambda a: _qpc(a),
 'QueryPerformanceFrequency': lambda a: (wr(a[0], 10000000), 1)[1],
 'GetCurrentProcessId': lambda a: 0x1234,
 'GetCurrentThreadId': lambda a: 0x5678,
 'IsDebuggerPresent': lambda a: 0,
 'GetLastError': lambda a: 0,
 'SetLastError': lambda a: 0,
 'GetStartupInfoA': lambda a: 0,
 'GetCommandLineA': lambda a: F + 0xA000,
 'GetCommandLineW': lambda a: F + 0xA100,
 'OutputDebugStringA': lambda a: 0,
 'OutputDebugStringW': lambda a: 0,
 'GetEnvironmentVariableA': lambda a: 0,
 'GetEnvironmentVariableW': lambda a: 0,
 'SetEnvironmentVariableA': lambda a: 1,
 'SetEnvironmentVariableW': lambda a: 1,
 'lstrlenA': lambda a: len(env.read_cstr(a[0])),
 'lstrlenW': lambda a: len(env.read_wstr(a[0])),
 'GetFileVersionInfoSizeA': lambda a: 0,
 'GetFileVersionInfoA': lambda a: 0,
 'GetFileVersionInfoSizeW': lambda a: 0,
 'GetFileVersionInfoW': lambda a: 0,
 'VerQueryValueA': lambda a: 0,
 'VerQueryValueW': lambda a: 0,
 'GetAdaptersAddresses': lambda a: 111,
 'inet_ntop': lambda a: 0,
 'RegGetValueW': lambda a: 2,
 'CoCreateInstance': lambda a: 0x80004002,
 'MessageBoxA': lambda a: 0,
 'JNI_GetCreatedJavaVMs': lambda a: _jni_getvms(a),
 'WSAStartup': lambda a: 0,
 'WSACleanup': lambda a: 0,
 'socket': lambda a: F + 0x50000 + 1,
 'closesocket': lambda a: 0,
 'connect': lambda a: 0,
 'send': lambda a: a[2],
 'recv': lambda a: 0,
 'getaddrinfo': lambda a: 0x2A,
 'freeaddrinfo': lambda a: 0,
 'gethostbyname': lambda a: 0,
 'htons': lambda a: ((a[0] & 0xFF) << 8) | ((a[0] >> 8) & 0xFF),
 'ntohs': lambda a: ((a[0] & 0xFF) << 8) | ((a[0] >> 8) & 0xFF),
 'inet_addr': lambda a: 0,
 'WSAGetLastError': lambda a: 0,
 'RtlAllocateHeap': lambda a: env.alloc(a[2] or 1),
 'RtlFreeHeap': lambda a: 1,
 'RtlGetCurrentPeb': lambda a: env.peb,
 'RtlInitUnicodeString': lambda a: (wr(a[0]+0x08, a[2]), 0)[1],
 'RtlEnterCriticalSection': lambda a: 0,
 'RtlLeaveCriticalSection': lambda a: 0,
 'RtlInitializeCriticalSection': lambda a: 0,
 'RtlDeleteCriticalSection': lambda a: 0,
 'RtlUnwind': lambda a: 0,
 'NtClose': lambda a: 0,
 'NtQueryInformationProcess': lambda a: 0xC0000003,
 'NtQuerySystemInformation': lambda a: 0xC0000003,
 'NtAllocateVirtualMemory': lambda a: 0xC0000005,
 'NtFreeVirtualMemory': lambda a: 0,
 'NtProtectVirtualMemory': lambda a: 0xC0000005,
 'NtQueryVirtualMemory': lambda a: 0xC0000003,
 'NtQueryObject': lambda a: 0xC0000003,
 'NtOpenProcess': lambda a: 0xC0000022,
 'NtQueryInformationThread': lambda a: 0xC0000003,
 'NtSetInformationThread': lambda a: 0,
 'NtQuerySystemTime': lambda a: 0,
 'RtlQueryTimeZoneInformation': lambda a: 0,
 'RtlGetVersion': lambda a: 0,
 'RtlZeroMemory': lambda a: _zero_memory(a),
 'RtlCopyMemory': lambda a: _copy_memory(a),
 'memcpy': lambda a: _copy_memory(a),
 'memset': lambda a: _set_memory(a),
 'RtlNtStatusToDosError': lambda a: 0,
 'RtlGetLastWin32Error': lambda a: 0,
 'RtlSetLastWin32Error': lambda a: 0,
 'NtGetContextThread': lambda a: 0xC0000003,
 'NtSetContextThread': lambda a: 0xC0000003,
 'NtReadVirtualMemory': lambda a: 0xC0000005,
 'NtWriteVirtualMemory': lambda a: 0xC0000005,
 'NtCreateThreadEx': lambda a: 0,
 'RtlCreateUserThread': lambda a: 0,
 'NtSuspendThread': lambda a: 0,
 'NtResumeThread': lambda a: 0,
 'RtlAddVectoredExceptionHandler': lambda a: 1,
 'RtlRemoveVectoredExceptionHandler': lambda a: 1,
 'RtlRaiseException': lambda a: 0,
 'KiUserExceptionDispatcher': lambda a: 0,
 'ZwQueryInformationProcess': lambda a: 0xC0000003,
 'ZwQuerySystemInformation': lambda a: 0xC0000003,
})

def _gp(a):
    mod = a[0]; name = env.read_cstr(a[1])
    for dll in env.dlls.values():
        if mod == 0 or dll['base'] == mod:
            if name in dll['exports']:
                return dll['base'] + dll['exports'][name]
    return 0
def _gmh(a, wide):
    nm = env.read_wstr(a[0]) if wide else env.read_cstr(a[0])
    if nm:
        ln = nm.lower()
        for key, dll in env.dlls.items():
            if key.split('\\')[-1].lower() == ln or key.lower() == ln:
                return dll['base']
        return 0
    return BASE
def _ll(a, wide):
    nm = env.read_wstr(a[0]) if wide else env.read_cstr(a[0])
    if not nm: return 0
    if 'jvm' in nm.lower(): return JVM
    for key, dll in env.dlls.items():
        if key.split('\\')[-1].lower() == nm.lower():
            return dll['base']
    return 0
def _gmn(a, wide):
    mod = a[0]; buf = a[1]; size = a[2]
    name = 'E:\\MCLDownload\\Game\\.minecraft\\native\\MaxHook.dll' if mod in (BASE, 0) else ''
    if mod == JVM: name = 'C:\\Program Files\\Java\\jvm.dll'
    d2 = name.encode('utf-16-le') if wide else name.encode()
    try: uc.mem_write(buf, d2[:max(0,size-2)] + b'\x00\x00')
    except UcError: pass
    return len(name)
def _va(a):
    addr = a[0]; size = a[1]
    if addr == 0:
        addr = env.alloc(size or 0x1000)
    else:
        env._ensure_map(addr, addr + (size or 0x1000))
    return addr
def _jni_getvms(a):
    wr(a[0], F + 0x30000)
    if a[2]: wr(a[2], 1)
    return 0

JNI_VTABLE = F + 0x10000; JNI_ENV = F + 0x20000
JVM_OBJ = F + 0x30000; JVM_VTABLE = F + 0x40000
for i in range(233): wr(JNI_VTABLE + i*8, JNI_VTABLE + i*8)
wr(JNI_ENV, JNI_VTABLE)
for i in range(7): wr(JVM_VTABLE + i*8, JVM_VTABLE + i*8)
wr(JVM_OBJ, JVM_VTABLE)

def on_code_all(uc, address, size, ud):
    if JNI_VTABLE <= address < JNI_VTABLE + 0x800:
        rsp = uc.reg_read(UC_X86_REG_RSP); ret = rd(rsp)
        uc.reg_write(UC_X86_REG_RAX, 0)
        uc.reg_write(UC_X86_REG_RIP, ret); uc.reg_write(UC_X86_REG_RSP, rsp + 8)
        return
    if JVM_VTABLE <= address < JVM_VTABLE + 0x40:
        idx = (address - JVM_VTABLE) // 8
        rsp = uc.reg_read(UC_X86_REG_RSP); ret = rd(rsp)
        if idx == 3: wr(uc.reg_read(UC_X86_REG_RDX), JNI_ENV)
        if idx == 4: wr(uc.reg_read(UC_X86_REG_RDX), JNI_ENV)
        uc.reg_write(UC_X86_REG_RAX, 0)
        uc.reg_write(UC_X86_REG_RIP, ret); uc.reg_write(UC_X86_REG_RSP, rsp + 8)
        return
    env._dispatch(address)
uc.hook_add(UC_HOOK_CODE, on_code_all)

# RDTSC/CPUID 逐点 hook (明文区)
def find_patterns(region, base_addr):
    r = []; c = []
    for i in range(len(region)-4):
        if region[i] == 0x0F and region[i+1] == 0x31: r.append(base_addr + i)
        if region[i] == 0x0F and region[i+1] == 0xA2: c.append(base_addr + i)
    return r, c
rdtsc_pts = set(); cpuid_pts = set()
r1, c1 = find_patterns(boot, BASE + 0x980000)
rdtsc_pts.update(r1); cpuid_pts.update(c1)
r2, c2 = find_patterns(data[0x400:0x400+0x5c2800], BASE + 0x10000)
rdtsc_pts.update(r2); cpuid_pts.update(c2)
print(f"[RDTSC/CPUID: {len(rdtsc_pts)}/{len(cpuid_pts)}]", flush=True)
tsc_counter = {'n': 0}
def on_rdtsc(uc, address, size, ud):
    if address not in rdtsc_pts: return
    tsc_counter['n'] += 1
    env.tsc += 0x100000
    uc.reg_write(UC_X86_REG_EAX, env.tsc & 0xFFFFFFFF)
    uc.reg_write(UC_X86_REG_EDX, (env.tsc >> 32) & 0xFFFFFFFF)
    uc.reg_write(UC_X86_REG_RIP, address + 2)
def on_cpuid(uc, address, size, ud):
    if address not in cpuid_pts: return
    eax_in = uc.reg_read(UC_X86_REG_EAX) & 0xFFFFFFFF
    if eax_in == 0:
        uc.reg_write(UC_X86_REG_EAX, 0x16); uc.reg_write(UC_X86_REG_EBX, 0x756E6547)
        uc.reg_write(UC_X86_REG_EDX, 0x49656E69); uc.reg_write(UC_X86_REG_ECX, 0x6C65746E)
    elif eax_in == 1:
        uc.reg_write(UC_X86_REG_EAX, 0x000906EA); uc.reg_write(UC_X86_REG_EBX, 0x02100800)
        uc.reg_write(UC_X86_REG_ECX, 0x7FFAFBFF & ~0x80000000); uc.reg_write(UC_X86_REG_EDX, 0xBFEBFBFF)
    elif eax_in == 7:
        uc.reg_write(UC_X86_REG_EAX, 0); uc.reg_write(UC_X86_REG_EBX, 0xD3C27FBF)
        uc.reg_write(UC_X86_REG_ECX, 0); uc.reg_write(UC_X86_REG_EDX, 0x1C000000)
    else:
        uc.reg_write(UC_X86_REG_EAX, 0); uc.reg_write(UC_X86_REG_EBX, 0)
        uc.reg_write(UC_X86_REG_ECX, 0); uc.reg_write(UC_X86_REG_EDX, 0)
    uc.reg_write(UC_X86_REG_RIP, address + 2)
for pt in sorted(rdtsc_pts):
    uc.hook_add(UC_HOOK_CODE, on_rdtsc, begin=pt, end=pt+1)
for pt in sorted(cpuid_pts):
    uc.hook_add(UC_HOOK_CODE, on_cpuid, begin=pt, end=pt+1)
print("[hooks 完成]", flush=True)

# PEB/TEB + KUSER_SHARED_DATA
mods = [('MaxHook.dll', BASE, TOTAL, PE_MODULE_ENTRY)]
for key, dll in env.dlls.items():
    mods.append((key, dll['base'], dll['size'], 0))
env.build_peb_teb(modules=mods)
pp = env.peb + 0x3000
cur = pp + 0x1000
def wstr2(addr, s):
    global cur
    b = s.encode('utf-16-le') + b'\x00\x00'
    uc.mem_write(cur, b)
    uc.mem_write(addr, struct.pack('<HHQ', len(s)*2, len(s)*2+2, cur))
    cur += len(b)
uc.mem_write(pp + 0x00, struct.pack('<I', 0x100))
uc.mem_write(pp + 0x04, struct.pack('<I', 0x100))
wstr2(pp + 0x10, 'C:\\Windows\\System32\\MaxHook.dll')
wstr2(pp + 0x20, 'MaxHook.dll')
uc.mem_write(pp + 0x80, struct.pack('<Q', pp + 0x2000))
uc.mem_write(pp + 0x2000, b'Path=C:\\Windows\\System32\x00\x00')
uc.mem_write(env.peb + 0x1C, struct.pack('<I', 0x1))
uc.mem_write(env.peb + 0x3C, struct.pack('<I', 0))
uc.mem_write(F + 0xA000, b'"MaxHook.dll"\x00')
uc.mem_write(F + 0xA100, '"MaxHook.dll"\x00'.encode('utf-16-le') + b'\x00\x00')
KUSD = 0x7FFE0000
env._ensure_map(KUSD, KUSD + 0x4000)
now = TIME_FILETIME
uc.mem_write(KUSD + 0x14, struct.pack('<Q', now))
uc.mem_write(KUSD + 0x20, struct.pack('<i', -480))
uc.mem_write(KUSD + 0x2C, struct.pack('<I', 10000000))
uc.mem_write(KUSD + 0x34, struct.pack('<I', 0))
print("[环境完成]", flush=True)

# ============ 从真实入口开始 ============
trace = []; CRASH = {}
def on_trace(uc, address, size, ud):
    trace.append(address)
    if len(trace) > 400000: del trace[:-200000]
def on_fetch(uc, access, address, size, value, ud):
    for r, n in [(UC_X86_REG_RAX,'rax'),(UC_X86_REG_RBX,'rbx'),(UC_X86_REG_RCX,'rcx'),(UC_X86_REG_RDX,'rdx'),
                 (UC_X86_REG_RSI,'rsi'),(UC_X86_REG_RDI,'rdi'),(UC_X86_REG_RBP,'rbp'),(UC_X86_REG_RSP,'rsp'),
                 (UC_X86_REG_R8,'r8'),(UC_X86_REG_R9,'r9'),(UC_X86_REG_R10,'r10'),(UC_X86_REG_R11,'r11'),
                 (UC_X86_REG_R12,'r12'),(UC_X86_REG_R13,'r13'),(UC_X86_REG_R14,'r14'),(UC_X86_REG_R15,'r15'),
                 (UC_X86_REG_RIP,'rip')]:
        CRASH[n] = uc.reg_read(r)
    CRASH['fetch'] = address
    CRASH['last'] = list(trace[-300:])
    return False
uc.hook_add(UC_HOOK_CODE, on_trace)
uc.hook_add(UC_HOOK_MEM_FETCH_UNMAPPED, on_fetch)

# ---------- 按需映射 + 读取追踪 ----------
map_log = []
def on_rd_um(uc, access, address, size, value, ud):
    rip = uc.reg_read(UC_X86_REG_RIP)
    if not ZERO_FILL_UNMAPPED:
        print(f"  [缺失读依赖] addr={address:#x} size={size:#x} RIP={rip:#x}", flush=True)
        return False
    pg = address & ~0xFFF
    try: uc.mem_map(pg, 0x1000)
    except UcError: pass
    if len(map_log) < 20:
        map_log.append(('R', address, rip))
        print(f"  [按需映射R] addr={address:#x} RIP={rip:#x}", flush=True)
    return True
def on_wr_um(uc, access, address, size, value, ud):
    rip = uc.reg_read(UC_X86_REG_RIP)
    if not ZERO_FILL_UNMAPPED:
        print(f"  [缺失写依赖] addr={address:#x} size={size:#x} RIP={rip:#x}", flush=True)
        return False
    pg = address & ~0xFFF
    try: uc.mem_map(pg, 0x1000)
    except UcError: pass
    if len(map_log) < 20:
        map_log.append(('W', address, rip))
        print(f"  [按需映射W] addr={address:#x} RIP={rip:#x}", flush=True)
    return True
def on_fetch_um(uc, access, address, size, value, ud):
    print(f"  [取指未映射] addr={address:#x} RIP={uc.reg_read(UC_X86_REG_RIP):#x}", flush=True)
    return False
uc.hook_add(UC_HOOK_MEM_READ_UNMAPPED, on_rd_um)
uc.hook_add(UC_HOOK_MEM_WRITE_UNMAPPED, on_wr_um)
uc.hook_add(UC_HOOK_MEM_FETCH_UNMAPPED, on_fetch_um)
print(f"[未映射依赖] {'兼容模式：补零页' if ZERO_FILL_UNMAPPED else '严格模式：立即停止'}", flush=True)
# ---------- 预映射 VM 虚拟地址区域 (vmsnap) ----------
import glob as _glob
vmsnap_dir = r'E:/Coding/S1mple/target/monitor_out'
n_files = 0
snap_pages = {}
snap_conflicts = []
for vf in sorted(_glob.glob(vmsnap_dir + '/vmsnap_*.bin')):
    addr = int(os.path.basename(vf)[len('vmsnap_'):len('vmsnap_')+16], 16)
    vdata = open(vf, 'rb').read()
    n_files += 1
    for off in range(0, len(vdata), 0x1000):
        pg = addr + off
        page = vdata[off:off+0x1000].ljust(0x1000, b'\x00')
        old = snap_pages.get(pg)
        if old is None:
            snap_pages[pg] = page
        elif old != page:
            snap_conflicts.append((pg, vf))
n_map = 0
for addr, page in sorted(snap_pages.items()):
    try:
        uc.mem_map(addr, 0x1000)
        uc.mem_write(addr, page)
        n_map += 1
    except UcError:
        pass
print(f"[VM 映射] {n_files} 个文件 -> {n_map}/{len(snap_pages)} 个完整页；重叠冲突 {len(snap_conflicts)}", flush=True)
# ---------- API 分发 ----------
import json as _json
api_map = _json.load(open(r'E:/Coding/S1mple/target/api_map.json'))
api_addr2name = {int(a, 16): n for a, n in api_map.items()}
api_calls = []

def _rd64(addr):
    try: return struct.unpack('<Q', uc.mem_read(addr, 8))[0]
    except Exception: return 0

def _cstr(addr, maxlen=200):
    try:
        b = uc.mem_read(addr, maxlen)
        end = b.find(b'\x00')
        if end < 0: end = len(b)
        return b[:end].decode('utf-16-le' if end > 2 and b[1] == 0 else 'latin1', errors='replace')[:80]
    except Exception: return ''

def on_api_call(uc, address, size, ud):
    name = api_addr2name.get(address, '?')
    if name == '?':
        # 完整导出表识别
        for mn2, (mb2, ms2) in mod_info.items():
            if mb2 <= address < mb2 + ms2:
                ex = mod_exports.get(mn2, {})
                nm2 = ex.get(address - mb2)
                if nm2:
                    name = f"{mn2}!{nm2}"
                else:
                    name = f"{mn2}!+{address-mb2:#x}"
                break
        api_addr2name[address] = name
    func_name = name.rsplit('!', 1)[-1]
    rcx = uc.reg_read(UC_X86_REG_RCX)
    rdx = uc.reg_read(UC_X86_REG_RDX)
    r8 = uc.reg_read(UC_X86_REG_R8)
    r9 = uc.reg_read(UC_X86_REG_R9)
    rsp = uc.reg_read(UC_X86_REG_RSP)
    ret = _rd64(rsp)
    # 参数辅助
    arg1 = _cstr(rcx) if func_name.endswith('W') and rcx and rcx < 0x7ff00000000 else ''
    api_calls.append(name)
    print(f"  [API] {name} @{address:#x} rcx={rcx:#x}{'('+arg1+')' if arg1 else ''} rdx={rdx:#x} r8={r8:#x} r9={r9:#x}", flush=True)
    # 分发
    result = 0
    if func_name == 'SetCurrentDirectoryW':
        result = 1
    elif func_name in ('RtlCopyMemory', 'memcpy'):
        if r8:
            uc.mem_write(rcx, bytes(uc.mem_read(rdx, r8)))
        result = rcx
    elif func_name == 'RtlZeroMemory':
        if rdx:
            uc.mem_write(rcx, b'\x00' * rdx)
        result = rcx
    elif func_name == 'memset':
        if r8:
            uc.mem_write(rcx, bytes([rdx & 0xFF]) * r8)
        result = rcx
    elif func_name in ('VirtualProtect', 'VirtualProtectEx'):
        try: uc.mem_write(r9, struct.pack('<I', 0x40))
        except Exception: pass
        result = 1
    elif func_name in ('CreateEventA', 'SetEvent', 'ResetEvent', 'Thread32First', 'Thread32Next',
                  'RegCloseKey', 'CloseHandle', 'DeleteCriticalSection',
                  'DispatchMessageA', 'PeekMessageA', 'GetMessageA', 'RtlLeaveCriticalSection',
                  'EnterCriticalSection', 'InitializeCriticalSection', 'HeapFree', 'HeapAlloc',
                  'GetLastError', 'SetLastError'):
        if func_name in ('Thread32First', 'Thread32Next'):
            result = 0  # 无更多线程
        elif func_name == 'CreateEventA':
            result = 0x18090f000  # 假句柄
        elif func_name == 'HeapAlloc':
            result = 0x18090f100
        else:
            result = 1
    elif func_name == 'RegCreateKeyA':
        result = 0  # ERROR_SUCCESS
    elif func_name in ('RegSetValueExA', 'RegQueryValueExA'):
        result = 0
    elif func_name == 'GetModuleFileNameW':
        # 写假路径
        try:
            uc.mem_write(rdx, 'C:////Windows////System32////MaxHook.dll'.encode('utf-16-le') + b'\x00\x00')
        except Exception: pass
        result = 32
    elif func_name == 'GetSystemFirmwareTable':
        result = 0  # 无固件表数据
    elif func_name in ('ZwQueryObject', 'NtQueryObject'):
        result = 0
    elif func_name in ('GetCurrentProcess', 'GetCurrentThread'):
        result = 0xffffffffffffffff
    elif func_name in ('GetTickCount', 'GetTickCount64'):
        env.ticks = getattr(env, 'ticks', 0) + 16
        result = env.ticks
    elif func_name in ('GetSystemTimeAsFileTime', 'GetSystemTimePreciseAsFileTime'):
        env.ft = getattr(env, 'ft', 133000000000000000) + 10000
        try:
            uc.mem_write(rcx, struct.pack('<Q', env.ft))
        except Exception: pass
        result = 0
    elif func_name == 'QueryPerformanceCounter':
        env.qpc = getattr(env, 'qpc', 0) + 100000
        try:
            uc.mem_write(rcx, struct.pack('<Q', env.qpc))
        except Exception: pass
        result = 1
    elif func_name in ('GetCurrentTime', 'GetMessageTime'):
        result = getattr(env, 'ticks', 0)
    elif func_name in ('rand', 'srand'):
        result = 0x12345678
    elif func_name == 'GetProcAddress':
        result = 0
    elif func_name in ('LoadLibraryA', 'LoadLibraryW', 'LoadLibraryExA', 'LoadLibraryExW'):
        result = 0
    else:
        result = 0  # 默认 0
    uc.reg_write(UC_X86_REG_RAX, result)
    uc.reg_write(UC_X86_REG_RSP, rsp + 8)
    uc.reg_write(UC_X86_REG_RIP, ret)

# ---------- 完整导出表加载 ----------
def load_exports(path):
    """完整 PE 导出表: {rva: name}"""
    try:
        d = open(path,'rb').read()
        if d[:2] != b'MZ': return {}
        e_lfanew = struct.unpack('<I', d[0x3C:0x40])[0]
        if d[e_lfanew:e_lfanew+4] != b'PE\x00\x00': return {}
        coff = e_lfanew + 4
        _, nsects, _, _, _, optsize, _ = struct.unpack('<HHIIIHH', d[coff:coff+20])
        opt = coff + 20
        sec_off = opt + optsize
        exp_rva, _ = struct.unpack('<II', d[opt+112:opt+120])
        if exp_rva == 0: return {}
        def rva2off(rva):
            for i in range(nsects):
                vs, va, rs, ra = struct.unpack('<IIII', d[sec_off+i*40+8:sec_off+i*40+24])
                if va <= rva < va + vs:
                    return ra + (rva - va)
            return None
        eo = rva2off(exp_rva)
        if eo is None or eo + 40 > len(d): return {}
        nnames = struct.unpack('<I', d[eo+24:eo+28])[0]
        name_rva = struct.unpack('<I', d[eo+32:eo+36])[0]
        ord_rva = struct.unpack('<I', d[eo+36:eo+40])[0]
        func_rva = struct.unpack('<I', d[eo+28:eo+32])[0]
        no_ = rva2off(name_rva); oo = rva2off(ord_rva); fo = rva2off(func_rva)
        if no_ is None or oo is None or fo is None: return {}
        out = {}
        for i in range(min(nnames, 12000)):
            nr = struct.unpack('<I', d[no_+i*4:no_+i*4+4])[0]
            so = rva2off(nr)
            if so is None: continue
            end = d.find(b'\x00', so, so+256)
            if end < 0: continue
            nm = d[so:end].decode(errors='replace')
            ordv = struct.unpack('<H', d[oo+i*2:oo+i*2+2])[0]
            frva = struct.unpack('<I', d[fo+ordv*4:fo+ordv*4+4])[0]
            out[frva] = nm
        return out
    except Exception:
        return {}

# 读取模块表
mods = []
for line in open(r'E:/Coding/S1mple/target/modules_37988.txt', encoding='utf-8'):
    parts = line.strip().split(',')
    if len(parts) >= 4:
        mods.append((int(parts[0], 16), int(parts[1], 16), parts[2].lower(), parts[3]))

# 只处理有 API 指针的模块 + 关键系统 DLL
API_MODS = {'kernel32.dll','ntdll.dll','kernelbase.dll','user32.dll','advapi32.dll',
            'ole32.dll','oleaut32.dll','ws2_32.dll','winhttp.dll','iphlpapi.dll',
            'ucrtbase.dll','combase.dll','jvm.dll','version.dll','comctl32.dll',
            'vcruntime140.dll','jli.dll','msvcp140.dll','gdi32.dll','sechost.dll',
            'rpcrt4.dll','shell32.dll','bcryptprimitives.dll','dbghelp.dll'}
mod_exports = {}  # name -> {rva: funcname}
mod_info = {}     # name -> (base, size)
for mb, ms, mn, mp in mods:
    short = mn.split('\\')[-1] if mn else ''
    if mn in API_MODS or (short and short.lower() in API_MODS):
        mod_exports[mn] = load_exports(mp)
        mod_info[mn] = (mb, ms)
print(f"[导出表] 已加载 {len(mod_exports)} 个模块导出", flush=True)

# 映射模块范围 + hook 所有导出函数
n_api = 0
for mn, (mb, ms) in mod_info.items():
    # 映射整个模块范围以便 exact-address hook 生效；填 INT3，避免未实现的
    # 模块内部调用静默穿过 NOP 海并伪造出可继续执行的状态。
    cur = mb
    end = mb + ms
    while cur < end:
        sz = min(0x400000, end - cur)
        try:
            uc.mem_map(cur, sz)
            uc.mem_write(cur, b'\xCC' * sz)
        except UcError:
            pass
        cur += sz
    # hook 导出函数
    for rva in mod_exports[mn]:
        addr = mb + rva
        try:
            uc.hook_add(UC_HOOK_CODE, on_api_call, begin=addr, end=addr+1)
            n_api += 1
        except Exception:
            pass
print(f"[API 分发] {n_api} 个导出函数已挂载", flush=True)

REGISTER_IDS = {
    'rax': UC_X86_REG_RAX, 'rbx': UC_X86_REG_RBX,
    'rcx': UC_X86_REG_RCX, 'rdx': UC_X86_REG_RDX,
    'rsi': UC_X86_REG_RSI, 'rdi': UC_X86_REG_RDI,
    'rsp': UC_X86_REG_RSP, 'rbp': UC_X86_REG_RBP,
    'r8': UC_X86_REG_R8, 'r9': UC_X86_REG_R9,
    'r10': UC_X86_REG_R10, 'r11': UC_X86_REG_R11,
    'r12': UC_X86_REG_R12, 'r13': UC_X86_REG_R13,
    'r14': UC_X86_REG_R14, 'r15': UC_X86_REG_R15,
    'rip': UC_X86_REG_RIP, 'rflags': UC_X86_REG_EFLAGS,
}

def restore_pss_capture(capture):
    """Restore a same-epoch PSS register set and selected thread stack."""
    capture_dir = os.path.dirname(os.path.abspath(CAPTURE_JSON_PATH))
    selected_id = capture.get('selected_thread_id')
    selected = next(
        (t for t in capture.get('threads', []) if t.get('thread_id') == selected_id),
        None,
    )
    if selected and isinstance(selected.get('stack'), dict):
        stack_meta = selected['stack']
        stack_file = stack_meta.get('file')
        stack_base = int(stack_meta.get('base', '0'), 0)
        if stack_file and stack_base:
            stack_data = open(os.path.join(capture_dir, stack_file), 'rb').read()
            map_base = stack_base & ~0xFFF
            prefix = stack_base - map_base
            env._ensure_map(map_base, map_base + prefix + len(stack_data))
            uc.mem_write(stack_base, stack_data)
            print(
                f"[PSS] restored thread {selected_id} stack "
                f"{stack_base:#x}+{len(stack_data):#x}",
                flush=True,
            )
    registers = capture.get('selected_registers')
    if not registers and selected:
        registers = selected.get('registers')
    if not registers:
        raise ValueError('capture has no selected_registers')
    for name, reg_id in REGISTER_IDS.items():
        if name in registers:
            uc.reg_write(reg_id, int(registers[name], 0))
    return int(registers['rip'], 0), int(registers['rsp'], 0)

if CAPTURE_JSON:
    start_rip, start_rsp = restore_pss_capture(CAPTURE_JSON)
    print(f"[*] same-epoch PSS context: RSP={start_rsp:#x} RIP={start_rip:#x}", flush=True)
else:
    # Legacy diagnostic mode.  This does not make the late memory snapshot an
    # entry-time state and must not be used to infer rolling-key impossibility.
    uc.reg_write(UC_X86_REG_RBP, VM_RBP)
    uc.reg_write(UC_X86_REG_RIP, REAL_ENTRY)
    print(f"[*] legacy mixed-epoch mode: rbp={VM_RBP:#x} RIP={REAL_ENTRY:#x}", flush=True)
t0 = time.time()
try:
    for blk in range(MAX_BLOCKS):
        uc.emu_start(
            uc.reg_read(UC_X86_REG_RIP),
            0,
            timeout=EMU_TIMEOUT_US,
            count=CHUNK,
        )
        rip = uc.reg_read(UC_X86_REG_RIP)
        if blk % LOG_EVERY == 0:
            print(f"[*] 块 {blk}: RIP=0x{rip:x} tsc={tsc_counter['n']} {time.time()-t0:.1f}s", flush=True)
        if rip == 0:
            print(f"=== RIP=0, 最后执行 {len(trace)} 条 ===", flush=True)
            from capstone import Cs, CS_ARCH_X86, CS_MODE_64
            md = Cs(CS_ARCH_X86, CS_MODE_64)
            for addr in trace[-40:]:
                off = addr - (BASE + 0x980000)
                if 0 <= off < len(boot):
                    insn = next(iter(md.disasm(boot[off:off+16], addr, count=1)), None)
                    if insn: print(f"  {addr:#x}: {insn.mnemonic:8s} {insn.op_str}", flush=True)
            break
except UcError as e:
    print(f"[!] UcError {e} RIP=0x{uc.reg_read(UC_X86_REG_RIP):x} {time.time()-t0:.1f}s tsc={tsc_counter['n']}", flush=True)

if CRASH:
    print("\n=== 崩溃现场 ===", flush=True)
    for k, v in CRASH.items():
        if k != 'last': print(f"   {k} = {v:#x}", flush=True)
    try:
        print(f"   [rsp] 附近: {uc.mem_read(CRASH['rsp'], 64).hex()}", flush=True)
    except Exception: pass
    from capstone import Cs, CS_ARCH_X86, CS_MODE_64
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    print("\n=== 崩溃前最后 60 条 ===", flush=True)
    for addr in CRASH['last'][-60:]:
        try:
            off = addr - (BASE + 0x980000)
            if 0 <= off < len(boot):
                insn = next(iter(md.disasm(boot[off:off+16], addr, count=1)), None)
                if insn: print(f"  {addr:#x}: {insn.mnemonic:8s} {insn.op_str}", flush=True)
        except Exception:
            pass

# ---------- 模拟结束后: 全内存 dump + 字符串分析 ----------
print("\n===== 模拟结束, dump 分析 =====", flush=True)
if not ANALYZE_DUMP:
    print("已按 PHASE2_ANALYZE_DUMP=0 跳过内存 dump/字符串扫描", flush=True)
    sys.exit(0)
try:
    mem = bytes(uc.mem_read(BASE, TOTAL))
    nz = sum(1 for b in mem if b)
    print(f"模块区非零: {100*nz/len(mem):.1f}%", flush=True)
    if MEM_DUMP_PATH:
        open(MEM_DUMP_PATH, 'wb').write(mem)
        print(f"已存 {MEM_DUMP_PATH} ({len(mem)} bytes)", flush=True)
    import re as _re
    kws = [b'wireshark', b'dumpcap', b'fiddler', b'charles', b'clash', b'v2ray', b'proxifier',
           b'http://', b'https://', b'heypixel', b'netease', b'jni_call_hook', b'flush_and_report',
           b'MaxHook', b'anti-cheat', b'WLkt', b'SOFTWARE', b'.minecraft', b'FindClass',
           b'GetStaticMethodID', b'net/minecraft', b'cheat', b'inject', b'process', b'report']
    for kw in kws:
        hits = [m.start() for m in _re.finditer(kw, mem, _re.I)]
        if hits:
            print(f"  kw {kw.decode()!r}: {len(hits)} 处")
            for h in hits[:3]:
                ctx = mem[max(0,h-20):h+60]
                print(f"    @{h:#x}: {ctx!r}")
except Exception as e:
    print(f"dump 失败: {e}", flush=True)
