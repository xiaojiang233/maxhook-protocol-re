#!/usr/bin/env python3
"""Realization: the encrypt_enter event provides the COMPLETE register state
(5 parameters), which the full emulator uses.  The register state is NOT missing
— it's in encrypt_enter's object pointers.

encrypt_enter call 1:
  output_object   = 0x86dfff610  (RCX)
  input32_object  = 0x86dfff460  (RDX)
  input64_object  = 0x86dfff520  (R8, the key hex string)
  context_object  = 0x86dfff3b8  (R9)
  plaintext_object= 0x86dfff480  ([RSP+0x28])

So the full emulator CAN be run with these registers + the key/nonce/plaintext
strings (from encrypt_string events), producing the keystream."""
import json
from pathlib import Path

P = Path(r"E:\Coding\S1mple\target\vm_context_capture2")
lines = open(P / "events.jsonl", encoding="utf-8").read().splitlines()
events = [json.loads(l) for l in lines]

# collect all encrypt_string data_pointer for call 1 (key, plaintext)
print("call 1 encrypt_string events (data locations):")
for e in events:
    if e.get("kind") == "encrypt_string" and e.get("call_id") == "1":
        print("  %s: object=%s data=%s size=%d" % (
            e.get("label"), e.get("object_pointer"), e.get("data_pointer"), e.get("size")))

# the full set of inputs needed for the emulator:
# key hex string (64 chars), input32 (32 chars), plaintext (7382 bytes)
key = (P / "000004_call_1_input_input64.bin").read_bytes()
input32 = (P / "000003_call_1_input_input32.bin").read_bytes()
plaintext = (P / "000005_call_1_input_plaintext_json.bin").read_bytes()
print("\nkey (input64 hex string):", key.decode())
print("input32:", input32.decode())
print("plaintext size:", len(plaintext))

if __name__ == "__main__":
    main()
