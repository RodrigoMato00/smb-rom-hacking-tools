# Cómo Ejecutar Super Mario Bros con Pyntendo

## Prerrequisitos

### Entorno Virtual
```bash
# Activar entorno virtual
source venv/bin/activate
```

### Dependencias Instaladas
- **pyntendo** - Emulador NES
- **pygame** - Interfaz gráfica y controles
- **pyaudio** - Audio (requiere PortAudio instalado)
- **Cython** - Dependencia de pyntendo

## Ejecutar el Emulador

### Comando Básico
```bash
cd /Users/rodrigomato/charla
source venv/bin/activate
python3 scripts/main.py roms/SuperMarioBros.nes
```

## Cambiar la ROM

### Ubicación del Archivo
Coloca tus ROMs en la carpeta `roms/` del proyecto.

### Para Cambiar la ROM
1. **Copia tu ROM** en `roms/`
2. **Ejecuta** pasando la ruta de la ROM como argumento:
   ```bash
   python3 scripts/main.py roms/TU_ROM.nes
   ```

### Ejemplo de Cambio
```bash
# ROM original
python3 scripts/main.py roms/SuperMarioBros.nes

# Cambiar a otra ROM
python3 scripts/main.py roms/DonkeyKong.nes
```

## Controles

### Movimiento
- **Arriba**: `W`
- **Izquierda**: `A`
- **Abajo**: `S`
- **Derecha**: `D`

### Botones del Control
- **Select**: `G`
- **Start**: `H`
- **A**: `P`
- **B**: `L`

### Controles del Sistema
- **Apagar OSD**: `1`
- **Iniciar logging CPU**: `2`
- **Bajar volumen**: `-`
- **Subir volumen**: `=`
- **Silenciar**: `0`

## Modos de Sincronización

### Valores Disponibles
- **sync_mode=0** - Sin sincronización (muy rápido, música entrecortada)
- **sync_mode=1** - Sincronización con audio (velocidad perfecta, puede tener glitches)
- **sync_mode=2** - Sincronización con pygame (confiable, algo de screen tearing)
- **sync_mode=3** - Sincronización con vsync (requiere ~60Hz vsync, sin tearing)

### Recomendado
```bash
python3 scripts/main.py roms/SuperMarioBros.nes --sync-mode 2
```

## Solución de Problemas

### Sin Audio
```bash
# Instalar PortAudio (macOS)
brew install portaudio

# Instalar PyAudio
pip install pyaudio
```

### Error de Ruta
- Usar **rutas relativas** al root del proyecto (p. ej. `roms/SuperMarioBros.nes`)
- Verificar que la ROM existe en la ubicación especificada

### Dependencias Faltantes
```bash
pip install -r requirements.txt
```

## Estructura del Proyecto

```
charla/
├── disassembly/            # Desensamblados y assets de ASM/65xx
├── roms/                   # ROMs del juego
│   └── SuperMarioBros.nes
├── scripts/                # Scripts de Python soportados
│   ├── main.py             # Emulador (pasar ROM por argumento)
│   ├── patch_*.py          # Scripts de modificación
│   └── rl_demo_mario.py     # Demo RL
├── venv/                   # Entorno virtual
└── requirements.txt        # Dependencias
```
