#!/usr/bin/env python3
"""Symbolically execute the proven MaxHook store32 trampoline stack shuffles.
Offline only. Shows which incoming virtual-stack cells become RCX, RDX, flags,
and the RET target at 0x180c2775c.
"""
from __future__ import annotations

BLOCKS = [
    0x180C278A7, 0x180C27786, 0x180C27652, 0x180C27BF9,
    0x180C279B4, 0x180C27673, 0x180C27BD0, 0x180C27A5B,
    0x180C27900, 0x180C2775C,
]

# Hand-lifted from target/original_unpacked_writer_chain_disasm.txt and
# target/writer_exact_predecessor_blocks.txt. Each tuple is (operation, operand).
OPS = {
    0x180C278A7: [('add',1),('dup',None),('load','r11'),('add',1),('add',1),('dup',None),('dup',None),('pop','r12'),('add',1),('add',1)],
    0x180C27786: [('dup',None),('dup',None),('load','r13'),('add',1),('add',1)],
    0x180C27652: [('add',1),('dup',None),('load','r14'),('add',1),('add',1),('dup',None)],
    0x180C27BF9: [('dup',None),('load','r15'),('add',1),('add',1),('add',1),('dup',None)],
    0x180C279B4: [('dup',None),('load','rdi'),('add',1),('add',1),('add',1),('dup',None),('dup',None),('load','rsi'),('add',1),('add',1)],
    0x180C27673: [('add',1),('dup',None),('dup',None),('load','rbp'),('add',1),('add',1),('add',1),('dup',None)],
    0x180C27BD0: [('dup',None),('pop','rbx'),('add',1),('add',1),('dup',None),('dup',None),('load','rdx'),('add',1),('add',1)],
    0x180C27A5B: [('add',1),('dup',None),('dup',None),('load','rcx')],
    0x180C27900: [('add',1),('add',1),('add',1),('dup',None),('dup',None),('load','rax'),('add',1),('add',1),('add',1)],
    0x180C2775C: [('pop','rflags'),('pop','rip')],
}

def main() -> None:
    # List index 0 is current [RSP]. Seed enough caller cells.
    stack = [f'S{i}' for i in range(128)]
    regs: dict[str,str] = {}
    for block in BLOCKS:
        before = list(stack[:8])
        for op, arg in OPS[block]:
            if op == 'add':
                del stack[:arg]
            elif op == 'dup':
                stack.insert(0, stack[0])
            elif op == 'load':
                regs[arg] = stack[0]
            elif op == 'pop':
                regs[arg] = stack.pop(0)
            else:
                raise AssertionError(op)
        print(f'{block:#x}: before={before} after={stack[:8]} regs={regs}')
    print('\nFINAL')
    for r in ('rcx','rdx','rflags','rip','rax','rbx','rbp','rsi','rdi','r11','r12','r13','r14','r15'):
        print(f'{r:>6} <- {regs.get(r, "unchanged")}')

if __name__ == '__main__':
    main()
