#!/usr/bin/env python3
"""
patch_title_message.py
Modify the title screen text "WORLD  TIME" in Super Mario Bros to display a custom message
(e.g., "PYTHON MEETUP MVD").

This script finds the byte sequence corresponding to "WORLD  TIME" and replaces it
with a new custom sequence.

Usage:
  python3 scripts/patch_title_message.py                    # Create new ROM with custom title
  python3 scripts/patch_title_message.py roms/my_rom.nes    # Modify a specific ROM
"""

import os
import argparse
from datetime import datetime
from argparse import ArgumentDefaultsHelpFormatter
from common_help import get_epilog


def main():
    parser = argparse.ArgumentParser(
        description="Modify the title screen text in Super Mario Bros",
        formatter_class=ArgumentDefaultsHelpFormatter,
        epilog=get_epilog("patch_title_message"),
    )
    parser.add_argument("rom_path", nargs="?", default=None,
                        help="Path to NES ROM (default uses SuperMarioBros.nes and creates a new ROM)")
    args = parser.parse_args()

    # Determine ROM to use
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

    # Validate iNES ROM
    if rom[0:4] != b"NES\x1a":
        print("ROM does not look like a valid iNES file")
        return

    # Signature to replace: bytes corresponding to "WORLD  TIME"
    WORLD_TIME_SEQ = bytes([
        0x20, 0x52, 0x0b, 0x20,
        0x18, 0x1b, 0x15, 0x0d
        # If your ROM has extra bytes for "WORLD  TIME" (additional spaces),
        # add them here in the same order.
    ])

    # NEW TEXT: "PYTHON MEETUP MVD"
    # Character-to-NES-tiles mapping (verify values for your ROM)
    PYTHON_MEETUP_MVD_SEQ = bytes([
        # P,Y,T,H,O,N,space,M,E,E,T,U,P,space,M,V,D
        # Example values (need verification):
        0x19, 0x22, 0x1d, 0x11, 0x18, 0x17, 0x24,  # PYTHON
        0x24,  # space
        0x16, 0x0e, 0x0e, 0x1d, 0x1e, 0x19,        # MEETUP
        0x24,  # space
        0x16, 0x1f, 0x0d                           # MVD
    ])

    # Find WORLD_TIME_SEQ in ROM
    idx = rom.find(WORLD_TIME_SEQ)
    if idx == -1:
        print("Could not find 'WORLD  TIME' sequence in the ROM. Your ROM may differ")
        return

    print(f"Found 'WORLD  TIME' at offset 0x{idx:06X}")

    # Length check
    if len(PYTHON_MEETUP_MVD_SEQ) != len(WORLD_TIME_SEQ):
        print("New text does not have the same length as the original.")
        print("For a first demo, use same length or pad with spaces.")
        # Pad to same length:
        new_seq = bytearray(WORLD_TIME_SEQ)
        repl = list(PYTHON_MEETUP_MVD_SEQ)
        for i, b in enumerate(repl):
            if i < len(new_seq):
                new_seq[i] = b
        PY = bytes(new_seq)
    else:
        PY = PYTHON_MEETUP_MVD_SEQ

    # Patch
    for i, b in enumerate(PY):
        rom[idx + i] = b

    # Save modified ROM
    if create_new:
        # Create new ROM with timestamp
        ts = datetime.now().strftime("%Y%m%d_%H%M%S")
        out_path = f"roms/SuperMarioBros_titlemsg_{ts}.nes"
        with open(out_path, "wb") as f:
            f.write(rom)
        print(f"New ROM created: {out_path}")
    else:
        # Overwrite existing ROM
        with open(rom_path, "wb") as f:
            f.write(rom)
        print(f"ROM modified: {rom_path}")

    print("That ROM should show your custom text where 'WORLD  TIME' was on the title screen.")
    print("Good for demos, e.g., 'PYTHON MEETUP MVD' in the main title.")


if __name__ == "__main__":
    main()
