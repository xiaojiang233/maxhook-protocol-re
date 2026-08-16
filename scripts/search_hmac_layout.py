#!/usr/bin/env python3
"""Broad offline search for the HMAC-SHA256 tag message layout."""
from __future__ import annotations
import hashlib,hmac,itertools,json,struct
from pathlib import Path

HERE=Path(__file__).resolve().parent
SAMPLES=json.loads((HERE/'crypto_verify_set.json').read_text('utf-8'))['samples']
AAD=b'v3|hpac.v3.session.report.req'

def parts(s):
 k=bytes.fromhex(s['key_material_64hex']);kid=bytes.fromhex(s['kid']);n=bytes.fromhex(s['nonce_24hex']);c=bytes.fromhex(s['ciphertext_hex']);pt=s['plaintext'].encode()
 return k,{
  'aad':AAD,'kid':kid,'kidhexU':s['kid'].encode(),'kidhexL':s['kid'].lower().encode(),
  'nonce':n,'noncehexL':s['nonce_24hex'].encode(),'noncehexU':s['nonce_24hex'].upper().encode(),
  'ct':c,'cthexL':s['ciphertext_hex'].encode(),'cthexU':s['ciphertext_hex'].upper().encode(),
  'pt':pt,'sv1':b'3','svb':b'\x03','sv32le':struct.pack('<I',3),'sv32be':struct.pack('>I',3),
 }

def digest_forms(d):
 def swap4(x):return b''.join(x[i:i+4][::-1] for i in range(0,len(x),4))
 return {'first16':d[:16],'last16':d[16:],'reverse_first16':d[::-1][:16],
         'word_swap_first16':swap4(d)[:16],'xor_halves':bytes(a^b for a,b in zip(d[:16],d[16:]))}

def encode_sequence(vals,sep,mode):
 if mode=='plain':return sep.join(vals)
 if mode=='len32le':return sep.join(struct.pack('<I',len(v))+v for v in vals)
 if mode=='len32be':return sep.join(struct.pack('>I',len(v))+v for v in vals)
 if mode=='len64le':return sep.join(struct.pack('<Q',len(v))+v for v in vals)
 if mode=='len64be':return sep.join(struct.pack('>Q',len(v))+v for v in vals)
 raise ValueError(mode)

def candidates_for(s):
 key,p=parts(s)
 seqs=set()
 # Plausible protocol orders plus all permutations of the four envelope fields.
 bases=[('aad','nonce','ct'),('nonce','ct'),('aad','ct'),('kid','nonce','ct'),
        ('aad','kid','nonce','ct'),('svb','kid','nonce','ct'),('sv1','kidhexU','noncehexL','cthexL'),
        ('aad','pt'),('nonce','pt'),('aad','nonce','pt'),('pt',),('ct',),('pt','ct'),('ct','pt')]
 reps={
  'kid':['kid','kidhexU','kidhexL'], 'nonce':['nonce','noncehexL','noncehexU'],
  'ct':['ct','cthexL','cthexU'], 'sv':['sv1','svb','sv32le','sv32be']}
 expanded=[]
 for base in bases:
  choices=[]
  for x in base: choices.append(reps.get(x,[x]))
  expanded.extend(itertools.product(*choices))
 for perm in itertools.permutations(('sv1','kidhexU','noncehexL','cthexL')):expanded.append(perm)
 for names in expanded:
  vals=[p[x] for x in names]
  for sep in (b'',b'|',b':',b'\0',b'\n',b','):
   for mode in ('plain','len32le','len32be','len64le','len64be'):
    msg=encode_sequence(vals,sep,mode);seqs.add((f"{names}|sep={sep!r}|{mode}",msg))
 # JSON envelope-without-tag variants.
 fields={'sv':3,'kid':s['kid'],'nonce':s['nonce_24hex'],'ciphertext':s['ciphertext_hex']}
 for order in itertools.permutations(fields):
  obj={k:fields[k] for k in order}
  for compact in (True,False):
   raw=json.dumps(obj,separators=(',',':') if compact else None,ensure_ascii=False).encode()
   seqs.add((f'json:{order}:compact={compact}',raw));seqs.add((f'aad+json:{order}:compact={compact}',AAD+raw));seqs.add((f'aad|json:{order}:compact={compact}',AAD+b'|'+raw))
 return key,seqs

def key_modes(raw_key):
 return {
  'raw':raw_key,
  'hmac_key_aad':hmac.new(raw_key,AAD,hashlib.sha256).digest(),
  'sha256_key_aad':hashlib.sha256(raw_key+AAD).digest(),
 }

def main():
 raw0,c0=candidates_for(SAMPLES[0]);wanted=bytes.fromhex(SAMPLES[0]['tag_32hex']);hits=[]
 for key_name,key0 in key_modes(raw0).items():
  for name,msg in c0:
   d=hmac.new(key0,msg,hashlib.sha256).digest()
   for form,value in digest_forms(d).items():
    if value==wanted:hits.append((key_name,name,form,msg))
 print('first-sample candidates',len(c0)*len(key_modes(raw0)),'hits',len(hits))
 verified=[]
 for key_name,name,form,_ in hits:
  ok=True
  for sample in SAMPLES:
   raw,cands=candidates_for(sample);table=dict(cands);msg=table.get(name)
   key=key_modes(raw)[key_name]
   if msg is None or digest_forms(hmac.new(key,msg,hashlib.sha256).digest())[form]!=bytes.fromhex(sample['tag_32hex']):ok=False;break
  if ok:verified.append((key_name,name,form))
 print('verified',verified)
 out={'schema':'maxhook.hmac-layout-search/v2','candidate_count_first_sample':len(c0)*len(key_modes(raw0)),'first_sample_hits':[(k,n,f) for k,n,f,_ in hits],'verified_all_samples':verified}
 (HERE/'hmac_layout_search_report.json').write_text(json.dumps(out,indent=2)+'\n')
if __name__=='__main__':main()
