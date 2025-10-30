#!/usr/bin/env python3
"""
mutate_chr_range.py
Like a global CHR mutation but only for a tile range.
Adjust TILE_START and TILE_COUNT until target graphics change
without destroying unrelated tiles.
"""

import os
from datetime import datetime

ROM_IN  = "roms/SuperMarioBros.nes"

TILE_SIZE = 16  # 16 bytes per tile
# Adjust these to test ranges
TILE_START = 0x1E0   # 480 decimal
TILE_COUNT = 0x20    # 32 tiles → covers 0x1E0..0x1FF

def swap_01_10_in_tile(tile_bytes):
    p0 = list(tile_bytes[0:8])  # plane0
    p1 = list(tile_bytes[8:16]) # plane1
    new_p0 = [0]*8
    new_p1 = [0]*8

    for row in range(8):
        b0 = p0[row]
        b1 = p1[row]
        out_b0 = 0
        out_b1 = 0
        for bit in range(8):
            mask = 1 << (7 - bit)
            bit0 = 1 if (b0 & mask) else 0
            bit1 = 1 if (b1 & mask) else 0

            if bit1 == 0 and bit0 == 1:
                nb1, nb0 = 1, 0   # 01 -> 10
            elif bit1 == 1 and bit0 == 0:
                nb1, nb0 = 0, 1   # 10 -> 01
            else:
                nb1, nb0 = bit1, bit0  # 00 or 11 unchanged

            if nb0:
                out_b0 |= mask
            if nb1:
                out_b1 |= mask

        new_p0[row] = out_b0
        new_p1[row] = out_b1

    return bytes(new_p0 + new_p1)

def main():
    if not os.path.exists(ROM_IN):
        print(f"Not found: {ROM_IN}")
        return

    with open(ROM_IN, "rb") as f:
        rom = bytearray(f.read())

    # validate iNES header
    if rom[0:4] != b"NES\x1a":
        print("Not a valid iNES file.")
        return

    prg_banks = rom[4]
    chr_banks = rom[5]

    header_size = 16
    prg_size = prg_banks * 16 * 1024
    chr_size = chr_banks * 8 * 1024

    prg_start = header_size
    chr_start = header_size + prg_size
    chr_end   = chr_start + chr_size

    chr_data = bytearray(rom[chr_start:chr_end])

    start_byte = TILE_START * TILE_SIZE
    end_byte   = start_byte + TILE_COUNT * TILE_SIZE

    if end_byte > len(chr_data):
        print("Range exceeds CHR. Adjust TILE_START/TILE_COUNT.")
        return

    # mutate only the selected range
    for tile_index in range(TILE_START, TILE_START + TILE_COUNT):
        off = tile_index * TILE_SIZE
        tile = chr_data[off:off+TILE_SIZE]
        chr_data[off:off+TILE_SIZE] = swap_01_10_in_tile(tile)

    # rebuild ROM
    new_rom = bytearray()
    new_rom += rom[:chr_start]
    new_rom += chr_data
    if chr_end < len(rom):
        new_rom += rom[chr_end:]

    out_path = f"roms/SuperMarioBros_CHRrange_{TILE_START:02X}_{TILE_COUNT:02X}.nes"
    with open(out_path, "wb") as f:
        f.write(new_rom)

    print("Modified ROM:", out_path)
    print("   TILE_START =", hex(TILE_START), "TILE_COUNT =", hex(TILE_COUNT))
    print("Load and verify target graphics changed while unrelated assets remain stable.")

if __name__ == "__main__":
    main()

