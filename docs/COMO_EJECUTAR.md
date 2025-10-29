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
python3 scripts/main.py
```

## Cambiar la ROM

### Ubicación del Archivo
El archivo `scripts/main.py` contiene la configuración de la ROM en la línea 11:

```python
nes = NES("/Users/rodrigomato/charla/roms/SuperMarioBros.nes", sync_mode=2)
```

### Para Cambiar la ROM
1. **Coloca tu ROM** en la carpeta `roms/`
2. **Edita la línea 11** en `scripts/main.py`:
   ```python
   nes = NES("/Users/rodrigomato/charla/roms/TU_ROM.nes", sync_mode=2)
   ```
3. **Ejecuta** el emulador normalmente

### Ejemplo de Cambio
```python
# ROM original
nes = NES("/Users/rodrigomato/charla/roms/SuperMarioBros.nes", sync_mode=2)

# Cambiar a otra ROM
nes = NES("/Users/rodrigomato/charla/roms/DonkeyKong.nes", sync_mode=2)
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
```python
nes = NES("ruta/a/tu/rom.nes", sync_mode=2)
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
- Usar **rutas absolutas** para evitar problemas
- Verificar que la ROM existe en la ubicación especificada

### Dependencias Faltantes
```bash
pip install -r requirements.txt
```

## Estructura del Proyecto

```
charla/
├── roms/                    # ROMs del juego
│   └── SuperMarioBros.nes
├── scripts/                 # Scripts de Python
│   └── main.py             # Archivo principal del emulador
├── venv/                   # Entorno virtual
└── requirements.txt        # Dependencias
```
