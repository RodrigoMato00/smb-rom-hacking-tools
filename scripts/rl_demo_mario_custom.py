#!/usr/bin/env python3
"""
Mario RL runner (custom ROM support via nes_py)

- Default: behaves like rl_demo_mario.py using gym_super_mario_bros
- With --rom: loads external .nes ROM via nes_py and runs PPO

Python 3.8 environment required (see requirements-rl.txt)
"""
import argparse
import os
import time
import warnings
import numpy as np
from argparse import ArgumentDefaultsHelpFormatter
from common_help import get_epilog

# Silence harmless overflow warning in SMB env RAM
warnings.filterwarnings(
    "ignore",
    message="overflow encountered in scalar subtract",
    category=RuntimeWarning,
    module="gym_super_mario_bros.smb_env"
)


def ensure_contiguous(obs: np.ndarray) -> np.ndarray:
    if isinstance(obs, np.ndarray) and not obs.flags.c_contiguous:
        return np.ascontiguousarray(obs)
    return obs


def build_parser() -> argparse.ArgumentParser:
    return argparse.ArgumentParser(
        description="[Python 3.8] PPO demo with optional external ROM (nes_py)",
        formatter_class=ArgumentDefaultsHelpFormatter,
        epilog=(
            "Examples:\n"
            "  python3 scripts/rl_demo_mario_custom.py --seconds 5 --timesteps 500\n"
            "  python3 scripts/rl_demo_mario_custom.py --rom roms/Infinite.nes --seconds 5 --timesteps 500\n\n"
            "Notes: External ROM uses nes_py directly; observations/actions may differ from gym_super_mario_bros."
        ),
    )


def make_env_with_rom(rom_path: str):
    # Lazy import so --help works without deps
    from nes_py.wrappers import JoypadSpace
    from gym_super_mario_bros.actions import SIMPLE_MOVEMENT
    # Base NES environment accepting a ROM path
    from nes_py.nes_env import NESEnv

    def _sanitize_rom_header(path: str) -> str:
        # Ensure iNES header padding bytes (12..15) are zero to satisfy nes_py
        try:
            with open(path, "rb") as f:
                data = bytearray(f.read())
            if len(data) >= 16 and data[0:4] == b"NES\x1a":
                # Zero-fill bytes 12..15 only (do not touch flags/mapper)
                data[12:16] = b"\x00\x00\x00\x00"
                tmp_path = path + ".sanitized.nes"
                with open(tmp_path, "wb") as f:
                    f.write(data)
                return tmp_path
        except Exception:
            pass
        return path

    class MarioCustomEnv(NESEnv):
        metadata = {"render.modes": ["human", "rgb_array"]}

        def __init__(self, path: str):
            super().__init__(path)
            self._score = 0
            self._time_left = 0

        def _get_reward(self):
            # Simple dense reward using score/time deltas if available
            # Many ROM hacks still expose typical RAM layout; adjust if needed
            reward = 0.0
            try:
                score = int(self.ram[0x07DC]) * 10  # coarse proxy
                delta = score - self._score
                self._score = score
                reward += max(delta, 0)
            except Exception:
                pass
            return reward

        def _get_done(self):
            # Done when life lost or level end; fallback to emulator signal
            return super()._get_done()

        def step(self, action):
            obs, _, done, info = super().step(action)
            reward = self._get_reward()
            return obs, reward, done, info

    sanitized = _sanitize_rom_header(rom_path)
    env = MarioCustomEnv(sanitized)

    # Extend action set to include a START action for booting past title screen
    movement = list(SIMPLE_MOVEMENT)
    movement.append(["start"])  # last index triggers START
    movement.append(["A"])      # jump/confirm
    movement.append(["select"]) # player select (some hacks require)
    env = JoypadSpace(env, movement)
    env._custom_start_action_index = len(movement) - 3  # START index
    env._custom_a_action_index = len(movement) - 2      # A index
    env._custom_select_action_index = len(movement) - 1 # SELECT index

    # Wrapper to press START automatically on reset until inside a level
    import gym

    class BootOnResetWrapper(gym.Wrapper):
        def __init__(self, env):
            super().__init__(env)
            self._boot_frames_after_reset = 0

        def reset(self, **kwargs):
            obs = self.env.reset(**kwargs)
            start_idx = getattr(self.env, "_custom_start_action_index", None)
            if start_idx is None:
                return obs
            # Press START twice with small delays to pass title and player select
            try:
                for _ in range(10):
                    obs, _, _, _ = self.env.step(start_idx)
                for _ in range(5):
                    obs, _, _, _ = self.env.step(0)  # NOOP settle
                for _ in range(10):
                    obs, _, _, _ = self.env.step(start_idx)
                for _ in range(5):
                    obs, _, _, _ = self.env.step(0)
                # After reset, force boot sequence window (~240 frames)
                self._boot_frames_after_reset = 240
            except Exception:
                pass
            return obs

        def step(self, action):
            # Only force boot during first ~60 frames, then let model actions through
            start_idx = getattr(self.env, "_custom_start_action_index", None)
            a_idx = getattr(self.env, "_custom_a_action_index", None)
            sel_idx = getattr(self.env, "_custom_select_action_index", None)
            from gym_super_mario_bros.actions import SIMPLE_MOVEMENT
            num_simple_actions = len(SIMPLE_MOVEMENT)

            if self._boot_frames_after_reset > 0 and start_idx is not None:
                f = self._boot_frames_after_reset
                self._boot_frames_after_reset -= 1
                # Force boot sequence only for first 60 frames after reset
                if f > (240 - 60):  # First 60 frames: force boot
                    if f % 40 == 0 and sel_idx is not None and f > 160:
                        action = sel_idx
                    elif f % 20 == 0 and a_idx is not None:
                        action = a_idx
                    else:
                        action = start_idx
                else:
                    # After boot: if model predicts boot actions (START/A/SELECT), map to NOOP
                    if action >= num_simple_actions:
                        action = 0  # NOOP
            else:
                # Normal gameplay: map any boot action predictions to valid actions
                if action >= num_simple_actions:
                    action = 0  # NOOP
            return self.env.step(action)

    env = BootOnResetWrapper(env)
    return env


def make_env_default():
    import gym_super_mario_bros
    from nes_py.wrappers import JoypadSpace
    from gym_super_mario_bros.actions import SIMPLE_MOVEMENT
    env = gym_super_mario_bros.make("SuperMarioBros-v0")
    env = JoypadSpace(env, SIMPLE_MOVEMENT)
    return env


def main():
    parser = build_parser()
    parser.add_argument("--rom", type=str, default=None, help="Path to external .nes ROM (uses nes_py)")
    parser.add_argument("--seconds", type=int, default=60, help="Play time in seconds (ignored if --forever)")
    parser.add_argument("--timesteps", type=int, default=15000, help="PPO training timesteps (ignored if --load)")
    parser.add_argument("--load", type=str, default=None, help="Path to .zip model to load (demo mode)")
    parser.add_argument("--save", type=str, default="mario_ppo_model.zip", help="Path to save the trained model")
    parser.add_argument("--forever", action="store_true", help="Keep playing until Ctrl+C (no auto-exit)")

    # Import heavy dependencies here so --help works even if not installed
    try:
        import gym  # noqa: F401
        import gym_super_mario_bros  # noqa: F401
        from nes_py.wrappers import JoypadSpace  # noqa: F401
        from gym_super_mario_bros.actions import SIMPLE_MOVEMENT  # noqa: F401
        from stable_baselines3 import PPO  # noqa: F401
    except ModuleNotFoundError as e:
        parser.print_help()
        mod = getattr(e, 'name', 'a required module')
        print()
        print(f"Error: missing dependency: {mod}")
        print("Hint: Use Python 3.8 environment and install pinned packages:")
        print("  pip install 'pip<24.1'")
        print("  pip install gym==0.21.0 nes_py==8.2.1 gym_super_mario_bros==7.3.0 stable-baselines3==1.6.2")
        print("  pip install torch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1")
        return

    args = parser.parse_args()

    from stable_baselines3 import PPO

    if args.rom:
        if not os.path.exists(args.rom):
            print(f"ROM not found: {args.rom}")
            return
        env = make_env_with_rom(args.rom)
    else:
        env = make_env_default()

    try:
        if args.load:
            if not os.path.exists(args.load):
                print(f"Model not found: {args.load}")
                return
            print(f"Loading existing model: {args.load}")
            model = PPO.load(args.load, env=env)
            print("Model loaded")
        else:
            print(f"Training PPO ({args.timesteps} timesteps)...")
            model = PPO("CnnPolicy", env, verbose=1, n_steps=256, batch_size=256, device="cpu")
            t0 = time.time()
            model.learn(total_timesteps=int(args.timesteps))
            train_secs = time.time() - t0
            model.save(args.save)
            print(f"Model saved to: {args.save}")
            print(f"Training time: {train_secs:.1f}s")

        if args.forever:
            print("Playing until Ctrl+C...")
        else:
            print(f"Playing {args.seconds}s...")
        obs = env.reset()
        start = time.time()
        steps = 0
        cycles = 0

        try:
            def time_left():
                return True if args.forever else (time.time() - start < args.seconds)
            from gym_super_mario_bros.actions import SIMPLE_MOVEMENT
            num_valid_actions = len(SIMPLE_MOVEMENT)

            while time_left():
                obs_input = ensure_contiguous(obs)
                if isinstance(obs_input, np.ndarray) and obs_input.ndim == 3:
                    obs_input = np.expand_dims(obs_input, axis=0)
                action, _ = model.predict(obs_input, deterministic=True)
                if isinstance(action, np.ndarray):
                    action = int(action.item())

                # Clamp action to valid range (0 to num_valid_actions-1)
                # If model was trained with extended actions, map back to valid range
                if action >= num_valid_actions:
                    # If action is out of range (START/A/SELECT), use a default useful action
                    # Use "right" (action 1) as fallback to keep moving forward
                    action = 1  # right
                elif action < 0:
                    action = 0  # NOOP

                # Fix: If model predicts "left" (action 6), map to "right" (action 1) instead
                # This corrects the backward movement issue
                if action == 6:  # left -> right
                    action = 1  # right

                obs, reward, done, info = env.step(action)
                env.render()
                steps += 1
                if done:
                    obs = env.reset()
                    cycles += 1
        finally:
            env.close()

        print(f"Done. Total steps: {steps}, level resets: {cycles}")
    finally:
        pass


if __name__ == "__main__":
    main()
