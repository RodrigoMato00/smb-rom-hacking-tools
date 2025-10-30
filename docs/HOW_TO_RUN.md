# How to Run Super Mario Bros with Pyntendo

## Prerequisites

### Virtual Environment (Emulator and Patches)
```bash
# Recommended Python for emulator/patches: 3.13
python3 -V  # should be 3.13.x

# Activate virtual environment
source venv/bin/activate
```

### Installed Dependencies
- **pyntendo** (local NES emulator) — install with `pip install -e ./depends/pyntendo-repo`
- **pygame** - UI and controls
- **pyaudio** - Audio (requires PortAudio installed)
- **Cython** - Dependency of pyntendo

## Run the Emulator (3.13)

### Basic Command
```bash
cd /Users/rodrigomato/charla
source venv/bin/activate
python3 scripts/main.py roms/SuperMarioBros.nes
```

## Change the ROM

### File Location
Place your ROMs in the project `roms/` folder.

### How to Change the ROM
1. Copy your ROM into `roms/`
2. Run passing the ROM path as an argument:
   ```bash
   python3 scripts/main.py roms/YOUR_ROM.nes
   ```

### Example
```bash
# Original ROM
python3 scripts/main.py roms/SuperMarioBros.nes

# Switch to another ROM
python3 scripts/main.py roms/DonkeyKong.nes
```

## Controls

### Movement
- Up: `W`
- Left: `A`
- Down: `S`
- Right: `D`

### Controller Buttons
- Select: `G`
- Start: `H`
- A: `P`
- B: `L`

### System Controls
- Toggle OSD: `1`
- Start CPU logging: `2`
- Volume down: `-`
- Volume up: `=`
- Mute: `0`

## Sync Modes

### Available Values
- `sync_mode=0` - No sync (very fast, choppy audio)
- `sync_mode=1` - Audio sync (perfect speed, occasional glitches)
- `sync_mode=2` - Pygame sync (reliable, some screen tearing)
- `sync_mode=3` - Vsync (requires ~60Hz vsync, no tearing)

### Recommended
```bash
python3 scripts/main.py roms/SuperMarioBros.nes --sync-mode 2
```

## Troubleshooting

### No Audio
```bash
# Install PortAudio (macOS)
brew install portaudio

# Install PyAudio
pip install pyaudio
```

### Path Error
- Use project-relative paths (e.g., `roms/SuperMarioBros.nes`).
- Verify the ROM exists at the specified path.

### Missing Dependencies
```bash
pip install -r requirements.txt
pip install -e ./depends/pyntendo-repo
```

## AI Environment (Python 3.8)
- For `scripts/rl_demo_mario.py`, use a separate venv with **Python 3.8** and pinned dependencies.
- See the main README ("RL Demo" section) for commands.

## Project Structure

```
repo/
├── roms/                    # Game ROMs
│   └── SuperMarioBros.nes
├── scripts/                 # Python scripts
│   └── main.py              # Emulator entrypoint
├── venv/                    # Virtual env (3.13)
└── requirements.txt         # Dependencies
```
