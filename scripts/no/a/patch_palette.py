#!/usr/bin/env python3
"""
patch_palette.py
Patch a player palette in Super Mario Bros (NES) by changing the dominant color
(2nd byte of the 4-byte palette).

Examples:
  python3 patch_palette.py --target mario --color 0x30
  python3 patch_palette.py --target luigi --color 0x29
  python3 patch_palette.py --target fire  --color 0x37

Supported targets:
  - mario  : Mario normal      [$22,$16,$27,$18]
  - luigi  : Luigi normal      [$22,$30,$27,$19]
  - fire   : Mario/Luigi fire  [$22,$37,$27,$16]
  - goomba : Goomba/Koopa      [$0F,$10,$30,$27]
"""

import os
import sys
import argparse
from datetime import datetime

ROM_PATH = "roms/SuperMarioBros.nes"

# Known base palettes (order as in standard SMB ROM)
PLAYER_PALETTES = {
    "mario": {
        "pattern": [0x22, 0x16, 0x27, 0x18],
        "index_to_patch": 1,  # dominant color (2nd byte)
    },
    "luigi": {
        "pattern": [0x22, 0x30, 0x27, 0x19],
        "index_to_patch": 1,
    },
    "fire": {
        "pattern": [0x22, 0x37, 0x27, 0x16],
        "index_to_patch": 1,
    },
    "goomba": {
        "pattern": [0x0F, 0x10, 0x30, 0x27],  # Goomba palette (observed around 0x0CCB)
        "index_to_patch": 1,  # body color for Goomba (0x10 = brown)
    },
}

def find_all_occurrences(data: bytearray, subseq: bytes):
    """Return a list of offsets where subseq appears in data."""
    matches = []
    start = 0
    L = len(subseq)
    while True:
        idx = data.find(subseq, start)
        if idx == -1:
            break
        matches.append(idx)
        start = idx + 1
    return matches

def patch_palette(target: str, new_color: int):
    if not os.path.exists(ROM_PATH):
        print(f"Error: ROM not found at {ROM_PATH}")
        sys.exit(1)

    with open(ROM_PATH, "rb") as f:
        rom = bytearray(f.read())

    if target not in PLAYER_PALETTES:
        print(f"Unsupported target '{target}'.")
        print(f"Valid targets: {', '.join(PLAYER_PALETTES.keys())}")
        sys.exit(1)

    pattern_info = PLAYER_PALETTES[target]
    pattern = bytes(pattern_info["pattern"])
    patch_index = pattern_info["index_to_patch"]

    occs = find_all_occurrences(rom, pattern)

    if not occs:
        print(f"Palette for target '{target}' not found in ROM: {pattern}")
        sys.exit(1)

    print(f"Found {len(occs)} occurrences of '{target}' palette: {pattern}")
    for off in occs:
        before = rom[off + patch_index]
        rom[off + patch_index] = new_color
        after = rom[off + patch_index]
        print(f"   Offset 0x{off+patch_index:04X}: {before:02X} -> {after:02X}")

    ts = datetime.now().strftime("%Y%m%d_%H%M%S")
    out_name = f"roms/SuperMarioBros_{target}_{new_color:02X}_{ts}.nes"

    with open(out_name, "wb") as f:
        f.write(rom)

    print()
    print(f"Modified ROM written to: {out_name}")
    print(f"Target: {target}")
    print(f"New color (hex): 0x{new_color:02X}")
    print("Load this ROM in the emulator and verify the visual result.")

def parse_args():
    ap = argparse.ArgumentParser(description="Patch a SMB player palette (dominant color)")
    ap.add_argument(
        "--target",
        required=True,
        choices=list(PLAYER_PALETTES.keys()),
        help="Which palette to patch (mario, luigi, fire, goomba)",
    )
    ap.add_argument(
        "--color",
        required=True,
        help="New color in hex, e.g., 0x30 or 30",
    )
    args = ap.parse_args()

    color_str = args.color
    if color_str.lower().startswith("0x"):
        color_str = color_str[2:]
    try:
        color_val = int(color_str, 16)
    except ValueError:
        print(f"'{args.color}' is not a valid hex value")
        sys.exit(1)

    if not (0 <= color_val <= 0x3F):
        # NES palette indices are typically 0x00-0x3F
        print("Warning: typical NES color value range is 0x00..0x3F.")
        if not (0 <= color_val <= 0xFF):
            print("Out of absolute range (0x00..0xFF).")
            sys.exit(1)

    return args.target, color_val

def main():
    target, color_val = parse_args()
    patch_palette(target, color_val)

if __name__ == "__main__":
    main()

