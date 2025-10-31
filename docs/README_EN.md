# Super Mario Bros Project Documentation

This directory contains the technical documentation for the Super Mario Bros modding project.

## Compatibility and environments

- Emulator and patch scripts: Python 3.13 (install local `pyntendo`)
- RL demo: Python 3.8 with pinned versions (gym 0.21.0, nes_py 8.2.1, gym_super_mario_bros 7.3.0, SB3 1.6.2, torch 1.13.1)

Quick environment and run commands are in the main README (sections “Quick Start” and “RL Demo”).

## Documentation files

### Scripts and Tools
- **[SCRIPTS_DOCUMENTATION.md](SCRIPTS_DOCUMENTATION.md)** - Complete documentation for all modding scripts
  - `patch_sky_night.py` - Night sky effect
  - `patch_mario_palette.py` - Mario custom skins
  - `patch_chr_range.py` - Mutate specific CHR-ROM tiles
  - `patch_star_permanent.py` - Permanent invincibility
  - `patch_title_message.py` - Modify title screen text
  - `patch_start_world_area_smart.py` - Patch starting world/level
  - `rl_demo_mario.py` - RL demo (train and play)
  - `rl_demo_mario_custom.py` - Train/play with custom ROMs
  - `main.py` - NES emulator to test ROMs

### Game Structure
- **[GAME_STRUCTURE.md](GAME_STRUCTURE.md)** - Technical analysis of the game architecture
  - Overall architecture and memory
  - Palette and color system
  - Collisions and gameplay
  - Main routines and execution flow
  - Key data tables

### Guides and References
- **[nes-reference-guide.md](nes-reference-guide.md)** - NES technical reference
- **[COMO_EJECUTAR.md](COMO_EJECUTAR.md)** - How to run the project
- **[PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)** - Project structure

### Results
- **[COLOR_TEST_RESULTS.md](COLOR_TEST_RESULTS.md)** - Color tests results
- **[MARIO_SKINS_RESULTS.md](MARIO_SKINS_RESULTS.md)** - Results for Mario skins

## Using the documentation

### For developers
1. Read `GAME_STRUCTURE.md` to understand SMB internals
2. See `SCRIPTS_DOCUMENTATION.md` to use the modding tools
3. Combine both to create custom mods

### For users
1. Go to `SCRIPTS_DOCUMENTATION.md` for script usage
2. Follow examples to build your own mods
3. Experiment with combinations

## Project Structure
```
charla/
├── docs/                           # Technical documentation
│   ├── SCRIPTS_DOCUMENTATION.md    # Scripts guide
│   └── GAME_STRUCTURE.md           # Game architecture
├── scripts/                        # Modding tools
│   ├── patch_sky_night.py
│   ├── patch_mario_palette.py
│   ├── patch_chr_range.py
│   ├── patch_star_permanent.py
│   ├── patch_title_message.py
│   ├── patch_start_world_area_smart.py
│   ├── rl_demo_mario.py
│   ├── rl_demo_mario_custom.py
│   └── main.py
├── roms/                           # Original and modified ROMs
│   └── SuperMarioBros.nes
└── smb-disassembly/               # Assembler sources
    ├── mario.txt
    └── SuperMarioBros_disasm.asm
```

## Additional resources

### Reference files
- **`scripts/mario.txt`** - Full disassembly (15,674 lines)
- **`scripts/SuperMarioBros_disasm.asm`** - Assembler source (13,114 lines)
- **`smb-disassembly/`** - Extra disassembly files

### Required tools
- **Python 3.13 (emulator/patches)** and **Python 3.8 (RL)**
- **NES emulator** - To run modified ROMs
- **Hex editor** - Optional for advanced analysis

## Quick Start

1. Read `GAME_STRUCTURE.md`
2. Try the scripts in `SCRIPTS_DOCUMENTATION.md`
3. Experiment with different modifications
4. Build your custom ROMs

### RL Demo (Python 3.8)
Install pinned dependencies from `requirements-rl.txt`:
```bash
python3.8 -m venv venv38
source venv38/bin/activate
pip install -r requirements-rl.txt
```
