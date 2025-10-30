# Estructura del Proyecto - Super Mario Bros ROM Hacking

## Organización de Carpetas

```
repo/
├── docs/                           # Documentación
│   ├── README.md                   # Índice de documentación (ES)
│   ├── README_EN.md                # Índice de documentación (EN)
│   ├── SCRIPTS_DOCUMENTATION.md    # Guía de scripts
│   ├── COMO_EJECUTAR.md            # Cómo ejecutar el emulador
│   ├── IA_REINFORCEMENT_LEARNING.md# Entorno y guía de RL
│   ├── GAME_STRUCTURE.md           # Arquitectura del juego
│   └── nes-reference-guide.md      # Guía técnica de NES
├── scripts/                        # Scripts y herramientas
│   ├── main.py                     # Emulador (pyntendo)
│   ├── patch_sky_night.py          # Parchear cielo (modo noche)
│   ├── patch_mario_palette.py      # Parchear paleta de Mario
│   ├── patch_chr_range.py          # Mutar rango de tiles CHR
│   ├── patch_star_permanent.py     # Invencibilidad permanente
│   ├── patch_title_message.py      # Texto de la pantalla de título
│   ├── rl_demo_mario.py            # Demo RL (Python 3.8)
│   └── assembly/                   # Desensamblados y assets ASM
│       ├── mario.txt               # Desensamblado en texto
│       ├── SuperMarioBros_disasm.asm
│       └── SuperMarioBros.dis65
├── smb-disassembly/                # Fuentes ASM adicionales
│   ├── smb.asm
│   ├── main.asm
│   └── ...
├── roms/                           # ROMs
│   └── SuperMarioBros.nes          # ROM original
├── extracted_sprites_real/         # Sprites extraídos
├── depends/                        # Dependencias locales de terceros
│   ├── pyntendo-repo/              # Emulador NES (instalar en venv)
│   └── retro/                      # Opcional (gym-retro, etc.)
├── venv/                           # Entorno virtual Python 3.13 (emulador/patches)
├── venv38/                         # Entorno virtual Python 3.8 (RL)
├── README.md
├── README_EN.md
└── requirements.txt
```

## Descripción de Carpetas y Archivos

### docs/
- `README.md` / `README_EN.md`: Índice de documentación.
- `SCRIPTS_DOCUMENTATION.md`: Guía de uso de los scripts.
- `COMO_EJECUTAR.md`: Ejecución del emulador con `pyntendo`.
- `IA_REINFORCEMENT_LEARNING.md`: Entorno y comandos para RL (Python 3.8).
- `GAME_STRUCTURE.md`, `nes-reference-guide.md`: Referencias técnicas.

### scripts/
- `main.py`: Lanza el emulador (requiere instalar `depends/pyntendo-repo`).
- `patch_*.py`: Scripts de parcheo de ROM (paletas, tiles, invencibilidad, título).
- `rl_demo_mario.py`: Demo de entrenamiento/ejecución RL (usar `venv38`).
- `assembly/`: Desensamblados y archivos de apoyo al análisis ASM.

### smb-disassembly/
- Fuentes ASM y datos adicionales relacionados a SMB para ensamblado/mods.

### roms/
- ROMs originales y generadas por los scripts.

### depends/
- Código de terceros usado localmente (ej. `pyntendo-repo/`).

## Pasos Recomendados

1. Activar entorno (emulador/patches): `source venv/bin/activate`
2. Instalar dependencias: `pip install -r requirements.txt`
3. Instalar emulador local: `pip install -e ./depends/pyntendo-repo`
4. Ejecutar un script de parcheo (ej.: `python3 scripts/patch_sky_night.py`)
5. Probar la ROM generada con `python3 scripts/main.py roms/ROM_GENERADA.nes`

Para RL (Python 3.8): crear `venv38`, fijar versiones y ejecutar `scripts/rl_demo_mario.py` según `docs/IA_REINFORCEMENT_LEARNING.md`.

## Comandos Útiles

```bash
# Activar entorno 3.13 (emulador/patches)
source venv/bin/activate

# Instalar dependencias y emulador local
pip install -r requirements.txt
pip install -e ./depends/pyntendo-repo

# Ejecutar emulador con una ROM
python3 scripts/main.py roms/SuperMarioBros.nes

# Entorno RL (3.8)
python3.8 -m venv venv38
source venv38/bin/activate
pip install 'pip<24.1'
pip install gym==0.21.0 nes_py==8.2.1 gym_super_mario_bros==7.3.0 stable-baselines3==1.6.2
pip install torch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1
python3 scripts/rl_demo_mario.py --seconds 5 --timesteps 1000
```
