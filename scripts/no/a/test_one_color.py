#!/usr/bin/env python3
"""
Script para probar UN color a la vez en Mario
Ejemplo: python3 scripts/test_one_color.py 0x30
"""

import os
import sys
import shutil

def modify_mario_color(color_hex):
    """
    Modifica el color de Mario al índice especificado
    """
    rom_path = "roms/SuperMarioBros.nes"

    if not os.path.exists(rom_path):
        print(f"❌ Error: ROM no encontrada en {rom_path}")
        return None

    # Usar la ROM original
    with open(rom_path, 'rb') as f:
        rom_data = bytearray(f.read())

    # Buscar la paleta de Mario y cambiar el color 1 (el color dominante)
    mario_pattern = bytes([0x22, 0x16, 0x27, 0x18])

    modified = False
    for i in range(len(rom_data) - len(mario_pattern)):
        if rom_data[i:i+len(mario_pattern)] == mario_pattern:
            old_color = rom_data[i + 1]
            rom_data[i + 1] = color_hex
            modified = True

            print(f"📍 Offset 0x{i+1:04X}: {old_color:02X} → {color_hex:02X}")
            print(f"   Cambio: Color dominante de Mario")
            break

    if not modified:
        print("❌ No se encontró la paleta de Mario")
        return None

    output_path = "roms/SuperMarioBros_test.nes"
    with open(output_path, 'wb') as f:
        f.write(rom_data)

    print(f"✅ ROM modificada: {output_path}")
    print(f"🎯 Color probado: 0x{color_hex:02X}")
    print()
    print("💡 Ahora actualiza main.py para cargar esta ROM y observa el color")

    return output_path

def main():
    if len(sys.argv) != 2:
        print("Uso: python3 scripts/test_one_color.py <color_hex>")
        print()
        print("Ejemplos:")
        print("  python3 scripts/test_one_color.py 0x30  # Verde lima")
        print("  python3 scripts/test_one_color.py 0x37  # Amarillo")
        print("  python3 scripts/test_one_color.py 0x18  # Azul")
        print("  python3 scripts/test_one_color.py 0x16  # Rojo (original)")
        print()
        print("Colores sugeridos para probar:")
        print("  0x16 - Rojo")
        print("  0x30 - Verde lima")
        print("  0x18 - Azul")
        print("  0x37 - Amarillo")
        print("  0x29 - Naranja")
        print("  0x0F - Negro")
        print("  0x22 - Beige")
        sys.exit(1)

    color_str = sys.argv[1]

    # Limpiar el prefijo 0x si existe
    if color_str.startswith('0x') or color_str.startswith('0X'):
        color_str = color_str[2:]

    try:
        color_hex = int(color_str, 16)
    except ValueError:
        print(f"❌ Error: '{color_str}' no es un valor hexadecimal válido")
        sys.exit(1)

    if not (0 <= color_hex <= 0xFF):
        print(f"❌ Error: '{color_hex}' debe estar entre 0x00 y 0xFF")
        sys.exit(1)

    print(f"🎨 Probando color: 0x{color_hex:02X}")
    print()

    modify_mario_color(color_hex)

if __name__ == "__main__":
    main()

