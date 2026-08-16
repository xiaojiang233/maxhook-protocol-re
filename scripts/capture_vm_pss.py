#!/usr/bin/env python3
# -*- coding: utf-8 -*-
r"""
Capture a MaxHook VM transition with Windows Process Snapshotting (PSS).

The target is never debug-attached, injected into, or explicitly suspended.  A
small, read-only polling loop watches the MaxHook VM key/VIP, then one or more
PSS VA clones are created on a stable -> active transition.  All expensive
memory and stack reads happen from the clone after PssCaptureSnapshot returns.

Examples:
  py -3 target\capture_vm_pss.py
  py -3 target\capture_vm_pss.py --pid 41264 --captures 2
  py -3 target\capture_vm_pss.py --self-test
  py -3 target\capture_vm_pss.py --dry-run --pid 41264

Requires 64-bit CPython on Windows 8.1 or later.
"""

from __future__ import annotations

import argparse
import base64
import ctypes
import ctypes.wintypes as wintypes
import datetime as _datetime
import hashlib
import json
import os
from pathlib import Path
import platform
import struct
import sys
import time
from collections import deque
from typing import Any, Iterable, Optional


# ---------------------------------------------------------------------------
# MaxHook layout (the image is non-relocating in the observed builds)
# ---------------------------------------------------------------------------

IMAGE_BASE = 0x180000000
BUGLAND_BASE = IMAGE_BASE + 0x980000
BUGLAND_SIZE = 0x157C000
VM_RBP = IMAGE_BASE + 0x98C884
VM_KEY_ADDRESS = VM_RBP + 0x0A       # unaligned DWORD
VM_VIP_ADDRESS = VM_RBP + 0x6D       # unaligned QWORD
KUSER_SHARED_DATA = 0x7FFE0000
KUSER_SHARED_DATA_SIZE = 0x1000

# Report-worker chain recovered from region_0000005962cf8000.bin.  The clear
# wrapper calls the VM-backed worker and returns to REPORT_VIRTUAL_RETURN, so
# this value is a much stronger thread discriminator than a generic .bugland
# address alone.
REPORT_WORKER_CLEAR_ENTRY = IMAGE_BASE + 0x4B67A0
REPORT_WORKER_VM_ENTRY = IMAGE_BASE + 0x1A841D3
REPORT_VIRTUAL_RETURN = IMAGE_BASE + 0x4BB305


# Win32 process and memory constants.
PROCESS_VM_READ = 0x0010
PROCESS_CREATE_PROCESS = 0x0080
PROCESS_QUERY_INFORMATION = 0x0400
PROCESS_CAPTURE_ACCESS = (
    PROCESS_VM_READ
    | PROCESS_CREATE_PROCESS
    | PROCESS_QUERY_INFORMATION
)

TH32CS_SNAPPROCESS = 0x00000002
INVALID_HANDLE_VALUE = ctypes.c_void_p(-1).value

MEM_COMMIT = 0x1000
PAGE_NOACCESS = 0x01
PAGE_READONLY = 0x02
PAGE_READWRITE = 0x04
PAGE_WRITECOPY = 0x08
PAGE_EXECUTE = 0x10
PAGE_EXECUTE_READ = 0x20
PAGE_EXECUTE_READWRITE = 0x40
PAGE_EXECUTE_WRITECOPY = 0x80
PAGE_GUARD = 0x100
READABLE_PAGE_PROTECTIONS = {
    PAGE_READONLY,
    PAGE_READWRITE,
    PAGE_WRITECOPY,
    PAGE_EXECUTE,
    PAGE_EXECUTE_READ,
    PAGE_EXECUTE_READWRITE,
    PAGE_EXECUTE_WRITECOPY,
}

# Process Snapshotting constants from processsnapshot.h.
PSS_CAPTURE_VA_CLONE = 0x00000001
PSS_CAPTURE_THREADS = 0x00000080
PSS_CAPTURE_THREAD_CONTEXT = 0x00000100
PSS_CAPTURE_THREAD_CONTEXT_EXTENDED = 0x00000200
PSS_QUERY_VA_CLONE_INFORMATION = 1
PSS_WALK_THREADS = 3

ERROR_SUCCESS = 0
ERROR_NO_MORE_ITEMS = 259
ERROR_PARTIAL_COPY = 299

# AMD64 CONTEXT flags from winnt.h.
CONTEXT_AMD64 = 0x00100000
CONTEXT_CONTROL = CONTEXT_AMD64 | 0x00000001
CONTEXT_INTEGER = CONTEXT_AMD64 | 0x00000002
CONTEXT_SEGMENTS = CONTEXT_AMD64 | 0x00000004
CONTEXT_FLOATING_POINT = CONTEXT_AMD64 | 0x00000008
CONTEXT_DEBUG_REGISTERS = CONTEXT_AMD64 | 0x00000010
CONTEXT_XSTATE = CONTEXT_AMD64 | 0x00000040
CONTEXT_ALL = (
    CONTEXT_CONTROL
    | CONTEXT_INTEGER
    | CONTEXT_SEGMENTS
    | CONTEXT_FLOATING_POINT
    | CONTEXT_DEBUG_REGISTERS
)


# Fixed-width aliases are used instead of c_long/c_ulong so these declarations
# remain visibly tied to the Windows ABI.
BYTE = ctypes.c_uint8
WORD = ctypes.c_uint16
USHORT = ctypes.c_uint16
DWORD = ctypes.c_uint32
LONG = ctypes.c_int32
ULONG64 = ctypes.c_uint64
DWORD64 = ctypes.c_uint64
SIZE_T = ctypes.c_size_t
HANDLE = ctypes.c_void_p
PVOID = ctypes.c_void_p
BOOL = ctypes.c_int


class FILETIME(ctypes.Structure):
    _fields_ = [
        ("dwLowDateTime", DWORD),
        ("dwHighDateTime", DWORD),
    ]


class M128A(ctypes.Structure):
    _fields_ = [
        ("Low", ctypes.c_uint64),
        ("High", ctypes.c_int64),
    ]


class XMM_SAVE_AREA32(ctypes.Structure):
    """AMD64 XSAVE legacy area, exactly as declared in winnt.h (512 bytes)."""

    _fields_ = [
        ("ControlWord", WORD),
        ("StatusWord", WORD),
        ("TagWord", BYTE),
        ("Reserved1", BYTE),
        ("ErrorOpcode", WORD),
        ("ErrorOffset", DWORD),
        ("ErrorSelector", WORD),
        ("Reserved2", WORD),
        ("DataOffset", DWORD),
        ("DataSelector", WORD),
        ("Reserved3", WORD),
        ("MxCsr", DWORD),
        ("MxCsr_Mask", DWORD),
        ("FloatRegisters", M128A * 8),
        ("XmmRegisters", M128A * 16),
        ("Reserved4", BYTE * 96),
    ]


class CONTEXT64(ctypes.Structure):
    """Native Windows AMD64 CONTEXT (DECLSPEC_ALIGN(16), 0x4d0 bytes)."""

    _fields_ = [
        ("P1Home", DWORD64),
        ("P2Home", DWORD64),
        ("P3Home", DWORD64),
        ("P4Home", DWORD64),
        ("P5Home", DWORD64),
        ("P6Home", DWORD64),
        ("ContextFlags", DWORD),
        ("MxCsr", DWORD),
        ("SegCs", WORD),
        ("SegDs", WORD),
        ("SegEs", WORD),
        ("SegFs", WORD),
        ("SegGs", WORD),
        ("SegSs", WORD),
        ("EFlags", DWORD),
        ("Dr0", DWORD64),
        ("Dr1", DWORD64),
        ("Dr2", DWORD64),
        ("Dr3", DWORD64),
        ("Dr6", DWORD64),
        ("Dr7", DWORD64),
        ("Rax", DWORD64),
        ("Rcx", DWORD64),
        ("Rdx", DWORD64),
        ("Rbx", DWORD64),
        ("Rsp", DWORD64),
        ("Rbp", DWORD64),
        ("Rsi", DWORD64),
        ("Rdi", DWORD64),
        ("R8", DWORD64),
        ("R9", DWORD64),
        ("R10", DWORD64),
        ("R11", DWORD64),
        ("R12", DWORD64),
        ("R13", DWORD64),
        ("R14", DWORD64),
        ("R15", DWORD64),
        ("Rip", DWORD64),
        ("FltSave", XMM_SAVE_AREA32),
        ("VectorRegister", M128A * 26),
        ("VectorControl", DWORD64),
        ("DebugControl", DWORD64),
        ("LastBranchToRip", DWORD64),
        ("LastBranchFromRip", DWORD64),
        ("LastExceptionToRip", DWORD64),
        ("LastExceptionFromRip", DWORD64),
    ]


class PSS_THREAD_ENTRY(ctypes.Structure):
    """Native x64 PSS_THREAD_ENTRY from processsnapshot.h."""

    _fields_ = [
        ("ExitStatus", DWORD),
        ("TebBaseAddress", PVOID),
        ("ProcessId", DWORD),
        ("ThreadId", DWORD),
        ("AffinityMask", SIZE_T),
        ("Priority", LONG),
        ("BasePriority", LONG),
        ("LastSyscallFirstArgument", PVOID),
        ("LastSyscallNumber", WORD),
        ("CreateTime", FILETIME),
        ("ExitTime", FILETIME),
        ("KernelTime", FILETIME),
        ("UserTime", FILETIME),
        ("Win32StartAddress", PVOID),
        ("CaptureTime", FILETIME),
        ("Flags", DWORD),
        ("SuspendCount", WORD),
        ("SizeOfContextRecord", WORD),
        ("ContextRecord", PVOID),
    ]


class PSS_VA_CLONE_INFORMATION(ctypes.Structure):
    _fields_ = [("VaCloneHandle", HANDLE)]


class MEMORY_BASIC_INFORMATION64(ctypes.Structure):
    _fields_ = [
        ("BaseAddress", PVOID),
        ("AllocationBase", PVOID),
        ("AllocationProtect", DWORD),
        ("PartitionId", WORD),
        ("_Padding", WORD),
        ("RegionSize", SIZE_T),
        ("State", DWORD),
        ("Protect", DWORD),
        ("Type", DWORD),
    ]


class PROCESSENTRY32W(ctypes.Structure):
    _fields_ = [
        ("dwSize", DWORD),
        ("cntUsage", DWORD),
        ("th32ProcessID", DWORD),
        ("th32DefaultHeapID", SIZE_T),
        ("th32ModuleID", DWORD),
        ("cntThreads", DWORD),
        ("th32ParentProcessID", DWORD),
        ("pcPriClassBase", LONG),
        ("dwFlags", DWORD),
        ("szExeFile", ctypes.c_wchar * 260),
    ]


class LUID(ctypes.Structure):
    _fields_ = [("LowPart", DWORD), ("HighPart", LONG)]


class LUID_AND_ATTRIBUTES(ctypes.Structure):
    _fields_ = [("Luid", LUID), ("Attributes", DWORD)]


class TOKEN_PRIVILEGES(ctypes.Structure):
    _fields_ = [
        ("PrivilegeCount", DWORD),
        ("Privileges", LUID_AND_ATTRIBUTES * 1),
    ]


def _field_offset(structure: type[ctypes.Structure], field: str) -> int:
    return int(getattr(structure, field).offset)


def validate_native_layout() -> dict[str, Any]:
    """Fail before calling PSS if this interpreter cannot express the x64 ABI."""

    if ctypes.sizeof(PVOID) != 8:
        raise RuntimeError("a 64-bit CPython interpreter is required")

    expected = {
        "XMM_SAVE_AREA32.size": (ctypes.sizeof(XMM_SAVE_AREA32), 0x200),
        "CONTEXT64.size": (ctypes.sizeof(CONTEXT64), 0x4D0),
        "CONTEXT64.ContextFlags": (_field_offset(CONTEXT64, "ContextFlags"), 0x30),
        "CONTEXT64.EFlags": (_field_offset(CONTEXT64, "EFlags"), 0x44),
        "CONTEXT64.Rax": (_field_offset(CONTEXT64, "Rax"), 0x78),
        "CONTEXT64.Rsp": (_field_offset(CONTEXT64, "Rsp"), 0x98),
        "CONTEXT64.Rbp": (_field_offset(CONTEXT64, "Rbp"), 0xA0),
        "CONTEXT64.Rip": (_field_offset(CONTEXT64, "Rip"), 0xF8),
        "CONTEXT64.FltSave": (_field_offset(CONTEXT64, "FltSave"), 0x100),
        "CONTEXT64.VectorRegister": (_field_offset(CONTEXT64, "VectorRegister"), 0x300),
        "CONTEXT64.VectorControl": (_field_offset(CONTEXT64, "VectorControl"), 0x4A0),
        "PSS_THREAD_ENTRY.size": (ctypes.sizeof(PSS_THREAD_ENTRY), 0x78),
        "PSS_THREAD_ENTRY.TebBaseAddress": (
            _field_offset(PSS_THREAD_ENTRY, "TebBaseAddress"),
            0x08,
        ),
        "PSS_THREAD_ENTRY.CreateTime": (
            _field_offset(PSS_THREAD_ENTRY, "CreateTime"),
            0x34,
        ),
        "PSS_THREAD_ENTRY.Win32StartAddress": (
            _field_offset(PSS_THREAD_ENTRY, "Win32StartAddress"),
            0x58,
        ),
        "PSS_THREAD_ENTRY.ContextRecord": (
            _field_offset(PSS_THREAD_ENTRY, "ContextRecord"),
            0x70,
        ),
        "MEMORY_BASIC_INFORMATION64.size": (
            ctypes.sizeof(MEMORY_BASIC_INFORMATION64),
            0x30,
        ),
    }
    mismatches = [
        f"{name}: got {actual:#x}, expected {wanted:#x}"
        for name, (actual, wanted) in expected.items()
        if actual != wanted
    ]
    if mismatches:
        raise RuntimeError("native structure layout mismatch: " + "; ".join(mismatches))
    return {name: actual for name, (actual, _wanted) in expected.items()}


class PssError(RuntimeError):
    def __init__(self, function: str, status: int, message: str = "") -> None:
        detail = f"{function} failed: {status} (0x{status:08x})"
        if message:
            detail += f": {message}"
        super().__init__(detail)
        self.function = function
        self.status = int(status)


class WinAPI:
    def __init__(self) -> None:
        if sys.platform != "win32":
            raise RuntimeError("this utility only runs on Windows")
        self.k32 = ctypes.WinDLL("kernel32", use_last_error=True)
        self.advapi = ctypes.WinDLL("advapi32", use_last_error=True)
        self._bind_kernel32()
        self._bind_advapi32()

    def _bind_kernel32(self) -> None:
        k32 = self.k32

        k32.OpenProcess.argtypes = [DWORD, BOOL, DWORD]
        k32.OpenProcess.restype = HANDLE
        k32.CloseHandle.argtypes = [HANDLE]
        k32.CloseHandle.restype = BOOL
        k32.GetCurrentProcess.argtypes = []
        k32.GetCurrentProcess.restype = HANDLE
        k32.GetCurrentProcessId.argtypes = []
        k32.GetCurrentProcessId.restype = DWORD
        k32.GetCurrentThreadId.argtypes = []
        k32.GetCurrentThreadId.restype = DWORD
        k32.GetProcessId.argtypes = [HANDLE]
        k32.GetProcessId.restype = DWORD

        k32.ReadProcessMemory.argtypes = [
            HANDLE,
            PVOID,
            PVOID,
            SIZE_T,
            ctypes.POINTER(SIZE_T),
        ]
        k32.ReadProcessMemory.restype = BOOL
        k32.VirtualQueryEx.argtypes = [
            HANDLE,
            PVOID,
            ctypes.POINTER(MEMORY_BASIC_INFORMATION64),
            SIZE_T,
        ]
        k32.VirtualQueryEx.restype = SIZE_T

        k32.CreateToolhelp32Snapshot.argtypes = [DWORD, DWORD]
        k32.CreateToolhelp32Snapshot.restype = HANDLE
        k32.Process32FirstW.argtypes = [HANDLE, ctypes.POINTER(PROCESSENTRY32W)]
        k32.Process32FirstW.restype = BOOL
        k32.Process32NextW.argtypes = [HANDLE, ctypes.POINTER(PROCESSENTRY32W)]
        k32.Process32NextW.restype = BOOL

        k32.FormatMessageW.argtypes = [
            DWORD,
            PVOID,
            DWORD,
            DWORD,
            ctypes.c_wchar_p,
            DWORD,
            PVOID,
        ]
        k32.FormatMessageW.restype = DWORD

        try:
            k32.IsWow64Process2.argtypes = [
                HANDLE,
                ctypes.POINTER(USHORT),
                ctypes.POINTER(USHORT),
            ]
            k32.IsWow64Process2.restype = BOOL
            self.is_wow64_process2 = k32.IsWow64Process2
        except AttributeError:
            self.is_wow64_process2 = None

        required_pss = (
            "PssCaptureSnapshot",
            "PssQuerySnapshot",
            "PssWalkMarkerCreate",
            "PssWalkSnapshot",
            "PssWalkMarkerFree",
            "PssFreeSnapshot",
        )
        missing = [name for name in required_pss if not hasattr(k32, name)]
        if missing:
            raise RuntimeError(
                "Process Snapshotting API is unavailable (Windows 8.1+ required): "
                + ", ".join(missing)
            )

        k32.PssCaptureSnapshot.argtypes = [
            HANDLE,
            DWORD,
            DWORD,
            ctypes.POINTER(HANDLE),
        ]
        k32.PssCaptureSnapshot.restype = DWORD
        k32.PssQuerySnapshot.argtypes = [HANDLE, DWORD, PVOID, DWORD]
        k32.PssQuerySnapshot.restype = DWORD
        k32.PssWalkMarkerCreate.argtypes = [PVOID, ctypes.POINTER(HANDLE)]
        k32.PssWalkMarkerCreate.restype = DWORD
        k32.PssWalkSnapshot.argtypes = [HANDLE, DWORD, HANDLE, PVOID, DWORD]
        k32.PssWalkSnapshot.restype = DWORD
        k32.PssWalkMarkerFree.argtypes = [HANDLE]
        k32.PssWalkMarkerFree.restype = DWORD
        k32.PssFreeSnapshot.argtypes = [HANDLE, HANDLE]
        k32.PssFreeSnapshot.restype = DWORD

    def _bind_advapi32(self) -> None:
        advapi = self.advapi
        advapi.OpenProcessToken.argtypes = [HANDLE, DWORD, ctypes.POINTER(HANDLE)]
        advapi.OpenProcessToken.restype = BOOL
        advapi.LookupPrivilegeValueW.argtypes = [
            ctypes.c_wchar_p,
            ctypes.c_wchar_p,
            ctypes.POINTER(LUID),
        ]
        advapi.LookupPrivilegeValueW.restype = BOOL
        advapi.AdjustTokenPrivileges.argtypes = [
            HANDLE,
            BOOL,
            ctypes.POINTER(TOKEN_PRIVILEGES),
            DWORD,
            PVOID,
            PVOID,
        ]
        advapi.AdjustTokenPrivileges.restype = BOOL

    def format_error(self, code: int) -> str:
        # FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS
        buf = ctypes.create_unicode_buffer(2048)
        got = self.k32.FormatMessageW(
            0x00001000 | 0x00000200,
            None,
            int(code),
            0,
            buf,
            len(buf),
            None,
        )
        if not got:
            return "unknown Windows error"
        return buf.value.strip().rstrip(".")

    def status_error(self, function: str, status: int) -> PssError:
        return PssError(function, status, self.format_error(status))

    def close_handle(self, handle: Optional[int]) -> None:
        if handle and handle != INVALID_HANDLE_VALUE:
            self.k32.CloseHandle(HANDLE(handle))

    def enable_debug_privilege(self) -> tuple[bool, str]:
        """Enable SeDebugPrivilege; this grants access but does not attach a debugger."""

        TOKEN_QUERY = 0x0008
        TOKEN_ADJUST_PRIVILEGES = 0x0020
        SE_PRIVILEGE_ENABLED = 0x00000002
        ERROR_NOT_ALL_ASSIGNED = 1300

        token = HANDLE()
        if not self.advapi.OpenProcessToken(
            self.k32.GetCurrentProcess(),
            TOKEN_QUERY | TOKEN_ADJUST_PRIVILEGES,
            ctypes.byref(token),
        ):
            err = ctypes.get_last_error()
            return False, f"OpenProcessToken: {err} ({self.format_error(err)})"
        try:
            luid = LUID()
            if not self.advapi.LookupPrivilegeValueW(
                None, "SeDebugPrivilege", ctypes.byref(luid)
            ):
                err = ctypes.get_last_error()
                return False, f"LookupPrivilegeValueW: {err} ({self.format_error(err)})"
            privileges = TOKEN_PRIVILEGES()
            privileges.PrivilegeCount = 1
            privileges.Privileges[0].Luid = luid
            privileges.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED
            ctypes.set_last_error(0)
            if not self.advapi.AdjustTokenPrivileges(
                token,
                False,
                ctypes.byref(privileges),
                0,
                None,
                None,
            ):
                err = ctypes.get_last_error()
                return False, f"AdjustTokenPrivileges: {err} ({self.format_error(err)})"
            err = ctypes.get_last_error()
            if err == ERROR_NOT_ALL_ASSIGNED:
                return False, "SeDebugPrivilege is not present in this token"
            return True, "SeDebugPrivilege enabled"
        finally:
            self.close_handle(token.value)

    def open_process(self, pid: int) -> int:
        ctypes.set_last_error(0)
        handle = self.k32.OpenProcess(PROCESS_CAPTURE_ACCESS, False, pid)
        if not handle:
            err = ctypes.get_last_error()
            raise PssError("OpenProcess", err, self.format_error(err))
        return int(handle)

    def assert_native_x64_target(self, process: int) -> None:
        if self.is_wow64_process2 is None:
            return
        process_machine = USHORT()
        native_machine = USHORT()
        if not self.is_wow64_process2(
            HANDLE(process), ctypes.byref(process_machine), ctypes.byref(native_machine)
        ):
            err = ctypes.get_last_error()
            raise PssError("IsWow64Process2", err, self.format_error(err))
        # IMAGE_FILE_MACHINE_UNKNOWN means a native process. AMD64 is 0x8664.
        if process_machine.value != 0 or native_machine.value != 0x8664:
            raise RuntimeError(
                "target must be a native AMD64 process "
                f"(process_machine={process_machine.value:#x}, "
                f"native_machine={native_machine.value:#x})"
            )


def _pointer_value(value: Any) -> int:
    if value is None:
        return 0
    if isinstance(value, int):
        return value
    converted = ctypes.cast(value, ctypes.c_void_p).value
    return int(converted or 0)


def read_memory(
    api: WinAPI, process: int, address: int, size: int
) -> tuple[Optional[bytes], int, int]:
    """Return (data or None, bytes_read, last_error)."""

    if size < 0:
        raise ValueError("negative memory read size")
    if size == 0:
        return b"", 0, ERROR_SUCCESS
    buffer = ctypes.create_string_buffer(size)
    got = SIZE_T()
    ctypes.set_last_error(0)
    ok = api.k32.ReadProcessMemory(
        HANDLE(process),
        PVOID(address),
        buffer,
        size,
        ctypes.byref(got),
    )
    error = ctypes.get_last_error()
    if not ok and got.value == 0:
        return None, 0, int(error)
    data = bytes(buffer.raw[: got.value])
    if got.value != size and error == 0:
        error = ERROR_PARTIAL_COPY
    return data, int(got.value), int(error)


def query_memory(
    api: WinAPI, process: int, address: int
) -> tuple[Optional[MEMORY_BASIC_INFORMATION64], int]:
    mbi = MEMORY_BASIC_INFORMATION64()
    ctypes.set_last_error(0)
    got = api.k32.VirtualQueryEx(
        HANDLE(process),
        PVOID(address),
        ctypes.byref(mbi),
        ctypes.sizeof(mbi),
    )
    if not got:
        return None, int(ctypes.get_last_error())
    return mbi, ERROR_SUCCESS


def _append_span(
    spans: list[dict[str, Any]], kind: str, address: int, size: int, error: int = 0
) -> None:
    if size <= 0:
        return
    if spans:
        previous = spans[-1]
        previous_end = int(previous["_address_int"]) + int(previous["size"])
        if (
            previous["kind"] == kind
            and previous_end == address
            and int(previous.get("error_code", 0)) == error
        ):
            previous["size"] += size
            return
    span: dict[str, Any] = {
        "kind": kind,
        "address": f"0x{address:x}",
        "_address_int": address,
        "size": size,
    }
    if error:
        span["error_code"] = error
    spans.append(span)


def _write_zeros(stream: Any, digest: Any, size: int) -> None:
    zero = b"\x00" * 0x10000
    remaining = size
    while remaining:
        block = zero[: min(len(zero), remaining)]
        stream.write(block)
        digest.update(block)
        remaining -= len(block)


def dump_clone_range(
    api: WinAPI,
    clone_process: int,
    address: int,
    size: int,
    output_file: Path,
) -> dict[str, Any]:
    """Dump an address range, zero-filling holes while recording exact spans."""

    output_file.parent.mkdir(parents=True, exist_ok=True)
    temporary = output_file.with_name(output_file.name + ".part")
    spans: list[dict[str, Any]] = []
    digest = hashlib.sha256()
    bytes_read = 0
    cursor = address
    end = address + size

    try:
        with temporary.open("wb") as stream:
            while cursor < end:
                mbi, query_error = query_memory(api, clone_process, cursor)
                if mbi is None:
                    hole_size = end - cursor
                    _write_zeros(stream, digest, hole_size)
                    _append_span(spans, "hole", cursor, hole_size, query_error)
                    cursor = end
                    continue

                region_base = _pointer_value(mbi.BaseAddress)
                region_size = int(mbi.RegionSize)
                if region_size <= 0:
                    hole_size = min(0x1000, end - cursor)
                    _write_zeros(stream, digest, hole_size)
                    _append_span(spans, "hole", cursor, hole_size, ERROR_PARTIAL_COPY)
                    cursor += hole_size
                    continue
                region_end = max(cursor, region_base + region_size)
                segment_end = min(end, region_end)
                if segment_end <= cursor:
                    segment_end = min(end, cursor + 0x1000)

                protection = int(mbi.Protect)
                base_protection = protection & 0xFF
                readable = (
                    int(mbi.State) == MEM_COMMIT
                    and not (protection & PAGE_GUARD)
                    and base_protection in READABLE_PAGE_PROTECTIONS
                )
                if not readable:
                    hole_size = segment_end - cursor
                    _write_zeros(stream, digest, hole_size)
                    _append_span(spans, "hole", cursor, hole_size, ERROR_PARTIAL_COPY)
                    cursor = segment_end
                    continue

                while cursor < segment_end:
                    request = min(0x10000, segment_end - cursor)
                    data, got, read_error = read_memory(
                        api, clone_process, cursor, request
                    )
                    if data:
                        stream.write(data)
                        digest.update(data)
                        bytes_read += got
                        _append_span(spans, "read", cursor, got)
                        cursor += got
                    if got < request:
                        missing = request - got
                        _write_zeros(stream, digest, missing)
                        _append_span(
                            spans,
                            "hole",
                            cursor,
                            missing,
                            read_error or ERROR_PARTIAL_COPY,
                        )
                        cursor += missing
            stream.flush()
            os.fsync(stream.fileno())
        os.replace(temporary, output_file)
    except BaseException:
        try:
            temporary.unlink(missing_ok=True)
        except OSError:
            pass
        raise

    for span in spans:
        span.pop("_address_int", None)
    holes = [span for span in spans if span["kind"] == "hole"]
    return {
        "file": output_file.name,
        "base": f"0x{address:x}",
        "size": size,
        "bytes_read": bytes_read,
        "complete": bytes_read == size,
        "sha256": digest.hexdigest(),
        "holes": holes,
    }


def read_sparse_bytes(
    api: WinAPI, process: int, address: int, size: int
) -> tuple[bytes, int]:
    """Small in-memory counterpart to dump_clone_range, used for stack scoring."""

    output = bytearray(size)
    total_read = 0
    cursor = address
    end = address + size
    while cursor < end:
        mbi, _error = query_memory(api, process, cursor)
        if mbi is None or int(mbi.RegionSize) <= 0:
            cursor += min(0x1000, end - cursor)
            continue
        region_base = _pointer_value(mbi.BaseAddress)
        segment_end = min(end, max(cursor + 1, region_base + int(mbi.RegionSize)))
        protection = int(mbi.Protect)
        if (
            int(mbi.State) != MEM_COMMIT
            or protection & PAGE_GUARD
            or (protection & 0xFF) not in READABLE_PAGE_PROTECTIONS
        ):
            cursor = segment_end
            continue
        while cursor < segment_end:
            request = min(0x10000, segment_end - cursor)
            data, got, _read_error = read_memory(api, process, cursor, request)
            if data:
                offset = cursor - address
                output[offset : offset + got] = data
                total_read += got
            cursor += request
    return bytes(output), total_read


def filetime_to_int(value: FILETIME) -> int:
    return (int(value.dwHighDateTime) << 32) | int(value.dwLowDateTime)


def hex64(value: int) -> str:
    return f"0x{int(value) & 0xFFFFFFFFFFFFFFFF:x}"


GPR_CONTEXT_FIELDS = {
    "rax": "Rax",
    "rbx": "Rbx",
    "rcx": "Rcx",
    "rdx": "Rdx",
    "rsi": "Rsi",
    "rdi": "Rdi",
    "rsp": "Rsp",
    "rbp": "Rbp",
    "r8": "R8",
    "r9": "R9",
    "r10": "R10",
    "r11": "R11",
    "r12": "R12",
    "r13": "R13",
    "r14": "R14",
    "r15": "R15",
    "rip": "Rip",
}


def parse_context(raw: bytes) -> tuple[dict[str, Any], dict[str, int]]:
    """Parse the stable CONTEXT prefix and retain the entire record as base64."""

    if len(raw) < _field_offset(CONTEXT64, "FltSave"):
        raise RuntimeError(f"PSS returned a truncated CONTEXT record ({len(raw)} bytes)")
    padded = raw[: ctypes.sizeof(CONTEXT64)].ljust(ctypes.sizeof(CONTEXT64), b"\x00")
    context = CONTEXT64.from_buffer_copy(padded)
    registers_int = {
        name: int(getattr(context, field)) for name, field in GPR_CONTEXT_FIELDS.items()
    }
    registers_int["rflags"] = int(context.EFlags)
    registers_int["eflags"] = int(context.EFlags)
    registers = {name: hex64(value) for name, value in registers_int.items()}

    parsed: dict[str, Any] = {
        "size": len(raw),
        "context_flags": hex64(context.ContextFlags),
        "mxcsr": hex64(context.MxCsr),
        "home": {
            f"p{index}_home": hex64(getattr(context, f"P{index}Home"))
            for index in range(1, 7)
        },
        "segments": {
            "cs": hex64(context.SegCs),
            "ds": hex64(context.SegDs),
            "es": hex64(context.SegEs),
            "fs": hex64(context.SegFs),
            "gs": hex64(context.SegGs),
            "ss": hex64(context.SegSs),
        },
        "rflags": hex64(context.EFlags),
        "debug_registers": {
            name.lower(): hex64(getattr(context, name))
            for name in ("Dr0", "Dr1", "Dr2", "Dr3", "Dr6", "Dr7")
        },
        "gpr": {name: registers[name] for name in GPR_CONTEXT_FIELDS},
        "vector_control": hex64(context.VectorControl),
        "debug_control": hex64(context.DebugControl),
        "last_branch_to_rip": hex64(context.LastBranchToRip),
        "last_branch_from_rip": hex64(context.LastBranchFromRip),
        "last_exception_to_rip": hex64(context.LastExceptionToRip),
        "last_exception_from_rip": hex64(context.LastExceptionFromRip),
        "raw_sha256": hashlib.sha256(raw).hexdigest(),
        "raw_base64": base64.b64encode(raw).decode("ascii"),
    }
    return {"registers": registers, "context": parsed}, registers_int


def enumerate_processes(api: WinAPI, name_fragment: str) -> list[tuple[int, str]]:
    snapshot = api.k32.CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    snapshot_value = _pointer_value(snapshot)
    if not snapshot_value or snapshot_value == INVALID_HANDLE_VALUE:
        err = ctypes.get_last_error()
        raise PssError("CreateToolhelp32Snapshot", err, api.format_error(err))
    matches: list[tuple[int, str]] = []
    try:
        entry = PROCESSENTRY32W()
        entry.dwSize = ctypes.sizeof(entry)
        if not api.k32.Process32FirstW(HANDLE(snapshot_value), ctypes.byref(entry)):
            err = ctypes.get_last_error()
            raise PssError("Process32FirstW", err, api.format_error(err))
        needle = name_fragment.casefold()
        while True:
            executable = str(entry.szExeFile)
            if needle in executable.casefold():
                matches.append((int(entry.th32ProcessID), executable))
            if not api.k32.Process32NextW(HANDLE(snapshot_value), ctypes.byref(entry)):
                break
    finally:
        api.close_handle(snapshot_value)
    return matches


def read_vm_sample(
    api: WinAPI, process: int, *, monotonic_ns: Optional[int] = None
) -> Optional[dict[str, Any]]:
    sample_size = (VM_VIP_ADDRESS + 8) - VM_KEY_ADDRESS
    data, got, _error = read_memory(api, process, VM_KEY_ADDRESS, sample_size)
    if data is None or got != sample_size:
        return None
    key = struct.unpack_from("<I", data, 0)[0]
    vip = struct.unpack_from("<Q", data, VM_VIP_ADDRESS - VM_KEY_ADDRESS)[0]
    return {
        "monotonic_ns": monotonic_ns if monotonic_ns is not None else time.perf_counter_ns(),
        "utc": utc_now(),
        "key": key,
        "vip": vip,
    }


def public_vm_sample(sample: Optional[dict[str, Any]]) -> Optional[dict[str, Any]]:
    if sample is None:
        return None
    return {
        "monotonic_ns": int(sample["monotonic_ns"]),
        "utc": sample["utc"],
        "key": f"0x{int(sample['key']):08x}",
        "vip": hex64(int(sample["vip"])),
    }


def same_vm_state(left: dict[str, Any], right: dict[str, Any]) -> bool:
    return int(left["key"]) == int(right["key"]) and int(left["vip"]) == int(
        right["vip"]
    )


def utc_now() -> str:
    return _datetime.datetime.now(_datetime.timezone.utc).isoformat(
        timespec="microseconds"
    ).replace("+00:00", "Z")


def find_ready_target(
    api: WinAPI, name: str, wait_timeout: float
) -> tuple[int, str, int, dict[str, Any]]:
    """Choose the newest matching process whose fixed VM addresses are readable."""

    deadline = time.monotonic() + wait_timeout
    last_report = 0.0
    while True:
        matches = sorted(enumerate_processes(api, name), reverse=True)
        ready: list[tuple[int, str, int, dict[str, Any]]] = []
        for pid, executable in matches:
            try:
                process = api.open_process(pid)
            except PssError:
                continue
            try:
                api.assert_native_x64_target(process)
                sample = read_vm_sample(api, process)
                if sample is not None:
                    ready.append((pid, executable, process, sample))
                    process = 0
            except (PssError, RuntimeError):
                pass
            finally:
                if process:
                    api.close_handle(process)

        if ready:
            chosen = ready[0]
            for unused in ready[1:]:
                api.close_handle(unused[2])
            if len(ready) > 1:
                ids = ", ".join(str(item[0]) for item in ready)
                print(f"[!] multiple ready targets ({ids}); using newest PID {chosen[0]}")
            return chosen

        now = time.monotonic()
        if now >= deadline:
            if matches:
                ids = ", ".join(str(pid) for pid, _exe in matches)
                raise RuntimeError(
                    f"matching process(es) found ({ids}), but MaxHook VM memory did not "
                    f"become readable within {wait_timeout:g}s"
                )
            raise RuntimeError(
                f"no process name containing {name!r} appeared within {wait_timeout:g}s"
            )
        if now - last_report >= 5.0:
            if matches:
                print("[*] waiting for MaxHook fixed VM region to become readable ...")
            else:
                print(f"[*] waiting for a process name containing {name!r} ...")
            last_report = now
        time.sleep(0.25)


def wait_for_vm_region(
    api: WinAPI, process: int, wait_timeout: float
) -> dict[str, Any]:
    deadline = time.monotonic() + wait_timeout
    last_report = 0.0
    while True:
        sample = read_vm_sample(api, process)
        if sample is not None:
            return sample
        now = time.monotonic()
        if now >= deadline:
            raise RuntimeError(
                f"MaxHook VM memory did not become readable within {wait_timeout:g}s"
            )
        if now - last_report >= 5.0:
            print("[*] waiting for MaxHook fixed VM region to become readable ...")
            last_report = now
        time.sleep(0.25)


def _thread_from_entry(entry: PSS_THREAD_ENTRY) -> dict[str, Any]:
    context_address = _pointer_value(entry.ContextRecord)
    context_size = int(entry.SizeOfContextRecord)
    if not context_address or context_size == 0:
        raise RuntimeError(f"thread {entry.ThreadId} has no captured CONTEXT record")
    if context_size > 1024 * 1024:
        raise RuntimeError(
            f"thread {entry.ThreadId} returned implausible CONTEXT size {context_size}"
        )
    raw = ctypes.string_at(context_address, context_size)
    parsed, registers_int = parse_context(raw)
    thread: dict[str, Any] = {
        "thread_id": int(entry.ThreadId),
        "process_id": int(entry.ProcessId),
        "exit_status": int(entry.ExitStatus),
        "teb_base": hex64(_pointer_value(entry.TebBaseAddress)),
        "affinity_mask": hex64(int(entry.AffinityMask)),
        "priority": int(entry.Priority),
        "base_priority": int(entry.BasePriority),
        "win32_start_address": hex64(_pointer_value(entry.Win32StartAddress)),
        "flags": hex64(int(entry.Flags)),
        "suspend_count_at_capture": int(entry.SuspendCount),
        "times_100ns": {
            "create": filetime_to_int(entry.CreateTime),
            "exit": filetime_to_int(entry.ExitTime),
            "kernel": filetime_to_int(entry.KernelTime),
            "user": filetime_to_int(entry.UserTime),
            "capture": filetime_to_int(entry.CaptureTime),
        },
        **parsed,
        "_registers_int": registers_int,
        "_teb_int": _pointer_value(entry.TebBaseAddress),
    }
    return thread


def walk_snapshot_threads(api: WinAPI, snapshot: int) -> list[dict[str, Any]]:
    marker = HANDLE()
    status = int(api.k32.PssWalkMarkerCreate(None, ctypes.byref(marker)))
    if status != ERROR_SUCCESS:
        raise api.status_error("PssWalkMarkerCreate", status)
    marker_value = _pointer_value(marker)
    try:
        threads: list[dict[str, Any]] = []
        while True:
            entry = PSS_THREAD_ENTRY()
            status = int(
                api.k32.PssWalkSnapshot(
                    HANDLE(snapshot),
                    PSS_WALK_THREADS,
                    HANDLE(marker_value),
                    ctypes.byref(entry),
                    ctypes.sizeof(entry),
                )
            )
            if status == ERROR_NO_MORE_ITEMS:
                break
            if status != ERROR_SUCCESS:
                raise api.status_error("PssWalkSnapshot(PSS_WALK_THREADS)", status)
            # ContextRecord is only promised to remain valid for the marker's
            # lifetime, so _thread_from_entry copies it on this iteration.
            threads.append(_thread_from_entry(entry))
        return threads
    finally:
        if marker_value:
            free_status = int(api.k32.PssWalkMarkerFree(HANDLE(marker_value)))
            if free_status != ERROR_SUCCESS:
                print(
                    f"[!] PssWalkMarkerFree returned {free_status}: "
                    f"{api.format_error(free_status)}",
                    file=sys.stderr,
                )


def populate_stack_bounds(api: WinAPI, clone: int, thread: dict[str, Any]) -> None:
    teb = int(thread["_teb_int"])
    stack_base = 0
    stack_limit = 0
    error_text: Optional[str] = None
    if teb:
        # NT_TIB64.ExceptionList @ +0, StackBase @ +8, StackLimit @ +0x10.
        data, got, error = read_memory(api, clone, teb + 8, 16)
        if data is not None and got == 16:
            stack_base, stack_limit = struct.unpack("<QQ", data)
        else:
            error_text = f"ReadProcessMemory(TEB): {error} ({api.format_error(error)})"
    else:
        error_text = "PSS returned a null TEB address"

    plausible = (
        0 < stack_limit <= stack_base < 0x0000800000000000
        and stack_base - stack_limit <= 0x40000000
    )
    if not plausible:
        if error_text is None:
            error_text = (
                f"implausible NT_TIB stack bounds: limit={stack_limit:#x}, "
                f"base={stack_base:#x}"
            )
        stack_base = 0
        stack_limit = 0
    thread["stack_base"] = hex64(stack_base)
    thread["stack_limit"] = hex64(stack_limit)
    thread["_stack_base_int"] = stack_base
    thread["_stack_limit_int"] = stack_limit
    if error_text:
        thread["stack_bounds_error"] = error_text


def score_thread(
    api: WinAPI,
    clone: int,
    thread: dict[str, Any],
    clone_key: int,
    clone_vip: int,
    stack_scan_bytes: int,
) -> tuple[int, list[str], list[dict[str, str]], list[dict[str, str]]]:
    regs: dict[str, int] = thread["_registers_int"]
    score = 0
    reasons: list[str] = []
    rip = regs["rip"]
    rbp = regs["rbp"]
    rsp = regs["rsp"]

    if BUGLAND_BASE <= rip < BUGLAND_BASE + BUGLAND_SIZE:
        score += 120
        reasons.append(f"+120 RIP in .bugland ({rip:#x})")
    if rip in {REPORT_WORKER_CLEAR_ENTRY, REPORT_WORKER_VM_ENTRY}:
        score += 140
        reasons.append(f"+140 RIP equals recovered report-worker entry ({rip:#x})")
    if rbp == VM_RBP:
        score += 100
        reasons.append(f"+100 RBP equals VM context ({VM_RBP:#x})")
    elif BUGLAND_BASE <= rbp < BUGLAND_BASE + BUGLAND_SIZE:
        score += 15
        reasons.append(f"+15 RBP points into .bugland ({rbp:#x})")

    non_pc_gprs = {name: value for name, value in regs.items() if name not in {"rip", "rflags", "eflags"}}
    vm_rbp_regs = [name for name, value in non_pc_gprs.items() if value == VM_RBP]
    if vm_rbp_regs and "rbp" not in vm_rbp_regs:
        score += 70
        reasons.append(f"+70 GPR holds VM context ({', '.join(vm_rbp_regs)})")

    if clone_vip:
        exact_vip_regs = [name for name, value in non_pc_gprs.items() if value == clone_vip]
        near_vip_regs = [
            name
            for name, value in non_pc_gprs.items()
            if value != clone_vip and abs(value - clone_vip) <= 0x40
        ]
        if rip == clone_vip:
            score += 90
            reasons.append(f"+90 RIP equals captured VIP ({clone_vip:#x})")
        if exact_vip_regs:
            score += 80
            reasons.append(f"+80 GPR equals captured VIP ({', '.join(exact_vip_regs)})")
        elif near_vip_regs:
            score += 35
            reasons.append(f"+35 GPR is within 0x40 of VIP ({', '.join(near_vip_regs)})")

    vip_slot_regs = [
        name for name, value in non_pc_gprs.items() if value == VM_VIP_ADDRESS
    ]
    if vip_slot_regs:
        score += 55
        reasons.append(
            f"+55 GPR points at VM VIP slot ({', '.join(vip_slot_regs)})"
        )

    bugland_gprs = [
        name
        for name, value in non_pc_gprs.items()
        if BUGLAND_BASE <= value < BUGLAND_BASE + BUGLAND_SIZE
    ]
    if bugland_gprs:
        points = min(24, len(bugland_gprs) * 4)
        score += points
        reasons.append(f"+{points} GPR(s) point into .bugland ({', '.join(bugland_gprs)})")

    key_regs = [
        name
        for name, value in non_pc_gprs.items()
        if (value & 0xFFFFFFFF) == clone_key
    ]
    if clone_key and key_regs:
        score += 10
        reasons.append(f"+10 GPR low DWORD equals captured key ({', '.join(key_regs)})")

    stack_base = int(thread["_stack_base_int"])
    stack_limit = int(thread["_stack_limit_int"])
    return_addresses: list[dict[str, str]] = []
    report_markers: list[dict[str, str]] = []
    if stack_limit <= rsp < stack_base and stack_scan_bytes > 0:
        scan_size = min(stack_scan_bytes, stack_base - rsp)
        stack_data, bytes_read = read_sparse_bytes(api, clone, rsp, scan_size)
        if bytes_read:
            for offset in range(0, len(stack_data) - 7, 8):
                value = struct.unpack_from("<Q", stack_data, offset)[0]
                if BUGLAND_BASE <= value < BUGLAND_BASE + BUGLAND_SIZE:
                    return_addresses.append(
                        {"stack_address": hex64(rsp + offset), "value": hex64(value)}
                    )
                    if len(return_addresses) >= 32:
                        break
            for offset in range(0, len(stack_data) - 7, 8):
                value = struct.unpack_from("<Q", stack_data, offset)[0]
                if value in {REPORT_VIRTUAL_RETURN, REPORT_WORKER_CLEAR_ENTRY}:
                    report_markers.append(
                        {"stack_address": hex64(rsp + offset), "value": hex64(value)}
                    )
                    if len(report_markers) >= 8:
                        break
        if return_addresses:
            points = min(60, 25 + (len(return_addresses) - 1) * 3)
            score += points
            reasons.append(
                f"+{points} stack contains {len(return_addresses)} .bugland return address(es)"
            )
        if report_markers:
            points = 100 + min(20, (len(report_markers) - 1) * 5)
            score += points
            reasons.append(
                f"+{points} stack contains recovered report-worker marker(s)"
            )
    return score, reasons, return_addresses, report_markers


def choose_and_dump_candidate_stacks(
    api: WinAPI,
    clone: int,
    threads: list[dict[str, Any]],
    capture_dir: Path,
    clone_key: int,
    clone_vip: int,
    candidate_count: int,
    minimum_score: int,
    stack_scan_bytes: int,
    max_stack_bytes: int,
) -> list[dict[str, Any]]:
    for thread in threads:
        populate_stack_bounds(api, clone, thread)
        score, reasons, returns, report_markers = score_thread(
            api,
            clone,
            thread,
            clone_key,
            clone_vip,
            stack_scan_bytes,
        )
        thread["score"] = score
        thread["score_reasons"] = reasons
        thread["bugland_stack_returns"] = returns
        thread["report_stack_markers"] = report_markers
        thread["candidate"] = False

    ranked = sorted(threads, key=lambda item: (-int(item["score"]), int(item["thread_id"])))
    candidates = [item for item in ranked if int(item["score"]) >= minimum_score][
        :candidate_count
    ]
    if not candidates and ranked and int(ranked[0]["score"]) > 0:
        candidates = ranked[:1]
        candidates[0]["score_reasons"].append(
            f"fallback: best non-zero score below minimum {minimum_score}"
        )

    for thread in candidates:
        thread["candidate"] = True
        stack_base = int(thread["_stack_base_int"])
        stack_limit = int(thread["_stack_limit_int"])
        if not stack_base or not stack_limit:
            thread["stack"] = {"error": "valid TEB stack bounds unavailable"}
            continue
        dump_base = stack_limit
        requested_size = stack_base - stack_limit
        truncated = False
        if max_stack_bytes and requested_size > max_stack_bytes:
            # Preserve the current call chain (RSP -> StackBase).  Java stacks
            # are normally far below this cap, so this is corrupt-bound safety.
            rsp = int(thread["_registers_int"]["rsp"])
            dump_base = max(stack_limit, stack_base - max_stack_bytes)
            if stack_limit <= rsp < dump_base:
                dump_base = rsp
            if stack_base - dump_base > max_stack_bytes:
                dump_base = stack_base - max_stack_bytes
            requested_size = stack_base - dump_base
            truncated = True
        stack_file = capture_dir / f"thread_{thread['thread_id']}_stack.bin"
        stack_meta = dump_clone_range(
            api, clone, dump_base, requested_size, stack_file
        )
        stack_meta["teb_stack_base"] = hex64(stack_base)
        stack_meta["teb_stack_limit"] = hex64(stack_limit)
        stack_meta["truncated"] = truncated
        thread["stack"] = stack_meta
    return candidates


def _strip_internal_thread_fields(thread: dict[str, Any]) -> None:
    for key in list(thread):
        if key.startswith("_"):
            del thread[key]


def atomic_write_json(path: Path, payload: dict[str, Any]) -> None:
    temporary = path.with_name(path.name + ".part")
    try:
        with temporary.open("w", encoding="utf-8", newline="\n") as stream:
            json.dump(payload, stream, ensure_ascii=False, indent=2)
            stream.write("\n")
            stream.flush()
            os.fsync(stream.fileno())
        os.replace(temporary, path)
    except BaseException:
        try:
            temporary.unlink(missing_ok=True)
        except OSError:
            pass
        raise


def snapshot_capture_flags(extended_context: bool) -> int:
    flags = PSS_CAPTURE_VA_CLONE | PSS_CAPTURE_THREADS | PSS_CAPTURE_THREAD_CONTEXT
    if extended_context:
        flags |= PSS_CAPTURE_THREAD_CONTEXT_EXTENDED
    return flags


def capture_one_snapshot(
    api: WinAPI,
    target_process: int,
    pid: int,
    executable: str,
    capture_dir: Path,
    sequence: int,
    trigger_stable: dict[str, Any],
    trigger_active: dict[str, Any],
    trigger_history: Iterable[dict[str, Any]],
    args: argparse.Namespace,
) -> dict[str, Any]:
    capture_dir.mkdir(parents=True, exist_ok=False)
    flags = snapshot_capture_flags(args.extended_context)
    context_flags = CONTEXT_ALL | (CONTEXT_XSTATE if args.extended_context else 0)
    snapshot = HANDLE()
    snapshot_value = 0
    clone_value = 0
    pss_started_ns = time.perf_counter_ns()
    try:
        status = int(
            api.k32.PssCaptureSnapshot(
                HANDLE(target_process),
                flags,
                context_flags,
                ctypes.byref(snapshot),
            )
        )
        pss_returned_ns = time.perf_counter_ns()
        snapshot_value = _pointer_value(snapshot)
        if status != ERROR_SUCCESS:
            raise api.status_error("PssCaptureSnapshot", status)
        if not snapshot_value:
            raise RuntimeError("PssCaptureSnapshot succeeded but returned a null snapshot")

        clone_info = PSS_VA_CLONE_INFORMATION()
        status = int(
            api.k32.PssQuerySnapshot(
                HANDLE(snapshot_value),
                PSS_QUERY_VA_CLONE_INFORMATION,
                ctypes.byref(clone_info),
                ctypes.sizeof(clone_info),
            )
        )
        if status != ERROR_SUCCESS:
            raise api.status_error("PssQuerySnapshot(PSS_QUERY_VA_CLONE_INFORMATION)", status)
        clone_value = _pointer_value(clone_info.VaCloneHandle)
        if not clone_value:
            raise RuntimeError("PssQuerySnapshot returned a null VA clone process handle")
        clone_pid = int(api.k32.GetProcessId(HANDLE(clone_value)))

        clone_sample = read_vm_sample(api, clone_value)
        clone_sample_error = None
        if clone_sample is None:
            # Some protected/custom mappings are absent or unreadable in a PSS
            # VA clone even though thread contexts are present.  The VM tuple is
            # useful for ranking but must not be allowed to discard the only
            # synchronized CONTEXT records.  Fall back to the transition sample
            # solely for scoring and label it as non-clone-synchronous.
            clone_sample_error = (
                "MaxHook VM key/VIP addresses were unreadable in the VA clone; "
                "thread contexts and sparse clone dumps were retained"
            )
            scoring_sample = trigger_active
            scoring_sample_source = "trigger_active_fallback_not_clone_synchronous"
            print(f"    warning: {clone_sample_error}", flush=True)
        else:
            scoring_sample = clone_sample
            scoring_sample_source = "pss_va_clone"

        threads = walk_snapshot_threads(api, snapshot_value)
        if not threads:
            raise RuntimeError("PSS thread walk returned no threads")

        extraction_started_ns = time.perf_counter_ns()
        memory: dict[str, Any] = {}
        print("    dumping complete .bugland from clone ...", flush=True)
        memory["bugland"] = dump_clone_range(
            api,
            clone_value,
            BUGLAND_BASE,
            BUGLAND_SIZE,
            capture_dir / "bugland.bin",
        )
        memory["kuser_shared_data"] = dump_clone_range(
            api,
            clone_value,
            KUSER_SHARED_DATA,
            KUSER_SHARED_DATA_SIZE,
            capture_dir / "kuser_shared_data.bin",
        )

        candidates = choose_and_dump_candidate_stacks(
            api,
            clone_value,
            threads,
            capture_dir,
            int(scoring_sample["key"]),
            int(scoring_sample["vip"]),
            args.candidate_count,
            args.min_score,
            args.stack_scan_bytes,
            args.max_stack_bytes,
        )
        extraction_finished_ns = time.perf_counter_ns()

        selected = candidates[0] if candidates else None
        selected_registers = dict(selected["registers"]) if selected else None
        selected_thread_id = int(selected["thread_id"]) if selected else None

        for thread in threads:
            _strip_internal_thread_fields(thread)
        threads.sort(key=lambda item: (-int(item["score"]), int(item["thread_id"])))

        payload: dict[str, Any] = {
            "schema": "maxhook.pss.capture/v1",
            "capture": {
                "utc": utc_now(),
                "sequence": sequence,
                "target_pid": pid,
                "target_executable": executable,
                "clone_pid": clone_pid,
                "open_process_access": f"0x{PROCESS_CAPTURE_ACCESS:08x}",
                "debug_attach": False,
                "capture_flags": f"0x{flags:08x}",
                "thread_context_flags": f"0x{context_flags:08x}",
                "extended_context": bool(args.extended_context),
                "pss_capture_duration_ms": (pss_returned_ns - pss_started_ns) / 1e6,
                "clone_extraction_duration_ms": (
                    extraction_finished_ns - extraction_started_ns
                )
                / 1e6,
                "note": (
                    "pss_capture_duration_ms is the only phase that may briefly "
                    "quiesce the target; all extraction is from the VA clone"
                ),
            },
            "addresses": {
                "image_base": hex64(IMAGE_BASE),
                "bugland_base": hex64(BUGLAND_BASE),
                "bugland_size": BUGLAND_SIZE,
                "vm_rbp": hex64(VM_RBP),
                "vm_key_address": hex64(VM_KEY_ADDRESS),
                "vm_vip_address": hex64(VM_VIP_ADDRESS),
                "kuser_shared_data": hex64(KUSER_SHARED_DATA),
            },
            "trigger": {
                "stable": public_vm_sample(trigger_stable),
                "active": public_vm_sample(trigger_active),
                "history": [public_vm_sample(item) for item in trigger_history],
            },
            "clone_sample": public_vm_sample(clone_sample) if clone_sample else None,
            "clone_sample_error": clone_sample_error,
            "thread_scoring_vm_sample": {
                "source": scoring_sample_source,
                "sample": public_vm_sample(scoring_sample),
            },
            "memory": memory,
            "selected_thread_id": selected_thread_id,
            "selected_registers": selected_registers,
            "threads": threads,
        }
        atomic_write_json(capture_dir / "capture.json", payload)
        return payload
    finally:
        # VaCloneHandle is owned by the snapshot and must not be CloseHandle'd
        # separately.  PssFreeSnapshot releases both descriptor and clone.
        if snapshot_value:
            free_status = int(
                api.k32.PssFreeSnapshot(
                    api.k32.GetCurrentProcess(), HANDLE(snapshot_value)
                )
            )
            if free_status != ERROR_SUCCESS:
                print(
                    f"[!] PssFreeSnapshot returned {free_status}: "
                    f"{api.format_error(free_status)}",
                    file=sys.stderr,
                )


def run_self_test(api: WinAPI, layout: dict[str, Any], extended: bool) -> int:
    """Exercise capture/query/walk/clone-RPM against this Python process."""

    marker_bytes = (
        b"MAXHOOK_PSS_SELF_TEST\x00"
        + os.urandom(32)
        + struct.pack("<Q", time.perf_counter_ns())
    )
    marker_buffer = ctypes.create_string_buffer(marker_bytes)
    marker_address = ctypes.addressof(marker_buffer)
    flags = snapshot_capture_flags(extended)
    context_flags = CONTEXT_ALL | (CONTEXT_XSTATE if extended else 0)
    current_process = api.k32.GetCurrentProcess()
    snapshot = HANDLE()
    snapshot_value = 0
    walk_marker = HANDLE()
    walk_marker_value = 0
    started = time.perf_counter_ns()
    try:
        status = int(
            api.k32.PssCaptureSnapshot(
                current_process, flags, context_flags, ctypes.byref(snapshot)
            )
        )
        captured = time.perf_counter_ns()
        snapshot_value = _pointer_value(snapshot)
        if status != ERROR_SUCCESS:
            raise api.status_error("PssCaptureSnapshot(self-test)", status)

        clone_info = PSS_VA_CLONE_INFORMATION()
        status = int(
            api.k32.PssQuerySnapshot(
                HANDLE(snapshot_value),
                PSS_QUERY_VA_CLONE_INFORMATION,
                ctypes.byref(clone_info),
                ctypes.sizeof(clone_info),
            )
        )
        if status != ERROR_SUCCESS:
            raise api.status_error("PssQuerySnapshot(self-test)", status)
        clone = _pointer_value(clone_info.VaCloneHandle)
        if not clone:
            raise RuntimeError("self-test returned a null clone handle")

        copied, got, read_error = read_memory(
            api, clone, marker_address, len(marker_bytes)
        )
        if copied != marker_bytes or got != len(marker_bytes):
            raise RuntimeError(
                "self-test clone memory mismatch "
                f"(got={got}, error={read_error}, address={marker_address:#x})"
            )

        status = int(api.k32.PssWalkMarkerCreate(None, ctypes.byref(walk_marker)))
        if status != ERROR_SUCCESS:
            raise api.status_error("PssWalkMarkerCreate(self-test)", status)
        walk_marker_value = _pointer_value(walk_marker)
        thread_count = 0
        context_sizes: set[int] = set()
        current_tid_seen = False
        while True:
            entry = PSS_THREAD_ENTRY()
            status = int(
                api.k32.PssWalkSnapshot(
                    HANDLE(snapshot_value),
                    PSS_WALK_THREADS,
                    HANDLE(walk_marker_value),
                    ctypes.byref(entry),
                    ctypes.sizeof(entry),
                )
            )
            if status == ERROR_NO_MORE_ITEMS:
                break
            if status != ERROR_SUCCESS:
                raise api.status_error("PssWalkSnapshot(self-test)", status)
            thread_count += 1
            context_sizes.add(int(entry.SizeOfContextRecord))
            if int(entry.ThreadId) == int(api.k32.GetCurrentThreadId()):
                current_tid_seen = True
            context_address = _pointer_value(entry.ContextRecord)
            if not context_address or int(entry.SizeOfContextRecord) < 0x100:
                raise RuntimeError(
                    f"self-test thread {entry.ThreadId} returned invalid CONTEXT"
                )
            raw = ctypes.string_at(context_address, int(entry.SizeOfContextRecord))
            parsed, _registers = parse_context(raw)
            flags_value = int(parsed["context"]["context_flags"], 0)
            if not (flags_value & CONTEXT_AMD64):
                raise RuntimeError(
                    f"self-test thread {entry.ThreadId} is not an AMD64 CONTEXT"
                )
        if not thread_count:
            raise RuntimeError("self-test PSS thread walk was empty")

        result = {
            "ok": True,
            "platform": platform.platform(),
            "python": sys.version.split()[0],
            "pointer_size": ctypes.sizeof(PVOID),
            "layout": layout,
            "capture_flags": f"0x{flags:08x}",
            "thread_context_flags": f"0x{context_flags:08x}",
            "capture_duration_ms": (captured - started) / 1e6,
            "clone_pid": int(api.k32.GetProcessId(HANDLE(clone))),
            "marker_address": hex64(marker_address),
            "marker_clone_read_verified": True,
            "thread_count": thread_count,
            "context_sizes": sorted(context_sizes),
            "current_thread_seen": current_tid_seen,
        }
        print(json.dumps(result, ensure_ascii=False, indent=2))
        return 0
    finally:
        if walk_marker_value:
            status = int(api.k32.PssWalkMarkerFree(HANDLE(walk_marker_value)))
            if status != ERROR_SUCCESS:
                print(
                    f"[!] self-test PssWalkMarkerFree returned {status}: "
                    f"{api.format_error(status)}",
                    file=sys.stderr,
                )
        if snapshot_value:
            status = int(
                api.k32.PssFreeSnapshot(current_process, HANDLE(snapshot_value))
            )
            if status != ERROR_SUCCESS:
                print(
                    f"[!] self-test PssFreeSnapshot returned {status}: "
                    f"{api.format_error(status)}",
                    file=sys.stderr,
                )


def build_argument_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description=(
            "Poll MaxHook's VM key/VIP and capture stable->active transitions with "
            "the Windows Process Snapshotting API (no debugger attach)."
        ),
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    target = parser.add_mutually_exclusive_group()
    target.add_argument("--pid", type=int, help="target process ID")
    target.add_argument(
        "--name",
        default="javaw.exe",
        help="process-name fragment used for automatic target discovery",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path(__file__).resolve().parent / "pss_out",
        help="output root (captures are placed under <root>/<pid>/)",
    )
    parser.add_argument("--captures", type=int, default=1, help="number of transitions")
    parser.add_argument(
        "--poll-ms", type=float, default=2.0, help="key/VIP polling interval in ms"
    )
    parser.add_argument(
        "--stable-samples",
        type=int,
        default=10,
        help="equal consecutive samples required before arming",
    )
    parser.add_argument(
        "--timeout",
        type=float,
        default=300.0,
        help="transition-monitoring timeout in seconds",
    )
    parser.add_argument(
        "--wait-timeout",
        type=float,
        default=180.0,
        help="process/MaxHook-load wait timeout in seconds",
    )
    parser.add_argument(
        "--capture-now",
        action="store_true",
        help="capture the first snapshot immediately after VM memory is readable",
    )
    parser.add_argument(
        "--extended-context",
        action="store_true",
        help=(
            "also request PSS_CAPTURE_THREAD_CONTEXT_EXTENDED/CONTEXT_XSTATE; "
            "off by default because the fixed CONTEXT_ALL record is sufficient"
        ),
    )
    parser.add_argument(
        "--candidate-count",
        type=int,
        default=8,
        help="maximum candidate thread stacks to dump per capture",
    )
    parser.add_argument(
        "--min-score",
        type=int,
        default=20,
        help="minimum VM-thread candidate score",
    )
    parser.add_argument(
        "--stack-scan-bytes",
        type=lambda text: int(text, 0),
        default=0x10000,
        help="bytes above each RSP scanned for .bugland return addresses",
    )
    parser.add_argument(
        "--max-stack-bytes",
        type=lambda text: int(text, 0),
        default=0x4000000,
        help="per-candidate stack dump safety cap (0 means unlimited)",
    )
    parser.add_argument(
        "--no-se-debug",
        action="store_true",
        help="do not try to enable SeDebugPrivilege before OpenProcess",
    )
    parser.add_argument(
        "--self-test",
        action="store_true",
        help="validate structure layout and exercise PSS against this process",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="validate layout/options and print the planned configuration only",
    )
    return parser


def validate_arguments(parser: argparse.ArgumentParser, args: argparse.Namespace) -> None:
    if args.pid is not None and args.pid <= 0:
        parser.error("--pid must be positive")
    if not (1 <= args.captures <= 32):
        parser.error("--captures must be between 1 and 32")
    if not (0.1 <= args.poll_ms <= 1000.0):
        parser.error("--poll-ms must be between 0.1 and 1000")
    if not (1 <= args.stable_samples <= 100000):
        parser.error("--stable-samples must be positive")
    if args.timeout <= 0 or args.wait_timeout <= 0:
        parser.error("--timeout and --wait-timeout must be positive")
    if not (1 <= args.candidate_count <= 256):
        parser.error("--candidate-count must be between 1 and 256")
    if args.stack_scan_bytes < 0 or args.max_stack_bytes < 0:
        parser.error("stack sizes cannot be negative")


def dry_run_payload(args: argparse.Namespace, layout: dict[str, Any]) -> dict[str, Any]:
    flags = snapshot_capture_flags(args.extended_context)
    context_flags = CONTEXT_ALL | (CONTEXT_XSTATE if args.extended_context else 0)
    return {
        "ok": True,
        "dry_run": True,
        "platform": platform.platform(),
        "python": sys.version.split()[0],
        "target": {"pid": args.pid, "name": None if args.pid else args.name},
        "capture_flags": f"0x{flags:08x}",
        "thread_context_flags": f"0x{context_flags:08x}",
        "open_process_access": f"0x{PROCESS_CAPTURE_ACCESS:08x}",
        "addresses": {
            "bugland": f"{BUGLAND_BASE:#x}+{BUGLAND_SIZE:#x}",
            "vm_rbp": hex64(VM_RBP),
            "key": hex64(VM_KEY_ADDRESS),
            "vip": hex64(VM_VIP_ADDRESS),
            "kuser": f"{KUSER_SHARED_DATA:#x}+{KUSER_SHARED_DATA_SIZE:#x}",
        },
        "layout": layout,
        "output": str(args.output.resolve()),
        "no_debug_attach": True,
    }


def monitor_and_capture(
    api: WinAPI,
    process: int,
    pid: int,
    executable: str,
    initial_sample: dict[str, Any],
    args: argparse.Namespace,
) -> int:
    output_root = args.output.resolve() / str(pid)
    output_root.mkdir(parents=True, exist_ok=True)
    print(
        f"[*] target PID={pid} ({executable}); output={output_root}",
        flush=True,
    )
    print(
        f"[*] polling key={VM_KEY_ADDRESS:#x}, VIP={VM_VIP_ADDRESS:#x} "
        f"every {args.poll_ms:g}ms; arm after {args.stable_samples} stable samples",
        flush=True,
    )

    history: deque[dict[str, Any]] = deque(maxlen=64)
    history.append(initial_sample)
    last = initial_sample
    stable_count = 1
    armed: Optional[dict[str, Any]] = None
    captured_count = 0
    deadline = time.monotonic() + args.timeout
    last_status = time.monotonic()

    if args.capture_now:
        armed = dict(initial_sample)
        active = dict(initial_sample)
        active["monotonic_ns"] = time.perf_counter_ns()
        active["utc"] = utc_now()
        print("[*] --capture-now requested", flush=True)
        captured_count += 1
        stamp = _datetime.datetime.now(_datetime.timezone.utc).strftime(
            "%Y%m%dT%H%M%S.%fZ"
        )
        capture_dir = output_root / f"capture_{stamp}_{captured_count:02d}"
        payload = capture_one_snapshot(
            api,
            process,
            pid,
            executable,
            capture_dir,
            captured_count,
            armed,
            active,
            list(history),
            args,
        )
        print(
            f"[+] capture {captured_count}/{args.captures}: {capture_dir / 'capture.json'} "
            f"(PSS {payload['capture']['pss_capture_duration_ms']:.3f}ms, "
            f"selected TID={payload['selected_thread_id']})",
            flush=True,
        )
        if captured_count >= args.captures:
            return 0
        armed = None
        stable_count = 1

    sleep_seconds = args.poll_ms / 1000.0
    while captured_count < args.captures:
        if time.monotonic() >= deadline:
            raise RuntimeError(
                f"timed out after {args.timeout:g}s with "
                f"{captured_count}/{args.captures} capture(s)"
            )
        time.sleep(sleep_seconds)
        sample = read_vm_sample(api, process)
        if sample is None:
            raise RuntimeError("target exited or MaxHook VM memory became unreadable")
        history.append(sample)

        if same_vm_state(sample, last):
            stable_count += 1
            if armed is None and stable_count >= args.stable_samples:
                armed = dict(sample)
                print(
                    f"[*] armed at stable key={sample['key']:#010x}, "
                    f"VIP={sample['vip']:#x}",
                    flush=True,
                )
        else:
            if armed is not None and not same_vm_state(sample, armed):
                print(
                    f"[!] VM active: key {armed['key']:#010x}->{sample['key']:#010x}, "
                    f"VIP {armed['vip']:#x}->{sample['vip']:#x}; capturing PSS clone",
                    flush=True,
                )
                captured_count += 1
                stamp = _datetime.datetime.now(_datetime.timezone.utc).strftime(
                    "%Y%m%dT%H%M%S.%fZ"
                )
                capture_dir = output_root / f"capture_{stamp}_{captured_count:02d}"
                payload = capture_one_snapshot(
                    api,
                    process,
                    pid,
                    executable,
                    capture_dir,
                    captured_count,
                    armed,
                    sample,
                    list(history),
                    args,
                )
                print(
                    f"[+] capture {captured_count}/{args.captures}: "
                    f"{capture_dir / 'capture.json'} "
                    f"(PSS {payload['capture']['pss_capture_duration_ms']:.3f}ms, "
                    f"selected TID={payload['selected_thread_id']})",
                    flush=True,
                )
                armed = None
            stable_count = 1
        last = sample

        now = time.monotonic()
        if now - last_status >= 10.0:
            state = "armed" if armed is not None else "waiting for stable state"
            print(
                f"[*] {state}; key={sample['key']:#010x}, VIP={sample['vip']:#x}, "
                f"captures={captured_count}/{args.captures}",
                flush=True,
            )
            last_status = now
    return 0


def main(argv: Optional[list[str]] = None) -> int:
    parser = build_argument_parser()
    args = parser.parse_args(argv)
    validate_arguments(parser, args)
    try:
        layout = validate_native_layout()
        if args.dry_run:
            print(json.dumps(dry_run_payload(args, layout), ensure_ascii=False, indent=2))
            return 0

        api = WinAPI()
        if args.self_test:
            return run_self_test(api, layout, args.extended_context)

        if not args.no_se_debug:
            enabled, message = api.enable_debug_privilege()
            prefix = "[*]" if enabled else "[!]"
            print(f"{prefix} {message}", flush=True)

        process = 0
        try:
            if args.pid is None:
                pid, executable, process, initial_sample = find_ready_target(
                    api, args.name, args.wait_timeout
                )
            else:
                pid = int(args.pid)
                executable = f"pid_{pid}"
                process = api.open_process(pid)
                api.assert_native_x64_target(process)
                initial_sample = wait_for_vm_region(api, process, args.wait_timeout)
            return monitor_and_capture(
                api, process, pid, executable, initial_sample, args
            )
        finally:
            if process:
                api.close_handle(process)
    except KeyboardInterrupt:
        print("\n[!] interrupted; all PSS/Win32 handles were released", file=sys.stderr)
        return 130
    except (PssError, RuntimeError, OSError) as error:
        print(f"[!] {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
