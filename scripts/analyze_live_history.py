#!/usr/bin/env python3
"""Analyze the LIVE call-history ring buffer (pid 42948, correct key-schedule
state) to reconstruct the actual key-schedule execution sequence.

The history is 1024 code addresses in execution order (ring buffer). The
.bugland addresses are VM handler bodies / dispatch stubs. Compare across the
3 calls to find the STABLE key-schedule loop (key-independent) vs the
key-dependent branching."""
import json
from pathlib import Path
from collections import Counter, OrderedDict

CAP = Path(r"E:\Coding\S1mple\target\keystream_history_capture_20260814")

def load_history(call):
    d = json.loads(sorted(CAP.glob("*call_%s*.bin" % call))[0].read_bytes().decode("utf-8"))
    return d["history"]

def main():
    h1, h2, h3 = load_history(1), load_history(2), load_history(3)
    print("history lengths:", len(h1), len(h2), len(h3))

    # The dispatch stubs are the .bugland addresses that appear as 'target' in
    # the handler trace. But history includes non-dispatch blocks too.
    # Focus: find the repeating stable sequence (the key-schedule loop) that is
    # IDENTICAL across all 3 calls (key-independent structure).
    
    # Find common substrings of length >= 4 between the 3 histories (the stable loop)
    def common_prefix_sets(hist):
        # map each 4-gram to count
        grams = Counter()
        for i in range(len(hist) - 3):
            grams[tuple(hist[i:i+4])] += 1
        return grams

    g1, g2, g3 = common_prefix_sets(h1), common_prefix_sets(h2), common_prefix_sets(h3)
    common_grams = set(g1) & set(g2) & set(g3)
    print("\n4-grams common to ALL 3 calls (stable key-schedule fragments):", len(common_grams))

    # Find the longest common SUBSEQUENCE/loop: look at the most common 4-grams
    for g in sorted(common_grams, key=lambda x: -(g1[x]+g2[x]+g3[x]))[:20]:
        print("  %s -> %s -> %s -> %s  (freq %d/%d/%d)" % (
            g[0], g[1], g[2], g[3], g1[g], g2[g], g3[g]))

if __name__ == "__main__":
    main()
