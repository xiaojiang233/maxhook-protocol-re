#!/usr/bin/env python3
"""Search plausible separate authentication-key KDF labels offline."""
from __future__ import annotations
import hashlib,hmac,itertools,json,struct
from pathlib import Path
from cryptography.hazmat.primitives.poly1305 import Poly1305
from cryptography.hazmat.primitives.cmac import CMAC
from cryptography.hazmat.primitives.ciphers import algorithms
from maxhook_protocol_reference import DOMAIN_LABEL,chacha20_block,derive_domain_key
from search_hmac_layout import digest_forms
HERE=Path(__file__).resolve().parent
SAMPLES=json.loads((HERE/'crypto_verify_set.json').read_text('utf-8'))['samples']

def pad16(x):return x+b'\0'*((-len(x))%16)
def labels():
 base=[DOMAIN_LABEL,DOMAIN_LABEL[3:],b'hpac.v3.session.report.req',b'v3',b'hpac',b'hpac.v3.session.report']
 words=[b'mac',b'tag',b'auth',b'poly1305',b'poly',b'aead',b'key',b'key.mac',b'mac.key',b'req.mac',b'req.tag',b'req.auth',b'enc',b'encrypt']
 out=set(base+words)
 for b,w,sep in itertools.product(base,words,[b'',b'|',b':',b'.',b'/',b'\0',b'-',b'_']):
  out.add(b+sep+w);out.add(w+sep+b)
 for b in base:
  for x in range(4):out.add(b+bytes([x]));out.add(bytes([x])+b);out.add(b+struct.pack('<I',x));out.add(struct.pack('<I',x)+b)
 return sorted(out)
def key_candidates(s):
 raw=bytes.fromhex(s['key_material_64hex']);d=derive_domain_key(raw);n=bytes.fromhex(s['nonce_24hex']);out={}
 for ln,l in enumerate(labels()):
  for bn,b in [('raw',raw),('derived',d)]:
   vals={
    f'hmac({bn},label)':hmac.new(b,l,hashlib.sha256).digest(),
    f'hmac({bn},label+nonce)':hmac.new(b,l+n,hashlib.sha256).digest(),
    f'hmac({bn},nonce+label)':hmac.new(b,n+l,hashlib.sha256).digest(),
    f'sha({bn}+label)':hashlib.sha256(b+l).digest(),
    f'sha(label+{bn})':hashlib.sha256(l+b).digest(),
   }
   for form,v in vals.items():out[f'{form}|label={l!r}']=v
 # Counter/tree derivations not requiring a label.
 for name,v in [('hmac(raw,derived)',hmac.new(raw,d,hashlib.sha256).digest()),('hmac(derived,raw)',hmac.new(d,raw,hashlib.sha256).digest()),('sha(raw+derived)',hashlib.sha256(raw+d).digest()),('sha(derived+raw)',hashlib.sha256(d+raw).digest())]:out[name]=v
 return out
def messages(s):
 n=bytes.fromhex(s['nonce_24hex']);c=bytes.fromhex(s['ciphertext_hex']);pt=s['plaintext'].encode();kid=bytes.fromhex(s['kid']);parts={'n':n,'c':c,'p':pt,'d':DOMAIN_LABEL,'k':kid,'kh':s['kid'].encode(),'v':b'3','vb':b'\x03'};out={}
 specs=[('c',),('p',),('n','c'),('n','p'),('d','n','c'),('d','n','p'),('k','n','c'),('kh','n','c'),('v','kh','n','c'),('d','k','n','c'),('n','d','c'),('c','n'),('p','n')]
 for spec in specs:
  vals=[parts[x] for x in spec]
  for sep in [b'',b'|',b':',b'\0',b',']:
   out[f'{spec}|{sep!r}']=sep.join(vals)
 for an,a in [('empty',b''),('domain',DOMAIN_LABEL),('kid',kid),('kidhex',s['kid'].encode())]:
  for pn,p in [('ct',c),('pt',pt)]:out[f'rfc:{an}:{pn}']=pad16(a)+pad16(p)+struct.pack('<QQ',len(a),len(p))
 vals={'ciphertext':s['ciphertext_hex'],'kid':s['kid'],'nonce':s['nonce_24hex'],'sv':3};out['json']=json.dumps(vals,separators=(',',':')).encode()
 return out

def main():
 s=SAMPLES[0];ks=key_candidates(s);ms=messages(s);target=bytes.fromhex(s['tag_32hex']);hits=[];tests=0
 print('labels',len(labels()),'keys',len(ks),'messages',len(ms),flush=True)
 for kn,k in ks.items():
  polykeys=[('direct',k),('chacha0lo',chacha20_block(k,0,bytes.fromhex(s['nonce_24hex']))[:32]),('chacha0hi',chacha20_block(k,0,bytes.fromhex(s['nonce_24hex']))[32:])]
  for mn,m in ms.items():
   vals=[('hmac-sha256',hmac.new(k,m,hashlib.sha256).digest()),('blake2s',hashlib.blake2s(m,key=k,digest_size=16).digest())]
   cm=CMAC(algorithms.AES(k));cm.update(m);vals.append(('aes-cmac',cm.finalize()))
   for pn,pk in polykeys:vals.append((f'poly:{pn}',Poly1305.generate_tag(pk,m)))
   for alg,v in vals:
    for fn,fv in digest_forms(v).items():
     tests+=1
     if fv==target:
      hit=(kn,mn,alg,fn);hits.append(hit);print('FIRST HIT',hit,flush=True)
 print('tests',tests,'hits',len(hits),flush=True)
 out={'schema':'maxhook.tag-kdf-label-search/v1','labels':len(labels()),'keys':len(ks),'messages':len(ms),'tests':tests,'first_sample_hits':hits}
 (HERE/'tag_kdf_label_search_report.json').write_text(json.dumps(out,indent=2)+'\n','utf-8')
if __name__=='__main__':main()
