#!/usr/bin/env python3
import os

ROM_IN = "roms/SuperMarioBros.nes"

WORLD_TIME_LEN = 16  # read 16 bytes around for context

# Pattern from disassembly: sequence for "WORLD  TIME"
WORLD_TIME_SEQ = bytes([
    0x20, 0x52, 0x0b, 0x20,
    0x18, 0x1b, 0x15, 0x0d
])

def main():
    if not os.path.exists(ROM_IN):
        print("Base ROM not found.")
        return

    with open(ROM_IN, "rb") as f:
        rom = f.read()

    idx = rom.find(WORLD_TIME_SEQ)
    if idx == -1:
        print("Sequence 'WORLD  TIME' not found in this ROM.")
        return

    print(f"'WORLD  TIME' found at offset 0x{idx:06X}")
    # show some bytes before/after to inspect if text is longer
    start = max(0, idx - 8)
    end   = idx + 8 + WORLD_TIME_LEN
    snippet = rom[start:end]

    print(f"\nRaw context (offset 0x{start:06X} .. 0x{end:06X}):")
    # print hex rows for inspection
    for i in range(start, end, 16):
        chunk = rom[i:i+16]
        hexline = " ".join(f"{b:02X}" for b in chunk)
        print(f"0x{i:06X} : {hexline}")

    print("\nExact bytes of WORLD_TIME_SEQ:")
    print(" ".join(f"{b:02X}" for b in WORLD_TIME_SEQ))

if __name__ == "__main__":
    main()
