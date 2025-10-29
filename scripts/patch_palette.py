#!/usr/bin/env python3
"""
patch_palette.py
Parchea la paleta de jugador en Super Mario Bros. (NES) cambiando
el color dominante (2do byte de la paleta de 4 colores).

Uso ejemplo:
  python3 patch_palette.py --target mario --color 0x30
  python3 patch_palette.py --target luigi --color 0x29
  python3 patch_palette.py --target fire --color 0x37

Targets soportados:
  - mario  : Mario normal      [$22,$16,$27,$18]
  - luigi  : Luigi normal      [$22,$30,$27,$19]
  - fire   : Mario/Luigi fuego [$22,$37,$27,$16]
  - goomba : Goomba/Koopa       [0x0F,$17,$27,$30]
"""

import os
import sys
import argparse
from datetime import datetime

ROM_PATH = "roms/SuperMarioBros.nes"

# Paletas base conocidas (orden tal como están en la ROM del SMB estándar)
PLAYER_PALETTES = {
    "mario": {
        "pattern": [0x22, 0x16, 0x27, 0x18],
        "index_to_patch": 1,  # byte que queremos reemplazar (color dominante)
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
        "pattern": [0x0F, 0x10, 0x30, 0x27],  # Paleta de Goomba detectada en offset 0x0CCB
        "index_to_patch": 1,  # Modifica el color del cuerpo del Goomba (0x10 = marrón)
    },
}

def find_all_occurrences(data: bytearray, subseq: bytes):
    """Devuelve lista de offsets donde aparece subseq en data."""
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
        print(f"❌ Error: ROM no encontrada en {ROM_PATH}")
        sys.exit(1)

    # cargar rom
    with open(ROM_PATH, "rb") as f:
        rom = bytearray(f.read())

    if target not in PLAYER_PALETTES:
        print(f"❌ Target '{target}' no soportado.")
        print(f"Targets válidos: {', '.join(PLAYER_PALETTES.keys())}")
        sys.exit(1)

    pattern_info = PLAYER_PALETTES[target]
    pattern = bytes(pattern_info["pattern"])
    patch_index = pattern_info["index_to_patch"]

    # buscar TODAS las apariciones
    occs = find_all_occurrences(rom, pattern)

    if not occs:
        print(f"❌ No se encontró la paleta {target} ({pattern}) en la ROM.")
        sys.exit(1)

    print(f"🔎 Encontradas {len(occs)} apariciones de la paleta {target}: {pattern}")
    for off in occs:
        before = rom[off + patch_index]
        rom[off + patch_index] = new_color
        after = rom[off + patch_index]
        print(f"   📍 Offset 0x{off+patch_index:04X}: {before:02X} → {after:02X}")

    # nombrar salida
    ts = datetime.now().strftime("%Y%m%d_%H%M%S")
    out_name = f"roms/SuperMarioBros_{target}_{new_color:02X}_{ts}.nes"

    with open(out_name, "wb") as f:
        f.write(rom)

    print()
    print(f"✅ ROM modificada escrita en: {out_name}")
    print(f"🎯 Target: {target}")
    print(f"🎨 Nuevo color (hex): 0x{new_color:02X}")
    print("💡 Cargá esa ROM en tu emulador y verificá resultado visual.")

def parse_args():
    ap = argparse.ArgumentParser()
    ap.add_argument(
        "--target",
        required=True,
        choices=list(PLAYER_PALETTES.keys()),
        help="Cuál paleta parchear (mario, luigi, fire)",
    )
    ap.add_argument(
        "--color",
        required=True,
        help="Nuevo color en hex, ej 0x30 o 30",
    )
    args = ap.parse_args()

    color_str = args.color
    if color_str.lower().startswith("0x"):
        color_str = color_str[2:]
    try:
        color_val = int(color_str, 16)
    except ValueError:
        print(f"❌ '{args.color}' no es un hex válido")
        sys.exit(1)

    if not (0 <= color_val <= 0x3F):
        # En la NES las paletas son 0x00-0x3F, realmente
        print("⚠ Aviso: el valor típico de color en NES va de 0x00 a 0x3F.")
        if not (0 <= color_val <= 0xFF):
            print("❌ Fuera de rango totalmente (0x00-0xFF).")
            sys.exit(1)

    return args.target, color_val

def main():
    target, color_val = parse_args()
    patch_palette(target, color_val)

if __name__ == "__main__":
    main()

