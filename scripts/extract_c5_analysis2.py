import json, glob, os
D = r'E:\Coding\S1mple\target\keystream_history_capture_20260814'
files = sorted(glob.glob(os.path.join(D, '*.bin')))
print('snapshots where b5 or c5 is a pointer (not small byte):')
for f in files:
    s = json.loads(open(f, 'rb').read().decode('utf-8', 'replace'))
    b = bytes.fromhex(s['context_hex'])
    b5 = int.from_bytes(b[0xb5:0xb5+8], 'little')
    c5 = int.from_bytes(b[0xc5:0xc5+8], 'little')
    c1 = int.from_bytes(b[0xc1:0xc1+8], 'little')
    c61 = int.from_bytes(b[0x61:0x61+8], 'little')
    d5 = int.from_bytes(b[0xd5:0xd5+8], 'little')
    if b5 > 0xffff or c5 > 0xffffffff:
        print('%-48s xor=%-5d b5=%#x c5=%#x c1=%#x c61=%#x d5=%#x' % (
            os.path.basename(f), s['xor_index'], b5, c5, c1, c61, d5))
