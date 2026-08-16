# -*- coding: utf-8 -*-
"""
winenv.py — Unicorn 最小 Windows 模拟环境
- 映射真实系统 DLL (kernel32/ntdll/winhttp/jvm.dll...) 及其导出表
- 构建 PEB/TEB/LDR, 设置 GS 段基址
- API 分发: 进入 DLL 区域时按导出名回调 Python 实现
"""
import struct, os, time

from unicorn import *
from unicorn.x86_const import *

IMAGE_DOS_SIGNATURE = 0x5A4D
IMAGE_NT_SIGNATURE = 0x00004550

class WinEnv:
    def __init__(self, uc, stack_top, log=None):
        self.uc = uc
        self.stack_top = stack_top
        self.log = log if log else print
        self.dlls = {}          # name_lower -> {'base':int,'size':int,'exports':{name:rva},'ord':{ord:rva},'path':str}
        self.api_impl = {}      # name -> callable(uc, args...)  (argc via stack)
        self.heap_cur = None
        self.heap_end = None
        self.calls = []         # 记录所有 API 调用 (name, args)
        self.winhttp_log = []
        self.jni_log = []
        self.net_log = []
        self.ticks = 0
        self.regions = []
        self._dispatch_cache = {}

    # ---------- DLL 解析与映射 ----------
    def parse_pe(self, path):
        d = open(path, 'rb').read()
        e_lfanew = struct.unpack('<I', d[0x3C:0x40])[0]
        assert struct.unpack('<H', d[0:2])[0] == IMAGE_DOS_SIGNATURE
        assert struct.unpack('<I', d[e_lfanew:e_lfanew+4])[0] == IMAGE_NT_SIGNATURE
        coff = e_lfanew + 4
        machine, nsects = struct.unpack('<HH', d[coff:coff+4])
        opt = coff + 20
        opt_magic = struct.unpack('<H', d[opt:opt+2])[0]
        is64 = (opt_magic == 0x20B)
        image_base = struct.unpack('<Q', d[opt+24:opt+32])[0] if is64 else struct.unpack('<I', d[opt+28:opt+32])[0]
        sec_off = opt + (240 if is64 else 224)
        sections = []
        for i in range(nsects):
            name = d[sec_off+i*40:sec_off+i*40+8].rstrip(b'\x00').decode(errors='replace')
            vsize, vaddr, rsize, raddr = struct.unpack('<IIII', d[sec_off+i*40+8:sec_off+i*40+24])
            sections.append((name, vaddr, vsize, raddr, rsize))
        # 导出表
        exp_rva, exp_size = struct.unpack('<II', d[opt+112:opt+120]) if is64 else struct.unpack('<II', d[opt+96:opt+104])
        exports = {}
        ordexports = {}
        if exp_rva:
            def rva2off(rva):
                for _, v, vs, ra, rs in sections:
                    if v <= rva < v + vs and rva - v < rs:
                        return ra + (rva - v)
                return None
            eo = rva2off(exp_rva)
            nfuncs = struct.unpack('<I', d[eo+20:eo+24])[0]
            nnames = struct.unpack('<I', d[eo+24:eo+28])[0]
            func_rva = struct.unpack('<I', d[eo+28:eo+32])[0]
            name_rva = struct.unpack('<I', d[eo+32:eo+36])[0]
            ord_rva = struct.unpack('<I', d[eo+36:eo+40])[0]
            fo, no_, oo = rva2off(func_rva), rva2off(name_rva), rva2off(ord_rva)
            names = []
            for i in range(nnames):
                nr = struct.unpack('<I', d[no_+i*4:no_+i*4+4])[0]
                s_off = rva2off(nr)
                end = d.find(b'\x00', s_off)
                names.append(d[s_off:end].decode(errors='replace'))
            ords = [struct.unpack('<H', d[oo+i*2:oo+i*2+2])[0] for i in range(nnames)]
            for nm, o in zip(names, ords):
                fr = struct.unpack('<I', d[fo+o*4:fo+o*4+4])[0]
                exports[nm] = fr
                ordexports[o] = fr
        return {'size': len(d), 'image_base': image_base, 'sections': sections,
                'raw': d, 'exports': exports, 'orde': ordexports, 'is64': is64}

    def map_dll(self, name, base):
        """映射系统 DLL 到指定基址, 记录导出表"""
        path = os.path.join(r'C:\Windows\System32', name)
        if not os.path.exists(path):
            self.log(f"[winenv] DLL 不存在: {name}")
            return None
        pe = self.parse_pe(path)
        # 映射 sections
        for sec_name, vaddr, vsize, raddr, rsize in pe['sections']:
            va = base + vaddr
            end = va + max(vsize, rsize)
            self._ensure_map(base, end)
            if rsize:
                self.uc.mem_write(va, pe['raw'][raddr:raddr+rsize])
            if vsize > rsize:
                self.uc.mem_write(va + rsize, b'\x00' * (vsize - rsize))
        self.dlls[name.lower()] = {'base': base, 'size': pe['size'], 'exports': pe['exports'],
                                   'orde': pe['orde'], 'path': path, 'image_base': pe['image_base']}
        return base

    def _ensure_map(self, base, end):
        """确保 [base, end) 已映射"""
        page = 0x1000
        cur = base & ~(page - 1)
        end = (end + page - 1) & ~(page - 1)
        while cur < end:
            try:
                self.uc.mem_map(cur, page)
            except UcError:
                pass
            cur += page

    # ---------- PEB / TEB ----------
    def build_peb_teb(self, teb_base=0x7FFDF00000, peb_base=0x7FFDF02000, modules=None):
        """modules: [(name, base, size, entry)] 按加载顺序"""
        self.teb = teb_base
        self.peb = peb_base
        self._ensure_map(teb_base, teb_base + 0x8000)
        uc = self.uc
        # --- TEB ---
        uc.mem_write(teb_base + 0x30, struct.pack('<Q', peb_base))       # PEB
        uc.mem_write(teb_base + 0x40, struct.pack('<Q', self.stack_top)) # StackBase
        uc.mem_write(teb_base + 0x10, struct.pack('<Q', self.stack_top - 0x800000))  # StackLimit
        uc.mem_write(teb_base + 0x188, struct.pack('<Q', 0))             # TLS array = NULL
        # --- PEB ---
        uc.mem_write(peb_base + 0x02, b'\x00')                           # BeingDebugged = 0
        uc.mem_write(peb_base + 0x08, struct.pack('<Q', modules[0][1]))  # ImageBaseAddress
        ldr = peb_base + 0x2000
        uc.mem_write(peb_base + 0x10, struct.pack('<Q', ldr))            # Ldr
        params = peb_base + 0x3000
        uc.mem_write(peb_base + 0x20, struct.pack('<Q', params))         # ProcessParameters
        # --- PEB_LDR_DATA ---
        uc.mem_write(ldr + 0x00, struct.pack('<I', 0x58))
        uc.mem_write(ldr + 0x0C, struct.pack('<I', len(modules)))
        # 链表: InLoadOrderModuleList @ +0x10, InMemoryOrder @ +0x20, InInitialization @ +0x30
        n = len(modules)
        # 每模块 entry 0x110 字节
        entries = {}
        entry_base = ldr + 0x100
        for i, (name, base, size, ep) in enumerate(modules):
            e = entry_base + i * 0x110
            entries[name] = e
            # 三个 LIST_ENTRY 互相串
            prev_il = entries.get(name, e)
            # InLoadOrderLinks @ e+0
            flink_il = entry_base + ((i+1) % n) * 0x110
            blink_il = entry_base + ((i-1) % n) * 0x110
            uc.mem_write(e + 0x00, struct.pack('<QQ', flink_il + 0x00, blink_il + 0x00))
            # InMemoryOrderLinks @ e+0x10
            uc.mem_write(e + 0x10, struct.pack('<QQ', flink_il + 0x10, blink_il + 0x10))
            # InInitializationOrderLinks @ e+0x20
            uc.mem_write(e + 0x20, struct.pack('<QQ', flink_il + 0x20, blink_il + 0x20))
            uc.mem_write(e + 0x30, struct.pack('<Q', base))              # DllBase
            uc.mem_write(e + 0x38, struct.pack('<Q', ep))                # EntryPoint
            uc.mem_write(e + 0x40, struct.pack('<Q', size))              # SizeOfImage
            # FullDllName @ +0x48, BaseDllName @ +0x58
            for off, nm in ((0x48, name), (0x58, name.split('\\')[-1])):
                s = nm.encode('utf-16-le')
                buf = e + 0x80 + (0 if off == 0x48 else 0x100)
                uc.mem_write(buf, s + b'\x00\x00')
                uc.mem_write(e + off, struct.pack('<HHQ', len(s), len(s)+2, buf))
        # LDR 的三个表头指向第一/最后 entry
        first = entry_base
        last = entry_base + (n-1) * 0x110
        for hdr_off in (0x10, 0x20, 0x30):
            uc.mem_write(ldr + hdr_off, struct.pack('<QQ', first + (hdr_off-0x10), last + (hdr_off-0x10)))
        self.ldr = ldr
        self.entries = entries
        # GS 基址
        self.uc.reg_write(UC_X86_REG_GS_BASE, teb_base)
        return teb_base

    # ---------- API 分发 ----------
    def install(self, regions):
        """regions: [(base, size, dll_name_lower)] 代码钩子"""
        self.regions = regions
        def on_code(uc, address, size, ud):
            self._dispatch(address)
        self.uc.hook_add(UC_HOOK_CODE, on_code)
        self._dispatch_cache = {}

    def _export_at(self, address):
        key = address
        if key in self._dispatch_cache:
            return self._dispatch_cache[key]
        r = None
        for base, size, name in self.regions:
            if base <= address < base + size:
                rva = address - base
                dll = self.dlls[name]
                # 精确匹配导出
                for nm, er in dll['exports'].items():
                    if er == rva:
                        r = (name, nm, rva)
                        break
                break
        self._dispatch_cache[key] = r
        return r

    def _dispatch(self, address):
        hit = self._export_at(address)
        if hit is None:
            return
        name, func, rva = hit
        impl = self.api_impl.get(func)
        if impl is None:
            self.log(f"[winenv] 未实现 API: {name}!{func}")
            # 返回 0
            rsp = self.uc.reg_read(UC_X86_REG_RSP)
            ret = struct.unpack('<Q', self.uc.mem_read(rsp, 8))[0]
            self.uc.reg_write(UC_X86_REG_RAX, 0)
            self.uc.reg_write(UC_X86_REG_RIP, ret)
            self.uc.reg_write(UC_X86_REG_RSP, rsp + 8)
            return
        # 收集参数 (rcx, rdx, r8, r9, 然后栈)
        a = [self.uc.reg_read(UC_X86_REG_RCX), self.uc.reg_read(UC_X86_REG_RDX),
             self.uc.reg_read(UC_X86_REG_R8), self.uc.reg_read(UC_X86_REG_R9)]
        rsp = self.uc.reg_read(UC_X86_REG_RSP)
        ret = struct.unpack('<Q', self.uc.mem_read(rsp, 8))[0]
        # 栈上第 5+ 参数
        for i in range(8):
            off = rsp + 8 + i * 8
            try:
                a.append(struct.unpack('<Q', self.uc.mem_read(off, 8))[0])
            except UcError:
                break
        self.calls.append((func, a[:8]))
        try:
            result = impl(a)
        except Exception as e:
            self.log(f"[winenv] API {func} 实现异常: {e}")
            result = 0
        self.uc.reg_write(UC_X86_REG_RAX, result)
        self.uc.reg_write(UC_X86_REG_RIP, ret)
        self.uc.reg_write(UC_X86_REG_RSP, rsp + 8)

    # ---------- 工具 ----------
    def read_cstr(self, addr, maxlen=512):
        if addr == 0: return ''
        try:
            b = self.uc.mem_read(addr, maxlen)
        except UcError:
            return ''
        return b.split(b'\x00')[0].decode('latin1', errors='replace')

    def read_wstr(self, addr, maxlen=256):
        if addr == 0: return ''
        try:
            b = self.uc.mem_read(addr, maxlen*2)
        except UcError:
            return ''
        end = b.find(b'\x00\x00')
        if end < 0: end = len(b)
        try:
            return b[:end].decode('utf-16-le', errors='replace')
        except Exception:
            return ''

    def read_ustring(self, addr):
        """UNICODE_STRING* -> str"""
        try:
            ln, mx, buf = struct.unpack('<HHQ', self.uc.mem_read(addr, 12))
        except UcError:
            return ''
        return self.read_wstr(buf, ln // 2 + 1)

    def alloc(self, size):
        """简单堆分配 (返回 0x7FF000000000 起的地址)"""
        page = 0x1000
        size = (size + page - 1) & ~(page - 1)
        if self.heap_cur is None:
            self.heap_cur = 0x7FF000000000
            self._ensure_map(self.heap_cur, self.heap_cur + 0x1000000)
            self.heap_end = self.heap_cur + 0x1000000
        if self.heap_cur + size > self.heap_end:
            self._ensure_map(self.heap_cur, self.heap_cur + size + 0x1000000)
            self.heap_end = self.heap_cur + size + 0x1000000
        r = self.heap_cur
        self.heap_cur += size
        return r
