#!/usr/bin/env python3
"""
patch_mario_palette.py
Modify Mario's FULL palette (4 color bytes) to create custom "skins".

Usage:
  python3 scripts/patch_mario_palette.py --c0 0x22 --c1 0x30 --c2 0x0F --c3 0x15

Meaning of c0..c3:
  c0 -> Skin / base tone
  c1 -> Cap / shirt (dominant color)
  c2 -> Outline / shadow
  c3 -> Overall / pants

Examples:
  Wario skin:
    python3 scripts/patch_mario_palette.py --c0 0x22 --c1 0x30 --c2 0x0F --c3 0x15

  Zombie skin:
    python3 scripts/patch_mario_palette.py --c0 0x29 --c1 0x15 --c2 0x0F --c3 0x27

Note: This patches the Mario palette [0x22,0x16,0x27,0x18] in ALL its occurrences.
"""

import os
import sys
import argparse
from datetime import datetime
from argparse import ArgumentDefaultsHelpFormatter
from common_help import get_epilog

ROM_PATH = "roms/SuperMarioBros.nes"

# Original Mario palette
MARIO_ORIGINAL = [0x22, 0x16, 0x27, 0x18]

def find_all_occurrences(data: bytearray, subseq: bytes):
    """Return list of offsets where subseq appears in data."""
    matches = []
    start = 0
    while True:
        idx = data.find(subseq, start)
        if idx == -1:
            break
        matches.append(idx)
        start = idx + 1
    return matches

def parse_hexbyte(s):
    """Parse a hex byte from string. Accepts "0x29", "29", "0X30", etc."""
    if s.lower().startswith("0x"):
        s = s[2:]
    val = int(s, 16)
    if not (0 <= val <= 0x3F):
        # Paleta PPU típica es 0x00-0x3F
        if not (0 <= val <= 0xFF):
            raise ValueError(f"value out of NES range: {val}")
        print(f"Warning: {val:02X} is outside typical NES palette range 0x00-0x3F, continuing anyway.")
    return val

def main():
    ap = argparse.ArgumentParser(
        description="Modify Mario's full palette in SMB (4 color slots).",
        formatter_class=ArgumentDefaultsHelpFormatter,
        epilog=get_epilog("patch_mario_palette"),
    )
    ap.add_argument("--c0", required=True, help="new color for slot 0 (skin/base tone)")
    ap.add_argument("--c1", required=True, help="new color for slot 1 (cap/shirt)")
    ap.add_argument("--c2", required=True, help="new color for slot 2 (outline/shadow)")
    ap.add_argument("--c3", required=True, help="new color for slot 3 (overall/pants)")
    args = ap.parse_args()

    # Parsear colores
    try:
        new_c0 = parse_hexbyte(args.c0)
        new_c1 = parse_hexbyte(args.c1)
        new_c2 = parse_hexbyte(args.c2)
        new_c3 = parse_hexbyte(args.c3)
    except ValueError as e:
        print(f"Error parsing color: {e}")
        sys.exit(1)

    if not os.path.exists(ROM_PATH):
        print(f"ROM not found at {ROM_PATH}")
        sys.exit(1)

    with open(ROM_PATH, "rb") as f:
        rom = bytearray(f.read())

    orig_pattern = bytes(MARIO_ORIGINAL)
    occs = find_all_occurrences(rom, orig_pattern)

    if not occs:
        print(f"Could not find original Mario palette {MARIO_ORIGINAL} in ROM.")
        sys.exit(1)

    print(f"Found {len(occs)} occurrences of the original Mario palette")
    print(f"   Original palette: {MARIO_ORIGINAL}")
    print(f"   New palette: [{new_c0:02X}, {new_c1:02X}, {new_c2:02X}, {new_c3:02X}]")
    print()

    for off in occs:
        before = rom[off:off+4]
        rom[off + 0] = new_c0
        rom[off + 1] = new_c1
        rom[off + 2] = new_c2
        rom[off + 3] = new_c3
        after = rom[off:off+4]
        print(f"   Offset 0x{off:04X}: {list(before)} → {list(after)}")

    ts = datetime.now().strftime("%Y%m%d_%H%M%S")
    out_name = (
        f"roms/SuperMarioBros_mario_full_"
        f"{new_c0:02X}_{new_c1:02X}_{new_c2:02X}_{new_c3:02X}_{ts}.nes"
    )

    with open(out_name, "wb") as f:
        f.write(rom)

    print()
    print(f"Modified ROM written to: {out_name}")
    print(f"Mario skin created with:")
    print(f"   Skin/Base: 0x{new_c0:02X}")
    print(f"   Cap:       0x{new_c1:02X}")
    print(f"   Outline:   0x{new_c2:02X}")
    print(f"   Overall:   0x{new_c3:02X}")
    print()
    print("Load it in the emulator to see the visual result.")
    print("Now you can create 'Zombie Mario', 'Wario', etc.")

if __name__ == "__main__":
    main()

