import json
from pathlib import Path

# writer_sync: 3 calls, same key, 3 nonces, 3 keystreams
a = json.loads(Path(r"E:\Coding\S1mple\target\writer_sync_clean_20260814_014351\analysis.json").read_text(encoding="utf-8"))
ks = [bytes.fromhex(c["keystream_hex"]) for c in a["calls"]]
nonces = [
    bytes.fromhex("96e71401fc4f5faa040e5ca1"),
    bytes.fromhex("3fa29634397f82181677262f"),
    bytes.fromhex("8260e5b4587f7b01e697ddf2"),
]

print("writer_sync: 3 keystreams, same key, 3 nonces")
for i in range(3):
    print("  call %d: nonce=%s ks[0:8]=%s len=%d" % (i+1, nonces[i].hex(), ks[i][:8].hex(), len(ks[i])))

# Test: is ks2 = ks1 shifted (counter mode, nonce-independent)?
# If keystream is nonce-independent, ks2 might be ks1 offset by some amount
print("\nCheck if keystreams are related (nonce-independent + counter):")
for shift in range(0, 64):
    if ks[0][shift:shift+8] == ks[1][:8]:
        print("  ks1[%d:%d] == ks2[0:8] (shift %d)" % (shift, shift+8, shift))

# More robust: check if any 8-byte window of ks1 matches ks2 start
for shift in range(0, len(ks[0])-8):
    if ks[0][shift:shift+8] == ks[1][:8]:
        print("  MATCH ks1[%d:] == ks2[0:8]" % shift)
    if ks[0][shift:shift+8] == ks[2][:8]:
        print("  MATCH ks1[%d:] == ks3[0:8]" % shift)

# vm_context2: 10 calls, same key, 10 nonces, 10 keystreams
P = Path(r"E:\Coding\S1mple\target\vm_context_capture2")
KEY = bytes.fromhex("32206F9C196327AD276821AC8EBC7F80FE82D84CF72A4F7C1BAF508C97D3AEA8")
print("\nvm_context2: 10 keystreams, same key, 10 nonces")
ks2_list = []
for cid in range(1, 11):
    ct = bytes.fromhex(list(P.glob("*call_%d*ciphertext*" % cid))[0].read_bytes().decode())
    pt = list(P.glob("*call_%d*plaintext*" % cid))[0].read_bytes()
    ks = bytes(a ^ b for a, b in zip(pt, ct))
    ks2_list.append(ks)
    print("  call %d: ks[0:8]=%s" % (cid, ks[:8].hex()))

# check if any vm_context2 keystream is a shift of another (nonce-independent)
print("\nCheck vm_context2 keystreams for counter-shift relationship:")
for i in range(10):
    for j in range(10):
        if i != j and ks2_list[i][:8] == ks2_list[j][:8]:
            print("  SAME prefix call %d == call %d" % (i+1, j+1))
# check if any 8-byte window matches
matched = 0
for i in range(10):
    for j in range(10):
        if i == j: continue
        for shift in range(len(ks2_list[i])-8):
            if ks2_list[i][shift:shift+8] == ks2_list[j][:8]:
                matched += 1
                break
print("  total shift-matches:", matched)
