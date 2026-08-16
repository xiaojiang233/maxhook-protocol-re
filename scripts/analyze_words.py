#!/usr/bin/env python3
import json, struct, glob, os

files = sorted(glob.glob(r"E:\Coding\S1mple\target\block_generator_manual_20260814_012601\*.bin"))

def parse_words(hx):
    b = bytes.fromhex(hx)
    words = struct.unpack('<' + 'Q'*(len(b)//8), b)
    return b, words

print("="*100)
print("INPUT BUFFER (rcx) word analysis  [little-endian 64-bit words]")
print("="*100)
# Use call 1 input
inp_hex = "a00b71be8602000032e7b08101000000b89970be860200000000000000000000200000000000000069c998800100000000000000000000000004000000000000"
b, words = parse_words(inp_hex)
print(f"total bytes: {len(b)}")
for i, w in enumerate(words):
    print(f"  word[{i}] @+{i*8:#04x} = {w:#018x}")

print()
print("Input bytes per dword (little-endian u32):")
for i in range(0, len(b), 4):
    w = struct.unpack('<I', b[i:i+4])[0]
    print(f"  +{i:#04x}: {w:#010x}")

print()
print("="*100)
print("OUTPUT buffer (rdx) analysis")
print("="*100)
for f in files:
    j = json.loads(open(f).read())[0]
    ob = bytes.fromhex(j['output_before_hex'])
    oa = bytes.fromhex(j['output_hex'])
    # show first 32 bytes of before vs after
    print(f"\n--- {os.path.basename(f)} ---")
    print(f"  output_before[0:32] = {ob[:32].hex()}")
    print(f"  output_after [0:32] = {oa[:32].hex()}")
    print(f"  before == after? {ob == oa}")
    # which bytes changed?
    if len(ob)==len(oa):
        diff = [i for i in range(len(ob)) if ob[i]!=oa[i]]
        print(f"  changed byte indices: {diff}")
