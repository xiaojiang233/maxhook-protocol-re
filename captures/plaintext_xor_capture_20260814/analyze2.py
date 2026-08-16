import json, glob, os, collections

base = os.getcwd()
def readbin(n):
    with open(os.path.join(base,n),'rb') as f: return f.read()
def find(c,label):
    g=glob.glob(os.path.join(base,f'*_call_{c}_{label}.bin')); return readbin(os.path.basename(g[0]))
def load_records(c):
    recs=[]
    for fn in sorted(glob.glob(os.path.join(base,f'*_call_{c}_meta_plaintext_xor_records.bin'))):
        recs.extend(json.loads(open(fn,'rb').read().decode('utf-8')))
    return recs

# Compare source_byte sequence to actual plaintext bytes
for c in [1,2,3,4,5,6,7]:
    pt = find(c,'input_plaintext_json')
    r = load_records(c)
    srcb = [x['source_byte'] for x in r]
    # compare to plaintext prefix
    match = sum(1 for i in range(len(r)) if srcb[i] == pt[i])
    print(f"call {c}: source_byte==plaintext[i] for {match}/{len(r)} records")

# Now check: does source_byte equal a TRANSFORMED plaintext? Check first 8 bytes
print()
r = load_records(1)
pt = find(1,'input_plaintext_json')
print("call1 first 8 plaintext bytes:", list(pt[:8]))
print("call1 first 8 source_bytes:", [x['source_byte'] for x in r[:8]])
