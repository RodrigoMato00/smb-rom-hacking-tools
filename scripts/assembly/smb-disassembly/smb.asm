
; Configuración para ensamblador 6502
; Super Mario Bros. Disassembly

.include "smb.inc"

.segment "HEADER"
    .byte "NES", $1a
    .byte $02, $01, $01, $00
    .byte $00, $00, $00, $00
    .byte $00, $00, $00, $00

.segment "PRG"
    .include "main.asm"

.segment "CHR"
    .incbin "smb.chr"
