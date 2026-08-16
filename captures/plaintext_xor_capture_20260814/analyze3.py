import json, glob, os, collections
base=os.getcwd()
def load_records(c):
    recs=[]
    for fn in sorted(glob.glob(os.path.join(base,f'*_call_{c}_meta_plaintext_xor_records.bin'))):
        recs.extend(json.loads(open(fn,'rb').read().decode('utf-8')))
    return recs

for c in [1,2,3,4,5,6,7]:
    r=load_records(c)
    print(f"\n===== call {c} ({len(r)} records) =====")
    # Show before/after at each destination transition
    for i in range(min(4,len(r))):
        x=r[i]
        print(f"seq{i}: dest={x['destination']} source_byte={x['source_byte']} before={x['before']} after={x['after']}")
    # find where destination changes
    d0=r[0]['destination']
    for i,x in enumerate(r):
        if x['destination']!=d0:
            print(f"  [destination switches at seq {i}: {d0} -> {x['destination']}]")
            for j in range(max(0,i-2), min(len(r), i+3)):
                y=r[j]
                print(f"    seq{j}: dest={y['destination']} src={y['source_byte']} before={y['before']} after={y['after']}")
            break
    # Does after[i] feed into before[i+1] within same destination? (rolling accumulator)
    same = [x for x in r if x['destination']==d0]
    chain_ok = sum(1 for i in range(len(same)-1) if same[i]['after']==same[i+1]['before'])
    print(f"  dest0 rolling chain (after[i]==before[i+1]): {chain_ok}/{len(same)-1}")
