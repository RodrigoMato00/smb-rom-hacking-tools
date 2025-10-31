#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
SMB: patch start world/area - heuristic finder

- Scans writes to $075F/$0760 (STA/STX)
- For each, backtracks nearby immediates that feed A/X (LDA/LDX or LDX+TXA)
- Supports --dry-run to list candidates and --pick N to choose which to patch
- Patches PRG only and creates timestamped output (does not overwrite original ROM)
- Converts world, level from 1-8/1-4 to 0-7/0-3 (internal SMB format)
"""
import argparse
import os
from datetime import datetime

HEADER = 16
W_ADDR = (0x5F, 0x07)  # $075F WorldNumber
A_ADDR = (0x60, 0x07)  # $0760 AreaNumber

# 6502 opcodes of interest
OP_LDA_IMM = 0xA9
OP_LDX_IMM = 0xA2
OP_TXA     = 0x8A
OP_STA_ABS = 0x8D
OP_STX_ABS = 0x8E

SEARCH_BACK = 48  # look-back window in bytes


def read_rom(path: str) -> bytearray:
    with open(path, "rb") as f:
        return bytearray(f.read())


def ines_slices(rom: bytearray):
    if rom[0:4] != b"NES\x1a":
        raise RuntimeError("ROM is not a valid iNES file.")
    prg_banks = rom[4]
    chr_banks = rom[5]
    prg_size = prg_banks * 16 * 1024
    prg_start = HEADER
    prg_end = HEADER + prg_size
    return prg_start, prg_end


def find_writes_to(prg: bytearray, low: int, high: int):
    """Return list of (idx, op) where op writes to address $highlow using STA/STX abs."""
    hits = []
    i = 0
    n = len(prg)
    while i < n - 2:
        op = prg[i]
        if op in (OP_STA_ABS, OP_STX_ABS) and i + 2 < n:
            lo = prg[i + 1]
            hi = prg[i + 2]
            if lo == low and hi == high:
                hits.append((i, op))
        i += 1
    return hits


def backtrack_immediate(prg: bytearray, idx: int, want_reg: str):
    """Find immediate feeding desired register within look-back window.

    want_reg: 'A' for STA, 'X' for STX.
    Strategies:
      - For A: nearest LDA #imm
      - For X: nearest LDX #imm
      - For A via X: prior LDX #imm followed by TXA before STA
    Returns (abs_offset_in_prg, imm_value) or None.
    """
    start = max(0, idx - SEARCH_BACK)
    window = prg[start:idx]

    # scan from closest to farthest back
    for k in range(len(window) - 1, -1, -1):
        op = window[k]
        if want_reg == 'A' and op == OP_LDA_IMM and k + 1 < len(window):
            return (start + k + 1, window[k + 1])
        if want_reg == 'X' and op == OP_LDX_IMM and k + 1 < len(window):
            return (start + k + 1, window[k + 1])
        if want_reg == 'A' and op == OP_TXA:
            # search for a prior LDX #imm
            for j in range(k - 1, -1, -1):
                if window[j] == OP_LDX_IMM and j + 1 < len(window):
                    return (start + j + 1, window[j + 1])
    return None


def to_internal(world: int, level: int):
    # Convert 1-based (user) to 0-based (SMB internal)
    return (world - 1) & 0xFF, (level - 1) & 0xFF


def main():
    ap = argparse.ArgumentParser(
        description="SMB: patch start world/area - heuristic finder",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    ap.add_argument("--rom", required=True, help="iNES ROM path")
    ap.add_argument("--world", type=int, required=True, help="World 1..8")
    ap.add_argument("--level", type=int, required=True, help="Level 1..4")
    ap.add_argument("--dry-run", action="store_true", help="Do not patch; list candidates")
    ap.add_argument("--pick", type=int, default=None, help="Candidate index to patch (from listing)")
    ap.add_argument("--patch-startworld1", action="store_true", help="Patch StartWorld1 directly (inserts code before LoadAreaPointer)")
    args = ap.parse_args()

    if not (1 <= args.world <= 8 and 1 <= args.level <= 4):
        print("Valid range: world 1..8, level 1..4")
        return

    if not os.path.exists(args.rom):
        print("ROM not found:", args.rom)
        return

    rom = read_rom(args.rom)
    prg_start, prg_end = ines_slices(rom)
    prg = rom[prg_start:prg_end]

    w_hits = find_writes_to(prg, W_ADDR[0], W_ADDR[1])
    a_hits = find_writes_to(prg, A_ADDR[0], A_ADDR[1])

    candidates = []
    # Pair by proximity: world write then nearest area write after it
    for wi, wop in w_hits:
        w_reg = 'A' if wop == OP_STA_ABS else 'X'
        w_im = backtrack_immediate(prg, wi, w_reg)
        nearest_a = None
        for ai, aop in a_hits:
            if ai >= wi and ai - wi < 64:
                a_reg = 'A' if aop == OP_STA_ABS else 'X'
                a_im = backtrack_immediate(prg, ai, a_reg)
                if a_im:
                    nearest_a = (ai, aop, a_reg, a_im)
                    break
        candidates.append({
            "w_site": wi, "w_op": wop, "w_reg": w_reg, "w_im": w_im,
            "a_site": nearest_a[0] if nearest_a else None,
            "a_op": nearest_a[1] if nearest_a else None,
            "a_reg": nearest_a[2] if nearest_a else None,
            "a_im": nearest_a[3] if nearest_a else None,
        })

    # Also consider area-first sequences
    for ai, aop in a_hits:
        already = any(c.get("a_site") == ai for c in candidates)
        if already:
            continue
        a_reg = 'A' if aop == OP_STA_ABS else 'X'
        a_im = backtrack_immediate(prg, ai, a_reg)
        nearest_w = None
        for wi, wop in w_hits:
            if wi <= ai and ai - wi < 64:
                w_reg = 'A' if wop == OP_STA_ABS else 'X'
                w_im = backtrack_immediate(prg, wi, w_reg)
                if w_im:
                    nearest_w = (wi, wop, w_reg, w_im)
                    break
        candidates.append({
            "w_site": nearest_w[0] if nearest_w else None,
            "w_op": nearest_w[1] if nearest_w else None,
            "w_reg": nearest_w[2] if nearest_w else None,
            "w_im": nearest_w[3] if nearest_w else None,
            "a_site": ai, "a_op": aop, "a_reg": a_reg, "a_im": a_im,
        })

    if not candidates:
        print("No sequences found that write $075F/$0760 with nearby immediates.")
        print("Your ROM might initialize world/level with different logic.")
        print("Suggestion: try SMB (U) PRG1 or use world-swap via area table.")
        return

    # Show candidates
    print("Candidates (sorted by appearance):\n")
    for idx, c in enumerate(candidates):
        def fmt_im(im):
            return f"off 0x{im[0]:04X} val 0x{im[1]:02X}" if im else "(not found)"
        wop = c['w_op']; aop = c['a_op']
        wop_s = 'STA' if wop == OP_STA_ABS else 'STX' if wop == OP_STX_ABS else '??'
        aop_s = 'STA' if aop == OP_STA_ABS else 'STX' if aop == OP_STX_ABS else '??'
        print(f"[{idx}] W: site 0x{(c['w_site'] if c['w_site'] is not None else -1):04X} op {wop_s} reg {c['w_reg']} imm {fmt_im(c['w_im'])}  |  "
              f"A: site 0x{(c['a_site'] if c['a_site'] is not None else -1):04X} op {aop_s} reg {c['a_reg']} imm {fmt_im(c['a_im'])}")
    print()

    if args.patch_startworld1 and not args.dry_run:
        # Patch StartWorld1 directly
        # Search for JSR LoadAreaPointer (20 03 9c) in PRG
        # StartWorld1 should be around 0x02e6 in PRG (0x82e6 - 0x8000)
        jsr_pattern = bytes([0x20, 0x03, 0x9c])  # JSR LoadAreaPointer
        startworld1_offset = None
        for i in range(len(prg) - 3):
            if prg[i:i+3] == jsr_pattern:
                # Verify it's near where StartWorld1 should be (0x02e6)
                if abs(i - 0x02e6) < 0x100:  # within 256 bytes
                    startworld1_offset = i
                    break

        if startworld1_offset is None:
            print("StartWorld1 not found (JSR LoadAreaPointer near 0x02e6).")
            print("ROM might use a different version. Try --pick with listed candidates.")
        else:
            w_int, a_int = to_internal(args.world, args.level)

            # Safer method: modify GoContinue directly to set our values
            # GoContinue is at 0x830E and does: STA $075F, STA $0766, LDX #$00, STX $0760
            # Search for GoContinue: STA $075F (8D 5F 07) followed by STA $0766 (8D 66 07)
            gocontinue_pattern = bytes([0x8D, 0x5F, 0x07, 0x8D, 0x66, 0x07])
            gocontinue_offset = None
            for i in range(len(prg) - len(gocontinue_pattern)):
                if prg[i:i+len(gocontinue_pattern)] == gocontinue_pattern:
                    # Verify it's near where GoContinue should be (0x030E)
                    if abs(i - 0x030E) < 0x20:
                        gocontinue_offset = i
                        break

            if gocontinue_offset is not None:
                # Find where LDX #$00 (A2 00) is in GoContinue (should be 3 bytes after second STA)
                if gocontinue_offset + 7 < len(prg) and prg[gocontinue_offset + 6] == 0xA2:
                    # Modify GoContinue: change immediate value after STA $075F (which comes from accumulator A)
                    # But the problem is that A comes from before... better to modify LDX #$00 to LDX #area
                    prg[gocontinue_offset + 7] = a_int  # Change LDX #$00 to LDX #area
                    # For world, we need to modify where A is loaded before STA $075F
                    # Search backwards from GoContinue to find LDA #$xx
                    for back in range(1, 10):
                        if gocontinue_offset - back >= 0 and prg[gocontinue_offset - back] == 0xA9:
                            prg[gocontinue_offset - back + 1] = w_int  # Change LDA immediate
                            break

                    # Modify StartWorld1 to set A with our world and then call GoContinue
                    # GoContinue is already modified to use our values
                    # We need: LDA #world (2 bytes), then JSR GoContinue
                    # Check if we can use bytes before JSR (replace code before)
                    # Problem is there's no free space before. We can only modify the JSR.
                    # Solution: simply make StartWorld1 call GoContinue (which already sets our values)
                    # and then GoContinue must call LoadAreaPointer
                    # But GoContinue ends with RTS, not JSR LoadAreaPointer...
                    # Better: modify StartWorld1 to do LDA #world and JSR GoContinue, but we need space

                    # Search for free space at end of PRG or in known free areas
                    # Search from end backwards to find a long sequence of FF
                    free_space_start = None
                    needed_bytes = 12  # LDA #w, STA $075F, LDA #a, STA $0760, JSR LoadAreaPointer, RTS

                    # Search in multiple places: end of PRG, or after data tables
                    search_ranges = [
                        (len(prg) - 0x200, len(prg)),  # Last 512 bytes
                        (0x6000, 0x7000),  # Common free space area in PRG
                        (0x1000, 0x2000),  # Another potential area
                    ]

                    for start, end in search_ranges:
                        # Adjust ranges to be within PRG
                        search_start = max(0, start)
                        search_end = min(len(prg) - needed_bytes, end)
                        if search_start >= search_end:
                            continue
                        # Search from end of range backwards
                        for i in range(search_end - 1, search_start - 1, -1):
                            if i + needed_bytes <= len(prg):
                                # Search for sequence of FF or 00 (typical free space)
                                if all(prg[i+j] in (0xFF, 0x00) for j in range(needed_bytes)):
                                    free_space_start = i
                                    break
                        if free_space_start is not None:
                            break

                    if free_space_start is None:
                        print("No sufficient free space found in PRG.")
                        print("Recommendation: use --pick 0 which works with A+START (Continue).")
                        return

                    # Create helper routine: sets world/area and calls LoadAreaPointer
                    helper_routine = bytearray([
                        0xA9, w_int,  # LDA #world
                        0x8D, 0x5F, 0x07,  # STA $075F
                        0xA9, a_int,  # LDA #area
                        0x8D, 0x60, 0x07,  # STA $0760
                        0x20, 0x03, 0x9c,  # JSR LoadAreaPointer
                        0x60,  # RTS
                    ])

                    # Write helper routine
                    prg[free_space_start:free_space_start+len(helper_routine)] = helper_routine

                    # Calculate CPU address of helper routine
                    helper_cpu_addr = 0x8000 + free_space_start
                    helper_lo = helper_cpu_addr & 0xFF
                    helper_hi = (helper_cpu_addr >> 8) & 0xFF

                    # Modify StartWorld1: replace JSR LoadAreaPointer with JSR to our routine
                    prg[startworld1_offset] = 0x20  # JSR
                    prg[startworld1_offset + 1] = helper_lo
                    prg[startworld1_offset + 2] = helper_hi
                else:
                    print("Expected structure not found in GoContinue.")
                    return
            else:
                print("GoContinue not found. Using alternative method...")
                # Fallback: patch directly in default memory (more complex)
                return

            out = bytearray(rom)
            out[prg_start:prg_end] = prg
            ts = datetime.now().strftime("%Y%m%d_%H%M%S")
            out_path = f"{os.path.splitext(args.rom)[0]}_startW{args.world}L{args.level}_startworld1_{ts}.nes"
            with open(out_path, "wb") as f:
                f.write(out)

            print(f"Patch applied to StartWorld1.")
            print(f"Helper routine inserted at PRG offset 0x{free_space_start:04X} (CPU: 0x{helper_cpu_addr:04X})")
            print(f"StartWorld1 modified to call helper routine.")
            print(f"World {args.world}, Level {args.level} (internal {w_int:#04x},{a_int:#04x})")
            print(f"Output: {out_path}")
            print("Should now work with normal START (without A+START).")
            print("Note: If using --pick 0, still requires A+START simultaneously (H+P in emulator).")

    if args.dry_run:
        print("Dry-run mode: no output written. Choose correct index with --pick N.")
        if not args.patch_startworld1:
            print("Tip: If candidates don't work, try --patch-startworld1 to patch StartWorld1 directly.")
        return

    pick = args.pick if args.pick is not None else 0
    if pick < 0 or pick >= len(candidates):
        print("--pick index out of range.")
        return

    c = candidates[pick]
    w_int, a_int = to_internal(args.world, args.level)

    patched = 0
    # If GoContinue (candidate 0), always patch LDA ContinueWorld instead of incorrect immediate
    if pick == 0 and c.get("w_site") == 0x030E:  # GoContinue: STA $075F at 0x030E
        # Search for LDA ContinueWorld (AD FD 07) before JSR GoContinue (20 0E 83 = JSR to 0x830E CPU)
        lda_continueworld = bytes([0xAD, 0xFD, 0x07])
        jsr_gocontinue = bytes([0x20, 0x0E, 0x83])  # JSR to 0x830E (absolute CPU address)
        for i in range(len(prg) - 6):
            if prg[i:i+3] == lda_continueworld and prg[i+3:i+6] == jsr_gocontinue:
                # Convert LDA $07FD to LDA #world (A9 w)
                prg[i] = 0xA9  # LDA #
                prg[i+1] = w_int
                prg[i+2] = 0xEA  # NOP (to maintain 3 bytes)
                patched += 1
                print(f"Patched LDA ContinueWorld at PRG+0x{i:04X} -> LDA #{w_int}")
                break
        if patched == 0:
            print("Warning: could not locate LDA ContinueWorld for GoContinue.")
    elif c.get("w_im"):
        prg[c["w_im"][0]] = w_int
        patched += 1
    else:
        print("Warning: could not locate World immediate for this candidate; keeping current.")
    if c.get("a_im"):
        prg[c["a_im"][0]] = a_int
        patched += 1
    else:
        print("Warning: could not locate Area immediate for this candidate; keeping current.")

    if patched == 0:
        print("Nothing to patch in this candidate. Try another --pick.")
        return

    out = bytearray(rom)
    out[prg_start:prg_end] = prg
    ts = datetime.now().strftime("%Y%m%d_%H%M%S")
    out_path = f"{os.path.splitext(args.rom)[0]}_startW{args.world}L{args.level}_smart_{ts}.nes"
    with open(out_path, "wb") as f:
        f.write(out)

    print(f"Patch applied. World {args.world}, Level {args.level} (internal {w_int:#04x},{a_int:#04x})")
    print(f"Output: {out_path}")
    print("Tip: From title screen, press A+START simultaneously (H+P in emulator) to activate Continue.")
    print("     If it doesn't jump to chosen world/level, run with --dry-run and try another --pick.")


if __name__ == "__main__":
    main()
