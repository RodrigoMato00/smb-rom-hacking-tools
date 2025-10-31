#!/usr/bin/env python3
"""
Common help utilities for script CLIs.
Provides standardized epilog text per script and a default formatter.
"""
from argparse import ArgumentDefaultsHelpFormatter
import os


def _cmd(script_name: str) -> str:
    """Return a python command prefixed relative to current cwd.
    If user is in scripts/ directory, show "python3 <script>.py"; otherwise
    show "python3 scripts/<script>.py".
    """
    cwd = os.path.basename(os.getcwd())
    if cwd == "scripts":
        return f"python3 {script_name}.py"
    return f"python3 scripts/{script_name}.py"


def epilog_sky() -> str:
    p = _cmd("patch_sky_night")
    return (
        "Examples:\n"
        f"  {p}\n"
        f"  {p} roms/Custom.nes\n\n"
        "Notes: Validates iNES header. Python 3.13 recommended."
    )


def epilog_mario_palette() -> str:
    p = _cmd("patch_mario_palette")
    return (
        "Examples:\n"
        f"  {p} --c0 0x22 --c1 0x30 --c2 0x0F --c3 0x15\n"
        f"  {p} --c0 34 --c1 48 --c2 15 --c3 21\n\n"
        "Notes: Typical NES palette range is 0x00..0x3F. Python 3.13 recommended."
    )


def epilog_chr_range() -> str:
    p = _cmd("patch_chr_range")
    return (
        "Examples:\n"
        f"  {p} --start 0x1E0 --count 0x20\n"
        f"  {p} --start 480 --count 32 --rom roms/Custom.nes\n\n"
        "Notes: Validates iNES header and range. Python 3.13 recommended."
    )


def epilog_star() -> str:
    p = _cmd("patch_star_permanent")
    return (
        "Examples:\n"
        f"  {p}\n"
        f"  {p} roms/Custom.nes\n\n"
        "Notes: Patches BEQ at PlayerEnemyCollision. Python 3.13 recommended."
    )


def epilog_title() -> str:
    p = _cmd("patch_title_message")
    return (
        "Examples:\n"
        f"  {p}\n"
        f"  {p} roms/Custom.nes\n\n"
        "Notes: Pads if new sequence length differs. Python 3.13 recommended."
    )


def epilog_main() -> str:
    p = _cmd("main")
    return (
        "Examples:\n"
        f"  {p} roms/SuperMarioBros.nes\n"
        f"  {p} roms/Patched.nes --sync-mode 1\n\n"
        "Sync modes: 0 no-sync; 1 audio; 2 pygame (default); 3 vsync."
    )


def epilog_rl() -> str:
    p = _cmd("rl_demo_mario")
    return (
        "Examples:\n"
        f"  {p} --seconds 5 --timesteps 1000\n"
        f"  {p} --load mario_ppo_model.zip --seconds 20\n\n"
        "Notes: Python 3.8 environment with pinned packages required."
    )


def epilog_start_world_area() -> str:
    p = _cmd("patch_start_world_area")
    return (
        "Examples:\n"
        f"  {p} --rom roms/SuperMarioBros.nes --world 8 --level 4\n"
        f"  {p} --rom roms/Custom.nes --world 1 --level 2\n\n"
        "Notes: Searches for LDA/STA $075F/$0760 pattern. Python 3.13 recommended."
    )


epilogs = {
    "patch_sky_night": epilog_sky,
    "patch_mario_palette": epilog_mario_palette,
    "patch_chr_range": epilog_chr_range,
    "patch_star_permanent": epilog_star,
    "patch_title_message": epilog_title,
    "patch_start_world_area": epilog_start_world_area,
    "main": epilog_main,
    "rl_demo_mario": epilog_rl,
}


def get_epilog(name: str) -> str:
    fn = epilogs.get(name)
    return fn() if fn else ""


def default_formatter():
    return ArgumentDefaultsHelpFormatter
