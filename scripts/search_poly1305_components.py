#!/usr/bin/env python3
"""Search Poly1305 r and s sources independently over offline vectors."""
from __future__ import annotations
import hashlib,hmac,json,struct,sys
from pathlib import Path
from search_hmac_layout import candidates_for
from maxhook_protocol_reference import DOMAIN_LABEL,chacha20_block,derive_domain_key
HERE=Path(__file__).resolve().parent
SAMPLES=json.loads((HERE/'crypto_verify_set.json').read_text('utf-8'))['samples']
P=(1<<130)-5; MASK=(1<<128)-1; CLAMP=0x0ffffffc0ffffffc0ffffffc0fffffff

def transforms(name,b):
 yield name,b
 yield name+':rev',b[::-1]
 yield name+':swap32',b''.join(b[i:i+4][::-1] for i in range(0,len(b),4))
 yield name+':swap64',b''.join(b[i:i+8][::-1] for i in range(0,len(b),8))

def components(s):
 raw=bytes.fromhex(s['key_material_64hex']);n=bytes.fromhex(s['nonce_24hex']);derived=derive_domain_key(raw)
 blobs={'raw':raw,'derived':derived,'hmac_raw_nonce':hmac.new(raw,n,hashlib.sha256).digest(),'hmac_derived_nonce':hmac.new(derived,n,hashlib.sha256).digest()}
 for base_name,key in [('raw',raw),('derived',derived)]:
  for counter in range(4):blobs[f'chacha_{base_name}_c{counter}']=chacha20_block(key,counter,n)
 out={}
 for bn,blob in blobs.items():
  for off in range(0,len(blob)-15,4):
   for name,value in transforms(f'{bn}[{off}:{off+16}]',blob[off:off+16]):out.setdefault(value,name)
 return out

def pad16(x):return x+b'\0'*((-len(x))%16)
def messages(s):
 _,base=candidates_for(s);out=dict(base)
 c=bytes.fromhex(s['ciphertext_hex']);pt=s['plaintext'].encode();n=bytes.fromhex(s['nonce_24hex']);kid=bytes.fromhex(s['kid'])
 for an,a in [('empty',b''),('domain',DOMAIN_LABEL),('kid',kid),('kidhex',s['kid'].encode()),('domainkid',DOMAIN_LABEL+kid)]:
  for pn,p in [('ct',c),('pt',pt)]:
   out[f'rfc:{an}:{pn}']=pad16(a)+pad16(p)+struct.pack('<QQ',len(a),len(p))
 # Exact observed serialization orders, excluding or blanking tag.
 vals={'ciphertext':s['ciphertext_hex'],'kid':s['kid'],'nonce':s['nonce_24hex'],'sv':3}
 for order in [('ciphertext','kid','nonce','sv'),('sv','kid','nonce','ciphertext')]:
  obj={k:vals[k] for k in order};out[f'json:{order}']=json.dumps(obj,separators=(',',':')).encode()
  obj['tag']='';out[f'json-empty-tag:{order}']=json.dumps(obj,separators=(',',':')).encode()
 return out

def poly_acc(msg,r):
 a=0
 for i in range(0,len(msg),16):
  b=msg[i:i+16];a=((a+int.from_bytes(b+b'\x01','little'))*r)%P
 return a

def main():
 s=SAMPLES[0];tag=int.from_bytes(bytes.fromhex(s['tag_32hex']),'little');comps=components(s);msgs=messages(s)
 rvals={int.from_bytes(v,'little')&CLAMP:n for v,n in comps.items()};svals={int.from_bytes(v,'little')&MASK:n for v,n in comps.items()}
 print('messages',len(msgs),'components',len(comps),'unique_r',len(rvals),flush=True)
 hits=[];tests=0
 for mi,(mn,msg) in enumerate(msgs.items()):
  for r,rn in rvals.items():
   need=(tag-poly_acc(msg,r))&MASK;tests+=1
   sn=svals.get(need)
   if sn:
    hit=(rn,sn,mn);hits.append(hit);print('FIRST HIT',hit,flush=True)
  if mi and mi%500==0:print('progress',mi,'hits',len(hits),flush=True)
 print('tests',tests,'hits',len(hits),flush=True)
 # Verify exact source descriptors by rebuilding name->bytes per sample.
 verified=[]
 for rn,sn,mn in hits:
  ok=True
  for sample in SAMPLES:
   inv={name:value for value,name in components(sample).items()};msg=messages(sample)[mn]
   r=int.from_bytes(inv[rn],'little')&CLAMP;ss=int.from_bytes(inv[sn],'little');got=(poly_acc(msg,r)+ss)&MASK
   if got.to_bytes(16,'little')!=bytes.fromhex(sample['tag_32hex']):ok=False;break
  if ok:verified.append((rn,sn,mn));print('VERIFIED',verified[-1],flush=True)
 out={'schema':'maxhook.poly1305-component-search/v1','tests':tests,'first_sample_hits':hits,'verified_all_samples':verified}
 (HERE/'poly1305_component_search_report.json').write_text(json.dumps(out,indent=2)+'\n','utf-8')
 print('verified',verified,flush=True)
if __name__=='__main__':main()
