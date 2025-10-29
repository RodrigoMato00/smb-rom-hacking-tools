# Guía de Referencia de NES - Documentación Técnica

*Basado en la información de [NES Dev Wiki](https://wiki.nesdev.com/w/index.php/NES_reference_guide)*

## Contenido

- [Arquitectura del NES](#arquitectura-del-nes)
- [Formato de ROMs (.nes)](#formato-de-roms-nes)
- [Estructura de Memoria](#estructura-de-memoria)
- [Formato de Sprites (CHR)](#formato-de-sprites-chr)

## Arquitectura del NES

El Nintendo Entertainment System (NES) está compuesto por varios componentes clave:

### Componentes Principales

- **CPU (2A03)**: Procesador principal basado en el MOS 6502 modificado
  - Frecuencia: 1.79 MHz (NTSC) / 1.66 MHz (PAL)
  - Arquitectura de 8 bits
  - Ejecuta las instrucciones del juego

- **APU (Audio Processing Unit)**: Unidad de procesamiento de audio integrada en la CPU
  - 5 canales de sonido
  - 2 canales de pulso, 1 triángulo, 1 ruido, 1 DMC
  - Genera música y efectos de sonido

- **PPU (Picture Processing Unit)**: Unidad de procesamiento de imágenes
  - Resolución: 256x240 píxeles
  - Paleta de 64 colores (54 únicos)
  - Maneja sprites y fondos

- **Dispositivos de Entrada**: Controladores y periféricos
  - Controladores estándar de 2 botones
  - Zapper (pistola de luz)
  - Power Pad, etc.

## Formato de ROMs (.nes)

Las ROMs del NES utilizan principalmente el formato **iNES**:

### Estructura del Archivo iNES

```
Offset  Tamaño  Descripción
------  ------  -----------
0x00    4       Identificador "NES\x1A"
0x04    1       Número de bancos PRG-ROM (16KB cada uno)
0x05    1       Número de bancos CHR-ROM (8KB cada uno)
0x06    1       Flags de control 1
0x07    1       Flags de control 2
0x08    1       Número de bancos PRG-RAM (8KB cada uno)
0x09    7       Reservado (debe ser 0)
0x10    ?       Datos PRG-ROM
?       ?       Datos CHR-ROM
```

### Componentes de la ROM

- **Cabecera (Header)**: 16 bytes con metadatos del juego
- **PRG-ROM**: Código del programa del juego
- **CHR-ROM**: Datos gráficos (sprites, tiles, fondos)

### Formatos Alternativos

- **NES 2.0**: Extensión del formato iNES con más capacidades
- **UNIF**: Formato alternativo menos común

## Estructura de Memoria

### Mapeo de Memoria del NES

```
Rango de Direcciones  Tamaño  Descripción
--------------------  ------  -----------
$0000-$07FF           2KB     RAM de trabajo (mirrored)
$0800-$0FFF           2KB     Mirror de RAM
$1000-$17FF           2KB     Mirror de RAM
$1800-$1FFF           2KB     Mirror de RAM
$2000-$2007           8B      Registros PPU
$2008-$3FFF           8KB     Mirror de registros PPU
$4000-$4017           24B     Registros APU e I/O
$4018-$401F           8B      Registros de prueba (no usar)
$4020-$FFFF           ~48KB   Espacio del cartucho
```

### Áreas de Memoria Clave

- **RAM de Trabajo**: 2KB de RAM interna para variables del juego
- **Registros PPU**: Control de gráficos y sprites
- **Registros APU**: Control de audio
- **Espacio del Cartucho**: Donde se mapea la PRG-ROM

## Formato de Sprites (CHR)

### Estructura de Tiles

Los gráficos en el NES se almacenan como **tiles de 8x8 píxeles**:

- **Resolución**: 8x8 píxeles por tile
- **Colores**: 4 colores por tile (incluyendo transparente)
- **Planos**: Cada tile usa 2 planos de bits

### Formato de Datos CHR

```
Cada tile de 8x8 píxeles requiere 16 bytes:
- Bytes 0-7:  Plano de bits inferior
- Bytes 8-15: Plano de bits superior
```

### Paletas de Colores

- **Paletas de Sprites**: 4 paletas de 4 colores cada una
- **Paletas de Fondo**: 4 paletas de 4 colores cada una
- **Colores Totales**: 64 colores en la paleta del sistema

### Ubicación en Memoria

- **CHR-ROM**: Gráficos almacenados en el cartucho
- **VRAM**: Memoria de video de la PPU (2KB)
- **Patrones**: Tiles organizados en patrones de 8x8

## Herramientas Recomendadas

### Para Análisis
- **Hex Editor**: HxD, Hex Fiend
- **Emuladores**: FCEUX, Nestopia, Mesen

### Para Edición
- **Tile Layer Pro**: Editor de gráficos NES
- **NES Screen Tool**: Visualizador de pantallas
- **Python Libraries**: `python-nes`, `pyNES`

---

*Esta documentación se basa en la información técnica disponible en [NES Dev Wiki](https://wiki.nesdev.com/w/index.php/NES_reference_guide)*
