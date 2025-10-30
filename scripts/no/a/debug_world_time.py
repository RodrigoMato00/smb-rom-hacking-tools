#!/usr/bin/env python3
import os

ROM_IN = "roms/SuperMarioBros.nes"

WORLD_TIME_LEN = 16  # vamos a leer 16 bytes alrededor para contexto

# Este patrón lo sacamos de tu desasm. Es la secuencia comentada ;"WORLD  TIME"
WORLD_TIME_SEQ = bytes([
    0x20, 0x52, 0x0b, 0x20,
    0x18, 0x1b, 0x15, 0x0d
])

def main():
    if not os.path.exists(ROM_IN):
        print("❌ No se encontró la ROM base.")
        return

    with open(ROM_IN, "rb") as f:
        rom = f.read()

    idx = rom.find(WORLD_TIME_SEQ)
    if idx == -1:
        print("❌ No encontré la secuencia 'WORLD  TIME' en esta ROM.")
        return

    print(f"✅ 'WORLD  TIME' encontrado en offset 0x{idx:06X}")
    # mostrar un poco antes y después para ver si el texto es más largo
    start = max(0, idx - 8)
    end   = idx + 8 + WORLD_TIME_LEN
    snippet = rom[start:end]

    print(f"\nContexto crudo (offset 0x{start:06X} .. 0x{end:06X}):")
    # imprimimos en filas hex+ascii fake para inspección
    rel = 0
    for i in range(start, end, 16):
        chunk = rom[i:i+16]
        hexline = " ".join(f"{b:02X}" for b in chunk)
        print(f"0x{i:06X} : {hexline}")
        rel += 16

    print("\nBytes exactos de la secuencia WORLD_TIME_SEQ:")
    print(" ".join(f"{b:02X}" for b in WORLD_TIME_SEQ))

if __name__ == "__main__":
    main()
