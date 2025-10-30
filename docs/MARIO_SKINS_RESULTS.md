# Resultados de Skins de Mario

Tests de paleta completa de Mario modificando los 4 slots de color.

## Skin 1: "Skin Test 1"

**Paleta usada:** [0x22, 0x30, 0x0F, 0x15]

| Slot | Byte | Función en Mario | Color visible | Descripción exacta |
|------|------|------------------|---------------|--------------------|
| c0   | 0x22 | Piel             | VIOLETA OSCURO | El tono de piel aparece completamente violáceo, especialmente en la cara, brazos y piernas |
| c1   | 0x30 | Gorra / Camisa  | BLANCO PURO    | Tanto la gorra como la parte superior del cuerpo se ven totalmente blancas |
| c2   | 0x0F | Detalles oscuros (ojos, bigote, guantes sombreados) | NEGRO INTENSO | Este color se usa en ojos, bigote, manos y otras zonas de sombra del sprite, no como un contorno general sino para los rasgos oscuros |
| c3   | 0x15 | Overol / Pantalón | BLANCO | Aunque este valor debería dar un tono violeta oscuro, en el juego se muestra igual que el blanco de la gorra; los pantalones se ven completamente blancos |

---

## Skin 2: "Skin Test 2"

**Comando:** `python3 scripts/patch_mario_palette.py --c0 0x22 --c1 0x18 --c2 0x0F --c3 0x29`

**Paleta usada:** [0x22, 0x18, 0x0F, 0x29]

| Slot | Byte | Función en Mario | Color visible | Descripción exacta |
|------|------|------------------|---------------|--------------------|
| c0   | 0x22 | Piel             | VERDE CLARO AMARILLENTO | La cara, brazos y cuello aparecen de color verde claro, algo pálido |
| c1   | 0x18 | Gorra / Camisa  | VERDE OLIVA OSCURO | Tanto la gorra como la parte superior del cuerpo se ven de un verde apagado, más oscuro que el de la piel |
| c2   | 0x0F | Detalles oscuros (ojos, bigote, manos sombreadas) | NEGRO PURO | Los ojos, el bigote, las manos y otros rasgos oscuros se muestran totalmente negros |
| c3   | 0x29 | Overol / Pantalón | VERDE MEDIO | El pantalón tiene un tono verde medio, algo más brillante que la gorra, pero de la misma familia de color |

---

## Comandos para crear skins

```bash
# Skin 1
python3 scripts/patch_mario_palette.py --c0 0x22 --c1 0x30 --c2 0x0F --c3 0x15

# Skin 2
python3 scripts/patch_mario_palette.py --c0 0x22 --c1 0x18 --c2 0x0F --c3 0x29
```

