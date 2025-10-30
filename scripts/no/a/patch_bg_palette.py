#!/usr/bin/env python3
"""
patch_bg_palette.py
Objetivo: oscurecer el cielo / ambiente del nivel estilo "modo noche"
sin tocar Mario ni enemigos.

Cómo funciona:
1. Busca bloques de 16 bytes que tengan pinta de paletas de background:
   - 4 subpaletas x 4 colores = 16 bytes
   - patrón común en SMB: cada subpaleta termina en 0x0F (negro)
   - el primer color de cada subpaleta suele repetirse (cielo base tipo 0x22)

2. Modo scan:
   python3 patch_bg_palette.py --scan

   -> imprime offsets de ROM donde parece haber paletas BG.

3. Modo patch:
   python3 patch_bg_palette.py --orig 0x22 --new 0x02
   Esto reemplaza 0x22 por 0x02 dentro de esos bloques candidatos
   y escribe una ROM nueva (oscurece el fondo tipo noche).

Truco:
 - 0x22 es azul/celeste claro típico cielo
 - 0x02 es azul más oscuro
 - 0x0F es negro

Podés ir cambiando --new según lo que quieras (0x0F = negro total).
"""

import os
import argparse
from datetime import datetime

ROM_IN = "roms/SuperMarioBros.nes"

def looks_like_bg_palette(block):
    """
    block: 16 bytes
    Heurística muy simple:
    - Cada subpaleta de 4 termina con algo oscuro tipo 0x0F (muy común en SMB)
    - El primer byte de cada subpaleta muchas veces se repite entre subpaletas (ej 0x22,0x22,0x22,...)
    Esto no es perfecto pero suele clavar las paletas del cielo/suelo.
    """
    if len(block) != 16:
        return False

    subs = [block[i:i+4] for i in range(0,16,4)]
    # chequeo: último color de cada subpaleta es 0x0F o algo <0x10 (muy oscuro)
    for sub in subs:
        if len(sub) < 4: return False
        if sub[3] not in (0x0F, 0x00, 0x10, 0x20, 0x30):
            # 0x0F es super típico, pero dejo tolerancia
            return False

    # chequeo: primer byte de cada subpaleta suele ser igual o muy parecido
    firsts = [sub[0] for sub in subs]
    # tolero variación de +/-1 entre ellos
    if not (max(firsts) - min(firsts) <= 2):
        return False

    return True

def scan_palettes(rom_bytes):
    cands = []
    for off in range(len(rom_bytes)-16):
        block = rom_bytes[off:off+16]
        if looks_like_bg_palette(block):
            cands.append((off, block))
    return cands

def patch_palettes(rom_bytes, orig_val, new_val, candidates):
    rom_mod = bytearray(rom_bytes)
    hits = 0
    for off, block in candidates:
        new_block = bytearray(block)
        changed = False
        for i,b in enumerate(new_block):
            if b == orig_val:
                new_block[i] = new_val
                changed = True
        if changed:
            rom_mod[off:off+16] = new_block
            hits += 1
    return rom_mod, hits

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--scan", action="store_true",
                    help="solo listar posibles paletas BG")
    ap.add_argument("--orig", help="valor original (ej 0x22)")
    ap.add_argument("--new",  help="valor nuevo (ej 0x02)")
    args = ap.parse_args()

    if not os.path.exists(ROM_IN):
        print(f"❌ No se encontró {ROM_IN}")
        return

    with open(ROM_IN,"rb") as f:
        rom = f.read()

    cands = scan_palettes(rom)

    print("🔎 Posibles paletas BG encontradas:")
    for off, block in cands[:20]:  # mostramos primeras 20 por prolijidad
        pretty = " ".join(f"{b:02X}" for b in block)
        print(f"  offset 0x{off:06X}: {pretty}")
    print(f"Total candidatos: {len(cands)}")
    print()

    if args.scan:
        # solo exploración, no parcheamos
        return

    # si no es --scan, esperamos --orig y --new
    if args.orig is None or args.new is None:
        print("ℹ Si querés parchear, usá --orig 0x22 --new 0x02 (por ejemplo)")
        return

    def parse_hexish(s):
        s = s.strip().lower()
        if s.startswith("0x"):
            return int(s,16)
        return int(s,16)  # igual interpretamos hex
    orig_val = parse_hexish(args.orig)
    new_val  = parse_hexish(args.new)

    rom_mod, hits = patch_palettes(rom, orig_val, new_val, cands)

    ts = datetime.now().strftime("%Y%m%d_%H%M%S")
    out_path = f"roms/SuperMarioBros_bgpatch_{orig_val:02X}_to_{new_val:02X}_{ts}.nes"
    with open(out_path,"wb") as f:
        f.write(rom_mod)

    print(f"✅ ROM parcheada escrita en: {out_path}")
    print(f"   Reemplazos hechos en {hits} bloques de paletas.")
    print("👉 Probá esa ROM en el emulador: si el cielo de 1-1 está oscuro tipo 'nivel 2', ganamos.")
    print("   Si cambió otra cosa rara (suelo raro, etc.), probamos otro new_val (0x0F negro total, 0x02 azul oscuro, 0x10 violeta oscuro NES).")

if __name__ == "__main__":
    main()
