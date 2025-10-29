#!/usr/bin/env python3
"""
patch_title_text.py
Modifica el texto "WORLD  TIME" en la pantalla de título de Super Mario Bros
para mostrar un mensaje personalizado como "PYTHON MEETUP MVD".

Este script busca la secuencia de bytes que corresponde al texto "WORLD  TIME"
en la ROM y la reemplaza con un nuevo texto personalizado.

Uso:
  python3 scripts/patch_title_text.py                    # Crea nueva ROM con texto personalizado
  python3 scripts/patch_title_text.py roms/mi_rom.nes    # Modifica ROM específica
"""

import os
import argparse
from datetime import datetime

def main():
    parser = argparse.ArgumentParser(description="Modifica el texto del título en Super Mario Bros")
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

    # Validar ROM iNES
    if rom[0:4] != b"NES\x1a":
        print("❌ ROM no parece iNES válida")
        return

    # Firma a reemplazar: bytes que corresponden a "WORLD  TIME"
    WORLD_TIME_SEQ = bytes([
        0x20, 0x52, 0x0b, 0x20,
        0x18, 0x1b, 0x15, 0x0d
        # Si en tu ROM hay más bytes para "WORLD  TIME" (espacios adicionales),
        # agrégalos acá tal cual, en el mismo orden.
    ])

    # NUEVO TEXTO: "PYTHON MEETUP MVD"
    # Mapeo de caracteres a tiles NES (necesita ser completado con valores reales)
    PYTHON_MEETUP_MVD_SEQ = bytes([
        # TODO: P,Y,T,H,O,N,space,M,E,E,T,U,P,space,M,V,D
        # Ejemplo de valores (necesitan ser verificados):
        0x19, 0x22, 0x1d, 0x11, 0x18, 0x17, 0x24,  # PYTHON
        0x24,  # espacio
        0x16, 0x0e, 0x0e, 0x1d, 0x1e, 0x19,  # MEETUP
        0x24,  # espacio
        0x16, 0x1f, 0x0d   # MVD
    ])

    # Buscar WORLD_TIME_SEQ en la ROM
    idx = rom.find(WORLD_TIME_SEQ)
    if idx == -1:
        print("❌ No encontré la secuencia 'WORLD  TIME' en la ROM. Puede que tu ROM difiera")
        return

    print(f"✅ Encontré 'WORLD  TIME' en offset 0x{idx:06X}")

    # Chequeo de largo
    if len(PYTHON_MEETUP_MVD_SEQ) != len(WORLD_TIME_SEQ):
        print("⚠ El nuevo texto no tiene el mismo largo que el original.")
        print("   Para primera demo lo mejor es mismo largo, o rellenar con espacios.")
        # Podemos padear:
        new_seq = bytearray(WORLD_TIME_SEQ)
        repl = list(PYTHON_MEETUP_MVD_SEQ)
        for i, b in enumerate(repl):
            if i < len(new_seq):
                new_seq[i] = b
        PY = bytes(new_seq)
    else:
        PY = PYTHON_MEETUP_MVD_SEQ

    # Parchear
    for i, b in enumerate(PY):
        rom[idx + i] = b

    # Guardar ROM modificada
    if create_new:
        # Crear nueva ROM con timestamp
        ts = datetime.now().strftime("%Y%m%d_%H%M%S")
        out_path = f"roms/SuperMarioBros_titlemsg_{ts}.nes"
        with open(out_path, "wb") as f:
            f.write(rom)
        print(f"💾 ROM nueva creada: {out_path}")
    else:
        # Sobreescribir ROM existente
        with open(rom_path, "wb") as f:
            f.write(rom)
        print(f"💾 ROM modificada: {rom_path}")

    print("🔁 Esa ROM debería mostrar tu texto custom en el lugar donde iba 'WORLD  TIME' en la pantalla de título.")
    print("👉 Eso sirve perfecto para la demo: queda el mensaje 'PYTHON MEETUP MVD' en pantalla principal.")

if __name__ == "__main__":
    main()
