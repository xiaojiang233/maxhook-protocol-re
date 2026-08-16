#!/usr/bin/env python3
"""Trace-guided MaxHook VM semantic lifter (incremental, fail-closed).

This is not a complete cipher implementation. It provides a durable core for
executing data flow while a recorded trace fixes control flow. Complete
handlers are registered only after their context bytes, stack behavior, next
rolling key, VIP and dispatch target match captured before/after snapshots.
The chain A/B/C/D families and the early INIT handlers currently satisfy that
standard; prefix helpers remain available for focused unit tests.

Design rules:
- no guessed handler behavior: an unimplemented/partial target raises;
- all operations use explicit 8/16/32/64-bit truncation;
- VM push/pop are explicit and testable;
- a trace step supplies concrete VIP/key/target, avoiding symbolic jmp targets;
- partial semantic units are labelled as partial and never masquerade as a full
  handler implementation.
"""
from __future__ import annotations

import argparse
import json
import struct
from dataclasses import dataclass, field
from pathlib import Path
from typing import Callable

HERE = Path(__file__).resolve().parent
IMAGE_BASE = 0x180000000
BUG_BASE = 0x180980000
HANDLER_TABLE = 0x180C64EBD
CTX_SIZE = 0x400


def mask(bits: int) -> int:
    return (1 << bits) - 1


def u(value: int, bits: int) -> int:
    return value & mask(bits)


class MissingValue(RuntimeError):
    pass


class UnsupportedHandler(RuntimeError):
    def __init__(self, diagnostic: dict):
        self.diagnostic = diagnostic
        super().__init__(
            "unsupported trace target {target} at step {step_index} "
            "(instr={instr}, vip={vip}, body={handler_body})".format(**diagnostic)
        )


class TraceMismatch(RuntimeError):
    def __init__(self, diagnostic: dict):
        self.diagnostic = diagnostic
        super().__init__(json.dumps(diagnostic, sort_keys=True))


@dataclass
class TraceStep:
    instr: int
    source: int
    target: int
    key: int
    vip: int

    @classmethod
    def from_json(cls, item: dict) -> "TraceStep":
        return cls(
            int(item["instr"]), int(item["source"], 16), int(item["target"], 16),
            int(item["key"], 16), int(item["vip"], 16),
        )


@dataclass
class VMState:
    context: bytearray = field(default_factory=lambda: bytearray(CTX_SIZE))
    stack: list[int] = field(default_factory=list)
    writes: list[dict] = field(default_factory=list)
    dispatches: list[dict] = field(default_factory=list)
    registers: dict[str, int] = field(default_factory=dict)
    rsp_delta: int = 0

    def _check(self, off: int, size: int) -> None:
        if off < 0 or off + size > len(self.context):
            raise MissingValue(f"context access +0x{off:x} size {size}")

    def read(self, off: int, bits: int) -> int:
        size = bits // 8
        self._check(off, size)
        return int.from_bytes(self.context[off:off + size], "little")

    def write(self, off: int, bits: int, value: int, reason: str) -> None:
        size = bits // 8
        self._check(off, size)
        old = self.read(off, bits)
        value = u(value, bits)
        self.context[off:off + size] = value.to_bytes(size, "little")
        self.writes.append({
            "offset": off, "bits": bits, "old": old, "new": value,
            "reason": reason,
        })

    def push(self, value: int, bits: int = 64) -> None:
        self.stack.append(u(value, bits))
        self.rsp_delta -= bits // 8

    def pop(self, bits: int = 64) -> int:
        if not self.stack:
            raise MissingValue("VM stack underflow")
        self.rsp_delta += bits // 8
        return u(self.stack.pop(), bits)

    def current_rsp(self) -> int:
        if "rsp" not in self.registers:
            raise MissingValue("entry RSP is unavailable")
        return u(self.registers["rsp"] + self.rsp_delta, 64)

    def swap_slots_via_stack(self, a: int, b: int) -> None:
        """Semantics of push [A]; push [B]; pop [A]; pop [B]."""
        self.push(self.read(a, 64))
        self.push(self.read(b, 64))
        self.write(a, 64, self.pop(), "slot_swap_A")
        self.write(b, 64, self.pop(), "slot_swap_B")


class Bytecode:
    def __init__(self, blob: bytes, base: int = BUG_BASE):
        self.blob = blob
        self.base = base

    def read(self, va: int, bits: int) -> int:
        size = bits // 8
        off = va - self.base
        if off < 0 or off + size > len(self.blob):
            raise MissingValue(f"bytecode access 0x{va:x} size {size}")
        return int.from_bytes(self.blob[off:off + size], "little")

    def resolve_direct_jump(self, va: int) -> int | None:
        """Resolve the 5-byte E9 rel32 jump used by handler-table stubs."""
        off = va - self.base
        if off < 0 or off + 5 > len(self.blob) or self.blob[off] != 0xE9:
            return None
        rel = struct.unpack_from("<i", self.blob, off + 1)[0]
        return u(va + 5 + rel, 64)

    def read_signed(self, va: int, bits: int) -> int:
        value = self.read(va, bits)
        sign = 1 << (bits - 1)
        return value - (1 << bits) if value & sign else value


class Semantics:
    """Evidence-backed partial semantic units.

    The A/C prefix helpers stop at their VM-stack boundary for focused tests.
    Their complete handler wrappers apply the pop/write and dispatch suffix and
    are validated against captured before/after snapshots.
    """

    @staticmethod
    def chain_a_operands(bc: Bytecode, vip: int) -> dict:
        return {
            "swap_1_a": bc.read(vip + 4, 16),
            "swap_1_b": bc.read(vip + 2, 16),
            "swap_2_a": bc.read(vip + 0x10, 16),
            "swap_2_b": bc.read(vip + 8, 16),
            "raw_word": bc.read(vip + 0x14, 16),
        }

    @staticmethod
    def chain_a_state_prefix(state: VMState, raw_word: int) -> dict:
        # 0x180990985..0x180990aa4. r13 is a 32-bit transformed word.
        transformed = u(raw_word, 16) ^ state.read(0xF6, 32)
        state.write(0x0A, 32, state.read(0x0A, 32) + transformed,
                    "chain_A_rolling_key_add_transformed")
        branch_taken = state.read(0x162, 8) > 0x30
        if branch_taken:
            transformed = u(transformed + 0x531CA727, 32)
        state.write(0xE5, 16, state.read(0xE5, 16) - transformed,
                    "chain_A_state_e5_sub_transformed")
        state.write(0x0A, 32, state.read(0x0A, 32) | 0x33A09506,
                    "chain_A_rolling_key_or")
        return {
            "raw_word": u(raw_word, 16),
            "transformed_word": transformed,
            "ctx_162_gt_0x30": branch_taken,
        }

    @staticmethod
    def chain_a_pre_stack(state: VMState, bc: Bytecode, vip: int) -> dict:
        operands = Semantics.chain_a_operands(bc, vip)
        state.swap_slots_via_stack(operands["swap_1_a"], operands["swap_1_b"])
        state.swap_slots_via_stack(operands["swap_2_a"], operands["swap_2_b"])
        update = Semantics.chain_a_state_prefix(state, operands["raw_word"])
        return {**operands, **update, "semantic_boundary": "before pop at 0x180990aef"}


    @staticmethod
    def handler_chain_a(state: VMState, bc: Bytecode, step: TraceStep) -> None:
        """Complete chain A handler for target stub 0x1809815b2."""
        vip = step.vip
        info = Semantics.chain_a_pre_stack(state, bc, vip)
        dynamic_destination = u(state.read(0xE5, 16) - 0xEC45, 16)
        state.write(dynamic_destination, 64, state.pop(),
                    "chain_A_pop_to_e5_derived_slot")
        increment_slot = bc.read(vip + 0x12, 16)
        if dynamic_destination != increment_slot:
            state.write(increment_slot, 64, state.read(increment_slot, 64) + 8,
                        "chain_A_conditional_slot_add8")

        dispatch_full = u(bc.read(vip + 0x0E, 16) - state.read(0x0A, 32), 32)
        state.write(0x0A, 32, state.read(0x0A, 32) + dispatch_full,
                    "chain_A_key_add_dispatch")
        dispatch_index = dispatch_full & 0xFFFF
        dispatch_target = bc.read(HANDLER_TABLE + dispatch_index * 8, 64)
        advance = bc.read_signed(vip + 0x0A, 32)
        next_vip = u(vip + advance, 64)
        state.write(0x6D, 64, next_vip, "chain_A_vip_advance")
        state.dispatches.append({
            "source_body": "0x18099089e",
            "index": dispatch_index,
            "target": dispatch_target,
            "advance": advance,
            "next_vip": next_vip,
            "dynamic_destination": dynamic_destination,
            "increment_slot": increment_slot,
            "prefix": info,
        })

    @staticmethod
    def chain_c_operand(bc: Bytecode, vip: int) -> int:
        # 0x180a02ad9/0x180a02ae0: VIP + 6, then movzx r14, word [VIP+6].
        return bc.read(vip + 6, 16)

    @staticmethod
    def chain_c_pre_stack(state: VMState, raw_word: int) -> dict:
        """Execute 0x180a02ae0..0x180a02c1b, before pop r9.

        This corrects the earlier oversimplification "ctx[e5] += raw word".
        r14d is first XORed with the pre-update rolling key and may then be
        conditionally reduced by 0x681b64d8. Chain C also mutates ctx+0xa and
        ctx+0x5d before the e5 update.
        """
        old_key = state.read(0x0A, 32)
        transformed = u(raw_word, 16) ^ old_key
        state.write(0x0A, 32, old_key | transformed,
                    "chain_C_rolling_key_or_transformed")
        state.write(0x5D, 32, state.read(0x5D, 32) ^ 0x558A625A,
                    "chain_C_state_5d_xor")
        branch_taken = state.read(0x162, 8) > 0xFA
        if branch_taken:
            transformed = u(transformed - 0x681B64D8, 32)
        state.write(0xE5, 16, state.read(0xE5, 16) + transformed,
                    "chain_C_state_e5_add_transformed")
        state.write(0x0A, 32, state.read(0x0A, 32) - 0x4DBFDE8F,
                    "chain_C_rolling_key_sub")
        return {
            "raw_word": u(raw_word, 16),
            "transformed_word": transformed,
            "ctx_162_gt_0xfa": branch_taken,
            "semantic_boundary": "before pop at 0x180a02c1e",
        }

    @staticmethod
    def chain_c_post_stack_conditional(state: VMState) -> bool:
        """Execute only 0x180a02c65..0x180a02ca5 after the unresolved pop.

        Callers must apply the intervening pop/write first. Keeping this as a
        separate unit prevents a false claim that the complete chain is closed.
        """
        taken = bool(state.read(0x5D, 32) & 1)
        if taken:
            state.write(0x5D, 32, state.read(0x5D, 32) + 0x6ABD113B,
                        "chain_C_state_5d_conditional_add")
        return taken


    @staticmethod
    @staticmethod
    @staticmethod
    def handler_chain_d(state: VMState, bc: Bytecode, step: TraceStep) -> None:
        """Complete chain D handler for target stub 0x18098202a."""
        vip = step.vip
        transformed = u(
            bc.read(vip + 0x0A, 16)
            - state.read(0x0A, 32)
            - state.read(0xF6, 32),
            32,
        )
        state.write(0x0A, 32, state.read(0x0A, 32) + transformed,
                    "chain_D_key_add_transformed")
        state.write(0x5D, 32, state.read(0x5D, 32) - 0x7F594FCF,
                    "chain_D_state_5d_sub")
        state.write(0xE5, 16, state.read(0xE5, 16) + transformed,
                    "chain_D_state_e5_add_transformed")
        state.write(0x0A, 32, state.read(0x0A, 32) + 0x616C560B,
                    "chain_D_key_add_constant")
        conditional_5d = bool(state.read(0x5D, 32) & 1)
        if conditional_5d:
            state.write(0x5D, 32, state.read(0x5D, 32) | 0x472793ED,
                        "chain_D_state_5d_conditional_or")

        dynamic_destination = u(state.read(0xE5, 16) + 0x3661, 16)
        state.write(dynamic_destination, 64, state.pop(),
                    "chain_D_pop_to_e5_derived_slot")
        increment_slot = bc.read(vip + 8, 16)
        if dynamic_destination != increment_slot:
            state.write(increment_slot, 64, state.read(increment_slot, 64) + 8,
                        "chain_D_conditional_slot_add8")

        dispatch_full = u(
            (bc.read(vip + 0, 16) ^ state.read(0x0A, 32)) + 0x6489F70E,
            32,
        )
        state.write(0x0A, 32, state.read(0x0A, 32) | dispatch_full,
                    "chain_D_key_or_dispatch")
        dispatch_index = dispatch_full & 0xFFFF
        dispatch_target = bc.read(HANDLER_TABLE + dispatch_index * 8, 64)
        advance = bc.read_signed(vip + 4, 32)
        next_vip = u(vip + advance, 64)
        state.write(0x6D, 64, next_vip, "chain_D_vip_advance")
        state.dispatches.append({
            "source_body": "0x180b41fb8",
            "index": dispatch_index,
            "target": dispatch_target,
            "advance": advance,
            "next_vip": next_vip,
            "dynamic_destination": dynamic_destination,
            "increment_slot": increment_slot,
            "transformed": transformed,
            "conditional_5d": conditional_5d,
        })

    def handler_chain_b(state: VMState, bc: Bytecode, step: TraceStep) -> None:
        """Complete chain B handler for target stub 0x18098257f."""
        vip = step.vip
        transformed = u(
            (bc.read(vip + 0x0A, 16) ^ state.read(0x0A, 32))
            + state.read(0xF6, 32),
            32,
        )
        state.write(0x0A, 32, state.read(0x0A, 32) + transformed,
                    "chain_B_key_add_transformed")
        state.write(0x5D, 32, state.read(0x5D, 32) ^ 0x5F5C808F,
                    "chain_B_state_5d_xor")
        branch_taken = state.read(0x162, 8) > 0xD6
        if branch_taken:
            transformed = u(transformed + 0x3B6A3D7A, 32)
        state.write(0xE5, 16, state.read(0xE5, 16) - transformed,
                    "chain_B_state_e5_sub_transformed")

        dynamic_destination = state.read(0xE5, 16) ^ 0xC989
        state.write(dynamic_destination, 64, state.pop(),
                    "chain_B_pop_to_e5_derived_slot")
        increment_slot = bc.read(vip + 0x0E, 16)
        if dynamic_destination != increment_slot:
            state.write(increment_slot, 64, state.read(increment_slot, 64) + 8,
                        "chain_B_conditional_slot_add8")

        dispatch_full = u(
            bc.read(vip + 0, 16) - state.read(0x0A, 32) + 0x5214A88C,
            32,
        )
        state.write(0x0A, 32, state.read(0x0A, 32) - dispatch_full,
                    "chain_B_key_sub_dispatch")
        dispatch_index = dispatch_full & 0xFFFF
        dispatch_target = bc.read(HANDLER_TABLE + dispatch_index * 8, 64)
        advance = bc.read_signed(vip + 6, 32)
        next_vip = u(vip + advance, 64)
        state.write(0x6D, 64, next_vip, "chain_B_vip_advance")
        state.dispatches.append({
            "source_body": "0x1809bfebb",
            "index": dispatch_index,
            "target": dispatch_target,
            "advance": advance,
            "next_vip": next_vip,
            "dynamic_destination": dynamic_destination,
            "increment_slot": increment_slot,
            "transformed": transformed,
            "ctx_162_gt_0xd6": branch_taken,
        })

    def handler_chain_c(state: VMState, bc: Bytecode, step: TraceStep) -> None:
        """Complete chain C handler for target stub 0x1809a3b86."""
        vip = step.vip
        raw = Semantics.chain_c_operand(bc, vip)
        prefix = Semantics.chain_c_pre_stack(state, raw)
        dynamic_destination = u(state.read(0xE5, 16) + 0xD04C, 16)
        state.write(dynamic_destination, 64, state.pop(),
                    "chain_C_pop_to_e5_derived_slot")
        increment_slot = bc.read(vip + 8, 16)
        if dynamic_destination != increment_slot:
            state.write(increment_slot, 64, state.read(increment_slot, 64) + 8,
                        "chain_C_conditional_slot_add8")
        conditional_5d = Semantics.chain_c_post_stack_conditional(state)

        dispatch_full = u(
            bc.read(vip + 0, 16) - state.read(0x0A, 32) + 0x04A511EB,
            32,
        )
        state.write(0x0A, 32, state.read(0x0A, 32) + dispatch_full,
                    "chain_C_key_add_dispatch")
        dispatch_index = dispatch_full & 0xFFFF
        dispatch_target = bc.read(HANDLER_TABLE + dispatch_index * 8, 64)
        advance = bc.read_signed(vip + 2, 32)
        next_vip = u(vip + advance, 64)
        state.write(0x6D, 64, next_vip, "chain_C_vip_advance")
        state.dispatches.append({
            "source_body": "0x180a02a99",
            "index": dispatch_index,
            "target": dispatch_target,
            "advance": advance,
            "next_vip": next_vip,
            "dynamic_destination": dynamic_destination,
            "increment_slot": increment_slot,
            "conditional_5d": conditional_5d,
            "prefix": prefix,
        })


    @staticmethod
    def handler_180c02701(state: VMState, bc: Bytecode, step: TraceStep) -> None:
        """Complete semantics for target stub 0x1809a57e1.

        Static body: 0x180c02701..0x180c02d8c. Junk-only register arithmetic
        and a balanced native pushfq/pop are omitted; every context/VM-stack
        write and the dispatch/VIP calculation are retained.
        """
        vip = step.vip
        word_0 = bc.read(vip + 0, 16)
        word_4 = bc.read(vip + 4, 16)
        word_6 = bc.read(vip + 6, 16)

        transformed = u((word_4 ^ state.read(0x0A, 32)) + state.read(0xF6, 32), 32)
        state.write(0x5D, 32, state.read(0x5D, 32) - 0x471E9483,
                    "handler_180c02701_state_5d_sub")
        state.write(0xE5, 16, state.read(0xE5, 16) - transformed,
                    "handler_180c02701_state_e5_sub_transformed")
        state.write(0x0A, 32, state.read(0x0A, 32) | 0x00754DC8,
                    "handler_180c02701_key_or_754dc8")
        state.write(0x0A, 32, state.read(0x0A, 32) ^ 0x744F7B6C,
                    "handler_180c02701_key_xor_744f7b6c")
        state.write(0x5D, 32, state.read(0x5D, 32) + 0x42B08572,
                    "handler_180c02701_state_5d_add")
        state.write(0x0A, 32, state.read(0x0A, 32) | 0x3EA1D931,
                    "handler_180c02701_key_or_3ea1d931")

        push_offset = u(state.read(0xE5, 16) + 0x79FC, 16)
        state.push(state.read(push_offset, 64))
        state.write(word_6, 64, state.read(word_6, 64) - 8,
                    "handler_180c02701_slot_vip_plus_6_sub8")
        state.write(0x5D, 32, state.read(0x5D, 32) & 0x64205BD0,
                    "handler_180c02701_state_5d_and")
        state.write(0x162, 8, state.read(0x162, 8) - 0xFC,
                    "handler_180c02701_flag_add4")

        dispatch_full = u(word_0 - 0x52037AC5, 32)
        state.write(0x0A, 32, state.read(0x0A, 32) | dispatch_full,
                    "handler_180c02701_key_or_dispatch")
        dispatch_index = dispatch_full & 0xFFFF
        dispatch_target = bc.read(HANDLER_TABLE + dispatch_index * 8, 64)
        advance = bc.read_signed(vip + 0x0A, 32)
        next_vip = u(vip + advance, 64)
        state.write(0x6D, 64, next_vip, "handler_180c02701_vip_advance")
        state.dispatches.append({
            "source_body": "0x180c02701",
            "index": dispatch_index,
            "target": dispatch_target,
            "advance": advance,
            "next_vip": next_vip,
            "push_offset": push_offset,
            "transformed": transformed,
        })


    @staticmethod
    def handler_180ac2b8c(state: VMState, bc: Bytecode, step: TraceStep) -> None:
        """Complete semantics for target stub 0x1809803d9.

        Static body: 0x180ac2b8c..0x180ac30e1. Retains all context/stack
        mutations and the exact dispatch/VIP calculation.
        """
        vip = step.vip
        if state.read(0x5D, 32) & 1:
            state.write(0x5D, 32, state.read(0x5D, 32) | 0x5C726B01,
                        "handler_180ac2b8c_state_5d_conditional_or")

        raw = bc.read(vip + 0x0A, 16)
        transformed = u((raw ^ state.read(0x0A, 32)) + state.read(0xF6, 32), 32)
        state.write(0x0A, 32, state.read(0x0A, 32) + transformed,
                    "handler_180ac2b8c_key_add_transformed")
        branch_taken = state.read(0x162, 8) > 0x66
        if branch_taken:
            transformed = u(transformed ^ 0x6B2D9F5B, 32)
        state.write(0xE5, 16, state.read(0xE5, 16) + transformed,
                    "handler_180ac2b8c_state_e5_add_transformed")

        push_offset = u(state.read(0xE5, 16) + 0x76C9, 16)
        state.push(state.read(push_offset, 64))
        slot = bc.read(vip + 0, 16)
        state.write(slot, 64, state.read(slot, 64) - 8,
                    "handler_180ac2b8c_slot_vip_plus_0_sub8")
        state.write(0x162, 8, state.read(0x162, 8) | 0x14,
                    "handler_180ac2b8c_flag_or_14")

        dispatch_full = u(
            (bc.read(vip + 8, 16) ^ state.read(0x0A, 32)) + 0x49D70BDB,
            32,
        )
        state.write(0x0A, 32, state.read(0x0A, 32) + dispatch_full,
                    "handler_180ac2b8c_key_add_dispatch")
        dispatch_index = dispatch_full & 0xFFFF
        dispatch_target = bc.read(HANDLER_TABLE + dispatch_index * 8, 64)
        advance = bc.read_signed(vip + 2, 32)
        next_vip = u(vip + advance, 64)
        state.write(0x6D, 64, next_vip, "handler_180ac2b8c_vip_advance")
        state.dispatches.append({
            "source_body": "0x180ac2b8c",
            "index": dispatch_index,
            "target": dispatch_target,
            "advance": advance,
            "next_vip": next_vip,
            "push_offset": push_offset,
            "transformed": transformed,
            "ctx_162_gt_0x66": branch_taken,
        })


    @staticmethod
    def handler_1809a4f60(state: VMState, bc: Bytecode, step: TraceStep) -> None:
        """Complete eight-slot permutation and dispatch for stub 0x18098c63d."""
        vip = step.vip
        source_word_offsets = [0x1E, 0x20, 0x02, 0x22, 0x04, 0x14, 0x18, 0x10]
        destination_word_offsets = [0x1C, 0x24, 0x12, 0x00, 0x16, 0x0A, 0x1A, 0x0E]
        sources = [bc.read(vip + off, 16) for off in source_word_offsets]
        destinations = [bc.read(vip + off, 16) for off in destination_word_offsets]
        for source in sources:
            state.push(state.read(source, 64))
        for destination in destinations:
            state.write(destination, 64, state.pop(),
                        "handler_1809a4f60_slot_permutation")

        state.write(0x162, 8, state.read(0x162, 8) & 0x61,
                    "handler_1809a4f60_flag_and_61")
        dispatch_full = u(
            bc.read(vip + 0x0C, 16) + state.read(0x0A, 32) + 0x68C971A1,
            32,
        )
        state.write(0x0A, 32, state.read(0x0A, 32) & dispatch_full,
                    "handler_1809a4f60_key_and_dispatch")
        dispatch_index = dispatch_full & 0xFFFF
        dispatch_target = bc.read(HANDLER_TABLE + dispatch_index * 8, 64)
        advance = bc.read_signed(vip + 6, 32)
        next_vip = u(vip + advance, 64)
        state.write(0x6D, 64, next_vip, "handler_1809a4f60_vip_advance")
        state.dispatches.append({
            "source_body": "0x1809a4f60",
            "index": dispatch_index,
            "target": dispatch_target,
            "advance": advance,
            "next_vip": next_vip,
            "sources": sources,
            "destinations": destinations,
        })


    @staticmethod
    def handler_180bbe02d(state: VMState, bc: Bytecode, step: TraceStep) -> None:
        """Complete six-slot permutation and dispatch for stub 0x180987adc."""
        vip = step.vip
        source_word_offsets = [0x16, 0x02, 0x10, 0x1C, 0x12, 0x0A]
        destination_word_offsets = [0x08, 0x18, 0x00, 0x06, 0x14, 0x04]
        sources = [bc.read(vip + off, 16) for off in source_word_offsets]
        destinations = [bc.read(vip + off, 16) for off in destination_word_offsets]
        for source in sources:
            state.push(state.read(source, 64))
        for destination in destinations:
            state.write(destination, 64, state.pop(),
                        "handler_180bbe02d_slot_permutation")

        dispatch_full = u(
            bc.read(vip + 0x1A, 16) + state.read(0x0A, 32) + 0x0293CF10,
            32,
        )
        state.write(0x0A, 32, state.read(0x0A, 32) & dispatch_full,
                    "handler_180bbe02d_key_and_dispatch")
        dispatch_index = dispatch_full & 0xFFFF
        dispatch_target = bc.read(HANDLER_TABLE + dispatch_index * 8, 64)
        advance = bc.read_signed(vip + 0x0C, 32)
        next_vip = u(vip + advance, 64)
        state.write(0x6D, 64, next_vip, "handler_180bbe02d_vip_advance")
        state.dispatches.append({
            "source_body": "0x180bbe02d",
            "index": dispatch_index,
            "target": dispatch_target,
            "advance": advance,
            "next_vip": next_vip,
            "sources": sources,
            "destinations": destinations,
        })


    @staticmethod
    @staticmethod
    @staticmethod
    @staticmethod
    @staticmethod
    @staticmethod
    def handler_1809d1c98(state: VMState, bc: Bytecode, step: TraceStep) -> None:
        """Complete reset/state/dispatch handler for target stub 0x1809ceaf1."""
        vip = step.vip
        for off, bits in [
            (0xF6, 32), (0xFA, 32), (0x0A, 32), (0xE5, 16),
            (0x81, 32), (0x00, 16), (0x69, 32), (0x5D, 32),
            (0xE1, 32), (0x3E, 16), (0x162, 8),
        ]:
            state.write(off, bits, 0, "handler_1809d1c98_state_reset")
        state.write(0x0A, 32, state.read(0x0A, 32) | bc.read(vip + 0x0E, 32),
                    "handler_1809d1c98_key_or_dword_vip_plus_e")
        state.write(0x0A, 32, state.read(0x0A, 32) + 0x6733B88E,
                    "handler_1809d1c98_key_add_constant")
        state.write(0x5D, 32, state.read(0x5D, 32) - 0x513C8347,
                    "handler_1809d1c98_state_5d_sub")

        dispatch_index = bc.read(vip + 8, 16)
        dispatch_target = bc.read(HANDLER_TABLE + dispatch_index * 8, 64)
        advance = bc.read_signed(vip + 0x16, 32)
        next_vip = u(vip + advance, 64)
        state.write(0x6D, 64, next_vip, "handler_1809d1c98_vip_advance")
        state.dispatches.append({
            "source_body": "0x1809d1c98",
            "index": dispatch_index,
            "target": dispatch_target,
            "advance": advance,
            "next_vip": next_vip,
        })

    def handler_180a31591(state: VMState, bc: Bytecode, step: TraceStep) -> None:
        """Complete VM-state reset/dispatch handler for stub 0x1809ac339."""
        vip = step.vip
        for off, bits in [
            (0x5D, 32), (0xE1, 32), (0x3E, 16), (0xE5, 16),
            (0x00, 16), (0x0A, 32), (0x81, 32), (0x69, 32),
            (0xF6, 32), (0xFA, 32), (0x162, 8),
        ]:
            state.write(off, bits, 0, "handler_180a31591_state_reset")
        dispatch_index = bc.read(vip + 8, 16)
        dispatch_target = bc.read(HANDLER_TABLE + dispatch_index * 8, 64)
        advance = bc.read_signed(vip + 4, 32)
        next_vip = u(vip + advance, 64)
        state.write(0x6D, 64, next_vip, "handler_180a31591_vip_advance")
        state.dispatches.append({
            "source_body": "0x180a31591",
            "index": dispatch_index,
            "target": dispatch_target,
            "advance": advance,
            "next_vip": next_vip,
        })

    def handler_180a182e9(state: VMState, bc: Bytecode, step: TraceStep) -> None:
        """Complete swap/pop/dispatch handler for target stub 0x180981a92."""
        vip = step.vip
        swap_a = bc.read(vip + 0x0A, 16)
        swap_b = bc.read(vip + 0x0C, 16)
        state.swap_slots_via_stack(swap_a, swap_b)
        pop_slot = bc.read(vip + 0, 16)
        state.write(pop_slot, 64, state.pop(),
                    "handler_180a182e9_pop_to_vip_plus_0_slot")
        increment_slot = bc.read(vip + 8, 16)
        state.write(increment_slot, 64, state.read(increment_slot, 64) + 8,
                    "handler_180a182e9_slot_vip_plus_8_add8")
        if state.read(0x5D, 32) & 1:
            state.write(0x5D, 32, state.read(0x5D, 32) | 0x4BFBA08F,
                        "handler_180a182e9_state_5d_conditional_or")

        dispatch_full = u(bc.read(vip + 6, 16) + state.read(0x0A, 32), 32)
        state.write(0x0A, 32, state.read(0x0A, 32) + dispatch_full,
                    "handler_180a182e9_key_add_dispatch")
        dispatch_index = dispatch_full & 0xFFFF
        dispatch_target = bc.read(HANDLER_TABLE + dispatch_index * 8, 64)
        advance = bc.read_signed(vip + 2, 32)
        next_vip = u(vip + advance, 64)
        state.write(0x6D, 64, next_vip, "handler_180a182e9_vip_advance")
        state.dispatches.append({
            "source_body": "0x180a182e9",
            "index": dispatch_index,
            "target": dispatch_target,
            "advance": advance,
            "next_vip": next_vip,
            "swap": [swap_a, swap_b],
            "pop_slot": pop_slot,
            "increment_slot": increment_slot,
        })

    def handler_1809da384(state: VMState, bc: Bytecode, step: TraceStep) -> None:
        """Complete VM-state reset/dispatch handler for stub 0x180981ac9."""
        vip = step.vip
        for off, bits in [
            (0xE5, 16), (0xFA, 32), (0x81, 32), (0x5D, 32),
            (0x3E, 16), (0x0A, 32), (0xE1, 32), (0xF6, 32),
            (0x00, 16), (0x69, 32), (0x162, 8),
        ]:
            state.write(off, bits, 0, "handler_1809da384_state_reset")
        state.write(0x0A, 32, state.read(0x0A, 32) & 0x029FA20A,
                    "handler_1809da384_key_and_constant")

        dispatch_index = bc.read(vip + 0x0C, 16)
        dispatch_target = bc.read(HANDLER_TABLE + dispatch_index * 8, 64)
        advance = bc.read_signed(vip + 4, 32)
        next_vip = u(vip + advance, 64)
        state.write(0x6D, 64, next_vip, "handler_1809da384_vip_advance")
        state.dispatches.append({
            "source_body": "0x1809da384",
            "index": dispatch_index,
            "target": dispatch_target,
            "advance": advance,
            "next_vip": next_vip,
        })

    def handler_180982798(state: VMState, bc: Bytecode, step: TraceStep) -> None:
        """Complete stack/dispatch handler for target stub 0x1809816a2."""
        vip = step.vip
        state.write(0x0A, 32, state.read(0x0A, 32) ^ bc.read(vip + 0, 32),
                    "handler_180982798_key_xor_dword_vip0")
        increment_slot = bc.read(vip + 8, 16)
        state.write(increment_slot, 64, state.read(increment_slot, 64) + 8,
                    "handler_180982798_slot_vip_plus_8_add8")
        pop_slot = bc.read(vip + 6, 16)
        state.write(pop_slot, 64, state.pop(),
                    "handler_180982798_pop_to_vip_plus_6_slot")
        if state.read(0x5D, 32) & 1:
            state.write(0x5D, 32, state.read(0x5D, 32) & 0x049C3A21,
                        "handler_180982798_state_5d_conditional_and")
        state.write(0x5D, 32, state.read(0x5D, 32) ^ 0x65753E5F,
                    "handler_180982798_state_5d_xor")

        dispatch_full = u(
            (bc.read(vip + 4, 16) - state.read(0x0A, 32)) ^ 0x2FC2AB68,
            32,
        )
        state.write(0x0A, 32, state.read(0x0A, 32) | dispatch_full,
                    "handler_180982798_key_or_dispatch")
        dispatch_index = dispatch_full & 0xFFFF
        dispatch_target = bc.read(HANDLER_TABLE + dispatch_index * 8, 64)
        advance = bc.read_signed(vip + 0x0A, 32)
        next_vip = u(vip + advance, 64)
        state.write(0x6D, 64, next_vip, "handler_180982798_vip_advance")
        state.dispatches.append({
            "source_body": "0x180982798",
            "index": dispatch_index,
            "target": dispatch_target,
            "advance": advance,
            "next_vip": next_vip,
            "increment_slot": increment_slot,
            "pop_slot": pop_slot,
        })

    @staticmethod
    @staticmethod
    @staticmethod
    @staticmethod
    @staticmethod
    @staticmethod
    @staticmethod
    def handler_180a34e0f(state: VMState, bc: Bytecode, step: TraceStep) -> None:
        """Complete multi-stage ARX/dynamic-copy handler for stub 0x1809819de."""
        vip = step.vip
        transformed_a = u(
            (bc.read(vip + 0x0C, 16) - state.read(0x0A, 32))
            ^ state.read(0x69, 32),
            32,
        )
        state.write(0x5D, 32, state.read(0x5D, 32) - 0x79A3DDFA,
                    "handler_180a34e0f_state_5d_sub")
        state.write(0x00, 16, state.read(0x00, 16) - transformed_a,
                    "handler_180a34e0f_state_0_sub")
        state.write(0x0A, 32, state.read(0x0A, 32) ^ bc.read(vip + 6, 32),
                    "handler_180a34e0f_key_xor_dword_vip_plus_6")

        transformed_b = u(
            bc.read(vip + 4, 16)
            - state.read(0x0A, 32)
            - state.read(0xF6, 32),
            32,
        )
        state.write(0x0A, 32, state.read(0x0A, 32) - transformed_b,
                    "handler_180a34e0f_key_sub_transformed_b")
        if state.read(0x162, 8) > 0x89:
            transformed_b = u(transformed_b + 0x02F8E1CB, 32)
        state.write(0xE5, 16, state.read(0xE5, 16) - transformed_b,
                    "handler_180a34e0f_state_e5_sub")

        dispatch_full = u(bc.read(vip + 0x0A, 16) - 0x33856881, 32)
        state.write(0x0A, 32, state.read(0x0A, 32) - dispatch_full,
                    "handler_180a34e0f_key_sub_dispatch")
        dispatch_index = dispatch_full & 0xFFFF
        dispatch_target = bc.read(HANDLER_TABLE + dispatch_index * 8, 64)
        state.write(0xED, 64, dispatch_target,
                    "handler_180a34e0f_dispatch_target_cache")
        state.write(0x0A, 32, state.read(0x0A, 32) - 0x0DCEAE0A,
                    "handler_180a34e0f_key_sub_constant")
        state.write(0x5D, 32, state.read(0x5D, 32) ^ 0x040B7D68,
                    "handler_180a34e0f_state_5d_xor_a")

        destination = u(state.read(0xE5, 16) + 0x97F1, 16)
        source = u(state.read(0x00, 16) + 0x2AD9, 16)
        state.write(destination, 32, state.read(source, 32),
                    "handler_180a34e0f_dynamic_dword_copy")
        state.write(destination + 4, 32, 0,
                    "handler_180a34e0f_dynamic_dword_clear_high")

        advance = bc.read_signed(vip + 0, 32)
        next_vip = u(vip + advance, 64)
        state.write(0x6D, 64, next_vip, "handler_180a34e0f_vip_advance")
        state.write(0x5D, 32, state.read(0x5D, 32) ^ 0x7D75E3CB,
                    "handler_180a34e0f_state_5d_xor_b")
        state.write(0x0A, 32, state.read(0x0A, 32) | 0x7A4A758C,
                    "handler_180a34e0f_key_or_constant")
        state.write(0x5D, 32, state.read(0x5D, 32) + 0x4F525B73,
                    "handler_180a34e0f_state_5d_add")
        state.dispatches.append({
            "source_body": "0x180a34e0f",
            "index": dispatch_index,
            "target": dispatch_target,
            "advance": advance,
            "next_vip": next_vip,
            "destination": destination,
            "source": source,
        })

    def handler_1809ba2f0(state: VMState, bc: Bytecode, step: TraceStep) -> None:
        """Complete two-swap ARX/dynamic-add handler for stub 0x18098b0a7."""
        vip = step.vip
        swap1_a = bc.read(vip + 0, 16)
        swap1_b = bc.read(vip + 0x0E, 16)
        state.swap_slots_via_stack(swap1_a, swap1_b)
        if state.read(0x5D, 32) & 1:
            state.write(0x5D, 32, state.read(0x5D, 32) | 0x30389017,
                        "handler_1809ba2f0_state_5d_conditional_or")
        swap2_a = bc.read(vip + 0x0C, 16)
        swap2_b = bc.read(vip + 0x10, 16)
        state.swap_slots_via_stack(swap2_a, swap2_b)

        transformed_a = u(
            (bc.read(vip + 2, 16) ^ state.read(0x0A, 32))
            - state.read(0x69, 32),
            32,
        )
        state.write(0x0A, 32, state.read(0x0A, 32) | transformed_a,
                    "handler_1809ba2f0_key_or_transformed_a")
        state.write(0x00, 16, state.read(0x00, 16) - transformed_a,
                    "handler_1809ba2f0_state_0_sub")

        transformed_b = u(
            (bc.read(vip + 8, 16) ^ state.read(0x0A, 32))
            - state.read(0xF6, 32),
            32,
        )
        state.write(0x0A, 32, state.read(0x0A, 32) | transformed_b,
                    "handler_1809ba2f0_key_or_transformed_b")
        state.write(0x5D, 32, state.read(0x5D, 32) & 0x513A7214,
                    "handler_1809ba2f0_state_5d_and")
        state.write(0xE5, 16, state.read(0xE5, 16) + transformed_b,
                    "handler_1809ba2f0_state_e5_add")

        destination = u(state.read(0xE5, 16) - 0x176C, 16)
        source = state.read(0x00, 16)
        state.write(destination, 64, state.read(destination, 64) + state.read(source, 64),
                    "handler_1809ba2f0_dynamic_qword_add")
        state.write(0x0A, 32, state.read(0x0A, 32) - 0x39E740C9,
                    "handler_1809ba2f0_key_sub_constant")
        state.write(0x0A, 32, state.read(0x0A, 32) ^ bc.read(vip + 4, 32),
                    "handler_1809ba2f0_key_xor_dword_vip_plus_4")
        state.write(0x162, 8, state.read(0x162, 8) | 0x22,
                    "handler_1809ba2f0_flag_or_22")

        dispatch_full = u(bc.read(vip + 0x0A, 16) - 0x08F40576, 32)
        state.write(0x0A, 32, state.read(0x0A, 32) | dispatch_full,
                    "handler_1809ba2f0_key_or_dispatch")
        dispatch_index = dispatch_full & 0xFFFF
        dispatch_target = bc.read(HANDLER_TABLE + dispatch_index * 8, 64)
        advance = bc.read_signed(vip + 0x12, 32)
        next_vip = u(vip + advance, 64)
        state.write(0x6D, 64, next_vip, "handler_1809ba2f0_vip_advance")
        state.dispatches.append({
            "source_body": "0x1809ba2f0",
            "index": dispatch_index,
            "target": dispatch_target,
            "advance": advance,
            "next_vip": next_vip,
            "swaps": [[swap1_a, swap1_b], [swap2_a, swap2_b]],
            "destination": destination,
            "source": source,
        })

    def handler_180addfc6_step34(state: VMState, bc: Bytecode, step: TraceStep) -> None:
        """Decoded outer 0x18098858a program instance at VIP 0x1814f1745.

        The outer wrapper applies its fixed pre-inner state program, selects
        inner index 0x1f7 (chain W) at VIP 0x1814e3e4d, and leaves RSP/stack
        unchanged for this instance.
        """
        if step.vip != 0x1814F1745:
            raise MissingValue(f"outer 0x18098858a descriptor for VIP 0x{step.vip:x}")
        state.write(0x5D, 32, state.read(0x5D, 32) + 0x31D126F2,
                    "outer_0x354_state_5d_add_31d126f2")
        state.write(0x00, 16, state.read(0x00, 16) ^ bc.read(step.vip + 4, 16),
                    "outer_0x354_state_0_xor_word_vip_plus_4")
        state.write(0x5D, 32, state.read(0x5D, 32) ^ 0x5B03772F,
                    "outer_0x354_state_5d_xor_5b03772f")
        state.write(0x5D, 32, state.read(0x5D, 32) + 0x0636B513,
                    "outer_0x354_state_5d_add_0636b513")
        state.write(0x0A, 32, state.read(0x0A, 32) - 0xF9CB01F7,
                    "outer_0x354_key_sub_f9cb01f7")
        state.write(0xED, 64, 0x18098A787,
                    "outer_0x354_inner_stub_cache")
        state.write(0x0A, 32, state.read(0x0A, 32) - 0xF9CA4412,
                    "outer_0x354_key_sub_f9ca4412")
        state.write(0x5D, 32, state.read(0x5D, 32) & 0x7C2BFE63,
                    "outer_0x354_state_5d_and_7c2bfe63")
        state.write(0xE5, 16, state.read(0xE5, 16) - 0x4412,
                    "outer_0x354_state_e5_sub_4412")
        state.write(0x0A, 32, state.read(0x0A, 32) - 0x6C4B7E4B,
                    "outer_0x354_key_sub_6c4b7e4b")
        state.write(0x45, 64, state.read(0xA7, 64),
                    "outer_0x354_state_45_from_a7")
        inner_vip = 0x1814E3E4D
        state.write(0x6D, 64, inner_vip, "outer_0x354_inner_vip")
        result = Semantics.inner_chain_w(state, bc, inner_vip)
        state.dispatches.append({
            "source_body": "0x180addfc6",
            "outer_vip": step.vip,
            **result,
        })

    def inner_chain_w(state: VMState, bc: Bytecode, vip: int) -> dict:
        """Complete inner index 0x1f7 / body 0x180a725cb semantics."""
        transformed_a = u(bc.read(vip + 0x0A, 8) - state.read(0x5D, 32), 32)
        state.write(0x0A, 32, state.read(0x0A, 32) - transformed_a,
                    "inner_chain_W_key_sub_transformed_a")
        state.write(0x5D, 32, state.read(0x5D, 32) ^ 0x5E800FC4,
                    "inner_chain_W_state_5d_xor")
        state.write(0x81, 32, state.read(0x81, 32) + transformed_a,
                    "inner_chain_W_state_81_add")
        state.write(0x69, 32, state.read(0x69, 32) & transformed_a,
                    "inner_chain_W_state_69_and")

        transformed_b = u(bc.read(vip + 6, 16) + state.read(0x0A, 32), 32)
        state.write(0x0A, 32, state.read(0x0A, 32) ^ transformed_b,
                    "inner_chain_W_key_xor_transformed_b")
        state.write(0x5D, 32, state.read(0x5D, 32) + 0x462DC540,
                    "inner_chain_W_state_5d_add")
        branch_taken = state.read(0x162, 8) > 3
        if branch_taken:
            transformed_b = u(transformed_b + 0x05E8880D, 32)
        state.write(0xE5, 16, state.read(0xE5, 16) - transformed_b,
                    "inner_chain_W_state_e5_sub")

        destination = state.read(0xE5, 16) ^ 0xFA43
        shift = u(state.read(0x81, 32) - 0x7829EBAB, 32) & 0x3F
        if shift:
            state.write(destination, 64, state.read(destination, 64) << shift,
                        "inner_chain_W_dynamic_qword_shift")

        dispatch_full = u(
            (bc.read(vip + 0x10, 16) + state.read(0x0A, 32)) ^ 0x053EC03C,
            32,
        )
        state.write(0x0A, 32, state.read(0x0A, 32) | dispatch_full,
                    "inner_chain_W_key_or_dispatch")
        dispatch_index = dispatch_full & 0xFFFF
        dispatch_target = bc.read(HANDLER_TABLE + dispatch_index * 8, 64)
        advance = bc.read_signed(vip + 0x0B, 32)
        next_vip = u(vip + advance, 64)
        state.write(0x6D, 64, next_vip, "inner_chain_W_vip_advance")
        return {
            "inner_index": 0x1F7,
            "index": dispatch_index,
            "target": dispatch_target,
            "advance": advance,
            "next_vip": next_vip,
            "destination": destination,
            "shift": shift,
            "ctx_162_gt_3": branch_taken,
        }

    def handler_1809a37ff(state: VMState, bc: Bytecode, step: TraceStep) -> None:
        """Complete ARX/dynamic-slot handler for target stub 0x180988d5e."""
        vip = step.vip
        transformed_a = u(
            (bc.read(vip + 4, 16) - state.read(0x0A, 32))
            ^ state.read(0x69, 32),
            32,
        )
        state.write(0x0A, 32, state.read(0x0A, 32) | transformed_a,
                    "handler_1809a37ff_key_or_transformed_a")
        state.write(0x00, 16, state.read(0x00, 16) - transformed_a,
                    "handler_1809a37ff_state_0_sub")
        transformed_b = u(
            (bc.read(vip + 2, 16) + state.read(0x0A, 32))
            ^ state.read(0xF6, 32),
            32,
        )
        state.write(0x0A, 32, state.read(0x0A, 32) ^ transformed_b,
                    "handler_1809a37ff_key_xor_transformed_b")
        state.write(0x5D, 32, state.read(0x5D, 32) & 0x4DA11B8C,
                    "handler_1809a37ff_state_5d_and")
        state.write(0xE5, 16, state.read(0xE5, 16) + transformed_b,
                    "handler_1809a37ff_state_e5_add")

        dispatch_full = u(
            bc.read(vip + 0, 16) ^ state.read(0x0A, 32) ^ 0x0F4A0222,
            32,
        )
        state.write(0x0A, 32, state.read(0x0A, 32) & dispatch_full,
                    "handler_1809a37ff_key_and_dispatch")
        dispatch_index = dispatch_full & 0xFFFF
        dispatch_target = bc.read(HANDLER_TABLE + dispatch_index * 8, 64)
        state.write(0xED, 64, dispatch_target,
                    "handler_1809a37ff_dispatch_target_cache")

        destination = u(state.read(0xE5, 16) - 0x6AB9, 16)
        source = u(state.read(0x00, 16) - 0xD85F, 16)
        source_low32 = state.read(source, 32)
        signed_value = source_low32 - (1 << 32) if source_low32 & 0x80000000 else source_low32
        state.write(destination, 64, signed_value,
                    "handler_1809a37ff_sign_extended_dynamic_write")

        advance = bc.read_signed(vip + 6, 32)
        next_vip = u(vip + advance, 64)
        state.write(0x6D, 64, next_vip, "handler_1809a37ff_vip_advance")
        state.dispatches.append({
            "source_body": "0x1809a37ff",
            "index": dispatch_index,
            "target": dispatch_target,
            "advance": advance,
            "next_vip": next_vip,
            "destination": destination,
            "source": source,
        })

    def handler_180a73b12(state: VMState, bc: Bytecode, step: TraceStep) -> None:
        """Complete stack-skip/state/dispatch handler for stub 0x1809d5d81."""
        vip = step.vip
        stack_skip = bc.read(vip + 8, 8)
        if stack_skip % 8:
            raise MissingValue(f"unaligned stack skip {stack_skip}")
        for _ in range(stack_skip // 8):
            state.pop()
        increment_slot = bc.read(vip + 0x0D, 16)
        state.write(increment_slot, 64, state.read(increment_slot, 64) + stack_skip,
                    "handler_180a73b12_slot_add_stack_skip")
        state.write(0x5D, 32, state.read(0x5D, 32) ^ 0x538BA31C,
                    "handler_180a73b12_state_5d_xor")
        state.write(0x0A, 32, state.read(0x0A, 32) ^ 0x538BA31C,
                    "handler_180a73b12_key_xor_constant")
        state.write(0x0A, 32, state.read(0x0A, 32) & bc.read(vip + 0x0F, 32),
                    "handler_180a73b12_key_and_dword_vip_plus_f")
        state.write(0x0A, 32, state.read(0x0A, 32) & bc.read(vip + 0, 32),
                    "handler_180a73b12_key_and_dword_vip_plus_0")
        state.write(0x162, 8, state.read(0x162, 8) ^ 0x0E,
                    "handler_180a73b12_flag_xor_0e")

        dispatch_full = u(
            bc.read(vip + 0x0B, 16) ^ state.read(0x0A, 32) ^ 0x69B83884,
            32,
        )
        dispatch_index = dispatch_full & 0xFFFF
        dispatch_target = bc.read(HANDLER_TABLE + dispatch_index * 8, 64)
        advance = bc.read_signed(vip + 4, 32)
        next_vip = u(vip + advance, 64)
        state.write(0x6D, 64, next_vip, "handler_180a73b12_vip_advance")
        state.dispatches.append({
            "source_body": "0x180a73b12",
            "index": dispatch_index,
            "target": dispatch_target,
            "advance": advance,
            "next_vip": next_vip,
            "stack_skip": stack_skip,
            "increment_slot": increment_slot,
        })

    def handler_180c2ea8b(state: VMState, bc: Bytecode, step: TraceStep) -> None:
        """Decoded per-program semantics for nested wrapper stub 0x18099cfa9.

        The wrapper rebuilds its logical stack frame, executes one inner handler
        selected by the fixed bytecode program, and returns through that inner
        handler's dispatch. Descriptors below are program constants recovered
        from complete instruction traces, while stack values remain live inputs.
        """
        descriptors = {
            0x181546F23: {"bswap_slot": 9,  "inner_index": 0x628, "inner_rva": 0x153990C},
            0x1814EE7D1: {"bswap_slot": 12, "inner_index": 0x147, "inner_rva": 0x14E67B4},
            0x1814E9EF4: {"bswap_slot": 0,  "inner_index": 0x147, "inner_rva": 0x14E6A34},
        }
        desc = descriptors.get(step.vip)
        if desc is None:
            raise MissingValue(f"nested wrapper descriptor for VIP 0x{step.vip:x}")
        top = list(reversed(state.stack))
        if len(top) < 30:
            raise MissingValue("nested wrapper requires at least 30 stack qwords")
        slot = desc["bswap_slot"]
        value32 = top[slot] & 0xFFFFFFFF
        top[slot] = int.from_bytes(value32.to_bytes(4, "little"), "big")
        # Fixed frame transformation observed in all three program instances:
        # duplicate qword 11, drop qword 16, insert inner index and inner VIP RVA.
        output_top = (
            top[:12]
            + [top[11], top[12], top[13], top[14], top[15],
               desc["inner_index"], desc["inner_rva"]]
            + top[17:]
        )
        state.stack = list(reversed(output_top))
        state.rsp_delta -= 16
        state.write(0xC5, 64, state.current_rsp(),
                    "handler_180c2ea8b_stack_frame_pointer")

        inner_vip = IMAGE_BASE + desc["inner_rva"]
        if desc["inner_index"] == 0x628:
            state.write(0x5D, 32, state.read(0x5D, 32) | 0x783EE292,
                        "inner_0x628_state_5d_or")
            state.write(0x0A, 32, state.read(0x0A, 32) - 0x660F5DDB,
                        "inner_0x628_key_sub")
            dispatch_index = bc.read(inner_vip + 0x0E, 16)
            advance = bc.read_signed(inner_vip + 0x12, 32)
        elif desc["inner_index"] == 0x147:
            state.write(0x5D, 32, state.read(0x5D, 32) | 0x44EA80B1,
                        "inner_0x147_state_5d_or")
            dispatch_index = bc.read(inner_vip + 6, 16)
            advance = bc.read_signed(inner_vip + 2, 32)
        else:
            raise MissingValue(f"unsupported nested inner index 0x{desc['inner_index']:x}")
        dispatch_target = bc.read(HANDLER_TABLE + dispatch_index * 8, 64)
        next_vip = u(inner_vip + advance, 64)
        state.write(0x6D, 64, next_vip, "handler_180c2ea8b_inner_vip_advance")
        state.dispatches.append({
            "source_body": "0x180c2ea8b",
            "inner_index": desc["inner_index"],
            "inner_vip": inner_vip,
            "index": dispatch_index,
            "target": dispatch_target,
            "advance": advance,
            "next_vip": next_vip,
            "bswap_slot": slot,
        })

    def handler_1809a57e6(state: VMState, bc: Bytecode, step: TraceStep) -> None:
        """Complete keyed dispatch for stub 0x1809dee32."""
        vip = step.vip
        dispatch_full = u(bc.read(vip + 4, 16) + state.read(0x0A, 32), 32)
        state.write(0x0A, 32, state.read(0x0A, 32) - dispatch_full,
                    "handler_1809a57e6_key_sub_dispatch")
        dispatch_index = dispatch_full & 0xFFFF
        dispatch_target = bc.read(HANDLER_TABLE + dispatch_index * 8, 64)
        advance = bc.read_signed(vip + 0, 32)
        next_vip = u(vip + advance, 64)
        state.write(0x6D, 64, next_vip, "handler_1809a57e6_vip_advance")
        state.dispatches.append({
            "source_body": "0x1809a57e6",
            "index": dispatch_index,
            "target": dispatch_target,
            "advance": advance,
            "next_vip": next_vip,
            "dispatch_full": dispatch_full,
        })


HandlerFn = Callable[[VMState, Bytecode, TraceStep], None]

# Complete handlers only. Partial A/C prefixes are deliberately absent.
TRACE_TARGET_180C02701 = 0x1809A57E1
TRACE_TARGET_180AC2B8C = 0x1809803D9
TRACE_TARGET_1809A4F60 = 0x18098C63D
TRACE_TARGET_180BBE02D = 0x180987ADC
TRACE_TARGET_1809A57E6 = 0x1809DEE32
dispatch_semantics_by_target: dict[int, HandlerFn] = {
    TRACE_TARGET_180C02701: Semantics.handler_180c02701,
    TRACE_TARGET_180AC2B8C: Semantics.handler_180ac2b8c,
    TRACE_TARGET_1809A4F60: Semantics.handler_1809a4f60,
    TRACE_TARGET_180BBE02D: Semantics.handler_180bbe02d,
    TRACE_TARGET_1809A57E6: Semantics.handler_1809a57e6,
    0x18099CFA9: Semantics.handler_180c2ea8b,
    0x1809D5D81: Semantics.handler_180a73b12,
    0x180988D5E: Semantics.handler_1809a37ff,
    0x18098858A: Semantics.handler_180addfc6_step34,
    0x18098B0A7: Semantics.handler_1809ba2f0,
    0x1809819DE: Semantics.handler_180a34e0f,
    0x1809816A2: Semantics.handler_180982798,
    0x180981AC9: Semantics.handler_1809da384,
    0x180981A92: Semantics.handler_180a182e9,
    0x1809AC339: Semantics.handler_180a31591,
    0x1809CEAF1: Semantics.handler_1809d1c98,
    0x1809815B2: Semantics.handler_chain_a,
    0x1809A3B86: Semantics.handler_chain_c,
    0x18098257F: Semantics.handler_chain_b,
    0x18098202A: Semantics.handler_chain_d,
}

TRACE_TARGET_CHAIN_A = 0x1809815B2
TRACE_TARGET_CHAIN_C = 0x1809A3B86
PARTIAL_SEMANTICS_BY_TARGET = {
    TRACE_TARGET_CHAIN_A: "chain_A_pre_stack",
    TRACE_TARGET_CHAIN_C: "chain_C_pre_stack + post_stack_conditional",
}

# None means every VIP instance is implemented. A set means only those fixed
# bytecode-program instances have complete semantics so far.
PROGRAM_VIP_SUPPORT: dict[int, set[int] | None] = {
    target: None for target in dispatch_semantics_by_target
}
PROGRAM_VIP_SUPPORT[0x18099CFA9] = {0x181546F23, 0x1814EE7D1, 0x1814E9EF4}
PROGRAM_VIP_SUPPORT[0x18098858A] = {0x1814F1745}
# Experimental static lift exists, but dynamic snapshots show unresolved
# context-side effects. Keep every instance fail-closed until corrected.
PROGRAM_VIP_SUPPORT[0x1809819DE] = set()


def step_has_complete_semantics(step: TraceStep) -> bool:
    if step.target not in dispatch_semantics_by_target:
        return False
    supported = PROGRAM_VIP_SUPPORT.get(step.target)
    return supported is None or step.vip in supported


def load_trace(path: Path) -> list[TraceStep]:
    return [TraceStep.from_json(x) for x in json.loads(path.read_text("utf-8"))]


def unsupported_diagnostic(step_index: int, step: TraceStep, bc: Bytecode) -> dict:
    body = bc.resolve_direct_jump(step.target)
    return {
        "step_index": step_index,
        "instr": step.instr,
        "source": hex(step.source),
        "target": hex(step.target),
        "vip": hex(step.vip),
        "key": hex(step.key),
        "handler_body": hex(body) if body is not None else None,
        "partial_semantics": PARTIAL_SEMANTICS_BY_TARGET.get(step.target),
    }


def execute_trace_program(
    trace: list[TraceStep], state: VMState, bc: Bytecode,
    handlers: dict[int, HandlerFn] | None = None, max_steps: int | None = None,
) -> dict:
    """Execute complete registered handlers with trace synchronization checks."""
    handlers = dispatch_semantics_by_target if handlers is None else handlers
    stop = len(trace) if max_steps is None else min(len(trace), max_steps)
    for step_index, step in enumerate(trace[:stop]):
        entry_vip = state.read(0x6D, 64)
        entry_key = state.read(0x0A, 32)
        if entry_vip != step.vip or entry_key != step.key:
            raise TraceMismatch({
                "kind": "entry_state",
                "step_index": step_index,
                "expected_vip": hex(step.vip), "actual_vip": hex(entry_vip),
                "expected_key": hex(step.key), "actual_key": hex(entry_key),
            })
        handler = handlers.get(step.target)
        if handler is None or (
            handlers is dispatch_semantics_by_target and not step_has_complete_semantics(step)
        ):
            raise UnsupportedHandler(unsupported_diagnostic(step_index, step, bc))
        dispatch_count_before = len(state.dispatches)
        handler(state, bc, step)
        if step_index + 1 < len(trace):
            following = trace[step_index + 1]
            next_vip = state.read(0x6D, 64)
            next_key = state.read(0x0A, 32)
            if next_vip != following.vip or next_key != following.key:
                raise TraceMismatch({
                    "kind": "exit_state",
                    "step_index": step_index,
                    "expected_next_vip": hex(following.vip), "actual_next_vip": hex(next_vip),
                    "expected_next_key": hex(following.key), "actual_next_key": hex(next_key),
                })
            if len(state.dispatches) > dispatch_count_before:
                actual_target = state.dispatches[-1]["target"]
                if actual_target != following.target:
                    raise TraceMismatch({
                        "kind": "dispatch_target",
                        "step_index": step_index,
                        "expected_target": hex(following.target),
                        "actual_target": hex(actual_target),
                    })
    return {
        "executed_steps": stop,
        "writes": len(state.writes),
        "dispatches": len(state.dispatches),
    }


def probe_trace_executor(trace: list[TraceStep], bc: Bytecode, state: VMState | None = None) -> dict:
    try:
        result = execute_trace_program(trace, VMState() if state is None else state, bc)
    except UnsupportedHandler as exc:
        return {"status": "unsupported", "first_unsupported": exc.diagnostic}
    except TraceMismatch as exc:
        return {"status": "trace_mismatch", "mismatch": exc.diagnostic}
    except MissingValue as exc:
        return {"status": "missing_value", "error": str(exc)}
    return {"status": "complete", **result}


def state_from_jump_snapshot(item: dict) -> VMState:
    context = bytes.fromhex(item["context_hex"])
    if len(context) > CTX_SIZE:
        raise ValueError(f"snapshot context is {len(context)} bytes, exceeds CTX_SIZE")
    stack_bytes = bytes.fromhex(item["stack_top_hex"])
    if len(stack_bytes) % 8:
        raise ValueError("stack snapshot length is not qword aligned")
    qwords_top_first = list(struct.unpack(f"<{len(stack_bytes) // 8}Q", stack_bytes))
    state = VMState(
        context=bytearray(context + b"\0" * (CTX_SIZE - len(context))),
        stack=list(reversed(qwords_top_first)),
        registers={
            name: int(value, 16)
            for name, value in item.get("registers", {}).items()
        },
    )
    return state


def snapshot_trace_step(item: dict) -> TraceStep:
    return TraceStep(
        int(item["instruction"]), int(item["source"], 16),
        int(item["target"], 16), int(item["key_low32"], 16),
        int(item["vip"], 16),
    )


def validate_registered_handlers_against_snapshots(items: list[dict], bc: Bytecode) -> dict:
    """Replay every captured occurrence of each complete registered handler."""
    counts: dict[str, int] = {}
    failures: list[dict] = []
    skipped_instances: dict[str, int] = {}
    for index in range(len(items) - 1):
        before = items[index]
        after = items[index + 1]
        target = int(before["target"], 16)
        handler = dispatch_semantics_by_target.get(target)
        if handler is None:
            continue
        step = snapshot_trace_step(before)
        if not step_has_complete_semantics(step):
            key = hex(target)
            skipped_instances[key] = skipped_instances.get(key, 0) + 1
            continue
        state = state_from_jump_snapshot(before)
        initial_stack_len = len(state.stack)
        state.writes.clear()
        try:
            handler(state, bc, step)
        except Exception as exc:
            failures.append({
                "snapshot_index": index, "target": hex(target),
                "kind": "exception", "error": repr(exc),
            })
            continue
        expected_context = bytes.fromhex(after["context_hex"])
        expected_stack = list(struct.unpack(
            f"<{len(bytes.fromhex(after['stack_top_hex'])) // 8}Q",
            bytes.fromhex(after["stack_top_hex"]),
        ))
        # A snapshot only gives N qwords starting at the old RSP. After pops,
        # deeper newly exposed qwords were never captured, so compare exactly
        # the still-known overlap instead of treating unknown tail data as a
        # mismatch. After pushes, the top N qwords remain fully known.
        known_stack_count = min(len(state.stack), len(expected_stack))
        actual_stack = list(reversed(state.stack[-known_stack_count:]))
        expected_known_stack = expected_stack[:known_stack_count]
        actual_rsp_delta = state.rsp_delta
        checks = {
            "context": bytes(state.context[:len(expected_context)]) == expected_context,
            "stack": actual_stack == expected_known_stack,
            "rsp_delta": int(after["rsp"], 16) - int(before["rsp"], 16) == actual_rsp_delta,
            "target": bool(state.dispatches)
                      and state.dispatches[-1]["target"] == int(after["target"], 16),
            "vip": state.read(0x6D, 64) == int(after["vip"], 16),
            "key": state.read(0x0A, 32) == int(after["key_low32"], 16),
        }
        if not all(checks.values()):
            failures.append({
                "snapshot_index": index, "target": hex(target),
                "kind": "mismatch", "checks": checks,
            })
        key = hex(target)
        counts[key] = counts.get(key, 0) + 1
    return {
        "validated_occurrences": sum(counts.values()),
        "per_target": counts,
        "failures": failures,
        "skipped_unimplemented_instances": skipped_instances,
        "all_match": not failures,
    }


def snapshot_state_for_trace_start(
    items: list[dict], trace: list[TraceStep]
) -> VMState:
    first_instruction = trace[0].instr
    for item in items:
        if int(item["instruction"]) == first_instruction:
            return state_from_jump_snapshot(item)
    raise MissingValue(f"no VM jump snapshot for trace instruction {first_instruction}")


def make_first_handler_fixture(trace: list[TraceStep], bc: Bytecode) -> VMState:
    """Construct a bounded fixture for step 0 while preserving real VIP/key.

    Only ctx+0xe5/f6/5d/162 and two referenced qwords are synthetic. The
    handler's next key, VIP and target are independent of those choices and are
    checked against trace step 1.
    """
    step = trace[0]
    if step.target != TRACE_TARGET_180C02701:
        raise ValueError("trace step 0 is not target 0x1809a57e1")
    state = VMState()
    state.write(0x0A, 32, step.key, "fixture_entry_key")
    state.write(0x6D, 64, step.vip, "fixture_entry_vip")
    state.write(0xF6, 32, 0, "fixture_f6")
    state.write(0x5D, 32, 0x12345678, "fixture_state_5d")
    state.write(0x162, 8, 0x41, "fixture_flag")
    transformed = u((bc.read(step.vip + 4, 16) ^ step.key), 32)
    desired_push_offset = 0x180
    post_sub_e5 = u(desired_push_offset - 0x79FC, 16)
    state.write(0xE5, 16, post_sub_e5 + transformed, "fixture_e5_for_bounded_push")
    state.write(desired_push_offset, 64, 0x1122334455667788, "fixture_push_source")
    slot = bc.read(step.vip + 6, 16)
    state.write(slot, 64, 0x8877665544332211, "fixture_vip_plus_6_slot")
    state.writes.clear()
    return state


def audit_registered_trace_coverage(trace: list[TraceStep]) -> dict:
    per_target: dict[str, int] = {}
    covered = 0
    distinct_all = {step.target for step in trace}
    for step in trace:
        if step_has_complete_semantics(step):
            covered += 1
            key = hex(step.target)
            per_target[key] = per_target.get(key, 0) + 1
    return {
        "covered_steps": covered,
        "total_steps": len(trace),
        "coverage_percent": covered * 100.0 / len(trace) if trace else 0.0,
        "covered_distinct_targets": len(per_target),
        "total_distinct_targets": len(distinct_all),
        "per_target": per_target,
    }


def audit_trace_semantics(trace: list[TraceStep], bc: Bytecode) -> dict:
    chain_a = []
    chain_c = []
    labels = list(range(CTX_SIZE))
    for step in trace:
        if step.target == TRACE_TARGET_CHAIN_A:
            op = Semantics.chain_a_operands(bc, step.vip)
            pairs = [
                (op["swap_1_a"], op["swap_1_b"]),
                (op["swap_2_a"], op["swap_2_b"]),
            ]
            valid = all(a + 8 <= CTX_SIZE and b + 8 <= CTX_SIZE for a, b in pairs)
            chain_a.append({
                "instr": step.instr, "vip": step.vip, **op,
                "all_swaps_in_context": valid,
            })
            if valid:
                for a, b in pairs:
                    for i in range(8):
                        labels[a + i], labels[b + i] = labels[b + i], labels[a + i]
        elif step.target == TRACE_TARGET_CHAIN_C:
            chain_c.append({
                "instr": step.instr, "vip": step.vip, "key": step.key,
                "raw_word_vip_plus_6": Semantics.chain_c_operand(bc, step.vip),
            })
    valid_a = [x for x in chain_a if x["all_swaps_in_context"]]
    moved = [i for i, original in enumerate(labels) if i != original]
    moved_ranges = []
    if moved:
        start = prev = moved[0]
        for value in moved[1:]:
            if value != prev + 1:
                moved_ranges.append((start, prev))
                start = value
            prev = value
        moved_ranges.append((start, prev))
    return {
        "chain_A_steps": len(chain_a),
        "chain_A_all_two_swaps_context_indexed": len(valid_a),
        "chain_A_swap_operations": len(chain_a) * 2,
        "chain_A_examples": [
            {
                "instr": x["instr"], "vip": hex(x["vip"]),
                "swap_1": [hex(x["swap_1_a"]), hex(x["swap_1_b"])],
                "swap_2": [hex(x["swap_2_a"]), hex(x["swap_2_b"])],
                "raw_word_vip_plus_0x14": hex(x["raw_word"]),
            }
            for x in chain_a[:8]
        ],
        "chain_A_two_swap_permutation": {
            "is_bijection": len(set(labels)) == CTX_SIZE,
            "moved_bytes": len(moved),
            "moved_ranges": [
                {"start": hex(a), "end": hex(b), "bytes": b - a + 1}
                for a, b in moved_ranges
            ],
            "destination_to_source": [hex(x) for x in labels],
        },
        "chain_C_steps": len(chain_c),
        "chain_C_examples": [
            {
                "instr": x["instr"], "vip": hex(x["vip"]),
                "key": hex(x["key"]),
                "raw_word_vip_plus_6": hex(x["raw_word_vip_plus_6"]),
            }
            for x in chain_c[:8]
        ],
    }


def self_test(
    bc: Bytecode | None = None, trace: list[TraceStep] | None = None,
    jump_snapshots: list[dict] | None = None,
) -> dict:
    # Stack swap behavior.
    s = VMState()
    s.write(0x20, 64, 0x1111222233334444, "fixture")
    s.write(0x40, 64, 0xAAAABBBBCCCCDDDD, "fixture")
    s.writes.clear()
    s.swap_slots_via_stack(0x20, 0x40)
    assert s.read(0x20, 64) == 0xAAAABBBBCCCCDDDD
    assert s.read(0x40, 64) == 0x1111222233334444
    assert not s.stack

    # Chain A state prefix, including f6 fold and ctx+0x162 branch.
    s = VMState()
    s.write(0xE5, 16, 0x1000, "fixture")
    s.write(0x0A, 32, 0x12345678, "fixture")
    s.write(0xF6, 32, 0x0F0F0F0F, "fixture")
    s.write(0x162, 8, 0x30, "fixture")
    s.writes.clear()
    a = Semantics.chain_a_state_prefix(s, 0x20)
    a_mix = 0x20 ^ 0x0F0F0F0F
    assert a["transformed_word"] == a_mix
    assert s.read(0xE5, 16) == u(0x1000 - a_mix, 16)
    assert s.read(0x0A, 32) == (u(0x12345678 + a_mix, 32) | 0x33A09506)

    # Chain C uses a real trace word and exact pre-pop transformations.
    real_chain_c = "not-run"
    if bc is not None:
        vip_c = 0x1814EBD29
        raw_c = Semantics.chain_c_operand(bc, vip_c)
        assert raw_c == 0xD425
        s = VMState()
        s.write(0xE5, 16, 0x1000, "fixture")
        s.write(0x0A, 32, 0x12345678, "fixture")
        s.write(0x5D, 32, 0xCAFEBABE, "fixture")
        s.write(0x162, 8, 0xFA, "fixture")
        s.writes.clear()
        c = Semantics.chain_c_pre_stack(s, raw_c)
        assert c["transformed_word"] == 0x1234825D
        assert not c["ctx_162_gt_0xfa"]
        assert s.read(0xE5, 16) == 0x925D
        assert s.read(0x0A, 32) == 0xC474F7EE
        assert s.read(0x5D, 32) == 0x9F74D8E4
        assert not Semantics.chain_c_post_stack_conditional(s)

        # High branch: subtract constant before the low-16 e5 add; odd post-XOR
        # ctx+0x5d takes the later conditional add.
        s = VMState()
        s.write(0xE5, 16, 0x1000, "fixture")
        s.write(0x0A, 32, 0x12345678, "fixture")
        s.write(0x5D, 32, 0xCAFEBABF, "fixture")
        s.write(0x162, 8, 0xFB, "fixture")
        s.writes.clear()
        c = Semantics.chain_c_pre_stack(s, raw_c)
        assert c["transformed_word"] == 0xAA191D85
        assert c["ctx_162_gt_0xfa"]
        assert s.read(0xE5, 16) == 0x2D85
        assert Semantics.chain_c_post_stack_conditional(s)
        assert s.read(0x5D, 32) == 0x0A31EA20
        real_chain_c = "pass"

    # Fail closed on absent stack data.
    try:
        VMState().pop()
    except MissingValue:
        stack_fail_closed = True
    else:
        stack_fail_closed = False
    assert stack_fail_closed

    real_chain_a = "not-run"
    if bc is not None:
        vip_a = 0x1814EC9AB
        op = Semantics.chain_a_operands(bc, vip_a)
        assert op == {
            "swap_1_a": 0x106, "swap_1_b": 0x0BD,
            "swap_2_a": 0x0B5, "swap_2_b": 0x106,
            "raw_word": 0xDAE8,
        }
        s = VMState()
        s.write(0x106, 64, 0x1111111111111111, "fixture_real_trace")
        s.write(0x0BD, 64, 0x2222222222222222, "fixture_real_trace")
        s.write(0x0B5, 64, 0x3333333333333333, "fixture_real_trace")
        s.write(0xE5, 16, 0x1000, "fixture_real_trace")
        s.write(0x0A, 32, 0x12345678, "fixture_real_trace")
        s.write(0xF6, 32, 0, "fixture_real_trace")
        s.write(0x162, 8, 0, "fixture_real_trace")
        s.writes.clear()
        Semantics.chain_a_pre_stack(s, bc, vip_a)
        assert s.read(0x0BD, 64) == 0x1111111111111111
        assert s.read(0x0B5, 64) == 0x2222222222222222
        assert s.read(0x106, 64) == 0x3333333333333333
        assert not s.stack
        real_chain_a = "pass"

    handler_180c02701 = "not-run"
    handler_180ac2b8c = "not-run"
    snapshot_validation = "not-run"
    executor_fail_closed = "not-run"
    if bc is not None and trace and len(trace) >= 3:
        fixture = make_first_handler_fixture(trace, bc)
        initial_slot = fixture.read(bc.read(trace[0].vip + 6, 16), 64)
        result = execute_trace_program(trace[:3], fixture, bc, max_steps=2)
        assert result["executed_steps"] == 2
        assert fixture.read(0x0A, 32) == trace[2].key
        assert fixture.read(0x6D, 64) == trace[2].vip
        assert fixture.dispatches[0]["target"] == trace[1].target
        assert fixture.dispatches[0]["index"] == 0x309
        assert fixture.dispatches[0]["push_offset"] == 0x180
        assert fixture.dispatches[1]["target"] == trace[2].target
        assert fixture.dispatches[1]["index"] == 0x5D5
        assert fixture.stack[-2] == 0x1122334455667788
        slot = bc.read(trace[0].vip + 6, 16)
        assert fixture.read(slot, 64) == u(initial_slot - 16, 64)
        handler_180c02701 = "pass"
        handler_180ac2b8c = "pass"

    if bc is not None and trace and jump_snapshots:
        validation = validate_registered_handlers_against_snapshots(jump_snapshots, bc)
        assert validation["all_match"]
        assert validation["validated_occurrences"] >= 2
        snapshot_validation = f"pass ({validation['validated_occurrences']})"
        probe = probe_trace_executor(
            trace, bc, snapshot_state_for_trace_start(jump_snapshots, trace)
        )
        first = probe["first_unsupported"]
        assert probe["status"] == "unsupported"
        assert first["step_index"] == 36
        assert first["target"] == "0x1809819de"
        assert first["handler_body"] == "0x180a34e0f"
        executor_fail_closed = "pass"

    return {
        "slot_swap": "pass",
        "chain_A_pre_stack": "pass",
        "chain_C_real_trace_vip_plus_6": real_chain_c,
        "missing_stack_fails_closed": "pass",
        "real_trace_chain_A_two_swaps": real_chain_a,
        "handler_180c02701_trace_sync": handler_180c02701,
        "handler_180ac2b8c_trace_sync": handler_180ac2b8c,
        "handler_1809a4f60_snapshot_sync": snapshot_validation,
        "snapshot_occurrence_validation": snapshot_validation,
        "trace_executor_next_unsupported": executor_fail_closed,
    }


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--trace", type=Path, default=HERE / "vm_handler_execution_trace.json")
    ap.add_argument("--bugland", type=Path, default=HERE / "runtime_bugland2.bin")
    ap.add_argument("--self-test", action="store_true")
    ap.add_argument("--execute", action="store_true",
                    help="probe the fail-closed trace executor")
    ap.add_argument("--max-steps", type=int)
    ap.add_argument(
        "--jump-snapshots", type=Path,
        default=HERE / "encrypt_vm_jump_snapshots_700k.json",
    )
    args = ap.parse_args()

    trace = load_trace(args.trace)
    bc = Bytecode(args.bugland.read_bytes())
    jump_snapshots = []
    if args.jump_snapshots.exists():
        jump_snapshots = json.loads(
            args.jump_snapshots.read_text("utf-8")
        ).get("vm_indirect_jumps", [])
    first_word = bc.read(trace[0].vip, 16)
    output = {
        "self_test": self_test(bc, trace, jump_snapshots),
        "trace_semantics_audit": audit_trace_semantics(trace, bc),
        "registered_trace_coverage": audit_registered_trace_coverage(trace),
        "trace_executor_probe": probe_trace_executor(
            trace, bc,
            snapshot_state_for_trace_start(jump_snapshots, trace)
            if jump_snapshots else make_first_handler_fixture(trace, bc),
        ),
        "snapshot_validation": (
            validate_registered_handlers_against_snapshots(jump_snapshots, bc)
            if jump_snapshots else {"status": "not-run"}
        ),
        "trace_steps": len(trace),
        "first_step": {
            "vip": hex(trace[0].vip), "key": hex(trace[0].key),
            "target": hex(trace[0].target), "word_at_vip": hex(first_word),
        },
        "semantic_notes": [
            "chain_A/B/C/D complete handlers are snapshot-validated",
            "chain_A and chain_C prefix helpers remain available for unit tests",
        ],
        "complete_handler_targets": [hex(x) for x in dispatch_semantics_by_target],
        "status": "incremental; trace executor fail-closed; not a keystream implementation",
    }
    if args.execute:
        try:
            output["trace_execution"] = execute_trace_program(
                trace,
                snapshot_state_for_trace_start(jump_snapshots, trace)
                if jump_snapshots else make_first_handler_fixture(trace, bc),
                bc, max_steps=args.max_steps
            )
        except UnsupportedHandler as exc:
            output["trace_execution"] = {
                "status": "unsupported", "first_unsupported": exc.diagnostic,
            }
        except TraceMismatch as exc:
            output["trace_execution"] = {
                "status": "trace_mismatch", "mismatch": exc.diagnostic,
            }
        except MissingValue as exc:
            output["trace_execution"] = {
                "status": "missing_value", "error": str(exc),
            }
    print(json.dumps(output, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
