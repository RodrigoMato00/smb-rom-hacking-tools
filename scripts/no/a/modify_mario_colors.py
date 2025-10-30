#!/usr/bin/env python3
"""
Modify Mario colors in Super Mario Bros based on documented NES palettes.
"""

import os
import shutil

# NES standard palette (NTSC) - approximate color names
NES_PALETTE = {
    0x22: (252, 152, 56, "Beige/Skin"),
    0x16: (152, 8, 8, "Red"),
    0x27: (88, 56, 0, "Dark Brown"),
    0x18: (8, 56, 152, "Blue"),
    0x30: (152, 248, 24, "Lime Green"),
    0x19: (88, 248, 152, "Light Green"),
    0x37: (248, 248, 152, "Yellow"),
}

def get_color_info(index):
    """Return color info string for a NES palette index."""
    if index in NES_PALETTE:
        rgb = NES_PALETTE[index][:3]
        name = NES_PALETTE[index][3]
        return f"{rgb} ({name})"
    return f"NES color {index:02X}"

def show_current_palettes():
    """Print current player palettes."""
    print("Current player palettes:")
    print()

    mario_palette = [0x22, 0x16, 0x27, 0x18]
    luigi_palette = [0x22, 0x30, 0x27, 0x19]
    fire_palette = [0x22, 0x37, 0x27, 0x16]

    print("Mario (normal):")
    for i, color in enumerate(mario_palette):
        print(f"  Color {i}: {color:02X} -> {get_color_info(color)}")

    print()
    print("Luigi (normal):")
    for i, color in enumerate(luigi_palette):
        print(f"  Color {i}: {color:02X} -> {get_color_info(color)}")

    print()
    print("Mario/Luigi (fire):")
    for i, color in enumerate(fire_palette):
        print(f"  Color {i}: {color:02X} -> {get_color_info(color)}")

def search_player_colors_in_rom(rom_data):
    """Search player palettes in ROM and print first matches."""
    print("Searching PlayerColors in ROM...")

    mario_pattern = bytes([0x22, 0x16, 0x27, 0x18])

    found_offsets = []
    for i in range(len(rom_data) - len(mario_pattern)):
        if rom_data[i:i+len(mario_pattern)] == mario_pattern:
            found_offsets.append(i)
            print(f"Mario palette found at offset: 0x{i:04X}")
            print(f"   Values: {rom_data[i]:02X} {rom_data[i+1]:02X} {rom_data[i+2]:02X} {rom_data[i+3]:02X}")
            break

    luigi_pattern = bytes([0x22, 0x30, 0x27, 0x19])
    for i in range(len(rom_data) - len(luigi_pattern)):
        if rom_data[i:i+len(luigi_pattern)] == luigi_pattern:
            print(f"Luigi palette found at offset: 0x{i:04X}")
            print(f"   Values: {rom_data[i]:02X} {rom_data[i+1]:02X} {rom_data[i+2]:02X} {rom_data[i+3]:02X}")
            found_offsets.append(i)
            break

    return found_offsets

def modify_mario_colors():
    """Modify Mario colors by changing the dominant color to lime green."""
    print("Modifying Mario colors...")
    print("Based on PlayerColors from disassembly")

    rom_path = "roms/SuperMarioBros.nes"

    if not os.path.exists(rom_path):
        print(f"Error: ROM not found at {rom_path}")
        return None

    # Create backup
    backup_path = "roms/SuperMarioBros_colors_backup.nes"
    if not os.path.exists(backup_path):
        shutil.copy2(rom_path, backup_path)
        print(f"Backup created: {backup_path}")

    with open(rom_path, 'rb') as f:
        rom_data = bytearray(f.read())

    show_current_palettes()
    print()

    found_offsets = search_player_colors_in_rom(rom_data)

    if not found_offsets:
        print("Player palettes not found in ROM")
        return None

    modifications = []

    print()
    print("APPLYING: Change Mario dominant color to lime green...")

    mario_pattern = bytes([0x22, 0x16, 0x27, 0x18])
    for i in range(len(rom_data) - len(mario_pattern)):
        if rom_data[i:i+len(mario_pattern)] == mario_pattern:
            old_color = rom_data[i + 1]
            new_color = 0x30  # lime green
            rom_data[i + 1] = new_color
            modifications.append((i + 1, old_color, new_color))

            print(f"Offset 0x{i+1:04X}: {old_color:02X} -> {new_color:02X}")
            print(f"   Change: {get_color_info(old_color)} -> {get_color_info(new_color)}")
            print(f"   RESULT: Mario dominant color changed to green")
            break

    if modifications:
        output_path = "roms/SuperMarioBros_Mario_Green.nes"
        with open(output_path, 'wb') as f:
            f.write(rom_data)

        print()
        print(f"Modified ROM: {output_path}")
        print(f"Modifications: {len(modifications)}")
        print("SPECIFIC CHANGE: Mario dominant color red -> green")
        print("SOURCE: PlayerColors from disassembly")

        return output_path
    else:
        print("No modifications could be applied")
        return None

if __name__ == "__main__":
    modify_mario_colors()

