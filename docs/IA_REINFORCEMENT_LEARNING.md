# Inteligencia Artificial para Super Mario Bros

Este documento explica en detalle el sistema de Inteligencia Artificial utilizado para entrenar un agente que juega Super Mario Bros mediante Reinforcement Learning (Aprendizaje por Refuerzo).

---

## 📋 Índice

1. [¿Qué tipo de IA se usa?](#qué-tipo-de-ia-se-usa)
2. [¿Qué es Reinforcement Learning?](#qué-es-reinforcement-learning)
3. [Tecnologías y Bibliotecas](#tecnologías-y-bibliotecas)
4. [Algoritmo: PPO (Proximal Policy Optimization)](#algoritmo-ppo-proximal-policy-optimization)
5. [Arquitectura del Sistema](#arquitectura-del-sistema)
6. [Proceso de Entrenamiento](#proceso-de-entrenamiento)
7. [Scripts Disponibles](#scripts-disponibles)
8. [Configuración y Parámetros](#configuración-y-parámetros)
9. [Cómo Funciona el Entrenamiento](#cómo-funciona-el-entrenamiento)
10. [Resultados Esperados](#resultados-esperados)

---

## ¿Qué tipo de IA se usa?

Este proyecto utiliza **Reinforcement Learning (Aprendizaje por Refuerzo)**, una rama del Machine Learning donde un agente aprende a tomar decisiones mediante la interacción con un entorno.

### Características clave:
- **Aprendizaje supervisado**: ❌ No requiere datos etiquetados
- **Aprendizaje no supervisado**: ❌ No busca patrones ocultos en datos
- **Reinforcement Learning**: ✅ El agente aprende mediante prueba y error, recibiendo recompensas (rewards) por acciones exitosas

### Analogía simple:
Imagina enseñarle a un perro trucos:
- Le muestras un truco → **Estado** (situación actual)
- El perro intenta algo → **Acción**
- Le das un premio si lo hizo bien → **Recompensa positiva**
- Lo regañas si lo hizo mal → **Recompensa negativa**
- Con el tiempo, el perro aprende qué acciones funcionan mejor → **Política aprendida**

En nuestro caso:
- **Estado**: La pantalla actual del juego (imagen)
- **Acción**: Saltar, moverse a la derecha, etc.
- **Recompensa**: Avanzar en el nivel (+), perder una vida (-)
- **Política**: La estrategia que aprende la IA para jugar

---

## ¿Qué es Reinforcement Learning?

Reinforcement Learning es un paradigma de Machine Learning donde:

### Componentes principales:

1. **Agente (Agent)**
   - La IA que toma decisiones
   - En nuestro caso: una red neuronal

2. **Entorno (Environment)**
   - El mundo con el que el agente interactúa
   - En nuestro caso: Super Mario Bros emulado

3. **Estado (State/Observation)**
   - La información que el agente recibe del entorno
   - En nuestro caso: la imagen de cada frame del juego (240x256 píxeles RGB)

4. **Acción (Action)**
   - Lo que el agente decide hacer en cada paso
   - En nuestro caso: una de 7 acciones posibles (NOOP, saltar, moverse derecha, etc.)

5. **Recompensa (Reward)**
   - Feedback numérico que indica qué tan buena fue la acción
   - En Super Mario Bros: avanza en X (+), pierde vida (-), mata enemigo (+), etc.

6. **Política (Policy)**
   - La estrategia que el agente aprende: "dado un estado, ¿qué acción debo tomar?"
   - Representada por una red neuronal

### El ciclo de Reinforcement Learning:

```
Estado actual (imagen del juego)
    ↓
Agente decide acción (ej: saltar)
    ↓
Ejecuta acción en el entorno
    ↓
Recibe nueva observación + recompensa
    ↓
Aprende: "¿fue buena o mala esta decisión?"
    ↓
Ajusta su política para tomar mejores decisiones en el futuro
    ↓
(Repite millones de veces)
```

---

## Tecnologías y Bibliotecas

### Stack tecnológico completo:

#### 1. **gym_super_mario_bros** (v7.3.0)
- **Qué es**: Entorno de OpenAI Gym específico para Super Mario Bros
- **Función**: Proporciona la interfaz entre Python y el emulador del juego
- **Características**:
  - Emula Super Mario Bros usando `nes_py`
  - Proporciona observaciones (imágenes del juego)
  - Recibe acciones y devuelve recompensas
  - Maneja el ciclo de reset/game over automáticamente

#### 2. **nes_py** (v8.2.1)
- **Qué es**: Emulador NES en Python
- **Función**: Ejecuta la ROM de Super Mario Bros y proporciona acceso a la RAM/estado del juego
- **Características**:
  - Emulación completa del NES
  - Acceso a memoria del juego
  - Renderizado de frames

#### 3. **stable-baselines3** (v1.6.2)
- **Qué es**: Biblioteca de algoritmos de Reinforcement Learning
- **Función**: Implementa PPO y otros algoritmos RL listos para usar
- **Características**:
  - Algoritmos optimizados y probados
  - Soporte para políticas basadas en CNNs (para imágenes)
  - Callbacks y logging integrados
  - Guardado/carga de modelos

#### 4. **PyTorch** (v1.13.1)
- **Qué es**: Framework de deep learning
- **Función**: Proporciona la infraestructura para las redes neuronales
- **Características**:
  - Redes neuronales convolucionales (CNNs)
  - Cálculo automático de gradientes
  - Optimización de parámetros
  - Soporte para CPU y GPU

#### 5. **gym** (v0.21.0)
- **Qué es**: Estándar de OpenAI para entornos de RL
- **Función**: Define la interfaz común entre agentes y entornos
- **Características**:
  - API estándar: `reset()`, `step()`, `render()`
  - Wrappers para modificar entornos

---

## Algoritmo: PPO (Proximal Policy Optimization)

### ¿Qué es PPO?

**PPO (Proximal Policy Optimization)** es un algoritmo de Reinforcement Learning propuesto por OpenAI en 2017. Es uno de los algoritmos más populares y efectivos para entrenar agentes en juegos.

### ¿Por qué PPO?

- ✅ **Estable**: Menos propenso a "romperse" durante el entrenamiento
- ✅ **Eficiente**: Aprende rápido con relativamente pocos datos
- ✅ **Robusto**: Funciona bien en muchos entornos diferentes
- ✅ **On-policy**: Aprende directamente de las interacciones actuales

### Conceptos clave de PPO:

#### 1. **Policy Gradient**
- La red neuronal (política) se entrena para maximizar la recompensa esperada
- Usa gradientes para ajustar los pesos de la red

#### 2. **Proximal**
- Limita qué tan "lejos" puede cambiar la política en cada actualización
- Esto evita que la política se rompa si actualiza demasiado rápido

#### 3. **Clipping**
- Si una actualización sería demasiado grande, la "recorta" (clip)
- Esto mantiene el entrenamiento estable

### Parámetros de PPO en nuestro proyecto:

```python
PPO(
    'CnnPolicy',          # Política: CNN para procesar imágenes
    env,                   # Entorno
    verbose=1,             # Logging
    n_steps=512,           # Pasos por actualización
    learning_rate=0.000001,# Tasa de aprendizaje (muy baja, aprendizaje lento pero estable)
    device="cpu"           # CPU o GPU
)
```

**Explicación de parámetros:**
- **n_steps=512**: El agente juega 512 pasos antes de actualizar la red
- **learning_rate=0.000001**: Qué tan rápido aprenden los pesos (muy conservador)
- **CnnPolicy**: Usa una Convolutional Neural Network para procesar imágenes

---

## Arquitectura del Sistema

### Flujo completo:

```
┌─────────────────────────────────────────────────────────────┐
│                    ENTORNO (Super Mario Bros)                │
│  ┌─────────────┐       ┌──────────────┐                    │
│  │  Emulador   │ ←──→  │  Observación │ (imagen 240x256x3) │
│  │   NES       │       │   (State)    │                    │
│  └─────────────┘       └──────────────┘                    │
│       ↑                         │                           │
│       │                         ↓                           │
│  ┌──────────────┐      ┌─────────────────────┐             │
│  │    Acción    │      │  Agente (Red Neur.) │             │
│  │  (ej: saltar)│ ←─── │  Política (PPO)     │             │
│  └──────────────┘      └─────────────────────┘             │
│       ↑                         │                           │
│       │                         ↓                           │
│  ┌──────────────┐      ┌─────────────────────┐             │
│  │  Recompensa  │ ←─── │  Ajuste de Pesos    │             │
│  │   (Reward)   │      │  (Entrenamiento)    │             │
│  └──────────────┘      └─────────────────────┘             │
└─────────────────────────────────────────────────────────────┘
```

### Arquitectura de la Red Neuronal:

La política usa una **CNN (Convolutional Neural Network)** con esta estructura:

```
Input: Imagen RGB (240x256x3)
    ↓
Convolución 1: Extrae características básicas (bordes, formas)
    ↓
Convolución 2: Detecta patrones más complejos
    ↓
Convolución 3: Reconoce objetos (Mario, enemigos, bloques)
    ↓
Flatten: Convierte a vector 1D
    ↓
Capa Densa 1: Procesa información abstracta
    ↓
Capa Densa 2: Toma decisión
    ↓
Output: Probabilidades para cada acción (7 acciones posibles)
```

### Acciones disponibles:

Usamos `SIMPLE_MOVEMENT` que proporciona 7 acciones:

```python
[
    ['NOOP'],           # 0: No hacer nada
    ['right'],          # 1: Mover derecha
    ['right', 'A'],     # 2: Mover derecha + saltar
    ['right', 'B'],     # 3: Mover derecha + correr
    ['right', 'A', 'B'],# 4: Mover derecha + saltar + correr
    ['A'],              # 5: Saltar
    ['left']            # 6: Mover izquierda
]
```

---

## Proceso de Entrenamiento

### Fase 1: Recolección de Experiencias (Rollout)

1. El agente (con política inicial aleatoria) juega el juego
2. Para cada frame:
   - Observa la imagen actual
   - Decide una acción usando la política actual
   - Ejecuta la acción
   - Recibe nueva observación + recompensa
   - Guarda la "experiencia": (estado, acción, recompensa, siguiente_estado)

3. Recolecta **n_steps** (512) experiencias

### Fase 2: Cálculo de Ventajas (Advantage)

- Calcula qué tan "buena" fue cada decisión comparada con el promedio
- Ventaja positiva = acción mejor que el promedio → aumentar probabilidad
- Ventaja negativa = acción peor que el promedio → disminuir probabilidad

### Fase 3: Actualización de la Política

- Usa las experiencias y ventajas para actualizar los pesos de la red
- Ajusta la política para aumentar la probabilidad de acciones "buenas"
- Usa "clipping" para evitar cambios demasiado grandes

### Fase 4: Repetición

- Repite Fase 1-3 millones de veces
- Con cada iteración, la política mejora gradualmente

### Ejemplo simplificado:

```
Iteración 1:
  - Política: Aleatoria
  - Mario salta al azar, muere rápido
  - Recompensa promedio: -50

Iteración 100:
  - Política: Aprendió que mover derecha es bueno
  - Mario avanza un poco antes de morir
  - Recompensa promedio: 200

Iteración 1000:
  - Política: Aprendió a saltar cuando hay enemigo
  - Mario sobrevive más tiempo
  - Recompensa promedio: 500

Iteración 10000:
  - Política: Aprendió estrategias complejas
  - Mario completa niveles
  - Recompensa promedio: 2000+
```

---

## Scripts Disponibles

### 1. `rl_demo_mario.py`

**Función**: Entrenar y jugar con la ROM estándar de Super Mario Bros.

**Uso básico:**
```bash
# Entrenar (default: 15000 timesteps)
python scripts/rl_demo_mario.py

# Entrenar con más timesteps
python scripts/rl_demo_mario.py --timesteps 50000

# Jugar con modelo entrenado
python scripts/rl_demo_mario.py --load mario_ppo_model.zip
```

**Características:**
- Usa la ROM estándar incluida en `gym_super_mario_bros`
- Configuración rápida para pruebas
- Parámetros: `n_steps=256`, `learning_rate=0.0003`

### 2. `mario_rl_custom_rom.py`

**Función**: Entrenar y jugar con ROMs personalizadas (ej: Mario invencible, cielo nocturno, etc.)

**Uso básico:**
```bash
# Entrenar con ROM personalizada (default: 1000000 timesteps)
python scripts/mario_rl_custom_rom.py roms/SuperMarioBros_star_infinite_20251028_231603.nes

# Jugar con modelo entrenado
python scripts/mario_rl_custom_rom.py roms/SuperMarioBros_star_infinite_20251028_231603.nes --load mario_invencible_model.zip
```

**Características:**
- Permite usar cualquier ROM modificada
- Corrige automáticamente el header de la ROM para compatibilidad
- Hace backup y restauración automática de la ROM original
- Parámetros según tutorial: `n_steps=512`, `learning_rate=0.000001`
- Entrenamiento largo (1,000,000 timesteps) para mejor aprendizaje

**IMPORTANTE**: Si usas una ROM modificada, debes **reentrenar** el modelo con esa ROM. Un modelo entrenado con ROM normal no sabe aprovechar las modificaciones (ej: invencibilidad).

---

## Configuración y Parámetros

### Entorno Python requerido:

**Versión**: Python 3.8 (requerido por `gym-retro` y compatibilidad)

**Dependencias específicas:**
```bash
pip install gym==0.21.0
pip install gym_super_mario_bros==7.3.0
pip install nes_py==8.2.1
pip install stable-baselines3==1.6.2
pip install torch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1
```

### Parámetros de entrenamiento:

#### Configuración rápida (`rl_demo_mario.py`):
```python
PPO(
    'CnnPolicy',
    env,
    n_steps=256,           # Menos pasos por actualización (más rápido)
    learning_rate=0.0003,  # Tasa más alta (aprende más rápido)
    batch_size=256,
    device="cpu"
)
model.learn(total_timesteps=15000)  # Entrenamiento corto
```

#### Configuración completa (`mario_rl_custom_rom.py`):
```python
PPO(
    'CnnPolicy',
    env,
    n_steps=512,           # Más pasos por actualización (más estable)
    learning_rate=0.000001,# Tasa muy baja (aprendizaje lento pero estable)
    device="cpu"
)
model.learn(total_timesteps=1000000)  # Entrenamiento largo
```

### Diferencias entre configuraciones:

| Parámetro | Rápida | Completa |
|-----------|--------|----------|
| **n_steps** | 256 | 512 |
| **learning_rate** | 0.0003 | 0.000001 |
| **total_timesteps** | 15,000 | 1,000,000 |
| **Tiempo estimado** | ~1 min | ~24-48 horas |
| **Calidad del modelo** | Básico | Avanzado |

---

## Cómo Funciona el Entrenamiento

### Paso a paso detallado:

#### 1. Inicialización
```python
env = gym_super_mario_bros.make("SuperMarioBros-v0")
env = JoypadSpace(env, SIMPLE_MOVEMENT)
```
- Crea el entorno del juego
- Limita a 7 acciones simples

#### 2. Creación del modelo
```python
model = PPO("CnnPolicy", env, ...)
```
- Inicializa la red neuronal con pesos aleatorios
- La política inicial es completamente aleatoria (no sabe jugar)

#### 3. Loop de entrenamiento

**Por cada iteración (512 pasos):**

```python
# Recolectar experiencias
for step in range(512):
    obs = env.get_current_screen()  # Imagen RGB
    action = model.predict(obs)      # Decisión de la red
    obs_new, reward, done = env.step(action)
    # Guarda: (obs, action, reward, obs_new)
```

#### 4. Cálculo de ventajas

```python
# Usa las recompensas recibidas para calcular:
advantage = reward - valor_esperado
# Si advantage > 0: acción fue buena
# Si advantage < 0: acción fue mala
```

#### 5. Actualización de la red

```python
# Ajusta los pesos para:
# - Aumentar probabilidad de acciones con advantage positivo
# - Disminuir probabilidad de acciones con advantage negativo
model.update(experiences, advantages)
```

#### 6. Repetición

- Repite pasos 3-5 hasta completar **total_timesteps**
- Con 1,000,000 timesteps: ~1953 iteraciones completas

### Qué aprende el agente en cada etapa:

**Etapa inicial (0-10,000 timesteps):**
- Aprende conceptos básicos: "mover derecha avanza"
- Muere frecuentemente
- Recompensa: -50 a 100

**Etapa intermedia (10,000-100,000 timesteps):**
- Aprende a saltar sobre obstáculos pequeños
- Sobrevive más tiempo
- Recompensa: 200-500

**Etapa avanzada (100,000-1,000,000 timesteps):**
- Aprende estrategias complejas
- Evita enemigos eficientemente
- Completa niveles
- Recompensa: 1000-5000+

---

## Métricas de Entrenamiento

Durante el entrenamiento, PPO muestra estas métricas:

### Métricas de tiempo:
- **fps**: Frames por segundo (velocidad de simulación)
- **iterations**: Número de actualizaciones completadas
- **time_elapsed**: Tiempo total de entrenamiento
- **total_timesteps**: Pasos totales ejecutados

### Métricas de entrenamiento:
- **approx_kl**: Divergencia KL aproximada (mide cambio en política)
  - Valores altos = política cambiando mucho
  - Valores bajos = política cambiando poco

- **clip_fraction**: Fracción de actualizaciones "recortadas"
  - Indica qué tan restrictiva es la actualización

- **entropy_loss**: Entropía de la política
  - Valores altos = política explora mucho (aleatoria)
  - Valores bajos = política es determinista

- **explained_variance**: Qué tan bien predice el valor
  - Valores cercanos a 1 = buenas predicciones
  - Valores negativos = predicciones peores que el promedio

- **loss**: Pérdida total del modelo
  - Disminuye con entrenamiento exitoso

- **policy_gradient_loss**: Pérdida de la política
  - Mide qué tan bien se ajusta la política

- **value_loss**: Pérdida del valor estimado
  - Mide qué tan bien estima recompensas futuras

### Interpretación:

Un entrenamiento saludable muestra:
- ✅ `loss` disminuyendo gradualmente
- ✅ `explained_variance` acercándose a 1
- ✅ `entropy_loss` disminuyendo (política se hace más segura)
- ✅ `approx_kl` en rango razonable (no demasiado alto)

---

## Resultados Esperados

### Con entrenamiento corto (15,000 timesteps):
- ⏱️ Tiempo: ~1-2 minutos
- 🎮 Resultado: Aprende movimientos básicos
- ⚠️ Limitaciones: No salta obstáculos consistentemente, muere frecuentemente

### Con entrenamiento completo (1,000,000 timesteps):
- ⏱️ Tiempo: ~24-48 horas (depende del hardware)
- 🎮 Resultado: Juega de forma competente
- ✅ Habilidades aprendidas:
  - Saltar sobre enemigos
  - Evitar obstáculos
  - Avanzar eficientemente
  - Completar niveles básicos
  - En ROM invencible: Aprovecha la invencibilidad para avanzar sin miedo

---

## Fixes Técnicos Implementados

### 1. Problema de "Negative Strides"

**Problema**: PyTorch no acepta arrays NumPy con strides negativos.

**Solución**: Función `ensure_contiguous()`:
```python
def ensure_contiguous(obs: np.ndarray) -> np.ndarray:
    """Devuelve una copia contigua lista para pasar a torch.as_tensor()"""
    if isinstance(obs, np.ndarray) and not obs.flags.c_contiguous:
        return np.ascontiguousarray(obs)
    return obs
```

### 2. Problema de Batch Dimension

**Problema**: Stable-Baselines3 espera observaciones con dimensión de batch.

**Solución**: Expandir dimensión si es necesario:
```python
if obs_input.ndim == 3:  # (H, W, C)
    obs_input = np.expand_dims(obs_input, axis=0)  # -> (1, H, W, C)
```

### 3. Problema de Tipo de Acción

**Problema**: `model.predict()` devuelve un array, pero `JoypadSpace` espera un entero.

**Solución**: Convertir a entero:
```python
if isinstance(action, np.ndarray):
    action = int(action.item())
```

### 4. Header de ROM

**Problema**: `nes_py` requiere que bytes  aventurero15 del header sean cero.

**Solución**: Corrección automática del header antes de usar la ROM.

---

## Casos de Uso

### Entrenar modelo para ROM normal:
```bash
python scripts/rl_demo_mario.py --timesteps 1000000
```

### Entrenar modelo para ROM invencible:
```bash
python scripts/mario_rl_custom_rom.py roms/SuperMarioBros_star_infinite_20251028_231603.nes --timesteps 1000000
```

### Demo con modelo entrenado:
```bash
python scripts/mario_rl_custom_rom.py roms/SuperMarioBros_star_infinite_20251028_231603.nes --load mario_invencible_model.zip --seconds 300
```

---

## Consideraciones Finales

### Ventajas de este enfoque:
- ✅ No requiere datos de entrenamiento pre-etiquetados
- ✅ El agente aprende explorando por sí mismo
- ✅ Puede descubrir estrategias no obvias
- ✅ Funciona con cualquier ROM (con reentrenamiento)

### Limitaciones:
- ⏱️ Entrenamiento requiere mucho tiempo
- 💻 Consume recursos computacionales significativos
- 🎯 Requiere ajuste fino de hiperparámetros para mejores resultados
- 🎮 La calidad depende mucho del tiempo de entrenamiento

### Mejoras posibles:
- Usar GPU para acelerar entrenamiento
- Ajustar hiperparámetros (learning rate, n_steps, etc.)
- Implementar reward shaping (diseñar mejores recompensas)
- Usar algoritmos más avanzados (SAC, TD3, etc.)
- Entrenar con múltiples niveles para generalización

---

*Documentación generada para el proyecto de ROM hacking y Reinforcement Learning con Super Mario Bros*

