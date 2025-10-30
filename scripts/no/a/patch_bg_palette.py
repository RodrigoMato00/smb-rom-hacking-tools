#!/usr/bin/env python3
"""
patch_bg_palette.py
Goal: darken the level sky/background (night-like) without changing Mario or enemies.

How it works:
1) Scan for 16-byte blocks that look like background palettes:
   - 4 sub-palettes x 4 colors = 16 bytes
   - common in SMB: each sub-palette ends in 0x0F (black)
   - the first color often repeats (sky base like 0x22)

2) Scan mode:
   python3 patch_bg_palette.py --scan
   -> prints ROM offsets of candidate BG palettes.

3) Patch mode:
   python3 patch_bg_palette.py --orig 0x22 --new 0x02
   Replaces 0x22 with 0x02 within candidate blocks and writes a new ROM.

Hints:
 - 0x22: light blue (sky)
 - 0x02: darker blue
 - 0x0F: black
"""

import os
import argparse
from datetime import datetime

ROM_IN = "roms/SuperMarioBros.nes"

def looks_like_bg_palette(block):
    """
    block: 16 bytes
    Simple heuristic:
    - Each 4-byte sub-palette ends with a dark entry like 0x0F
    - First byte of each sub-palette often repeats (e.g., 0x22)
    This is not perfect but usually catches sky/ground palettes.
    """
    if len(block) != 16:
        return False

    subs = [block[i:i+4] for i in range(0,16,4)]
    # last color of each sub-palette is commonly dark (0x0F)
    for sub in subs:
        if len(sub) < 4: return False
        if sub[3] not in (0x0F, 0x00, 0x10, 0x20, 0x30):
            return False

    # first byte of each sub-palette tends to be equal or close
    firsts = [sub[0] for sub in subs]
    if not (max(firsts) - min(firsts) <= 2):
        return False

    return True

def scan_palettes(rom_bytes):
    cands = []
    for off in range(len(rom_bytes)-16):
        block = rom_bytes[off:off+16]
        if looks_like_bg_palette(block):
            cands.append((off, block))
    return cands

def patch_palettes(rom_bytes, orig_val, new_val, candidates):
    rom_mod = bytearray(rom_bytes)
    hits = 0
    for off, block in candidates:
        new_block = bytearray(block)
        changed = False
        for i,b in enumerate(new_block):
            if b == orig_val:
                new_block[i] = new_val
                changed = True
        if changed:
            rom_mod[off:off+16] = new_block
            hits += 1
    return rom_mod, hits

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--scan", action="store_true", help="only list candidate BG palettes")
    ap.add_argument("--orig", help="original value (e.g., 0x22)")
    ap.add_argument("--new",  help="new value (e.g., 0x02)")
    args = ap.parse_args()

    if not os.path.exists(ROM_IN):
        print(f"Not found: {ROM_IN}")
        return

    with open(ROM_IN,"rb") as f:
        rom = f.read()

    cands = scan_palettes(rom)

    print("Candidate BG palettes:")
    for off, block in cands[:20]:
        pretty = " ".join(f"{b:02X}" for b in block)
        print(f"  offset 0x{off:06X}: {pretty}")
    print(f"Total candidates: {len(cands)}")
    print()

    if args.scan:
        return

    if args.orig is None or args.new is None:
        print("For patching use: --orig 0x22 --new 0x02 (example)")
        return

    def parse_hexish(s):
        s = s.strip().lower()
        if s.startswith("0x"):
            return int(s,16)
        return int(s,16)
    orig_val = parse_hexish(args.orig)
    new_val  = parse_hexish(args.new)

    rom_mod, hits = patch_palettes(rom, orig_val, new_val, cands)

    ts = datetime.now().strftime("%Y%m%d_%H%M%S")
    out_path = f"roms/SuperMarioBros_bgpatch_{orig_val:02X}_to_{new_val:02X}_{ts}.nes"
    with open(out_path,"wb") as f:
        f.write(rom_mod)

    print(f"Patched ROM written to: {out_path}")
    print(f"Replacements applied in {hits} palette blocks.")
    print("Load the ROM in the emulator; if 1-1 sky is darker, it worked.")

if __name__ == "__main__":
    main()
