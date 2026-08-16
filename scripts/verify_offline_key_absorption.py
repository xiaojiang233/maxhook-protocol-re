#!/usr/bin/env python3
"""Verify the offline-only 32-byte MaxHook key absorption schedule."""
from __future__ import annotations
import json
from pathlib import Path

HERE=Path(__file__).resolve().parent
BASE=HERE/'diff_key_baseline_2000k.json'
DIFFS={
  0: HERE/'offline_key_byte0bit0_diff.json',
  1: HERE/'offline_key_byte1bit0_diff.json',
  2: HERE/'offline_key_byte2bit0_diff.json',
  31:HERE/'offline_key_byte31bit0_diff.json',
}
OUT=HERE/'offline_key_absorption_report.json'

def main()->int:
    baseline=json.loads(BASE.read_text('utf-8')); jumps=baseline['vm_indirect_jumps']
    rounds=[]
    for step,item in enumerate(jumps):
        if item['target'].lower()!='0x18098abf8' or item['vip'].lower()!='0x181be1445':continue
        ctx=bytes.fromhex(item['context_hex']); ptr=int.from_bytes(ctx[0x45:0x4d],'little')
        if 0x7FFE1FEC70 <= ptr < 0x7FFE1FEC90:
            rounds.append({'step':step,'instruction':item['instruction'],'pointer':ptr,'byte_index':ptr-0x7FFE1FEC70})
    assert len(rounds)==32
    assert [x['byte_index'] for x in rounds]==list(range(32))
    assert all(rounds[i]['instruction']-rounds[i-1]['instruction']==14070 for i in range(1,32))
    assert all(rounds[i]['step']-rounds[i-1]['step']==26 for i in range(1,32))

    variants={}
    base_first_instruction=1422141
    for index,path in DIFFS.items():
        diff=json.loads(path.read_text('utf-8'))
        first=diff['first_context_influence']['0xe']
        assert first['instruction']==base_first_instruction+index*14070
        assert first['producer_target'].lower()=='0x18098abf8'
        assert first['producer_body'].lower()=='0x180aa57d7'
        stack=diff['first_stack_influence']
        assert hex(0x90+index) in stack
        assert hex(0x50+index) in stack
        variants[str(index)]={
            'first_context_instruction':first['instruction'],
            'first_context_offset':'0xe',
            'baseline_byte':first['baseline'],'variant_byte':first['variant'],
            'first_stack_offsets':[hex(0x90+index),hex(0x50+index)],
        }
    result={
      'schema':'maxhook.offline-key-absorption/v1',
      'decoded_key_copy':{
        'source_heap':'0x200001000e0','destination_stack':'0x7ffe1fec70',
        'bytes':32,'copy_instruction':'0x1805d0c36/0x1805d0c3a',
        'copy_write_instruction':'0x1805d0c41/0x1805d0c45',
      },
      'round':{
        'count':32,'vm_jumps_per_byte':26,'native_instructions_per_byte':14070,
        'producer_target':'0x18098abf8','producer_body':'0x180aa57d7',
        'producer_vip':'0x181be1445','key_pointer_context_slot':'0x45',
        'injection_context_slot':'0x0e','injection_instruction':'0x180aa5bce',
      },
      'round_entries':rounds,
      'differential_vectors':variants,
      'control_flow_identical':True,
    }
    OUT.write_text(json.dumps(result,indent=2)+'\n','utf-8')
    print(json.dumps(result,indent=2));return 0
if __name__=='__main__':raise SystemExit(main())
