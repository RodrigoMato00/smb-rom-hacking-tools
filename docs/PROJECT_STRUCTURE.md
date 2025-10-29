# Estructura del Proyecto - Super Mario Bros ROM Hacking

## Organización de Carpetas

```
charla/
├── docs/                           # Documentación
│   ├── README.md                   # Descripción de la charla
│   └── nes-reference-guide.md      # Guía técnica de NES
├── roms/                          # Archivos ROM
│   └── Super Mario Bros.nes       # ROM original (40KB)
├── scripts/                       # Scripts y herramientas
│   ├── mario.txt                  # Disassembly en texto
│   ├── SuperMarioBros.dis65       # Proyecto SourceGen
│   └── SMBHelp.cs                 # Plugin de SourceGen
├── venv/                          # Entorno virtual Python
├── requirements.txt               # Dependencias del proyecto
└── PROJECT_STRUCTURE.md           # Este archivo
```

## Descripción de Archivos

### 📁 docs/
- **README.md**: Descripción de la charla sobre modificación de ROMs
- **nes-reference-guide.md**: Documentación técnica del NES

### 📁 roms/
- **Super Mario Bros.nes**: ROM original del juego (40,976 bytes)

### 📁 scripts/
- **mario.txt**: Disassembly completo comentado del juego
- **SuperMarioBros.dis65**: Proyecto de SourceGen con análisis avanzado
- **SMBHelp.cs**: Plugin específico para Super Mario Bros

### 📁 venv/
- Entorno virtual de Python para el proyecto

## Próximos Pasos

1. **Activar entorno virtual**: `source venv/bin/activate`
2. **Instalar dependencias**: `pip install -r requirements.txt`
3. **Crear scripts Python** para modificar sprites
4. **Probar modificaciones** en emulador

## Comandos Útiles

```bash
# Activar entorno virtual
source venv/bin/activate

# Instalar dependencias
pip install -r requirements.txt

# Desactivar entorno virtual
deactivate
```
