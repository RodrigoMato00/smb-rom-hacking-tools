#!/usr/bin/env python3
"""
Mario RL runner (gym_super_mario_bros + SB3 PPO)

Requirements (install in a separate env, e.g., Python 3.8):
  pip install gym==0.21.0 gym_super_mario_bros==7.3.0 nes_py==8.2.1 \
              stable-baselines3==1.6.2 \
              torch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1

Usage:
  # Train briefly and play (default: 15000 timesteps, 2 minutes):
  python scripts/rl_demo_mario.py

  # Load a saved model and play (demo mode):
  python scripts/rl_demo_mario.py --load mario_ppo_model.zip

Notes:
- This script avoids the "negative strides" issue when calling predict() with SB3.
- It silences harmless warnings from the NES emulator.
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
    """Return a C-contiguous copy ready for torch.as_tensor()."""
    if isinstance(obs, np.ndarray) and not obs.flags.c_contiguous:
        return np.ascontiguousarray(obs)
    return obs


def build_parser() -> argparse.ArgumentParser:
    return argparse.ArgumentParser(
        description="[Python 3.8] Train PPO and play Mario (or load a model for demo)",
        formatter_class=ArgumentDefaultsHelpFormatter,
        epilog=get_epilog("rl_demo_mario"),
    )


def main():
    parser = build_parser()
    parser.add_argument("--seconds", type=int, default=120, help="Play time in seconds (default: 120)")
    parser.add_argument("--timesteps", type=int, default=15000, help="PPO training timesteps (ignored if --load)")
    parser.add_argument("--load", type=str, default=None, help="Path to .zip model to load (demo mode)")
    parser.add_argument("--save", type=str, default="mario_ppo_model.zip", help="Path to save the trained model")

    # Import heavy dependencies here so --help works even if not installed
    try:
        import gym  # noqa: F401
        import gym_super_mario_bros  # noqa: F401
        from nes_py.wrappers import JoypadSpace  # noqa: F401
        from gym_super_mario_bros.actions import SIMPLE_MOVEMENT  # noqa: F401
        from stable_baselines3 import PPO  # noqa: F401
    except ModuleNotFoundError as e:
        # Show help and a friendly hint for missing deps
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

    import gym_super_mario_bros
    from nes_py.wrappers import JoypadSpace
    from gym_super_mario_bros.actions import SIMPLE_MOVEMENT
    from stable_baselines3 import PPO

    env = gym_super_mario_bros.make("SuperMarioBros-v0")
    env = JoypadSpace(env, SIMPLE_MOVEMENT)

    try:
        if args.load:
            # Inference-only (no training)
            if not os.path.exists(args.load):
                print(f"Model not found: {args.load}")
                return
            print(f"Loading existing model: {args.load}")
            model = PPO.load(args.load, env=env)
            print("Model loaded")
        else:
            # Brief PPO training then save
            print(f"Training PPO ({args.timesteps} timesteps)...")
            model = PPO("CnnPolicy", env, verbose=1, n_steps=256, batch_size=256, device="cpu")
            t0 = time.time()
            model.learn(total_timesteps=int(args.timesteps))
            train_secs = time.time() - t0
            model.save(args.save)
            print(f"Model saved to: {args.save}")
            print(f"Training time: {train_secs:.1f}s")

        # Policy-controlled play demo
        print(f"Playing {args.seconds}s...")
        obs = env.reset()
        start = time.time()
        steps = 0
        cycles = 0

        try:
            while time.time() - start < args.seconds:
                # Ensure shape compatible with SB3.predict
                obs_input = ensure_contiguous(obs)
                if obs_input.ndim == 3:  # (H, W, C) -> (1, H, W, C)
                    obs_input = np.expand_dims(obs_input, axis=0)

                action, _ = model.predict(obs_input, deterministic=True)

                # JoypadSpace expects an int (not an array)
                if isinstance(action, np.ndarray):
                    action = int(action.item())

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


