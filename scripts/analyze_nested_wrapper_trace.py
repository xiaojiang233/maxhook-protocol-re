#!/usr/bin/env python3
"""Summarize one concrete nested-VM wrapper path without guessing semantics.

Given an emulator JSON trace window and entry/exit VM-jump instruction numbers,
this resolves executed handler-table stubs/bodies, concrete context writes, RSP
movement and before/after context/stack diffs. It is an evidence extractor for
trace_guided_vm_lifter.py, not a crypto implementation.
"""
from __future__ import annotations
import argparse, json, struct, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE / ".pydeps"))
from capstone import CS_AC_WRITE, CS_ARCH_X86, CS_MODE_64, Cs
from capstone.x86 import X86_OP_MEM

BUG_BASE = 0x180980000
CTX_BASE = 0x18098C884
HANDLER_TABLE = 0x180C64EBD
REG_PARENT = {
    "eax":"rax","ax":"rax","al":"rax","ah":"rax",
    "ebx":"rbx","bx":"rbx","bl":"rbx","bh":"rbx",
    "ecx":"rcx","cx":"rcx","cl":"rcx","ch":"rcx",
    "edx":"rdx","dx":"rdx","dl":"rdx","dh":"rdx",
    "esi":"rsi","si":"rsi","sil":"rsi",
    "edi":"rdi","di":"rdi","dil":"rdi",
    "ebp":"rbp","bp":"rbp","bpl":"rbp",
    "esp":"rsp","sp":"rsp","spl":"rsp",
}
for _n in range(8, 16):
    REG_PARENT[f"r{_n}d"] = f"r{_n}"
    REG_PARENT[f"r{_n}w"] = f"r{_n}"
    REG_PARENT[f"r{_n}b"] = f"r{_n}"


def ranges(diff: list[int]) -> list[tuple[int,int]]:
    if not diff: return []
    out=[]; start=prev=diff[0]
    for value in diff[1:]:
        if value != prev + 1:
            out.append((start,prev)); start=value
        prev=value
    out.append((start,prev)); return out


def main() -> int:
    ap=argparse.ArgumentParser()
    ap.add_argument("trace_json", type=Path)
    ap.add_argument("--start-instr", type=int, required=True,
                    help="indirect jump instruction entering the wrapper")
    ap.add_argument("--end-instr", type=int, required=True,
                    help="indirect jump instruction leaving the wrapper")
    ap.add_argument("--snapshots", type=Path,
                    default=HERE/"encrypt_vm_jump_snapshots_registers_700k.json")
    ap.add_argument("--bugland", type=Path, default=HERE/"runtime_bugland2.bin")
    ap.add_argument("--output", type=Path)
    args=ap.parse_args()

    data=json.loads(args.trace_json.read_text("utf-8")); window=data["trace_window"]
    entries=[e for e in window if args.start_instr < int(e["instruction"]) <= args.end_instr]
    if not entries: raise SystemExit("requested trace range is absent")
    blob=args.bugland.read_bytes(); md=Cs(CS_ARCH_X86,CS_MODE_64); md.detail=True

    table={}
    for index in range(1612):
        off=HANDLER_TABLE-BUG_BASE+index*8
        target=struct.unpack_from("<Q",blob,off)[0]
        table[target]=index
    bodies={}
    for target,index in table.items():
        off=target-BUG_BASE
        if 0 <= off <= len(blob)-5 and blob[off] == 0xE9:
            rel=struct.unpack_from("<i",blob,off+1)[0]
            bodies[(target+5+rel)&((1<<64)-1)] = (index,target)

    def reg_value(reg_id:int, regs:dict) -> int:
        if not reg_id:return 0
        name=md.reg_name(reg_id); name=REG_PARENT.get(name,name)
        return int(regs.get(name,"0"),16)
    def mem_addr(mem,regs):
        return (reg_value(mem.base,regs)+reg_value(mem.index,regs)*mem.scale+mem.disp)&((1<<64)-1)

    writes=[]; executed=[]; seen=set()
    for e in entries:
        address=int(e["rip"],16)
        insn=next(md.disasm(bytes.fromhex(e["bytes"]),address))
        if address in table and ("stub",address) not in seen:
            seen.add(("stub",address)); executed.append({"kind":"stub","index":hex(table[address]),"address":hex(address)})
        if address in bodies and ("body",address) not in seen:
            index,stub=bodies[address]; seen.add(("body",address)); executed.append({"kind":"body","index":hex(index),"stub":hex(stub),"address":hex(address)})
        for op in insn.operands:
            if op.type != X86_OP_MEM or not (op.access & CS_AC_WRITE): continue
            address2=mem_addr(op.mem,e["registers"])
            if CTX_BASE <= address2 < CTX_BASE+0x200:
                writes.append({
                    "instruction":e["instruction"],"rip":hex(address),
                    "mnemonic":insn.mnemonic,"op_str":insn.op_str,
                    "context_offset":hex(address2-CTX_BASE),
                    "registers":e["registers"],
                })

    snapshot_data=json.loads(args.snapshots.read_text("utf-8"))["vm_indirect_jumps"]
    before=next(x for x in snapshot_data if int(x["instruction"])==args.start_instr)
    after=next(x for x in snapshot_data if int(x["instruction"])==args.end_instr)
    ca=bytes.fromhex(before["context_hex"]); cb=bytes.fromhex(after["context_hex"])
    sa=bytes.fromhex(before["stack_top_hex"]); sb=bytes.fromhex(after["stack_top_hex"])
    context_ranges=[]
    for a,b in ranges([i for i,(x,y) in enumerate(zip(ca,cb)) if x!=y]):
        context_ranges.append({"start":hex(a),"end":hex(b),"before":ca[a:b+1].hex(),"after":cb[a:b+1].hex()})
    stack_ranges=[]
    for a,b in ranges([i for i,(x,y) in enumerate(zip(sa,sb)) if x!=y]):
        stack_ranges.append({"start":hex(a),"end":hex(b),"before":sa[a:b+1].hex(),"after":sb[a:b+1].hex()})

    result={
        "trace":str(args.trace_json),"start_instruction":args.start_instr,
        "end_instruction":args.end_instr,"executed_instructions":len(entries),
        "entry":{"target":before["target"],"vip":before["vip"],"key":before["key_low32"],"rsp":before["rsp"]},
        "exit":{"target":after["target"],"vip":after["vip"],"key":after["key_low32"],"rsp":after["rsp"]},
        "rsp_delta":int(after["rsp"],16)-int(before["rsp"],16),
        "executed_handler_entries":executed,
        "context_writes":writes,
        "context_diff_ranges":context_ranges,
        "stack_diff_ranges":stack_ranges,
    }
    encoded=json.dumps(result,indent=2)
    if args.output:args.output.write_text(encoded+"\n","utf-8")
    print(encoded); return 0

if __name__=="__main__": raise SystemExit(main())
