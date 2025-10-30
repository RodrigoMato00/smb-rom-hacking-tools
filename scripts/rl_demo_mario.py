#!/usr/bin/env python3
"""
Mario RL runner (gym_super_mario_bros + SB3 PPO)

Requisitos (instalar en entorno separado, p.ej. mario-rl-env con Python 3.8):
  pip install gym==0.21.0 gym_super_mario_bros==7.3.0 nes_py==8.2.1 \
              stable-baselines3==1.6.2 \
              torch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1

Uso:
  # Entrenar y jugar (default: 15000 timesteps, 2 minutos de juego):
  python scripts/mario_rl_run.py

  # Cargar modelo guardado y jugar (modo demo, default: 2 minutos):
  python scripts/mario_rl_run.py --load mario_ppo_model.zip

Notas:
- Este script evita el error de "negative strides" al hacer predict() con SB3.
- Silencia warnings inofensivos del emulador NES.
"""
import argparse
import os
import time
import warnings
import numpy as np

import gym
import gym_super_mario_bros
from nes_py.wrappers import JoypadSpace
from gym_super_mario_bros.actions import SIMPLE_MOVEMENT

from stable_baselines3 import PPO

# Silenciar warning harmless de overflow en RAM del emulador NES
warnings.filterwarnings(
    "ignore",
    message="overflow encountered in scalar subtract",
    category=RuntimeWarning,
    module="gym_super_mario_bros.smb_env"
)


def ensure_contiguous(obs: np.ndarray) -> np.ndarray:
    """Devuelve una copia contigua lista para pasar a torch.as_tensor()"""
    if isinstance(obs, np.ndarray) and not obs.flags.c_contiguous:
        return np.ascontiguousarray(obs)
    return obs


def main():
    parser = argparse.ArgumentParser(description="Entrenar PPO y jugar Mario (o cargar modelo para demo)")
    parser.add_argument("--seconds", type=int, default=120, help="Segundos de juego (default: 120 = 2 minutos)")
    parser.add_argument("--timesteps", type=int, default=15000, help="Timesteps de entrenamiento PPO (ignorado si --load)")
    parser.add_argument("--load", type=str, default=None, help="Path al modelo .zip para cargar (modo demo)")
    parser.add_argument("--save", type=str, default="mario_ppo_model.zip", help="Path donde guardar modelo tras entrenar")
    args = parser.parse_args()

    env = gym_super_mario_bros.make("SuperMarioBros-v0")
    env = JoypadSpace(env, SIMPLE_MOVEMENT)

    try:
        if args.load:
            # Inference-only (no entrenamiento)
            if not os.path.exists(args.load):
                print(f"❌ No se encontró el modelo: {args.load}")
                return
            print(f"📦 Cargando modelo existente: {args.load}")
            model = PPO.load(args.load, env=env)
            print("✅ Modelo cargado")
        else:
            # Entrenar PPO breve y guardar
            print(f"🏋️ Entrenando PPO ({args.timesteps} timesteps)...")
            model = PPO("CnnPolicy", env, verbose=1, n_steps=256, batch_size=256, device="cpu")
            t0 = time.time()
            model.learn(total_timesteps=int(args.timesteps))
            train_secs = time.time() - t0
            model.save(args.save)
            print(f"💾 Modelo guardado en: {args.save}")
            print(f"⏱️ Tiempo de entrenamiento: {train_secs:.1f}s")

        # Demo de juego controlado por la política entrenada
        print(f"🎮 Jugando {args.seconds}s...")
        obs = env.reset()
        start = time.time()
        steps = 0
        cycles = 0

        try:
            while time.time() - start < args.seconds:
                # Asegurar forma compatible con SB3.predict
                obs_input = ensure_contiguous(obs)
                if obs_input.ndim == 3:  # (H, W, C) -> (1, H, W, C)
                    obs_input = np.expand_dims(obs_input, axis=0)

                action, _ = model.predict(obs_input, deterministic=True)

                # JoypadSpace espera int (no array)
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

        print(f"✅ Listo. Pasos jugados totales: {steps}, reinicios del nivel: {cycles}")


if __name__ == "__main__":
    main()


