
; Super Mario Bros. Simplified Assembly
; Solo modificar el título

.segment "HEADER"
    .byte "NES", $1a
    .byte $02, $01, $01, $00
    .byte $00, $00, $00, $00
    .byte $00, $00, $00, $00

.segment "PRG"
    .include "title_data.asm"

.segment "CHR"
    .incbin "smb.chr"
