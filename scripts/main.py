import logging
import argparse
import os
from nes import NES
from nes.pycore.system import NES as pyNES
#from tests.blargg_tests import run_tests

#run_tests()

def main():
    parser = argparse.ArgumentParser(description="Ejecutar emulador NES con ROM especificada")
    parser.add_argument("rom_path", help="Ruta a la ROM de NES")
    parser.add_argument("--sync-mode", type=int, default=2, help="Modo de sincronización (default: 2)")
    args = parser.parse_args()

    if not os.path.exists(args.rom_path):
        print(f"❌ No se encontró la ROM: {args.rom_path}")
        return

    nes = None

    # Mapper 0
    nes = NES(args.rom_path, sync_mode=args.sync_mode)

    #nes.run_frame_headless(run_frames=1)
    #nes.run_frame_headless(run_frames=1)
    #buffer = nes.run_frame_headless(run_frames=1)

    #python version:
    #nes = pyNES("./roms/Super Mario Bros. (Japan, USA).nes")

    if nes is not None:
        nes.run()

if __name__ == "__main__":
    main()
