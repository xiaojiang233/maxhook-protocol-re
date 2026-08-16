import json, glob, os, collections
base=os.getcwd()
def load_records(c):
    recs=[]
    for fn in sorted(glob.glob(os.path.join(base,f'*_call_{c}_meta_plaintext_xor_records.bin'))):
        recs.extend(json.loads(open(fn,'rb').read().decode('utf-8')))
    return recs

# Verify: for each record, is 'verified' == (before ^ xor_byte == after)?
# Also: the 'before' at dest0 is keystream, 'after' is ciphertext. Since xor_byte==plaintext,
# before == keystream == plaintext ^ ciphertext, so before ^ xor_byte == ciphertext == after. Always holds.

# KEY question: are the two lanes two INDEPENDENT keystream accumulators?
# Check: does before[i] at lane A relate to before[i-1] at lane A? (already checked: NO rolling chain)
# Instead check: is before[seq] == keystream[seq]? (already verified True by analyzer)

# Understand WHY records stop at floor(64): the tail bytes (remainder after last full 64-block)
# are processed elsewhere. Let's check the tail ciphertext is still produced (it is - ciphertext_hex = 2*pt).
# So the tail IS encrypted, just not via THIS xor site. => there's a second, tail-handling path.

# Let me examine the relationship: source_byte XOR before = after (ciphertext), and the keystream
# is generated SOMEWHERE before this site. The 'before' value = keystream. 
# Where does keystream come from? It must be written into the VM context slots 0x18098c939/0x18098cab9
# by a keystream-generation primitive BEFORE the XOR, OR the XOR is the keystream update.

# Check if the two lanes carry interleaved keystream: laneA holds even-index keystream, laneB odd?
r=load_records(2)  # call 2 has many switches
# Reconstruct: for seq 0..n-1, what is dest, and is before == keystream[seq]?
import hashlib
def find(c,label):
    g=glob.glob(os.path.join(base,f'*_call_{c}_{label}.bin')); return open(g[0],'rb').read()
pt=find(2,'input_plaintext_json'); ct=bytes.fromhex(find(2,'output_ciphertext_hex').decode())
ks=bytes(a^b for a,b in zip(pt,ct))
laneA=[]; laneB=[]
for i,x in enumerate(r):
    if x['destination']=='0x18098c939': laneA.append((i,x['before']))
    else: laneB.append((i,x['before']))
print("call2 laneA count", len(laneA), "laneB count", len(laneB))
print("laneA first seqs:", [s for s,_ in laneA[:10]])
print("laneB first seqs:", [s for s,_ in laneB[:10]])
print("laneA before == ks[seq] check:", all(b==ks[s] for s,b in laneA))
print("laneB before == ks[seq] check:", all(b==ks[s] for s,b in laneB))
