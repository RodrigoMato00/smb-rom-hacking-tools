#!/usr/bin/env python3
"""
mutate_chr_range_args.py
Versión parametrizable por línea de comandos.

Ejemplo de uso:
  python3 scripts/mutate_chr_range_args.py --start 0x1E0 --count 0x20
  python3 scripts/mutate_chr_range_args.py --start 480 --count 32
"""

import os
import argparse
from datetime import datetime

ROM_IN = "roms/SuperMarioBros.nes"
TILE_SIZE = 16  # bytes por tile (8 plano bajo + 8 plano alto)

def swap_01_10_in_tile(tile_bytes):
    p0 = list(tile_bytes[0:8])  # plane 0 (LSB)
    p1 = list(tile_bytes[8:16]) # plane 1 (MSB)
    new_p0, new_p1 = [0]*8, [0]*8

    for row in range(8):
        b0, b1 = p0[row], p1[row]
        out_b0, out_b1 = 0, 0
        for bit in range(8):
            mask = 1 << (7 - bit)
            bit0 = 1 if (b0 & mask) else 0
            bit1 = 1 if (b1 & mask) else 0

            # swap indices 01 <-> 10
            if bit1 == 0 and bit0 == 1:
                nb1, nb0 = 1, 0   # 01 -> 10
            elif bit1 == 1 and bit0 == 0:
                nb1, nb0 = 0, 1   # 10 -> 01
            else:
                nb1, nb0 = bit1, bit0

            if nb0: out_b0 |= mask
            if nb1: out_b1 |= mask

        new_p0[row] = out_b0
        new_p1[row] = out_b1

    return bytes(new_p0 + new_p1)

def main():
    parser = argparse.ArgumentParser(description="Mutar rango de tiles en CHR-ROM de SMB")
    parser.add_argument("--start", required=True, help="Tile inicial (hex o decimal)")
    parser.add_argument("--count", required=True, help="Cantidad de tiles (hex o decimal)")
    args = parser.parse_args()

    # Conversión segura de argumentos
    def parse_int(val):
        return int(val, 16) if str(val).lower().startswith("0x") else int(val)

    TILE_START = parse_int(args.start)
    TILE_COUNT = parse_int(args.count)

    if not os.path.exists(ROM_IN):
        print(f"❌ No se encontró {ROM_IN}")
        return

    with open(ROM_IN, "rb") as f:
        rom = bytearray(f.read())

    if rom[:4] != b"NES\x1a":
        print("❌ No parece una ROM iNES válida.")
        return

    prg_banks = rom[4]
    chr_banks = rom[5]

    header_size = 16
    prg_size = prg_banks * 16 * 1024
    chr_size = chr_banks * 8 * 1024

    chr_start = header_size + prg_size
    chr_end = chr_start + chr_size
    chr_data = bytearray(rom[chr_start:chr_end])

    total_tiles = len(chr_data) // TILE_SIZE
    if TILE_START < 0 or TILE_START + TILE_COUNT > total_tiles:
        print("❌ Rango fuera de CHR. Ajustá --start/--count.")
        return

    for tile_index in range(TILE_START, TILE_START + TILE_COUNT):
        off = tile_index * TILE_SIZE
        tile = chr_data[off:off+TILE_SIZE]
        chr_data[off:off+TILE_SIZE] = swap_01_10_in_tile(tile)

    # reconstruir ROM
    new_rom = bytearray()
    new_rom += rom[:chr_start]
    new_rom += chr_data
    if chr_end < len(rom):
        new_rom += rom[chr_end:]

    ts = datetime.now().strftime("%Y%m%d_%H%M%S")
    out_path = f"roms/SuperMarioBros_CHR_{TILE_START:03X}_{TILE_COUNT:03X}_{ts}.nes"
    with open(out_path, "wb") as f:
        f.write(new_rom)

    print(f"✅ ROM mutada parcialmente: {out_path}")
    print(f"   Tiles modificados: {hex(TILE_START)} .. {hex(TILE_START + TILE_COUNT - 1)}")
    print("👉 Cargá esa ROM y mirá el Goomba del 1-1.")

if __name__ == "__main__":
    main()
