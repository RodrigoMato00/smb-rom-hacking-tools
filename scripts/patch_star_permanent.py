#!/usr/bin/env python3
"""
patch_star_invincible.py
Hackea la rutina de colisión Mario-enemigo para que Mario SIEMPRE
sea tratado como 'estrella activa' → toca enemigo = enemigo muere,
Mario nunca recibe daño.

Idea:
En la rutina PlayerEnemyCollision (~$D88A en PRG-ROM),
hay este patrón (según tu desensamblado):

    D88A: LDA StarInvincibleTimer
    D88D: BEQ HandlePECollisions  ; si timer = 0 -> daño normal
    D88F: JMP ShellOrBlockDefeat  ; si no, matar enemigo

Nosotros NOPeamos el BEQ, para que JAMÁS vaya a daño normal.
Entonces SIEMPRE se ejecuta el JMP ShellOrBlockDefeat.

Pasos técnicos:
- Tu ROM es iNES con header 16 bytes, PRG=32KB.
- $C000-$FFFF = banco PRG alto (últimos 16KB del PRG).
- $D88A está en ese banco, offset_local = $D88A - $C000.
- offset_en_archivo = 16(header) + 16KB(banco0) + offset_local.

Después NOPeamos el BEQ en $D88D.

Uso:
  python3 scripts/patch_star_invincible.py                    # Crea nueva ROM con invencibilidad
  python3 scripts/patch_star_invincible.py roms/mi_rom.nes    # Modifica ROM específica
"""

import os
import argparse
from datetime import datetime

# direcciones CPU que nos interesan (de tu desasm)
ADDR_LDA_STAR = 0xD88A  # LDA StarInvincibleTimer
ADDR_BEQ      = 0xD88D  # BEQ HandlePECollisions  (queremos NOP acá)

def cpu_addr_to_file_offset(cpu_addr):
    """
    Convierte dirección CPU ($8000-$FFFF) a offset dentro del .nes,
    asumiendo:
      - header iNES 16 bytes
      - PRG-ROM 32 KB = banco0 ($8000-$BFFF), banco1 ($C000-$FFFF)
      - banco0 va inmediatamente después del header
      - banco1 va después de banco0

    Para direcciones < $C000: usan banco0
    Para direcciones >=$C000: usan banco1
    """
    HEADER_SIZE = 16
    BANK_SIZE   = 16 * 1024  # 16KB

    if cpu_addr < 0x8000 or cpu_addr > 0xFFFF:
        raise ValueError("Dirección fuera de rango PRG-ROM NES estándar")

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
    parser = argparse.ArgumentParser(description="Hackea Super Mario Bros para hacer a Mario invencible permanentemente")
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

    # sanity: chequear cabecera "NES\x1A"
    if rom[0:4] != b"NES\x1a":
        print("❌ ROM no parece iNES válida")
        return

    # calculamos offsets de las instrucciones
    beq_off = cpu_addr_to_file_offset(ADDR_BEQ)

    # Preview antes de parchar (opcional debug para vos):
    # BEQ opcode en 6502 = 0xF0, seguido de 1 byte relativo (salto corto)
    original_beq_opcode = rom[beq_off]
    original_beq_arg    = rom[beq_off+1]
    print(f"Antes del parche en {hex(ADDR_BEQ)}:")
    print(f"  opcode={hex(original_beq_opcode)} arg={hex(original_beq_arg)}")
    # esperamos ver algo tipo F0 xx

    # Parche:
    # Vamos a poner NOP (0xEA) 0xEA en lugar de BEQ rel8
    rom[beq_off]   = 0xEA  # NOP
    rom[beq_off+1] = 0xEA  # NOP
    print("Aplicado parche: BEQ -> NOP,NOP")

    # Guardar ROM modificada
    if create_new:
        # Crear nueva ROM con timestamp
        ts = datetime.now().strftime("%Y%m%d_%H%M%S")
        out_path = f"roms/SuperMarioBros_star_infinite_{ts}.nes"
        with open(out_path, "wb") as f:
            f.write(rom)
        print("✅ ROM hackeada escrita en:", out_path)
    else:
        # Sobreescribir ROM existente
        with open(rom_path, "wb") as f:
            f.write(rom)
        print("✅ ROM hackeada modificada:", rom_path)

    print("➡ Esta ROM debería hacer que, al tocar un Goomba, el Goomba muera siempre,")
    print("   y Mario no reciba daño nunca (efecto estrella permanente).")

if __name__ == "__main__":
    main()
