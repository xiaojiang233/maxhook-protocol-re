#!/usr/bin/env python3
import json, struct, glob, os

# Reconcile: the "block generator" @ 0x41a8a0 input buffer is a CONTEXT object
# whose first words are POINTERS. Verify the output is a fixed struct.

files = sorted(glob.glob(r"E:\Coding\S1mple\target\block_generator_manual_20260814_012601\*.bin"))

print("Input buffer (rcx) across calls — pointer words that CHANGE vs CONSTANT")
print("="*100)
prev_words = None
for f in files:
    j = json.loads(open(f).read())[0]
    b = bytes.fromhex(j['input_hex'])
    words = struct.unpack('<'+'Q'*(len(b)//8), b)
    tag = os.path.basename(f)[:6]
    print(f"  {tag}: " + "  ".join(f"{w:#018x}" for w in words))

# Identify which words are constant (struct layout) vs change (pointers to per-call heap)
print()
print("The changing words are heap POINTERS (per-call allocations).")
print("The constant words are the context struct's fixed fields.")
print()

# Decode the constant words of the input context
j = json.loads(open(files[0]).read())[0]
b = bytes.fromhex(j['input_hex'])
words = struct.unpack('<'+'Q'*(len(b)//8), b)
print("Context word roles (call 1):")
print(f"  word[0] = {words[0]:#x}  -> pointer (changes per call)")
print(f"  word[1] = {words[1]:#x}  -> pointer into module (0x180... constant image addr)")
print(f"  word[2] = {words[2]:#x}  -> pointer (changes per call, = word[0] - 0x15e8)")
print(f"  word[3] = {words[3]:#x}  -> zero")
print(f"  word[4] = {words[4]:#x}  -> 0x20 = 32 (size/len)")
print(f"  word[5] = {words[5]:#x}  -> 0x18098c969 pointer (module data)")
print(f"  word[6] = {words[6]:#x}  -> zero")
print(f"  word[7] = {words[7]:#x}  -> 0x400 = 1024 (capacity/size)")
print()

# word[2] - word[0] relationship
d = words[0] - words[2]
print(f"word[0] - word[2] = {d:#x} = {d} (offset between two heap pointers)")

# Now the OUTPUT constant struct
print()
print("Output buffer (rdx) constant struct = a std::string / std::vector-like header:")
oa = bytes.fromhex(json.loads(open(files[0]).read())[0]['output_hex'])
print("  bytes:", oa.hex())
print("  u32[0] = 0x27f = 639  (size/capacity field)")
print("  u32[7] = 0x1f80 = 8064")
print("  u32[8] = 0xffff = 65535")
