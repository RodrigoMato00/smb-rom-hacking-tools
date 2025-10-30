#!/usr/bin/env python3
"""
Test a single color in Mario's palette by replacing the dominant color
and writing a test ROM.
Example: python3 scripts/test_one_color.py 0x30
"""

import os
import sys
import shutil

def modify_mario_color(color_hex):
    """
    Modify Mario's dominant color to the specified NES palette index.
    """
    rom_path = "roms/SuperMarioBros.nes"

    if not os.path.exists(rom_path):
        print(f"Error: ROM not found at {rom_path}")
        return None

    with open(rom_path, 'rb') as f:
        rom_data = bytearray(f.read())

    # Find Mario palette and change the 2nd byte (dominant color)
    mario_pattern = bytes([0x22, 0x16, 0x27, 0x18])

    modified = False
    for i in range(len(rom_data) - len(mario_pattern)):
        if rom_data[i:i+len(mario_pattern)] == mario_pattern:
            old_color = rom_data[i + 1]
            rom_data[i + 1] = color_hex
            modified = True

            print(f"Offset 0x{i+1:04X}: {old_color:02X} -> {color_hex:02X}")
            print("   Change: Mario dominant color")
            break

    if not modified:
        print("Mario palette not found in ROM")
        return None

    output_path = "roms/SuperMarioBros_test.nes"
    with open(output_path, 'wb') as f:
        f.write(rom_data)

    print(f"Modified ROM: {output_path}")
    print(f"Tested color: 0x{color_hex:02X}")
    print()
    print("Now run the emulator pointing to this ROM to verify the color")

    return output_path

def main():
    if len(sys.argv) != 2:
        print("Usage: python3 scripts/test_one_color.py <color_hex>")
        print()
        print("Examples:")
        print("  python3 scripts/test_one_color.py 0x30  # Lime green")
        print("  python3 scripts/test_one_color.py 0x37  # Yellow")
        print("  python3 scripts/test_one_color.py 0x18  # Blue")
        print("  python3 scripts/test_one_color.py 0x16  # Red (original)")
        print()
        print("Suggested colors:")
        print("  0x16 - Red")
        print("  0x30 - Lime green")
        print("  0x18 - Blue")
        print("  0x37 - Yellow")
        print("  0x29 - Orange")
        print("  0x0F - Black")
        print("  0x22 - Beige")
        sys.exit(1)

    color_str = sys.argv[1]

    # Strip 0x prefix if present
    if color_str.startswith('0x') or color_str.startswith('0X'):
        color_str = color_str[2:]

    try:
        color_hex = int(color_str, 16)
    except ValueError:
        print(f"Error: '{color_str}' is not a valid hex value")
        sys.exit(1)

    if not (0 <= color_hex <= 0xFF):
        print(f"Error: '{color_hex}' must be between 0x00 and 0xFF")
        sys.exit(1)

    print(f"Testing color: 0x{color_hex:02X}")
    print()

    modify_mario_color(color_hex)

if __name__ == "__main__":
    main()

