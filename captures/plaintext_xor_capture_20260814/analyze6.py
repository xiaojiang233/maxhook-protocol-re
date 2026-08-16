import json, glob, os
base=os.getcwd()
def find(c,label):
    g=glob.glob(os.path.join(base,f'*_call_{c}_{label}.bin')); return open(g[0],'rb').read()

# ciphertext_hex length == 2 * plaintext length (hex encoding, exact)
for c in [1,2,3,4,5,6,7]:
    pt=find(c,'input_plaintext_json')
    ct=bytes.fromhex(find(c,'output_ciphertext_hex').decode())
    nonce=bytes.fromhex(find(c,'output_nonce_hex').decode())
    tag=bytes.fromhex(find(c,'output_tag_hex').decode())
    print(f"call {c}: pt={len(pt)} ct={len(ct)} ct==2*pt? {len(ct)==len(pt)} nonce={len(nonce)}B tag={len(tag)}B")

# So ciphertext is SAME length as plaintext (not +16 tag). This is a STREAM cipher (no padding).
# tag is separate 16-byte auth tag. nonce is 12 bytes. => looks like ChaCha20-Poly1305 or AES-GCM style
# but implemented in a custom VM. Actually nonce=12 + tag=16 + stream => ChaCha20-Poly1305 (or AES-GCM).

# The floor(64) strongly suggests 64-byte keystream blocks (ChaCha20 uses 64-byte blocks!).
print()
print("nonce=12, tag=16, stream cipher, 64-byte blocks => ChaCha20-Poly1305-like (or AES-GCM).")
print("ChaCha20 processes 64-byte blocks; partial last block handled via same XOR but the VM likely")
print("uses a different code path / tail loop for the <64 remainder, which this single XOR site does not capture.")
