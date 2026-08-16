# -*- coding: utf-8 -*-
"""
run_unpack.py — 完整 Unicorn 解包: 解压 .boot -> 搭 WinEnv -> 继续模拟 WinLicense 运行
- WinHTTP 调用记录 URL/请求
- JNI 调用记录类名/方法名 (DLL->Java mod 通信面)
- ws2_32 connect 记录对端 IP
"""
import struct, time, os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from unicorn import *
from unicorn.x86_const import *
from winenv import WinEnv

path = r'E:/MCLDownload/Game/.minecraft/native/MaxHook.dll'
data = open(path, 'rb').read()
BASE = 0x180000000
STACK_BASE = 0x7FFE000000      # 栈 (大)
STACK_SIZE = 0x800000
RSP = STACK_BASE + STACK_SIZE - 0x1000
ENTRY = BASE + 0x1f00058

# ---------- 解析 MaxHook 节 ----------
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

env = WinEnv(uc, RSP, log=lambda *a: print(*a) if __import__('os').environ.get('VERBOSE') else None)

# ---------- 映射系统 DLL ----------
K32 = 0x7FFC00000000
NTD = 0x7FFB00000000
WHT = 0x7FFA00000000
WS2 = 0x7FF900000000
IPH = 0x7FF800000000
VER = 0x7FF700000000
ADV = 0x7FF600000000
USR = 0x7FF500000000
OLE = 0x7FF400000000
JVM = 0x7FF300000000
for name, base in [('kernel32.dll', K32), ('ntdll.dll', NTD), ('winhttp.dll', WHT),
                   ('ws2_32.dll', WS2), ('iphlpapi.dll', IPH), ('version.dll', VER),
                   ('advapi32.dll', ADV), ('user32.dll', USR), ('ole32.dll', OLE)]:
    env.map_dll(name, base)

# ---------- 伪造 jvm.dll (只有 JNI_GetCreatedJavaVMs 导出) ----------
def make_fake_dll(path, exports, base):
    """构造最小 PE: 1 节 .text [RVA 0x1000, file 0x200], 导出表放在节内"""
    n = len(exports)
    sect_vsize = 0x2000
    sect_rsize = 0x2000
    exp_rva = 0x1000 + 0x40              # 导出目录
    name_table = exp_rva + 0x40          # 名字 RVA 表
    func_table = name_table + n * 4
    ord_table = func_table + n * 4
    str_base = ord_table + n * 2
    blob = bytearray(sect_rsize + 0x200)
    # DOS / PE 头 (file 0x00)
    blob[0:2] = b'MZ'
    blob[0x3C:0x40] = struct.pack('<I', 0x40)
    blob[0x40:0x44] = b'PE\x00\x00'
    blob[0x44:0x46] = struct.pack('<H', 0x8664)
    blob[0x46:0x48] = struct.pack('<H', 1)
    blob[0x54:0x56] = struct.pack('<H', 0xF0)
    blob[0x56:0x58] = struct.pack('<H', 0x22)
    opt = 0x60
    blob[opt:opt+2] = struct.pack('<H', 0x20B)
    blob[opt+16:opt+20] = struct.pack('<I', 0x1000)
    blob[opt+24:opt+32] = struct.pack('<Q', base)
    blob[opt+32:opt+36] = struct.pack('<I', 0x1000)
    blob[opt+36:opt+40] = struct.pack('<I', 0x200)
    blob[opt+56:opt+60] = struct.pack('<H', 6)
    blob[opt+64:opt+68] = struct.pack('<I', sect_vsize)
    blob[opt+112:opt+116] = struct.pack('<I', exp_rva)
    blob[opt+116:opt+120] = struct.pack('<I', 0x40 + n*12 + 64)
    sct = opt + 240
    blob[sct:sct+8] = b'.text\x00\x00\x00'
    blob[sct+8:sct+12] = struct.pack('<I', sect_vsize)
    blob[sct+12:sct+16] = struct.pack('<I', 0x1000)
    blob[sct+16:sct+20] = struct.pack('<I', sect_rsize)
    blob[sct+20:sct+24] = struct.pack('<I', 0x200)
    blob[sct+36:sct+40] = struct.pack('<I', 0x60000020)
    # 节内容起点: file 0x200 == RVA 0x1000
    base_off = 0x200
    # 导出目录
    blob[base_off + 0x00:base_off + 0x04] = struct.pack('<I', 0)
    blob[base_off + 0x0C:base_off + 0x10] = struct.pack('<I', 1)
    blob[base_off + 0x10:base_off + 0x14] = struct.pack('<I', n)
    blob[base_off + 0x14:base_off + 0x18] = struct.pack('<I', func_table)
    blob[base_off + 0x18:base_off + 0x1C] = struct.pack('<I', name_table)
    blob[base_off + 0x1C:base_off + 0x20] = struct.pack('<I', ord_table)
    for i, (nm, rva) in enumerate(exports.items()):
        blob[base_off + (func_table-0x1000) + i*4:base_off + (func_table-0x1000) + i*4+4] = struct.pack('<I', rva)
        blob[base_off + (name_table-0x1000) + i*4:base_off + (name_table-0x1000) + i*4+4] = struct.pack('<I', str_base)
        blob[base_off + (ord_table-0x1000) + i*2:base_off + (ord_table-0x1000) + i*2+2] = struct.pack('<H', i)
        nmb = nm.encode() + b'\x00'
        blob[base_off + (str_base-0x1000):base_off + (str_base-0x1000) + len(nmb)] = nmb
        str_base += len(nmb)
    # 导出函数体 (JNI_GetCreatedJavaVMs @ RVA 0x1000): mov eax,0; ret
    blob[base_off + 0x00] = 0x31; blob[base_off + 0x01] = 0xC0
    blob[base_off + 0x02] = 0xC3
    open(path, 'wb').write(bytes(blob))

jvm_dll_path = r'E:\Coding\S1mple\target\fake_jvm.dll'
make_fake_dll(jvm_dll_path, {'JNI_GetCreatedJavaVMs': 0x1000}, JVM)
env._ensure_map(JVM, JVM + 0x3000)
env.uc.mem_write(JVM + 0x1000, open(jvm_dll_path,'rb').read()[0x200:0x200+0x2000])
env.dlls['jvm.dll'] = {'base': JVM, 'size': 0x3000, 'exports': {'JNI_GetCreatedJavaVMs': 0x1000}, 'orde': {}, 'path': jvm_dll_path, 'image_base': JVM}

# ---------- API 实现 ----------
F = 0x7FF200000000  # fake 结构区 (JavaVM/JNIEnv 表)
env._ensure_map(F, F + 0x100000)

def rd(addr, n=8): return struct.unpack('<Q', uc.mem_read(addr, n))[0]
def wr(addr, v): uc.mem_write(addr, struct.pack('<Q', v))
def wstr16(addr, s):
    b = s.encode('utf-16-le') + b'\x00\x00'
    uc.mem_write(addr, b)
    return addr

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
 'GetSystemTimeAsFileTime': lambda a: (wr(a[0], 0), 0)[1],
 'GetTickCount': lambda a: env.ticks,
 'GetTickCount64': lambda a: env.ticks,
 'QueryPerformanceCounter': lambda a: (wr(a[0], 0), 0)[1],
 'QueryPerformanceFrequency': lambda a: (wr(a[0], 10000000), 1)[1],
 'GetCurrentProcessId': lambda a: 0x1234,
 'GetCurrentThreadId': lambda a: 0x5678,
 'IsDebuggerPresent': lambda a: 0,
 'GetLastError': lambda a: 0,
 'SetLastError': lambda a: 0,
 'GetStartupInfoA': lambda a: 0,
 'GetCommandLineA': lambda a: F + 0xA000,
 'GetCommandLineW': lambda a: F + 0xA100,
 'OutputDebugStringA': lambda a: (env.log(f"[dbg] {env.read_cstr(a[0])}"), 0)[1],
 'OutputDebugStringW': lambda a: (env.log(f"[dbgW] {env.read_wstr(a[0])}"), 0)[1],
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
 'GetAdaptersAddresses': lambda a: (env.log(f"[iphlpapi] GetAdaptersAddresses family={a[0]}"), 111)[1],
 'inet_ntop': lambda a: 0,
 'RegGetValueW': lambda a: (env.log(f"[advapi] RegGetValueW hkey={a[0]:#x} sub={env.read_wstr(a[1])} val={env.read_wstr(a[3])}"), 2)[1],
 'CoCreateInstance': lambda a: 0x80004002,
 'MessageBoxA': lambda a: (env.log(f"[msgbox] {env.read_cstr(a[1])}"), 0)[1],
 'JNI_GetCreatedJavaVMs': lambda a: _jni_getvms(a),
})

def _gp(a):
    mod = a[0]; name = env.read_cstr(a[1])
    for dll in env.dlls.values():
        if mod == 0 or dll['base'] == mod or dll['base'] == 0:
            if name in dll['exports']:
                return dll['base'] + dll['exports'][name]
    # name 可能是序号 (0x80000000 | ord)
    if name.startswith('#'):
        try:
            ordn = int(name[1:])
            for dll in env.dlls.values():
                if mod == 0 or dll['base'] == mod:
                    if ordn in dll['orde']:
                        return dll['base'] + dll['orde'][ordn]
        except Exception: pass
    return 0

def _gmh(a, wide):
    nm = env.read_wstr(a[0]) if wide else env.read_cstr(a[0])
    if nm:
        ln = nm.lower()
        for dll in env.dlls.values():
            if ln in dll['base'].__class__.__name__: pass
        # 按文件名匹配
        for key, dll in env.dlls.items():
            if key.split('\\')[-1].lower() == ln or key.lower() == ln:
                return dll['base']
        return 0
    # 主模块
    return BASE

def _ll(a, wide):
    nm = env.read_wstr(a[0]) if wide else env.read_cstr(a[0])
    env.log(f"[LoadLibrary] {nm}")
    if not nm: return 0
    if 'jvm' in nm.lower(): return JVM
    for key, dll in env.dlls.items():
        if dll['base'] in (K32, NTD, WHT, WS2, IPH, VER, ADV, USR, OLE) and key.split('\\')[-1].lower() == nm.lower():
            return dll['base']
    return 0

def _gmn(a, wide):
    mod = a[0]; buf = a[1]; size = a[2]
    name = b''
    if mod == BASE or mod == 0:
        name = 'E:\\MCLDownload\\Game\\.minecraft\\native\\MaxHook.dll'
    elif mod == JVM:
        name = 'C:\\Program Files\\Java\\jvm.dll'
    else:
        for key, dll in env.dlls.items():
            if dll['base'] == mod:
                name = key
                break
    data2 = name.encode('utf-16-le') if wide else name.encode()
    try:
        uc.mem_write(buf, data2[:size-2] + b'\x00\x00')
    except UcError: pass
    return len(name)

def _va(a):
    addr = a[0]; size = a[1]; typ = a[2]; prot = a[3]
    if addr == 0:
        addr = env.alloc(size or 0x1000)
    else:
        env._ensure_map(addr, addr + (size or 0x1000))
    env.log(f"[VirtualAlloc] addr={addr:#x} size={size:#x} type={typ:#x} prot={prot:#x}")
    return addr

# ---------- JNI 伪造 ----------
JNI_VTABLE = F + 0x10000
JNI_ENV = F + 0x20000
JVM_OBJ = F + 0x30000
JVM_VTABLE = F + 0x40000

jni_fn_names = [None]*250
jni_fn_names[0] = 'reserved0'; jni_fn_names[1] = 'reserved1'; jni_fn_names[2] = 'reserved2'; jni_fn_names[3] = 'reserved3'
jni_names_map = {4:'GetVersion',5:'DefineClass',6:'FindClass',7:'FromReflectedMethod',8:'FromReflectedField',
 9:'ToReflectedMethod',10:'GetSuperclass',11:'IsAssignableFrom',12:'ToReflectedField',13:'Throw',14:'ThrowNew',
 15:'ExceptionOccurred',16:'ExceptionDescribe',17:'ExceptionClear',18:'FatalError',19:'PushLocalFrame',20:'PopLocalFrame',
 21:'NewGlobalRef',22:'DeleteGlobalRef',23:'DeleteLocalRef',24:'IsSameObject',25:'NewLocalRef',26:'EnsureLocalCapacity',
 27:'AllocObject',28:'NewObject',29:'NewObjectV',30:'NewObjectA',31:'GetObjectClass',32:'IsInstanceOf',
 33:'GetMethodID',34:'CallObjectMethod',35:'CallObjectMethodV',36:'CallObjectMethodA',37:'CallBooleanMethod',
 38:'CallBooleanMethodV',39:'CallBooleanMethodA',40:'CallByteMethod',41:'CallByteMethodV',42:'CallByteMethodA',
 43:'CallCharMethod',44:'CallCharMethodV',45:'CallCharMethodA',46:'CallShortMethod',47:'CallShortMethodV',
 48:'CallShortMethodA',49:'CallIntMethod',50:'CallIntMethodV',51:'CallIntMethodA',52:'CallLongMethod',
 53:'CallLongMethodV',54:'CallLongMethodA',55:'CallFloatMethod',56:'CallFloatMethodV',57:'CallFloatMethodA',
 58:'CallDoubleMethod',59:'CallDoubleMethodV',60:'CallDoubleMethodA',61:'CallVoidMethod',62:'CallVoidMethodV',
 63:'CallVoidMethodA',64:'CallNonvirtualObjectMethod',65:'CallNonvirtualObjectMethodV',66:'CallNonvirtualObjectMethodA',
 67:'CallNonvirtualBooleanMethod',68:'CallNonvirtualBooleanMethodV',69:'CallNonvirtualBooleanMethodA',
 70:'CallNonvirtualByteMethod',71:'CallNonvirtualByteMethodV',72:'CallNonvirtualByteMethodA',73:'CallNonvirtualCharMethod',
 74:'CallNonvirtualCharMethodV',75:'CallNonvirtualCharMethodA',76:'CallNonvirtualShortMethod',77:'CallNonvirtualShortMethodV',
 78:'CallNonvirtualShortMethodA',79:'CallNonvirtualIntMethod',80:'CallNonvirtualIntMethodV',81:'CallNonvirtualIntMethodA',
 82:'CallNonvirtualLongMethod',83:'CallNonvirtualLongMethodV',84:'CallNonvirtualLongMethodA',85:'CallNonvirtualFloatMethod',
 86:'CallNonvirtualFloatMethodV',87:'CallNonvirtualFloatMethodA',88:'CallNonvirtualDoubleMethod',89:'CallNonvirtualDoubleMethodV',
 90:'CallNonvirtualDoubleMethodA',91:'CallNonvirtualVoidMethod',92:'CallNonvirtualVoidMethodV',93:'CallNonvirtualVoidMethodA',
 94:'GetFieldID',95:'GetObjectField',96:'GetBooleanField',97:'GetByteField',98:'GetCharField',99:'GetShortField',
 100:'GetIntField',101:'GetLongField',102:'GetFloatField',103:'GetDoubleField',104:'SetObjectField',105:'SetBooleanField',
 106:'SetByteField',107:'SetCharField',108:'SetShortField',109:'SetIntField',110:'SetLongField',111:'SetFloatField',
 112:'SetDoubleField',113:'GetStaticMethodID',114:'CallStaticObjectMethod',115:'CallStaticObjectMethodV',
 116:'CallStaticObjectMethodA',117:'CallStaticBooleanMethod',118:'CallStaticBooleanMethodV',119:'CallStaticBooleanMethodA',
 120:'CallStaticByteMethod',121:'CallStaticByteMethodV',122:'CallStaticByteMethodA',123:'CallStaticCharMethod',
 124:'CallStaticCharMethodV',125:'CallStaticCharMethodA',126:'CallStaticShortMethod',127:'CallStaticShortMethodV',
 128:'CallStaticShortMethodA',129:'CallStaticIntMethod',130:'CallStaticIntMethodV',131:'CallStaticIntMethodA',
 132:'CallStaticLongMethod',133:'CallStaticLongMethodV',134:'CallStaticLongMethodA',135:'CallStaticFloatMethod',
 136:'CallStaticFloatMethodV',137:'CallStaticFloatMethodA',138:'CallStaticDoubleMethod',139:'CallStaticDoubleMethodV',
 140:'CallStaticDoubleMethodA',141:'CallStaticVoidMethod',142:'CallStaticVoidMethodV',143:'CallStaticVoidMethodA',
 144:'GetStaticFieldID',145:'GetStaticObjectField',146:'GetStaticBooleanField',147:'GetStaticByteField',
 148:'GetStaticCharField',149:'GetStaticShortField',150:'GetStaticIntField',151:'GetStaticLongField',
 152:'GetStaticFloatField',153:'GetStaticDoubleField',154:'SetStaticObjectField',155:'SetStaticBooleanField',
 156:'SetStaticByteField',157:'SetStaticCharField',158:'SetStaticShortField',159:'SetStaticIntField',
 160:'SetStaticLongField',161:'SetStaticFloatField',162:'SetStaticDoubleField',163:'NewString',164:'GetStringLength',
 165:'GetStringChars',166:'ReleaseStringChars',167:'NewStringUTF',168:'GetStringUTFLength',169:'GetStringUTFChars',
 170:'ReleaseStringUTFChars',171:'GetArrayLength',172:'NewObjectArray',173:'GetObjectArrayElement',174:'SetObjectArrayElement',
 175:'NewBooleanArray',176:'NewByteArray',177:'NewCharArray',178:'NewShortArray',179:'NewIntArray',180:'NewLongArray',
 181:'NewFloatArray',182:'NewDoubleArray',183:'GetBooleanArrayElements',184:'GetByteArrayElements',185:'GetCharArrayElements',
 186:'GetShortArrayElements',187:'GetIntArrayElements',188:'GetLongArrayElements',189:'GetFloatArrayElements',
 190:'GetDoubleArrayElements',191:'ReleaseBooleanArrayElements',192:'ReleaseByteArrayElements',193:'ReleaseCharArrayElements',
 194:'ReleaseShortArrayElements',195:'ReleaseIntArrayElements',196:'ReleaseLongArrayElements',197:'ReleaseFloatArrayElements',
 198:'ReleaseDoubleArrayElements',199:'GetBooleanArrayRegion',200:'GetByteArrayRegion',201:'GetCharArrayRegion',
 202:'GetShortArrayRegion',203:'GetIntArrayRegion',204:'GetLongArrayRegion',205:'GetFloatArrayRegion',206:'GetDoubleArrayRegion',
 207:'SetBooleanArrayRegion',208:'SetByteArrayRegion',209:'SetCharArrayRegion',210:'SetShortArrayRegion',
 211:'SetIntArrayRegion',212:'SetLongArrayRegion',213:'SetFloatArrayRegion',214:'SetDoubleArrayRegion',
 215:'RegisterNatives',216:'UnregisterNatives',217:'MonitorEnter',218:'MonitorExit',219:'GetJavaVM',
 220:'GetStringRegion',221:'GetStringUTFRegion',222:'GetPrimitiveArrayCritical',223:'ReleasePrimitiveArrayCritical',
 224:'GetStringCritical',225:'ReleaseStringCritical',226:'NewWeakGlobalRef',227:'DeleteWeakGlobalRef',228:'ExceptionCheck',
 229:'NewDirectByteBuffer',230:'GetDirectBufferAddress',231:'GetDirectBufferCapacity',232:'GetObjectRefType',233:'GetModule'}

def jni_impl(idx, args):
    nm = jni_names_map.get(idx, f'jni_{idx}')
    if nm in ('FindClass',):
        env.jni_log.append(('FindClass', env.read_cstr(args[1])))
        env.log(f"[JNI] FindClass({env.read_cstr(args[1])})")
        return F + 0x40000 + idx * 0x10 + 1   # 假 jclass (非 0)
    if nm in ('GetMethodID', 'GetStaticMethodID', 'GetFieldID', 'GetStaticFieldID', 'RegisterNatives'):
        cls = args[1]; nm2 = env.read_cstr(args[2]); sig = env.read_cstr(args[3])
        env.jni_log.append((nm, nm2, sig))
        env.log(f"[JNI] {nm}(class={cls:#x} name={nm2!r} sig={sig!r})")
        return F + 0x40000 + idx * 0x10 + 2
    if nm in ('NewStringUTF', 'NewString'):
        s = env.read_cstr(args[1]) if nm == 'NewStringUTF' else env.read_wstr(args[1])
        env.jni_log.append((nm, s))
        env.log(f"[JNI] {nm}({s!r})")
        return F + 0x40000 + idx * 0x10 + 3
    if nm in ('GetStringUTFChars', 'GetStringChars'):
        s = env.read_cstr(args[1])
        buf = env.alloc(len(s) + 1)
        uc.mem_write(buf, s.encode() + b'\x00')
        return buf
    if nm == 'ReleaseStringUTFChars': return 0
    if nm in ('GetJavaVM',):
        wr(args[1], JVM_OBJ)
        return 0
    if nm in ('ExceptionOccurred', 'ExceptionCheck'): return 0
    if nm in ('ExceptionDescribe', 'ExceptionClear'): return 0
    if nm.startswith('CallStatic') or nm.startswith('Call'):
        env.jni_log.append((nm, hex(args[1]) if args[1] else None))
        env.log(f"[JNI] {nm}(obj={args[1]:#x})")
        return 0
    if nm in ('GetObjectClass', 'GetStaticObjectField', 'GetObjectField', 'ToReflectedMethod', 'NewLocalRef', 'NewGlobalRef'):
        return F + 0x40000 + idx * 0x10 + 4
    if nm in ('GetVersion',): return 0x0001000E
    if nm == 'GetArrayLength': return 1
    if nm in ('GetIntField','GetLongField','GetBooleanField','GetShortField','GetByteField','GetCharField','GetFloatField','GetDoubleField'):
        return 0
    return 0

def jni_dispatch(address, args):
    idx = (address - JNI_VTABLE) // 8
    if 0 <= idx < 250:
        return jni_impl(idx, args)

def _jni_getvms(a):
    buf = a[0]; n = a[1]; cnt = a[2]
    wr(buf, JVM_OBJ)
    if cnt: wr(cnt, 1)
    env.log("[JNI] JNI_GetCreatedJavaVMs -> 1 VM")
    return 0

# JavaVM vtable: 4 个函数: reserved0-2, GetEnv, AttachCurrentThread, DetachCurrentThread
# 让表项自指: vtable[i] = JVM_VTABLE + i*8, 调用直接落在槽上, dispatch 按 idx 识别
for i in range(7):
    wr(JVM_VTABLE + i*8, JVM_VTABLE + i*8)
wr(JVM_OBJ, JVM_VTABLE)

def jvm_dispatch(address, args):
    if address == JVM_VTABLE + 3*8:
        # GetEnv(JavaVM*, void** env, jint version)
        wr(args[1], JNI_ENV)
        env.log(f"[JVM] GetEnv version={args[2]:#x}")
        return 0
    if address == JVM_VTABLE + 4*8:
        # AttachCurrentThread
        wr(args[1], JNI_ENV)
        env.log("[JVM] AttachCurrentThread")
        return 0
    if address == JVM_VTABLE + 5*8:
        # DetachCurrentThread
        env.log("[JVM] DetachCurrentThread")
        return 0
    return 0

# 构建 JNIEnv 表: 表项自指
for i in range(233):
    wr(JNI_VTABLE + i*8, JNI_VTABLE + i*8)
wr(JNI_ENV, JNI_VTABLE)

# ---------- WinHTTP 实现 ----------
winhttp_states = {}
def _wh_open(a):
    env.log(f"[WinHTTP] WinHttpOpen(agent={env.read_wstr(a[0])})")
    h = env.alloc(16); wr(h, 1); return h
def _wh_connect(a):
    h = a[0]; host = env.read_wstr(a[1]); port = a[2]
    env.log(f"[WinHTTP] WinHttpConnect(host={host!r} port={port})")
    env.winhttp_log.append(('connect', host, port))
    h2 = env.alloc(16); wr(h2, 2); return h2
def _wh_openreq(a):
    h = a[0]; verb = env.read_wstr(a[1]); obj = env.read_wstr(a[2])
    env.log(f"[WinHTTP] WinHttpOpenRequest(verb={verb!r} path={obj!r})")
    env.winhttp_log.append(('openrequest', verb, obj))
    h2 = env.alloc(16); wr(h2, 3); return h2
def _wh_sendreq(a):
    h = a[0]; hdr = env.read_wstr(a[3])
    body = b''
    if a[5]:
        try: body = uc.mem_read(a[4], a[5])
        except UcError: pass
    env.log(f"[WinHTTP] WinHttpSendRequest(headers={hdr!r} body={body[:200]!r})")
    env.winhttp_log.append(('send', hdr, body[:500]))
    return 1
def _wh_recvresp(a):
    env.log("[WinHTTP] WinHttpReceiveResponse")
    return 1
def _wh_readdata(a):
    env.log("[WinHTTP] WinHttpReadData")
    return 0
def _wh_close(a):
    env.log("[WinHTTP] WinHttpCloseHandle")
    return 1
def _wh_query(a):
    env.log(f"[WinHTTP] WinHttpQueryHeaders")
    return 0

winhttp_apis = {'WinHttpOpen': _wh_open, 'WinHttpConnect': _wh_connect, 'WinHttpOpenRequest': _wh_openreq,
 'WinHttpSendRequest': _wh_sendreq, 'WinHttpReceiveResponse': _wh_recvresp, 'WinHttpReadData': _wh_readdata,
 'WinHttpCloseHandle': _wh_close, 'WinHttpQueryHeaders': _wh_query, 'WinHttpQueryOption': lambda a: 0,
 'WinHttpSetOption': lambda a: 1, 'WinHttpAddRequestHeaders': lambda a: 1, 'WinHttpWriteData': lambda a: 1,
 'WinHttpQueryDataAvailable': lambda a: 0, 'WinHttpCrackUrl': lambda a: 0, 'WinHttpSetTimeouts': lambda a: 1}
env.api_impl.update(winhttp_apis)

# ws2_32 关键: connect/send/recv/getaddrinfo
env.api_impl.update({
 'WSAStartup': lambda a: 0,
 'WSACleanup': lambda a: 0,
 'socket': lambda a: F + 0x50000 + 1,
 'closesocket': lambda a: 0,
 'connect': lambda a: (env.log(f"[ws2] connect(sock={a[0]:#x} addr={a[1]:#x})"), 0)[1],
 'send': lambda a: a[2],
 'recv': lambda a: 0,
 'getaddrinfo': lambda a: (env.log(f"[ws2] getaddrinfo({env.read_cstr(a[0])})"), 0x2A)[1],
 'freeaddrinfo': lambda a: 0,
 'inet_ntop': lambda a: 0,
 'gethostbyname': lambda a: (env.log(f"[ws2] gethostbyname({env.read_cstr(a[0])})"), 0)[1],
 'htons': lambda a: ((a[0] & 0xFF) << 8) | ((a[0] >> 8) & 0xFF),
 'ntohs': lambda a: ((a[0] & 0xFF) << 8) | ((a[0] >> 8) & 0xFF),
 'inet_addr': lambda a: 0,
 'WSAGetLastError': lambda a: 0,
})

# ntdll
env.api_impl.update({
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
 'NtQueryInformationProcess': lambda a: (env.log(f"[ntdll] NtQueryInformationProcess class={a[1]}"), 0xC0000003)[1],
 'NtQuerySystemInformation': lambda a: (env.log(f"[ntdll] NtQuerySystemInformation class={a[0]}"), 0xC0000003)[1],
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
 'RtlAddVectoredExceptionHandler': lambda a: (env.log(f"[ntdll] RtlAddVectoredExceptionHandler first={a[0]} handler={a[1]:#x}"), 1)[1],
 'RtlRemoveVectoredExceptionHandler': lambda a: 1,
 'RtlRaiseException': lambda a: 0,
 'KiUserExceptionDispatcher': lambda a: 0,
 'ZwQueryInformationProcess': lambda a: 0xC0000003,
 'ZwQuerySystemInformation': lambda a: 0xC0000003,
})

# ---------- 安装分发 ----------
env.regions = [(K32, 0x1000000, 'kernel32.dll'), (NTD, 0x1000000, 'ntdll.dll'),
           (WHT, 0x1000000, 'winhttp.dll'), (WS2, 0x1000000, 'ws2_32.dll'),
           (IPH, 0x1000000, 'iphlpapi.dll'), (VER, 0x1000000, 'version.dll'),
           (ADV, 0x1000000, 'advapi32.dll'), (USR, 0x1000000, 'user32.dll'),
           (OLE, 0x1000000, 'ole32.dll'), (JVM, 0x100000, 'jvm.dll')]
env._dispatch_cache = {}

# 安装: jni/jvmtable 分发 + env._dispatch
def on_code_all(uc, address, size, ud):
    if JNI_VTABLE <= address < JNI_VTABLE + 0x800:
        idx = (address - JNI_VTABLE) // 8
        rsp = uc.reg_read(UC_X86_REG_RSP)
        ret = rd(rsp)
        args = [uc.reg_read(UC_X86_REG_RCX), uc.reg_read(UC_X86_REG_RDX), uc.reg_read(UC_X86_REG_R8), uc.reg_read(UC_X86_REG_R9)]
        for i in range(6):
            try: args.append(rd(rsp + 8 + i*8))
            except UcError: args.append(0)
        r = jni_impl(idx, args)
        uc.reg_write(UC_X86_REG_RAX, r)
        uc.reg_write(UC_X86_REG_RIP, ret)
        uc.reg_write(UC_X86_REG_RSP, rsp + 8)
        return
    if JVM_VTABLE <= address < JVM_VTABLE + 0x40:
        idx = (address - JVM_VTABLE) // 8
        rsp = uc.reg_read(UC_X86_REG_RSP)
        ret = rd(rsp)
        args = [uc.reg_read(UC_X86_REG_RCX), uc.reg_read(UC_X86_REG_RDX), uc.reg_read(UC_X86_REG_R8), uc.reg_read(UC_X86_REG_R9)]
        for i in range(6):
            try: args.append(rd(rsp + 8 + i*8))
            except UcError: args.append(0)
        r = jvm_dispatch(address, args)
        uc.reg_write(UC_X86_REG_RAX, r)
        uc.reg_write(UC_X86_REG_RIP, ret)
        uc.reg_write(UC_X86_REG_RSP, rsp + 8)
        return
    env._dispatch(address)

uc.hook_add(UC_HOOK_CODE, on_code_all)

# ---------- 构建 PEB/TEB ----------
mods = [('MaxHook.dll', BASE, last_end, BASE + 0x1f00058)]
for key, dll in env.dlls.items():
    mods.append((key, dll['base'], dll['size'], 0))
env.build_peb_teb(modules=mods)

# ---------- 第一阶段: 解压 ----------
env.log = lambda *a: None  # 静默解压阶段
uc.emu_start(ENTRY, BASE + 0x1f00246, timeout=0, count=0)
rax = uc.reg_read(UC_X86_REG_RAX)
print(f"[*] 解压完成 -> 真实入口 {rax:#x}")

# 保存解压区
unpacked = uc.mem_read(BASE + 0x980000, 0x157C000)
open(r'E:\Coding\S1mple\target\boot_unpacked.bin', 'wb').write(unpacked)
print(f"[*] 已保存 boot_unpacked.bin ({len(unpacked)} bytes)")

# ---------- 崩溃现场 ----------
crash_state = {}
def on_fetch3(uc, access, address, size, value, ud):
    for r, n in [(UC_X86_REG_RAX,'rax'),(UC_X86_REG_RBX,'rbx'),(UC_X86_REG_RCX,'rcx'),(UC_X86_REG_RDX,'rdx'),
                 (UC_X86_REG_RSI,'rsi'),(UC_X86_REG_RDI,'rdi'),(UC_X86_REG_RBP,'rbp'),(UC_X86_REG_RSP,'rsp'),
                 (UC_X86_REG_R8,'r8'),(UC_X86_REG_R9,'r9'),(UC_X86_REG_R10,'r10'),(UC_X86_REG_R11,'r11'),
                 (UC_X86_REG_R12,'r12'),(UC_X86_REG_R13,'r13'),(UC_X86_REG_R14,'r14'),(UC_X86_REG_R15,'r15'),
                 (UC_X86_REG_RIP,'rip')]:
        crash_state[n] = uc.reg_read(r)
    crash_state['fetch'] = address
    return False
uc.hook_add(UC_HOOK_MEM_FETCH_UNMAPPED, on_fetch3)
# ---------- 第二阶段: WinEnv 模拟 (分块) ----------
env.log = print
env.ticks = 0
CHUNK = 50_000_000
t0 = time.time()
api_hits_before = len(env.calls)
blocks = 0
for blocks in range(120):
    try:
        uc.emu_start(uc.reg_read(UC_X86_REG_RIP), 0, timeout=30000, count=CHUNK)
        # 正常返回(到达 until=0 的特殊情况) -> 继续
        if len(env.calls) != api_hits_before:
            print(f"[*] 块 {blocks}: 出现 API 调用! RIP=0x{uc.reg_read(UC_X86_REG_RIP):x}")
            break
        if blocks % 5 == 0:
            print(f"[*] 块 {blocks}: RIP=0x{uc.reg_read(UC_X86_REG_RIP):x} 已执行 {blocks*CHUNK//1000000}M 条, {time.time()-t0:.1f}s")
    except UcError as e:
        print(f"[!] 块 {blocks} UcError {e} RIP=0x{uc.reg_read(UC_X86_REG_RIP):x} {time.time()-t0:.1f}s")
        break
else:
    print(f"[*] 达到块上限")
print(f"[*] 总耗时 {time.time()-t0:.1f}s, 已执行 ~{blocks*CHUNK/1e6:.0f}M 指令")
if crash_state:
    print("=== 崩溃现场 ===")
    for k, v in crash_state.items():
        print(f"   {k} = {v:#x}")
    # 尝试读取崩溃地址所在页内容
    fa = crash_state['fetch']
    try:
        uc.mem_map(fa & ~0xFFF, 0x1000)
        print(f"   崩溃页内容: {uc.mem_read(fa & ~0xFFF, 16).hex()}")
    except UcError as e:
        print(f"   (映射崩溃页失败 {e})")


# ---- 全内存 dump 找解密串 ----
memdump = bytearray()
try:
    memdump = bytearray(uc.mem_read(BASE, (last_end + 0xFFF) & ~0xFFF))
except Exception as e:
    print(f"mem_read BASE 失败: {e}")
for region_name, region_base, region_size in [('kernel32',K32,0x1000000),('ntdll',NTD,0x1000000),('winhttp',WHT,0x1000000),
    ('ws2',WS2,0x1000000),('iphlpapi',IPH,0x1000000),('version',VER,0x1000000),('advapi',ADV,0x1000000),
    ('user32',USR,0x1000000),('ole32',OLE,0x1000000)]:
    try:
        d = bytes(uc.mem_read(region_base, 0x20000))
        if b'MaxHook' in d or b'heypixel' in d or b'http' in d.lower():
            print(f"[{region_name}] 发现可疑内容 @ base")
    except Exception: pass
open(r'E://Coding//S1mple//target//mem_after_vm.bin','wb').write(bytes(memdump))
print(f"已存 mem_after_vm.bin ({len(memdump)} bytes)")

import re
m = bytes(memdump)
kws = [rb'http', rb'https', rb'wireshark', rb'heypixel', rb'netease', rb'WinHttp', rb'\.exe', rb'\.dll',
       rb'com[/\\]', rb'java', rb'JNI', rb'report', rb'SOFTWARE', rb'MaxHook', rb'anti-cheat', rb'\.minecraft', rb'launcher']
for kw in kws:
    hits = [mm.start() for mm in re.finditer(kw, m, re.I)]
    if hits:
        print(f"kw {kw}: {len(hits)} 处, 例: {[hex(h) for h in hits[:5]]}")
        # 打印第一处上下文
        h = hits[0]
        ctx = m[max(0,h-32):h+64]
        print(f"   上下文: {repr(ctx)}")
print(f"\n===== 总结 =====")
print(f"API 调用数: {len(env.calls)}")
from collections import Counter
print("API 调用 TOP:", Counter(c[0] for c in env.calls).most_common(25))
print(f"\nJNI 调用数: {len(env.jni_log)}")
for j in env.jni_log[:60]: print("   ", j)
print(f"\nWinHTTP: {len(env.winhttp_log)}")
for w in env.winhttp_log[:40]: print("   ", w)
