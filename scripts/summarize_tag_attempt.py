import json
from pathlib import Path
import sys
p=Path(sys.argv[1] if len(sys.argv) > 1 else 'tag_attempt_r17.json')
d=json.loads(p.read_text())
print('instruction_count',d.get('instruction_count'),'error',d.get('error'),'stopped',d.get('stopped_by_limit'))
print('nonce_seed_log',d.get('nonce_seed_log'))
print('sha_events',len(d.get('sha_component_events',[])))
for e in d.get('sha_component_events',[]):
 print(e.get('instruction'),e.get('kind'),e.get('rcx'),e.get('rdx'),e.get('r8'),'nonce_seeded',e.get('nonce_seeded'),'stopped',e.get('stopped_here'),'data_len',len(e.get('data_hex') or '')//2)
print('tag_dump',len(d.get('tag_buffer_dump',[])))
print('output',d.get('output_object_words'))
print('stubs',len(d.get('host_call_stubs',[])),len(d.get('null_read_stubs',[])),len(d.get('skipped_int3',[])))
