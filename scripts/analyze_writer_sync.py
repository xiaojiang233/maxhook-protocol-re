#!/usr/bin/env python3
"""Analyze synchronized MaxHook writer passes against the true XOR keystream."""
from __future__ import annotations
import argparse, json, struct
from pathlib import Path


def events(path: Path):
    return [json.loads(x) for x in (path / "events.jsonl").read_text(encoding="utf-8").splitlines()]


def main() -> int:
    ap = argparse.ArgumentParser(); ap.add_argument("capture", type=Path); ap.add_argument("--output", type=Path)
    a = ap.parse_args(); root = a.capture.resolve(); ev = events(root)
    results=[]
    complete=sorted({int(e["call_id"]) for e in ev if e.get("kind")=="writer_sync_leave"})
    for cid in complete:
        strings={e["label"]:e for e in ev if e.get("kind")=="writer_sync_string" and int(e["call_id"])==cid}
        rec_event=next(e for e in ev if e.get("kind")=="writer_sync_records" and int(e["call_id"])==cid)
        rec=json.loads((root/rec_event["file"]).read_bytes())
        pt=(root/strings["plaintext_json"]["file"]).read_bytes(); ct=bytes.fromhex((root/strings["ciphertext_hex"]["file"]).read_text())
        ks=bytes(x^y for x,y in zip(pt,ct))
        # Execution begins with the unfinished tail of an earlier/setup pass
        # (offsets 16..60). Each real block is then exactly 16 records in the
        # VM's wrap order 0x10..0x3c,0x00..0x0c.
        lead = 0
        while lead < len(rec) and int(rec[lead]["offset"]) != 0:
            lead += 1
        blocks=[]
        for start in range(lead, len(rec), 16):
            chunk=rec[start:start+16]
            if len(chunk) != 16: break
            buf=bytearray(64)
            for r in chunk:
                off=int(r["offset"]); buf[off:off+4]=struct.pack("<I",int(r["value"],0))
            block_index=(start-lead)//16
            target=ks[block_index*64:(block_index+1)*64]
            blocks.append({"index":block_index,"hex":bytes(buf).hex(),
                "keystream_prefix_bytes":len(target),
                "equals_keystream":bytes(buf[:len(target)])==target})
        results.append({"call_id":cid,"plaintext_bytes":len(pt),"writer_records":len(rec),
            "discarded_leading_records":lead,"blocks":blocks,
            "all_blocks_equal_keystream":all(x["equals_keystream"] for x in blocks),
            "keystream_hex":ks.hex()})
    out={"schema":"maxhook.writer-sync.analysis/v1","capture":str(root),"calls":results}
    text=json.dumps(out,indent=2)+"\n"
    (a.output or root.joinpath("analysis.json")).write_text(text,encoding="utf-8")
    print(f"analyzed {len(results)} complete calls")
    return 0
if __name__=="__main__": raise SystemExit(main())
