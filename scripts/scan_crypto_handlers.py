"""Static scan of .bugland for stream-cipher core primitives.

Focus: identify which of the 1612 VM handlers implement cryptographic
primitives (XOR/ADD/SUB/shift/lookup/GF-mul), and locate the cipher core.

Approach:
1. Read the handler table at 0x180C64EBD (1612 qwords) and map each to a
   .bugland offset (VA - 0x180980000).
2. For each handler stub, disassemble a short window and classify the
   primitive operations (xor/add/sub/rol/ror/shl/shr/mul/sbox-lookup).
3. Report handlers that contain ONLY xor/add/sub/rotate/shift chains (the
   classic ARX/stream-cipher core building blocks) vs data-movement.
"""

from __future__ import annotations
import struct
from pathlib import Path

try:
    from capstone import Cs, CS_ARCH_X86, CS_MODE_64
except ImportError:
    Cs = None

DLL = Path(r"E:\Coding\S1mple\target\MaxHook.runtime-unpacked.dll")
BUG = Path(r"E:\Coding\S1mple\target\runtime_bugland2.bin")
BUG_BASE = 0x180980000
TABLE_VA = 0x180C64EBD
N_HANDLERS = 1612

# file offset for a VA in the DLL image: assume PE headers + sections; simplest
# is to compute RVA = VA - ImageBase and find section.  ImageBase=0x180000000.


def read_pe_sections():
    data = DLL.read_bytes()
    pe_off = struct.unpack_from("<I", data, 0x3C)[0]
    nsec = struct.unpack_from("<H", data, pe_off + 6)[0]
    opt_off = pe_off + 24
    opt_size = struct.unpack_from("<H", data, pe_off + 20)[0]
    sec_off = opt_off + opt_size
    sections = []
    for i in range(nsec):
        off = sec_off + i * 40
        name = data[off:off+8].rstrip(b"\x00").decode("latin1")
        vsize = struct.unpack_from("<I", data, off + 8)[0]
        va = struct.unpack_from("<I", data, off + 12)[0]
        rawsize = struct.unpack_from("<I", data, off + 16)[0]
        rawptr = struct.unpack_from("<I", data, off + 20)[0]
        sections.append(dict(name=name, va=va, vsize=vsize, rawsize=rawsize, rawptr=rawptr))
    return data, sections


def va_to_off(data, sections, va):
    rva = va - 0x180000000
    for s in sections:
        if s["va"] <= rva < s["va"] + max(s["vsize"], s["rawsize"]):
            return s["rawptr"] + (rva - s["va"])
    return None


def main():
    data, sections = read_pe_sections()
    print("Sections:")
    for s in sections:
        print(f"  {s['name']:8s} va=0x{s['va']:08x} vsize=0x{s['vsize']:08x} "
              f"raw=0x{s['rawptr']:08x}+0x{s['rawsize']:08x}")

    # handler table
    tbl_off = va_to_off(data, sections, TABLE_VA)
    print(f"\nHandler table VA=0x{TABLE_VA:x} -> file off=0x{tbl_off:x}" if tbl_off else "TABLE NOT IN DLL")
    bug = BUG.read_bytes()
    print(f".bugland size = {len(bug)} (0x{len(bug):x})")

    handlers = []
    for i in range(N_HANDLERS):
        q = struct.unpack_from("<Q", data, tbl_off + i * 8)[0]
        # map VA to bugland offset
        if BUG_BASE <= q < BUG_BASE + len(bug):
            handlers.append((i, q, q - BUG_BASE))
        else:
            handlers.append((i, q, None))

    in_bug = sum(1 for _, _, o in handlers if o is not None)
    print(f"handlers: {N_HANDLERS} total, {in_bug} mapped into .bugland")

    # classify each handler by disassembling the first ~32 bytes of the stub
    if Cs is None:
        print("capstone not available; skipping disasm")
        return

    md = Cs(CS_ARCH_X86, CS_MODE_64)

    # opcode classification sets
    XOR = {"xor", "pxor", "xorpd", "xmm"}
    ROT = {"rol", "ror", "rcl", "rcr"}
    SHIFT = {"shl", "shr", "sal", "sar"}
    ADD = {"add", "adc", "paddb", "paddw", "paddd", "paddq"}
    SUB = {"sub", "sbb", "psubb", "psubw", "psubd", "psubq"}
    MUL = {"mul", "imul", "pmullw", "pmulld", "pmuludq"}
    AND = {"and", "pand", "andn", "andpd", "andps"}
    OR = {"or", "por", "orpd", "orps"}
    NOT = {"not"}
    LOOKUP = set()  # will detect via mov reg,[reg+disp] with small disp + movzx

    def classify(va):
        code = bug[va - BUG_BASE: va - BUG_BASE + 48]
        ops = set()
        for ins in md.disasm(code, va):
            ops.add(ins.mnemonic)
            if len(ops) >= 64:
                break
        return ops

    from collections import Counter
    cryptoish = []
    for i, va, off in handlers:
        if off is None:
            continue
        ops = classify(va)
        # a "crypto primitive" handler has ALU/rotate/shift ops and little else
        alu = ops & (ROT | SHIFT | XOR | ADD | SUB | MUL | AND | OR | NOT)
        # count of non-movement, non-jump ops
        moved = ops & {"mov", "lea", "push", "pop", "jmp", "call", "ret", "nop",
                       "movzx", "movsx", "movsxd", "xchg", "cmovne", "cmove", "cmovz",
                       "cmovnz", "cmovs", "cmovns", "cmova", "cmovb", "cmovg", "cmovl",
                       "cmovae", "cmovbe", "cmovge", "cmovle", "test", "cmp", "jne",
                       "je", "jz", "jnz", "jb", "ja", "jg", "jl", "jae", "jbe", "jge",
                       "jle", "js", "jns", "inc", "dec", "neg", "cdqe", "cqo", "clc",
                       "stc", "cmc", "bt", "bts", "btr", "btc", "bsf", "bsr", "bswap",
                       "movbe", "adcx", "adox", "sete", "setne", "setz", "setnz",
                       "setb", "seta", "setg", "setl", "cmpxchg", "xadd", "lahf"}
        crypto_only = alu - moved
        if len(alu) >= 2 and len(crypto_only) >= 1:
            cryptoish.append((i, va, sorted(alu)))

    print(f"\n{len(cryptoish)} handlers with >=2 ALU/rotate/shift ops")
    # group by operation signature
    sig_counter = Counter()
    for i, va, alu in cryptoish:
        # signature: which classes are present
        sig = tuple(sorted(alu))
        sig_counter[sig] += 1

    print("\nTop operation signatures (handler counts):")
    for sig, cnt in sig_counter.most_common(60):
        print(f"  {cnt:4d}  {sig}")

    # Specifically: find handlers using ONLY rotate+add+xor (classic ARX), and
    # handlers using a 256-entry table lookup (S-box).
    arx = [c for c in cryptoish if c[2] and (set(c[2]) & ROT) and (set(c[2]) & XOR)]
    print(f"\n{len(arx)} handlers with ROTATE + XOR (ARX candidates)")
    for i, va, alu in arx[:40]:
        print(f"  idx={i:04x}  va=0x{va:x}  off=0x{va-BUG_BASE:x}  ops={alu}")


if __name__ == "__main__":
    main()
