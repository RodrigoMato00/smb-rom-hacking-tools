# Documentación del Proyecto Super Mario Bros

Este directorio contiene toda la documentación técnica del proyecto de modificación de Super Mario Bros.

## 📋 Archivos de Documentación

### Scripts y Herramientas
- **[SCRIPTS_DOCUMENTATION.md](SCRIPTS_DOCUMENTATION.md)** - Documentación completa de todos los scripts de modificación
  - `patch_sky_palette_final.py` - Modificar cielo para efecto noche
  - `patch_mario_full.py` - Crear skins personalizados de Mario
  - `mutate_chr_range_args.py` - Mutar tiles específicos en CHR-ROM
  - `patch_star_invincible.py` - Hacer a Mario invencible permanentemente
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

## 🎯 Uso de la Documentación

### Para Desarrolladores
1. **Lee `GAME_STRUCTURE.md`** para entender cómo funciona Super Mario Bros internamente
2. **Consulta `SCRIPTS_DOCUMENTATION.md`** para usar las herramientas de modificación
3. **Combina ambos documentos** para crear modificaciones personalizadas

### Para Usuarios
1. **Ve a `SCRIPTS_DOCUMENTATION.md`** para aprender a usar los scripts
2. **Sigue los ejemplos** para crear tus propias modificaciones
3. **Experimenta** con diferentes combinaciones de modificaciones

## 🔧 Estructura del Proyecto

```
charla/
├── docs/                           # Documentación técnica
│   ├── SCRIPTS_DOCUMENTATION.md    # Guía de scripts
│   └── GAME_STRUCTURE.md           # Arquitectura del juego
├── scripts/                        # Herramientas de modificación
│   ├── patch_sky_palette_final.py
│   ├── patch_mario_full.py
│   ├── mutate_chr_range_args.py
│   └── patch_star_invincible.py
├── roms/                           # ROMs originales y modificadas
│   └── SuperMarioBros.nes
└── smb-disassembly/               # Archivos de assembler
    ├── mario.txt
    └── SuperMarioBros_disasm.asm
```

## 📚 Recursos Adicionales

### Archivos de Referencia
- **`scripts/mario.txt`** - Desensamblado completo del juego (15,674 líneas)
- **`scripts/SuperMarioBros_disasm.asm`** - Assembler fuente (13,114 líneas)
- **`smb-disassembly/`** - Archivos adicionales de desensamblado

### Herramientas Necesarias
- **Python 3.6+** - Para ejecutar los scripts
- **Emulador NES** - Para probar las ROMs modificadas
- **Editor hexadecimal** - Para análisis avanzado (opcional)

## 🚀 Inicio Rápido

1. **Lee la documentación**: Comienza con `GAME_STRUCTURE.md`
2. **Prueba los scripts**: Sigue los ejemplos en `SCRIPTS_DOCUMENTATION.md`
3. **Experimenta**: Combina diferentes modificaciones
4. **Comparte**: Crea tus propias ROMs personalizadas

---

*Documentación mantenida para el proyecto de modificación de Super Mario Bros*