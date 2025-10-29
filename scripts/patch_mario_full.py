#!/usr/bin/env python3
"""
patch_mario_full.py
Modifica la paleta COMPLETA de Mario (los 4 bytes de color), creando "skins" personalizados.

Uso:
  python3 scripts/patch_mario_full.py --c0 0x22 --c1 0x30 --c2 0x0F --c3 0x15

Significado de c0..c3:
  c0 -> Piel / tono base de Mario
  c1 -> Gorra / camisa (color dominante)
  c2 -> Contorno / sombra
  c3 -> Overall / pantalón

Ejemplos de skins:
  Skin "Wario":
    python3 scripts/patch_mario_full.py --c0 0x22 --c1 0x30 --c2 0x0F --c3 0x15

  Skin "Zombie":
    python3 scripts/patch_mario_full.py --c0 0x29 --c1 0x15 --c2 0x0F --c3 0x27

Nota: Esto parchea la paleta Mario [0x22,0x16,0x27,0x18] en TODAS sus apariciones.
"""

import os
import sys
import argparse
from datetime import datetime

ROM_PATH = "roms/SuperMarioBros.nes"

# Paleta original de Mario
MARIO_ORIGINAL = [0x22, 0x16, 0x27, 0x18]

def find_all_occurrences(data: bytearray, subseq: bytes):
    """Devuelve lista de offsets donde aparece subseq en data."""
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
    """Convierte string a byte hexadecimal. Acepta "0x29", "29", "0X30", etc."""
    if s.lower().startswith("0x"):
        s = s[2:]
    val = int(s, 16)
    if not (0 <= val <= 0x3F):
        # Paleta PPU típica es 0x00-0x3F
        if not (0 <= val <= 0xFF):
            raise ValueError(f"valor fuera de rango NES: {val}")
        print(f"⚠ Aviso: {val:02X} está fuera del rango 0x00-0x3F típico NES, igual continuo.")
    return val

def main():
    ap = argparse.ArgumentParser(
        description="Modifica la paleta completa de Mario en Super Mario Bros.",
        epilog="Ejemplos:\n"
               "  python3 patch_mario_full.py --c0 0x22 --c1 0x30 --c2 0x0F --c3 0x15\n"
               "  python3 patch_mario_full.py --c0 0x29 --c1 0x15 --c2 0x0F --c3 0x27"
    )
    ap.add_argument("--c0", required=True, help="nuevo color para slot 0 (piel/tono base)")
    ap.add_argument("--c1", required=True, help="nuevo color para slot 1 (gorra/camisa)")
    ap.add_argument("--c2", required=True, help="nuevo color para slot 2 (contorno/sombra)")
    ap.add_argument("--c3", required=True, help="nuevo color para slot 3 (overall/pantalon)")
    args = ap.parse_args()

    # Parsear colores
    try:
        new_c0 = parse_hexbyte(args.c0)
        new_c1 = parse_hexbyte(args.c1)
        new_c2 = parse_hexbyte(args.c2)
        new_c3 = parse_hexbyte(args.c3)
    except ValueError as e:
        print(f"❌ Error parseando color: {e}")
        sys.exit(1)

    if not os.path.exists(ROM_PATH):
        print(f"❌ ROM no encontrada en {ROM_PATH}")
        sys.exit(1)

    with open(ROM_PATH, "rb") as f:
        rom = bytearray(f.read())

    orig_pattern = bytes(MARIO_ORIGINAL)
    occs = find_all_occurrences(rom, orig_pattern)

    if not occs:
        print(f"❌ No se encontró la paleta original de Mario {MARIO_ORIGINAL} en la ROM.")
        sys.exit(1)

    print(f"🔎 Encontradas {len(occs)} apariciones de la paleta Mario original")
    print(f"   Paleta original: {MARIO_ORIGINAL}")
    print(f"   Nueva paleta: [{new_c0:02X}, {new_c1:02X}, {new_c2:02X}, {new_c3:02X}]")
    print()

    for off in occs:
        before = rom[off:off+4]
        rom[off + 0] = new_c0
        rom[off + 1] = new_c1
        rom[off + 2] = new_c2
        rom[off + 3] = new_c3
        after = rom[off:off+4]
        print(f"   📍 Offset 0x{off:04X}: {list(before)} → {list(after)}")

    ts = datetime.now().strftime("%Y%m%d_%H%M%S")
    out_name = (
        f"roms/SuperMarioBros_mario_full_"
        f"{new_c0:02X}_{new_c1:02X}_{new_c2:02X}_{new_c3:02X}_{ts}.nes"
    )

    with open(out_name, "wb") as f:
        f.write(rom)

    print()
    print(f"✅ ROM modificada escrita en: {out_name}")
    print(f"🎯 Skin de Mario creado con:")
    print(f"   Piel:      0x{new_c0:02X}")
    print(f"   Gorra:     0x{new_c1:02X}")
    print(f"   Contorno:  0x{new_c2:02X}")
    print(f"   Overall:   0x{new_c3:02X}")
    print()
    print("💡 Cargala en el emulador y mirá el resultado visual.")
    print("   Ahora sí podés crear 'Mario zombie', 'Mario wario', etc. 🔥")

if __name__ == "__main__":
    main()

