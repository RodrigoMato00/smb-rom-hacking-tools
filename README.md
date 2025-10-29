# Super Mario Bros ROM Hacking Tools

A comprehensive Python toolkit for creating custom Super Mario Bros experiences. Modify NES ROMs with custom Mario skins, night mode skies, invincible gameplay, personalized title text, and mutated sprites.

## Features

This toolkit includes 6 powerful scripts for binary manipulation with NES memory addressing and 6502 assembly knowledge:

1. **Palette Editor** - Modify colors, create night mode skies, and customize visual appearance
2. **Skin Creator** - Create custom Mario skins and sprite modifications
3. **Invincibility Hack** - Enable invincible gameplay and other gameplay modifications
4. **Text Modifier** - Personalize title text and in-game messages
5. **Tile Mutator** - Mutate sprites and tiles for creative visual effects
6. **NES Emulator** - Integrated NES ROM information viewer and emulator launcher

## Requirements

- Python 3.6 or higher
- No external dependencies for core functionality
- Optional: External NES emulator (FCEUX, Nestopia, or Mesen) for testing

## Installation

```bash
git clone https://github.com/RodrigoMato00/smb-rom-hacking-tools.git
cd smb-rom-hacking-tools
```

No installation required - pure Python implementation!

## Usage

### 1. Palette Editor

Modify colors and create night mode effects:

```bash
# View current palette
python palette_editor.py smb.nes --view

# Apply night mode with dark sky
python palette_editor.py smb.nes --night-mode

# Apply rainbow colors
python palette_editor.py smb.nes --rainbow

# Set custom color (background palette, index 0, black)
python palette_editor.py smb.nes --set-color bg 0 0x0F
```

**Features:**
- View and modify background and sprite palettes
- Night mode with dark sky
- Rainbow color schemes
- Custom color setting

### 2. Skin Creator

Create custom Mario skins and modify sprite graphics:

```bash
# View tile graphics (tile index 0)
python skin_creator.py smb.nes --view-tile 0

# Apply preset skins
python skin_creator.py smb.nes --preset luigi
python skin_creator.py smb.nes --preset fire
python skin_creator.py smb.nes --preset gold
python skin_creator.py smb.nes --preset shadow

# Invert tile colors
python skin_creator.py smb.nes --invert 0

# Mirror tile horizontally
python skin_creator.py smb.nes --mirror 5

# Apply patterns
python skin_creator.py smb.nes --pattern 10 checkerboard
python skin_creator.py smb.nes --pattern 15 stripes
```

**Features:**
- View sprite tile data as ASCII art
- Apply preset skin modifications (Luigi, Fire, Gold, Shadow)
- Invert and mirror sprite tiles
- Apply custom patterns (checkerboard, stripes)

### 3. Invincibility Hack

Enable invincible gameplay and other modifications:

```bash
# Enable invincibility
python invincibility_hack.py smb.nes --invincible

# Enable infinite lives
python invincibility_hack.py smb.nes --infinite-lives

# Enable infinite time
python invincibility_hack.py smb.nes --infinite-time

# Enable super jump
python invincibility_hack.py smb.nes --super-jump

# Enable moon gravity
python invincibility_hack.py smb.nes --moon-gravity

# Enable all hacks at once
python invincibility_hack.py smb.nes --all
```

**Features:**
- Permanent invincibility (no damage from enemies)
- Infinite lives
- Infinite time
- Super jump (higher jumps)
- Moon gravity (slower falling)

**Technical Details:** Uses 6502 assembly knowledge to NOP out damage detection routines, modify jump velocities, and patch timer countdown code.

### 4. Text Modifier

Personalize title text and in-game messages:

```bash
# Search for text in ROM
python text_modifier.py smb.nes --search 'MARIO'

# Read text at specific offset
python text_modifier.py smb.nes --read 0x4F4 16

# Write text at specific offset
python text_modifier.py smb.nes --write-at 0x4F4 'CUSTOM TEXT'

# Replace text throughout ROM
python text_modifier.py smb.nes --replace 'MARIO' 'LUIGI'

# Set custom title
python text_modifier.py smb.nes --title 'SUPER CUSTOM'

# Add easter egg messages
python text_modifier.py smb.nes --easter-eggs
```

**Features:**
- Search for text patterns in ROM
- Read and write text at specific addresses
- Replace text throughout the ROM
- Custom title screen text
- Easter egg message modifications

### 5. Tile Mutator

Mutate sprites and tiles for creative visual effects:

```bash
# Glitch a tile
python tile_mutator.py smb.nes --glitch 0

# Randomize a tile
python tile_mutator.py smb.nes --randomize 5

# Rotate tile clockwise/counter-clockwise
python tile_mutator.py smb.nes --rotate 10 cw
python tile_mutator.py smb.nes --rotate 10 ccw

# Flip tile horizontally or vertically
python tile_mutator.py smb.nes --flip 15 horizontal
python tile_mutator.py smb.nes --flip 15 vertical

# Swap two tiles
python tile_mutator.py smb.nes --swap 5 10

# Mutate a range of tiles
python tile_mutator.py smb.nes --mutate-range 0 20 glitch
python tile_mutator.py smb.nes --mutate-range 0 20 random
python tile_mutator.py smb.nes --mutate-range 0 20 invert

# Psychedelic mode - random mutations
python tile_mutator.py smb.nes --psychedelic
```

**Features:**
- Glitch and randomize tiles
- Rotate tiles 90 degrees
- Flip tiles horizontally/vertically
- Swap tiles
- Mutate ranges of tiles
- Psychedelic mode for wild effects

### 6. NES Emulator

ROM information viewer and emulator launcher:

```bash
# Display ROM information
python nes_emulator.py smb.nes --info

# Verify ROM integrity
python nes_emulator.py smb.nes --verify

# Extract PRG ROM
python nes_emulator.py smb.nes --extract-prg prg.bin

# Extract CHR ROM
python nes_emulator.py smb.nes --extract-chr chr.bin

# Launch in external emulator
python nes_emulator.py smb.nes --launch fceux
python nes_emulator.py smb.nes --launch nestopia
python nes_emulator.py smb.nes --launch mesen
```

**Features:**
- Parse and display iNES ROM header information
- Verify ROM integrity
- Extract PRG and CHR ROM sections
- Launch ROM in external emulators (FCEUX, Nestopia, Mesen)

## Technical Background

### NES Memory Addressing

- **PRG ROM**: Program code and data (typically 32KB)
- **CHR ROM**: Graphics data (pattern tables, typically 8KB)
- **Palettes**: Background and sprite color palettes (16 bytes each)
- **iNES Header**: 16-byte header with ROM information

### 6502 Assembly Concepts

The invincibility hack uses knowledge of 6502 assembly instructions:

- `CMP` (0xC9): Compare instruction
- `BNE` (0xD0): Branch if Not Equal
- `NOP` (0xEA): No Operation
- `DEC` (0xCE): Decrement
- `LDA` (0xA9): Load Accumulator
- `ADC` (0x69): Add with Carry
- `SBC` (0xE9): Subtract with Carry

### Binary Manipulation

All tools work directly with binary ROM data:

- Pattern matching for code sequences
- Bitwise operations for graphics manipulation
- Direct memory address modifications
- CHR ROM tile encoding (2 bitplanes per tile)

## Example Workflows

### Create a Night Mode Luigi Hack

```bash
# 1. Apply night mode palette
python palette_editor.py smb.nes --night-mode

# 2. Apply Luigi skin
python skin_creator.py smb_modified.nes --preset luigi

# 3. Make invincible
python invincibility_hack.py smb_modified_skinned.nes --invincible

# 4. Test in emulator
python nes_emulator.py smb_modified_skinned_invincible.nes --launch fceux
```

### Create a Psychedelic Experience

```bash
# 1. Rainbow palette
python palette_editor.py smb.nes --rainbow

# 2. Mutate sprites
python tile_mutator.py smb_modified.nes --psychedelic

# 3. Custom title
python text_modifier.py smb_modified_mutated.nes --title 'PSYCHEDELIC'

# 4. Test
python nes_emulator.py smb_modified_mutated_modified_text.nes --info
```

## Important Notes

- **Backup your ROMs**: Always keep a backup of your original ROM files
- **ROM Versions**: These tools are designed for standard Super Mario Bros (USA) ROMs. Different versions may require address adjustments
- **Testing**: Always test modified ROMs in an emulator before using
- **Legal**: Only use these tools with ROMs you legally own

## Output Files

Modified ROMs are saved with descriptive suffixes:
- `*_modified.nes` - Palette modifications
- `*_skinned.nes` - Skin modifications
- `*_invincible.nes` - Gameplay hacks
- `*_modified_text.nes` - Text modifications
- `*_mutated.nes` - Tile mutations

## Troubleshooting

### "ROM file not found"
- Ensure the ROM file path is correct
- Check file permissions

### "Invalid NES ROM header"
- Verify you're using a valid iNES format ROM
- Check the ROM file isn't corrupted

### Modified ROM doesn't work
- Some modifications may conflict with each other
- Try applying modifications one at a time
- Different ROM versions may require different addresses

### External emulator not launching
- Install the emulator (fceux, nestopia, or mesen)
- Ensure the emulator is in your system PATH
- Try launching the ROM manually

## Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest new features
- Submit pull requests
- Share your ROM hacks

## License

This project is for educational purposes. Respect copyright laws and only use with ROMs you legally own.

## Credits

Created by the ROM hacking community. These tools demonstrate binary manipulation, NES hardware knowledge, and 6502 assembly programming concepts.
