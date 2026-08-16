#!/usr/bin/env python3
"""Independent high-level reconstruction of MaxHook's 64-byte key absorption stage.

The protected VM processes key||zero32 one byte per fixed 26-jump round. At the
post-round boundary all key dependence is exactly two stack arrays:
  stack[0x50+i] = block[i] ^ 0x5c
  stack[0x90+i] = block[i] ^ 0x36
All context bytes, registers, control state and other stack bytes are independent
of key. This module replaces 1664 VM jumps with those exact equations.
"""
from __future__ import annotations
import argparse,json
from copy import deepcopy
from pathlib import Path

HERE=Path(__file__).resolve().parent
BASELINE=HERE/'diff_key_baseline_2350k_block.json'
RANDOM_VECTOR=HERE/'diff_key_sequence001f_2350k.json'
OUT=HERE/'offline_key_absorbed_baseline_state.json'

def locate_boundary(document:dict)->dict:
    jumps=document['vm_indirect_jumps']
    for i,item in enumerate(jumps):
        if item['target'].lower()=='0x18098abf8' and item.get('pointer45')=='0x7ffe1fecaf':
            return deepcopy(jumps[i+26])
    raise ValueError('64-byte absorption boundary not found')

def absorb_key(key:bytes, baseline_state:dict)->dict:
    if len(key)!=32:raise ValueError('key must be 32 bytes')
    result=deepcopy(baseline_state)
    stack=bytearray.fromhex(result['stack_top_hex'])
    block=key+b'\x00'*32
    for i,value in enumerate(block):
        stack[0x50+i]=value^0x5c
        stack[0x90+i]=value^0x36
    result['stack_top_hex']=stack.hex()
    return result

def comparable(state:dict)->dict:
    return {k:state[k] for k in ('target','vip','key_low32','rsp','context_hex','stack_top_hex','registers')}

def self_test()->dict:
    base_doc=json.loads(BASELINE.read_text('utf-8'));random_doc=json.loads(RANDOM_VECTOR.read_text('utf-8'))
    baseline=locate_boundary(base_doc);expected=locate_boundary(random_doc)
    key=bytes(range(32));actual=absorb_key(key,baseline)
    assert comparable(actual)==comparable(expected)
    # Also verify the complete 64-byte block equations directly.
    stack=bytes.fromhex(actual['stack_top_hex']);block=key+b'\x00'*32
    assert stack[0x50:0x90]==bytes(x^0x5c for x in block)
    assert stack[0x90:0xd0]==bytes(x^0x36 for x in block)
    return {
      'random_key_00_to_1f_full_state_match':'pass',
      'context_match':'pass','registers_match':'pass','control_match':'pass',
      'stack_block_xor_5c':'pass','stack_block_xor_36':'pass',
      'replaced_vm_jumps':64*26,
    }

def main()->int:
    ap=argparse.ArgumentParser();ap.add_argument('--key',help='64 hex chars');ap.add_argument('--output',type=Path,default=OUT);args=ap.parse_args()
    baseline=locate_boundary(json.loads(BASELINE.read_text('utf-8')))
    key=bytes.fromhex(args.key) if args.key else bytes([0xbb])*32
    result={'schema':'maxhook.offline-key-absorbed-state/v1','key_hex':key.hex(),'state':absorb_key(key,baseline),'self_test':self_test()}
    args.output.write_text(json.dumps(result,indent=2)+'\n','utf-8');print(json.dumps(result['self_test'],indent=2));return 0
if __name__=='__main__':raise SystemExit(main())
