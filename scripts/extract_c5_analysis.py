#!/usr/bin/env python3
"""Extract VM context slots at offsets 0xc5 / 0x61 / neighbors from
keystream_history_capture_20260814 context_hex snapshots, to determine the
real runtime value of the pointer chain at 0x180bf1eb2 / 0x180a831db."""
import json, glob, os, collections

D = r'E:\Coding\S1mple\target\keystream_history_capture_20260814'
files = sorted(glob.glob(os.path.join(D, '*.bin')))

def qword(ctx, off):
    b = bytes.fromhex(ctx)
    return int.from_bytes(b[off:off+8], 'little')

def dword(ctx, off):
    b = bytes.fromhex(ctx)
    return int.from_bytes(b[off:off+4], 'little')

print('=' * 90)
print('VM context base = 0x18098c884  (module_base 0x180000000 + rva 0x98c884)')
print('context+0xc5 = 0x18098c949 ; context+0x61 = 0x18098c8e5')
print('=' * 90)

# Offsets to inspect: 0x61 (milestone28 slot), 0xc5 (milestone28 slot),
# plus a window to understand the slot layout.
OFFS = [0x61, 0xc1, 0xc5, 0xc9, 0xcd, 0xd1, 0xd5]

seen = collections.defaultdict(collections.Counter)
rows = []
for f in files:
    s = json.loads(open(f, 'rb').read().decode('utf-8', 'replace'))
    ch = s['context_hex']
    rec = dict(file=os.path.basename(f), xor_index=s['xor_index'],
               dest=s.get('destination'), ks_byte=s.get('keystream_byte'))
    for off in OFFS:
        q = qword(ch, off)
        rec[f'q_{off:x}'] = q
        seen[off][q] += 1
    rows.append(rec)

print('\n--- per-offset unique 8-byte values (little-endian) ---')
for off in OFFS:
    print(f'  offset +0x{off:x} ({off:3d}): { {hex(k):v for k,v in seen[off].items()} }')

print('\n--- all rows (first 60) ---')
for r in rows:
    line = f"{r['file']:45s} xor={r['xor_index']:5d} "
    for off in OFFS:
        line += f" +{off:x}={r[f'q_{off:x}']:#x}"
    print(line)

# Now print the raw 8 bytes at 0xc5 and 0x61 for a few, to see byte layout
print('\n--- raw bytes (hex) at 0xc5 and 0x61 for first 6 snapshots ---')
for f in files[:6]:
    s = json.loads(open(f, 'rb').read().decode('utf-8', 'replace'))
    b = bytes.fromhex(s['context_hex'])
    print(f"{os.path.basename(f)}: c5={b[0xc5:0xc5+8].hex()}  c61={b[0x61:0x61+8].hex()}  c1={b[0xc1:0xc1+4].hex()}  c9={b[0xc9:0xc9+4].hex()}")

# Also check what a dword (4-byte) read at 0xc5 looks like (handler uses movzx word / dword)
print('\n--- dword reads at 0xc5 and word at 0xc5 (handler pattern) ---')
for f in files[:6]:
    s = json.loads(open(f, 'rb').read().decode('utf-8', 'replace'))
    b = bytes.fromhex(s['context_hex'])
    print(f"{os.path.basename(f)}: dword@c5={int.from_bytes(b[0xc5:0xc5+4],'little'):#x}  word@c5={int.from_bytes(b[0xc5:0xc5+2],'little'):#x}  byte@c5={b[0xc5]:#x}")
