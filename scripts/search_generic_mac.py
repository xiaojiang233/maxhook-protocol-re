#!/usr/bin/env python3
"""Search common 16-byte MAC/hash constructions against offline vectors."""
from __future__ import annotations
import hashlib, hmac, json
from pathlib import Path
from cryptography.hazmat.primitives.cmac import CMAC
from cryptography.hazmat.primitives.ciphers import algorithms
from search_hmac_layout import candidates_for
from search_poly1305_layout import key_modes

HERE=Path(__file__).resolve().parent
SAMPLES=json.loads((HERE/'crypto_verify_set.json').read_text('utf-8'))['samples']

HASHES=('md5','sha1','sha224','sha256','sha384','sha512','sha3_224','sha3_256','sha3_384','sha3_512','blake2s','blake2b')

def forms(d:bytes):
 def swap4(x): return b''.join(x[i:i+4][::-1] for i in range(0,len(x),4))
 out={'first16':d[:16],'last16':d[-16:],'reverse_first16':d[::-1][:16],'swap4_first16':swap4(d)[:16]}
 if len(d)>=32: out['xor_halves']=bytes(a^b for a,b in zip(d[:16],d[16:32]))
 return out

def computations(key:bytes,msg:bytes):
 for alg in HASHES:
  fn=getattr(hashlib,alg)
  for order,data in [('prefix',key+msg),('suffix',msg+key),('sandwich',key+msg+key)]:
   yield f'{alg}:{order}',fn(data).digest()
  yield f'hmac-{alg}',hmac.new(key,msg,fn).digest()
 yield 'blake2s-keyed-16',hashlib.blake2s(msg,key=key[:32],digest_size=16).digest()
 yield 'blake2b-keyed-16',hashlib.blake2b(msg,key=key[:64],digest_size=16).digest()
 if len(key) in (16,24,32):
  c=CMAC(algorithms.AES(key));c.update(msg);yield 'aes-cmac',c.finalize()

def main():
 first=SAMPLES[0];_,msgs0=candidates_for(first); msgs0=list(msgs0); keys0=key_modes(first); target=bytes.fromhex(first['tag_32hex']); hits=[]; tests=0
 print('messages',len(msgs0),'keys',len(keys0),flush=True)
 for kn,key in keys0.items():
  for mn,msg in msgs0:
   for cn,d in computations(key,msg):
    for fn,val in forms(d).items():
     tests+=1
     if val==target:
      hit=(kn,mn,cn,fn);hits.append(hit);print('FIRST HIT',hit,flush=True)
 print('tests',tests,'hits',len(hits),flush=True)
 verified=[]
 for hit in hits:
  kn,mn,cn,fn=hit;ok=True
  for s in SAMPLES:
   table=dict(candidates_for(s));key=key_modes(s)[kn]
   found=False
   for cn2,d in computations(key,table[mn]):
    if cn2==cn:
     found=forms(d)[fn]==bytes.fromhex(s['tag_32hex']);break
   if not found:ok=False;break
  if ok: verified.append(hit);print('VERIFIED',hit,flush=True)
 out={'schema':'maxhook.generic-mac-search/v1','tests':tests,'first_sample_hits':hits,'verified_all_samples':verified}
 (HERE/'generic_mac_search_report.json').write_text(json.dumps(out,indent=2)+'\n','utf-8')
 print('verified',verified,flush=True)
if __name__=='__main__':main()
