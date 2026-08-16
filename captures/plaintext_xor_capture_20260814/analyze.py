import json, glob, os, collections

base = os.getcwd()

def readbin(name):
    with open(os.path.join(base, name), 'rb') as f:
        return f.read()

def find(call, label):
    pat = os.path.join(base, f'*_call_{call}_{label}.bin')
    g = glob.glob(pat)
    assert len(g)==1, (call, label, g)
    return readbin(os.path.basename(g[0]))

def load_records(call):
    recs = []
    for fn in sorted(glob.glob(os.path.join(base, f'*_call_{call}_meta_plaintext_xor_records.bin'))):
        with open(fn, 'rb') as f:
            recs.extend(json.loads(f.read().decode('utf-8')))
    return recs

calls = {}
for c in [1,2,3,4,5,6,7]:
    calls[c] = dict(
        plaintext=find(c, 'input_plaintext_json'),
        nonce=find(c, 'output_nonce_hex'),
        ciphertext_hex=find(c, 'output_ciphertext_hex'),
        tag=find(c, 'output_tag_hex'),
        records=load_records(c),
    )

print("=== record count vs plaintext length ===")
for c in [1,2,3,4,5,6,7]:
    pt = calls[c]['plaintext']; r = calls[c]['records']
    floor = (len(pt)//64)*64
    print(f"call {c}: pt_len={len(pt)} floor64={floor} records={len(r)} match={floor==len(r)}")

print()
print("=== xor_byte vs source_byte ===")
for c in [1,2,3,4,5,6,7]:
    r = calls[c]['records']
    eq = sum(1 for x in r if x.get('xor_byte')==x.get('source_byte'))
    print(f"call {c}: records={len(r)} xor==source={eq}")

print()
print("=== source pointer sequence ===")
for c in [1,2,3,4,5,6,7]:
    r = calls[c]['records']
    srcs = [int(x['source'],16) for x in r]
    diffs = collections.Counter(srcs[i+1]-srcs[i] for i in range(len(srcs)-1))
    print(f"call {c}: first={hex(srcs[0])} last={hex(srcs[-1])} span={srcs[-1]-srcs[0]+1} diffs={dict(diffs)}")

print()
print("=== destination pointer sequence ===")
for c in [1,2,3,4,5,6,7]:
    r = calls[c]['records']
    dsts = [x['destination'] for x in r]
    uniq = collections.Counter(dsts)
    print(f"call {c}: unique_dest={len(uniq)} top={uniq.most_common(4)}")

print()
print("=== pointer_slot / pointer_value ===")
for c in [1,2,3,4,5,6,7]:
    r = calls[c]['records']
    slots = collections.Counter(x['pointer_slot'] for x in r)
    pvs = collections.Counter(x['pointer_value'] for x in r)
    print(f"call {c}: slot uniq={len(slots)}={dict(slots)}  ptr_value uniq={len(pvs)}")
