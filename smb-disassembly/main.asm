
; Super Mario Bros. Main Code

.segment "PRG"

; Datos del título modificado
TitleScreenData:
    .byte $20, $a6, $54, $26  ; Datos del título
    .byte $20, $c6, $54, $26
    .byte $20, $e6, $54, $26
    .byte $21, $06, $54, $26
    
    ; Título modificado: "MARIO PYTHON MEETUP"
    .byte $20, $85, $01, $44
    .byte $20, $86, $54, $48
    .byte $20, $9a, $01, $49
    .byte $20, $a5, $c9, $46
    
    ; Nuevos tiles para "MARIO PYTHON MEETUP"
    .byte $20, $ba, $c9, $4a
    .byte $20, $a6, $0a, $16  ; M
    .byte $0a, $1b, $12, $18  ; A R I O
    .byte $20, $c6, $0a, $19  ; P
    .byte $22, $1d, $11, $18  ; Y T H N
    .byte $20, $e6, $0a, $16  ; M
    .byte $0e, $0e, $1d, $1e  ; E E T U
    .byte $19, $21, $06, $0a  ; P
    
    ; Más datos del título...
    .byte $d4, $d5, $d4, $d9
    .byte $db, $e2, $d4, $da
    .byte $db, $e0, $21, $06
    .byte $0a, $d6, $d7, $d6
    .byte $d7, $e1, $26, $d6
    .byte $dd, $e1, $e1, $21
    .byte $26, $14, $d0, $e8
    .byte $d1, $d0, $d1, $de
    .byte $d1, $d8, $d0, $d1
    .byte $26, $de, $d1, $de
    .byte $d1, $d0, $d1, $d0
    .byte $d1, $26, $21, $46
    .byte $14, $db, $42, $42
    .byte $db, $42, $db, $42
    .byte $db, $db, $42, $26
    .byte $db, $42, $db, $42
    .byte $db, $42, $db, $42
    .byte $26, $21, $66, $46
    .byte $db, $21, $6c, $0e
    .byte $df, $db, $db, $db
    .byte $26, $db, $df, $db
    .byte $df, $db, $db, $e4
    .byte $e5, $26, $21, $86
    .byte $14, $db, $db, $db
    .byte $de, $43, $db, $e0
    .byte $db, $db, $db, $26
    .byte $db, $e3, $db, $e0
    .byte $db, $db, $e6, $e3
    .byte $26, $21, $a6, $14
    .byte $db, $db, $db, $db
    .byte $42, $db, $db, $db
    .byte $d4, $d9, $26, $db
    .byte $d9, $db, $db, $d4
    .byte $d9, $d4, $d9, $e7
    .byte $21, $c5, $16, $5f
    .byte $95, $95, $95, $95
    .byte $95, $95, $95, $95
    .byte $95, $97, $98, $78
    .byte $95, $96, $95, $95
    .byte $97, $98, $97, $98
    .byte $95, $7a, $21, $ed
    .byte $0e, $cf, $01, $09
    .byte $08, $05, $24, $17
    .byte $12, $17, $1d, $0e
    .byte $17, $0d, $18, $22
    .byte $4b, $0d, $01, $24
    .byte $19, $15, $0a, $22
    .byte $0e, $1b, $24, $10
    .byte $0a, $16, $0e, $22
    .byte $8b, $0d, $02, $24
    .byte $19, $15, $0a, $22
    .byte $0e, $1b, $24, $10
    .byte $0a, $16, $0e, $22
    .byte $ec, $04, $1d, $18
    .byte $19, $28, $22, $f6
    .byte $01, $00, $23, $c9
    .byte $56, $55, $23, $e2
    .byte $04, $99, $aa, $aa
    .byte $aa, $23, $ea, $04
    .byte $99, $aa, $aa, $aa
    .byte $00, $ff, $ff, $ff
    .byte $ff, $ff, $ff, $ff
    .byte $ff, $ff, $ff, $ff
    .byte $ff, $ff, $ff, $ff
