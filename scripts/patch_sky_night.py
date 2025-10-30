#!/usr/bin/env python3
"""
patch_sky_night.py
Modify Super Mario Bros sky background to a "night" effect by editing BackgroundColors.

Based on assembler analysis:
BackgroundColors at CPU $85cf: 22 22 0f 0f
- The first two $22 are the sky colors
- Replace both $22 with $0f for a night effect

Usage:
  python3 scripts/patch_sky_night.py                    # Create new ROM with night effect
  python3 scripts/patch_sky_night.py roms/my_rom.nes    # Modify a specific ROM
"""

import os
import argparse
from datetime import datetime
from argparse import ArgumentDefaultsHelpFormatter
from common_help import get_epilog

def cpu_addr_to_file_offset(cpu_addr):
    """Convert CPU address to file offset"""
    HEADER_SIZE = 16
    BANK_SIZE = 16 * 1024  # 16 KB

    if cpu_addr < 0x8000 or cpu_addr > 0xFFFF:
        raise ValueError("Address out of PRG-ROM range")

    if cpu_addr < 0xC000:
        # low bank
        offset_in_bank = cpu_addr - 0x8000
        file_off = HEADER_SIZE + offset_in_bank
    else:
        # high bank
        offset_in_bank = cpu_addr - 0xC000
        file_off = HEADER_SIZE + BANK_SIZE + offset_in_bank

    return file_off

def main():
    parser = argparse.ArgumentParser(
        description="Modify SMB sky palette for night effect",
        formatter_class=ArgumentDefaultsHelpFormatter,
        epilog=get_epilog("patch_sky_night"),
    )
    parser.add_argument("rom_path", nargs="?", default=None,
                        help="Path to NES ROM (default uses SuperMarioBros.nes and creates a new ROM)")
    args = parser.parse_args()

    # Determinar qué ROM usar
    if args.rom_path is None:
        rom_path = "roms/SuperMarioBros.nes"
        create_new = True
    else:
        rom_path = args.rom_path
        create_new = False

    if not os.path.exists(rom_path):
        print(f"Not found: {rom_path}")
        return

    with open(rom_path, "rb") as f:
        rom = bytearray(f.read())

    if rom[0:4] != b"NES\x1a":
        print("ROM does not look like a valid iNES file")
        return

    # BackgroundColors at 0x85cf: 22 22 0f 0f
    # The first two $22 are the sky colors
    BACKGROUND_COLORS_ADDR = 0x85cf

    # Convert to file offset
    bg_colors_off = cpu_addr_to_file_offset(BACKGROUND_COLORS_ADDR)

    print(f"BackgroundColors at file offset 0x{bg_colors_off:06X} (CPU $85cf)")

    # Read current colors
    current_colors = rom[bg_colors_off:bg_colors_off+4]
    print(f"Current colors: {' '.join(f'{b:02X}' for b in current_colors)}")

    # Change BOTH sky colors to black
    original_sky1 = rom[bg_colors_off]
    original_sky2 = rom[bg_colors_off + 1]
    new_sky_color = 0x0f

    rom[bg_colors_off] = new_sky_color      # Primer cielo: $22 → $0f
    rom[bg_colors_off + 1] = new_sky_color  # Segundo cielo: $22 → $0f

    print("Changes applied:")
    print(f"   First sky: 0x{original_sky1:02X} → 0x{new_sky_color:02X}")
    print(f"   Second sky: 0x{original_sky2:02X} → 0x{new_sky_color:02X}")

    # Save modified ROM
    if create_new:
        # Create new ROM with timestamp
        ts = datetime.now().strftime("%Y%m%d_%H%M%S")
        out_path = f"roms/SuperMarioBros_sky_night_{ts}.nes"
        with open(out_path, "wb") as f:
            f.write(rom)
        print(f"New ROM created: {out_path}")
    else:
        # Overwrite existing ROM
        with open(rom_path, "wb") as f:
            f.write(rom)
        print(f"ROM modified: {rom_path}")

    print("1-1 sky should now be dark.")

if __name__ == "__main__":
    main()
