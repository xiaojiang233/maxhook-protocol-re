#!/usr/bin/env python3
"""Search Carter-Wegman-like digest combined with a ChaCha/key-derived pad."""
from __future__ import annotations
import hashlib,hmac,json
from pathlib import Path
from search_hmac_layout import candidates_for,digest_forms
from search_poly1305_layout import key_modes
from search_poly1305_components import components
HERE=Path(__file__).resolve().parent
SAMPLES=json.loads((HERE/'crypto_verify_set.json').read_text('utf-8'))['samples']
MASK=(1<<128)-1

def pad_maps(s):
 c=components(s)
 direct={v:n for v,n in c.items()}
 ints_le={int.from_bytes(v,'little'):n for v,n in c.items()}
 ints_be={int.from_bytes(v,'big'):n for v,n in c.items()}
 return direct,ints_le,ints_be

def combinations(target,digest,direct,le,be):
 need=bytes(a^b for a,b in zip(target,digest));n=direct.get(need)
 if n:yield 'xor',n
 ti=int.from_bytes(target,'little');di=int.from_bytes(digest,'little')
 for op,val in [('add-le',(ti-di)&MASK),('sub-le',(di-ti)&MASK)]:
  n=le.get(val)
  if n:yield op,n
 ti=int.from_bytes(target,'big');di=int.from_bytes(digest,'big')
 for op,val in [('add-be',(ti-di)&MASK),('sub-be',(di-ti)&MASK)]:
  n=be.get(val)
  if n:yield op,n

def main():
 s=SAMPLES[0];_,msgs=candidates_for(s);msgs=list(msgs);keys=key_modes(s);target=bytes.fromhex(s['tag_32hex']);direct,le,be=pad_maps(s);hits=[];tests=0
 print('messages',len(msgs),'keys',len(keys),'pads',len(direct),flush=True)
 for kn,k in keys.items():
  for mn,m in msgs:
   digests={
    'hmac-sha256':hmac.new(k,m,hashlib.sha256).digest(),
    'sha256-key-prefix':hashlib.sha256(k+m).digest(),
    'sha256-key-suffix':hashlib.sha256(m+k).digest(),
    'hmac-sha512':hmac.new(k,m,hashlib.sha512).digest(),
    'blake2s-keyed':hashlib.blake2s(m,key=k[:32]).digest(),
   }
   for dn,d in digests.items():
    for fn,v in digest_forms(d).items():
     tests+=1
     for op,pn in combinations(target,v,direct,le,be):
      hit=(kn,mn,dn,fn,op,pn);hits.append(hit);print('FIRST HIT',hit,flush=True)
 print('tests',tests,'hits',len(hits),flush=True)
 verified=[]
 for hit in hits:
  # Candidate count should be tiny; a full verifier is added only on a hit.
  pass
 out={'schema':'maxhook.tag-digest-pad-search/v1','tests':tests,'first_sample_hits':hits,'verified_all_samples':verified}
 (HERE/'tag_digest_pad_search_report.json').write_text(json.dumps(out,indent=2)+'\n','utf-8')
if __name__=='__main__':main()
