#!/usr/bin/env python3
"""
patch_star_permanent.py
Hack the Mario-enemy collision routine so Mario is ALWAYS treated as having star power:
- touching any enemy kills it
- Mario never takes damage

Idea (from your disassembly):
At PlayerEnemyCollision (~$D88A in PRG-ROM):

    D88A: LDA StarInvincibleTimer
    D88D: BEQ HandlePECollisions  ; if timer = 0 -> normal damage
    D88F: JMP ShellOrBlockDefeat  ; else, kill enemy

We NOP the BEQ at $D88D so it never branches to normal damage, always jumping to defeat.

Usage:
  python3 scripts/patch_star_permanent.py                    # Create new ROM with invincibility
  python3 scripts/patch_star_permanent.py roms/my_rom.nes    # Modify a specific ROM
"""

import os
import argparse
from datetime import datetime
from argparse import ArgumentDefaultsHelpFormatter
from common_help import get_epilog

# CPU addresses we care about
ADDR_LDA_STAR = 0xD88A  # LDA StarInvincibleTimer
ADDR_BEQ      = 0xD88D  # BEQ HandlePECollisions  (we NOP here)

def cpu_addr_to_file_offset(cpu_addr):
    """
    Convert CPU address ($8000-$FFFF) to .nes file offset, assuming:
      - iNES 16-byte header
      - PRG-ROM 32 KB = bank0 ($8000-$BFFF), bank1 ($C000-$FFFF)
      - bank0 follows the header; bank1 follows bank0

    Addresses < $C000 use bank0; >= $C000 use bank1.
    """
    HEADER_SIZE = 16
    BANK_SIZE   = 16 * 1024  # 16 KB

    if cpu_addr < 0x8000 or cpu_addr > 0xFFFF:
        raise ValueError("Address out of standard NES PRG-ROM range")

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
        description="Hack SMB to make Mario permanently invincible",
        formatter_class=ArgumentDefaultsHelpFormatter,
        epilog=get_epilog("patch_star_permanent"),
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

    # sanity: chequear cabecera "NES\x1A"
    if rom[0:4] != b"NES\x1a":
        print("ROM does not look like a valid iNES file")
        return

    # calculamos offsets de las instrucciones
    beq_off = cpu_addr_to_file_offset(ADDR_BEQ)

    # Preview antes de parchar (opcional debug para vos):
    original_beq_opcode = rom[beq_off]
    original_beq_arg    = rom[beq_off+1]
    print(f"Before patch at {hex(ADDR_BEQ)}:")
    print(f"  opcode={hex(original_beq_opcode)} arg={hex(original_beq_arg)}")

    # Parche:
    rom[beq_off]   = 0xEA  # NOP
    rom[beq_off+1] = 0xEA  # NOP
    print("Applied patch: BEQ -> NOP,NOP")

    # Guardar ROM modificada
    if create_new:
        # Crear nueva ROM con timestamp
        ts = datetime.now().strftime("%Y%m%d_%H%M%S")
        out_path = f"roms/SuperMarioBros_star_infinite_{ts}.nes"
        with open(out_path, "wb") as f:
            f.write(rom)
        print("Hacked ROM written to:", out_path)
    else:
        # Sobreescribir ROM existente
        with open(rom_path, "wb") as f:
            f.write(rom)
        print("Hacked ROM modified:", rom_path)

    print("With this ROM, touching a Goomba should always kill it,")
    print("and Mario should not take damage (permanent star effect).")

if __name__ == "__main__":
    main()
