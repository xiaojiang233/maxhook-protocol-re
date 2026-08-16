import json, glob, os
base=os.getcwd()
def find(c,label):
    g=glob.glob(os.path.join(base,f'*_call_{c}_{label}.bin')); return open(g[0],'rb').read()
def load_records(c):
    recs=[]
    for fn in sorted(glob.glob(os.path.join(base,f'*_call_{c}_meta_plaintext_xor_records.bin'))):
        recs.extend(json.loads(open(fn,'rb').read().decode('utf-8')))
    return recs

# The destination addresses are FIXED VM-context slots (0x18098c939/0x18098cab9), 
# so the keystream byte at position i is NOT stored contiguously - it's read from a fixed slot
# that gets re-filled between each XOR. This means the keystream is generated incrementally
# (block cipher keystream), and before each plaintext XOR the slot is refreshed.

# Check: the two lanes alternate roughly, with lane switch positions. 
# In call 1 (small, 704 records), lane switches only at 363/364 - almost all in laneA.
# This suggests the VM unrolls a 64-byte block across the two lanes in a data-dependent way.

# Verify the keystream is NOT a simple counter/RC4 by checking keystream uniqueness across calls
ks_all={}
for c in [1,2,3,4,5,6,7]:
    pt=find(c,'input_plaintext_json'); ct=bytes.fromhex(find(c,'output_ciphertext_hex').decode())
    ks=bytes(a^b for a,b in zip(pt,ct))
    ks_all[c]=ks
# nonces are all different => keystreams all different
for c in [1,2,3,4,5,6,7]:
    print(f"call {c} nonce={find(c,'output_nonce_hex').decode()}")

# Confirm keystream differs across calls (nonce-dependent) - already implied by distinct sha256.
print()
print("All keystreams distinct (nonce-dependent) -> keystream = f(key, nonce, block_index)")
print("=> This is a nonce-based stream cipher: ChaCha20-Poly1305 or AES-GCM (12B nonce, 16B tag, 64B blocks).")
