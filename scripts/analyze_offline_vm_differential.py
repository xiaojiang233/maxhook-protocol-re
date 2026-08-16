#!/usr/bin/env python3
"""Compare two purely-offline VM jump traces and identify key/nonce influence."""
from __future__ import annotations
import argparse, json, struct
from collections import Counter
from pathlib import Path

BUG_BASE=0x180980000
HANDLER_TABLE=0x180C64EBD

def resolve_body(blob:bytes,target:int)->int|None:
    off=target-BUG_BASE
    if off<0 or off+5>len(blob) or blob[off]!=0xE9:return None
    rel=struct.unpack_from('<i',blob,off+1)[0]
    return (target+5+rel)&((1<<64)-1)

def main()->int:
    ap=argparse.ArgumentParser()
    ap.add_argument('baseline',type=Path);ap.add_argument('variant',type=Path)
    ap.add_argument('--bugland',type=Path,default=Path(__file__).resolve().parent/'runtime_bugland2.bin')
    ap.add_argument('--output',type=Path,required=True)
    args=ap.parse_args()
    A=json.loads(args.baseline.read_text('utf-8'));B=json.loads(args.variant.read_text('utf-8'))
    a=A['vm_indirect_jumps'];b=B['vm_indirect_jumps'];blob=args.bugland.read_bytes()
    if len(a)!=len(b):raise ValueError(f'jump lengths differ: {len(a)} != {len(b)}')
    first_any=None;control=[];timeline=[];ctx_first={};stack_first={};target_counts=Counter()
    for i,(x,y) in enumerate(zip(a,b)):
        control_fields=[k for k in ('instruction','source','target','vip','key_low32','rsp') if x.get(k)!=y.get(k)]
        cx=bytes.fromhex(x['context_hex']);cy=bytes.fromhex(y['context_hex'])
        sx=bytes.fromhex(x['stack_top_hex']);sy=bytes.fromhex(y['stack_top_hex'])
        cd=[j for j,(u,v) in enumerate(zip(cx,cy)) if u!=v]
        sd=[j for j,(u,v) in enumerate(zip(sx,sy)) if u!=v]
        rd=[k for k in x.get('registers',{}) if x['registers'][k]!=y.get('registers',{}).get(k)]
        if first_any is None and (control_fields or cd or sd or rd):first_any=i
        if control_fields:control.append({'step':i,'fields':control_fields})
        new_ctx=[];new_stack=[]
        for off in cd:
            if off not in ctx_first:
                producer=a[i-1] if i else None
                ctx_first[off]={
                    'step':i,'instruction':x['instruction'],'baseline':cx[off],'variant':cy[off],
                    'entry_target':x['target'],'entry_target_body':hex(resolve_body(blob,int(x['target'],16)) or 0),
                    'producer_target':None if producer is None else producer['target'],
                    'producer_body':None if producer is None else hex(resolve_body(blob,int(producer['target'],16)) or 0),
                    'producer_exit_source':x['source'],'vip':x['vip'],
                };new_ctx.append(off)
        for off in sd:
            if off not in stack_first:
                stack_first[off]={'step':i,'instruction':x['instruction'],'baseline':sx[off],'variant':sy[off]};new_stack.append(off)
        if cd or sd or rd or control_fields:
            timeline.append({'step':i,'instruction':x['instruction'],'source':x['source'],'target':x['target'],'vip':x['vip'],
                             'context_offsets':[hex(z) for z in cd],'stack_offsets':[hex(z) for z in sd],
                             'registers':rd,'new_context_offsets':[hex(z) for z in new_ctx],
                             'new_stack_offsets':[hex(z) for z in new_stack]})
            target_counts[x['target']]+=1
    result={
        'schema':'maxhook.offline-vm-differential/v1',
        'baseline':str(args.baseline),'variant':str(args.variant),
        'jump_count':len(a),'instruction_range':[a[0]['instruction'],a[-1]['instruction']] if a else None,
        'decoded_key_reads':{'baseline':A.get('fast_diff_key_reads',[]),'variant':B.get('fast_diff_key_reads',[])},
        'first_any_difference_step':first_any,'control_flow_difference_count':len(control),
        'control_flow_identical':not control,'differing_steps':len(timeline),
        'first_context_influence':{hex(k):v for k,v in sorted(ctx_first.items(),key=lambda z:z[1]['step'])},
        'first_stack_influence':{hex(k):v for k,v in sorted(stack_first.items(),key=lambda z:z[1]['step'])},
        'affected_target_counts':dict(target_counts),
        'timeline':timeline,
    }
    args.output.write_text(json.dumps(result,indent=2)+'\n','utf-8')
    print(json.dumps({k:result[k] for k in ('jump_count','instruction_range','first_any_difference_step','control_flow_identical','differing_steps','first_context_influence','first_stack_influence')},indent=2))
    return 0
if __name__=='__main__':raise SystemExit(main())
