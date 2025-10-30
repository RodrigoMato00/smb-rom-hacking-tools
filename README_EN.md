# Super Mario Bros Project - Modding Tools

This project contains tools to modify Super Mario Bros (NES) and create customized ROMs with visual and gameplay changes.

## Quick Start

### Requirements
- Python 3.13 (emulator/patches) and Python 3.8 (RL)
- `nes` library installed (local package `pyntendo`)
- Original Super Mario Bros ROM

### Python compatibility by component

| Component | Recommended Python | Notes |
|---|---|---|
| Emulator (`scripts/main.py`) | 3.13 | Install `depends/pyntendo-repo` in the active venv.
| Patching scripts (`patch_*.py`) | 3.13 | No special deps beyond stdlib.
| RL demo (`scripts/rl_demo_mario.py`) | 3.8 | Pinned: gym 0.21.0, nes_py 8.2.1, gym_super_mario_bros 7.3.0, SB3 1.6.2, torch 1.13.1.

### Installation
```bash
# Create 3.13 env for emulator/patches
python3 -V            # should be 3.13.x
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Install local NES emulator (pyntendo)
pip install -e ./depends/pyntendo-repo
```

### Basic usage (Emulator + Patches)
```bash
# Create a night-sky ROM
python3 scripts/patch_sky_night.py

# Create a custom Mario skin
python3 scripts/patch_mario_palette.py --c0 0x22 --c1 0x30 --c2 0x0F --c3 0x15

# Make Mario permanently invincible
python3 scripts/patch_star_permanent.py

# Run a generated ROM
python3 scripts/main.py roms/SuperMarioBros_sky_night_YYYYMMDD_HHMMSS.nes
```

### RL Demo (separate Python 3.8 env)
```bash
# Requires Python 3.8 (pyenv or system python3.8)
python3.8 -V         # should be 3.8.x
python3.8 -m venv venv38
source venv38/bin/activate

# pip 24.0 to allow installing gym==0.21.0
pip install 'pip<24.1'

# Compatible RL deps
pip install gym==0.21.0 nes_py==8.2.1 gym_super_mario_bros==7.3.0 stable-baselines3==1.6.2
pip install torch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1

# Short run: brief training and 5s play
python3 scripts/rl_demo_mario.py --seconds 5 --timesteps 1000
```

## Full Documentation

See the [`docs/`](docs/) directory:

- **[docs/README.md](docs/README.md)** - Documentation index
- **[docs/SCRIPTS_DOCUMENTATION.md](docs/SCRIPTS_DOCUMENTATION.md)** - Scripts guide
- **[docs/GAME_STRUCTURE.md](docs/GAME_STRUCTURE.md)** - Game architecture
- **[docs/COMO_EJECUTAR.md](docs/COMO_EJECUTAR.md)** - Detailed run instructions

## Available Scripts

| Script | Description |
|--------|-------------|
| `patch_sky_night.py` | Change sky to night effect |
| `patch_mario_palette.py` | Create custom Mario skins |
| `patch_chr_range.py` | Mutate specific CHR-ROM tiles |
| `patch_star_permanent.py` | Permanent invincibility |
| `patch_title_message.py` | Modify title screen text |
| `main.py` | NES emulator to test ROMs |

## Project Structure

```
charla/
├── docs/                    # Documentation
├── scripts/                 # Modding tools
├── roms/                    # Original and generated ROMs
├── smb-disassembly/         # Assembler sources
├── extracted_sprites_real/  # Extracted sprites
└── requirements.txt         # Dependencies
```

## Features

- Palette modding: sky, Mario, enemies
- Custom skins: visual Mario variants
- Gameplay hacks: invincibility, effects
- Tile mutation: targeted graphics edits
- Integrated emulator: run ROMs directly
- Comprehensive docs

## Examples

### Night Sky
```bash
python3 scripts/patch_sky_night.py
# Result: ROM with dark night-style sky
```

### Zombie Mario
```bash
python3 scripts/patch_mario_palette.py --c0 0x29 --c1 0x15 --c2 0x0F --c3 0x27
# Result: greenish skin, darker outfit
```

### Permanent Invincibility
```bash
python3 scripts/patch_star_permanent.py
# Result: Mario does not take damage; enemies die on touch
```

### Custom Title Text
```bash
python3 scripts/patch_title_message.py
# Result: replace "WORLD  TIME" with a custom message
```

## Additional Resources

- Disassembly: `scripts/mario.txt` (15,674 lines)
- Assembler source: `scripts/SuperMarioBros_disasm.asm`
- Extracted sprites: `extracted_sprites_real/`

## Contributing

1. Fork the repo
2. Create a feature branch (`git checkout -b feature/new-feature`)
3. Commit changes (`git commit -am 'Add new feature'`)
4. Push the branch (`git push origin feature/new-feature`)
5. Open a Pull Request

## License

This project is for educational and research purposes. Super Mario Bros is property of Nintendo.
