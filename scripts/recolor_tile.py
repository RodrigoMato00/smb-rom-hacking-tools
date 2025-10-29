#!/usr/bin/env python3
"""
recolor_tile.py
Recolorea UN tile CHR cambiando índices de color específicos,
pero sin destruir el dibujo.

En NES cada pixel del tile es 2 bits (0..3). Este script:
1. Lee el tile original.
2. Lo decodifica en una matriz 8x8 de índices [0..3].
3. Aplica reglas de reemplazo (por ejemplo "2 -> 1", "3 -> 0").
4. Vuelve a empaquetar a formato NES (dos planos de 8 bytes).
5. Escribe una ROM nueva.

USO:
  python3 recolor_tile.py \
    --tile 0x072 \
    --map 2:1 \
    --map 3:0

Eso reemplaza todos los píxeles que tenían índice 2 por 1,
y todos los que tenían 3 por 0.
"""

import os
import argparse
from datetime import datetime

ROM_IN    = "roms/SuperMarioBros_goomba.nes"
TILE_SIZE = 16  # 8 bytes plano0 + 8 bytes plano1

def decode_tile(tile_bytes):
    """
    tile_bytes: 16 bytes
      primeros 8 bytes: plano bit0 (LSB)
      siguientes 8:      plano bit1 (MSB)

    devolvemos tile_matrix[8][8] con valores 0..3
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
    inverso de decode_tile:
    recibe matriz 8x8 con valores 0..3
    devuelve 16 bytes (8 plane0 + 8 plane1)
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
                    help="tile index (hex ej 0x072 o decimal ej 114)")
    ap.add_argument("--map", action="append", required=True,
                    help="regla de recolor src:dst (ej --map 2:1). Puedes repetir varias veces.")
    ap.add_argument("--input", default="roms/SuperMarioBros_goomba.nes",
                    help="ROM de entrada (default: SuperMarioBros_goomba.nes)")
    args = ap.parse_args()

    # parse tile index
    tile_str = args.tile
    tile_idx = int(tile_str, 16) if tile_str.lower().startswith("0x") else int(tile_str)

    # parse reglas de recolor
    recolor_rules = []
    for m in args.map:
        if ":" not in m:
            raise ValueError(f"Regla inválida '{m}'. Debe ser tipo src:dst")
        src_str, dst_str = m.split(":")
        src_val = int(src_str)
        dst_val = int(dst_str)
        if not (0 <= src_val <= 3 and 0 <= dst_val <= 3):
            raise ValueError("Solo índices 0..3 permitidos en --map")
        recolor_rules.append((src_val, dst_val))

    # cargar ROM
    if not os.path.exists(args.input):
        print(f"❌ No se encontró {args.input}")
        return

    with open(args.input, "rb") as f:
        rom = bytearray(f.read())

    # validar iNES
    if rom[0:4] != b"NES\x1a":
        print("❌ No parece iNES válida.")
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
        print(f"❌ tile fuera de rango (0..{total_tiles-1})")
        return

    off = tile_idx * TILE_SIZE
    original_tile = bytes(chr_data[off:off+TILE_SIZE])

    # 1. decodificamos tile → matriz 8x8 con índices 0..3
    matrix = decode_tile(original_tile)

    # 2. aplicamos recolor: para cada pixel que sea src, lo cambiamos a dst
    for row in range(8):
        for col in range(8):
            pix = matrix[row][col]
            for (src, dst) in recolor_rules:
                if pix == src:
                    pix = dst
            matrix[row][col] = pix

    # 3. reempacamos
    new_tile = encode_tile(matrix)

    # 4. guardamos el tile modificado en la CHR
    chr_data[off:off+TILE_SIZE] = new_tile

    # 5. reconstruimos ROM entera
    new_rom = bytearray()
    new_rom += rom[:chr_start]
    new_rom += chr_data
    if chr_end < len(rom):
        new_rom += rom[chr_end:]

    # Escribir directamente sobre la ROM de trabajo
    with open(args.input, "wb") as f:
        f.write(new_rom)

    print("✅ ROM modificada:", args.input)
    print(f"   Tile editado: 0x{tile_idx:03X}")
    print("   Reglas aplicadas:")
    for (s,d) in recolor_rules:
        print(f"     índice {s} → índice {d}")

if __name__ == "__main__":
    main()
