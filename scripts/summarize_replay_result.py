import json,sys
p=sys.argv[1]
d=json.load(open(p))
print('instructions',d.get('instruction_count'),'error',d.get('error'))
print('seed',d.get('nonce_seed_log'))
for e in d.get('sha_component_events',[]):
 print(e.get('instruction'),e.get('kind'),e.get('rcx'),e.get('rdx'),e.get('r8'),'seeded',e.get('nonce_seeded'),'stopped',e.get('stopped_here'),'data',e.get('data_hex'))
print('tag_dump',len(d.get('tag_buffer_dump',[])))
print('patches',d.get('ret_trampoline_patches'))
print('recent',d.get('recent_instructions',[])[-12:])
