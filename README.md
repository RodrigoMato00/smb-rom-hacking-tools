# Proyecto Super Mario Bros - Modificaciones y Herramientas

Este proyecto contiene herramientas para modificar Super Mario Bros (NES) y crear ROMs personalizadas con diferentes efectos visuales y de gameplay.

## 🚀 Inicio Rápido

### Requisitos
- Python 3.8 (no fue mi primer eleccion, es porque me daba problemas con la version 3.13 y 3.14 con el gym_retro de openai)
- Biblioteca `nes` instalada
- ROM original de Super Mario Bros

### Instalación
```bash

# Instalar dependencias
pip install -r requirements.txt

# Crear entorno virtual (recomendado)
python -m venv venv
source venv/bin/activate  # En Windows: venv\Scripts\activate
pip install -r requirements.txt
```

### Uso Básico
```bash
# Crear ROM con cielo nocturno
python3 scripts/patch_sky_night.py

# Crear skin personalizado de Mario
python3 scripts/patch_mario_palette.py --c0 0x22 --c1 0x30 --c2 0x0F --c3 0x15

# Hacer a Mario invencible
python3 scripts/patch_star_permanent.py

# Probar ROM modificada
python3 scripts/main.py roms/SuperMarioBros_sky_night_20251029_123456.nes
```

## 📚 Documentación Completa

Toda la documentación técnica está disponible en el directorio [`docs/`](docs/):

- **[docs/README.md](docs/README.md)** - Índice principal de documentación
- **[docs/SCRIPTS_DOCUMENTATION.md](docs/SCRIPTS_DOCUMENTATION.md)** - Guía completa de scripts
- **[docs/GAME_STRUCTURE.md](docs/GAME_STRUCTURE.md)** - Arquitectura del juego
- **[docs/COMO_EJECUTAR.md](docs/COMO_EJECUTAR.md)** - Instrucciones detalladas

## 🔧 Scripts Disponibles

| Script | Descripción |
|--------|-------------|
| `patch_sky_night.py` | Modificar cielo para efecto noche |
| `patch_mario_palette.py` | Crear skins personalizados de Mario |
| `patch_chr_range.py` | Mutar tiles específicos en CHR-ROM |
| `patch_star_permanent.py` | Hacer a Mario invencible permanentemente |
| `patch_title_message.py` | Modificar texto del título del juego |
| `main.py` | Emulador NES para probar ROMs modificadas |

## 📁 Estructura del Proyecto

```
charla/
├── docs/                    # 📚 Documentación completa
├── scripts/                 # 🔧 Herramientas de modificación
├── roms/                    # 🎮 ROMs originales y modificadas
├── smb-disassembly/         # 📖 Archivos de assembler
├── extracted_sprites_real/  # 🎨 Sprites extraídos
└── requirements.txt         # 📦 Dependencias
```

## 🎯 Características

- ✅ **Modificación de paletas**: Cambiar colores del cielo, Mario, enemigos
- ✅ **Skins personalizados**: Crear variaciones visuales de Mario
- ✅ **Hacks de gameplay**: Invencibilidad, efectos especiales
- ✅ **Mutación de tiles**: Modificar gráficos específicos
- ✅ **Emulador integrado**: Probar modificaciones directamente
- ✅ **Documentación completa**: Guías técnicas detalladas

## 🎮 Ejemplos de Modificaciones

### Cielo Nocturno
```bash
python3 scripts/patch_sky_night.py
# Resultado: ROM con cielo oscuro estilo noche
```

### Mario Zombie
```bash
python3 scripts/patch_mario_palette.py --c0 0x29 --c1 0x15 --c2 0x0F --c3 0x27
# Resultado: Mario con colores zombie (piel verde, ropa oscura)
```

### Mario Invencible
```bash
python3 scripts/patch_star_permanent.py
# Resultado: Mario nunca recibe daño, mata enemigos al tocarlos
```

### Texto Personalizado del Título
```bash
python3 scripts/patch_title_message.py
# Resultado: Cambia "WORLD  TIME" por "PYTHON MEETUP MVD" en la pantalla de título
```

## 📖 Recursos Adicionales

- **Desensamblado completo**: `scripts/mario.txt` (15,674 líneas)
- **Assembler fuente**: `scripts/SuperMarioBros_disasm.asm`
- **Sprites extraídos**: `extracted_sprites_real/` (tiles individuales)

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto es para fines educativos y de investigación. Super Mario Bros es propiedad de Nintendo.

---

*Proyecto de modificación de Super Mario Bros - Herramientas y documentación técnica*
