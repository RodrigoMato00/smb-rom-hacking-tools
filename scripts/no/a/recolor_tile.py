#!/usr/bin/env python3
"""
recolor_tile.py
Recolor a single CHR tile by remapping specific color indices
without destroying the drawing.

On NES each tile pixel is 2 bits (0..3). This script:
1) Reads the original tile
2) Decodes into an 8x8 matrix of indices [0..3]
3) Applies replacement rules (e.g., "2 -> 1", "3 -> 0")
4) Re-encodes to NES format (two 8-byte planes)
5) Writes the modified ROM

Usage:
  python3 recolor_tile.py \
    --tile 0x072 \
    --map 2:1 \
    --map 3:0

This replaces all pixels with index 2 to 1, and 3 to 0.
"""

import os
import argparse
from datetime import datetime

ROM_IN    = "roms/SuperMarioBros_goomba.nes"
TILE_SIZE = 16  # 8 bytes plane0 + 8 bytes plane1

def decode_tile(tile_bytes):
    """
    tile_bytes: 16 bytes
      first 8 bytes: plane bit0 (LSB)
      next 8 bytes:  plane bit1 (MSB)

    return tile_matrix[8][8] with values 0..3
    """
    plane0 = tile_bytes[0:8]
    plane1 = tile_bytes[8:16]

    tile_matrix = [[0]*8 for _ in range(8)]
    for row in range(8):
        b0 = plane0[row]
        b1 = plane1[row]
        for col in range(8):
            mask = 1 << (7 - col)
            bit0 = 1 if (b0 & mask) else 0
            bit1 = 1 if (b1 & mask) else 0
            tile_matrix[row][col] = (bit1 << 1) | bit0  # 0..3
    return tile_matrix

def encode_tile(tile_matrix):
    """
    Inverse of decode_tile:
    receives 8x8 matrix with values 0..3
    returns 16 bytes (8 plane0 + 8 plane1)
    """
    plane0 = [0]*8
    plane1 = [0]*8
    for row in range(8):
        b0 = 0
        b1 = 0
        for col in range(8):
            val = tile_matrix[row][col] & 0b11
            bit0 = val & 1
            bit1 = (val >> 1) & 1
            mask = 1 << (7 - col)
            if bit0:
                b0 |= mask
            if bit1:
                b1 |= mask
        plane0[row] = b0
        plane1[row] = b1
    return bytes(plane0 + plane1)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--tile", required=True,
                    help="tile index (hex e.g. 0x072 or decimal e.g. 114)")
    ap.add_argument("--map", action="append", required=True,
                    help="recolor rule src:dst (e.g., --map 2:1); can repeat")
    ap.add_argument("--input", default="roms/SuperMarioBros_goomba.nes",
                    help="input ROM (default: SuperMarioBros_goomba.nes)")
    args = ap.parse_args()

    # parse tile index
    tile_str = args.tile
    tile_idx = int(tile_str, 16) if tile_str.lower().startswith("0x") else int(tile_str)

    # parse recolor rules
    recolor_rules = []
    for m in args.map:
        if ":" not in m:
            raise ValueError(f"Invalid rule '{m}'. Must be src:dst")
        src_str, dst_str = m.split(":")
        src_val = int(src_str)
        dst_val = int(dst_str)
        if not (0 <= src_val <= 3 and 0 <= dst_val <= 3):
            raise ValueError("Only indices 0..3 allowed in --map")
        recolor_rules.append((src_val, dst_val))

    # load ROM
    if not os.path.exists(args.input):
        print(f"Not found: {args.input}")
        return

    with open(args.input, "rb") as f:
        rom = bytearray(f.read())

    # validate iNES
    if rom[0:4] != b"NES\x1a":
        print("Not a valid iNES file.")
        return

    prg_banks = rom[4]
    chr_banks = rom[5]

    header_size = 16
    prg_size = prg_banks * 16 * 1024
    chr_size = chr_banks * 8 * 1024

    chr_start = header_size + prg_size
    chr_end   = chr_start + chr_size
    chr_data  = bytearray(rom[chr_start:chr_end])

    total_tiles = len(chr_data) // TILE_SIZE
    if tile_idx < 0 or tile_idx >= total_tiles:
        print(f"Tile index out of range (0..{total_tiles-1})")
        return

    off = tile_idx * TILE_SIZE
    original_tile = bytes(chr_data[off:off+TILE_SIZE])

    # 1) decode tile -> 8x8 matrix with indices 0..3
    matrix = decode_tile(original_tile)

    # 2) apply recolor rules
    for row in range(8):
        for col in range(8):
            pix = matrix[row][col]
            for (src, dst) in recolor_rules:
                if pix == src:
                    pix = dst
            matrix[row][col] = pix

    # 3) re-pack
    new_tile = encode_tile(matrix)

    # 4) write tile back into CHR
    chr_data[off:off+TILE_SIZE] = new_tile

    # 5) rebuild whole ROM
    new_rom = bytearray()
    new_rom += rom[:chr_start]
    new_rom += chr_data
    if chr_end < len(rom):
        new_rom += rom[chr_end:]

    # overwrite working ROM
    with open(args.input, "wb") as f:
        f.write(new_rom)

    print("Modified ROM:", args.input)
    print(f"   Edited tile: 0x{tile_idx:03X}")
    print("   Rules applied:")
    for (s,d) in recolor_rules:
        print(f"     index {s} -> index {d}")

if __name__ == "__main__":
    main()
