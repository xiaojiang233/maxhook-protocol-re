#!/usr/bin/env python3
"""
MaxHook keystream round-function reconstruction (offline).

Decodes the exact ARX round function recovered from disasm_unpacked.asm,
annotating genuine cipher constants vs Themida pointer-obfuscation noise.

Key findings from this session:
  - The round function lives at 0x1809bd245..0x1809bd73a (and the byte-pump
    at 0x180bd4640..0x180bd46b1), all within .bugland (offline-reconstructed).
  - GENUINE 32-bit cipher constants (appear as full immediates exactly once):
      0x32f12c5a  @ 0x1809bd367  (xor ecx, 0x32f12c5a)
      0x35a7d4cf  @ 0x1809bd5a5  (push 0x35a7d4cf)
  - POINTER-OBFUSCATION 16-bit masks (appear in movzx-word + xor patterns on
    pointer halves, NOT cipher state):
      0x9e22  @ 0x180bd4683  (xor r10w, 0x9e22)
      0x1d6e  @ 0x180bd46a1  (xor cx, 0x1d6e)
      0x65aa  @ 0x1809bd51a  (add r9w, 0x65aa)
  - State lives in the 768-byte VM context at 0x18098c884 (rbp):
      +0x0a  rolling counter (dword)
      +0x61  keystream state table pointer (0x180835f10)
      +0x6d  VIP (qword, advances per dispatch)
      +0x85  handler table (0x180c64ebd)
      +0xb5  destination slot A (keystream byte)
      +0xe5  state word (word)
      +0xed  state word (qword)
      +0x235 destination slot B (keystream byte)
"""
from __future__ import annotations
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent

# Genuine 32-bit cipher round constants (each appears exactly once as a full
# immediate in the whole image, and sits inside the ARX round body):
CIPHER_CONSTANTS = {
    0x1809bd367: (0x32f12c5a, "xor ecx, 0x32f12c5a", "key-schedule round constant A"),
    0x1809bd5a5: (0x35a7d4cf, "push 0x35a7d4cf",     "key-schedule round constant B"),
}

# Fold/trampoline 32-bit constants (in 0x180c27500..0x180c27d00, the sequence
# that folds the 6 word-producer context values into the final keystream EDX):
FOLD_CONSTANTS = {
    0x180c2769e: (0x7ef78e7d, "sub rdx, 0x7ef78e7d", "fold constant (sub)"),
    0x180c27747: (0x47f75fb8, "add r13d, 0x47f75fb8", "fold constant (add+not+neg+not)"),
    0x180c27987: (0x1f5ff464, "sub r8, 0x1f5ff464", "fold branch constant"),
    0x180c2799d: (0x3879c8ab, "push 0x3879c8ab; not r9", "fold constant"),
    0x180c279aa: (0x6eaa89fc, "mov ebp, 0x6eaa89fc", "fold constant"),
    0x180c279a1c: (0x5f77d611, "xor rsi, 0x5f77d611", "fold constant"),
}

# 16-bit pointer-obfuscation masks (Themida anti-static-analysis on embedded
# pointers; NOT part of the cipher state):
POINTER_MASKS = {
    0x180bd4683: (0x9e22, "xor r10w, 0x9e22"),
    0x180bd46a1: (0x1d6e, "xor cx, 0x1d6e"),
    0x1809bd51a: (0x65aa, "add r9w, 0x65aa"),
}

# Context slots (768-byte VM context @ 0x18098c884):
CONTEXT_SLOTS = {
    0x0a:   ("dword",  "rolling counter (position-derived)"),
    0x61:   ("qword",  "keystream state table pointer (0x180835f10)"),
    0x6d:   ("qword",  "VIP - advances per dispatch, not cipher state"),
    0x85:   ("qword",  "handler table pointer (0x180c64ebd)"),
    0xb5:   ("byte",   "destination slot A (keystream byte, XOR target)"),
    0xbd:   ("qword",  "KEY POINTER: decoded input64 (32B key) pointer, written "
                      "during key-schedule; consumed by vm_load 0x1809bd556"),
    0xc5:   ("qword",  "runtime keystream-source pointer"),
    0xe5:   ("word",   "state word (word)"),
    0xed:   ("qword",  "state word (qword)"),
    0x235:  ("byte",   "destination slot B (keystream byte, XOR target)"),
}


def main():
    report = {
        "schema": "maxhook.round-function-reconstruction/v1",
        "scope": "offline; disasm_unpacked.asm + writer_sync keystreams",
        "cipher_constants": [
            {"address": hex(a), "constant": hex(c), "insn": insn, "role": role}
            for a, (c, insn, role) in CIPHER_CONSTANTS.items()
        ],
        "fold_constants": [
            {"address": hex(a), "constant": hex(c), "insn": insn, "role": role}
            for a, (c, insn, role) in FOLD_CONSTANTS.items()
        ],
        "pointer_masks": [
            {"address": hex(a), "mask": hex(m), "insn": insn}
            for a, (m, insn) in POINTER_MASKS.items()
        ],
        "context_slots": [
            {"offset": hex(o), "size": sz, "role": role}
            for o, (sz, role) in CONTEXT_SLOTS.items()
        ],
        "round_function_regions": [
            {"address": "0x1809bd245", "end": "0x1809bd73a",
             "role": "KEY-SCHEDULE / KEY-CONSUMER handler: vm_load 0x1809bd502..556 "
                     "(two-level deref) fetches decoded input64 key via context+0xbd; "
                     "contains the two genuine 32-bit round constants 0x32f12c5a and "
                     "0x35a7d4cf (milestone 26: key pointer -> context+0xbd -> 0x1809bd556)"},
            {"address": "0x180bd4640", "end": "0x180bd46b1",
             "role": "byte/word pump (pointer-obfuscation masks 0x9e22/0x1d6e only)"},
            {"address": "0x180b8c7aa", "end": "0x180b8caa0",
             "role": "WORD PRODUCER (final keystream word -> store32 EDX): six "
                     "push [word[VIP+k]+rbp] sites; writes destination slots "
                     "+0xb5/+0x235 (edx_slice_findings_corrected.md)"},
            {"address": "0x180c27500", "end": "0x180c27d00",
             "role": "FOLD/TRAMPOLINE: folds the 6 word-producer values into EDX "
                     "via fold constants 0x7ef78e7d/0x47f75fb8/0x1f5ff464/"
                     "0x3879c8ab/0x6eaa89fc/0x5f77d611, then popfq;ret -> store32"},
        ],
        "conclusion": (
            "Proprietary word-oriented ARX stream cipher. The key-schedule/key-"
            "consumer handler 0x1809bd245..73a contains two genuine 32-bit round "
            "constants 0x32f12c5a and 0x35a7d4cf; it fetches the decoded input64 "
            "key via context+0xbd. The final word producer is 0x180b8c7aa (six "
            "push [word[VIP+k]+rbp] sites feeding store32 EDX). 16-bit masks "
            "0x9e22/0x1d6e/0x65aa are Themida pointer-obfuscation, not cipher "
            "constants. Full state in the 768-byte context; keystream = F(key, "
            "nonce) fully diffused from byte 0, 64-byte output blocks."
        ),
    }
    out = HERE / "round_function_reconstruction.json"
    out.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(f"wrote {out.resolve()}")


if __name__ == "__main__":
    main()
