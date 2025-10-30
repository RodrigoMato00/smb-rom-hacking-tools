# Comandos de Ejecución de ROMs (Demos)

Este documento lista comandos listos para ejecutar ROMs ya generadas, usando rutas relativas y activando el entorno una sola vez al inicio.

Notas:
- Entorno: venv de Python 3.13 del proyecto (`venv`)
- Emulador: `scripts/main.py` (HUD desactivado)
- No se ejecutan scripts de parcheo: sólo se abren ROMs ya generadas

---

## Preparación (una vez por terminal)

```bash
cd /Users/rodrigomato/charla
source venv/bin/activate
```

### (Opcional) Corregir paquete "nes" si se mezcló con el de PyPI

```bash
pip uninstall -y nes mpi4py
pip install -e ./pyntendo-repo
```

---

## ROM base (control)

```bash
python scripts/main.py \
  roms/SuperMarioBros.nes
```

---

## Demo Goomba (evolución visual)

Orden sugerido: 1) CHR (más roto → menos roto), 2) Variantes de Goomba (paleta/color)

### 1) CHR — de MÁS modificado → MENOS modificado

```bash

# Rango extremo (muy roto)
python scripts/main.py \
  roms/SuperMarioBros_CHRrange_100_100.nes

# Otros rangos (de muy roto a menos roto)
python scripts/main.py \
  roms/SuperMarioBros_CHRrange_100_80.nes
python scripts/main.py \
  roms/SuperMarioBros_CHRrange_180_40.nes
python scripts/main.py \
  roms/SuperMarioBros_CHRrange_20_20.nes
python scripts/main.py \
  roms/SuperMarioBros_CHRrange_1C0_20.nes
python scripts/main.py \
  roms/SuperMarioBros_CHRrange_1E0_08.nes
python scripts/main.py \
  roms/SuperMarioBros_CHRrange_1E0_10.nes
python scripts/main.py \
  roms/SuperMarioBros_CHRrange_1E0_20.nes
python scripts/main.py \
  roms/SuperMarioBros_CHRrange_1F0_10.nes

# Upper / Quarter
python scripts/main.py \
  roms/SuperMarioBros_CHRupper_20251028_043310.nes
python scripts/main.py \
  roms/SuperMarioBros_CHRquarter_20251028_043552.nes

# Goomba CHR corrupto (localizado)
python scripts/main.py \
  roms/SuperMarioBros_GoombaCHR_20251028_033211.nes

# Iteraciones intermedias (parciales)
python scripts/main.py \
  roms/SuperMarioBros_goombaPatched_29_20251028_002817.nes
python scripts/main.py \
  roms/SuperMarioBros_goombaTry2_29_20251028_001049.nes

# Serie 29 (gradualidad, menos roto)
python scripts/main.py \
  roms/SuperMarioBros_goomba_29_20251027_233500.nes
python scripts/main.py \
  roms/SuperMarioBros_goomba_29_20251027_234257.nes
python scripts/main.py \
  roms/SuperMarioBros_goomba_29_20251027_235710.nes
python scripts/main.py \
  roms/SuperMarioBros_goomba_29_20251028_000511.nes
```

### 2) Variantes de Goomba — Paleta / Color / Fuerza

```bash
# Goomba base mod
python scripts/main.py \
  roms/goomba/SuperMarioBros_goomba.nes

# Ojos (variantes)
python scripts/main.py \
  roms/goomba/SuperMarioBros_CHR_070_001_20251028_215831-Ojos.nes
python scripts/main.py \
  roms/goomba/SuperMarioBros_CHR_071_001_20251028_215921-Ojos.nes

# Alterna patas/pico (izq-der / der-izq)
python scripts/main.py \
  roms/goomba/SuperMarioBros_CHR_072_001_20251028_215953-AlternaIzquieraDerechaPatasPico.nes
python scripts/main.py \
  roms/goomba/SuperMarioBros_CHR_073_001_20251028_220023AlternaDerechaIzquierdaPatasPico.nes
```

---

## Cielos: Night

```bash

python scripts/main.py \
  roms/SuperMarioBros_sky_final_20251029_000501.nes

```

---

## Demo Mario Invencible (estrella permanente)

```bash
# ROM invencible (usada también para RL)
python scripts/main.py \
  roms/SuperMarioBros_star_infinite_20251028_231603.nes
```

---

## Demo Título Personalizado ("PYTHON MEETUP MVD")

```bash
# Ajustá el timestamp al que generaste
python scripts/main.py \
  roms/SuperMarioBros_titlemsg_20251029_011904.nes
```

---

## Variantes de color de Mario (Wario / Verde claro)

```bash
# Wario (amarillo/violeta aprox.)
python scripts/main.py \
  roms/SuperMarioBros_mario_full_22_30_0F_15_20251027_231231.nes

# Verde claro
python scripts/main.py \
  roms/SuperMarioBros_Mario_Green.nes

# Zombie
python scripts/main.py \
  roms/SuperMarioBros_mario_full_22_18_0F_29_20251027_232514.nes

# verde oscuro
python scripts/main.py \
  roms/SuperMarioBros_test.nes

# blanco
python scripts/main.py \
  roms/SuperMarioBros_mario_30_20251027_230401.nes
```

---

## Otras ROMs útiles (CHR / colores)

```bash
# Backups de colores (si querés comparar)
python scripts/main.py \
  roms/SuperMarioBros_colors_backup.nes
```

---

## Sugerencia de uso en vivo

- Abrí una terminal, corré la preparación una vez (cd + activate) y luego copiá/pegá los comandos según la demo.
- Mostrá primero la ROM base, luego la sección CHR (más roto → menos roto), Modo Noche y cerrá con las variantes de Goomba.
- Si alguna ROM cambió de timestamp, sólo reemplazá el nombre en el comando (la ruta base no cambia).
