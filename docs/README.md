# Documentación del Proyecto Super Mario Bros

Este directorio contiene toda la documentación técnica del proyecto de modificación de Super Mario Bros.

## Compatibilidad y entornos

- Emulador y scripts de parcheo: Python 3.13 (instalar `pyntendo` local)
- Demo de IA (RL): Python 3.8 con versiones fijadas (gym 0.21.0, nes_py 8.2.1, gym_super_mario_bros 7.3.0, SB3 1.6.2, torch 1.13.1)

Comandos rápidos para crear entornos y ejecutar están en el README principal (sección “Inicio Rápido” y “Demo de IA”).

### Demo de IA (Python 3.8)
Usar `requirements-rl.txt` para instalar dependencias pinneadas:
```bash
python3.8 -m venv venv38
source venv38/bin/activate
pip install -r requirements-rl.txt
```

## Archivos de Documentación

### Scripts y Herramientas
- **[SCRIPTS_DOCUMENTATION.md](SCRIPTS_DOCUMENTATION.md)** - Documentación completa de todos los scripts de modificación
  - `patch_sky_night.py` - Modificar cielo para efecto noche
  - `patch_mario_palette.py` - Crear skins personalizados de Mario
  - `patch_chr_range.py` - Mutar tiles específicos en CHR-ROM
  - `patch_star_permanent.py` - Hacer a Mario invencible permanentemente
  - `patch_title_message.py` - Modificar texto del título del juego
  - `patch_start_world_area_smart.py` - Parchear mundo/nivel de inicio
  - `rl_demo_mario.py` - Demo de RL (entrenar y jugar automáticamente)
  - `rl_demo_mario_custom.py` - Demo RL con ROMs personalizadas
  - `main.py` - Emulador NES para probar ROMs modificadas

### Estructura del Juego
- **[GAME_STRUCTURE.md](GAME_STRUCTURE.md)** - Análisis técnico de la arquitectura del juego
  - Arquitectura general y memoria
  - Sistema de paletas y colores
  - Sistema de colisiones y gameplay
  - Rutinas principales y flujo de ejecución
  - Datos y tablas importantes

### Guías y Referencias
- **[nes-reference-guide.md](nes-reference-guide.md)** - Guía de referencia técnica para NES
- **[COMO_EJECUTAR.md](COMO_EJECUTAR.md)** - Instrucciones de ejecución del proyecto
- **[PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)** - Estructura general del proyecto

### Resultados y Pruebas
- **[COLOR_TEST_RESULTS.md](COLOR_TEST_RESULTS.md)** - Resultados de pruebas de colores
- **[MARIO_SKINS_RESULTS.md](MARIO_SKINS_RESULTS.md)** - Resultados de skins de Mario creados

## Uso de la Documentación

### Para Desarrolladores
1. **Lee `GAME_STRUCTURE.md`** para entender cómo funciona Super Mario Bros internamente
2. **Consulta `SCRIPTS_DOCUMENTATION.md`** para usar las herramientas de modificación
3. **Combina ambos documentos** para crear modificaciones personalizadas

### Para Usuarios
1. **Ve a `SCRIPTS_DOCUMENTATION.md`** para aprender a usar los scripts
2. **Sigue los ejemplos** para crear tus propias modificaciones
3. **Experimenta** con diferentes combinaciones de modificaciones

## Estructura del Proyecto
```
charla/
├── docs/                           # Documentación técnica
│   ├── SCRIPTS_DOCUMENTATION.md    # Guía de scripts
│   └── GAME_STRUCTURE.md           # Arquitectura del juego
├── scripts/                        # Herramientas de modificación
│   ├── patch_sky_night.py
│   ├── patch_mario_palette.py
│   ├── patch_chr_range.py
│   ├── patch_star_permanent.py
│   ├── patch_title_message.py
│   ├── patch_start_world_area_smart.py
│   ├── rl_demo_mario.py
│   ├── rl_demo_mario_custom.py
│   └── main.py
├── roms/                           # ROMs originales y modificadas
│   └── SuperMarioBros.nes
└── smb-disassembly/               # Archivos de assembler
    ├── mario.txt
    └── SuperMarioBros_disasm.asm
```

## Recursos Adicionales

### Archivos de Referencia
- **`scripts/mario.txt`** - Desensamblado completo del juego (15,674 líneas)
- **`scripts/SuperMarioBros_disasm.asm`** - Assembler fuente (13,114 líneas)
- **`smb-disassembly/`** - Archivos adicionales de desensamblado

### Herramientas Necesarias
- **Python 3.13 (emulador/patches)** y **Python 3.8 (RL)**
- **Emulador NES** - Para probar las ROMs modificadas
- **Editor hexadecimal** - Para análisis avanzado (opcional)

## Inicio Rápido

1. **Lee la documentación**: Comienza con `GAME_STRUCTURE.md`
2. **Prueba los scripts**: Sigue los ejemplos en `SCRIPTS_DOCUMENTATION.md`
3. **Experimenta**: Combina diferentes modificaciones
4. **Comparte**: Crea tus propias ROMs personalizadas

---
