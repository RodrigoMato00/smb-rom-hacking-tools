#!/usr/bin/env python3
"""
patch_sky_palette_final.py
Modifica específicamente BackgroundColors en Super Mario Bros.

Basado en el análisis correcto del assembler:
BackgroundColors en 0x85cf: 22 22 0f 0f
- Los primeros dos $22 son los colores del cielo
- Cambiamos ambos $22 por $0f para efecto noche

Uso:
  python3 scripts/patch_sky_palette_final.py                    # Crea nueva ROM con efecto noche
  python3 scripts/patch_sky_palette_final.py roms/mi_rom.nes    # Modifica ROM específica
"""

import os
import argparse
from datetime import datetime

def cpu_addr_to_file_offset(cpu_addr):
    """Convierte dirección CPU a offset de archivo"""
    HEADER_SIZE = 16
    BANK_SIZE = 16 * 1024  # 16KB

    if cpu_addr < 0x8000 or cpu_addr > 0xFFFF:
        raise ValueError("Dirección fuera de rango PRG-ROM")

    if cpu_addr < 0xC000:
        # banco bajo
        offset_in_bank = cpu_addr - 0x8000
        file_off = HEADER_SIZE + offset_in_bank
    else:
        # banco alto
        offset_in_bank = cpu_addr - 0xC000
        file_off = HEADER_SIZE + BANK_SIZE + offset_in_bank

    return file_off

def main():
    parser = argparse.ArgumentParser(description="Modifica el cielo de Super Mario Bros para efecto noche")
    parser.add_argument("rom_path", nargs="?", default=None,
                        help="Ruta a la ROM de NES (si no se especifica, usa SuperMarioBros.nes y crea nueva)")
    args = parser.parse_args()

    # Determinar qué ROM usar
    if args.rom_path is None:
        rom_path = "roms/SuperMarioBros.nes"
        create_new = True
    else:
        rom_path = args.rom_path
        create_new = False

    if not os.path.exists(rom_path):
        print(f"❌ No se encontró {rom_path}")
        return

    with open(rom_path, "rb") as f:
        rom = bytearray(f.read())

    if rom[0:4] != b"NES\x1a":
        print("❌ ROM no parece iNES válida")
        return

    # BackgroundColors en 0x85cf: 22 22 0f 0f
    # Los primeros dos $22 son los colores del cielo
    BACKGROUND_COLORS_ADDR = 0x85cf

    # Convertir a offset de archivo
    bg_colors_off = cpu_addr_to_file_offset(BACKGROUND_COLORS_ADDR)

    print(f"📍 BackgroundColors en offset 0x{bg_colors_off:06X} (CPU $85cf)")

    # Leer colores actuales
    current_colors = rom[bg_colors_off:bg_colors_off+4]
    print(f"🔍 Colores actuales: {' '.join(f'{b:02X}' for b in current_colors)}")

    # Cambiar AMBOS colores del cielo por negro
    original_sky1 = rom[bg_colors_off]
    original_sky2 = rom[bg_colors_off + 1]
    new_sky_color = 0x0f

    rom[bg_colors_off] = new_sky_color      # Primer cielo: $22 → $0f
    rom[bg_colors_off + 1] = new_sky_color  # Segundo cielo: $22 → $0f

    print(f"✅ Cambios aplicados:")
    print(f"   Primer cielo: 0x{original_sky1:02X} → 0x{new_sky_color:02X}")
    print(f"   Segundo cielo: 0x{original_sky2:02X} → 0x{new_sky_color:02X}")

    # Guardar ROM modificada
    if create_new:
        # Crear nueva ROM con timestamp
        ts = datetime.now().strftime("%Y%m%d_%H%M%S")
        out_path = f"roms/SuperMarioBros_sky_night_{ts}.nes"
        with open(out_path, "wb") as f:
            f.write(rom)
        print(f"💾 ROM nueva creada: {out_path}")
    else:
        # Sobreescribir ROM existente
        with open(rom_path, "wb") as f:
            f.write(rom)
        print(f"💾 ROM modificada: {rom_path}")

    print("🌙 El cielo del nivel 1-1 ahora está oscuro!")

if __name__ == "__main__":
    main()
