import logging
import argparse
import os
from nes import NES
from nes.pycore.system import NES as pyNES
from argparse import ArgumentDefaultsHelpFormatter
from common_help import get_epilog
# from tests.blargg_tests import run_tests

# run_tests()

def main():
    parser = argparse.ArgumentParser(
        description="Run NES emulator with specified ROM",
        formatter_class=ArgumentDefaultsHelpFormatter,
        epilog=get_epilog("main"),
    )
    parser.add_argument("rom_path", help="Path to NES ROM")
    parser.add_argument("--sync-mode", type=int, default=2, help="Sync mode (default: 2)")
    args = parser.parse_args()

    if not os.path.exists(args.rom_path):
        print(f"ROM not found: {args.rom_path}")
        return

    nes = None

    # Mapper 0
    nes = NES(args.rom_path, sync_mode=args.sync_mode)

    # nes.run_frame_headless(run_frames=1)
    # nes.run_frame_headless(run_frames=1)
    # buffer = nes.run_frame_headless(run_frames=1)

    # Python version:
    # nes = pyNES("./roms/Super Mario Bros. (Japan, USA).nes")

    if nes is not None:
        nes.run()

if __name__ == "__main__":
    main()
