# CLI Help Reference (Scripts)

This document summarizes usage, arguments and examples for the main scripts.

## patch_sky_night.py
- Description: Apply a night-sky effect by editing BackgroundColors at $85CF.
- Usage: `python3 scripts/patch_sky_night.py [ROM_PATH]`
- Arguments:
  - `ROM_PATH` (optional): NES ROM path. If omitted, uses `roms/SuperMarioBros.nes` and writes a new ROM with timestamp.
- Notes: Validates iNES header.
- Examples:
  - `python3 scripts/patch_sky_night.py`
  - `python3 scripts/patch_sky_night.py roms/Custom.nes`

## patch_mario_palette.py
- Description: Replace Mario's full palette (4 bytes) across all occurrences to create skins.
- Usage: `python3 scripts/patch_mario_palette.py --c0 HEX --c1 HEX --c2 HEX --c3 HEX`
- Arguments:
  - `--c0/--c1/--c2/--c3`: color bytes (hex or dec). Typical NES range: 0x00–0x3F.
- Notes: Warns if outside 0x00–0x3F. Validates iNES. Output auto-named `mario_full_..._TIMESTAMP.nes`.
- Examples:
  - `python3 scripts/patch_mario_palette.py --c0 0x22 --c1 0x30 --c2 0x0F --c3 0x15`
  - `python3 scripts/patch_mario_palette.py --c0 34 --c1 48 --c2 15 --c3 21`

## patch_chr_range.py
- Description: Mutate a CHR tile range swapping indices 01 ↔ 10.
- Usage: `python3 scripts/patch_chr_range.py --start N --count N [--rom PATH]`
- Arguments:
  - `--start`: start tile (hex or decimal)
  - `--count`: tile count (hex or decimal)
  - `--rom` (optional): input ROM path. Defaults to `roms/SuperMarioBros.nes`.
- Notes: Validates iNES and range. Output `SuperMarioBros_CHR_START_COUNT_TIMESTAMP.nes`.
- Examples:
  - `python3 scripts/patch_chr_range.py --start 0x1E0 --count 0x20`
  - `python3 scripts/patch_chr_range.py --start 480 --count 32`

## patch_star_permanent.py
- Description: Force permanent invincibility (NOP the BEQ in PlayerEnemyCollision).
- Usage: `python3 scripts/patch_star_permanent.py [ROM_PATH]`
- Arguments:
  - `ROM_PATH` (optional): NES ROM path. If omitted, uses `roms/SuperMarioBros.nes` and writes a new ROM.
- Notes: Validates iNES; prints opcode before patch.
- Examples:
  - `python3 scripts/patch_star_permanent.py`
  - `python3 scripts/patch_star_permanent.py roms/Custom.nes`

## patch_title_message.py
- Description: Replace the title-screen "WORLD  TIME" bytes with a custom sequence.
- Usage: `python3 scripts/patch_title_message.py [ROM_PATH]`
- Arguments:
  - `ROM_PATH` (optional): NES ROM path. If omitted, uses `roms/SuperMarioBros.nes` and writes a new ROM.
- Notes: Validates iNES; pads if sequence length differs.
- Examples:
  - `python3 scripts/patch_title_message.py`
  - `python3 scripts/patch_title_message.py roms/Custom.nes`

## main.py
- Description: Run the NES emulator with a given ROM.
- Usage: `python3 scripts/main.py ROM_PATH [--sync-mode N]`
- Arguments:
  - `ROM_PATH`: NES ROM path.
  - `--sync-mode`: 0 no-sync; 1 audio sync; 2 pygame (default); 3 vsync.
- Examples:
  - `python3 scripts/main.py roms/SuperMarioBros.nes`
  - `python3 scripts/main.py roms/Patched.nes --sync-mode 1`

## rl_demo_mario.py (Python 3.8)
- Description: Brief PPO training and play, or load model and play.
- Usage: `python3 scripts/rl_demo_mario.py [--seconds S] [--timesteps T] [--load PATH] [--save PATH]`
- Examples:
  - `python3 scripts/rl_demo_mario.py --seconds 5 --timesteps 1000`
  - `python3 scripts/rl_demo_mario.py --load mario_ppo_model.zip --seconds 20`
