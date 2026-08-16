#!/usr/bin/env python3
import json, struct, glob, os

files = sorted(glob.glob(r"E:\Coding\S1mple\target\block_generator_manual_20260814_012601\*.bin"))

print("Stores analysis: destination, offset(relative to output), value (u32 LE)")
print("="*100)
for f in files:
    j = json.loads(open(f).read())[0]
    out_ptr = int(j['output'], 16)
    print(f"\n--- {os.path.basename(f)}  output={j['output']} input={j['input']} ---")
    for s in j['stores']:
        dest = int(s['destination'], 16)
        off = s['offset']
        val = int(s['value'], 16)
        # reconstruct bytes as LE
        vbytes = struct.pack('<I', val)
        print(f"  dest={s['destination']}  offset={off:+d}  value={val:#010x}  LE_bytes={vbytes.hex()}")

# Now examine the constant output in full
print()
print("="*100)
print("CONSTANT output_hex (all calls identical) — 72 bytes")
print("="*100)
j = json.loads(open(files[0]).read())[0]
oa = bytes.fromhex(j['output_hex'])
print("raw:", oa.hex())
print("len:", len(oa))
print("u32 words:", [hex(struct.unpack('<I', oa[i:i+4])[0]) for i in range(0, len(oa), 4)])
print("u64 words:", [hex(struct.unpack('<Q', oa[i:i+8])[0]) for i in range(0, len(oa), 8)])
