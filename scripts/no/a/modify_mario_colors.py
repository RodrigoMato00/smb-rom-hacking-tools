#!/usr/bin/env python3
"""
Script para modificar los colores de Mario en Super Mario Bros.
Basado en el disassembly y documentación de paletas NES.
"""

import os
import shutil

# Paleta estándar NES (NTSC)
# Mapeo de índices hex a nombres aproximados de colores
NES_PALETTE = {
    0x22: (252, 152, 56, "Beige/Piel"),
    0x16: (152, 8, 8, "Rojo"),
    0x27: (88, 56, 0, "Marrón oscuro"),
    0x18: (8, 56, 152, "Azul"),
    0x30: (152, 248, 24, "Verde lima"),
    0x19: (88, 248, 152, "Verde claro"),
    0x37: (248, 248, 152, "Amarillo"),
}

def get_color_info(index):
    """Devuelve información del color dado un índice NES"""
    if index in NES_PALETTE:
        rgb = NES_PALETTE[index][:3]
        name = NES_PALETTE[index][3]
        return f"{rgb} ({name})"
    return f"Color NES {index:02X}"

def show_current_palettes():
    """Muestra las paletas actuales de los jugadores"""
    print("🎨 Paletas actuales de los jugadores:")
    print()

    mario_palette = [0x22, 0x16, 0x27, 0x18]
    luigi_palette = [0x22, 0x30, 0x27, 0x19]
    fire_palette = [0x22, 0x37, 0x27, 0x16]

    print("Mario normal:")
    for i, color in enumerate(mario_palette):
        print(f"  Color {i}: {color:02X} → {get_color_info(color)}")

    print()
    print("Luigi:")
    for i, color in enumerate(luigi_palette):
        print(f"  Color {i}: {color:02X} → {get_color_info(color)}")

    print()
    print("Mario/Luigi de Fuego:")
    for i, color in enumerate(fire_palette):
        print(f"  Color {i}: {color:02X} → {get_color_info(color)}")

def search_player_colors_in_rom(rom_data):
    """Busca las paletas de jugadores en la ROM"""
    print("🔍 Buscando PlayerColors en la ROM...")

    # Paleta de Mario
    mario_pattern = bytes([0x22, 0x16, 0x27, 0x18])

    found_offsets = []
    for i in range(len(rom_data) - len(mario_pattern)):
        if rom_data[i:i+len(mario_pattern)] == mario_pattern:
            found_offsets.append(i)
            print(f"📍 Mario palette encontrada en offset: 0x{i:04X}")
            print(f"   Valores: {rom_data[i]:02X} {rom_data[i+1]:02X} {rom_data[i+2]:02X} {rom_data[i+3]:02X}")
            break

    # Buscar también Luigi
    luigi_pattern = bytes([0x22, 0x30, 0x27, 0x19])
    for i in range(len(rom_data) - len(luigi_pattern)):
        if rom_data[i:i+len(luigi_pattern)] == luigi_pattern:
            print(f"📍 Luigi palette encontrada en offset: 0x{i:04X}")
            print(f"   Valores: {rom_data[i]:02X} {rom_data[i+1]:02X} {rom_data[i+2]:02X} {rom_data[i+3]:02X}")
            found_offsets.append(i)
            break

    return found_offsets

def modify_mario_colors():
    """
    Modifica los colores de Mario basándose en las paletas documentadas
    """
    print("🎯 Modificando colores de Mario...")
    print("📖 Basado en PlayerColors del disassembly")

    rom_path = "roms/SuperMarioBros.nes"

    if not os.path.exists(rom_path):
        print(f"❌ Error: ROM no encontrada en {rom_path}")
        return None

    # Crear respaldo
    backup_path = "roms/SuperMarioBros_colors_backup.nes"
    if not os.path.exists(backup_path):
        shutil.copy2(rom_path, backup_path)
        print(f"✅ Respaldo creado: {backup_path}")

    with open(rom_path, 'rb') as f:
        rom_data = bytearray(f.read())

    # Mostrar paletas actuales
    show_current_palettes()
    print()

    # Buscar las paletas en la ROM
    found_offsets = search_player_colors_in_rom(rom_data)

    if not found_offsets:
        print("❌ No se encontraron las paletas de jugadores en la ROM")
        return None

    modifications = []

    # Modificar la paleta de Mario para hacer un cambio visible
    print()
    print("🎨 MODIFICANDO: Cambiando el color dominante de Mario...")

    # Buscar el patrón de Mario
    mario_pattern = bytes([0x22, 0x16, 0x27, 0x18])
    for i in range(len(rom_data) - len(mario_pattern)):
        if rom_data[i:i+len(mario_pattern)] == mario_pattern:
            # Cambiar el color 1 (índice $16, rojo) por verde lima ($30)
            old_color = rom_data[i + 1]
            new_color = 0x30  # Verde lima
            rom_data[i + 1] = new_color
            modifications.append((i + 1, old_color, new_color))

            print(f"📍 Offset 0x{i+1:04X}: {old_color:02X} → {new_color:02X}")
            print(f"   Cambio: {get_color_info(old_color)} → {get_color_info(new_color)}")
            print(f"   🎮 RESULTADO: Mario tendrá overall VERDE en lugar de rojo")
            break

    if modifications:
        output_path = "roms/SuperMarioBros_Mario_Green.nes"
        with open(output_path, 'wb') as f:
            f.write(rom_data)

        print()
        print(f"✅ ROM modificada: {output_path}")
        print(f"📊 Modificaciones: {len(modifications)}")
        print("🎯 CAMBIO ESPECÍFICO: Color dominante de Mario de rojo a verde")
        print("📖 BASADO EN: PlayerColors del disassembly")

        return output_path
    else:
        print("❌ No se pudieron realizar modificaciones")
        return None

if __name__ == "__main__":
    modify_mario_colors()

