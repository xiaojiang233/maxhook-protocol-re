import json, glob, os, collections
base=os.getcwd()
def load_records(c):
    recs=[]
    for fn in sorted(glob.glob(os.path.join(base,f'*_call_{c}_meta_plaintext_xor_records.bin'))):
        recs.extend(json.loads(open(fn,'rb').read().decode('utf-8')))
    return recs

# Understand destination alternation: how the two accumulators interleave with the source
for c in [1,2,3,4,5,6,7]:
    r=load_records(c)
    # map seq -> dest, and check the "before" of first record vs keystream[0]
    # The key question: are the two destinations 64 bytes apart? 0x18098cab9 - 0x18098c939 = 0x180 = 384
    d0='0x18098c939'; d1='0x18098cab9'
    # positions where dest switches
    switches=[i for i in range(1,len(r)) if r[i]['destination']!=r[i-1]['destination']]
    print(f"\ncall {c}: n={len(r)} switches={switches}")

# Check the source pointer: is it the plaintext data pointer or a copy? Compare to event data_pointer
# events show plaintext data_pointer e.g. call1 = 0x1398efac450, but source=0x13989dbac80 -> different => copied buffer
print()
print("Note: source pointer 0x139... differs from plaintext data_pointer in events => copied plaintext buffer")

# Check the two source pointer slots (r12 slot) mapping to the two destinations:
# pointer_slot 0x18098c8c9 -> dest 0x18098c939 (offset +0x70), pointer_slot 0x18098ca49 -> dest 0x18098cab9 (offset +0x70)
r=load_records(1)
for x in r[:8]:
    print(x['pointer_slot'], '->', x['destination'])
