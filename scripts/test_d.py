# -*- coding: utf-8 -*-
"""
trace_trap_tsc.py — 反模拟时间戳对策版
对全部 RDTSC/CPUID 指令位置加精准 hook:
  - RDTSC: 返回递增时间戳 (模拟真实 3GHz 周期计数)
  - CPUID: 返回真实硬件特征 (hypervisor 位=0)
  - 时间 API (GetSystemTimeAsFileTime/QueryPerformanceCounter/GetTickCount): 递增
"""
import struct, time, os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from unicorn import *
from unicorn.x86_const import *
from winenv import WinEnv

path = r'E:/MCLDownload/Game/.minecraft/native/MaxHook.dll'
data = open(path, 'rb').read()
BASE = 0x180000000
STACK_BASE = 0x7FFE000000
STACK_SIZE = 0x800000
RSP = STACK_BASE + STACK_SIZE - 0x1000
ENTRY = BASE + 0x1f00058

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

uc = Uc(UC_ARCH_X86, UC_MODE_64)
last_end = max(vaddr + vsize for _, vaddr, vsize, _, _ in sections)
uc.mem_map(BASE, (last_end + 0xFFF) & ~0xFFF)
uc.mem_write(BASE, data)
for name, vaddr, vsize, raddr, rsize in sections:
    va = BASE + vaddr
    if rsize > 0: uc.mem_write(va, data[raddr:raddr+rsize])
    if vsize > rsize: uc.mem_write(va + rsize, b'\x00' * (vsize - rsize))
uc.mem_map(STACK_BASE, STACK_SIZE)
uc.reg_write(UC_X86_REG_RSP, RSP)
uc.mem_write(RSP, struct.pack('<QQQQ', 0, BASE, 1, 0))

env = WinEnv(uc, RSP, log=lambda *a: None)

K32 = 0x7FFC00000000; NTD = 0x7FFB00000000; WHT = 0x7FFA00000000
WS2 = 0x7FF900000000; IPH = 0x7FF800000000; VER = 0x7FF700000000
ADV = 0x7FF600000000; USR = 0x7FF500000000; OLE = 0x7FF400000000; JVM = 0x7FF300000000
for name, base in [('kernel32.dll', K32), ('ntdll.dll', NTD), ('winhttp.dll', WHT),
                   ('ws2_32.dll', WS2), ('iphlpapi.dll', IPH), ('version.dll', VER),
                   ('advapi32.dll', ADV), ('user32.dll', USR), ('ole32.dll', OLE)]:
    env.map_dll(name, base)

# 伪造 jvm.dll
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
def rd(addr, n=8): return struct.unpack('<Q', uc.mem_read(addr, n))[0]
def wr(addr, v): uc.mem_write(addr, struct.pack('<Q', v))

# 时间基准: 用真实当前时间 (Unix ms * 10^4 作 100ns)
import datetime
base_ft = int(time.time() * 10000000) + 116444736000000000  # FILETIME
env.ticks = 100000  # GetTickCount ms
env.qpc = 0
env.tsc = 0
def _tick():
    env.ticks += 16
    return env.ticks

def _qpc(a):
    env.qpc += 100000
    wr(a[0], env.qpc)
    return 0

def _time_ft(a):
    global base_ft
    base_ft += 10000  # 每次 +1ms
    wr(a[0], base_ft & 0xFFFFFFFF)
    wr(a[0]+4, (base_ft >> 32) & 0xFFFFFFFF)
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
 'VirtualProtect': lambda a: (wr(a[3], 0x40), 1)[1],
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
 'RtlZeroMemory': lambda a: 0,
 'RtlCopyMemory': lambda a: 0,
 'memcpy': lambda a: 0,
 'memset': lambda a: 0,
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

# ---------- RDTSC / CPUID 精准 hook ----------
def find_patterns(region, base_addr):
    r = []; c = []
    for i in range(len(region)-4):
        if region[i] == 0x0F and region[i+1] == 0x31: r.append(base_addr + i)
        if region[i] == 0x0F and region[i+1] == 0xA2: c.append(base_addr + i)
    return r, c

rdtsc_pts = set(); cpuid_pts = set()
# 解压区 (runtime 版 .bugland = boot_unpacked.bin 一致, 用 runtime 版更全)
rt = open(r'E:/Coding/S1mple/target/MaxHook.runtime-unpacked.dll','rb').read()
bug_region = rt[0x17c3800:0x17c3800+0x157c000]
r1, c1 = find_patterns(bug_region, BASE + 0x980000)
rdtsc_pts.update(r1); cpuid_pts.update(c1)
# 原始 .text
t = data[0x400:0x400+0x5c2800]
r2, c2 = find_patterns(t, BASE + 0x10000)
rdtsc_pts.update(r2); cpuid_pts.update(c2)
# .boot 解压前的 stub 也可能跑 (第一阶段已过, 保险)
b = data[0x896600:0x896600+0xf2d000]
r3, c3 = find_patterns(b, BASE + 0x1f00000)
rdtsc_pts.update(r3); cpuid_pts.update(c3)
print(f"RDTSC hook 点: {len(rdtsc_pts)}, CPUID hook 点: {len(cpuid_pts)}")

tsc_counter = {'n': 0}
def on_rdtsc(uc, address, size, ud):
    tsc_counter['n'] += 1
    env.tsc += 0x100000  # 每次调用前进 ~0.3ms (3GHz)
    uc.reg_write(UC_X86_REG_EAX, env.tsc & 0xFFFFFFFF)
    uc.reg_write(UC_X86_REG_EDX, (env.tsc >> 32) & 0xFFFFFFFF)
    uc.reg_write(UC_X86_REG_RIP, address + 2)  # 跳过 rdtsc
    if tsc_counter['n'] <= 5:
        print(f"  [RDTSC @{address:#x}] -> {env.tsc:#x}")

def on_cpuid(uc, address, size, ud):
    eax_in = uc.reg_read(UC_X86_REG_EAX) & 0xFFFFFFFF
    if eax_in == 0:
        uc.reg_write(UC_X86_REG_EAX, 0x16)  # max leaf
        uc.reg_write(UC_X86_REG_EBX, 0x756E6547)  # Genu
        uc.reg_write(UC_X86_REG_EDX, 0x49656E69)  # ineI
        uc.reg_write(UC_X86_REG_ECX, 0x6C65746E)  # ntel
    elif eax_in == 1:
        uc.reg_write(UC_X86_REG_EAX, 0x000906EA)  # CPUID 步进/型号
        uc.reg_write(UC_X86_REG_EBX, 0x02100800)
        uc.reg_write(UC_X86_REG_ECX, 0x7FFAFBFF & ~0x80000000)  # hypervisor 位=0
        uc.reg_write(UC_X86_REG_EDX, 0xBFEBFBFF)
    elif eax_in == 7:
        uc.reg_write(UC_X86_REG_EAX, 0)
        uc.reg_write(UC_X86_REG_EBX, 0xD3C27FBF)
        uc.reg_write(UC_X86_REG_ECX, 0)
        uc.reg_write(UC_X86_REG_EDX, 0x1C000000)
    elif eax_in == 0x80000000:
        uc.reg_write(UC_X86_REG_EAX, 0x80000008)
        uc.reg_write(UC_X86_REG_EBX, 0)
        uc.reg_write(UC_X86_REG_ECX, 0)
        uc.reg_write(UC_X86_REG_EDX, 0)
    else:
print("SEC4 OK")
