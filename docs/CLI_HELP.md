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

## patch_start_world_area_smart.py
- Description: Patch starting world/level using heuristic search for $075F/$0760 writes.
- Usage: `python3 scripts/patch_start_world_area_smart.py --rom PATH --world N --level N [--dry-run] [--pick N]`
- Arguments:
  - `--rom` (required): NES ROM path.
  - `--world` (required): World 1..8.
  - `--level` (required): Level 1..4.
  - `--dry-run`: List candidates without patching.
  - `--pick N`: Candidate index to patch (default: 0).
- Notes: Converts 1-based to 0-based internally. Candidate 0 uses GoContinue (requires A+START).
- Examples:
  - `python3 scripts/patch_start_world_area_smart.py --rom roms/SuperMarioBros.nes --world 3 --level 1 --dry-run`
  - `python3 scripts/patch_start_world_area_smart.py --rom roms/SuperMarioBros.nes --world 8 --level 4 --pick 0`

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

## rl_demo_mario_custom.py (Python 3.8)
- Description: RL demo with custom ROMs using nes_py (auto-boot wrapper included).
- Usage: `python3 scripts/rl_demo_mario_custom.py --rom PATH [--timesteps T] [--seconds S] [--forever] [--load PATH] [--save PATH]`
- Arguments:
  - `--rom` (required): Custom NES ROM path.
  - `--timesteps`: PPO training timesteps (default: 10000).
  - `--seconds`: Demo play seconds (default: 20).
  - `--forever`: Play indefinitely (ignores --seconds).
  - `--load`: Load trained model (.zip) to skip training.
  - `--save`: Save model path (default: `mario_ppo_model.zip`).
- Notes: Auto-boots game menus. Works with modified ROMs.
- Examples:
  - `python3 scripts/rl_demo_mario_custom.py --rom roms/Custom.nes --timesteps 50000 --seconds 60`
  - `python3 scripts/rl_demo_mario_custom.py --rom roms/Patched.nes --load models/model.zip --forever`
