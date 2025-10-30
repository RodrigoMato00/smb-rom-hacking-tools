Unable to locate pyusb library
;  HEADER - MAPPER 0 - NROM
        .db "NES", $1a
        .db 2  ; PRG ROM banks
        .db 1  ; CHR ROM banks
        .db $01 ; Mapper, mirroring, battery, trainer
        .db $08 ; Mapper, VS/Playchoice, NES 2.0 Header
        .db 0  ; PRG-RAM size (rarely used)
        .db 0  ; TV system (rarely used)
        .db 0  ; TV system, PRG-RAM presense (unofficial, rarely used)
        .db $00, $02, $00, $00, $01 ; Unused padding

;  MMIO
        PPUCTRL    EQU $2000
        PPUMASK    EQU $2001
        PPUSTATUS  EQU $2002
        OAMADDR    EQU $2003
        OAMDATA    EQU $2004
        PPUSCROLL  EQU $2005
        PPUADDR    EQU $2006
        PPUDATA    EQU $2007
        SQ1_VOL    EQU $4000
        SQ1_SWEEP  EQU $4001
        SQ1_LO     EQU $4002
        SQ1_HI     EQU $4003
        SQ2_VOL    EQU $4004
        SQ2_SWEEP  EQU $4005
        SQ2_LO     EQU $4006
        SQ2_HI     EQU $4007
        TRI_LINEAR EQU $4008
        TRI_LO     EQU $400a
        TRI_HI     EQU $400b
        NOISE_VOL  EQU $400c
        NOISE_PER  EQU $400e
        NOISE_LEN  EQU $400f
        DMC_FREQ   EQU $4010
        DMC_RAW    EQU $4011
        DMC_START  EQU $4012
        DMC_LEN    EQU $4013
        OAMDMA     EQU $4014
        SND_CHN    EQU $4015
        JOY1       EQU $4016
        JOY2       EQU $4017

.base $8000

            sei                         ; 00000:  78
            cld                         ; 00001:  d8
            lda #$10                    ; 00002:  a9 10
            sta PPUCTRL                 ; 00004:  8d 00 20
            ldx #$ff                    ; 00007:  a2 ff
            txs                         ; 00009:  9a
b0_800a:    lda PPUSTATUS               ; 0000A:  ad 02 20
            bpl b0_800a                 ; 0000D:  10 fb
b0_800f:    lda PPUSTATUS               ; 0000F:  ad 02 20
            bpl b0_800f                 ; 00012:  10 fb
            ldy #$fe                    ; 00014:  a0 fe
            ldx #$05                    ; 00016:  a2 05
b0_8018:    lda $07d7,x                 ; 00018:  bd d7 07
            cmp #$0a                    ; 0001B:  c9 0a
            bcs b0_802b                 ; 0001D:  b0 0c
            dex                         ; 0001F:  ca
            bpl b0_8018                 ; 00020:  10 f6
            lda $07ff                   ; 00022:  ad ff 07
            cmp #$a5                    ; 00025:  c9 a5
            bne b0_802b                 ; 00027:  d0 02
            ldy #$d6                    ; 00029:  a0 d6
b0_802b:    jsr b0_90cc                 ; 0002B:  20 cc 90
            sta DMC_RAW                 ; 0002E:  8d 11 40
            sta $0770                   ; 00031:  8d 70 07
            lda #$a5                    ; 00034:  a9 a5
            sta $07ff                   ; 00036:  8d ff 07
            sta $07a7                   ; 00039:  8d a7 07
            lda #$0f                    ; 0003C:  a9 0f
            sta SND_CHN                 ; 0003E:  8d 15 40
            lda #$06                    ; 00041:  a9 06
            sta PPUMASK                 ; 00043:  8d 01 20
            jsr b0_8220                 ; 00046:  20 20 82
            jsr b0_8e19                 ; 00049:  20 19 8e
            inc $0774                   ; 0004C:  ee 74 07
            lda $0778                   ; 0004F:  ad 78 07
            ora #$80                    ; 00052:  09 80
            jsr b0_8eed                 ; 00054:  20 ed 8e
b0_8057:    jmp b0_8057                 ; 00057:  4c 57 80

b0_805a:    ora ($a4,x)                 ; 0005A:  01 a4
            iny                         ; 0005C:  c8
            hex ec 10 00 ; cpx $0010    ; 0005D:  ec 10 00
            eor ($41,x)                 ; 00060:  41 41
            jmp $3c34                   ; 00062:  4c 34 3c

tab_b0_8065: ; 16 bytes
            hex 44 54 68 7c a8 bf de ef ; 00065:  44 54 68 7c a8 bf de ef
            hex 03 8c 8c 8c 8d 03 03 03 ; 0006D:  03 8c 8c 8c 8d 03 03 03

            sta $8d8d                   ; 00075:  8d 8d 8d
            sta $8d8d                   ; 00078:  8d 8d 8d
            sta $8d8d                   ; 0007B:  8d 8d 8d
b0_807e:    hex 8d 8d 00 ; sta $008d    ; 0007E:  8d 8d 00
            rti                         ; 00081:  40

            lda $0778                   ; 00082:  ad 78 07
            and #$7f                    ; 00085:  29 7f
            sta $0778                   ; 00087:  8d 78 07
            and #$7e                    ; 0008A:  29 7e
            sta PPUCTRL                 ; 0008C:  8d 00 20
            lda $0779                   ; 0008F:  ad 79 07
            and #$e6                    ; 00092:  29 e6
            ldy $0774                   ; 00094:  ac 74 07
            bne b0_809e                 ; 00097:  d0 05
            lda $0779                   ; 00099:  ad 79 07
            ora #$1e                    ; 0009C:  09 1e
b0_809e:    sta $0779                   ; 0009E:  8d 79 07
            and #$e7                    ; 000A1:  29 e7
            sta PPUMASK                 ; 000A3:  8d 01 20
            ldx PPUSTATUS               ; 000A6:  ae 02 20
            lda #$00                    ; 000A9:  a9 00
            jsr b0_8ee6                 ; 000AB:  20 e6 8e
            sta OAMADDR                 ; 000AE:  8d 03 20
            lda #$02                    ; 000B1:  a9 02
            sta OAMDMA                  ; 000B3:  8d 14 40
            ldx $0773                   ; 000B6:  ae 73 07
            lda b0_805a,x               ; 000B9:  bd 5a 80
            sta $00                     ; 000BC:  85 00
            lda tab_b0_8065+8,x         ; 000BE:  bd 6d 80
            sta $01                     ; 000C1:  85 01
            jsr b0_8edd                 ; 000C3:  20 dd 8e
            ldy #$00                    ; 000C6:  a0 00
            ldx $0773                   ; 000C8:  ae 73 07
            cpx #$06                    ; 000CB:  e0 06
            bne b0_80d0                 ; 000CD:  d0 01
            iny                         ; 000CF:  c8
b0_80d0:    ldx b0_807e+2,y             ; 000D0:  be 80 80
            lda #$00                    ; 000D3:  a9 00
            sta $0300,x                 ; 000D5:  9d 00 03
            sta $0301,x                 ; 000D8:  9d 01 03
            sta $0773                   ; 000DB:  8d 73 07
            lda $0779                   ; 000DE:  ad 79 07
            sta PPUMASK                 ; 000E1:  8d 01 20
            jsr $f2d0                   ; 000E4:  20 d0 f2
            jsr b0_8e5c                 ; 000E7:  20 5c 8e
            jsr b0_8182                 ; 000EA:  20 82 81
            jsr b0_8f97                 ; 000ED:  20 97 8f
            lda $0776                   ; 000F0:  ad 76 07
            lsr a                       ; 000F3:  4a
            bcs b0_811b                 ; 000F4:  b0 25
            lda $0747                   ; 000F6:  ad 47 07
            beq b0_8100                 ; 000F9:  f0 05
            dec $0747                   ; 000FB:  ce 47 07
            bne b0_8119                 ; 000FE:  d0 19
b0_8100:    ldx #$14                    ; 00100:  a2 14
            dec $077f                   ; 00102:  ce 7f 07
            bpl b0_810e                 ; 00105:  10 07
            lda #$14                    ; 00107:  a9 14
            sta $077f                   ; 00109:  8d 7f 07
            ldx #$23                    ; 0010C:  a2 23
b0_810e:    lda $0780,x                 ; 0010E:  bd 80 07
            beq b0_8116                 ; 00111:  f0 03
            dec $0780,x                 ; 00113:  de 80 07
b0_8116:    dex                         ; 00116:  ca
            bpl b0_810e                 ; 00117:  10 f5
b0_8119:    inc $09                     ; 00119:  e6 09
b0_811b:    ldx #$00                    ; 0011B:  a2 00
            ldy #$07                    ; 0011D:  a0 07
            lda $07a7                   ; 0011F:  ad a7 07
            and #$02                    ; 00122:  29 02
            sta $00                     ; 00124:  85 00
            lda $07a8                   ; 00126:  ad a8 07
            and #$02                    ; 00129:  29 02
            eor $00                     ; 0012B:  45 00
            clc                         ; 0012D:  18
            beq b0_8131                 ; 0012E:  f0 01
            sec                         ; 00130:  38
b0_8131:    ror $07a7,x                 ; 00131:  7e a7 07
            inx                         ; 00134:  e8
            dey                         ; 00135:  88
            bne b0_8131                 ; 00136:  d0 f9
            lda $0722                   ; 00138:  ad 22 07
            beq b0_815c                 ; 0013B:  f0 1f
b0_813d:    lda PPUSTATUS               ; 0013D:  ad 02 20
            and #$40                    ; 00140:  29 40
            bne b0_813d                 ; 00142:  d0 f9
            lda $0776                   ; 00144:  ad 76 07
            lsr a                       ; 00147:  4a
            bcs b0_8150                 ; 00148:  b0 06
            jsr b0_8222+1               ; 0014A:  20 23 82
            jsr b0_81c6                 ; 0014D:  20 c6 81
b0_8150:    lda PPUSTATUS               ; 00150:  ad 02 20
            and #$40                    ; 00153:  29 40
            beq b0_8150                 ; 00155:  f0 f9
            ldy #$14                    ; 00157:  a0 14
b0_8159:    dey                         ; 00159:  88
            bne b0_8159                 ; 0015A:  d0 fd
b0_815c:    lda $073f                   ; 0015C:  ad 3f 07
            sta PPUSCROLL               ; 0015F:  8d 05 20
            lda $0740                   ; 00162:  ad 40 07
            sta PPUSCROLL               ; 00165:  8d 05 20
            lda $0778                   ; 00168:  ad 78 07
            pha                         ; 0016B:  48
            sta PPUCTRL                 ; 0016C:  8d 00 20
            lda $0776                   ; 0016F:  ad 76 07
            lsr a                       ; 00172:  4a
            bcs b0_8178                 ; 00173:  b0 03
            jsr tab_b0_8212             ; 00175:  20 12 82
b0_8178:    lda PPUSTATUS               ; 00178:  ad 02 20
            pla                         ; 0017B:  68
            ora #$80                    ; 0017C:  09 80
            sta PPUCTRL                 ; 0017E:  8d 00 20
            rti                         ; 00181:  40

b0_8182:    lda $0770                   ; 00182:  ad 70 07
            cmp #$02                    ; 00185:  c9 02
            beq b0_8194                 ; 00187:  f0 0b
            cmp #$01                    ; 00189:  c9 01
            bne b0_81c5                 ; 0018B:  d0 38
            lda $0772                   ; 0018D:  ad 72 07
            cmp #$03                    ; 00190:  c9 03
            bne b0_81c5                 ; 00192:  d0 31
b0_8194:    lda $0777                   ; 00194:  ad 77 07
            beq b0_819d                 ; 00197:  f0 04
            dec $0777                   ; 00199:  ce 77 07
            rts                         ; 0019C:  60

b0_819d:    lda $06fc                   ; 0019D:  ad fc 06
            and #$10                    ; 001A0:  29 10
            beq b0_81bd                 ; 001A2:  f0 19
            lda $0776                   ; 001A4:  ad 76 07
            and #$80                    ; 001A7:  29 80
            bne b0_81c5                 ; 001A9:  d0 1a
            lda #$2b                    ; 001AB:  a9 2b
            sta $0777                   ; 001AD:  8d 77 07
            lda $0776                   ; 001B0:  ad 76 07
            tay                         ; 001B3:  a8
            iny                         ; 001B4:  c8
            sty $fa                     ; 001B5:  84 fa
            eor #$01                    ; 001B7:  49 01
            ora #$80                    ; 001B9:  09 80
            bne b0_81c2                 ; 001BB:  d0 05
b0_81bd:    lda $0776                   ; 001BD:  ad 76 07
            and #$7f                    ; 001C0:  29 7f
b0_81c2:    sta $0776                   ; 001C2:  8d 76 07
b0_81c5:    rts                         ; 001C5:  60

b0_81c6:    ldy $074e                   ; 001C6:  ac 4e 07
            lda #$28                    ; 001C9:  a9 28
            sta $00                     ; 001CB:  85 00
            ldx #$0e                    ; 001CD:  a2 0e
b0_81cf:    lda $06e4,x                 ; 001CF:  bd e4 06
            cmp $00                     ; 001D2:  c5 00
            bcc b0_81e5                 ; 001D4:  90 0f
            ldy $06e0                   ; 001D6:  ac e0 06
            clc                         ; 001D9:  18
            adc $06e1,y                 ; 001DA:  79 e1 06
            bcc b0_81e2                 ; 001DD:  90 03
            clc                         ; 001DF:  18
            adc $00                     ; 001E0:  65 00
b0_81e2:    sta $06e4,x                 ; 001E2:  9d e4 06
b0_81e5:    dex                         ; 001E5:  ca
            bpl b0_81cf                 ; 001E6:  10 e7
            ldx $06e0                   ; 001E8:  ae e0 06
            inx                         ; 001EB:  e8
            cpx #$03                    ; 001EC:  e0 03
            bne b0_81f2                 ; 001EE:  d0 02
            ldx #$00                    ; 001F0:  a2 00
b0_81f2:    stx $06e0                   ; 001F2:  8e e0 06
            ldx #$08                    ; 001F5:  a2 08
            ldy #$02                    ; 001F7:  a0 02
b0_81f9:    lda $06e9,y                 ; 001F9:  b9 e9 06
            sta $06f1,x                 ; 001FC:  9d f1 06
            clc                         ; 001FF:  18
            adc #$08                    ; 00200:  69 08
            sta $06f2,x                 ; 00202:  9d f2 06
            clc                         ; 00205:  18
            adc #$08                    ; 00206:  69 08
            sta $06f3,x                 ; 00208:  9d f3 06
            dex                         ; 0020B:  ca
            dex                         ; 0020C:  ca
            dex                         ; 0020D:  ca
            dey                         ; 0020E:  88
            bpl b0_81f9                 ; 0020F:  10 e8
            rts                         ; 00211:  60

tab_b0_8212: ; 14 bytes
            hex ad 70 07 20 04 8e 31 82 ; 00212:  ad 70 07 20 04 8e 31 82
            hex dc ae 8b 83 18 92       ; 0021A:  dc ae 8b 83 18 92

b0_8220:    ldy #$00                    ; 00220:  a0 00
b0_8222:    bit $04a0                   ; 00222:  2c a0 04
            lda #$f8                    ; 00225:  a9 f8
b0_8227:    sta $0200,y                 ; 00227:  99 00 02
            iny                         ; 0022A:  c8
            iny                         ; 0022B:  c8
            iny                         ; 0022C:  c8
            iny                         ; 0022D:  c8
            bne b0_8227                 ; 0022E:  d0 f7
            rts                         ; 00230:  60

tab_b0_8231: ; 15 bytes
            hex ad 72 07 20 04 8e cf 8f ; 00231:  ad 72 07 20 04 8e cf 8f
            hex 67 85 61 90 45 82 04    ; 00239:  67 85 61 90 45 82 04

            jsr $0173                   ; 00240:  20 73 01
            brk                         ; 00243:  00
            hex 00                      ; 00244:  00
            ldy #$00                    ; 00245:  a0 00
            lda $06fc                   ; 00247:  ad fc 06
            ora $06fd                   ; 0024A:  0d fd 06
            cmp #$10                    ; 0024D:  c9 10
            beq b0_8255                 ; 0024F:  f0 04
            cmp #$90                    ; 00251:  c9 90
            bne b0_8258                 ; 00253:  d0 03
b0_8255:    jmp b0_82d8                 ; 00255:  4c d8 82

b0_8258:    cmp #$20                    ; 00258:  c9 20
            beq b0_8276                 ; 0025A:  f0 1a
            ldx $07a2                   ; 0025C:  ae a2 07
            bne b0_826c                 ; 0025F:  d0 0b
            sta $0780                   ; 00261:  8d 80 07
            jsr tab_b0_8340+43          ; 00264:  20 6b 83
            bcs b0_82c9                 ; 00267:  b0 60
            jmp b0_82c0                 ; 00269:  4c c0 82

b0_826c:    ldx $07fc                   ; 0026C:  ae fc 07
            beq b0_82bb                 ; 0026F:  f0 4a
            cmp #$40                    ; 00271:  c9 40
            bne b0_82bb                 ; 00273:  d0 46
            iny                         ; 00275:  c8
b0_8276:    lda $07a2                   ; 00276:  ad a2 07
            beq b0_82c9                 ; 00279:  f0 4e
            lda #$18                    ; 0027B:  a9 18
            sta $07a2                   ; 0027D:  8d a2 07
            lda $0780                   ; 00280:  ad 80 07
            bne b0_82bb                 ; 00283:  d0 36
            lda #$10                    ; 00285:  a9 10
            sta $0780                   ; 00287:  8d 80 07
            cpy #$01                    ; 0028A:  c0 01
            beq b0_829c                 ; 0028C:  f0 0e
            lda $077a                   ; 0028E:  ad 7a 07
            eor #$01                    ; 00291:  49 01
            sta $077a                   ; 00293:  8d 7a 07
            jsr tab_b0_831d+8           ; 00296:  20 25 83
            jmp b0_82bb                 ; 00299:  4c bb 82

b0_829c:    ldx $076b                   ; 0029C:  ae 6b 07
            inx                         ; 0029F:  e8
            txa                         ; 002A0:  8a
            and #$07                    ; 002A1:  29 07
            sta $076b                   ; 002A3:  8d 6b 07
            jsr b0_830e                 ; 002A6:  20 0e 83
b0_82a9:    lda tab_b0_8231+14,x        ; 002A9:  bd 3f 82
            sta $0300,x                 ; 002AC:  9d 00 03
            inx                         ; 002AF:  e8
            cpx #$06                    ; 002B0:  e0 06
            bmi b0_82a9                 ; 002B2:  30 f5
            ldy $075f                   ; 002B4:  ac 5f 07
            iny                         ; 002B7:  c8
            sty $0304                   ; 002B8:  8c 04 03
b0_82bb:    lda #$00                    ; 002BB:  a9 00
            sta $06fc                   ; 002BD:  8d fc 06
b0_82c0:    jsr tab_b0_ae38+178         ; 002C0:  20 ea ae
            lda $0e                     ; 002C3:  a5 0e
            cmp #$06                    ; 002C5:  c9 06
            bne b0_830d                 ; 002C7:  d0 44
b0_82c9:    lda #$00                    ; 002C9:  a9 00
            sta $0770                   ; 002CB:  8d 70 07
            sta $0772                   ; 002CE:  8d 72 07
            sta $0722                   ; 002D1:  8d 22 07
            inc $0774                   ; 002D4:  ee 74 07
            rts                         ; 002D7:  60

b0_82d8:    ldy $07a2                   ; 002D8:  ac a2 07
            beq b0_82c9                 ; 002DB:  f0 ec
            asl a                       ; 002DD:  0a
            bcc b0_82e6                 ; 002DE:  90 06
            lda $07fd                   ; 002E0:  ad fd 07
            jsr b0_830e                 ; 002E3:  20 0e 83
b0_82e6:    jsr b0_9c03                 ; 002E6:  20 03 9c
            inc $075d                   ; 002E9:  ee 5d 07
            inc $0764                   ; 002EC:  ee 64 07
            inc $0757                   ; 002EF:  ee 57 07
            inc $0770                   ; 002F2:  ee 70 07
            lda $07fc                   ; 002F5:  ad fc 07
            sta $076a                   ; 002F8:  8d 6a 07
            lda #$00                    ; 002FB:  a9 00
            sta $0772                   ; 002FD:  8d 72 07
            sta $07a2                   ; 00300:  8d a2 07
            ldx #$17                    ; 00303:  a2 17
            lda #$00                    ; 00305:  a9 00
b0_8307:    sta $07dd,x                 ; 00307:  9d dd 07
            dex                         ; 0030A:  ca
            bpl b0_8307                 ; 0030B:  10 fa
b0_830d:    rts                         ; 0030D:  60

b0_830e:    sta $075f                   ; 0030E:  8d 5f 07
            sta $0766                   ; 00311:  8d 66 07
            ldx #$00                    ; 00314:  a2 00
            stx $0760                   ; 00316:  8e 60 07
            stx $0767                   ; 00319:  8e 67 07
            rts                         ; 0031C:  60

tab_b0_831d: ; 10 bytes
            hex 07 22 49 83 ce 24 24 00 ; 0031D:  07 22 49 83 ce 24 24 00
            hex a0 07                   ; 00325:  a0 07

b0_8327:    lda tab_b0_831d,y           ; 00327:  b9 1d 83
            sta $0300,y                 ; 0032A:  99 00 03
            dey                         ; 0032D:  88
            bpl b0_8327                 ; 0032E:  10 f7
            lda $077a                   ; 00330:  ad 7a 07
            beq b0_833f                 ; 00333:  f0 0a
            lda #$24                    ; 00335:  a9 24
            sta $0304                   ; 00337:  8d 04 03
            lda #$ce                    ; 0033A:  a9 ce
            sta $0306                   ; 0033C:  8d 06 03
b0_833f:    rts                         ; 0033F:  60

tab_b0_8340: ; 46 bytes
            hex 01 80 02 81 41 80 01 42 ; 00340:  01 80 02 81 41 80 01 42
            hex c2 02 80 41 c1 41 c1 01 ; 00348:  c2 02 80 41 c1 41 c1 01
            hex c1 01 02 80 00 9b 10 18 ; 00350:  c1 01 02 80 00 9b 10 18
            hex 05 2c 20 24 15 5a 10 20 ; 00358:  05 2c 20 24 15 5a 10 20
            hex 28 30 20 10 80 20 30 30 ; 00360:  28 30 20 10 80 20 30 30
            hex 01 ff 00 ae 17 07       ; 00368:  01 ff 00 ae 17 07

            lda $0718                   ; 0036E:  ad 18 07
            bne b0_8380                 ; 00371:  d0 0d
            inx                         ; 00373:  e8
            inc $0717                   ; 00374:  ee 17 07
            sec                         ; 00377:  38
            lda tab_b0_8340+20,x        ; 00378:  bd 54 83
            sta $0718                   ; 0037B:  8d 18 07
            beq b0_838a                 ; 0037E:  f0 0a
b0_8380:    lda b0_833f,x               ; 00380:  bd 3f 83
            sta $06fc                   ; 00383:  8d fc 06
            dec $0718                   ; 00386:  ce 18 07
            clc                         ; 00389:  18
b0_838a:    rts                         ; 0038A:  60

            jsr tab_b0_83a0             ; 0038B:  20 a0 83
            lda $0772                   ; 0038E:  ad 72 07
            beq b0_839a                 ; 00391:  f0 07
            ldx #$00                    ; 00393:  a2 00
            stx $08                     ; 00395:  86 08
            jsr $c047                   ; 00397:  20 47 c0
b0_839a:    jsr $f12a                   ; 0039A:  20 2a f1
            jmp $eee9                   ; 0039D:  4c e9 ee

tab_b0_83a0: ; 14 bytes
            hex ad 72 07 20 04 8e ec cf ; 003A0:  ad 72 07 20 04 8e ec cf
            hex b0 83 bd 83 f6 83       ; 003A8:  b0 83 bd 83 f6 83

            adc ($84,x)                 ; 003AE:  61 84
            ldx $071b                   ; 003B0:  ae 1b 07
            inx                         ; 003B3:  e8
            stx $34                     ; 003B4:  86 34
            lda #$08                    ; 003B6:  a9 08
            sta $fc                     ; 003B8:  85 fc
            jmp b0_874e                 ; 003BA:  4c 4e 87

            ldy #$00                    ; 003BD:  a0 00
            sty $35                     ; 003BF:  84 35
            lda $6d                     ; 003C1:  a5 6d
            cmp $34                     ; 003C3:  c5 34
            bne b0_83cd                 ; 003C5:  d0 06
            lda $86                     ; 003C7:  a5 86
            cmp #$60                    ; 003C9:  c9 60
            bcs b0_83d0                 ; 003CB:  b0 03
b0_83cd:    inc $35                     ; 003CD:  e6 35
            iny                         ; 003CF:  c8
b0_83d0:    tya                         ; 003D0:  98
            jsr b0_b0e6                 ; 003D1:  20 e6 b0
            lda $071a                   ; 003D4:  ad 1a 07
            cmp $34                     ; 003D7:  c5 34
            beq b0_83f1                 ; 003D9:  f0 16
            lda $0768                   ; 003DB:  ad 68 07
            clc                         ; 003DE:  18
            adc #$80                    ; 003DF:  69 80
            sta $0768                   ; 003E1:  8d 68 07
            lda #$01                    ; 003E4:  a9 01
            adc #$00                    ; 003E6:  69 00
            tay                         ; 003E8:  a8
            jsr b0_afc4                 ; 003E9:  20 c4 af
            jsr b0_af6f                 ; 003EC:  20 6f af
            inc $35                     ; 003EF:  e6 35
b0_83f1:    lda $35                     ; 003F1:  a5 35
            beq b0_845d                 ; 003F3:  f0 68
            rts                         ; 003F5:  60

            lda $0749                   ; 003F6:  ad 49 07
            bne b0_8443                 ; 003F9:  d0 48
            lda $0719                   ; 003FB:  ad 19 07
            beq b0_8418                 ; 003FE:  f0 18
            cmp #$09                    ; 00400:  c9 09
            bcs b0_8443                 ; 00402:  b0 3f
            ldy $075f                   ; 00404:  ac 5f 07
            cpy #$07                    ; 00407:  c0 07
            bne b0_8414                 ; 00409:  d0 09
            cmp #$03                    ; 0040B:  c9 03
            bcc b0_8443                 ; 0040D:  90 34
            sbc #$01                    ; 0040F:  e9 01
            jmp b0_8418                 ; 00411:  4c 18 84

b0_8414:    cmp #$02                    ; 00414:  c9 02
            bcc b0_8443                 ; 00416:  90 2b
b0_8418:    tay                         ; 00418:  a8
            bne b0_8423                 ; 00419:  d0 08
            lda $0753                   ; 0041B:  ad 53 07
            beq b0_8434                 ; 0041E:  f0 14
            iny                         ; 00420:  c8
            bne b0_8434                 ; 00421:  d0 11
b0_8423:    iny                         ; 00423:  c8
            lda $075f                   ; 00424:  ad 5f 07
            cmp #$07                    ; 00427:  c9 07
            beq b0_8434                 ; 00429:  f0 09
            dey                         ; 0042B:  88
            cpy #$04                    ; 0042C:  c0 04
            bcs b0_8456                 ; 0042E:  b0 26
            cpy #$03                    ; 00430:  c0 03
            bcs b0_8443                 ; 00432:  b0 0f
b0_8434:    cpy #$03                    ; 00434:  c0 03
            bne b0_843c                 ; 00436:  d0 04
            lda #$04                    ; 00438:  a9 04
            sta $fc                     ; 0043A:  85 fc
b0_843c:    tya                         ; 0043C:  98
            clc                         ; 0043D:  18
            adc #$0c                    ; 0043E:  69 0c
            sta $0773                   ; 00440:  8d 73 07
b0_8443:    lda $0749                   ; 00443:  ad 49 07
            clc                         ; 00446:  18
            adc #$04                    ; 00447:  69 04
            sta $0749                   ; 00449:  8d 49 07
            lda $0719                   ; 0044C:  ad 19 07
            adc #$00                    ; 0044F:  69 00
            sta $0719                   ; 00451:  8d 19 07
            cmp #$07                    ; 00454:  c9 07
b0_8456:    bcc b0_8460                 ; 00456:  90 08
            lda #$06                    ; 00458:  a9 06
            sta $07a1                   ; 0045A:  8d a1 07
b0_845d:    inc $0772                   ; 0045D:  ee 72 07
b0_8460:    rts                         ; 00460:  60

            lda $07a1                   ; 00461:  ad a1 07
            bne b0_8486                 ; 00464:  d0 20
            ldy $075f                   ; 00466:  ac 5f 07
            cpy #$07                    ; 00469:  c0 07
            bcs b0_8487                 ; 0046B:  b0 1a
            lda #$00                    ; 0046D:  a9 00
            sta $0760                   ; 0046F:  8d 60 07
            sta $075c                   ; 00472:  8d 5c 07
            sta $0772                   ; 00475:  8d 72 07
            inc $075f                   ; 00478:  ee 5f 07
            jsr b0_9c03                 ; 0047B:  20 03 9c
            inc $0757                   ; 0047E:  ee 57 07
            lda #$01                    ; 00481:  a9 01
            sta $0770                   ; 00483:  8d 70 07
b0_8486:    rts                         ; 00486:  60

b0_8487:    lda $06fc                   ; 00487:  ad fc 06
            ora $06fd                   ; 0048A:  0d fd 06
            and #$40                    ; 0048D:  29 40
            beq b0_849e                 ; 0048F:  f0 0d
            lda #$01                    ; 00491:  a9 01
            sta $07fc                   ; 00493:  8d fc 07
            lda #$ff                    ; 00496:  a9 ff
            sta $075a                   ; 00498:  8d 5a 07
            jsr b0_9248                 ; 0049B:  20 48 92
b0_849e:    rts                         ; 0049E:  60

tab_b0_849f: ; 33 bytes
            hex ff ff f6 fb f7 fb f8 fb ; 0049F:  ff ff f6 fb f7 fb f8 fb
            hex f9 fb fa fb f6 50 f7 50 ; 004A7:  f9 fb fa fb f6 50 f7 50
            hex f8 50 f9 50 fa 50 fd fe ; 004AF:  f8 50 f9 50 fa 50 fd fe
            hex ff 41 42 44 45 48 31 32 ; 004B7:  ff 41 42 44 45 48 31 32
            hex 34                      ; 004BF:  34

            and $38,x                   ; 004C0:  35 38
b0_84c2:    brk                         ; 004C2:  00
            hex bd                      ; 004C3:  bd
            bpl b0_84c6+1               ; 004C4:  10 01
b0_84c6:    beq b0_8486                 ; 004C6:  f0 be
            cmp #$0b                    ; 004C8:  c9 0b
            bcc b0_84d1                 ; 004CA:  90 05
            lda #$0b                    ; 004CC:  a9 0b
            sta $0110,x                 ; 004CE:  9d 10 01
b0_84d1:    tay                         ; 004D1:  a8
            lda $012c,x                 ; 004D2:  bd 2c 01
            bne b0_84db                 ; 004D5:  d0 04
            sta $0110,x                 ; 004D7:  9d 10 01
            rts                         ; 004DA:  60

b0_84db:    dec $012c,x                 ; 004DB:  de 2c 01
            cmp #$2b                    ; 004DE:  c9 2b
            bne b0_8500                 ; 004E0:  d0 1e
            cpy #$0b                    ; 004E2:  c0 0b
            bne b0_84ed                 ; 004E4:  d0 07
            inc $075a                   ; 004E6:  ee 5a 07
            lda #$40                    ; 004E9:  a9 40
            sta $fe                     ; 004EB:  85 fe
b0_84ed:    lda tab_b0_849f+24,y        ; 004ED:  b9 b7 84
            lsr a                       ; 004F0:  4a
            lsr a                       ; 004F1:  4a
            lsr a                       ; 004F2:  4a
            lsr a                       ; 004F3:  4a
            tax                         ; 004F4:  aa
            lda tab_b0_849f+24,y        ; 004F5:  b9 b7 84
            and #$0f                    ; 004F8:  29 0f
            sta $0134,x                 ; 004FA:  9d 34 01
            jsr b0_bc27                 ; 004FD:  20 27 bc
b0_8500:    ldy $06e5,x                 ; 00500:  bc e5 06
            lda $16,x                   ; 00503:  b5 16
            cmp #$12                    ; 00505:  c9 12
            beq b0_852b                 ; 00507:  f0 22
            cmp #$0d                    ; 00509:  c9 0d
            beq b0_852b                 ; 0050B:  f0 1e
            cmp #$05                    ; 0050D:  c9 05
            beq b0_8523                 ; 0050F:  f0 12
            cmp #$0a                    ; 00511:  c9 0a
            beq b0_852b                 ; 00513:  f0 16
            cmp #$0b                    ; 00515:  c9 0b
            beq b0_852b                 ; 00517:  f0 12
            cmp #$09                    ; 00519:  c9 09
            bcs b0_8523                 ; 0051B:  b0 06
            lda $1e,x                   ; 0051D:  b5 1e
            cmp #$02                    ; 0051F:  c9 02
            bcs b0_852b                 ; 00521:  b0 08
b0_8523:    ldx $03ee                   ; 00523:  ae ee 03
            ldy $06ec,x                 ; 00526:  bc ec 06
            ldx $08                     ; 00529:  a6 08
b0_852b:    lda $011e,x                 ; 0052B:  bd 1e 01
            cmp #$18                    ; 0052E:  c9 18
            bcc b0_8537                 ; 00530:  90 05
            sbc #$01                    ; 00532:  e9 01
            sta $011e,x                 ; 00534:  9d 1e 01
b0_8537:    lda $011e,x                 ; 00537:  bd 1e 01
            sbc #$08                    ; 0053A:  e9 08
            jsr $e5c1                   ; 0053C:  20 c1 e5
            lda $0117,x                 ; 0053F:  bd 17 01
            sta $0203,y                 ; 00542:  99 03 02
            clc                         ; 00545:  18
            adc #$08                    ; 00546:  69 08
            sta $0207,y                 ; 00548:  99 07 02
            lda #$02                    ; 0054B:  a9 02
            sta $0202,y                 ; 0054D:  99 02 02
            sta $0206,y                 ; 00550:  99 06 02
            lda $0110,x                 ; 00553:  bd 10 01
            asl a                       ; 00556:  0a
            tax                         ; 00557:  aa
            lda tab_b0_849f,x           ; 00558:  bd 9f 84
            sta $0201,y                 ; 0055B:  99 01 02
            lda tab_b0_849f+1,x         ; 0055E:  bd a0 84
            sta $0205,y                 ; 00561:  99 05 02
            ldx $08                     ; 00564:  a6 08
            rts                         ; 00566:  60

            hex ad 3c 07 20 04 8e 8b 85 ; 00567:  ad 3c 07 20 04 8e 8b 85
            hex 9b 85 52 86 5a 86 93 86 ; 0056F:  9b 85 52 86 5a 86 93 86
            hex 9d 88 a8 86 9d 88 e6 86 ; 00577:  9d 88 a8 86 9d 88 e6 86
            hex bf 85 e3 85 43 86 ff 86 ; 0057F:  bf 85 e3 85 43 86 ff 86
            hex 32 87                   ; 00587:  32 87

            eor #$87                    ; 00589:  49 87
            jsr b0_8220                 ; 0058B:  20 20 82
            jsr b0_8e19                 ; 0058E:  20 19 8e
            lda $0770                   ; 00591:  ad 70 07
            beq b0_85c8                 ; 00594:  f0 32
            ldx #$03                    ; 00596:  a2 03
            jmp b0_85c5                 ; 00598:  4c c5 85

            lda $0744                   ; 0059B:  ad 44 07
            pha                         ; 0059E:  48
            lda $0756                   ; 0059F:  ad 56 07
            pha                         ; 005A2:  48
            lda #$00                    ; 005A3:  a9 00
            sta $0756                   ; 005A5:  8d 56 07
            lda #$02                    ; 005A8:  a9 02
            sta $0744                   ; 005AA:  8d 44 07
            jsr b0_85f1                 ; 005AD:  20 f1 85
            pla                         ; 005B0:  68
            sta $0756                   ; 005B1:  8d 56 07
            pla                         ; 005B4:  68
            sta $0744                   ; 005B5:  8d 44 07
            jmp b0_8745                 ; 005B8:  4c 45 87

tab_b0_85bb: ; 4 bytes
            hex 01 02 03 04             ; 005BB:  01 02 03 04

            ldy $074e                   ; 005BF:  ac 4e 07
            ldx tab_b0_85bb,y           ; 005C2:  be bb 85
b0_85c5:    stx $0773                   ; 005C5:  8e 73 07
b0_85c8:    jmp b0_8745                 ; 005C8:  4c 45 87

tab_b0_85cb: ; 27 bytes - TABLA DE PALETAS DE SPRITES
            ; Esta tabla contiene todas las paletas de sprites que el juego usa
            ; Cada paleta son 4 bytes: [color0, color1, color2, color3]
            hex 00 09 0a 04             ; 005CB: Enemigos - paleta A (posiblemente Cheep Cheep o fuego)
            hex 22 22 0f 0f             ; 005CF: Enemigos - paleta B (posiblemente bloques/power-ups)
            hex 0f 22 0f 0f             ; 005D3: Enemigos - paleta C (posiblemente Goomba/Koopa)
            hex 22 16 27 18             ; 005D7: MARIO NORMAL [piel=$22, ropa=$16, sombra=$27, overall=$18]
            hex 22 30 27 19             ; 005DB: LUIGI [piel=$22, ropa=$30, sombra=$27, overall=$19]
            hex 22 37 27 16             ; 005DF: MARIO/LUIGI FUEGO [piel=$22, ropa=$37, sombra=$27, overall=$16]
            hex ac 44 07                ; 005E3: No es paleta (código)

            beq b0_85ee                 ; 005E6:  f0 06
            lda b0_85c5+2,y             ; 005E8:  b9 c7 85
            sta $0773                   ; 005EB:  8d 73 07
b0_85ee:    inc $073c                   ; 005EE:  ee 3c 07
b0_85f1:    ldx $0300                   ; 005F1:  ae 00 03
            ldy #$00                    ; 005F4:  a0 00
            lda $0753                   ; 005F6:  ad 53 07
            beq b0_85fd                 ; 005F9:  f0 02
            ldy #$04                    ; 005FB:  a0 04
b0_85fd:    lda $0756                   ; 005FD:  ad 56 07
            cmp #$02                    ; 00600:  c9 02
            bne b0_8606                 ; 00602:  d0 02
            ldy #$08                    ; 00604:  a0 08
b0_8606:    lda #$03                    ; 00606:  a9 03
            sta $00                     ; 00608:  85 00
b0_860a:    lda tab_b0_85cb+12,y        ; 0060A:  b9 d7 85
            sta $0304,x                 ; 0060D:  9d 04 03
            iny                         ; 00610:  c8
            inx                         ; 00611:  e8
            dec $00                     ; 00612:  c6 00
            bpl b0_860a                 ; 00614:  10 f4
            ldx $0300                   ; 00616:  ae 00 03
            ldy $0744                   ; 00619:  ac 44 07
            bne b0_8621                 ; 0061C:  d0 03
            ldy $074e                   ; 0061E:  ac 4e 07
b0_8621:    lda tab_b0_85cb+4,y         ; 00621:  b9 cf 85
            sta $0304,x                 ; 00624:  9d 04 03
            lda #$3f                    ; 00627:  a9 3f
            sta $0301,x                 ; 00629:  9d 01 03
            lda #$10                    ; 0062C:  a9 10
            sta $0302,x                 ; 0062E:  9d 02 03
            lda #$04                    ; 00631:  a9 04
            sta $0303,x                 ; 00633:  9d 03 03
            lda #$00                    ; 00636:  a9 00
            sta $0308,x                 ; 00638:  9d 08 03
            txa                         ; 0063B:  8a
            clc                         ; 0063C:  18
            adc #$07                    ; 0063D:  69 07
b0_863f:    sta $0300                   ; 0063F:  8d 00 03
            rts                         ; 00642:  60

            lda $0733                   ; 00643:  ad 33 07
            cmp #$01                    ; 00646:  c9 01
            bne b0_864f                 ; 00648:  d0 05
            lda #$0b                    ; 0064A:  a9 0b
b0_864c:    sta $0773                   ; 0064C:  8d 73 07
b0_864f:    jmp b0_8745                 ; 0064F:  4c 45 87

            lda #$00                    ; 00652:  a9 00
            jsr b0_8807+1               ; 00654:  20 08 88
            jmp b0_8745                 ; 00657:  4c 45 87

            jsr b0_bc30                 ; 0065A:  20 30 bc
            ldx $0300                   ; 0065D:  ae 00 03
            lda #$20                    ; 00660:  a9 20
            sta $0301,x                 ; 00662:  9d 01 03
            lda #$73                    ; 00665:  a9 73
            sta $0302,x                 ; 00667:  9d 02 03
            lda #$03                    ; 0066A:  a9 03
            sta $0303,x                 ; 0066C:  9d 03 03
            ldy $075f                   ; 0066F:  ac 5f 07
            iny                         ; 00672:  c8
            tya                         ; 00673:  98
            sta $0304,x                 ; 00674:  9d 04 03
            lda #$28                    ; 00677:  a9 28
            sta $0305,x                 ; 00679:  9d 05 03
            ldy $075c                   ; 0067C:  ac 5c 07
            iny                         ; 0067F:  c8
            tya                         ; 00680:  98
            sta $0306,x                 ; 00681:  9d 06 03
            lda #$00                    ; 00684:  a9 00
            sta $0307,x                 ; 00686:  9d 07 03
            txa                         ; 00689:  8a
            clc                         ; 0068A:  18
            adc #$06                    ; 0068B:  69 06
            sta $0300                   ; 0068D:  8d 00 03
            jmp b0_8745                 ; 00690:  4c 45 87

            lda $0759                   ; 00693:  ad 59 07
            beq b0_86a2                 ; 00696:  f0 0a
            lda #$00                    ; 00698:  a9 00
            sta $0759                   ; 0069A:  8d 59 07
            lda #$02                    ; 0069D:  a9 02
            jmp b0_86c7                 ; 0069F:  4c c7 86

b0_86a2:    inc $073c                   ; 006A2:  ee 3c 07
            jmp b0_8745                 ; 006A5:  4c 45 87

            lda $0770                   ; 006A8:  ad 70 07
            beq b0_86e0                 ; 006AB:  f0 33
            cmp #$03                    ; 006AD:  c9 03
            beq b0_86d3                 ; 006AF:  f0 22
            lda $0752                   ; 006B1:  ad 52 07
            bne b0_86e0                 ; 006B4:  d0 2a
            ldy $074e                   ; 006B6:  ac 4e 07
            cpy #$03                    ; 006B9:  c0 03
            beq b0_86c2                 ; 006BB:  f0 05
            lda $0769                   ; 006BD:  ad 69 07
            bne b0_86e0                 ; 006C0:  d0 1e
b0_86c2:    jsr $efa4                   ; 006C2:  20 a4 ef
            lda #$01                    ; 006C5:  a9 01
b0_86c7:    jsr b0_8807+1               ; 006C7:  20 08 88
            jsr b0_88a5                 ; 006CA:  20 a5 88
            lda #$00                    ; 006CD:  a9 00
            sta $0774                   ; 006CF:  8d 74 07
            rts                         ; 006D2:  60

b0_86d3:    lda #$12                    ; 006D3:  a9 12
            sta $07a0                   ; 006D5:  8d a0 07
            lda #$03                    ; 006D8:  a9 03
            jsr b0_8807+1               ; 006DA:  20 08 88
            jmp b0_874e                 ; 006DD:  4c 4e 87

b0_86e0:    lda #$08                    ; 006E0:  a9 08
            sta $073c                   ; 006E2:  8d 3c 07
            rts                         ; 006E5:  60

            inc $0774                   ; 006E6:  ee 74 07
b0_86e9:    jsr b0_92b0                 ; 006E9:  20 b0 92
            lda $071f                   ; 006EC:  ad 1f 07
            bne b0_86e9                 ; 006EF:  d0 f8
            dec $071e                   ; 006F1:  ce 1e 07
            bpl b0_86f9                 ; 006F4:  10 03
            inc $073c                   ; 006F6:  ee 3c 07
b0_86f9:    lda #$06                    ; 006F9:  a9 06
            sta $0773                   ; 006FB:  8d 73 07
            rts                         ; 006FE:  60

            lda $0770                   ; 006FF:  ad 70 07
            bne b0_874e                 ; 00702:  d0 4a
            lda #$1e                    ; 00704:  a9 1e
            sta PPUADDR                 ; 00706:  8d 06 20
            lda #$c0                    ; 00709:  a9 c0
            sta PPUADDR                 ; 0070B:  8d 06 20
            lda #$03                    ; 0070E:  a9 03
            sta $01                     ; 00710:  85 01
            ldy #$00                    ; 00712:  a0 00
            sty $00                     ; 00714:  84 00
            lda PPUDATA                 ; 00716:  ad 07 20
b0_8719:    lda PPUDATA                 ; 00719:  ad 07 20
            sta ($00),y                 ; 0071C:  91 00
            iny                         ; 0071E:  c8
            bne b0_8723                 ; 0071F:  d0 02
            inc $01                     ; 00721:  e6 01
b0_8723:    lda $01                     ; 00723:  a5 01
            cmp #$04                    ; 00725:  c9 04
            bne b0_8719                 ; 00727:  d0 f0
            cpy #$3a                    ; 00729:  c0 3a
            bcc b0_8719                 ; 0072B:  90 ec
            lda #$05                    ; 0072D:  a9 05
            jmp b0_864c                 ; 0072F:  4c 4c 86

            lda $0770                   ; 00732:  ad 70 07
            bne b0_874e                 ; 00735:  d0 17
            ldx #$00                    ; 00737:  a2 00
b0_8739:    sta $0300,x                 ; 00739:  9d 00 03
            sta $0400,x                 ; 0073C:  9d 00 04
            dex                         ; 0073F:  ca
            bne b0_8739                 ; 00740:  d0 f7
            jsr tab_b0_831d+8           ; 00742:  20 25 83
b0_8745:    inc $073c                   ; 00745:  ee 3c 07
            rts                         ; 00748:  60

            lda #$fa                    ; 00749:  a9 fa
            jsr b0_bc36                 ; 0074B:  20 36 bc
b0_874e:    inc $0772                   ; 0074E:  ee 72 07
            rts                         ; 00751:  60

tab_b0_8752: ; 176 bytes
            hex 20 43 05 16 0a 1b 12 18 ; 00752:  20 43 05 16 0a 1b 12 18
            hex 20 52 0b 20 18 1b 15 0d ; 0075A:  20 52 0b 20 18 1b 15 0d
            hex 24 24 1d 12 16 0e 20 68 ; 00762:  24 24 1d 12 16 0e 20 68
            hex 05 00 24 24 2e 29 23 c0 ; 0076A:  05 00 24 24 2e 29 23 c0
            hex 7f aa 23 c2 01 ea ff 21 ; 00772:  7f aa 23 c2 01 ea ff 21
            hex cd 07 24 24 29 24 24 24 ; 0077A:  cd 07 24 24 29 24 24 24
            hex 24 21 4b 09 20 18 1b 15 ; 00782:  24 21 4b 09 20 18 1b 15
            hex 0d 24 24 28 24 22 0c 47 ; 0078A:  0d 24 24 28 24 22 0c 47
            hex 24 23 dc 01 ba ff 21 cd ; 00792:  24 23 dc 01 ba ff 21 cd
            hex 05 16 0a 1b 12 18 22 0c ; 0079A:  05 16 0a 1b 12 18 22 0c
            hex 07 1d 12 16 0e 24 1e 19 ; 007A2:  07 1d 12 16 0e 24 1e 19
            hex ff 21 cd 05 16 0a 1b 12 ; 007AA:  ff 21 cd 05 16 0a 1b 12
            hex 18 22 0b 09 10 0a 16 0e ; 007B2:  18 22 0b 09 10 0a 16 0e
            hex 24 18 1f 0e 1b ff 25 84 ; 007BA:  24 18 1f 0e 1b ff 25 84
            hex 15 20 0e 15 0c 18 16 0e ; 007C2:  15 20 0e 15 0c 18 16 0e
            hex 24 1d 18 24 20 0a 1b 19 ; 007CA:  24 1d 18 24 20 0a 1b 19
            hex 24 23 18 17 0e 2b 26 25 ; 007D2:  24 23 18 17 0e 2b 26 25
            hex 01 24 26 2d 01 24 26 35 ; 007DA:  01 24 26 2d 01 24 26 35
            hex 01 24 27 d9 46 aa 27 e1 ; 007E2:  01 24 27 d9 46 aa 27 e1
            hex 45 aa ff 15 1e 12 10 12 ; 007EA:  45 aa ff 15 1e 12 10 12
            hex 04 03 02 00 24 05 24 00 ; 007F2:  04 03 02 00 24 05 24 00
            hex 08 07 06 00 00 00 27 27 ; 007FA:  08 07 06 00 00 00 27 27

            lsr $4e                     ; 00802:  46 4e
            eor $6e61,y                 ; 00804:  59 61 6e
b0_8807:    ror $0a48                   ; 00807:  6e 48 0a
            tay                         ; 0080A:  a8
            cpy #$04                    ; 0080B:  c0 04
            bcc b0_881b                 ; 0080D:  90 0c
            cpy #$08                    ; 0080F:  c0 08
            bcc b0_8815                 ; 00811:  90 02
            ldy #$08                    ; 00813:  a0 08
b0_8815:    lda $077a                   ; 00815:  ad 7a 07
            bne b0_881b                 ; 00818:  d0 01
            iny                         ; 0081A:  c8
b0_881b:    ldx tab_b0_8752+172,y       ; 0081B:  be fe 87
            ldy #$00                    ; 0081E:  a0 00
b0_8820:    lda tab_b0_8752,x           ; 00820:  bd 52 87
            cmp #$ff                    ; 00823:  c9 ff
            beq b0_882e                 ; 00825:  f0 07
            sta $0301,y                 ; 00827:  99 01 03
            inx                         ; 0082A:  e8
            iny                         ; 0082B:  c8
            bne b0_8820                 ; 0082C:  d0 f2
b0_882e:    lda #$00                    ; 0082E:  a9 00
            sta $0301,y                 ; 00830:  99 01 03
            pla                         ; 00833:  68
            tax                         ; 00834:  aa
            cmp #$04                    ; 00835:  c9 04
            bcs b0_8882                 ; 00837:  b0 49
            dex                         ; 00839:  ca
            bne b0_885f                 ; 0083A:  d0 23
            lda $075a                   ; 0083C:  ad 5a 07
            clc                         ; 0083F:  18
            adc #$01                    ; 00840:  69 01
            cmp #$0a                    ; 00842:  c9 0a
            bcc b0_884d                 ; 00844:  90 07
            sbc #$0a                    ; 00846:  e9 0a
            ldy #$9f                    ; 00848:  a0 9f
            sty $0308                   ; 0084A:  8c 08 03
b0_884d:    sta $0309                   ; 0084D:  8d 09 03
            ldy $075f                   ; 00850:  ac 5f 07
            iny                         ; 00853:  c8
            sty $0314                   ; 00854:  8c 14 03
            ldy $075c                   ; 00857:  ac 5c 07
            iny                         ; 0085A:  c8
            sty $0316                   ; 0085B:  8c 16 03
            rts                         ; 0085E:  60

b0_885f:    lda $077a                   ; 0085F:  ad 7a 07
            beq b0_8881                 ; 00862:  f0 1d
            lda $0753                   ; 00864:  ad 53 07
            dex                         ; 00867:  ca
            bne b0_8873                 ; 00868:  d0 09
            ldy $0770                   ; 0086A:  ac 70 07
            cpy #$03                    ; 0086D:  c0 03
            beq b0_8873                 ; 0086F:  f0 02
            eor #$01                    ; 00871:  49 01
b0_8873:    lsr a                       ; 00873:  4a
            bcc b0_8881                 ; 00874:  90 0b
            ldy #$04                    ; 00876:  a0 04
b0_8878:    lda tab_b0_8752+155,y       ; 00878:  b9 ed 87
            sta $0304,y                 ; 0087B:  99 04 03
            dey                         ; 0087E:  88
            bpl b0_8878                 ; 0087F:  10 f7
b0_8881:    rts                         ; 00881:  60

b0_8882:    sbc #$04                    ; 00882:  e9 04
            asl a                       ; 00884:  0a
            asl a                       ; 00885:  0a
            tax                         ; 00886:  aa
            ldy #$00                    ; 00887:  a0 00
b0_8889:    lda tab_b0_8752+160,x       ; 00889:  bd f2 87
            sta $031c,y                 ; 0088C:  99 1c 03
            inx                         ; 0088F:  e8
            iny                         ; 00890:  c8
            iny                         ; 00891:  c8
            iny                         ; 00892:  c8
            iny                         ; 00893:  c8
            cpy #$0c                    ; 00894:  c0 0c
            bcc b0_8889                 ; 00896:  90 f1
            lda #$2c                    ; 00898:  a9 2c
            jmp b0_863f                 ; 0089A:  4c 3f 86

            lda $07a0                   ; 0089D:  ad a0 07
            bne b0_88ad                 ; 008A0:  d0 0b
            jsr b0_8220                 ; 008A2:  20 20 82
b0_88a5:    lda #$07                    ; 008A5:  a9 07
            sta $07a0                   ; 008A7:  8d a0 07
            inc $073c                   ; 008AA:  ee 3c 07
b0_88ad:    rts                         ; 008AD:  60

            lda $0726                   ; 008AE:  ad 26 07
            and #$01                    ; 008B1:  29 01
            sta $05                     ; 008B3:  85 05
            ldy $0340                   ; 008B5:  ac 40 03
            sty $00                     ; 008B8:  84 00
            lda $0721                   ; 008BA:  ad 21 07
            sta $0342,y                 ; 008BD:  99 42 03
            lda $0720                   ; 008C0:  ad 20 07
            sta $0341,y                 ; 008C3:  99 41 03
            lda #$9a                    ; 008C6:  a9 9a
            sta $0343,y                 ; 008C8:  99 43 03
            lda #$00                    ; 008CB:  a9 00
            sta $04                     ; 008CD:  85 04
            tax                         ; 008CF:  aa
b0_88d0:    stx $01                     ; 008D0:  86 01
            lda $06a1,x                 ; 008D2:  bd a1 06
            and #$c0                    ; 008D5:  29 c0
            sta $03                     ; 008D7:  85 03
            asl a                       ; 008D9:  0a
            rol a                       ; 008DA:  2a
            rol a                       ; 008DB:  2a
            tay                         ; 008DC:  a8
            lda tab_b0_8b08,y           ; 008DD:  b9 08 8b
            sta $06                     ; 008E0:  85 06
            lda tab_b0_8b08+4,y         ; 008E2:  b9 0c 8b
            sta $07                     ; 008E5:  85 07
            lda $06a1,x                 ; 008E7:  bd a1 06
            asl a                       ; 008EA:  0a
            asl a                       ; 008EB:  0a
            sta $02                     ; 008EC:  85 02
            lda $071f                   ; 008EE:  ad 1f 07
            and #$01                    ; 008F1:  29 01
            eor #$01                    ; 008F3:  49 01
            asl a                       ; 008F5:  0a
            adc $02                     ; 008F6:  65 02
            tay                         ; 008F8:  a8
            ldx $00                     ; 008F9:  a6 00
            lda ($06),y                 ; 008FB:  b1 06
            sta $0344,x                 ; 008FD:  9d 44 03
            iny                         ; 00900:  c8
            lda ($06),y                 ; 00901:  b1 06
            sta $0345,x                 ; 00903:  9d 45 03
            ldy $04                     ; 00906:  a4 04
            lda $05                     ; 00908:  a5 05
            bne b0_891a                 ; 0090A:  d0 0e
            lda $01                     ; 0090C:  a5 01
            lsr a                       ; 0090E:  4a
            bcs b0_892a                 ; 0090F:  b0 19
            rol $03                     ; 00911:  26 03
            rol $03                     ; 00913:  26 03
            rol $03                     ; 00915:  26 03
            jmp b0_8930                 ; 00917:  4c 30 89

b0_891a:    lda $01                     ; 0091A:  a5 01
            lsr a                       ; 0091C:  4a
            bcs b0_892e                 ; 0091D:  b0 0f
            lsr $03                     ; 0091F:  46 03
            lsr $03                     ; 00921:  46 03
            lsr $03                     ; 00923:  46 03
            lsr $03                     ; 00925:  46 03
            jmp b0_8930                 ; 00927:  4c 30 89

b0_892a:    lsr $03                     ; 0092A:  46 03
            lsr $03                     ; 0092C:  46 03
b0_892e:    inc $04                     ; 0092E:  e6 04
b0_8930:    lda $03f9,y                 ; 00930:  b9 f9 03
            ora $03                     ; 00933:  05 03
            sta $03f9,y                 ; 00935:  99 f9 03
            inc $00                     ; 00938:  e6 00
            inc $00                     ; 0093A:  e6 00
            ldx $01                     ; 0093C:  a6 01
            inx                         ; 0093E:  e8
            cpx #$0d                    ; 0093F:  e0 0d
            bcc b0_88d0                 ; 00941:  90 8d
            ldy $00                     ; 00943:  a4 00
            iny                         ; 00945:  c8
            iny                         ; 00946:  c8
            iny                         ; 00947:  c8
            lda #$00                    ; 00948:  a9 00
            sta $0341,y                 ; 0094A:  99 41 03
            sty $0340                   ; 0094D:  8c 40 03
            inc $0721                   ; 00950:  ee 21 07
            lda $0721                   ; 00953:  ad 21 07
            and #$1f                    ; 00956:  29 1f
            bne b0_8967                 ; 00958:  d0 0d
            lda #$80                    ; 0095A:  a9 80
            sta $0721                   ; 0095C:  8d 21 07
            lda $0720                   ; 0095F:  ad 20 07
            eor #$04                    ; 00962:  49 04
            sta $0720                   ; 00964:  8d 20 07
b0_8967:    jmp b0_89bd                 ; 00967:  4c bd 89

b0_896a:    lda $0721                   ; 0096A:  ad 21 07
            and #$1f                    ; 0096D:  29 1f
            sec                         ; 0096F:  38
            sbc #$04                    ; 00970:  e9 04
            and #$1f                    ; 00972:  29 1f
            sta $01                     ; 00974:  85 01
            lda $0720                   ; 00976:  ad 20 07
            bcs b0_897d                 ; 00979:  b0 02
            eor #$04                    ; 0097B:  49 04
b0_897d:    and #$04                    ; 0097D:  29 04
            ora #$23                    ; 0097F:  09 23
            sta $00                     ; 00981:  85 00
            lda $01                     ; 00983:  a5 01
            lsr a                       ; 00985:  4a
            lsr a                       ; 00986:  4a
            adc #$c0                    ; 00987:  69 c0
            sta $01                     ; 00989:  85 01
            ldx #$00                    ; 0098B:  a2 00
            ldy $0340                   ; 0098D:  ac 40 03
b0_8990:    lda $00                     ; 00990:  a5 00
            sta $0341,y                 ; 00992:  99 41 03
            lda $01                     ; 00995:  a5 01
            clc                         ; 00997:  18
            adc #$08                    ; 00998:  69 08
            sta $0342,y                 ; 0099A:  99 42 03
            sta $01                     ; 0099D:  85 01
            lda $03f9,x                 ; 0099F:  bd f9 03
            sta $0344,y                 ; 009A2:  99 44 03
            lda #$01                    ; 009A5:  a9 01
            sta $0343,y                 ; 009A7:  99 43 03
            lsr a                       ; 009AA:  4a
            sta $03f9,x                 ; 009AB:  9d f9 03
            iny                         ; 009AE:  c8
            iny                         ; 009AF:  c8
            iny                         ; 009B0:  c8
            iny                         ; 009B1:  c8
            inx                         ; 009B2:  e8
            cpx #$07                    ; 009B3:  e0 07
            bcc b0_8990                 ; 009B5:  90 d9
            sta $0341,y                 ; 009B7:  99 41 03
            sty $0340                   ; 009BA:  8c 40 03
b0_89bd:    lda #$06                    ; 009BD:  a9 06
            sta $0773                   ; 009BF:  8d 73 07
            rts                         ; 009C2:  60

tab_b0_89c3: ; 34 bytes
            hex 27 27 27 17 07 17 3f 0c ; 009C3:  27 27 27 17 07 17 3f 0c
            hex 04 ff ff ff ff 00 0f 07 ; 009CB:  04 ff ff ff ff 00 0f 07
            hex 12 0f 0f 07 17 0f 0f 07 ; 009D3:  12 0f 0f 07 17 0f 0f 07
            hex 17 1c 0f 07 17 00 a5 09 ; 009DB:  17 1c 0f 07 17 00 a5 09
            hex 29 07                   ; 009E3:  29 07

            bne b0_8a38                 ; 009E5:  d0 51
            ldx $0300                   ; 009E7:  ae 00 03
            cpx #$31                    ; 009EA:  e0 31
            bcs b0_8a38                 ; 009EC:  b0 4a
            tay                         ; 009EE:  a8
b0_89ef:    lda tab_b0_89c3+6,y         ; 009EF:  b9 c9 89
            sta $0301,x                 ; 009F2:  9d 01 03
            inx                         ; 009F5:  e8
            iny                         ; 009F6:  c8
            cpy #$08                    ; 009F7:  c0 08
            bcc b0_89ef                 ; 009F9:  90 f4
            ldx $0300                   ; 009FB:  ae 00 03
            lda #$03                    ; 009FE:  a9 03
            sta $00                     ; 00A00:  85 00
            lda $074e                   ; 00A02:  ad 4e 07
            asl a                       ; 00A05:  0a
            asl a                       ; 00A06:  0a
            tay                         ; 00A07:  a8
b0_8a08:    lda tab_b0_89c3+14,y        ; 00A08:  b9 d1 89
            sta $0304,x                 ; 00A0B:  9d 04 03
            iny                         ; 00A0E:  c8
            inx                         ; 00A0F:  e8
            dec $00                     ; 00A10:  c6 00
            bpl b0_8a08                 ; 00A12:  10 f4
            ldx $0300                   ; 00A14:  ae 00 03
            ldy $06d4                   ; 00A17:  ac d4 06
            lda tab_b0_89c3,y           ; 00A1A:  b9 c3 89
            sta $0305,x                 ; 00A1D:  9d 05 03
            lda $0300                   ; 00A20:  ad 00 03
            clc                         ; 00A23:  18
            adc #$07                    ; 00A24:  69 07
            sta $0300                   ; 00A26:  8d 00 03
            inc $06d4                   ; 00A29:  ee d4 06
            lda $06d4                   ; 00A2C:  ad d4 06
            cmp #$06                    ; 00A2F:  c9 06
            bcc b0_8a38                 ; 00A31:  90 05
            lda #$00                    ; 00A33:  a9 00
            sta $06d4                   ; 00A35:  8d d4 06
b0_8a38:    rts                         ; 00A38:  60

tab_b0_8a39: ; 24 bytes
            hex 45 45 47 47 47 47 47 47 ; 00A39:  45 45 47 47 47 47 47 47
            hex 57 58 59 5a 24 24 24 24 ; 00A41:  57 58 59 5a 24 24 24 24
            hex 26 26 26 26 a0 41 a9 03 ; 00A49:  26 26 26 26 a0 41 a9 03

            ldx $074e                   ; 00A51:  ae 4e 07
            bne b0_8a58                 ; 00A54:  d0 02
            lda #$04                    ; 00A56:  a9 04
b0_8a58:    jsr b0_8a97                 ; 00A58:  20 97 8a
            lda #$06                    ; 00A5B:  a9 06
            sta $0773                   ; 00A5D:  8d 73 07
            rts                         ; 00A60:  60

b0_8a61:    jsr b0_8a6d                 ; 00A61:  20 6d 8a
            inc $03f0                   ; 00A64:  ee f0 03
            dec $03ec,x                 ; 00A67:  de ec 03
            rts                         ; 00A6A:  60

b0_8a6b:    lda #$00                    ; 00A6B:  a9 00
b0_8a6d:    ldy #$03                    ; 00A6D:  a0 03
            cmp #$00                    ; 00A6F:  c9 00
            beq b0_8a87                 ; 00A71:  f0 14
            ldy #$00                    ; 00A73:  a0 00
            cmp #$58                    ; 00A75:  c9 58
            beq b0_8a87                 ; 00A77:  f0 0e
            cmp #$51                    ; 00A79:  c9 51
            beq b0_8a87                 ; 00A7B:  f0 0a
            iny                         ; 00A7D:  c8
            cmp #$5d                    ; 00A7E:  c9 5d
            beq b0_8a87                 ; 00A80:  f0 05
            cmp #$52                    ; 00A82:  c9 52
            beq b0_8a87                 ; 00A84:  f0 01
            iny                         ; 00A86:  c8
b0_8a87:    tya                         ; 00A87:  98
            ldy $0300                   ; 00A88:  ac 00 03
            iny                         ; 00A8B:  c8
            jsr b0_8a97                 ; 00A8C:  20 97 8a
            dey                         ; 00A8F:  88
            tya                         ; 00A90:  98
            clc                         ; 00A91:  18
            adc #$0a                    ; 00A92:  69 0a
            jmp b0_863f                 ; 00A94:  4c 3f 86

b0_8a97:    stx $00                     ; 00A97:  86 00
            sty $01                     ; 00A99:  84 01
            asl a                       ; 00A9B:  0a
            asl a                       ; 00A9C:  0a
            tax                         ; 00A9D:  aa
            ldy #$20                    ; 00A9E:  a0 20
            lda $06                     ; 00AA0:  a5 06
            cmp #$d0                    ; 00AA2:  c9 d0
            bcc b0_8aa8                 ; 00AA4:  90 02
            ldy #$24                    ; 00AA6:  a0 24
b0_8aa8:    sty $03                     ; 00AA8:  84 03
            and #$0f                    ; 00AAA:  29 0f
            asl a                       ; 00AAC:  0a
            sta $04                     ; 00AAD:  85 04
            lda #$00                    ; 00AAF:  a9 00
            sta $05                     ; 00AB1:  85 05
            lda $02                     ; 00AB3:  a5 02
            clc                         ; 00AB5:  18
            adc #$20                    ; 00AB6:  69 20
            asl a                       ; 00AB8:  0a
            rol $05                     ; 00AB9:  26 05
            asl a                       ; 00ABB:  0a
            rol $05                     ; 00ABC:  26 05
            adc $04                     ; 00ABE:  65 04
            sta $04                     ; 00AC0:  85 04
            lda $05                     ; 00AC2:  a5 05
            adc #$00                    ; 00AC4:  69 00
            clc                         ; 00AC6:  18
            adc $03                     ; 00AC7:  65 03
            sta $05                     ; 00AC9:  85 05
            ldy $01                     ; 00ACB:  a4 01
            lda tab_b0_8a39,x           ; 00ACD:  bd 39 8a
            sta $0303,y                 ; 00AD0:  99 03 03
            lda tab_b0_8a39+1,x         ; 00AD3:  bd 3a 8a
            sta $0304,y                 ; 00AD6:  99 04 03
            lda tab_b0_8a39+2,x         ; 00AD9:  bd 3b 8a
            sta $0308,y                 ; 00ADC:  99 08 03
            lda tab_b0_8a39+3,x         ; 00ADF:  bd 3c 8a
            sta $0309,y                 ; 00AE2:  99 09 03
            lda $04                     ; 00AE5:  a5 04
            sta $0301,y                 ; 00AE7:  99 01 03
            clc                         ; 00AEA:  18
            adc #$20                    ; 00AEB:  69 20
            sta $0306,y                 ; 00AED:  99 06 03
            lda $05                     ; 00AF0:  a5 05
            sta $0300,y                 ; 00AF2:  99 00 03
            sta $0305,y                 ; 00AF5:  99 05 03
            lda #$02                    ; 00AF8:  a9 02
            sta $0302,y                 ; 00AFA:  99 02 03
            sta $0307,y                 ; 00AFD:  99 07 03
            lda #$00                    ; 00B00:  a9 00
            sta $030a,y                 ; 00B02:  99 0a 03
            ldx $00                     ; 00B05:  a6 00
            rts                         ; 00B07:  60

tab_b0_8b08: ; 59 bytes
            hex 10 ac 64 8c 8b 8b 8c 8c ; 00B08:  10 ac 64 8c 8b 8b 8c 8c
            hex 24 24 24 24 27 27 27 27 ; 00B10:  24 24 24 24 27 27 27 27
            hex 24 24 24 35 36 25 37 25 ; 00B18:  24 24 24 35 36 25 37 25
            hex 24 38 24 24 24 30 30 26 ; 00B20:  24 38 24 24 24 30 30 26
            hex 26 26 34 26 24 31 24 32 ; 00B28:  26 26 34 26 24 31 24 32
            hex 33 26 24 33 34 26 26 26 ; 00B30:  33 26 24 33 34 26 26 26
            hex 26 26 26 26 24 c0 24 c0 ; 00B38:  26 26 26 26 24 c0 24 c0
            hex 24 7f 7f                ; 00B40:  24 7f 7f

            bit $b8                     ; 00B43:  24 b8
            tsx                         ; 00B45:  ba
            lda tab_b0_b8b6+5,y         ; 00B46:  b9 bb b8
            ldy tab_b0_bd9b+30,x        ; 00B49:  bc b9 bd
            tsx                         ; 00B4C:  ba
            ldy tab_b0_bd9b+32,x        ; 00B4D:  bc bb bd
            rts                         ; 00B50:  60

tab_b0_8b51: ; 238 bytes
            hex 64 61 65 62 66 63 67 60 ; 00B51:  64 61 65 62 66 63 67 60
            hex 64 61 65 62 66 63 67 68 ; 00B59:  64 61 65 62 66 63 67 68
            hex 68 69 69 26 26 6a 6a 4b ; 00B61:  68 69 69 26 26 6a 6a 4b
            hex 4c 4d 4e 4d 4f 4d 4f 4d ; 00B69:  4c 4d 4e 4d 4f 4d 4f 4d
            hex 4e 50 51 6b 70 2c 2d 6c ; 00B71:  4e 50 51 6b 70 2c 2d 6c
            hex 71 6d 72 6e 73 6f 74 86 ; 00B79:  71 6d 72 6e 73 6f 74 86
            hex 8a 87 8b 88 8c 88 8c 89 ; 00B81:  8a 87 8b 88 8c 88 8c 89
            hex 8d 69 69 8e 91 8f 92 26 ; 00B89:  8d 69 69 8e 91 8f 92 26
            hex 93 26 93 90 94 69 69 a4 ; 00B91:  93 26 93 90 94 69 69 a4
            hex e9 ea eb 24 24 24 24 24 ; 00B99:  e9 ea eb 24 24 24 24 24
            hex 2f 24 3d a2 a2 a3 a3 24 ; 00BA1:  2f 24 3d a2 a2 a3 a3 24
            hex 24 24 24 a2 a2 a3 a3 99 ; 00BA9:  24 24 24 a2 a2 a3 a3 99
            hex 24 99 24 24 a2 3e 3f 5b ; 00BB1:  24 99 24 24 a2 3e 3f 5b
            hex 5c 24 a3 24 24 24 24 9d ; 00BB9:  5c 24 a3 24 24 24 24 9d
            hex 47 9e 47 47 47 27 27 47 ; 00BC1:  47 9e 47 47 47 27 27 47
            hex 47 47 47 27 27 47 47 a9 ; 00BC9:  47 47 47 27 27 47 47 a9
            hex 47 aa 47 9b 27 9c 27 27 ; 00BD1:  47 aa 47 9b 27 9c 27 27
            hex 27 27 27 52 52 52 52 80 ; 00BD9:  27 27 27 52 52 52 52 80
            hex a0 81 a1 be be bf bf 75 ; 00BE1:  a0 81 a1 be be bf bf 75
            hex ba 76 bb ba ba bb bb 45 ; 00BE9:  ba 76 bb ba ba bb bb 45
            hex 47 45 47 47 47 47 47 45 ; 00BF1:  47 45 47 47 47 47 47 45
            hex 47 45 47 b4 b6 b5 b7 45 ; 00BF9:  47 45 47 b4 b6 b5 b7 45
            hex 47 45 47 45 47 45 47 45 ; 00C01:  47 45 47 45 47 45 47 45
            hex 47 45 47 45 47 45 47 45 ; 00C09:  47 45 47 45 47 45 47 45
            hex 47 45 47 47 47 47 47 47 ; 00C11:  47 45 47 47 47 47 47 47
            hex 47 47 47 47 47 47 47 47 ; 00C19:  47 47 47 47 47 47 47 47
            hex 47 47 47 47 47 47 47 24 ; 00C21:  47 47 47 47 47 47 47 24
            hex 24 24 24 24 24 24 24 ab ; 00C29:  24 24 24 24 24 24 24 ab
            hex ac ad ae 5d 5e 5d 5e c1 ; 00C31:  ac ad ae 5d 5e 5d 5e c1
            hex 24 c1 24 c6 c8 c7       ; 00C39:  24 c1 24 c6 c8 c7

            cmp #$ca                    ; 00C3F:  c9 ca
            cpy $cdcb                   ; 00C41:  cc cb cd
            rol a                       ; 00C44:  2a
            rol a                       ; 00C45:  2a
            rti                         ; 00C46:  40

            hex 40 24 24 24 24 24 47 24 ; 00C47:  40 24 24 24 24 24 47 24
            hex 47 82 83 84 85 24 47 24 ; 00C4F:  47 82 83 84 85 24 47 24
            hex 47 86 8a 87 8b 8e 91 8f ; 00C57:  47 86 8a 87 8b 8e 91 8f
            hex 92 24 2f 24 3d 24 24 24 ; 00C5F:  92 24 2f 24 3d 24 24 24
            hex 35 36 25 37 25 24 38 24 ; 00C67:  35 36 25 37 25 24 38 24
            hex 24 24 24 39 24 3a 24 3b ; 00C6F:  24 24 24 39 24 3a 24 3b
            hex 24 3c 24 24 24 41 26 41 ; 00C77:  24 3c 24 24 24 41 26 41
            hex 26 26 26 26 26 b0 b1 b2 ; 00C7F:  26 26 26 26 26 b0 b1 b2
            hex b3 77 79 77 79 53 55 54 ; 00C87:  b3 77 79 77 79 53 55 54
            hex 56 53 55 54 56 a5 a7 a6 ; 00C8F:  56 53 55 54 56 a5 a7 a6
            hex a8 c2 c4 c3 c5 57 59 58 ; 00C97:  a8 c2 c4 c3 c5 57 59 58
            hex 5a 7b 7d 7c 7e 3f 00 20 ; 00C9F:  5a 7b 7d 7c 7e 3f 00 20
            hex 0f 15 12 25 0f 3a 1a 0f ; 00CA7:  0f 15 12 25 0f 3a 1a 0f
            hex 0f 30 12 0f 0f 27 12 0f ; 00CAF:  0f 30 12 0f 0f 27 12 0f
            hex 22 16 27 18 0f 10 30 27 ; 00CB7:  22 16 27 18 0f 10 30 27
            hex 0f 16 30 27 0f 0f 30 10 ; 00CBF:  0f 16 30 27 0f 0f 30 10
            hex 00 3f 00 20 0f 29 1a 0f ; 00CC7:  00 3f 00 20 0f 29 1a 0f
            hex 0f 36 17 0f 0f 30 21 0f ; 00CCF:  0f 36 17 0f 0f 30 21 0f
            hex 0f 27 17 0f 0f 16 27 18 ; 00CD7:  0f 27 17 0f 0f 16 27 18
            hex 0f 1a 30 27 0f 16 30 27 ; 00CDF:  0f 1a 30 27 0f 16 30 27
            hex 0f 0f 36 17 00 3f 00 20 ; 00CE7:  0f 0f 36 17 00 3f 00 20
            hex 0f 29 1a 09 0f 3c 1c 0f ; 00CEF:  0f 29 1a 09 0f 3c 1c 0f
            hex 0f 30 21 1c 0f 27 17 1c ; 00CF7:  0f 30 21 1c 0f 27 17 1c
            hex 0f 16 27 18 0f 1c 36 17 ; 00CFF:  0f 16 27 18 0f 1c 36 17
            hex 0f 16 30 27 0f 0c 3c 1c ; 00D07:  0f 16 30 27 0f 0c 3c 1c
            hex 00 3f 00 20 0f 30 10 00 ; 00D0F:  00 3f 00 20 0f 30 10 00
            hex 0f 30 10 00 0f 30 16 00 ; 00D17:  0f 30 10 00 0f 30 16 00
            hex 0f 27 17 00 0f 16 27 18 ; 00D1F:  0f 27 17 00 0f 16 27 18
            hex 0f 1c 36 17 0f 16 30 27 ; 00D27:  0f 1c 36 17 0f 16 30 27
            hex 0f 00 30 10 00 3f 00 04 ; 00D2F:  0f 00 30 10 00 3f 00 04
            hex 22 30 00 10 00 3f 00 04 ; 00D37:  22 30 00 10 00 3f 00 04
            hex 0f 30 00 10 00 3f 00 04 ; 00D3F:  0f 30 00 10 00 3f 00 04
            hex 22 27 16 0f 00 3f 14 04 ; 00D47:  22 27 16 0f 00 3f 14 04
            hex 0f 1a 30 27 00 25 48 10 ; 00D4F:  0f 1a 30 27 00 25 48 10
            hex 1d 11 0a 17 14 24 22 18 ; 00D57:  1d 11 0a 17 14 24 22 18
            hex 1e 24 16 0a 1b 12 18 2b ; 00D5F:  1e 24 16 0a 1b 12 18 2b
            hex 00 25 48 10 1d 11 0a 17 ; 00D67:  00 25 48 10 1d 11 0a 17
            hex 14 24 22 18 1e 24 15 1e ; 00D6F:  14 24 22 18 1e 24 15 1e
            hex 12 10 12 2b 00 25 c5 16 ; 00D77:  12 10 12 2b 00 25 c5 16
            hex 0b 1e 1d 24 18 1e 1b 24 ; 00D7F:  0b 1e 1d 24 18 1e 1b 24
            hex 19 1b 12 17 0c 0e 1c 1c ; 00D87:  19 1b 12 17 0c 0e 1c 1c
            hex 24 12 1c 24 12 17 26 05 ; 00D8F:  24 12 1c 24 12 17 26 05
            hex 0f 0a 17 18 1d 11 0e 1b ; 00D97:  0f 0a 17 18 1d 11 0e 1b
            hex 24 0c 0a 1c 1d 15 0e 2b ; 00D9F:  24 0c 0a 1c 1d 15 0e 2b
            hex 00 25 a7 13 22 18 1e 1b ; 00DA7:  00 25 a7 13 22 18 1e 1b
            hex 24 1a 1e 0e 1c 1d 24 12 ; 00DAF:  24 1a 1e 0e 1c 1d 24 12
            hex 1c 24 18 1f 0e 1b af 00 ; 00DB7:  1c 24 18 1f 0e 1b af 00
            hex 25 e3 1b 20 0e 24 19 1b ; 00DBF:  25 e3 1b 20 0e 24 19 1b
            hex 0e 1c 0e 17 1d 24 22 18 ; 00DC7:  0e 1c 0e 17 1d 24 22 18
            hex 1e 24 0a 24 17 0e 20 24 ; 00DCF:  1e 24 0a 24 17 0e 20 24
            hex 1a 1e 0e 1c 1d af 00 26 ; 00DD7:  1a 1e 0e 1c 1d af 00 26
            hex 4a 0d 19 1e 1c 11 24 0b ; 00DDF:  4a 0d 19 1e 1c 11 24 0b
            hex 1e 1d 1d 18 17 24 0b 00 ; 00DE7:  1e 1d 1d 18 17 24 0b 00
            hex 26 88 11 1d 18 24 1c 0e ; 00DEF:  26 88 11 1d 18 24 1c 0e
            hex 15 0e 0c 1d 24 0a 24 20 ; 00DF7:  15 0e 0c 1d 24 0a 24 20
            hex 18 1b                   ; 00DFF:  18 1b

            ora $0d,x                   ; 00E01:  15 0d
b0_8e03:    brk                         ; 00E03:  00
            hex 0a                      ; 00E04:  0a
            tay                         ; 00E05:  a8
            pla                         ; 00E06:  68
            sta $04                     ; 00E07:  85 04
            pla                         ; 00E09:  68
            sta $05                     ; 00E0A:  85 05
            iny                         ; 00E0C:  c8
            lda ($04),y                 ; 00E0D:  b1 04
            sta $06                     ; 00E0F:  85 06
            iny                         ; 00E11:  c8
            lda ($04),y                 ; 00E12:  b1 04
            sta $07                     ; 00E14:  85 07
            jmp ($0006)                 ; 00E16:  6c 06 00

b0_8e19:    lda PPUSTATUS               ; 00E19:  ad 02 20
            lda $0778                   ; 00E1C:  ad 78 07
            ora #$10                    ; 00E1F:  09 10
            and #$f0                    ; 00E21:  29 f0
            jsr b0_8eed                 ; 00E23:  20 ed 8e
            lda #$24                    ; 00E26:  a9 24
            jsr b0_8e2d                 ; 00E28:  20 2d 8e
            lda #$20                    ; 00E2B:  a9 20
b0_8e2d:    sta PPUADDR                 ; 00E2D:  8d 06 20
            lda #$00                    ; 00E30:  a9 00
            sta PPUADDR                 ; 00E32:  8d 06 20
            ldx #$04                    ; 00E35:  a2 04
            ldy #$c0                    ; 00E37:  a0 c0
            lda #$24                    ; 00E39:  a9 24
b0_8e3b:    sta PPUDATA                 ; 00E3B:  8d 07 20
            dey                         ; 00E3E:  88
            bne b0_8e3b                 ; 00E3F:  d0 fa
            dex                         ; 00E41:  ca
            bne b0_8e3b                 ; 00E42:  d0 f7
            ldy #$40                    ; 00E44:  a0 40
            txa                         ; 00E46:  8a
            sta $0300                   ; 00E47:  8d 00 03
            sta $0301                   ; 00E4A:  8d 01 03
b0_8e4d:    sta PPUDATA                 ; 00E4D:  8d 07 20
            dey                         ; 00E50:  88
            bne b0_8e4d                 ; 00E51:  d0 fa
            sta $073f                   ; 00E53:  8d 3f 07
            sta $0740                   ; 00E56:  8d 40 07
            jmp b0_8ee6                 ; 00E59:  4c e6 8e

b0_8e5c:    lda #$01                    ; 00E5C:  a9 01
            sta JOY1                    ; 00E5E:  8d 16 40
            lsr a                       ; 00E61:  4a
            tax                         ; 00E62:  aa
            sta JOY1                    ; 00E63:  8d 16 40
            jsr b0_8e6a                 ; 00E66:  20 6a 8e
            inx                         ; 00E69:  e8
b0_8e6a:    ldy #$08                    ; 00E6A:  a0 08
b0_8e6c:    pha                         ; 00E6C:  48
            lda JOY1,x                  ; 00E6D:  bd 16 40
            sta $00                     ; 00E70:  85 00
            lsr a                       ; 00E72:  4a
            ora $00                     ; 00E73:  05 00
            lsr a                       ; 00E75:  4a
            pla                         ; 00E76:  68
            rol a                       ; 00E77:  2a
            dey                         ; 00E78:  88
            bne b0_8e6c                 ; 00E79:  d0 f1
            sta $06fc,x                 ; 00E7B:  9d fc 06
            pha                         ; 00E7E:  48
            and #$30                    ; 00E7F:  29 30
            and $074a,x                 ; 00E81:  3d 4a 07
            beq b0_8e8d                 ; 00E84:  f0 07
            pla                         ; 00E86:  68
            and #$cf                    ; 00E87:  29 cf
            sta $06fc,x                 ; 00E89:  9d fc 06
            rts                         ; 00E8C:  60

b0_8e8d:    pla                         ; 00E8D:  68
            sta $074a,x                 ; 00E8E:  9d 4a 07
            rts                         ; 00E91:  60

b0_8e92:    sta PPUADDR                 ; 00E92:  8d 06 20
            iny                         ; 00E95:  c8
            lda ($00),y                 ; 00E96:  b1 00
            sta PPUADDR                 ; 00E98:  8d 06 20
            iny                         ; 00E9B:  c8
            lda ($00),y                 ; 00E9C:  b1 00
            asl a                       ; 00E9E:  0a
            pha                         ; 00E9F:  48
            lda $0778                   ; 00EA0:  ad 78 07
            ora #$04                    ; 00EA3:  09 04
            bcs b0_8ea9                 ; 00EA5:  b0 02
            and #$fb                    ; 00EA7:  29 fb
b0_8ea9:    jsr b0_8eed                 ; 00EA9:  20 ed 8e
            pla                         ; 00EAC:  68
            asl a                       ; 00EAD:  0a
            bcc b0_8eb3                 ; 00EAE:  90 03
            ora #$02                    ; 00EB0:  09 02
            iny                         ; 00EB2:  c8
b0_8eb3:    lsr a                       ; 00EB3:  4a
            lsr a                       ; 00EB4:  4a
            tax                         ; 00EB5:  aa
b0_8eb6:    bcs b0_8eb9                 ; 00EB6:  b0 01
            iny                         ; 00EB8:  c8
b0_8eb9:    lda ($00),y                 ; 00EB9:  b1 00
            sta PPUDATA                 ; 00EBB:  8d 07 20
            dex                         ; 00EBE:  ca
            bne b0_8eb6                 ; 00EBF:  d0 f5
            sec                         ; 00EC1:  38
            tya                         ; 00EC2:  98
            adc $00                     ; 00EC3:  65 00
            sta $00                     ; 00EC5:  85 00
            lda #$00                    ; 00EC7:  a9 00
            adc $01                     ; 00EC9:  65 01
            sta $01                     ; 00ECB:  85 01
            lda #$3f                    ; 00ECD:  a9 3f
            sta PPUADDR                 ; 00ECF:  8d 06 20
            lda #$00                    ; 00ED2:  a9 00
            sta PPUADDR                 ; 00ED4:  8d 06 20
            sta PPUADDR                 ; 00ED7:  8d 06 20
            sta PPUADDR                 ; 00EDA:  8d 06 20
b0_8edd:    ldx PPUSTATUS               ; 00EDD:  ae 02 20
            ldy #$00                    ; 00EE0:  a0 00
            lda ($00),y                 ; 00EE2:  b1 00
            bne b0_8e92                 ; 00EE4:  d0 ac
b0_8ee6:    sta PPUSCROLL               ; 00EE6:  8d 05 20
            sta PPUSCROLL               ; 00EE9:  8d 05 20
            rts                         ; 00EEC:  60

b0_8eed:    sta PPUCTRL                 ; 00EED:  8d 00 20
            sta $0778                   ; 00EF0:  8d 78 07
            rts                         ; 00EF3:  60

tab_b0_8ef4: ; 15 bytes
            hex f0 06 62 06 62 06 6d 02 ; 00EF4:  f0 06 62 06 62 06 6d 02
            hex 6d 02 7a 03 06 0c 12    ; 00EFC:  6d 02 7a 03 06 0c 12

            clc                         ; 00F03:  18
b0_8f04:    asl b0_8523+1,x             ; 00F04:  1e 24 85
            brk                         ; 00F07:  00
            hex 20                      ; 00F08:  20
            ora ($8f),y                 ; 00F09:  11 8f
            lda $00                     ; 00F0B:  a5 00
            lsr a                       ; 00F0D:  4a
            lsr a                       ; 00F0E:  4a
            lsr a                       ; 00F0F:  4a
            lsr a                       ; 00F10:  4a
            clc                         ; 00F11:  18
            adc #$01                    ; 00F12:  69 01
            and #$0f                    ; 00F14:  29 0f
            cmp #$06                    ; 00F16:  c9 06
            bcs b0_8f5e                 ; 00F18:  b0 44
            pha                         ; 00F1A:  48
            asl a                       ; 00F1B:  0a
            tay                         ; 00F1C:  a8
            ldx $0300                   ; 00F1D:  ae 00 03
            lda #$20                    ; 00F20:  a9 20
            cpy #$00                    ; 00F22:  c0 00
            bne b0_8f28                 ; 00F24:  d0 02
            lda #$22                    ; 00F26:  a9 22
b0_8f28:    sta $0301,x                 ; 00F28:  9d 01 03
            lda tab_b0_8ef4,y           ; 00F2B:  b9 f4 8e
            sta $0302,x                 ; 00F2E:  9d 02 03
            lda tab_b0_8ef4+1,y         ; 00F31:  b9 f5 8e
            sta $0303,x                 ; 00F34:  9d 03 03
            sta $03                     ; 00F37:  85 03
            stx $02                     ; 00F39:  86 02
            pla                         ; 00F3B:  68
            tax                         ; 00F3C:  aa
            lda tab_b0_8ef4+12,x        ; 00F3D:  bd 00 8f
            sec                         ; 00F40:  38
            sbc tab_b0_8ef4+1,y         ; 00F41:  f9 f5 8e
            tay                         ; 00F44:  a8
            ldx $02                     ; 00F45:  a6 02
b0_8f47:    lda $07d7,y                 ; 00F47:  b9 d7 07
            sta $0304,x                 ; 00F4A:  9d 04 03
            inx                         ; 00F4D:  e8
            iny                         ; 00F4E:  c8
            dec $03                     ; 00F4F:  c6 03
            bne b0_8f47                 ; 00F51:  d0 f4
            lda #$00                    ; 00F53:  a9 00
            sta $0304,x                 ; 00F55:  9d 04 03
            inx                         ; 00F58:  e8
            inx                         ; 00F59:  e8
            inx                         ; 00F5A:  e8
            stx $0300                   ; 00F5B:  8e 00 03
b0_8f5e:    rts                         ; 00F5E:  60

b0_8f5f:    lda $0770                   ; 00F5F:  ad 70 07
            cmp #$00                    ; 00F62:  c9 00
            beq b0_8f7c                 ; 00F64:  f0 16
            ldx #$05                    ; 00F66:  a2 05
b0_8f68:    lda $0134,x                 ; 00F68:  bd 34 01
            clc                         ; 00F6B:  18
            adc $07d7,y                 ; 00F6C:  79 d7 07
            bmi b0_8f87                 ; 00F6F:  30 16
            cmp #$0a                    ; 00F71:  c9 0a
            bcs b0_8f8e                 ; 00F73:  b0 19
b0_8f75:    sta $07d7,y                 ; 00F75:  99 d7 07
            dey                         ; 00F78:  88
            dex                         ; 00F79:  ca
            bpl b0_8f68                 ; 00F7A:  10 ec
b0_8f7c:    lda #$00                    ; 00F7C:  a9 00
            ldx #$06                    ; 00F7E:  a2 06
b0_8f80:    sta $0133,x                 ; 00F80:  9d 33 01
            dex                         ; 00F83:  ca
            bpl b0_8f80                 ; 00F84:  10 fa
            rts                         ; 00F86:  60

b0_8f87:    dec $0133,x                 ; 00F87:  de 33 01
            lda #$09                    ; 00F8A:  a9 09
            bne b0_8f75                 ; 00F8C:  d0 e7
b0_8f8e:    sec                         ; 00F8E:  38
            sbc #$0a                    ; 00F8F:  e9 0a
            inc $0133,x                 ; 00F91:  fe 33 01
            jmp b0_8f75                 ; 00F94:  4c 75 8f

b0_8f97:    ldx #$05                    ; 00F97:  a2 05
            jsr b0_8f9e                 ; 00F99:  20 9e 8f
            ldx #$0b                    ; 00F9C:  a2 0b
b0_8f9e:    ldy #$05                    ; 00F9E:  a0 05
            sec                         ; 00FA0:  38
b0_8fa1:    lda $07dd,x                 ; 00FA1:  bd dd 07
            sbc $07d7,y                 ; 00FA4:  f9 d7 07
            dex                         ; 00FA7:  ca
            dey                         ; 00FA8:  88
            bpl b0_8fa1                 ; 00FA9:  10 f6
            bcc b0_8fbb                 ; 00FAB:  90 0e
            inx                         ; 00FAD:  e8
            iny                         ; 00FAE:  c8
b0_8faf:    lda $07dd,x                 ; 00FAF:  bd dd 07
            sta $07d7,y                 ; 00FB2:  99 d7 07
            inx                         ; 00FB5:  e8
            iny                         ; 00FB6:  c8
            cpy #$06                    ; 00FB7:  c0 06
            bcc b0_8faf                 ; 00FB9:  90 f4
b0_8fbb:    rts                         ; 00FBB:  60

tab_b0_8fbc: ; 1 bytes
            hex 04                      ; 00FBC:  04

            bmi b0_9007                 ; 00FBD:  30 48
            rts                         ; 00FBF:  60

tab_b0_8fc0: ; 14 bytes
            hex 78 90 a8 c0 d8 e8 24 f8 ; 00FC0:  78 90 a8 c0 d8 e8 24 f8
            hex fc 28 2c 18 ff 23       ; 00FC8:  fc 28 2c 18 ff 23

            cli                         ; 00FCE:  58
            ldy #$6f                    ; 00FCF:  a0 6f
            jsr b0_90cc                 ; 00FD1:  20 cc 90
            ldy #$1f                    ; 00FD4:  a0 1f
b0_8fd6:    sta $07b0,y                 ; 00FD6:  99 b0 07
            dey                         ; 00FD9:  88
            bpl b0_8fd6                 ; 00FDA:  10 fa
            lda #$18                    ; 00FDC:  a9 18
            sta $07a2                   ; 00FDE:  8d a2 07
            jsr b0_9c03                 ; 00FE1:  20 03 9c
            ldy #$4b                    ; 00FE4:  a0 4b
            jsr b0_90cc                 ; 00FE6:  20 cc 90
            ldx #$21                    ; 00FE9:  a2 21
            lda #$00                    ; 00FEB:  a9 00
b0_8fed:    sta $0780,x                 ; 00FED:  9d 80 07
            dex                         ; 00FF0:  ca
            bpl b0_8fed                 ; 00FF1:  10 fa
            lda $075b                   ; 00FF3:  ad 5b 07
            ldy $0752                   ; 00FF6:  ac 52 07
            beq b0_8ffe                 ; 00FF9:  f0 03
            lda $0751                   ; 00FFB:  ad 51 07
b0_8ffe:    sta $071a                   ; 00FFE:  8d 1a 07
            sta $0725                   ; 01001:  8d 25 07
            sta $0728                   ; 01004:  8d 28 07
b0_9007:    jsr b0_b038                 ; 01007:  20 38 b0
            ldy #$20                    ; 0100A:  a0 20
            and #$01                    ; 0100C:  29 01
            beq b0_9012                 ; 0100E:  f0 02
            ldy #$24                    ; 01010:  a0 24
b0_9012:    sty $0720                   ; 01012:  8c 20 07
            ldy #$80                    ; 01015:  a0 80
            sty $0721                   ; 01017:  8c 21 07
            asl a                       ; 0101A:  0a
            asl a                       ; 0101B:  0a
            asl a                       ; 0101C:  0a
            asl a                       ; 0101D:  0a
            sta $06a0                   ; 0101E:  8d a0 06
            dec $0730                   ; 01021:  ce 30 07
            dec $0731                   ; 01024:  ce 31 07
            dec $0732                   ; 01027:  ce 32 07
            lda #$0b                    ; 0102A:  a9 0b
            sta $071e                   ; 0102C:  8d 1e 07
            jsr b0_9c22                 ; 0102F:  20 22 9c
            lda $076a                   ; 01032:  ad 6a 07
            bne b0_9047                 ; 01035:  d0 10
            lda $075f                   ; 01037:  ad 5f 07
            cmp #$04                    ; 0103A:  c9 04
            bcc b0_904a                 ; 0103C:  90 0c
            bne b0_9047                 ; 0103E:  d0 07
            lda $075c                   ; 01040:  ad 5c 07
            cmp #$02                    ; 01043:  c9 02
            bcc b0_904a                 ; 01045:  90 03
b0_9047:    inc $06cc                   ; 01047:  ee cc 06
b0_904a:    lda $075b                   ; 0104A:  ad 5b 07
            beq b0_9054                 ; 0104D:  f0 05
            lda #$02                    ; 0104F:  a9 02
            sta $0710                   ; 01051:  8d 10 07
b0_9054:    lda #$80                    ; 01054:  a9 80
            sta $fb                     ; 01056:  85 fb
            lda #$01                    ; 01058:  a9 01
            sta $0774                   ; 0105A:  8d 74 07
            inc $0772                   ; 0105D:  ee 72 07
            rts                         ; 01060:  60

            lda #$01                    ; 01061:  a9 01
            sta $0757                   ; 01063:  8d 57 07
            sta $0754                   ; 01066:  8d 54 07
            lda #$02                    ; 01069:  a9 02
            sta $075a                   ; 0106B:  8d 5a 07
            sta $0761                   ; 0106E:  8d 61 07
            lda #$00                    ; 01071:  a9 00
            sta $0774                   ; 01073:  8d 74 07
            tay                         ; 01076:  a8
b0_9077:    sta $0300,y                 ; 01077:  99 00 03
            iny                         ; 0107A:  c8
            bne b0_9077                 ; 0107B:  d0 fa
            sta $0759                   ; 0107D:  8d 59 07
            sta $0769                   ; 01080:  8d 69 07
            sta $0728                   ; 01083:  8d 28 07
            lda #$ff                    ; 01086:  a9 ff
            sta $03a0                   ; 01088:  8d a0 03
            lda $071a                   ; 0108B:  ad 1a 07
            lsr $0778                   ; 0108E:  4e 78 07
            and #$01                    ; 01091:  29 01
            ror a                       ; 01093:  6a
            rol $0778                   ; 01094:  2e 78 07
            jsr b0_90ed                 ; 01097:  20 ed 90
            lda #$38                    ; 0109A:  a9 38
            sta $06e3                   ; 0109C:  8d e3 06
            lda #$48                    ; 0109F:  a9 48
            sta $06e2                   ; 010A1:  8d e2 06
            lda #$58                    ; 010A4:  a9 58
            sta $06e1                   ; 010A6:  8d e1 06
            ldx #$0e                    ; 010A9:  a2 0e
b0_90ab:    lda tab_b0_8fbc,x           ; 010AB:  bd bc 8f
            sta $06e4,x                 ; 010AE:  9d e4 06
            dex                         ; 010B1:  ca
            bpl b0_90ab                 ; 010B2:  10 f7
            ldy #$03                    ; 010B4:  a0 03
b0_90b6:    lda tab_b0_8fc0+11,y        ; 010B6:  b9 cb 8f
            sta $0200,y                 ; 010B9:  99 00 02
            dey                         ; 010BC:  88
            bpl b0_90b6                 ; 010BD:  10 f7
            jsr b0_92af                 ; 010BF:  20 af 92
            jsr b0_92aa                 ; 010C2:  20 aa 92
            inc $0722                   ; 010C5:  ee 22 07
            inc $0772                   ; 010C8:  ee 72 07
            rts                         ; 010CB:  60

b0_90cc:    ldx #$07                    ; 010CC:  a2 07
            lda #$00                    ; 010CE:  a9 00
            sta $06                     ; 010D0:  85 06
b0_90d2:    stx $07                     ; 010D2:  86 07
b0_90d4:    cpx #$01                    ; 010D4:  e0 01
            bne b0_90dc                 ; 010D6:  d0 04
            cpy #$60                    ; 010D8:  c0 60
            bcs b0_90de                 ; 010DA:  b0 02
b0_90dc:    sta ($06),y                 ; 010DC:  91 06
b0_90de:    dey                         ; 010DE:  88
            cpy #$ff                    ; 010DF:  c0 ff
            bne b0_90d4                 ; 010E1:  d0 f1
            dex                         ; 010E3:  ca
            bpl b0_90d2                 ; 010E4:  10 ec
            rts                         ; 010E6:  60

tab_b0_90e7: ; 1 bytes
            hex 02                      ; 010E7:  02

            ora ($04,x)                 ; 010E8:  01 04
            php                         ; 010EA:  08
            bpl b0_910c+1               ; 010EB:  10 20
b0_90ed:    lda $0770                   ; 010ED:  ad 70 07
            beq b0_9115                 ; 010F0:  f0 23
            lda $0752                   ; 010F2:  ad 52 07
            cmp #$02                    ; 010F5:  c9 02
            beq b0_9106                 ; 010F7:  f0 0d
            ldy #$05                    ; 010F9:  a0 05
            lda $0710                   ; 010FB:  ad 10 07
            cmp #$06                    ; 010FE:  c9 06
            beq b0_9110                 ; 01100:  f0 0e
            cmp #$07                    ; 01102:  c9 07
            beq b0_9110                 ; 01104:  f0 0a
b0_9106:    ldy $074e                   ; 01106:  ac 4e 07
            lda $0743                   ; 01109:  ad 43 07
b0_910c:    beq b0_9110                 ; 0110C:  f0 02
            ldy #$04                    ; 0110E:  a0 04
b0_9110:    lda tab_b0_90e7,y           ; 01110:  b9 e7 90
            sta $fb                     ; 01113:  85 fb
b0_9115:    rts                         ; 01115:  60

tab_b0_9116: ; 27 bytes
            hex 28 18 38 28 08 00 00 20 ; 01116:  28 18 38 28 08 00 00 20
            hex b0 50 00 00 b0 b0 f0 00 ; 0111E:  b0 50 00 00 b0 b0 f0 00
            hex 20 00 00 00 00 00 00 20 ; 01126:  20 00 00 00 00 00 00 20
            hex 04 03 02                ; 0112E:  04 03 02

            lda $071a                   ; 01131:  ad 1a 07
            sta $6d                     ; 01134:  85 6d
            lda #$28                    ; 01136:  a9 28
            sta $070a                   ; 01138:  8d 0a 07
            lda #$01                    ; 0113B:  a9 01
            sta $33                     ; 0113D:  85 33
            sta $b5                     ; 0113F:  85 b5
            lda #$00                    ; 01141:  a9 00
            sta $1d                     ; 01143:  85 1d
            dec $0490                   ; 01145:  ce 90 04
            ldy #$00                    ; 01148:  a0 00
            sty $075b                   ; 0114A:  8c 5b 07
            lda $074e                   ; 0114D:  ad 4e 07
            bne b0_9153                 ; 01150:  d0 01
            iny                         ; 01152:  c8
b0_9153:    sty $0704                   ; 01153:  8c 04 07
            ldx $0710                   ; 01156:  ae 10 07
            ldy $0752                   ; 01159:  ac 52 07
            beq b0_9165                 ; 0115C:  f0 07
            cpy #$01                    ; 0115E:  c0 01
            beq b0_9165                 ; 01160:  f0 03
            ldx tab_b0_9116+2,y         ; 01162:  be 18 91
b0_9165:    lda tab_b0_9116,y           ; 01165:  b9 16 91
            sta $86                     ; 01168:  85 86
            lda tab_b0_9116+6,x         ; 0116A:  bd 1c 91
            sta $ce                     ; 0116D:  85 ce
            lda tab_b0_9116+15,x        ; 0116F:  bd 25 91
            sta $03c4                   ; 01172:  8d c4 03
            jsr b0_85f1                 ; 01175:  20 f1 85
            ldy $0715                   ; 01178:  ac 15 07
            beq b0_9197                 ; 0117B:  f0 1a
            lda $0757                   ; 0117D:  ad 57 07
            beq b0_9197                 ; 01180:  f0 15
            lda tab_b0_9116+23,y        ; 01182:  b9 2d 91
            sta $07f8                   ; 01185:  8d f8 07
            lda #$01                    ; 01188:  a9 01
            sta $07fa                   ; 0118A:  8d fa 07
            lsr a                       ; 0118D:  4a
            sta $07f9                   ; 0118E:  8d f9 07
            sta $0757                   ; 01191:  8d 57 07
            sta $079f                   ; 01194:  8d 9f 07
b0_9197:    ldy $0758                   ; 01197:  ac 58 07
            beq b0_91b0                 ; 0119A:  f0 14
            lda #$03                    ; 0119C:  a9 03
            sta $1d                     ; 0119E:  85 1d
            ldx #$00                    ; 011A0:  a2 00
            jsr b0_bd84                 ; 011A2:  20 84 bd
            lda #$f0                    ; 011A5:  a9 f0
            sta $d7                     ; 011A7:  85 d7
            ldx #$05                    ; 011A9:  a2 05
            ldy #$00                    ; 011AB:  a0 00
            jsr b0_b91e                 ; 011AD:  20 1e b9
b0_91b0:    ldy $074e                   ; 011B0:  ac 4e 07
            bne b0_91b8                 ; 011B3:  d0 03
            jsr b0_b70b                 ; 011B5:  20 0b b7
b0_91b8:    lda #$07                    ; 011B8:  a9 07
            sta $0e                     ; 011BA:  85 0e
            rts                         ; 011BC:  60

b0_91bd:    lsr $40,x                   ; 011BD:  56 40
            adc $70                     ; 011BF:  65 70
            ror $40                     ; 011C1:  66 40
            ror $40                     ; 011C3:  66 40
            ror $40                     ; 011C5:  66 40
            ror $60                     ; 011C7:  66 60
            adc $70                     ; 011C9:  65 70
            brk                         ; 011CB:  00
            hex 00                      ; 011CC:  00
            inc $0774                   ; 011CD:  ee 74 07
            lda #$00                    ; 011D0:  a9 00
            sta $0722                   ; 011D2:  8d 22 07
            lda #$80                    ; 011D5:  a9 80
            sta $fc                     ; 011D7:  85 fc
            dec $075a                   ; 011D9:  ce 5a 07
            bpl b0_91e9                 ; 011DC:  10 0b
            lda #$00                    ; 011DE:  a9 00
            sta $0772                   ; 011E0:  8d 72 07
            lda #$03                    ; 011E3:  a9 03
            sta $0770                   ; 011E5:  8d 70 07
            rts                         ; 011E8:  60

b0_91e9:    lda $075f                   ; 011E9:  ad 5f 07
            asl a                       ; 011EC:  0a
            tax                         ; 011ED:  aa
            lda $075c                   ; 011EE:  ad 5c 07
            and #$02                    ; 011F1:  29 02
            beq b0_91f6                 ; 011F3:  f0 01
            inx                         ; 011F5:  e8
b0_91f6:    ldy b0_91bd,x               ; 011F6:  bc bd 91
            lda $075c                   ; 011F9:  ad 5c 07
            lsr a                       ; 011FC:  4a
            tya                         ; 011FD:  98
            bcs b0_9204                 ; 011FE:  b0 04
            lsr a                       ; 01200:  4a
            lsr a                       ; 01201:  4a
            lsr a                       ; 01202:  4a
            lsr a                       ; 01203:  4a
b0_9204:    and #$0f                    ; 01204:  29 0f
            cmp $071a                   ; 01206:  cd 1a 07
            beq b0_920f                 ; 01209:  f0 04
            bcc b0_920f                 ; 0120B:  90 02
            lda #$00                    ; 0120D:  a9 00
b0_920f:    sta $075b                   ; 0120F:  8d 5b 07
            jsr b0_9282                 ; 01212:  20 82 92
            jmp b0_9264                 ; 01215:  4c 64 92

            hex ad 72 07 20 04 8e 24 92 ; 01218:  ad 72 07 20 04 8e 24 92
            hex 67 85 37 92             ; 01220:  67 85 37 92

            lda #$00                    ; 01224:  a9 00
            sta $073c                   ; 01226:  8d 3c 07
            sta $0722                   ; 01229:  8d 22 07
            lda #$02                    ; 0122C:  a9 02
            sta $fc                     ; 0122E:  85 fc
            inc $0774                   ; 01230:  ee 74 07
            inc $0772                   ; 01233:  ee 72 07
            rts                         ; 01236:  60

            lda #$00                    ; 01237:  a9 00
            sta $0774                   ; 01239:  8d 74 07
            lda $06fc                   ; 0123C:  ad fc 06
            and #$10                    ; 0123F:  29 10
            bne b0_9248                 ; 01241:  d0 05
            lda $07a0                   ; 01243:  ad a0 07
            bne b0_9281                 ; 01246:  d0 39
b0_9248:    lda #$80                    ; 01248:  a9 80
            sta $fc                     ; 0124A:  85 fc
            jsr b0_9282                 ; 0124C:  20 82 92
            bcc b0_9264                 ; 0124F:  90 13
            lda $075f                   ; 01251:  ad 5f 07
            sta $07fd                   ; 01254:  8d fd 07
            lda #$00                    ; 01257:  a9 00
            asl a                       ; 01259:  0a
            sta $0772                   ; 0125A:  8d 72 07
            sta $07a0                   ; 0125D:  8d a0 07
            sta $0770                   ; 01260:  8d 70 07
            rts                         ; 01263:  60

b0_9264:    jsr b0_9c03                 ; 01264:  20 03 9c
            lda #$01                    ; 01267:  a9 01
            sta $0754                   ; 01269:  8d 54 07
            inc $0757                   ; 0126C:  ee 57 07
            lda #$00                    ; 0126F:  a9 00
            sta $0747                   ; 01271:  8d 47 07
            sta $0756                   ; 01274:  8d 56 07
            sta $0e                     ; 01277:  85 0e
            sta $0772                   ; 01279:  8d 72 07
            lda #$01                    ; 0127C:  a9 01
            sta $0770                   ; 0127E:  8d 70 07
b0_9281:    rts                         ; 01281:  60

b0_9282:    sec                         ; 01282:  38
            lda $077a                   ; 01283:  ad 7a 07
            beq b0_92a9                 ; 01286:  f0 21
            lda $0761                   ; 01288:  ad 61 07
            bmi b0_92a9                 ; 0128B:  30 1c
            lda $0753                   ; 0128D:  ad 53 07
            eor #$01                    ; 01290:  49 01
            sta $0753                   ; 01292:  8d 53 07
            ldx #$06                    ; 01295:  a2 06
b0_9297:    lda $075a,x                 ; 01297:  bd 5a 07
            pha                         ; 0129A:  48
            lda $0761,x                 ; 0129B:  bd 61 07
            sta $075a,x                 ; 0129E:  9d 5a 07
            pla                         ; 012A1:  68
            sta $0761,x                 ; 012A2:  9d 61 07
            dex                         ; 012A5:  ca
            bpl b0_9297                 ; 012A6:  10 ef
            clc                         ; 012A8:  18
b0_92a9:    rts                         ; 012A9:  60

b0_92aa:    lda #$ff                    ; 012AA:  a9 ff
            sta $06c9                   ; 012AC:  8d c9 06
b0_92af:    rts                         ; 012AF:  60

b0_92b0:    ldy $071f                   ; 012B0:  ac 1f 07
            bne b0_92ba                 ; 012B3:  d0 05
            ldy #$08                    ; 012B5:  a0 08
            sty $071f                   ; 012B7:  8c 1f 07
b0_92ba:    dey                         ; 012BA:  88
            tya                         ; 012BB:  98
            jsr tab_b0_92c8             ; 012BC:  20 c8 92
            dec $071f                   ; 012BF:  ce 1f 07
            bne b0_92c7                 ; 012C2:  d0 03
            jsr b0_896a                 ; 012C4:  20 6a 89
b0_92c7:    rts                         ; 012C7:  60

tab_b0_92c8: ; 19 bytes
            hex 20 04 8e db 92 ae 88 ae ; 012C8:  20 04 8e db 92 ae 88 ae
            hex 88 fc 93 db 92 ae 88 ae ; 012D0:  88 fc 93 db 92 ae 88 ae
            hex 88 fc 93                ; 012D8:  88 fc 93

            inc $0726                   ; 012DB:  ee 26 07
            lda $0726                   ; 012DE:  ad 26 07
            and #$0f                    ; 012E1:  29 0f
            bne b0_92eb                 ; 012E3:  d0 06
            sta $0726                   ; 012E5:  8d 26 07
            inc $0725                   ; 012E8:  ee 25 07
b0_92eb:    inc $06a0                   ; 012EB:  ee a0 06
            lda $06a0                   ; 012EE:  ad a0 06
            and #$1f                    ; 012F1:  29 1f
            sta $06a0                   ; 012F3:  8d a0 06
b0_92f6:    rts                         ; 012F6:  60

            brk                         ; 012F7:  00
            hex 30                      ; 012F8:  30
            rts                         ; 012F9:  60

tab_b0_92fa: ; 258 bytes
            hex 93 00 00 11 12 12 13 00 ; 012FA:  93 00 00 11 12 12 13 00
            hex 00 51 52 53 00 00 00 00 ; 01302:  00 51 52 53 00 00 00 00
            hex 00 00 01 02 02 03 00 00 ; 0130A:  00 00 01 02 02 03 00 00
            hex 00 00 00 00 91 92 93 00 ; 01312:  00 00 00 00 91 92 93 00
            hex 00 00 00 51 52 53 41 42 ; 0131A:  00 00 00 51 52 53 41 42
            hex 43 00 00 00 00 00 91 92 ; 01322:  43 00 00 00 00 00 91 92
            hex 97 87 88 89 99 00 00 00 ; 0132A:  97 87 88 89 99 00 00 00
            hex 11 12 13 a4 a5 a5 a5 a6 ; 01332:  11 12 13 a4 a5 a5 a5 a6
            hex 97 98 99 01 02 03 00 a4 ; 0133A:  97 98 99 01 02 03 00 a4
            hex a5 a6 00 11 12 12 12 13 ; 01342:  a5 a6 00 11 12 12 12 13
            hex 00 00 00 00 01 02 02 03 ; 0134A:  00 00 00 00 01 02 02 03
            hex 00 a4 a5 a5 a6 00 00 00 ; 01352:  00 a4 a5 a5 a6 00 00 00
            hex 11 12 12 13 00 00 00 00 ; 0135A:  11 12 12 13 00 00 00 00
            hex 00 00 00 9c 00 8b aa aa ; 01362:  00 00 00 9c 00 8b aa aa
            hex aa aa 11 12 13 8b 00 9c ; 0136A:  aa aa 11 12 13 8b 00 9c
            hex 9c 00 00 01 02 03 11 12 ; 01372:  9c 00 00 01 02 03 11 12
            hex 12 13 00 00 00 00 aa aa ; 0137A:  12 13 00 00 00 00 aa aa
            hex 9c aa 00 8b 00 01 02 03 ; 01382:  9c aa 00 8b 00 01 02 03
            hex 80 83 00 81 84 00 82 85 ; 0138A:  80 83 00 81 84 00 82 85
            hex 00 02 00 00 03 00 00 04 ; 01392:  00 02 00 00 03 00 00 04
            hex 00 00 00 05 06 07 06 0a ; 0139A:  00 00 00 05 06 07 06 0a
            hex 00 08 09 4d 00 00 0d 0f ; 013A2:  00 08 09 4d 00 00 0d 0f
            hex 4e 0e 4e 4e 00 0d 1a 86 ; 013AA:  4e 0e 4e 4e 00 0d 1a 86
            hex 87 87 87 87 87 87 87 87 ; 013B2:  87 87 87 87 87 87 87 87
            hex 87 87 69 69 00 00 00 00 ; 013BA:  87 87 69 69 00 00 00 00
            hex 00 45 47 47 47 47 47 00 ; 013C2:  00 45 47 47 47 47 47 00
            hex 00 00 00 00 00 00 00 00 ; 013CA:  00 00 00 00 00 00 00 00
            hex 00 00 00 00 86 87 69 54 ; 013D2:  00 00 00 00 86 87 69 54
            hex 52 62 00 00 00 18 01 18 ; 013DA:  52 62 00 00 00 18 01 18
            hex 07 18 0f 18 ff 18 01 1f ; 013E2:  07 18 0f 18 ff 18 01 1f
            hex 07 1f 0f 1f 81 1f 01 00 ; 013EA:  07 1f 0f 1f 81 1f 01 00
            hex 8f 1f f1 1f f9 18 f1 18 ; 013F2:  8f 1f f1 1f f9 18 f1 18
            hex ff 1f                   ; 013FA:  ff 1f

            lda $0728                   ; 013FC:  ad 28 07
            beq b0_9404                 ; 013FF:  f0 03
            jsr tab_b0_9504+4           ; 01401:  20 08 95
b0_9404:    ldx #$0c                    ; 01404:  a2 0c
            lda #$00                    ; 01406:  a9 00
b0_9408:    sta $06a1,x                 ; 01408:  9d a1 06
            dex                         ; 0140B:  ca
            bpl b0_9408                 ; 0140C:  10 fa
            ldy $0742                   ; 0140E:  ac 42 07
            beq b0_9455                 ; 01411:  f0 42
            lda $0725                   ; 01413:  ad 25 07
b0_9416:    cmp #$03                    ; 01416:  c9 03
            bmi b0_941f                 ; 01418:  30 05
            sec                         ; 0141A:  38
            sbc #$03                    ; 0141B:  e9 03
            bpl b0_9416                 ; 0141D:  10 f7
b0_941f:    asl a                       ; 0141F:  0a
            asl a                       ; 01420:  0a
            asl a                       ; 01421:  0a
            asl a                       ; 01422:  0a
            adc b0_92f6,y               ; 01423:  79 f6 92
            adc $0726                   ; 01426:  6d 26 07
            tax                         ; 01429:  aa
            lda tab_b0_92fa,x           ; 0142A:  bd fa 92
            beq b0_9455                 ; 0142D:  f0 26
            pha                         ; 0142F:  48
            and #$0f                    ; 01430:  29 0f
            sec                         ; 01432:  38
            sbc #$01                    ; 01433:  e9 01
            sta $00                     ; 01435:  85 00
            asl a                       ; 01437:  0a
            adc $00                     ; 01438:  65 00
            tax                         ; 0143A:  aa
            pla                         ; 0143B:  68
            lsr a                       ; 0143C:  4a
            lsr a                       ; 0143D:  4a
            lsr a                       ; 0143E:  4a
            lsr a                       ; 0143F:  4a
            tay                         ; 01440:  a8
            lda #$03                    ; 01441:  a9 03
            sta $00                     ; 01443:  85 00
b0_9445:    lda tab_b0_92fa+144,x       ; 01445:  bd 8a 93
            sta $06a1,y                 ; 01448:  99 a1 06
            inx                         ; 0144B:  e8
            iny                         ; 0144C:  c8
            cpy #$0b                    ; 0144D:  c0 0b
            beq b0_9455                 ; 0144F:  f0 04
            dec $00                     ; 01451:  c6 00
            bne b0_9445                 ; 01453:  d0 f0
b0_9455:    ldx $0741                   ; 01455:  ae 41 07
            beq b0_946d                 ; 01458:  f0 13
            ldy tab_b0_92fa+179,x       ; 0145A:  bc ad 93
            ldx #$00                    ; 0145D:  a2 00
b0_945f:    lda tab_b0_92fa+183,y       ; 0145F:  b9 b1 93
            beq b0_9467                 ; 01462:  f0 03
            sta $06a1,x                 ; 01464:  9d a1 06
b0_9467:    iny                         ; 01467:  c8
            inx                         ; 01468:  e8
            cpx #$0d                    ; 01469:  e0 0d
            bne b0_945f                 ; 0146B:  d0 f2
b0_946d:    ldy $074e                   ; 0146D:  ac 4e 07
            bne b0_947e                 ; 01470:  d0 0c
            lda $075f                   ; 01472:  ad 5f 07
            cmp #$07                    ; 01475:  c9 07
            bne b0_947e                 ; 01477:  d0 05
            lda #$62                    ; 01479:  a9 62
            jmp b0_9488                 ; 0147B:  4c 88 94

b0_947e:    lda tab_b0_92fa+222,y       ; 0147E:  b9 d8 93
            ldy $0743                   ; 01481:  ac 43 07
            beq b0_9488                 ; 01484:  f0 02
            lda #$88                    ; 01486:  a9 88
b0_9488:    sta $07                     ; 01488:  85 07
            ldx #$00                    ; 0148A:  a2 00
            lda $0727                   ; 0148C:  ad 27 07
            asl a                       ; 0148F:  0a
            tay                         ; 01490:  a8
b0_9491:    lda tab_b0_92fa+226,y       ; 01491:  b9 dc 93
            sta $00                     ; 01494:  85 00
            iny                         ; 01496:  c8
            sty $01                     ; 01497:  84 01
            lda $0743                   ; 01499:  ad 43 07
            beq b0_94a8                 ; 0149C:  f0 0a
            cpx #$00                    ; 0149E:  e0 00
            beq b0_94a8                 ; 014A0:  f0 06
            lda $00                     ; 014A2:  a5 00
            and #$08                    ; 014A4:  29 08
            sta $00                     ; 014A6:  85 00
b0_94a8:    ldy #$00                    ; 014A8:  a0 00
b0_94aa:    lda $c68a,y                 ; 014AA:  b9 8a c6
            bit $00                     ; 014AD:  24 00
            beq b0_94b6                 ; 014AF:  f0 05
            lda $07                     ; 014B1:  a5 07
            sta $06a1,x                 ; 014B3:  9d a1 06
b0_94b6:    inx                         ; 014B6:  e8
            cpx #$0d                    ; 014B7:  e0 0d
            beq b0_94d3                 ; 014B9:  f0 18
            lda $074e                   ; 014BB:  ad 4e 07
            cmp #$02                    ; 014BE:  c9 02
            bne b0_94ca                 ; 014C0:  d0 08
            cpx #$0b                    ; 014C2:  e0 0b
            bne b0_94ca                 ; 014C4:  d0 04
            lda #$54                    ; 014C6:  a9 54
            sta $07                     ; 014C8:  85 07
b0_94ca:    iny                         ; 014CA:  c8
            cpy #$08                    ; 014CB:  c0 08
            bne b0_94aa                 ; 014CD:  d0 db
            ldy $01                     ; 014CF:  a4 01
            bne b0_9491                 ; 014D1:  d0 be
b0_94d3:    jsr tab_b0_9504+4           ; 014D3:  20 08 95
            lda $06a0                   ; 014D6:  ad a0 06
            jsr b0_9be1                 ; 014D9:  20 e1 9b
            ldx #$00                    ; 014DC:  a2 00
            ldy #$00                    ; 014DE:  a0 00
b0_94e0:    sty $00                     ; 014E0:  84 00
            lda $06a1,x                 ; 014E2:  bd a1 06
            and #$c0                    ; 014E5:  29 c0
            asl a                       ; 014E7:  0a
            rol a                       ; 014E8:  2a
            rol a                       ; 014E9:  2a
            tay                         ; 014EA:  a8
            lda $06a1,x                 ; 014EB:  bd a1 06
            cmp tab_b0_9504,y           ; 014EE:  d9 04 95
            bcs b0_94f5                 ; 014F1:  b0 02
            lda #$00                    ; 014F3:  a9 00
b0_94f5:    ldy $00                     ; 014F5:  a4 00
            sta ($06),y                 ; 014F7:  91 06
            tya                         ; 014F9:  98
            clc                         ; 014FA:  18
            adc #$10                    ; 014FB:  69 10
            tay                         ; 014FD:  a8
            inx                         ; 014FE:  e8
            cpx #$0d                    ; 014FF:  e0 0d
            bcc b0_94e0                 ; 01501:  90 dd
            rts                         ; 01503:  60

tab_b0_9504: ; 6 bytes
            hex 10 51 88 c0 a2 02       ; 01504:  10 51 88 c0 a2 02

b0_950a:    stx $08                     ; 0150A:  86 08
            lda #$00                    ; 0150C:  a9 00
            sta $0729                   ; 0150E:  8d 29 07
            ldy $072c                   ; 01511:  ac 2c 07
            lda ($e7),y                 ; 01514:  b1 e7
            cmp #$fd                    ; 01516:  c9 fd
            beq b0_9565                 ; 01518:  f0 4b
            lda $0730,x                 ; 0151A:  bd 30 07
            bpl b0_9565                 ; 0151D:  10 46
            iny                         ; 0151F:  c8
            lda ($e7),y                 ; 01520:  b1 e7
            asl a                       ; 01522:  0a
            bcc b0_9530                 ; 01523:  90 0b
            lda $072b                   ; 01525:  ad 2b 07
            bne b0_9530                 ; 01528:  d0 06
            inc $072b                   ; 0152A:  ee 2b 07
            inc $072a                   ; 0152D:  ee 2a 07
b0_9530:    dey                         ; 01530:  88
            lda ($e7),y                 ; 01531:  b1 e7
            and #$0f                    ; 01533:  29 0f
            cmp #$0d                    ; 01535:  c9 0d
            bne b0_9554                 ; 01537:  d0 1b
            iny                         ; 01539:  c8
            lda ($e7),y                 ; 0153A:  b1 e7
            dey                         ; 0153C:  88
            and #$40                    ; 0153D:  29 40
            bne b0_955d                 ; 0153F:  d0 1c
            lda $072b                   ; 01541:  ad 2b 07
            bne b0_955d                 ; 01544:  d0 17
            iny                         ; 01546:  c8
            lda ($e7),y                 ; 01547:  b1 e7
            and #$1f                    ; 01549:  29 1f
            sta $072a                   ; 0154B:  8d 2a 07
            inc $072b                   ; 0154E:  ee 2b 07
            jmp b0_956e                 ; 01551:  4c 6e 95

b0_9554:    cmp #$0e                    ; 01554:  c9 0e
            bne b0_955d                 ; 01556:  d0 05
            lda $0728                   ; 01558:  ad 28 07
            bne b0_9565                 ; 0155B:  d0 08
b0_955d:    lda $072a                   ; 0155D:  ad 2a 07
            cmp $0725                   ; 01560:  cd 25 07
            bcc b0_956b                 ; 01563:  90 06
b0_9565:    jsr b0_9595                 ; 01565:  20 95 95
            jmp b0_9571                 ; 01568:  4c 71 95

b0_956b:    inc $0729                   ; 0156B:  ee 29 07
b0_956e:    jsr b0_9589                 ; 0156E:  20 89 95
b0_9571:    ldx $08                     ; 01571:  a6 08
            lda $0730,x                 ; 01573:  bd 30 07
            bmi b0_957b                 ; 01576:  30 03
            dec $0730,x                 ; 01578:  de 30 07
b0_957b:    dex                         ; 0157B:  ca
            bpl b0_950a                 ; 0157C:  10 8c
            lda $0729                   ; 0157E:  ad 29 07
            bne tab_b0_9504+4           ; 01581:  d0 85
            lda $0728                   ; 01583:  ad 28 07
            bne tab_b0_9504+4           ; 01586:  d0 80
b0_9588:    rts                         ; 01588:  60

b0_9589:    inc $072c                   ; 01589:  ee 2c 07
            inc $072c                   ; 0158C:  ee 2c 07
            lda #$00                    ; 0158F:  a9 00
            sta $072b                   ; 01591:  8d 2b 07
            rts                         ; 01594:  60

b0_9595:    lda $0730,x                 ; 01595:  bd 30 07
            bmi b0_959d                 ; 01598:  30 03
            ldy $072d,x                 ; 0159A:  bc 2d 07
b0_959d:    ldx #$10                    ; 0159D:  a2 10
            lda ($e7),y                 ; 0159F:  b1 e7
            cmp #$fd                    ; 015A1:  c9 fd
            beq b0_9588                 ; 015A3:  f0 e3
            and #$0f                    ; 015A5:  29 0f
            cmp #$0f                    ; 015A7:  c9 0f
            beq b0_95b3                 ; 015A9:  f0 08
            ldx #$08                    ; 015AB:  a2 08
            cmp #$0c                    ; 015AD:  c9 0c
            beq b0_95b3                 ; 015AF:  f0 02
            ldx #$00                    ; 015B1:  a2 00
b0_95b3:    stx $07                     ; 015B3:  86 07
            ldx $08                     ; 015B5:  a6 08
            cmp #$0e                    ; 015B7:  c9 0e
            bne b0_95c3                 ; 015B9:  d0 08
            lda #$00                    ; 015BB:  a9 00
            sta $07                     ; 015BD:  85 07
            lda #$2e                    ; 015BF:  a9 2e
            bne b0_9616                 ; 015C1:  d0 53
b0_95c3:    cmp #$0d                    ; 015C3:  c9 0d
            bne b0_95e2                 ; 015C5:  d0 1b
            lda #$22                    ; 015C7:  a9 22
            sta $07                     ; 015C9:  85 07
            iny                         ; 015CB:  c8
            lda ($e7),y                 ; 015CC:  b1 e7
            and #$40                    ; 015CE:  29 40
            beq b0_9635                 ; 015D0:  f0 63
            lda ($e7),y                 ; 015D2:  b1 e7
            and #$7f                    ; 015D4:  29 7f
            cmp #$4b                    ; 015D6:  c9 4b
            bne b0_95dd                 ; 015D8:  d0 03
            inc $0745                   ; 015DA:  ee 45 07
b0_95dd:    and #$3f                    ; 015DD:  29 3f
            jmp b0_9616                 ; 015DF:  4c 16 96

b0_95e2:    cmp #$0c                    ; 015E2:  c9 0c
            bcs b0_960d                 ; 015E4:  b0 27
            iny                         ; 015E6:  c8
            lda ($e7),y                 ; 015E7:  b1 e7
            and #$70                    ; 015E9:  29 70
            bne b0_95f8                 ; 015EB:  d0 0b
            lda #$16                    ; 015ED:  a9 16
            sta $07                     ; 015EF:  85 07
            lda ($e7),y                 ; 015F1:  b1 e7
            and #$0f                    ; 015F3:  29 0f
            jmp b0_9616                 ; 015F5:  4c 16 96

b0_95f8:    sta $00                     ; 015F8:  85 00
            cmp #$70                    ; 015FA:  c9 70
            bne b0_9608                 ; 015FC:  d0 0a
            lda ($e7),y                 ; 015FE:  b1 e7
            and #$08                    ; 01600:  29 08
            beq b0_9608                 ; 01602:  f0 04
            lda #$00                    ; 01604:  a9 00
            sta $00                     ; 01606:  85 00
b0_9608:    lda $00                     ; 01608:  a5 00
            jmp b0_9612                 ; 0160A:  4c 12 96

b0_960d:    iny                         ; 0160D:  c8
            lda ($e7),y                 ; 0160E:  b1 e7
            and #$70                    ; 01610:  29 70
b0_9612:    lsr a                       ; 01612:  4a
            lsr a                       ; 01613:  4a
            lsr a                       ; 01614:  4a
            lsr a                       ; 01615:  4a
b0_9616:    sta $00                     ; 01616:  85 00
            lda $0730,x                 ; 01618:  bd 30 07
            bpl b0_965f                 ; 0161B:  10 42
            lda $072a                   ; 0161D:  ad 2a 07
            cmp $0725                   ; 01620:  cd 25 07
            beq b0_9636                 ; 01623:  f0 11
            ldy $072c                   ; 01625:  ac 2c 07
            lda ($e7),y                 ; 01628:  b1 e7
            and #$0f                    ; 0162A:  29 0f
            cmp #$0e                    ; 0162C:  c9 0e
            bne b0_9635                 ; 0162E:  d0 05
            lda $0728                   ; 01630:  ad 28 07
            bne b0_9656                 ; 01633:  d0 21
b0_9635:    rts                         ; 01635:  60

b0_9636:    lda $0728                   ; 01636:  ad 28 07
            beq b0_9646                 ; 01639:  f0 0b
            lda #$00                    ; 0163B:  a9 00
            sta $0728                   ; 0163D:  8d 28 07
            sta $0729                   ; 01640:  8d 29 07
            sta $08                     ; 01643:  85 08
            rts                         ; 01645:  60

b0_9646:    ldy $072c                   ; 01646:  ac 2c 07
            lda ($e7),y                 ; 01649:  b1 e7
            and #$f0                    ; 0164B:  29 f0
            lsr a                       ; 0164D:  4a
            lsr a                       ; 0164E:  4a
            lsr a                       ; 0164F:  4a
            lsr a                       ; 01650:  4a
            cmp $0726                   ; 01651:  cd 26 07
            bne b0_9635                 ; 01654:  d0 df
b0_9656:    lda $072c                   ; 01656:  ad 2c 07
            sta $072d,x                 ; 01659:  9d 2d 07
            jsr b0_9589                 ; 0165C:  20 89 95
b0_965f:    lda $00                     ; 0165F:  a5 00
            clc                         ; 01661:  18
            adc $07                     ; 01662:  65 07
            jsr b0_8e03+1               ; 01664:  20 04 8e
            sbc $98                     ; 01667:  e5 98
            rti                         ; 01669:  40

            hex 97 2e 9a 3e 9a f2 99 50 ; 0166A:  97 2e 9a 3e 9a f2 99 50
            hex 9a 59 9a e5 98 41 9b ba ; 01672:  9a 59 9a e5 98 41 9b ba
            hex 97 79 99 7c 99 7f 99 57 ; 0167A:  97 79 99 7c 99 7f 99 57
            hex 99 68 99 6b 99 d0 99 d7 ; 01682:  99 68 99 6b 99 d0 99 d7
            hex 99 06 98 b7 9a ab 98 94 ; 0168A:  99 06 98 b7 9a ab 98 94
            hex 99 0e 9b 0e 9b 0e 9b 01 ; 01692:  99 0e 9b 0e 9b 0e 9b 01
            hex 9b 19 9b 19 9b 19 9b 14 ; 0169A:  9b 19 9b 19 9b 19 9b 14
            hex 9b 19 9b 6f 98 19 9a d3 ; 016A2:  9b 19 9b 6f 98 19 9a d3
            hex 9a 82 98 9e 99 09 9a 0e ; 016AA:  9a 82 98 9e 99 09 9a 0e
            hex 9a 01 9a f2 96 0d 97 0d ; 016B2:  9a 01 9a f2 96 0d 97 0d
            hex 97 2b 97 2b 97 2b 97    ; 016BA:  97 2b 97 2b 97 2b 97

            eor $96                     ; 016C1:  45 96
            cmp $96                     ; 016C3:  c5 96
            ldy $072d,x                 ; 016C5:  bc 2d 07
            iny                         ; 016C8:  c8
            lda ($e7),y                 ; 016C9:  b1 e7
            pha                         ; 016CB:  48
            and #$40                    ; 016CC:  29 40
            bne b0_96e2                 ; 016CE:  d0 12
            pla                         ; 016D0:  68
            pha                         ; 016D1:  48
            and #$0f                    ; 016D2:  29 0f
            sta $0727                   ; 016D4:  8d 27 07
            pla                         ; 016D7:  68
            and #$30                    ; 016D8:  29 30
            lsr a                       ; 016DA:  4a
            lsr a                       ; 016DB:  4a
            lsr a                       ; 016DC:  4a
            lsr a                       ; 016DD:  4a
            sta $0742                   ; 016DE:  8d 42 07
            rts                         ; 016E1:  60

b0_96e2:    pla                         ; 016E2:  68
            and #$07                    ; 016E3:  29 07
            cmp #$04                    ; 016E5:  c9 04
            bcc b0_96ee                 ; 016E7:  90 05
            sta $0744                   ; 016E9:  8d 44 07
            lda #$00                    ; 016EC:  a9 00
b0_96ee:    sta $0741                   ; 016EE:  8d 41 07
            rts                         ; 016F1:  60

            ldx #$04                    ; 016F2:  a2 04
            lda $075f                   ; 016F4:  ad 5f 07
            beq b0_9701                 ; 016F7:  f0 08
            inx                         ; 016F9:  e8
            ldy $074e                   ; 016FA:  ac 4e 07
            dey                         ; 016FD:  88
            bne b0_9701                 ; 016FE:  d0 01
            inx                         ; 01700:  e8
b0_9701:    txa                         ; 01701:  8a
            sta $06d6                   ; 01702:  8d d6 06
            jsr b0_8807+1               ; 01705:  20 08 88
            lda #$0d                    ; 01708:  a9 0d
            jsr b0_9716                 ; 0170A:  20 16 97
            lda $0723                   ; 0170D:  ad 23 07
            eor #$01                    ; 01710:  49 01
            sta $0723                   ; 01712:  8d 23 07
            rts                         ; 01715:  60

b0_9716:    sta $00                     ; 01716:  85 00
            lda #$00                    ; 01718:  a9 00
            ldx #$04                    ; 0171A:  a2 04
b0_971c:    ldy $16,x                   ; 0171C:  b4 16
            cpy $00                     ; 0171E:  c4 00
b0_9720:    bne b0_9724                 ; 01720:  d0 02
            sta $0f,x                   ; 01722:  95 0f
b0_9724:    dex                         ; 01724:  ca
            bpl b0_971c                 ; 01725:  10 f5
            rts                         ; 01727:  60

            hex 14 17                   ; 01728:  14 17

            clc                         ; 0172A:  18
            ldx $00                     ; 0172B:  a6 00
            lda b0_9720,x               ; 0172D:  bd 20 97
            ldy #$05                    ; 01730:  a0 05
b0_9732:    dey                         ; 01732:  88
            bmi b0_973c                 ; 01733:  30 07
            hex d9 16 00 ; cmp $0016,y  ; 01735:  d9 16 00
            bne b0_9732                 ; 01738:  d0 f8
            lda #$00                    ; 0173A:  a9 00
b0_973c:    sta $06cd                   ; 0173C:  8d cd 06
            rts                         ; 0173F:  60

            lda $0733                   ; 01740:  ad 33 07
            jsr b0_8e03+1               ; 01743:  20 04 8e
            jmp $7897                   ; 01746:  4c 97 78

            hex 97                      ; 01749:  97

            adc #$9a                    ; 0174A:  69 9a
            jsr b0_9bbb                 ; 0174C:  20 bb 9b
            lda $0730,x                 ; 0174F:  bd 30 07
            beq b0_9773                 ; 01752:  f0 1f
            bpl b0_9767                 ; 01754:  10 11
            tya                         ; 01756:  98
            sta $0730,x                 ; 01757:  9d 30 07
            lda $0725                   ; 0175A:  ad 25 07
            ora $0726                   ; 0175D:  0d 26 07
            beq b0_9767                 ; 01760:  f0 05
            lda #$16                    ; 01762:  a9 16
            jmp b0_97b0                 ; 01764:  4c b0 97

b0_9767:    ldx $07                     ; 01767:  a6 07
            lda #$17                    ; 01769:  a9 17
            sta $06a1,x                 ; 0176B:  9d a1 06
            lda #$4c                    ; 0176E:  a9 4c
            jmp b0_97aa                 ; 01770:  4c aa 97

b0_9773:    lda #$18                    ; 01773:  a9 18
            jmp b0_97b0                 ; 01775:  4c b0 97

            jsr b0_9bac                 ; 01778:  20 ac 9b
            sty $06                     ; 0177B:  84 06
            bcc b0_978b                 ; 0177D:  90 0c
            lda $0730,x                 ; 0177F:  bd 30 07
            lsr a                       ; 01782:  4a
            sta $0736,x                 ; 01783:  9d 36 07
            lda #$19                    ; 01786:  a9 19
            jmp b0_97b0                 ; 01788:  4c b0 97

b0_978b:    lda #$1b                    ; 0178B:  a9 1b
            ldy $0730,x                 ; 0178D:  bc 30 07
            beq b0_97b0                 ; 01790:  f0 1e
            lda $0736,x                 ; 01792:  bd 36 07
            sta $06                     ; 01795:  85 06
            ldx $07                     ; 01797:  a6 07
            lda #$1a                    ; 01799:  a9 1a
            sta $06a1,x                 ; 0179B:  9d a1 06
            cpy $06                     ; 0179E:  c4 06
            bne b0_97ce                 ; 017A0:  d0 2c
            inx                         ; 017A2:  e8
            lda #$4f                    ; 017A3:  a9 4f
            sta $06a1,x                 ; 017A5:  9d a1 06
            lda #$50                    ; 017A8:  a9 50
b0_97aa:    inx                         ; 017AA:  e8
            ldy #$0f                    ; 017AB:  a0 0f
            jmp b0_9b7d                 ; 017AD:  4c 7d 9b

b0_97b0:    ldx $07                     ; 017B0:  a6 07
            ldy #$00                    ; 017B2:  a0 00
            jmp b0_9b7d                 ; 017B4:  4c 7d 9b

tab_b0_97b7: ; 1 bytes
            hex 42                      ; 017B7:  42

            eor ($43,x)                 ; 017B8:  41 43
            jsr b0_9bac                 ; 017BA:  20 ac 9b
            ldy #$00                    ; 017BD:  a0 00
            bcs b0_97c8                 ; 017BF:  b0 07
            iny                         ; 017C1:  c8
            lda $0730,x                 ; 017C2:  bd 30 07
            bne b0_97c8                 ; 017C5:  d0 01
            iny                         ; 017C7:  c8
b0_97c8:    lda tab_b0_97b7,y           ; 017C8:  b9 b7 97
            sta $06a1                   ; 017CB:  8d a1 06
b0_97ce:    rts                         ; 017CE:  60

tab_b0_97cf: ; 55 bytes
            hex 00 45 45 45 00 00 48 47 ; 017CF:  00 45 45 45 00 00 48 47
            hex 46 00 45 49 49 49 45 47 ; 017D7:  46 00 45 49 49 49 45 47
            hex 47 4a 47 47 47 47 4b 47 ; 017DF:  47 4a 47 47 47 47 4b 47
            hex 47 49 49 49 49 49 47 4a ; 017E7:  47 49 49 49 49 49 47 4a
            hex 47 4a 47 47 4b 47 4b 47 ; 017EF:  47 4a 47 47 4b 47 4b 47
            hex 47 47 47 47 47 4a 47 4a ; 017F7:  47 47 47 47 47 4a 47 4a
            hex 47 4a 4b 47 4b 47 4b    ; 017FF:  47 4a 4b 47 4b 47 4b

            jsr b0_9bbb                 ; 01806:  20 bb 9b
            sty $07                     ; 01809:  84 07
            ldy #$04                    ; 0180B:  a0 04
            jsr b0_9baf                 ; 0180D:  20 af 9b
            txa                         ; 01810:  8a
            pha                         ; 01811:  48
            ldy $0730,x                 ; 01812:  bc 30 07
            ldx $07                     ; 01815:  a6 07
            lda #$0b                    ; 01817:  a9 0b
            sta $06                     ; 01819:  85 06
b0_981b:    lda tab_b0_97cf,y           ; 0181B:  b9 cf 97
            sta $06a1,x                 ; 0181E:  9d a1 06
            inx                         ; 01821:  e8
            lda $06                     ; 01822:  a5 06
            beq b0_982d                 ; 01824:  f0 07
            iny                         ; 01826:  c8
            iny                         ; 01827:  c8
            iny                         ; 01828:  c8
            iny                         ; 01829:  c8
            iny                         ; 0182A:  c8
            dec $06                     ; 0182B:  c6 06
b0_982d:    cpx #$0b                    ; 0182D:  e0 0b
            bne b0_981b                 ; 0182F:  d0 ea
            pla                         ; 01831:  68
            tax                         ; 01832:  aa
            lda $0725                   ; 01833:  ad 25 07
            beq b0_986e                 ; 01836:  f0 36
            lda $0730,x                 ; 01838:  bd 30 07
            cmp #$01                    ; 0183B:  c9 01
            beq b0_9869                 ; 0183D:  f0 2a
            ldy $07                     ; 0183F:  a4 07
            bne b0_9847                 ; 01841:  d0 04
            cmp #$03                    ; 01843:  c9 03
            beq b0_9869                 ; 01845:  f0 22
b0_9847:    cmp #$02                    ; 01847:  c9 02
            bne b0_986e                 ; 01849:  d0 23
            jsr b0_9bcb                 ; 0184B:  20 cb 9b
            pha                         ; 0184E:  48
            jsr b0_994a                 ; 0184F:  20 4a 99
            pla                         ; 01852:  68
            sta $87,x                   ; 01853:  95 87
            lda $0725                   ; 01855:  ad 25 07
            sta $6e,x                   ; 01858:  95 6e
            lda #$01                    ; 0185A:  a9 01
            sta $b6,x                   ; 0185C:  95 b6
            sta $0f,x                   ; 0185E:  95 0f
            lda #$90                    ; 01860:  a9 90
            sta $cf,x                   ; 01862:  95 cf
            lda #$31                    ; 01864:  a9 31
            sta $16,x                   ; 01866:  95 16
            rts                         ; 01868:  60

b0_9869:    ldy #$52                    ; 01869:  a0 52
            sty $06ab                   ; 0186B:  8c ab 06
b0_986e:    rts                         ; 0186E:  60

            jsr b0_9bbb                 ; 0186F:  20 bb 9b
            ldy $0730,x                 ; 01872:  bc 30 07
            ldx $07                     ; 01875:  a6 07
            lda #$6b                    ; 01877:  a9 6b
            sta $06a1,x                 ; 01879:  9d a1 06
            lda #$6c                    ; 0187C:  a9 6c
            sta $06a2,x                 ; 0187E:  9d a2 06
            rts                         ; 01881:  60

            ldy #$03                    ; 01882:  a0 03
            jsr b0_9baf                 ; 01884:  20 af 9b
            ldy #$0a                    ; 01887:  a0 0a
            jsr b0_98b3                 ; 01889:  20 b3 98
            bcs b0_989e                 ; 0188C:  b0 10
            ldx #$06                    ; 0188E:  a2 06
b0_9890:    lda #$00                    ; 01890:  a9 00
            sta $06a1,x                 ; 01892:  9d a1 06
            dex                         ; 01895:  ca
            bpl b0_9890                 ; 01896:  10 f8
            lda tab_b0_98dd,y           ; 01898:  b9 dd 98
            sta $06a8                   ; 0189B:  8d a8 06
b0_989e:    rts                         ; 0189E:  60

tab_b0_989f: ; 12 bytes
            hex 15 14 00 00 15 1e 1d 1c ; 0189F:  15 14 00 00 15 1e 1d 1c
            hex 15 21 20 1f             ; 018A7:  15 21 20 1f

            ldy #$03                    ; 018AB:  a0 03
            jsr b0_9baf                 ; 018AD:  20 af 9b
            jsr b0_9bbb                 ; 018B0:  20 bb 9b
b0_98b3:    dey                         ; 018B3:  88
            dey                         ; 018B4:  88
            sty $05                     ; 018B5:  84 05
            ldy $0730,x                 ; 018B7:  bc 30 07
            sty $06                     ; 018BA:  84 06
            ldx $05                     ; 018BC:  a6 05
            inx                         ; 018BE:  e8
            lda tab_b0_989f,y           ; 018BF:  b9 9f 98
            cmp #$00                    ; 018C2:  c9 00
            beq b0_98ce                 ; 018C4:  f0 08
            ldx #$00                    ; 018C6:  a2 00
            ldy $05                     ; 018C8:  a4 05
            jsr b0_9b7d                 ; 018CA:  20 7d 9b
            clc                         ; 018CD:  18
b0_98ce:    ldy $06                     ; 018CE:  a4 06
            lda tab_b0_989f+4,y         ; 018D0:  b9 a3 98
            sta $06a1,x                 ; 018D3:  9d a1 06
            lda tab_b0_989f+8,y         ; 018D6:  b9 a7 98
            sta $06a2,x                 ; 018D9:  9d a2 06
            rts                         ; 018DC:  60

tab_b0_98dd: ; 6 bytes
            hex 11 10 15 14 13 12       ; 018DD:  11 10 15 14 13 12

            ora $14,x                   ; 018E3:  15 14
            jsr b0_9939                 ; 018E5:  20 39 99
            lda $00                     ; 018E8:  a5 00
            beq b0_98f0                 ; 018EA:  f0 04
            iny                         ; 018EC:  c8
            iny                         ; 018ED:  c8
            iny                         ; 018EE:  c8
            iny                         ; 018EF:  c8
b0_98f0:    tya                         ; 018F0:  98
            pha                         ; 018F1:  48
            lda $0760                   ; 018F2:  ad 60 07
            ora $075f                   ; 018F5:  0d 5f 07
            beq b0_9925                 ; 018F8:  f0 2b
            ldy $0730,x                 ; 018FA:  bc 30 07
            beq b0_9925                 ; 018FD:  f0 26
            jsr b0_994a                 ; 018FF:  20 4a 99
            bcs b0_9925                 ; 01902:  b0 21
            jsr b0_9bcb                 ; 01904:  20 cb 9b
            clc                         ; 01907:  18
            adc #$08                    ; 01908:  69 08
            sta $87,x                   ; 0190A:  95 87
            lda $0725                   ; 0190C:  ad 25 07
            adc #$00                    ; 0190F:  69 00
            sta $6e,x                   ; 01911:  95 6e
            lda #$01                    ; 01913:  a9 01
            sta $b6,x                   ; 01915:  95 b6
            sta $0f,x                   ; 01917:  95 0f
            jsr b0_9bd3                 ; 01919:  20 d3 9b
            sta $cf,x                   ; 0191C:  95 cf
            lda #$0d                    ; 0191E:  a9 0d
            sta $16,x                   ; 01920:  95 16
            jsr $c787                   ; 01922:  20 87 c7
b0_9925:    pla                         ; 01925:  68
            tay                         ; 01926:  a8
            ldx $07                     ; 01927:  a6 07
            lda tab_b0_98dd,y           ; 01929:  b9 dd 98
            sta $06a1,x                 ; 0192C:  9d a1 06
            inx                         ; 0192F:  e8
            lda tab_b0_98dd+2,y         ; 01930:  b9 df 98
            ldy $06                     ; 01933:  a4 06
            dey                         ; 01935:  88
            jmp b0_9b7d                 ; 01936:  4c 7d 9b

b0_9939:    ldy #$01                    ; 01939:  a0 01
            jsr b0_9baf                 ; 0193B:  20 af 9b
            jsr b0_9bbb                 ; 0193E:  20 bb 9b
            tya                         ; 01941:  98
            and #$07                    ; 01942:  29 07
            sta $06                     ; 01944:  85 06
            ldy $0730,x                 ; 01946:  bc 30 07
            rts                         ; 01949:  60

b0_994a:    ldx #$00                    ; 0194A:  a2 00
b0_994c:    clc                         ; 0194C:  18
            lda $0f,x                   ; 0194D:  b5 0f
            beq b0_9956                 ; 0194F:  f0 05
            inx                         ; 01951:  e8
            cpx #$05                    ; 01952:  e0 05
            bne b0_994c                 ; 01954:  d0 f6
b0_9956:    rts                         ; 01956:  60

            jsr b0_9bac                 ; 01957:  20 ac 9b
            lda #$86                    ; 0195A:  a9 86
            sta $06ab                   ; 0195C:  8d ab 06
            ldx #$0b                    ; 0195F:  a2 0b
            ldy #$01                    ; 01961:  a0 01
            lda #$87                    ; 01963:  a9 87
            jmp b0_9b7d                 ; 01965:  4c 7d 9b

            lda #$03                    ; 01968:  a9 03
            bit $07a9                   ; 0196A:  2c a9 07
            pha                         ; 0196D:  48
            jsr b0_9bac                 ; 0196E:  20 ac 9b
            pla                         ; 01971:  68
            tax                         ; 01972:  aa
            lda #$c0                    ; 01973:  a9 c0
            sta $06a1,x                 ; 01975:  9d a1 06
            rts                         ; 01978:  60

            lda #$06                    ; 01979:  a9 06
            bit $07a9                   ; 0197B:  2c a9 07
            bit $09a9                   ; 0197E:  2c a9 09
            pha                         ; 01981:  48
            jsr b0_9bac                 ; 01982:  20 ac 9b
            pla                         ; 01985:  68
            tax                         ; 01986:  aa
            lda #$0b                    ; 01987:  a9 0b
            sta $06a1,x                 ; 01989:  9d a1 06
            inx                         ; 0198C:  e8
            ldy #$00                    ; 0198D:  a0 00
            lda #$63                    ; 0198F:  a9 63
            jmp b0_9b7d                 ; 01991:  4c 7d 9b

            jsr b0_9bbb                 ; 01994:  20 bb 9b
            ldx #$02                    ; 01997:  a2 02
            lda #$6d                    ; 01999:  a9 6d
            jmp b0_9b7d                 ; 0199B:  4c 7d 9b

            lda #$24                    ; 0199E:  a9 24
            sta $06a1                   ; 019A0:  8d a1 06
            ldx #$01                    ; 019A3:  a2 01
            ldy #$08                    ; 019A5:  a0 08
            lda #$25                    ; 019A7:  a9 25
            jsr b0_9b7d                 ; 019A9:  20 7d 9b
            lda #$61                    ; 019AC:  a9 61
            sta $06ab                   ; 019AE:  8d ab 06
            jsr b0_9bcb                 ; 019B1:  20 cb 9b
            sec                         ; 019B4:  38
            sbc #$08                    ; 019B5:  e9 08
            sta $8c                     ; 019B7:  85 8c
            lda $0725                   ; 019B9:  ad 25 07
            sbc #$00                    ; 019BC:  e9 00
            sta $73                     ; 019BE:  85 73
            lda #$30                    ; 019C0:  a9 30
            sta $d4                     ; 019C2:  85 d4
            lda #$b0                    ; 019C4:  a9 b0
            sta $010d                   ; 019C6:  8d 0d 01
            lda #$30                    ; 019C9:  a9 30
            sta $1b                     ; 019CB:  85 1b
            inc $14                     ; 019CD:  e6 14
            rts                         ; 019CF:  60

            ldx #$00                    ; 019D0:  a2 00
            ldy #$0f                    ; 019D2:  a0 0f
            jmp b0_99e9                 ; 019D4:  4c e9 99

            txa                         ; 019D7:  8a
            pha                         ; 019D8:  48
            ldx #$01                    ; 019D9:  a2 01
            ldy #$0f                    ; 019DB:  a0 0f
            lda #$44                    ; 019DD:  a9 44
            jsr b0_9b7d                 ; 019DF:  20 7d 9b
            pla                         ; 019E2:  68
            tax                         ; 019E3:  aa
            jsr b0_9bbb                 ; 019E4:  20 bb 9b
            ldx #$01                    ; 019E7:  a2 01
b0_99e9:    lda #$40                    ; 019E9:  a9 40
            jmp b0_9b7d                 ; 019EB:  4c 7d 9b

tab_b0_99ee: ; 4 bytes
            hex c3 c2 c2 c2             ; 019EE:  c3 c2 c2 c2

            ldy $074e                   ; 019F2:  ac 4e 07
            lda tab_b0_99ee,y           ; 019F5:  b9 ee 99
b0_99f8:    jmp b0_9a44                 ; 019F8:  4c 44 9a

tab_b0_99fb: ; 6 bytes
            hex 06 07 08 c5 0c 89       ; 019FB:  06 07 08 c5 0c 89

            ldy #$0c                    ; 01A01:  a0 0c
            jsr b0_9baf                 ; 01A03:  20 af 9b
            jmp b0_9a0e                 ; 01A06:  4c 0e 9a

            lda #$08                    ; 01A09:  a9 08
            sta $0773                   ; 01A0B:  8d 73 07
b0_9a0e:    ldy $00                     ; 01A0E:  a4 00
            ldx b0_99f8+1,y             ; 01A10:  be f9 99
            lda tab_b0_99fb+1,y         ; 01A13:  b9 fc 99
            jmp b0_9a20                 ; 01A16:  4c 20 9a

            jsr b0_9bbb                 ; 01A19:  20 bb 9b
            ldx $07                     ; 01A1C:  a6 07
            lda #$c4                    ; 01A1E:  a9 c4
b0_9a20:    ldy #$00                    ; 01A20:  a0 00
            jmp b0_9b7d                 ; 01A22:  4c 7d 9b

tab_b0_9a25: ; 8 bytes
            hex 69 61 61 62 22 51 52 52 ; 01A25:  69 61 61 62 22 51 52 52

            dey                         ; 01A2D:  88
            ldy $074e                   ; 01A2E:  ac 4e 07
            lda $0743                   ; 01A31:  ad 43 07
            beq b0_9a38                 ; 01A34:  f0 02
            ldy #$04                    ; 01A36:  a0 04
b0_9a38:    lda tab_b0_9a25+4,y         ; 01A38:  b9 29 9a
            jmp b0_9a44                 ; 01A3B:  4c 44 9a

            ldy $074e                   ; 01A3E:  ac 4e 07
            lda tab_b0_9a25,y           ; 01A41:  b9 25 9a
b0_9a44:    pha                         ; 01A44:  48
            jsr b0_9bac                 ; 01A45:  20 ac 9b
b0_9a48:    ldx $07                     ; 01A48:  a6 07
            ldy #$00                    ; 01A4A:  a0 00
            pla                         ; 01A4C:  68
            jmp b0_9b7d                 ; 01A4D:  4c 7d 9b

            ldy $074e                   ; 01A50:  ac 4e 07
            lda tab_b0_9a25+4,y         ; 01A53:  b9 29 9a
            jmp b0_9a5f                 ; 01A56:  4c 5f 9a

            ldy $074e                   ; 01A59:  ac 4e 07
            lda tab_b0_9a25,y           ; 01A5C:  b9 25 9a
b0_9a5f:    pha                         ; 01A5F:  48
            jsr b0_9bbb                 ; 01A60:  20 bb 9b
            pla                         ; 01A63:  68
            ldx $07                     ; 01A64:  a6 07
            jmp b0_9b7d                 ; 01A66:  4c 7d 9b

            jsr b0_9bbb                 ; 01A69:  20 bb 9b
            ldx $07                     ; 01A6C:  a6 07
            lda #$64                    ; 01A6E:  a9 64
            sta $06a1,x                 ; 01A70:  9d a1 06
            inx                         ; 01A73:  e8
            dey                         ; 01A74:  88
            bmi b0_9a85                 ; 01A75:  30 0e
            lda #$65                    ; 01A77:  a9 65
            sta $06a1,x                 ; 01A79:  9d a1 06
            inx                         ; 01A7C:  e8
            dey                         ; 01A7D:  88
            bmi b0_9a85                 ; 01A7E:  30 05
            lda #$66                    ; 01A80:  a9 66
            jsr b0_9b7d                 ; 01A82:  20 7d 9b
b0_9a85:    ldx $046a                   ; 01A85:  ae 6a 04
            jsr b0_9bd3                 ; 01A88:  20 d3 9b
            sta $0477,x                 ; 01A8B:  9d 77 04
            lda $0725                   ; 01A8E:  ad 25 07
            sta $046b,x                 ; 01A91:  9d 6b 04
            jsr b0_9bcb                 ; 01A94:  20 cb 9b
            sta $0471,x                 ; 01A97:  9d 71 04
            inx                         ; 01A9A:  e8
            cpx #$06                    ; 01A9B:  e0 06
            bcc b0_9aa1                 ; 01A9D:  90 02
            ldx #$00                    ; 01A9F:  a2 00
b0_9aa1:    stx $046a                   ; 01AA1:  8e 6a 04
            rts                         ; 01AA4:  60

tab_b0_9aa5: ; 15 bytes
            hex 07 07 06 05 04 03 02 01 ; 01AA5:  07 07 06 05 04 03 02 01
            hex 00 03 03 04 05 06 07    ; 01AAD:  00 03 03 04 05 06 07

            php                         ; 01AB4:  08
            ora #$0a                    ; 01AB5:  09 0a
            jsr b0_9bac                 ; 01AB7:  20 ac 9b
            bcc b0_9ac1                 ; 01ABA:  90 05
            lda #$09                    ; 01ABC:  a9 09
            sta $0734                   ; 01ABE:  8d 34 07
b0_9ac1:    dec $0734                   ; 01AC1:  ce 34 07
            ldy $0734                   ; 01AC4:  ac 34 07
            ldx tab_b0_9aa5+9,y         ; 01AC7:  be ae 9a
            lda tab_b0_9aa5,y           ; 01ACA:  b9 a5 9a
            tay                         ; 01ACD:  a8
            lda #$61                    ; 01ACE:  a9 61
            jmp b0_9b7d                 ; 01AD0:  4c 7d 9b

            jsr b0_9bbb                 ; 01AD3:  20 bb 9b
            jsr b0_994a                 ; 01AD6:  20 4a 99
            jsr b0_9bcb                 ; 01AD9:  20 cb 9b
            sta $87,x                   ; 01ADC:  95 87
            lda $0725                   ; 01ADE:  ad 25 07
            sta $6e,x                   ; 01AE1:  95 6e
            jsr b0_9bd3                 ; 01AE3:  20 d3 9b
            sta $cf,x                   ; 01AE6:  95 cf
            sta $58,x                   ; 01AE8:  95 58
            lda #$32                    ; 01AEA:  a9 32
            sta $16,x                   ; 01AEC:  95 16
            ldy #$01                    ; 01AEE:  a0 01
            sty $b6,x                   ; 01AF0:  94 b6
            inc $0f,x                   ; 01AF2:  f6 0f
            ldx $07                     ; 01AF4:  a6 07
            lda #$67                    ; 01AF6:  a9 67
            sta $06a1,x                 ; 01AF8:  9d a1 06
            lda #$68                    ; 01AFB:  a9 68
            sta $06a2,x                 ; 01AFD:  9d a2 06
            rts                         ; 01B00:  60

            lda $075d                   ; 01B01:  ad 5d 07
            beq b0_9b3c                 ; 01B04:  f0 36
            lda #$00                    ; 01B06:  a9 00
            sta $075d                   ; 01B08:  8d 5d 07
            jmp b0_9b19                 ; 01B0B:  4c 19 9b

            jsr b0_9b36                 ; 01B0E:  20 36 9b
            jmp b0_9b2c                 ; 01B11:  4c 2c 9b

            lda #$00                    ; 01B14:  a9 00
            sta $06bc                   ; 01B16:  8d bc 06
b0_9b19:    jsr b0_9b36                 ; 01B19:  20 36 9b
            sty $07                     ; 01B1C:  84 07
            lda #$00                    ; 01B1E:  a9 00
            ldy $074e                   ; 01B20:  ac 4e 07
            dey                         ; 01B23:  88
            beq b0_9b28                 ; 01B24:  f0 02
            lda #$05                    ; 01B26:  a9 05
b0_9b28:    clc                         ; 01B28:  18
            adc $07                     ; 01B29:  65 07
            tay                         ; 01B2B:  a8
b0_9b2c:    lda tab_b0_bde8,y           ; 01B2C:  b9 e8 bd
            pha                         ; 01B2F:  48
            jsr b0_9bbb                 ; 01B30:  20 bb 9b
            jmp b0_9a48                 ; 01B33:  4c 48 9a

b0_9b36:    lda $00                     ; 01B36:  a5 00
            sec                         ; 01B38:  38
            sbc #$00                    ; 01B39:  e9 00
            tay                         ; 01B3B:  a8
b0_9b3c:    rts                         ; 01B3C:  60

tab_b0_9b3d: ; 12 bytes
            hex 87 00 00 00 20 ac 9b 90 ; 01B3D:  87 00 00 00 20 ac 9b 90
            hex 2d ad 4e 07             ; 01B45:  2d ad 4e 07

            bne b0_9b73                 ; 01B49:  d0 28
            ldx $046a                   ; 01B4B:  ae 6a 04
            jsr b0_9bcb                 ; 01B4E:  20 cb 9b
            sec                         ; 01B51:  38
            sbc #$10                    ; 01B52:  e9 10
            sta $0471,x                 ; 01B54:  9d 71 04
            lda $0725                   ; 01B57:  ad 25 07
            sbc #$00                    ; 01B5A:  e9 00
            sta $046b,x                 ; 01B5C:  9d 6b 04
            iny                         ; 01B5F:  c8
            iny                         ; 01B60:  c8
            tya                         ; 01B61:  98
            asl a                       ; 01B62:  0a
            asl a                       ; 01B63:  0a
            asl a                       ; 01B64:  0a
            asl a                       ; 01B65:  0a
            sta $0477,x                 ; 01B66:  9d 77 04
            inx                         ; 01B69:  e8
            cpx #$05                    ; 01B6A:  e0 05
            bcc b0_9b70                 ; 01B6C:  90 02
            ldx #$00                    ; 01B6E:  a2 00
b0_9b70:    stx $046a                   ; 01B70:  8e 6a 04
b0_9b73:    ldx $074e                   ; 01B73:  ae 4e 07
            lda tab_b0_9b3d,x           ; 01B76:  bd 3d 9b
            ldx #$08                    ; 01B79:  a2 08
            ldy #$0f                    ; 01B7B:  a0 0f
b0_9b7d:    sty $0735                   ; 01B7D:  8c 35 07
            ldy $06a1,x                 ; 01B80:  bc a1 06
            beq b0_9b9d                 ; 01B83:  f0 18
            cpy #$17                    ; 01B85:  c0 17
            beq b0_9ba0                 ; 01B87:  f0 17
            cpy #$1a                    ; 01B89:  c0 1a
            beq b0_9ba0                 ; 01B8B:  f0 13
            cpy #$c0                    ; 01B8D:  c0 c0
            beq b0_9b9d                 ; 01B8F:  f0 0c
            cpy #$c0                    ; 01B91:  c0 c0
            bcs b0_9ba0                 ; 01B93:  b0 0b
            cpy #$54                    ; 01B95:  c0 54
            bne b0_9b9d                 ; 01B97:  d0 04
            cmp #$50                    ; 01B99:  c9 50
            beq b0_9ba0                 ; 01B9B:  f0 03
b0_9b9d:    sta $06a1,x                 ; 01B9D:  9d a1 06
b0_9ba0:    inx                         ; 01BA0:  e8
            cpx #$0d                    ; 01BA1:  e0 0d
            bcs b0_9bab                 ; 01BA3:  b0 06
            ldy $0735                   ; 01BA5:  ac 35 07
            dey                         ; 01BA8:  88
            bpl b0_9b7d                 ; 01BA9:  10 d2
b0_9bab:    rts                         ; 01BAB:  60

b0_9bac:    jsr b0_9bbb                 ; 01BAC:  20 bb 9b
b0_9baf:    lda $0730,x                 ; 01BAF:  bd 30 07
            clc                         ; 01BB2:  18
            bpl b0_9bba                 ; 01BB3:  10 05
            tya                         ; 01BB5:  98
            sta $0730,x                 ; 01BB6:  9d 30 07
            sec                         ; 01BB9:  38
b0_9bba:    rts                         ; 01BBA:  60

b0_9bbb:    ldy $072d,x                 ; 01BBB:  bc 2d 07
            lda ($e7),y                 ; 01BBE:  b1 e7
            and #$0f                    ; 01BC0:  29 0f
            sta $07                     ; 01BC2:  85 07
            iny                         ; 01BC4:  c8
            lda ($e7),y                 ; 01BC5:  b1 e7
            and #$0f                    ; 01BC7:  29 0f
            tay                         ; 01BC9:  a8
            rts                         ; 01BCA:  60

b0_9bcb:    lda $0726                   ; 01BCB:  ad 26 07
            asl a                       ; 01BCE:  0a
            asl a                       ; 01BCF:  0a
            asl a                       ; 01BD0:  0a
            asl a                       ; 01BD1:  0a
            rts                         ; 01BD2:  60

b0_9bd3:    lda $07                     ; 01BD3:  a5 07
            asl a                       ; 01BD5:  0a
            asl a                       ; 01BD6:  0a
            asl a                       ; 01BD7:  0a
            asl a                       ; 01BD8:  0a
            clc                         ; 01BD9:  18
            adc #$20                    ; 01BDA:  69 20
            rts                         ; 01BDC:  60

b0_9bdd:    brk                         ; 01BDD:  00
            hex d0                      ; 01BDE:  d0
b0_9bdf:    ora $05                     ; 01BDF:  05 05
b0_9be1:    pha                         ; 01BE1:  48
            lsr a                       ; 01BE2:  4a
            lsr a                       ; 01BE3:  4a
            lsr a                       ; 01BE4:  4a
            lsr a                       ; 01BE5:  4a
            tay                         ; 01BE6:  a8
            lda b0_9bdf,y               ; 01BE7:  b9 df 9b
            sta $07                     ; 01BEA:  85 07
            pla                         ; 01BEC:  68
            and #$0f                    ; 01BED:  29 0f
            clc                         ; 01BEF:  18
            adc b0_9bdd,y               ; 01BF0:  79 dd 9b
            sta $06                     ; 01BF3:  85 06
            rts                         ; 01BF5:  60

            hex ff ff 12 36 0e 0e 0e 32 ; 01BF6:  ff ff 12 36 0e 0e 0e 32
            hex 32 32                   ; 01BFE:  32 32

            asl a                       ; 01C00:  0a
            rol $40                     ; 01C01:  26 40
b0_9c03:    jsr b0_9c13                 ; 01C03:  20 13 9c
            sta $0750                   ; 01C06:  8d 50 07
b0_9c09:    and #$60                    ; 01C09:  29 60
            asl a                       ; 01C0B:  0a
            rol a                       ; 01C0C:  2a
            rol a                       ; 01C0D:  2a
            rol a                       ; 01C0E:  2a
            sta $074e                   ; 01C0F:  8d 4e 07
            rts                         ; 01C12:  60

b0_9c13:    ldy $075f                   ; 01C13:  ac 5f 07
            lda tab_b0_9cb4,y           ; 01C16:  b9 b4 9c
            clc                         ; 01C19:  18
            adc $0760                   ; 01C1A:  6d 60 07
            tay                         ; 01C1D:  a8
            lda b0_9cbb+1,y             ; 01C1E:  b9 bc 9c
            rts                         ; 01C21:  60

b0_9c22:    lda $0750                   ; 01C22:  ad 50 07
            jsr b0_9c09                 ; 01C25:  20 09 9c
            tay                         ; 01C28:  a8
            lda $0750                   ; 01C29:  ad 50 07
            and #$1f                    ; 01C2C:  29 1f
            sta $074f                   ; 01C2E:  8d 4f 07
            lda tab_b0_9cd7+9,y         ; 01C31:  b9 e0 9c
            clc                         ; 01C34:  18
            adc $074f                   ; 01C35:  6d 4f 07
            tay                         ; 01C38:  a8
            lda tab_b0_9cd7+13,y        ; 01C39:  b9 e4 9c
            sta $e9                     ; 01C3C:  85 e9
            lda tab_b0_9d04+2,y         ; 01C3E:  b9 06 9d
            sta $ea                     ; 01C41:  85 ea
            ldy $074e                   ; 01C43:  ac 4e 07
            lda tab_b0_9d04+36,y        ; 01C46:  b9 28 9d
            clc                         ; 01C49:  18
            adc $074f                   ; 01C4A:  6d 4f 07
            tay                         ; 01C4D:  a8
            lda tab_b0_9d04+40,y        ; 01C4E:  b9 2c 9d
            sta $e7                     ; 01C51:  85 e7
            lda tab_b0_9d04+74,y        ; 01C53:  b9 4e 9d
            sta $e8                     ; 01C56:  85 e8
            ldy #$00                    ; 01C58:  a0 00
            lda ($e7),y                 ; 01C5A:  b1 e7
            pha                         ; 01C5C:  48
            and #$07                    ; 01C5D:  29 07
            cmp #$04                    ; 01C5F:  c9 04
            bcc b0_9c68                 ; 01C61:  90 05
            sta $0744                   ; 01C63:  8d 44 07
            lda #$00                    ; 01C66:  a9 00
b0_9c68:    sta $0741                   ; 01C68:  8d 41 07
            pla                         ; 01C6B:  68
            pha                         ; 01C6C:  48
            and #$38                    ; 01C6D:  29 38
            lsr a                       ; 01C6F:  4a
            lsr a                       ; 01C70:  4a
            lsr a                       ; 01C71:  4a
            sta $0710                   ; 01C72:  8d 10 07
            pla                         ; 01C75:  68
            and #$c0                    ; 01C76:  29 c0
            clc                         ; 01C78:  18
            rol a                       ; 01C79:  2a
            rol a                       ; 01C7A:  2a
            rol a                       ; 01C7B:  2a
            sta $0715                   ; 01C7C:  8d 15 07
            iny                         ; 01C7F:  c8
            lda ($e7),y                 ; 01C80:  b1 e7
            pha                         ; 01C82:  48
            and #$0f                    ; 01C83:  29 0f
            sta $0727                   ; 01C85:  8d 27 07
            pla                         ; 01C88:  68
            pha                         ; 01C89:  48
            and #$30                    ; 01C8A:  29 30
            lsr a                       ; 01C8C:  4a
            lsr a                       ; 01C8D:  4a
            lsr a                       ; 01C8E:  4a
            lsr a                       ; 01C8F:  4a
            sta $0742                   ; 01C90:  8d 42 07
            pla                         ; 01C93:  68
            and #$c0                    ; 01C94:  29 c0
            clc                         ; 01C96:  18
            rol a                       ; 01C97:  2a
            rol a                       ; 01C98:  2a
            rol a                       ; 01C99:  2a
            cmp #$03                    ; 01C9A:  c9 03
            bne b0_9ca3                 ; 01C9C:  d0 05
            sta $0743                   ; 01C9E:  8d 43 07
            lda #$00                    ; 01CA1:  a9 00
b0_9ca3:    sta $0733                   ; 01CA3:  8d 33 07
            lda $e7                     ; 01CA6:  a5 e7
            clc                         ; 01CA8:  18
            adc #$02                    ; 01CA9:  69 02
            sta $e7                     ; 01CAB:  85 e7
            lda $e8                     ; 01CAD:  a5 e8
            adc #$00                    ; 01CAF:  69 00
            sta $e8                     ; 01CB1:  85 e8
            rts                         ; 01CB3:  60

tab_b0_9cb4: ; 7 bytes
            hex 00 05 0a 0e 13 17 1b    ; 01CB4:  00 05 0a 0e 13 17 1b

b0_9cbb:    jsr $2925                   ; 01CBB:  20 25 29
            cpy #$26                    ; 01CBE:  c0 26
            rts                         ; 01CC0:  60

            hex 28 29 01 27 62 24 35 20 ; 01CC1:  28 29 01 27 62 24 35 20
            hex 63 22 29 41 2c 61 2a 31 ; 01CC9:  63 22 29 41 2c 61 2a 31
            hex 26 62                   ; 01CD1:  26 62

            rol $2d23                   ; 01CD3:  2e 23 2d
            rts                         ; 01CD6:  60

tab_b0_9cd7: ; 36 bytes
            hex 33 29 01 27 64 30 32 21 ; 01CD7:  33 29 01 27 64 30 32 21
            hex 65 1f 06 1c 00 70 97 b0 ; 01CDF:  65 1f 06 1c 00 70 97 b0
            hex df 0a 1f 59 7e 9b a9 d0 ; 01CE7:  df 0a 1f 59 7e 9b a9 d0
            hex 01 1f 3c 51 7b 7c a0 a9 ; 01CEF:  01 1f 3c 51 7b 7c a0 a9
            hex ce f1 fa fb             ; 01CF7:  ce f1 fa fb

            and $60,x                   ; 01CFB:  35 60
            stx $b3aa                   ; 01CFD:  8e aa b3
            cld                         ; 01D00:  d8
            ora $33                     ; 01D01:  05 33
            rts                         ; 01D03:  60

tab_b0_9d04: ; 570 bytes
            hex 71 9b 9d 9d 9d 9d 9e 9e ; 01D04:  71 9b 9d 9d 9d 9d 9e 9e
            hex 9e 9e 9e 9e 9e 9f 9f 9f ; 01D0C:  9e 9e 9e 9e 9e 9f 9f 9f
            hex 9f 9f 9f 9f 9f 9f 9f 9f ; 01D14:  9f 9f 9f 9f 9f 9f 9f 9f
            hex 9f a0 a0 a0 a0 a0 a0 a1 ; 01D1C:  9f a0 a0 a0 a0 a0 a0 a1
            hex a1 a1 a1 a1 00 03 19 1c ; 01D24:  a1 a1 a1 a1 00 03 19 1c
            hex 06 45 c0 6b ce 37 8a 19 ; 01D2C:  06 45 c0 6b ce 37 8a 19
            hex 8e f3 48 cd 32 3b 7a 8f ; 01D34:  8e f3 48 cd 32 3b 7a 8f
            hex f6 5b ce ff 92 05 7e d7 ; 01D3C:  f6 5b ce ff 92 05 7e d7
            hex 02 35 d8 79 af 10 8f 02 ; 01D44:  02 35 d8 79 af 10 8f 02
            hex 6f fa ae ae ae a4 a4 a5 ; 01D4C:  6f fa ae ae ae a4 a4 a5
            hex a5 a6 a6 a6 a7 a7 a8 a8 ; 01D54:  a5 a6 a6 a6 a7 a7 a8 a8
            hex a8 a8 a8 a9 a9 a9 aa ab ; 01D5C:  a8 a8 a8 a9 a9 a9 aa ab
            hex ab ab ac ac ac ad a1 a2 ; 01D64:  ab ab ac ac ac ad a1 a2
            hex a2 a3 a3 a3 76 dd bb 4c ; 01D6C:  a2 a3 a3 a3 76 dd bb 4c
            hex ea 1d 1b cc 56 5d 16 9d ; 01D74:  ea 1d 1b cc 56 5d 16 9d
            hex c6 1d 36 9d c9 1d 04 db ; 01D7C:  c6 1d 36 9d c9 1d 04 db
            hex 49 1d 84 1b c9 5d 88 95 ; 01D84:  49 1d 84 1b c9 5d 88 95
            hex 0f 08 30 4c 78 2d a6 28 ; 01D8C:  0f 08 30 4c 78 2d a6 28
            hex 90 b5 ff 0f 03 56 1b c9 ; 01D94:  90 b5 ff 0f 03 56 1b c9
            hex 1b 0f 07 36 1b aa 1b 48 ; 01D9C:  1b 0f 07 36 1b aa 1b 48
            hex 95 0f 0a 2a 1b 5b 0c 78 ; 01DA4:  95 0f 0a 2a 1b 5b 0c 78
            hex 2d 90 b5 ff 0b 8c 4b 4c ; 01DAC:  2d 90 b5 ff 0b 8c 4b 4c
            hex 77 5f eb 0c bd db 19 9d ; 01DB4:  77 5f eb 0c bd db 19 9d
            hex 75 1d 7d 5b d9 1d 3d dd ; 01DBC:  75 1d 7d 5b d9 1d 3d dd
            hex 99 1d 26 9d 5a 2b 8a 2c ; 01DC4:  99 1d 26 9d 5a 2b 8a 2c
            hex ca 1b 20 95 7b 5c db 4c ; 01DCC:  ca 1b 20 95 7b 5c db 4c
            hex 1b cc 3b cc 78 2d a6 28 ; 01DD4:  1b cc 3b cc 78 2d a6 28
            hex 90 b5 ff 0b 8c 3b 1d 8b ; 01DDC:  90 b5 ff 0b 8c 3b 1d 8b
            hex 1d ab 0c db 1d 0f 03 65 ; 01DE4:  1d ab 0c db 1d 0f 03 65
            hex 1d 6b 1b 05 9d 0b 1b 05 ; 01DEC:  1d 6b 1b 05 9d 0b 1b 05
            hex 9b 0b 1d 8b 0c 1b 8c 70 ; 01DF4:  9b 0b 1d 8b 0c 1b 8c 70
            hex 15 7b 0c db 0c 0f 08 78 ; 01DFC:  15 7b 0c db 0c 0f 08 78
            hex 2d a6 28 90 b5 ff 27 a9 ; 01E04:  2d a6 28 90 b5 ff 27 a9
            hex 4b 0c 68 29 0f 06 77 1b ; 01E0C:  4b 0c 68 29 0f 06 77 1b
            hex 0f 0b 60 15 4b 8c 78 2d ; 01E14:  0f 0b 60 15 4b 8c 78 2d
            hex 90 b5 ff 0f 03 8e 65 e1 ; 01E1C:  90 b5 ff 0f 03 8e 65 e1
            hex bb 38 6d a8 3e e5 e7 0f ; 01E24:  bb 38 6d a8 3e e5 e7 0f
            hex 08 0b 02 2b 02 5e 65 e1 ; 01E2C:  08 0b 02 2b 02 5e 65 e1
            hex bb 0e db 0e bb 8e db 0e ; 01E34:  bb 0e db 0e bb 8e db 0e
            hex fe 65 ec 0f 0d 4e 65 e1 ; 01E3C:  fe 65 ec 0f 0d 4e 65 e1
            hex 0f 0e 4e 02 e0 0f 10 fe ; 01E44:  0f 0e 4e 02 e0 0f 10 fe
            hex e5 e1 1b 85 7b 0c 5b 95 ; 01E4C:  e5 e1 1b 85 7b 0c 5b 95
            hex 78 2d 90 b5 ff a5 86 e4 ; 01E54:  78 2d 90 b5 ff a5 86 e4
            hex 28 18 a8 45 83 69 03 c6 ; 01E5C:  28 18 a8 45 83 69 03 c6
            hex 29 9b 83 16 a4 88 24 e9 ; 01E64:  29 9b 83 16 a4 88 24 e9
            hex 28 05 a8 7b 28 24 8f c8 ; 01E6C:  28 05 a8 7b 28 24 8f c8
            hex 03 e8 03 46 a8 85 24 c8 ; 01E74:  03 e8 03 46 a8 85 24 c8
            hex 24 ff eb 8e 0f 03 fb 05 ; 01E7C:  24 ff eb 8e 0f 03 fb 05
            hex 17 85 db 8e 0f 07 57 05 ; 01E84:  17 85 db 8e 0f 07 57 05
            hex 7b 05 9b 80 2b 85 fb 05 ; 01E8C:  7b 05 9b 80 2b 85 fb 05
            hex 0f 0b 1b 05 9b 05 ff 2e ; 01E94:  0f 0b 1b 05 9b 05 ff 2e
            hex c2 66 e2 11 0f 07 02 11 ; 01E9C:  c2 66 e2 11 0f 07 02 11
            hex 0f 0c 12 11 ff 0e c2 a8 ; 01EA4:  0f 0c 12 11 ff 0e c2 a8
            hex ab 00 bb 8e 6b 82 de 00 ; 01EAC:  ab 00 bb 8e 6b 82 de 00
            hex a0 33 86 43 06 3e b4 a0 ; 01EB4:  a0 33 86 43 06 3e b4 a0
            hex cb 02 0f 07 7e 42 a6 83 ; 01EBC:  cb 02 0f 07 7e 42 a6 83
            hex 02 0f 0a 3b 02 cb 37 0f ; 01EC4:  02 0f 0a 3b 02 cb 37 0f
            hex 0c e3 0e ff 9b 8e ca 0e ; 01ECC:  0c e3 0e ff 9b 8e ca 0e
            hex ee 42 44 5b 86 80 b8 1b ; 01ED4:  ee 42 44 5b 86 80 b8 1b
            hex 80 50 ba 10 b7 5b 00 17 ; 01EDC:  80 50 ba 10 b7 5b 00 17
            hex 85 4b 05 fe 34 40 b7 86 ; 01EE4:  85 4b 05 fe 34 40 b7 86
            hex c6 06 5b 80 83 00 d0 38 ; 01EEC:  c6 06 5b 80 83 00 d0 38
            hex 5b 8e 8a 0e a6 00 bb 0e ; 01EF4:  5b 8e 8a 0e a6 00 bb 0e
            hex c5 80 f3 00 ff 1e c2 00 ; 01EFC:  c5 80 f3 00 ff 1e c2 00
            hex 6b 06 8b 86 63 b7 0f 05 ; 01F04:  6b 06 8b 86 63 b7 0f 05
            hex 03 06 23 06 4b b7 bb 00 ; 01F0C:  03 06 23 06 4b b7 bb 00
            hex 5b b7 fb 37 3b b7 0f 0b ; 01F14:  5b b7 fb 37 3b b7 0f 0b
            hex 1b 37 ff 2b d7 e3 03 c2 ; 01F1C:  1b 37 ff 2b d7 e3 03 c2
            hex 86 e2 06 76 a5 a3 8f 03 ; 01F24:  86 e2 06 76 a5 a3 8f 03
            hex 86 2b 57 68 28 e9 28 e5 ; 01F2C:  86 2b 57 68 28 e9 28 e5
            hex 83 24 8f 36 a8 5b 03 ff ; 01F34:  83 24 8f 36 a8 5b 03 ff
            hex 0f 02                   ; 01F3C:  0f 02

            sei                         ; 01F3E:  78
            rti                         ; 01F3F:  40

tab_b0_9f40: ; 422 bytes
            hex 48 ce f8 c3 f8 c3 0f 07 ; 01F40:  48 ce f8 c3 f8 c3 0f 07
            hex 7b 43 c6 d0 0f 8a c8 50 ; 01F48:  7b 43 c6 d0 0f 8a c8 50
            hex ff 85 86 0b 80 1b 00 db ; 01F50:  ff 85 86 0b 80 1b 00 db
            hex 37 77 80 eb 37 fe 2b 20 ; 01F58:  37 77 80 eb 37 fe 2b 20
            hex 2b 80 7b 38 ab b8 77 86 ; 01F60:  2b 80 7b 38 ab b8 77 86
            hex fe 42 20 49 86 8b 06 9b ; 01F68:  fe 42 20 49 86 8b 06 9b
            hex 80 7b 8e 5b b7 9b 0e bb ; 01F70:  80 7b 8e 5b b7 9b 0e bb
            hex 0e 9b 80 ff 0b 80 60 38 ; 01F78:  0e 9b 80 ff 0b 80 60 38
            hex 10 b8 c0 3b db 8e 40 b8 ; 01F80:  10 b8 c0 3b db 8e 40 b8
            hex f0 38 7b 8e a0 b8 c0 b8 ; 01F88:  f0 38 7b 8e a0 b8 c0 b8
            hex fb 00 a0 b8 30 bb ee 42 ; 01F90:  fb 00 a0 b8 30 bb ee 42
            hex 88 0f 0b 2b 0e 67 0e ff ; 01F98:  88 0f 0b 2b 0e 67 0e ff
            hex 0a aa 0e 28 2a 0e 31 88 ; 01FA0:  0a aa 0e 28 2a 0e 31 88
            hex ff c7 83 d7 03 42 8f 7a ; 01FA8:  ff c7 83 d7 03 42 8f 7a
            hex 03 05 a4 78 24 a6 25 e4 ; 01FB0:  03 05 a4 78 24 a6 25 e4
            hex 25 4b 83 e3 03 05 a4 89 ; 01FB8:  25 4b 83 e3 03 05 a4 89
            hex 24 b5 24 09 a4 65 24 c9 ; 01FC0:  24 b5 24 09 a4 65 24 c9
            hex 24 0f 08 85 25 ff cd a5 ; 01FC8:  24 0f 08 85 25 ff cd a5
            hex b5 a8 07 a8 76 28 cc 25 ; 01FD0:  b5 a8 07 a8 76 28 cc 25
            hex 65 a4 a9 24 e5 24 19 a4 ; 01FD8:  65 a4 a9 24 e5 24 19 a4
            hex 0f 07 95 28 e6 24 19 a4 ; 01FE0:  0f 07 95 28 e6 24 19 a4
            hex d7 29 16 a9 58 29 97 29 ; 01FE8:  d7 29 16 a9 58 29 97 29
            hex ff 0f 02 02 11 0f 07 02 ; 01FF0:  ff 0f 02 02 11 0f 07 02
            hex 11 ff ff 2b 82 ab 38 de ; 01FF8:  11 ff ff 2b 82 ab 38 de
            hex 42 e2 1b b8 eb 3b db 80 ; 02000:  42 e2 1b b8 eb 3b db 80
            hex 8b b8 1b 82 fb b8 7b 80 ; 02008:  8b b8 1b 82 fb b8 7b 80
            hex fb 3c 5b bc 7b b8 1b 8e ; 02010:  fb 3c 5b bc 7b b8 1b 8e
            hex cb 0e 1b 8e 0f 0d 2b 3b ; 02018:  cb 0e 1b 8e 0f 0d 2b 3b
            hex bb b8 eb 82 4b b8 bb 38 ; 02020:  bb b8 eb 82 4b b8 bb 38
            hex 3b b7 bb 02 0f 13 1b 00 ; 02028:  3b b7 bb 02 0f 13 1b 00
            hex cb 80 6b bc ff 7b 80 ae ; 02030:  cb 80 6b bc ff 7b 80 ae
            hex 00 80 8b 8e e8 05 f9 86 ; 02038:  00 80 8b 8e e8 05 f9 86
            hex 17 86 16 85 4e 2b 80 ab ; 02040:  17 86 16 85 4e 2b 80 ab
            hex 8e 87 85 c3 05 8b 82 9b ; 02048:  8e 87 85 c3 05 8b 82 9b
            hex 02 ab 02 bb 86 cb 06 d3 ; 02050:  02 ab 02 bb 86 cb 06 d3
            hex 03 3b 8e 6b 0e a7 8e ff ; 02058:  03 3b 8e 6b 0e a7 8e ff
            hex 29 8e 52 11 83 0e 0f 03 ; 02060:  29 8e 52 11 83 0e 0f 03
            hex 9b 0e 2b 8e 5b 0e cb 8e ; 02068:  9b 0e 2b 8e 5b 0e cb 8e
            hex fb 0e fb 82 9b 82 bb 02 ; 02070:  fb 0e fb 82 9b 82 bb 02
            hex fe 42 e8 bb 8e 0f 0a ab ; 02078:  fe 42 e8 bb 8e 0f 0a ab
            hex 0e cb 0e f9 0e 88 86 a6 ; 02080:  0e cb 0e f9 0e 88 86 a6
            hex 06 db 02 b6 8e ff ab ce ; 02088:  06 db 02 b6 8e ff ab ce
            hex de 42 c0 cb ce 5b 8e 1b ; 02090:  de 42 c0 cb ce 5b 8e 1b
            hex ce 4b 85 67 45 0f 07 2b ; 02098:  ce 4b 85 67 45 0f 07 2b
            hex 00 7b 85 97 05 0f 0a 92 ; 020A0:  00 7b 85 97 05 0f 0a 92
            hex 02 ff 0a aa 0e 24 4a 1e ; 020A8:  02 ff 0a aa 0e 24 4a 1e
            hex 23 aa ff 1b 80 bb 38 4b ; 020B0:  23 aa ff 1b 80 bb 38 4b
            hex bc eb 3b 0f 04 2b 00 ab ; 020B8:  bc eb 3b 0f 04 2b 00 ab
            hex 38 eb 00 cb 8e fb 80 ab ; 020C0:  38 eb 00 cb 8e fb 80 ab
            hex b8 6b 80 fb 3c 9b bb 5b ; 020C8:  b8 6b 80 fb 3c 9b bb 5b
            hex bc fb 00 6b b8 fb 38 ff ; 020D0:  bc fb 00 6b b8 fb 38 ff
            hex 0b 86 1a 06 db 06 de c2 ; 020D8:  0b 86 1a 06 db 06 de c2
            hex 02 f0 3b bb 80 eb       ; 020E0:  02 f0 3b bb 80 eb

            asl $0b                     ; 020E6:  06 0b
            stx $93                     ; 020E8:  86 93
            asl $f0                     ; 020EA:  06 f0
            and $060f,y                 ; 020EC:  39 0f 06
            rts                         ; 020EF:  60

            hex b8 1b 86 a0 b9 b7 27 bd ; 020F0:  b8 1b 86 a0 b9 b7 27 bd
            hex 27 2b 83 a1 26 a9 26 ee ; 020F8:  27 2b 83 a1 26 a9 26 ee
            hex 25 0b 27 b4 ff 0f 02 1e ; 02100:  25 0b 27 b4 ff 0f 02 1e
            hex 2f 60 e0 3a a5 a7 db 80 ; 02108:  2f 60 e0 3a a5 a7 db 80
            hex 3b 82 8b 02 fe 42 68 70 ; 02110:  3b 82 8b 02 fe 42 68 70
            hex bb 25 a7 2c 27 b2 26 b9 ; 02118:  bb 25 a7 2c 27 b2 26 b9
            hex 26 9b 80 a8 82 b5 27 bc ; 02120:  26 9b 80 a8 82 b5 27 bc
            hex 27 b0 bb 3b 82 87 34 ee ; 02128:  27 b0 bb 3b 82 87 34 ee
            hex 25 6b ff 1e a5 0a 2e 28 ; 02130:  25 6b ff 1e a5 0a 2e 28
            hex 27 2e 33 c7 0f 03 1e 40 ; 02138:  27 2e 33 c7 0f 03 1e 40
            hex 07 2e 30 e7 0f 05 1e 24 ; 02140:  07 2e 30 e7 0f 05 1e 24
            hex 44 0f 07 1e 22 6a 2e 23 ; 02148:  44 0f 07 1e 22 6a 2e 23
            hex ab 0f 09 1e 41 68 1e 2a ; 02150:  ab 0f 09 1e 41 68 1e 2a
            hex 8a 2e 23 a2 2e 32 ea ff ; 02158:  8a 2e 23 a2 2e 32 ea ff
            hex 3b 87 66 27 cc 27 ee 31 ; 02160:  3b 87 66 27 cc 27 ee 31
            hex 87 ee 23 a7 3b 87 db 07 ; 02168:  87 ee 23 a7 3b 87 db 07
            hex ff 0f 01 2e 25 2b 2e 25 ; 02170:  ff 0f 01 2e 25 2b 2e 25
            hex 4b 4e 25 cb 6b 07 97 47 ; 02178:  4b 4e 25 cb 6b 07 97 47
            hex e9 87 47 c7 7a 07 d6 c7 ; 02180:  e9 87 47 c7 7a 07 d6 c7
            hex 78 07 38 87 ab 47 e3 07 ; 02188:  78 07 38 87 ab 47 e3 07
            hex 9b 87 0f 09 68 47 db c7 ; 02190:  9b 87 0f 09 68 47 db c7
            hex 3b c7 ff 47 9b cb 07 fa ; 02198:  3b c7 ff 47 9b cb 07 fa
            hex 1d 86 9b 3a 87 56 07 88 ; 021A0:  1d 86 9b 3a 87 56 07 88
            hex 1b 07 9d 2e 65 f0 ff 9b ; 021A8:  1b 07 9d 2e 65 f0 ff 9b
            hex 07 05 32 06 33 07 34 ce ; 021B0:  07 05 32 06 33 07 34 ce
            hex 03 dc 51 ee 07 73 e0 74 ; 021B8:  03 dc 51 ee 07 73 e0 74
            hex 0a 7e 06 9e 0a ce 06 e4 ; 021C0:  0a 7e 06 9e 0a ce 06 e4
            hex 00 e8 0a fe 0a 2e 89 4e ; 021C8:  00 e8 0a fe 0a 2e 89 4e
            hex 0b 54 0a 14 8a c4 0a 34 ; 021D0:  0b 54 0a 14 8a c4 0a 34
            hex 8a 7e 06 c7 0a 01 e0 02 ; 021D8:  8a 7e 06 c7 0a 01 e0 02
            hex 0a 47 0a 81 60 82 0a c7 ; 021E0:  0a 47 0a 81 60 82 0a c7
            hex 0a 0e 87 7e 02 a7 02 b3 ; 021E8:  0a 0e 87 7e 02 a7 02 b3
            hex 02 d7 02 e3 02 07 82 13 ; 021F0:  02 d7 02 e3 02 07 82 13
            hex 02 3e 06 7e 02 ae 07 fe ; 021F8:  02 3e 06 7e 02 ae 07 fe
            hex 0a 0d c4 cd 43 ce 09 de ; 02200:  0a 0d c4 cd 43 ce 09 de
            hex 0b dd 42 fe 02 5d c7 fd ; 02208:  0b dd 42 fe 02 5d c7 fd
            hex 5b 07 05 32 06 33 07 34 ; 02210:  5b 07 05 32 06 33 07 34
            hex 5e 0a 68 64 98 64 a8 64 ; 02218:  5e 0a 68 64 98 64 a8 64
            hex ce 06 fe 02 0d 01 1e 0e ; 02220:  ce 06 fe 02 0d 01 1e 0e
            hex 7e 02 94 63 b4 63 d4 63 ; 02228:  7e 02 94 63 b4 63 d4 63
            hex f4 63 14 e3 2e 0e 5e 02 ; 02230:  f4 63 14 e3 2e 0e 5e 02
            hex 64 35 88 72 be 0e 0d 04 ; 02238:  64 35 88 72 be 0e 0d 04
            hex ae 02 ce 08 cd 4b fe 02 ; 02240:  ae 02 ce 08 cd 4b fe 02
            hex 0d 05 68 31 7e 0a 96 31 ; 02248:  0d 05 68 31 7e 0a 96 31
            hex a9 63 a8 33 d5 30 ee 02 ; 02250:  a9 63 a8 33 d5 30 ee 02
            hex e6 62 f4 61 04 b1 08 3f ; 02258:  e6 62 f4 61 04 b1 08 3f
            hex 44 33 94 63 a4 31 e4 31 ; 02260:  44 33 94 63 a4 31 e4 31
            hex 04 bf 08 3f 04 bf 08 3f ; 02268:  04 bf 08 3f 04 bf 08 3f
            hex cd 4b 03 e4 0e 03 2e 01 ; 02270:  cd 4b 03 e4 0e 03 2e 01
            hex 7e 06 be 02 de 06 fe 0a ; 02278:  7e 06 be 02 de 06 fe 0a
            hex 0d c4 cd 43 ce 09 de 0b ; 02280:  0d c4 cd 43 ce 09 de 0b
            hex dd 42 fe 02 5d c7 fd 9b ; 02288:  dd 42 fe 02 5d c7 fd 9b
            hex 07 05 32 06 33 07 34 fe ; 02290:  07 05 32 06 33 07 34 fe
            hex 00 27 b1 65 32 75 0a 71 ; 02298:  00 27 b1 65 32 75 0a 71
            hex 00 b7 31 08 e4 18 64 1e ; 022A0:  00 b7 31 08 e4 18 64 1e
            hex 04 57 3b bb 0a 17 8a 27 ; 022A8:  04 57 3b bb 0a 17 8a 27
            hex 3a 73 0a 7b 0a d7 0a e7 ; 022B0:  3a 73 0a 7b 0a d7 0a e7
            hex 3a 3b 8a 97             ; 022B8:  3a 3b 8a 97

            asl a                       ; 022BC:  0a
            inc $2408,x                 ; 022BD:  fe 08 24
            txa                         ; 022C0:  8a
            rol $3e00                   ; 022C1:  2e 00 3e
            rti                         ; 022C4:  40

            hex 38 64 6f 00 9f 00 be 43 ; 022C5:  38 64 6f 00 9f 00 be 43
            hex c8 0a c9 63 ce 07 fe 07 ; 022CD:  c8 0a c9 63 ce 07 fe 07
            hex 2e 81 66 42 6a 42 79 0a ; 022D5:  2e 81 66 42 6a 42 79 0a
            hex be 00 c8 64 f8 64 08 e4 ; 022DD:  be 00 c8 64 f8 64 08 e4
            hex 2e 07 7e 03 9e 07 be 03 ; 022E5:  2e 07 7e 03 9e 07 be 03
            hex de 07 fe 0a 03 a5 0d 44 ; 022ED:  de 07 fe 0a 03 a5 0d 44
            hex cd 43 ce 09 dd 42 de 0b ; 022F5:  cd 43 ce 09 dd 42 de 0b
            hex fe 02 5d c7 fd 9b 07 05 ; 022FD:  fe 02 5d c7 fd 9b 07 05
            hex 32 06 33 07 34 fe 06 0c ; 02305:  32 06 33 07 34 fe 06 0c
            hex 81 39 0a 5c 01 89 0a ac ; 0230D:  81 39 0a 5c 01 89 0a ac
            hex 01 d9 0a fc 01 2e 83 a7 ; 02315:  01 d9 0a fc 01 2e 83 a7
            hex 01 b7 00 c7 01 de 0a fe ; 0231D:  01 b7 00 c7 01 de 0a fe
            hex 02 4e 83 5a 32 63 0a 69 ; 02325:  02 4e 83 5a 32 63 0a 69
            hex 0a 7e 02 ee 03 fa 32 03 ; 0232D:  0a 7e 02 ee 03 fa 32 03
            hex 8a 09 0a 1e 02 ee 03 fa ; 02335:  8a 09 0a 1e 02 ee 03 fa
            hex 32 03 8a 09 0a 14 42 1e ; 0233D:  32 03 8a 09 0a 14 42 1e
            hex 02 7e 0a 9e 07 fe 0a 2e ; 02345:  02 7e 0a 9e 07 fe 0a 2e
            hex 86 5e 0a 8e 06 be 0a ee ; 0234D:  86 5e 0a 8e 06 be 0a ee
            hex 07 3e 83 5e 07 fe 0a 0d ; 02355:  07 3e 83 5e 07 fe 0a 0d
            hex c4 41 52 51 52 cd 43 ce ; 0235D:  c4 41 52 51 52 cd 43 ce
            hex 09 de 0b dd 42 fe 02 5d ; 02365:  09 de 0b dd 42 fe 02 5d
            hex c7 fd 5b 07 05 32 06 33 ; 0236D:  c7 fd 5b 07 05 32 06 33
            hex 07 34 fe 0a ae 86 be 07 ; 02375:  07 34 fe 0a ae 86 be 07
            hex fe 02 0d 02 27 32 46 61 ; 0237D:  fe 02 0d 02 27 32 46 61
            hex 55 62 5e 0e 1e 82 68 3c ; 02385:  55 62 5e 0e 1e 82 68 3c
            hex 74 3a 7d 4b 5e 8e 7d 4b ; 0238D:  74 3a 7d 4b 5e 8e 7d 4b
            hex 7e 82 84 62 94 61 a4 31 ; 02395:  7e 82 84 62 94 61 a4 31
            hex bd 4b ce 06 fe 02 0d 06 ; 0239D:  bd 4b ce 06 fe 02 0d 06
            hex 34 31 3e 0a 64 32 75 0a ; 023A5:  34 31 3e 0a 64 32 75 0a
            hex 7b 61 a4 33 ae 02 de 0e ; 023AD:  7b 61 a4 33 ae 02 de 0e
            hex 3e 82 64 32 78 32 b4 36 ; 023B5:  3e 82 64 32 78 32 b4 36
            hex c8 36 dd 4b 44 b2 58 32 ; 023BD:  c8 36 dd 4b 44 b2 58 32
            hex 94 63 a4 3e ba 30 c9 61 ; 023C5:  94 63 a4 3e ba 30 c9 61
            hex ce 06 dd 4b ce 86 dd 4b ; 023CD:  ce 06 dd 4b ce 86 dd 4b
            hex fe 02 2e 86 5e 02 7e 06 ; 023D5:  fe 02 2e 86 5e 02 7e 06
            hex fe 02 1e 86 3e 02 5e 06 ; 023DD:  fe 02 1e 86 3e 02 5e 06
            hex 7e 02 9e 06 fe 0a 0d c4 ; 023E5:  7e 02 9e 06 fe 0a 0d c4
            hex cd 43 ce 09 de 0b dd 42 ; 023ED:  cd 43 ce 09 de 0b dd 42
            hex fe 02 5d c7 fd 5b 06 05 ; 023F5:  fe 02 5d c7 fd 5b 06 05
            hex 32 06 33 07 34 5e 0a ae ; 023FD:  32 06 33 07 34 5e 0a ae
            hex 02 0d 01 39 73 0d 03 39 ; 02405:  02 0d 01 39 73 0d 03 39
            hex 7b 4d 4b de 06 1e 8a ae ; 0240D:  7b 4d 4b de 06 1e 8a ae
            hex 06 c4 33 16 fe a5 77 fe ; 02415:  06 c4 33 16 fe a5 77 fe
            hex 02 fe 82 0d 07 39 73 a8 ; 0241D:  02 fe 82 0d 07 39 73 a8
            hex 74 ed 4b 49 fb e8 74 fe ; 02425:  74 ed 4b 49 fb e8 74 fe
            hex 0a 2e 82 67 02 84 7a 87 ; 0242D:  0a 2e 82 67 02 84 7a 87
            hex 31 0d 0b fe 02 0d 0c 39 ; 02435:  31 0d 0b fe 02 0d 0c 39
            hex 73 5e 06 c6 76 45 ff be ; 0243D:  73 5e 06 c6 76 45 ff be
            hex 0a dd 48 fe 06 3d cb 46 ; 02445:  0a dd 48 fe 06 3d cb 46
            hex 7e ad 4a fe 82 39 f3 a9 ; 0244D:  7e ad 4a fe 82 39 f3 a9
            hex 7b 4e 8a 9e 07 fe 0a 0d ; 02455:  7b 4e 8a 9e 07 fe 0a 0d
            hex c4 cd 43 ce 09 de 0b dd ; 0245D:  c4 cd 43 ce 09 de 0b dd
            hex 42 fe 02 5d c7 fd 94 11 ; 02465:  42 fe 02 5d c7 fd 94 11
            hex 0f 26 fe 10 28 94 65 15 ; 0246D:  0f 26 fe 10 28 94 65 15
            hex eb 12 fa                ; 02475:  eb 12 fa

            eor ($4a,x)                 ; 02478:  41 4a
            stx $54,y                   ; 0247A:  96 54
            rti                         ; 0247C:  40

            hex a4 42 b7 13 e9 19 f5 15 ; 0247D:  a4 42 b7 13 e9 19 f5 15
            hex 11 80 47 42 71 13 80 41 ; 02485:  11 80 47 42 71 13 80 41
            hex 15 92 1b 1f 24 40 55 12 ; 0248D:  15 92 1b 1f 24 40 55 12
            hex 64 40 95 12 a4 40 d2 12 ; 02495:  64 40 95 12 a4 40 d2 12
            hex e1 40 13 c0 2c 17 2f 12 ; 0249D:  e1 40 13 c0 2c 17 2f 12
            hex 49 13 83 40 9f 14 a3 40 ; 024A5:  49 13 83 40 9f 14 a3 40
            hex 17 92 83 13 92 41 b9 14 ; 024AD:  17 92 83 13 92 41 b9 14

            cmp $12                     ; 024B5:  c5 12
            iny                         ; 024B7:  c8
            rti                         ; 024B8:  40

            hex d4 40 4b 92 78 1b 9c 94 ; 024B9:  d4 40 4b 92 78 1b 9c 94
            hex 9f 11 df 14 fe 11 7d c1 ; 024C1:  9f 11 df 14 fe 11 7d c1
            hex 9e 42 cf 20 fd 90 b1 0f ; 024C9:  9e 42 cf 20 fd 90 b1 0f
            hex 26 29 91 7e 42 fe 40 28 ; 024D1:  26 29 91 7e 42 fe 40 28
            hex 92 4e 42 2e c0 57 73 c3 ; 024D9:  92 4e 42 2e c0 57 73 c3
            hex 25 c7 27 23 84 33 20 5c ; 024E1:  25 c7 27 23 84 33 20 5c
            hex 01 77 63 88 62          ; 024E9:  01 77 63 88 62

            sta $aa61,y                 ; 024EE:  99 61 aa
            rts                         ; 024F1:  60

            hex bc 01 ee 42 4e c0 69 11 ; 024F2:  bc 01 ee 42 4e c0 69 11
            hex 7e 42 de 40 f8 62       ; 024FA:  7e 42 de 40 f8 62

            asl tab_b0_ae38+138         ; 02500:  0e c2 ae
            rti                         ; 02503:  40

            hex d7 63 e7 63 33 a7 37 27 ; 02504:  d7 63 e7 63 33 a7 37 27
            hex 43 04 cc 01 e7 73 0c 81 ; 0250C:  43 04 cc 01 e7 73 0c 81
            hex 3e 42                   ; 02514:  3e 42

            ora $5e0a                   ; 02516:  0d 0a 5e
            rti                         ; 02519:  40

            hex 88 72 be 42 e7 87       ; 0251A:  88 72 be 42 e7 87

            inc $3940,x                 ; 02520:  fe 40 39
            sbc ($4e,x)                 ; 02523:  e1 4e
            brk                         ; 02525:  00
            hex 69                      ; 02526:  69
            rts                         ; 02527:  60

            hex 87 60 a5 60 c3 31 fe 31 ; 02528:  87 60 a5 60 c3 31 fe 31
            hex 6d c1 be 42 ef 20 fd 52 ; 02530:  6d c1 be 42 ef 20 fd 52
            hex 21 0f 20 6e 40 58 f2 93 ; 02538:  21 0f 20 6e 40 58 f2 93

            ora ($97,x)                 ; 02540:  01 97
            brk                         ; 02542:  00
            hex 0c                      ; 02543:  0c
            sta ($97,x)                 ; 02544:  81 97
            rti                         ; 02546:  40

tab_b0_a547: ; 407 bytes
            hex a6 41 c7 40 0d 04 03 01 ; 02547:  a6 41 c7 40 0d 04 03 01
            hex 07 01 23 01 27 01 ec 03 ; 0254F:  07 01 23 01 27 01 ec 03
            hex ac f3 c3 03 78 e2 94 43 ; 02557:  ac f3 c3 03 78 e2 94 43
            hex 47 f3 74 43 47 fb 74 43 ; 0255F:  47 f3 74 43 47 fb 74 43
            hex 2c f1 4c 63 47 00 57 21 ; 02567:  2c f1 4c 63 47 00 57 21
            hex 5c 01 7c 72 39 f1 ec 02 ; 0256F:  5c 01 7c 72 39 f1 ec 02
            hex 4c 81 d8 62 ec 01 0d 0d ; 02577:  4c 81 d8 62 ec 01 0d 0d
            hex 0f 38 c7 07 ed 4a 1d c1 ; 0257F:  0f 38 c7 07 ed 4a 1d c1
            hex 5f 26 fd 54 21 0f 26 a7 ; 02587:  5f 26 fd 54 21 0f 26 a7
            hex 22 37 fb 73 20 83 07 87 ; 0258F:  22 37 fb 73 20 83 07 87
            hex 02 93 20 c7 73 04 f1 06 ; 02597:  02 93 20 c7 73 04 f1 06
            hex 31 39 71 59 71 e7 73 37 ; 0259F:  31 39 71 59 71 e7 73 37
            hex a0 47 04 86 7c e5 71 e7 ; 025A7:  a0 47 04 86 7c e5 71 e7
            hex 31 33 a4 39 71 a9 71 d3 ; 025AF:  31 33 a4 39 71 a9 71 d3
            hex 23 08 f2 13 05 27 02 49 ; 025B7:  23 08 f2 13 05 27 02 49
            hex 71 75 75 e8 72 67 f3 99 ; 025BF:  71 75 75 e8 72 67 f3 99
            hex 71 e7 20 f4 72 f7 31 17 ; 025C7:  71 e7 20 f4 72 f7 31 17
            hex a0 33 20 39 71 73 28 bc ; 025CF:  a0 33 20 39 71 73 28 bc
            hex 05 39 f1 79 71 a6 21 c3 ; 025D7:  05 39 f1 79 71 a6 21 c3
            hex 06 d3 20 dc 00 fc 00 07 ; 025DF:  06 d3 20 dc 00 fc 00 07
            hex a2 13 21 5f 32 8c 00 98 ; 025E7:  a2 13 21 5f 32 8c 00 98
            hex 7a c7 63 d9 61 03 a2 07 ; 025EF:  7a c7 63 d9 61 03 a2 07
            hex 22 74 72 77 31 e7 73 39 ; 025F7:  22 74 72 77 31 e7 73 39
            hex f1 58 72 77 73 d8 72 7f ; 025FF:  f1 58 72 77 73 d8 72 7f
            hex b1 97 73 b6 64 c5 65 d4 ; 02607:  b1 97 73 b6 64 c5 65 d4
            hex 66 e3 67 f3 67 8d c1 cf ; 0260F:  66 e3 67 f3 67 8d c1 cf
            hex 26 fd 52 31 0f 20 6e 66 ; 02617:  26 fd 52 31 0f 20 6e 66
            hex 07 81 36 01 66 00 a7 22 ; 0261F:  07 81 36 01 66 00 a7 22
            hex 08 f2 67 7b dc 02 98 f2 ; 02627:  08 f2 67 7b dc 02 98 f2
            hex d7 20 39 f1 9f 33 dc 27 ; 0262F:  d7 20 39 f1 9f 33 dc 27
            hex dc 57 23 83 57 63 6c 51 ; 02637:  dc 57 23 83 57 63 6c 51
            hex 87 63 99 61 a3 06 b3 21 ; 0263F:  87 63 99 61 a3 06 b3 21
            hex 77 f3 f3 21 f7 2a 13 81 ; 02647:  77 f3 f3 21 f7 2a 13 81
            hex 23 22 53 00 63 22 e9 0b ; 0264F:  23 22 53 00 63 22 e9 0b
            hex 0c 83 13 21 16 22 33 05 ; 02657:  0c 83 13 21 16 22 33 05
            hex 8f 35 ec 01 63 a0 67 20 ; 0265F:  8f 35 ec 01 63 a0 67 20
            hex 73 01 77 01 83 20 87 20 ; 02667:  73 01 77 01 83 20 87 20
            hex b3 20 b7 20 c3 01 c7 00 ; 0266F:  b3 20 b7 20 c3 01 c7 00
            hex d3 20 d7 20 67 a0 77 07 ; 02677:  d3 20 d7 20 67 a0 77 07
            hex 87 22 e8 62 f5 65 1c 82 ; 0267F:  87 22 e8 62 f5 65 1c 82
            hex 7f 38 8d c1 cf 26 fd 50 ; 02687:  7f 38 8d c1 cf 26 fd 50
            hex 21 07 81 47 24 57 00 63 ; 0268F:  21 07 81 47 24 57 00 63
            hex 01 77 01 c9 71 68 f2 e7 ; 02697:  01 77 01 c9 71 68 f2 e7
            hex 73 97 fb 06 83 5c 01 d7 ; 0269F:  73 97 fb 06 83 5c 01 d7
            hex 22 e7 00 03 a7 6c 02 b3 ; 026A7:  22 e7 00 03 a7 6c 02 b3
            hex 22 e3 01 e7 07 47 a0 57 ; 026AF:  22 e3 01 e7 07 47 a0 57
            hex 06 a7 01 d3 00 d7 01 07 ; 026B7:  06 a7 01 d3 00 d7 01 07
            hex 81 67 20 93 22 03 a3 1c ; 026BF:  81 67 20 93 22 03 a3 1c
            hex 61 17 21 6f 33 c7 63 d8 ; 026C7:  61 17 21 6f 33 c7 63 d8
            hex 62 e9 61 fa 60 4f b3 87 ; 026CF:  62 e9 61 fa 60 4f b3 87
            hex 63 9c 01 b7 63 c8 62    ; 026D7:  63 9c 01 b7 63 c8 62

            cmp $ea61,y                 ; 026DE:  d9 61 ea
            rts                         ; 026E1:  60

            hex 39 f1 87 21 a7 01 b7 20 ; 026E2:  39 f1 87 21 a7 01 b7 20
            hex 39 f1 5f 38 6d c1 af 26 ; 026EA:  39 f1 5f 38 6d c1 af 26
            hex fd 90 11 0f 26 fe 10 2a ; 026F2:  fd 90 11 0f 26 fe 10 2a
            hex 93 87 17 a3 14 b2 42 0a ; 026FA:  93 87 17 a3 14 b2 42 0a
            hex 92 19 40 36 14 50 41 82 ; 02702:  92 19 40 36 14 50 41 82
            hex 16 2b 93 24 41 bb 14 b8 ; 0270A:  16 2b 93 24 41 bb 14 b8
            hex 00 c2 43 c3 13 1b 94 67 ; 02712:  00 c2 43 c3 13 1b 94 67
            hex 12 c4 15 53 c1 d2 41 12 ; 0271A:  12 c4 15 53 c1 d2 41 12
            hex c1 29 13 85 17 1b 92 1a ; 02722:  c1 29 13 85 17 1b 92 1a
            hex 42 47 13 83 41 a7 13 0e ; 0272A:  42 47 13 83 41 a7 13 0e
            hex 91 a7 63 b7 63 c5 65 d5 ; 02732:  91 a7 63 b7 63 c5 65 d5
            hex 65 dd 4a e3 67 f3 67 8d ; 0273A:  65 dd 4a e3 67 f3 67 8d
            hex c1 ae 42 df 20 fd 90 11 ; 02742:  c1 ae 42 df 20 fd 90 11
            hex 0f 26 6e 10 8b 17 af 32 ; 0274A:  0f 26 6e 10 8b 17 af 32
            hex d8 62 e8 62 fc 3f ad c8 ; 02752:  d8 62 e8 62 fc 3f ad c8
            hex f8 64 0c be 43 43 f8 64 ; 0275A:  f8 64 0c be 43 43 f8 64
            hex 0c bf 73 40 84 40 93 40 ; 02762:  0c bf 73 40 84 40 93 40
            hex a4 40 b3 40 f8 64 48 e4 ; 0276A:  a4 40 b3 40 f8 64 48 e4
            hex 5c 39 83 40 92          ; 02772:  5c 39 83 40 92

            eor ($b3,x)                 ; 02777:  41 b3
            rti                         ; 02779:  40

            hex f8 64 48 e4 5c 39 f8 64 ; 0277A:  f8 64 48 e4 5c 39 f8 64
            hex 13 c2 37 65 4c 24 63 00 ; 02782:  13 c2 37 65 4c 24 63 00
            hex 97 65 c3 42 0b 97 ac 32 ; 0278A:  97 65 c3 42 0b 97 ac 32
            hex f8 64 0c be 53 45 9d 48 ; 02792:  f8 64 0c be 53 45 9d 48
            hex f8 64 2a e2 3c 47 56 43 ; 0279A:  f8 64 2a e2 3c 47 56 43
            hex ba 62 f8 64 0c b7 88 64 ; 027A2:  ba 62 f8 64 0c b7 88 64
            hex bc 31 d4 45 fc 31 3c b1 ; 027AA:  bc 31 d4 45 fc 31 3c b1
            hex 78 64 8c 38 0b 9c 1a 33 ; 027B2:  78 64 8c 38 0b 9c 1a 33

            clc                         ; 027BA:  18
            adc ($28,x)                 ; 027BB:  61 28
            adc ($39,x)                 ; 027BD:  61 39
            rts                         ; 027BF:  60

            hex 5d 4a ee 11 0f b8 1d c1 ; 027C0:  5d 4a ee 11 0f b8 1d c1
            hex 3e 42 6f 20 fd 52 31 0f ; 027C8:  3e 42 6f 20 fd 52 31 0f
            hex 20 6e 40 f7 20 07 84 17 ; 027D0:  20 6e 40 f7 20 07 84 17
            hex 20 4f 34 c3 03 c7 02 d3 ; 027D8:  20 4f 34 c3 03 c7 02 d3
            hex 22 27 e3 39 61 e7 73 5c ; 027E0:  22 27 e3 39 61 e7 73 5c
            hex e4 57 00 6c 73 47 a0 53 ; 027E8:  e4 57 00 6c 73 47 a0 53
            hex 06 63 22 a7 73 fc 73 13 ; 027F0:  06 63 22 a7 73 fc 73 13
            hex a1 33 05 43 21 5c 72 c3 ; 027F8:  a1 33 05 43 21 5c 72 c3
            hex 23 cc 03 77 fb ac 02 39 ; 02800:  23 cc 03 77 fb ac 02 39
            hex f1 a7 73 d3 04 e8 72 e3 ; 02808:  f1 a7 73 d3 04 e8 72 e3
            hex 22 26 f4 bc 02 8c 81 a8 ; 02810:  22 26 f4 bc 02 8c 81 a8
            hex 62 17 87 43 24 a7 01 c3 ; 02818:  62 17 87 43 24 a7 01 c3
            hex 04 08 f2 97 21 a3 02    ; 02820:  04 08 f2 97 21 a3 02

            cmp #$0b                    ; 02827:  c9 0b
            sbc ($69,x)                 ; 02829:  e1 69
            sbc ($69),y                 ; 0282B:  f1 69
            sta $cfc1                   ; 0282D:  8d c1 cf
            rol $fd                     ; 02830:  26 fd
            sec                         ; 02832:  38
            ora ($0f),y                 ; 02833:  11 0f
            rol $ad                     ; 02835:  26 ad
            rti                         ; 02837:  40

            hex 3d c7 fd 95 b1 0f 26 0d ; 02838:  3d c7 fd 95 b1 0f 26 0d
            hex 02 c8 72 1c 81 38 72 0d ; 02840:  02 c8 72 1c 81 38 72 0d
            hex 05 97 34 98 62 a3 20 b3 ; 02848:  05 97 34 98 62 a3 20 b3
            hex 06 c3 20 cc 03 f9 91 2c ; 02850:  06 c3 20 cc 03 f9 91 2c
            hex 81 48 62 0d 09 37 63 47 ; 02858:  81 48 62 0d 09 37 63 47
            hex 03 57 21 8c 02 c5 79 c7 ; 02860:  03 57 21 8c 02 c5 79 c7

            and ($f9),y                 ; 02868:  31 f9
            ora ($39),y                 ; 0286A:  11 39
            sbc ($a9),y                 ; 0286C:  f1 a9
            ora ($6f),y                 ; 0286E:  11 6f
            ldy $d3,x                   ; 02870:  b4 d3
            adc $e3                     ; 02872:  65 e3
            adc $7d                     ; 02874:  65 7d
            cmp ($bf,x)                 ; 02876:  c1 bf
            rol $fd                     ; 02878:  26 fd
            brk                         ; 0287A:  00
            hex c1                      ; 0287B:  c1
            jmp $f400                   ; 0287C:  4c 00 f4

            hex 4f 0d 02 02 42 43 4f 52 ; 0287F:  4f 0d 02 02 42 43 4f 52
            hex c2 de 00 5a c2 4d c7 fd ; 02887:  c2 de 00 5a c2 4d c7 fd
            hex 90 51 0f 26 ee 10 0b 94 ; 0288F:  90 51 0f 26 ee 10 0b 94
            hex 33 14 42 42 77 16 86 44 ; 02897:  33 14 42 42 77 16 86 44
            hex 02 92 4a 16 69 42 73 14 ; 0289F:  02 92 4a 16 69 42 73 14
            hex b0 00 c7 12 05 c0 1c 17 ; 028A7:  b0 00 c7 12 05 c0 1c 17
            hex 1f 11 36 12 8f 14 91 40 ; 028AF:  1f 11 36 12 8f 14 91 40
            hex 1b 94 35 12 34 42 60 42 ; 028B7:  1b 94 35 12 34 42 60 42
            hex 61 12 87 12 96 40 a3 14 ; 028BF:  61 12 87 12 96 40 a3 14
            hex 1c 98 1f 11 47 12 9f 15 ; 028C7:  1c 98 1f 11 47 12 9f 15
            hex cc 15 cf 11 05 c0 1f 15 ; 028CF:  cc 15 cf 11 05 c0 1f 15
            hex 39 12 7c                ; 028D7:  39 12 7c

            asl $7f,x                   ; 028DA:  16 7f
            ora ($82),y                 ; 028DC:  11 82
            rti                         ; 028DE:  40

            hex 98 12 df 15 16 c4 17 14 ; 028DF:  98 12 df 15 16 c4 17 14
            hex 54 12 9b 16 28 94 ce 01 ; 028E7:  54 12 9b 16 28 94 ce 01
            hex 3d c1 5e 42 8f 20 fd 97 ; 028EF:  3d c1 5e 42 8f 20 fd 97
            hex 11 0f 26 fe 10 2b 92 57 ; 028F7:  11 0f 26 fe 10 2b 92 57
            hex 12 8b 12 c0 41 f7 13 5b ; 028FF:  12 8b 12 c0 41 f7 13 5b
            hex 92 69 0b bb 12 b2 46 19 ; 02907:  92 69 0b bb 12 b2 46 19
            hex 93 71 00 17 94 7c 14 7f ; 0290F:  93 71 00 17 94 7c 14 7f
            hex 11 93 41 bf 15 fc 13 ff ; 02917:  11 93 41 bf 15 fc 13 ff
            hex 11 2f 95 50 42 51 12 58 ; 0291F:  11 2f 95 50 42 51 12 58
            hex 14 a6 12 db 12 1b 93 46 ; 02927:  14 a6 12 db 12 1b 93 46
            hex 43 7b 12 8d 49 b7 14 1b ; 0292F:  43 7b 12 8d 49 b7 14 1b
            hex 94 49 0b bb 12 fc 13 ff ; 02937:  94 49 0b bb 12 fc 13 ff
            hex 12 03 c1 2f 15 43 12 4b ; 0293F:  12 03 c1 2f 15 43 12 4b
            hex 13 77 13 9d 4a 15 c1 a1 ; 02947:  13 77 13 9d 4a 15 c1 a1
            hex 41 c3 12 fe 01 7d c1 9e ; 0294F:  41 c3 12 fe 01 7d c1 9e
            hex 42 cf 20 fd 52 21 0f 20 ; 02957:  42 cf 20 fd 52 21 0f 20
            hex 6e 44 0c f1 4c 01 aa 35 ; 0295F:  6e 44 0c f1 4c 01 aa 35
            hex d9 34 ee 20 08 b3 37 32 ; 02967:  d9 34 ee 20 08 b3 37 32
            hex 43 04 4e 21 53 20 7c 01 ; 0296F:  43 04 4e 21 53 20 7c 01
            hex 97 21 b7 07 9c 81 e7 42 ; 02977:  97 21 b7 07 9c 81 e7 42
            hex 5f b3 97 63 ac 02 c5 41 ; 0297F:  5f b3 97 63 ac 02 c5 41
            hex 49 e0 58 61 76 64 85 65 ; 02987:  49 e0 58 61 76 64 85 65
            hex 94 66 a4 22 a6 03 c8 22 ; 0298F:  94 66 a4 22 a6 03 c8 22
            hex dc 02 68 f2 96 42 13 82 ; 02997:  dc 02 68 f2 96 42 13 82
            hex 17 02 af 34 f6 21 fc 06 ; 0299F:  17 02 af 34 f6 21 fc 06
            hex 26 80 2a 24 36 01 8c 00 ; 029A7:  26 80 2a 24 36 01 8c 00
            hex ff 35 4e a0 55 21 77 20 ; 029AF:  ff 35 4e a0 55 21 77 20
            hex 87 07 89 22 ae 21 4c 82 ; 029B7:  87 07 89 22 ae 21 4c 82
            hex 9f 34 ec 01 03 e7 13 67 ; 029BF:  9f 34 ec 01 03 e7 13 67

            sta $ad4a                   ; 029C7:  8d 4a ad
            eor ($0f,x)                 ; 029CA:  41 0f
            ldx $fd                     ; 029CC:  a6 fd
            bpl tab_b0_a9d3+78          ; 029CE:  10 51
            jmp $c700                   ; 029D0:  4c 00 c7

tab_b0_a9d3: ; 501 bytes
            hex 12 c6 42 03 92 02 42 29 ; 029D3:  12 c6 42 03 92 02 42 29
            hex 12 63 12 62 42 69 14 a5 ; 029DB:  12 63 12 62 42 69 14 a5
            hex 12 a4 42 e2 14 e1 44 f8 ; 029E3:  12 a4 42 e2 14 e1 44 f8
            hex 16 37 c1 8f 38 02 bb 28 ; 029EB:  16 37 c1 8f 38 02 bb 28
            hex 7a 68 7a a8 7a e0 6a f0 ; 029F3:  7a 68 7a a8 7a e0 6a f0
            hex 6a 6d c5 fd 92 31 0f 20 ; 029FB:  6a 6d c5 fd 92 31 0f 20
            hex 6e 40 0d 02 37 73 ec 00 ; 02A03:  6e 40 0d 02 37 73 ec 00
            hex 0c 80 3c 00 6c 00 9c 00 ; 02A0B:  0c 80 3c 00 6c 00 9c 00
            hex 06 c0 c7 73 06 83 28 72 ; 02A13:  06 c0 c7 73 06 83 28 72
            hex 96 40 e7 73 26 c0 87 7b ; 02A1B:  96 40 e7 73 26 c0 87 7b
            hex d2 41 39 f1 c8 f2 97 e3 ; 02A23:  d2 41 39 f1 c8 f2 97 e3
            hex a3 23 e7 02 e3 07 f3 22 ; 02A2B:  a3 23 e7 02 e3 07 f3 22
            hex 37 e3 9c 00 bc 00 ec 00 ; 02A33:  37 e3 9c 00 bc 00 ec 00
            hex 0c 80 3c 00 86 21 a6 06 ; 02A3B:  0c 80 3c 00 86 21 a6 06
            hex b6 24 5c 80 7c 00 9c 00 ; 02A43:  b6 24 5c 80 7c 00 9c 00
            hex 29 e1 dc 05 f6 41 dc 80 ; 02A4B:  29 e1 dc 05 f6 41 dc 80
            hex e8 72 0c 81 27 73 4c 01 ; 02A53:  e8 72 0c 81 27 73 4c 01
            hex 66 74 0d 11 3f 35 b6 41 ; 02A5B:  66 74 0d 11 3f 35 b6 41
            hex 2c 82 36 40 7c 02 86 40 ; 02A63:  2c 82 36 40 7c 02 86 40
            hex f9 61 39 e1 ac 04 c6 41 ; 02A6B:  f9 61 39 e1 ac 04 c6 41
            hex 0c 83 16 41 88 f2 39 f1 ; 02A73:  0c 83 16 41 88 f2 39 f1
            hex 7c 00 89 61 9c 00 a7 63 ; 02A7B:  7c 00 89 61 9c 00 a7 63
            hex bc 00 c5 65 dc 00 e3 67 ; 02A83:  bc 00 c5 65 dc 00 e3 67
            hex f3 67 8d c1 cf 26 fd 55 ; 02A8B:  f3 67 8d c1 cf 26 fd 55
            hex b1 0f 26 cf 33 07 b2 15 ; 02A93:  b1 0f 26 cf 33 07 b2 15
            hex 11 52 42 99 0b ac 02 d3 ; 02A9B:  11 52 42 99 0b ac 02 d3
            hex 24 d6 42 d7 25 23 84 cf ; 02AA3:  24 d6 42 d7 25 23 84 cf
            hex 33 07 e3 19 61 78 7a ef ; 02AAB:  33 07 e3 19 61 78 7a ef
            hex 33 2c 81 46 64 55 65 65 ; 02AB3:  33 2c 81 46 64 55 65 65
            hex 65 ec 74 47 82 53 05 63 ; 02ABB:  65 ec 74 47 82 53 05 63
            hex 21 62 41 96 22 9a 41 cc ; 02AC3:  21 62 41 96 22 9a 41 cc
            hex 03 b9 91 39 f1 63 26 67 ; 02ACB:  03 b9 91 39 f1 63 26 67
            hex 27 d3 06 fc 01 18 e2 d9 ; 02AD3:  27 d3 06 fc 01 18 e2 d9
            hex 07 e9 04 0c 86 37 22 93 ; 02ADB:  07 e9 04 0c 86 37 22 93
            hex 24 87 84 ac 02 c2 41 c3 ; 02AE3:  24 87 84 ac 02 c2 41 c3
            hex 23 d9 71 fc 01 7f b1 9c ; 02AEB:  23 d9 71 fc 01 7f b1 9c
            hex 00 a7 63 b6 64 cc 00 d4 ; 02AF3:  00 a7 63 b6 64 cc 00 d4
            hex 66 e3 67 f3 67 8d c1 cf ; 02AFB:  66 e3 67 f3 67 8d c1 cf
            hex 26 fd 50 b1 0f 26 fc 00 ; 02B03:  26 fd 50 b1 0f 26 fc 00
            hex 1f b3 5c 00 65 65 74 66 ; 02B0B:  1f b3 5c 00 65 65 74 66
            hex 83 67 93 67 dc 73 4c 80 ; 02B13:  83 67 93 67 dc 73 4c 80
            hex b3 20 c9 0b c3 08 d3 2f ; 02B1B:  b3 20 c9 0b c3 08 d3 2f
            hex dc 00 2c 80 4c 00 8c 00 ; 02B23:  dc 00 2c 80 4c 00 8c 00
            hex d3 2e ed 4a fc 00 d7 a1 ; 02B2B:  d3 2e ed 4a fc 00 d7 a1
            hex ec 01 4c 80 59 11 d8 11 ; 02B33:  ec 01 4c 80 59 11 d8 11
            hex da 10 37 a0 47 04 99 11 ; 02B3B:  da 10 37 a0 47 04 99 11
            hex e7 21 3a 90 67 20 76 10 ; 02B43:  e7 21 3a 90 67 20 76 10
            hex 77 60 87 07 d8 12 39 f1 ; 02B4B:  77 60 87 07 d8 12 39 f1
            hex ac 00 e9 71 0c 80 2c 00 ; 02B53:  ac 00 e9 71 0c 80 2c 00
            hex 4c 05 c7 7b 39 f1 ec 00 ; 02B5B:  4c 05 c7 7b 39 f1 ec 00
            hex f9 11 0c 82 6f 34 f8 11 ; 02B63:  f9 11 0c 82 6f 34 f8 11
            hex fa 10 7f b2 ac 00 b6 64 ; 02B6B:  fa 10 7f b2 ac 00 b6 64
            hex cc 01 e3 67 f3 67 8d c1 ; 02B73:  cc 01 e3 67 f3 67 8d c1
            hex cf 26 fd 52 b1 0f 20 6e ; 02B7B:  cf 26 fd 52 b1 0f 20 6e
            hex 45 39 91 b3 04 c3 21 c8 ; 02B83:  45 39 91 b3 04 c3 21 c8
            hex 11 ca 10 49 91 7c 73 e8 ; 02B8B:  11 ca 10 49 91 7c 73 e8
            hex 12 88 91 8a 10 e7 21 05 ; 02B93:  12 88 91 8a 10 e7 21 05
            hex 91 07 30 17 07 27 20 49 ; 02B9B:  91 07 30 17 07 27 20 49
            hex 11 9c 01 c8 72 23 a6 27 ; 02BA3:  11 9c 01 c8 72 23 a6 27
            hex 26 d3 03 d8 7a 89 91 d8 ; 02BAB:  26 d3 03 d8 7a 89 91 d8
            hex 72 39 f1 a9 11 09 f1 63 ; 02BB3:  72 39 f1 a9 11 09 f1 63
            hex 24 67 24 d8 62 28 91 2a ; 02BBB:  24 67 24 d8 62 28 91 2a
            hex 10 56 21 70 04          ; 02BC3:  10 56 21 70 04

            adc tab_b0_8b51+186,y       ; 02BC8:  79 0b 8c
            brk                         ; 02BCB:  00
            hex 94                      ; 02BCC:  94
            and ($9f,x)                 ; 02BCD:  21 9f
            and $2f,x                   ; 02BCF:  35 2f
            clv                         ; 02BD1:  b8
            and $7fc1,x                 ; 02BD2:  3d c1 7f
            rol $fd                     ; 02BD5:  26 fd
            asl $c1                     ; 02BD7:  06 c1
            jmp $f400                   ; 02BD9:  4c 00 f4

tab_b0_abdc: ; 460 bytes
            hex 4f 0d 02 06 20 24 4f 35 ; 02BDC:  4f 0d 02 06 20 24 4f 35
            hex a0 36 20 53 46 d5 20 d6 ; 02BE4:  a0 36 20 53 46 d5 20 d6
            hex 20 34 a1 73 49 74 20 94 ; 02BEC:  20 34 a1 73 49 74 20 94
            hex 20 b4 20 d4 20 f4 20 2e ; 02BF4:  20 b4 20 d4 20 f4 20 2e
            hex 80 59 42 4d c7 fd 96 31 ; 02BFC:  80 59 42 4d c7 fd 96 31
            hex 0f 26 0d 03 1a 60 77 42 ; 02C04:  0f 26 0d 03 1a 60 77 42
            hex c4 00 c8 62 b9 e1 d3 06 ; 02C0C:  c4 00 c8 62 b9 e1 d3 06
            hex d7 07 f9 61 0c 81 4e b1 ; 02C14:  d7 07 f9 61 0c 81 4e b1
            hex 8e b1 bc 01 e4 50 e9 61 ; 02C1C:  8e b1 bc 01 e4 50 e9 61
            hex 0c 81 0d 0a 84 43 98 72 ; 02C24:  0c 81 0d 0a 84 43 98 72
            hex 0d 0c 0f 38 1d c1 5f 26 ; 02C2C:  0d 0c 0f 38 1d c1 5f 26
            hex fd 48 0f 0e 01 5e 02 a7 ; 02C34:  fd 48 0f 0e 01 5e 02 a7
            hex 00 bc 73 1a e0 39 61 58 ; 02C3C:  00 bc 73 1a e0 39 61 58
            hex 62 77 63 97 63 b8 62 d6 ; 02C44:  62 77 63 97 63 b8 62 d6
            hex 07 f8 62 19 e1 75 52 86 ; 02C4C:  07 f8 62 19 e1 75 52 86
            hex 40 87 50 95 52 93 43 a5 ; 02C54:  40 87 50 95 52 93 43 a5
            hex 21 c5 52 d6 40 d7 20 e5 ; 02C5C:  21 c5 52 d6 40 d7 20 e5
            hex 06 e6 51 3e 8d 5e 03 67 ; 02C64:  06 e6 51 3e 8d 5e 03 67
            hex 52 77 52 7e 02 9e 03 a6 ; 02C6C:  52 77 52 7e 02 9e 03 a6
            hex 43 a7 23 de 05 fe 02 1e ; 02C74:  43 a7 23 de 05 fe 02 1e
            hex 83 33 54 46 40 47 21 56 ; 02C7C:  83 33 54 46 40 47 21 56
            hex 04 5e 02 83 54 93 52 96 ; 02C84:  04 5e 02 83 54 93 52 96
            hex 07 97 50 be 03 c7 23 fe ; 02C8C:  07 97 50 be 03 c7 23 fe
            hex 02 0c 82 43 45 45 24 46 ; 02C94:  02 0c 82 43 45 45 24 46
            hex 24 90 08 95 51 78 fa d7 ; 02C9C:  24 90 08 95 51 78 fa d7
            hex 73 39 f1 8c 01 a8 52 b8 ; 02CA4:  73 39 f1 8c 01 a8 52 b8
            hex 52 cc 01 5f b3 97 63 9e ; 02CAC:  52 cc 01 5f b3 97 63 9e
            hex 00 0e 81 16 24 66 04 8e ; 02CB4:  00 0e 81 16 24 66 04 8e
            hex 00 fe 01 08 d2 0e 06 6f ; 02CBC:  00 fe 01 08 d2 0e 06 6f
            hex 47 9e 0f 0e 82 2d 47 28 ; 02CC4:  47 9e 0f 0e 82 2d 47 28
            hex 7a 68 7a a8 7a ae 01 de ; 02CCC:  7a 68 7a a8 7a ae 01 de
            hex 0f 6d c5 fd 48 0f 0e 01 ; 02CD4:  0f 6d c5 fd 48 0f 0e 01
            hex 5e 02 bc 01 fc 01 2c 82 ; 02CDC:  5e 02 bc 01 fc 01 2c 82
            hex 41 52 4e 04 67 25 68 24 ; 02CE4:  41 52 4e 04 67 25 68 24
            hex 69 24 ba 42 c7 04 de 0b ; 02CEC:  69 24 ba 42 c7 04 de 0b
            hex b2 87 fe 02 2c e1 2c 71 ; 02CF4:  b2 87 fe 02 2c e1 2c 71
            hex 67 01 77 00 87 01 8e 00 ; 02CFC:  67 01 77 00 87 01 8e 00
            hex ee 01 f6 02 03 85 05 02 ; 02D04:  ee 01 f6 02 03 85 05 02
            hex 13 21 16 02 27 02 2e 02 ; 02D0C:  13 21 16 02 27 02 2e 02
            hex 88 72 c7 20 d7 07 e4 76 ; 02D14:  88 72 c7 20 d7 07 e4 76
            hex 07 a0 17 06 48 7a 76 20 ; 02D1C:  07 a0 17 06 48 7a 76 20
            hex 98 72 79 e1 88 62 9c 01 ; 02D24:  98 72 79 e1 88 62 9c 01
            hex b7 73 dc 01 f8 62 fe 01 ; 02D2C:  b7 73 dc 01 f8 62 fe 01
            hex 08 e2 0e 00 6e 02 73 20 ; 02D34:  08 e2 0e 00 6e 02 73 20
            hex 77 23 83 04 93 20 ae 00 ; 02D3C:  77 23 83 04 93 20 ae 00
            hex fe 0a 0e 82 39 71 a8 72 ; 02D44:  fe 0a 0e 82 39 71 a8 72
            hex e7 73 0c 81 8f 32 ae 00 ; 02D4C:  e7 73 0c 81 8f 32 ae 00
            hex fe 04 04 d1 17 04 26 49 ; 02D54:  fe 04 04 d1 17 04 26 49
            hex 27 29 df 33 fe 02 44 f6 ; 02D5C:  27 29 df 33 fe 02 44 f6
            hex 7c 01 8e 06 bf 47 ee 0f ; 02D64:  7c 01 8e 06 bf 47 ee 0f
            hex 4d c7 0e 82 68 7a ae 01 ; 02D6C:  4d c7 0e 82 68 7a ae 01
            hex de 0f 6d c5 fd 48 01 0e ; 02D74:  de 0f 6d c5 fd 48 01 0e
            hex 01 00 5a 3e 06 45 46 47 ; 02D7C:  01 00 5a 3e 06 45 46 47
            hex 46 53 44 ae 01 df 4a 4d ; 02D84:  46 53 44 ae 01 df 4a 4d
            hex c7 0e 81 00 5a 2e 04 37 ; 02D8C:  c7 0e 81 00 5a 2e 04 37
            hex 28 3a 48 46 47 c7 07 ce ; 02D94:  28 3a 48 46 47 c7 07 ce
            hex 0f df 4a 4d c7 0e 81 00 ; 02D9C:  0f df 4a 4d c7 0e 81 00
            hex 5a 33 53 43             ; 02DA4:  5a 33 53 43

            eor ($46),y                 ; 02DA8:  51 46
            rti                         ; 02DAA:  40

            hex 47 50 53 04 55 40 56 50 ; 02DAB:  47 50 53 04 55 40 56 50
            hex 62 43 64 40 65 50 71 41 ; 02DB3:  62 43 64 40 65 50 71 41
            hex 73                      ; 02DBB:  73

            eor ($83),y                 ; 02DBC:  51 83
            eor ($94),y                 ; 02DBE:  51 94
            rti                         ; 02DC0:  40

            hex 95 50 a3                ; 02DC1:  95 50 a3

            bvc tab_b0_abdc+399         ; 02DC4:  50 a5
            rti                         ; 02DC6:  40

            hex a6 50 b3                ; 02DC7:  a6 50 b3

            eor ($b6),y                 ; 02DCA:  51 b6
            rti                         ; 02DCC:  40

            hex b7 50 c3 53 df 4a 4d c7 ; 02DCD:  b7 50 c3 53 df 4a 4d c7
            hex 0e 81 00 5a 2e 02 36 47 ; 02DD5:  0e 81 00 5a 2e 02 36 47
            hex 37 52 3a 49 47 25 a7 52 ; 02DDD:  37 52 3a 49 47 25 a7 52
            hex d7 04 df 4a 4d c7 0e 81 ; 02DE5:  d7 04 df 4a 4d c7 0e 81
            hex 00 5a 3e 02 44 51 53 44 ; 02DED:  00 5a 3e 02 44 51 53 44
            hex 54 44 55 24 a1 54 ae 01 ; 02DF5:  54 44 55 24 a1 54 ae 01
            hex b4 21 df 4a e5 07 4d c7 ; 02DFD:  b4 21 df 4a e5 07 4d c7
            hex fd 41 01 b4 34 c8 52 f2 ; 02E05:  fd 41 01 b4 34 c8 52 f2
            hex 51 47 d3 6c 03 65 49 9e ; 02E0D:  51 47 d3 6c 03 65 49 9e
            hex 07 be 01 cc 03 fe 07 0d ; 02E15:  07 be 01 cc 03 fe 07 0d
            hex c9 1e 01 6c 01 62 35 63 ; 02E1D:  c9 1e 01 6c 01 62 35 63
            hex 53 8a 41 ac 01 b3 53 e9 ; 02E25:  53 8a 41 ac 01 b3 53 e9
            hex 51 26 c3 27 33 63 43 64 ; 02E2D:  51 26 c3 27 33 63 43 64
            hex 33                      ; 02E35:  33

            tsx                         ; 02E36:  ba
            rts                         ; 02E37:  60

tab_b0_ae38: ; 181 bytes
            hex c9 61 ce 0b e5 09 ee 0f ; 02E38:  c9 61 ce 0b e5 09 ee 0f
            hex 7d ca 7d 47 fd 41 01 b8 ; 02E40:  7d ca 7d 47 fd 41 01 b8
            hex 52 ea 41 27 b2 b3 42 16 ; 02E48:  52 ea 41 27 b2 b3 42 16
            hex d4 4a 42 a5 51 a7 31 27 ; 02E50:  d4 4a 42 a5 51 a7 31 27
            hex d3 08 e2 16 64 2c 04 38 ; 02E58:  d3 08 e2 16 64 2c 04 38
            hex 42 76 64 88 62 de 07 fe ; 02E60:  42 76 64 88 62 de 07 fe
            hex 01 0d c9 23 32 31 51 98 ; 02E68:  01 0d c9 23 32 31 51 98
            hex 52 0d c9 59 42 63 53 67 ; 02E70:  52 0d c9 59 42 63 53 67
            hex 31 14 c2 36 31 87 53 17 ; 02E78:  31 14 c2 36 31 87 53 17
            hex e3 29 61 30 62 3c 08 42 ; 02E80:  e3 29 61 30 62 3c 08 42
            hex 37 59 40 6a 42 99 40 c9 ; 02E88:  37 59 40 6a 42 99 40 c9
            hex 61 d7 63 39 d1 58 52 c3 ; 02E90:  61 d7 63 39 d1 58 52 c3
            hex 67 d3 31 dc 06 f7 42 fa ; 02E98:  67 d3 31 dc 06 f7 42 fa
            hex 42 23 b1 43 67 c3 34 c7 ; 02EA0:  42 23 b1 43 67 c3 34 c7
            hex 34 d1 51 43 b3 47 33 9a ; 02EA8:  34 d1 51 43 b3 47 33 9a
            hex 30 a9 61 b8 62 be 0b d5 ; 02EB0:  30 a9 61 b8 62 be 0b d5
            hex 09 de 0f 0d ca 7d 47 fd ; 02EB8:  09 de 0f 0d ca 7d 47 fd
            hex 49 0f 1e 01 39 73 5e 07 ; 02EC0:  49 0f 1e 01 39 73 5e 07
            hex ae 0b 1e 82 6e 88 9e 02 ; 02EC8:  ae 0b 1e 82 6e 88 9e 02
            hex 0d 04 2e 0b 45 09 4e 0f ; 02ED0:  0d 04 2e 0b 45 09 4e 0f
            hex ed 47 fd ff ad 72 07 20 ; 02ED8:  ed 47 fd ff ad 72 07 20
            hex 04 8e e4 8f 67 85 71 90 ; 02EE0:  04 8e e4 8f 67 85 71 90
            hex ea ae ae 53 07          ; 02EE8:  ea ae ae 53 07

            lda $06fc,x                 ; 02EED:  bd fc 06
            sta $06fc                   ; 02EF0:  8d fc 06
            jsr tab_b0_b04a             ; 02EF3:  20 4a b0
            lda $0772                   ; 02EF6:  ad 72 07
            cmp #$03                    ; 02EF9:  c9 03
            bcs b0_aefe                 ; 02EFB:  b0 01
            rts                         ; 02EFD:  60

b0_aefe:    jsr b0_b624                 ; 02EFE:  20 24 b6
            ldx #$00                    ; 02F01:  a2 00
b0_af03:    stx $08                     ; 02F03:  86 08
            jsr $c047                   ; 02F05:  20 47 c0
            jsr b0_84c2+1               ; 02F08:  20 c3 84
            inx                         ; 02F0B:  e8
            cpx #$06                    ; 02F0C:  e0 06
            bne b0_af03                 ; 02F0E:  d0 f3
            jsr $f180                   ; 02F10:  20 80 f1
            jsr $f12a                   ; 02F13:  20 2a f1
            jsr $eee9                   ; 02F16:  20 e9 ee
            jsr b0_bed4                 ; 02F19:  20 d4 be
            ldx #$01                    ; 02F1C:  a2 01
            stx $08                     ; 02F1E:  86 08
            jsr b0_be70                 ; 02F20:  20 70 be
            dex                         ; 02F23:  ca
            stx $08                     ; 02F24:  86 08
            jsr b0_be70                 ; 02F26:  20 70 be
            jsr b0_bb96                 ; 02F29:  20 96 bb
            jsr b0_b9bc                 ; 02F2C:  20 bc b9
            jsr b0_b7b8                 ; 02F2F:  20 b8 b7
            jsr b0_b855                 ; 02F32:  20 55 b8
            jsr tab_b0_b74b+4           ; 02F35:  20 4f b7
            jsr tab_b0_89c3+30          ; 02F38:  20 e1 89
            lda $b5                     ; 02F3B:  a5 b5
            cmp #$02                    ; 02F3D:  c9 02
            bpl b0_af52                 ; 02F3F:  10 11
            lda $079f                   ; 02F41:  ad 9f 07
            beq b0_af64                 ; 02F44:  f0 1e
            cmp #$04                    ; 02F46:  c9 04
            bne b0_af52                 ; 02F48:  d0 08
            lda $077f                   ; 02F4A:  ad 7f 07
            bne b0_af52                 ; 02F4D:  d0 03
            jsr b0_90ed                 ; 02F4F:  20 ed 90
b0_af52:    ldy $079f                   ; 02F52:  ac 9f 07
            lda $09                     ; 02F55:  a5 09
            cpy #$08                    ; 02F57:  c0 08
            bcs b0_af5d                 ; 02F59:  b0 02
            lsr a                       ; 02F5B:  4a
            lsr a                       ; 02F5C:  4a
b0_af5d:    lsr a                       ; 02F5D:  4a
            jsr b0_b288                 ; 02F5E:  20 88 b2
            jmp b0_af67                 ; 02F61:  4c 67 af

b0_af64:    jsr b0_b29a                 ; 02F64:  20 9a b2
b0_af67:    lda $0a                     ; 02F67:  a5 0a
            sta $0d                     ; 02F69:  85 0d
            lda #$00                    ; 02F6B:  a9 00
            sta $0c                     ; 02F6D:  85 0c
b0_af6f:    lda $0773                   ; 02F6F:  ad 73 07
            cmp #$06                    ; 02F72:  c9 06
            beq b0_af92                 ; 02F74:  f0 1c
            lda $071f                   ; 02F76:  ad 1f 07
            bne b0_af8f                 ; 02F79:  d0 14
            lda $073d                   ; 02F7B:  ad 3d 07
            cmp #$20                    ; 02F7E:  c9 20
            bmi b0_af92                 ; 02F80:  30 10
            lda $073d                   ; 02F82:  ad 3d 07
            sbc #$20                    ; 02F85:  e9 20
            sta $073d                   ; 02F87:  8d 3d 07
            lda #$00                    ; 02F8A:  a9 00
            sta $0340                   ; 02F8C:  8d 40 03
b0_af8f:    jsr b0_92b0                 ; 02F8F:  20 b0 92
b0_af92:    rts                         ; 02F92:  60

b0_af93:    lda $06ff                   ; 02F93:  ad ff 06
            clc                         ; 02F96:  18
            adc $03a1                   ; 02F97:  6d a1 03
            sta $06ff                   ; 02F9A:  8d ff 06
            lda $0723                   ; 02F9D:  ad 23 07
            bne b0_affb                 ; 02FA0:  d0 59
            lda $0755                   ; 02FA2:  ad 55 07
            cmp #$50                    ; 02FA5:  c9 50
            bcc b0_affb                 ; 02FA7:  90 52
            lda $0785                   ; 02FA9:  ad 85 07
            bne b0_affb                 ; 02FAC:  d0 4d
            ldy $06ff                   ; 02FAE:  ac ff 06
            dey                         ; 02FB1:  88
            bmi b0_affb                 ; 02FB2:  30 47
            iny                         ; 02FB4:  c8
            cpy #$02                    ; 02FB5:  c0 02
            bcc b0_afba                 ; 02FB7:  90 01
            dey                         ; 02FB9:  88
b0_afba:    lda $0755                   ; 02FBA:  ad 55 07
            cmp #$70                    ; 02FBD:  c9 70
            bcc b0_afc4                 ; 02FBF:  90 03
            ldy $06ff                   ; 02FC1:  ac ff 06
b0_afc4:    tya                         ; 02FC4:  98
            sta $0775                   ; 02FC5:  8d 75 07
            clc                         ; 02FC8:  18
            adc $073d                   ; 02FC9:  6d 3d 07
            sta $073d                   ; 02FCC:  8d 3d 07
            tya                         ; 02FCF:  98
            clc                         ; 02FD0:  18
            adc $071c                   ; 02FD1:  6d 1c 07
            sta $071c                   ; 02FD4:  8d 1c 07
            sta $073f                   ; 02FD7:  8d 3f 07
            lda $071a                   ; 02FDA:  ad 1a 07
            adc #$00                    ; 02FDD:  69 00
            sta $071a                   ; 02FDF:  8d 1a 07
            and #$01                    ; 02FE2:  29 01
            sta $00                     ; 02FE4:  85 00
            lda $0778                   ; 02FE6:  ad 78 07
            and #$fe                    ; 02FE9:  29 fe
            ora $00                     ; 02FEB:  05 00
            sta $0778                   ; 02FED:  8d 78 07
            jsr b0_b038                 ; 02FF0:  20 38 b0
            lda #$08                    ; 02FF3:  a9 08
            sta $0795                   ; 02FF5:  8d 95 07
            jmp b0_b000                 ; 02FF8:  4c 00 b0

b0_affb:    lda #$00                    ; 02FFB:  a9 00
            sta $0775                   ; 02FFD:  8d 75 07
b0_b000:    ldx #$00                    ; 03000:  a2 00
            jsr $f1f6                   ; 03002:  20 f6 f1
            sta $00                     ; 03005:  85 00
            ldy #$00                    ; 03007:  a0 00
            asl a                       ; 03009:  0a
            bcs b0_b013                 ; 0300A:  b0 07
            iny                         ; 0300C:  c8
            lda $00                     ; 0300D:  a5 00
            and #$20                    ; 0300F:  29 20
            beq b0_b02e                 ; 03011:  f0 1b
b0_b013:    lda $071c,y                 ; 03013:  b9 1c 07
            sec                         ; 03016:  38
            sbc b0_b034,y               ; 03017:  f9 34 b0
            sta $86                     ; 0301A:  85 86
            lda $071a,y                 ; 0301C:  b9 1a 07
            sbc #$00                    ; 0301F:  e9 00
            sta $6d                     ; 03021:  85 6d
            lda $0c                     ; 03023:  a5 0c
            cmp b0_b036,y               ; 03025:  d9 36 b0
            beq b0_b02e                 ; 03028:  f0 04
            lda #$00                    ; 0302A:  a9 00
            sta $57                     ; 0302C:  85 57
b0_b02e:    lda #$00                    ; 0302E:  a9 00
            sta $03a1                   ; 03030:  8d a1 03
            rts                         ; 03033:  60

b0_b034:    brk                         ; 03034:  00
            hex 10                      ; 03035:  10
b0_b036:    ora ($02,x)                 ; 03036:  01 02
b0_b038:    lda $071c                   ; 03038:  ad 1c 07
            clc                         ; 0303B:  18
            adc #$ff                    ; 0303C:  69 ff
            sta $071d                   ; 0303E:  8d 1d 07
            lda $071a                   ; 03041:  ad 1a 07
            adc #$00                    ; 03044:  69 00
            sta $071b                   ; 03046:  8d 1b 07
            rts                         ; 03049:  60

tab_b0_b04a: ; 34 bytes
            hex a5 0e 20 04 8e 31 91 c7 ; 0304A:  a5 0e 20 04 8e 31 91 c7
            hex b1 06 b2 e5 b1 a4 b2 ca ; 03052:  b1 06 b2 e5 b1 a4 b2 ca
            hex b2 cd 91 69 b0 e9 b0 33 ; 0305A:  b2 cd 91 69 b0 e9 b0 33
            hex b2 45 b2 69 b2 7d b2 ad ; 03062:  b2 45 b2 69 b2 7d b2 ad
            hex 52 07                   ; 0306A:  52 07

            cmp #$02                    ; 0306C:  c9 02
            beq b0_b09b                 ; 0306E:  f0 2b
            lda #$00                    ; 03070:  a9 00
            ldy $ce                     ; 03072:  a4 ce
            cpy #$30                    ; 03074:  c0 30
            bcc b0_b0e6                 ; 03076:  90 6e
            lda $0710                   ; 03078:  ad 10 07
            cmp #$06                    ; 0307B:  c9 06
            beq b0_b083                 ; 0307D:  f0 04
            cmp #$07                    ; 0307F:  c9 07
            bne b0_b0d3                 ; 03081:  d0 50
b0_b083:    lda $03c4                   ; 03083:  ad c4 03
            bne b0_b08d                 ; 03086:  d0 05
            lda #$01                    ; 03088:  a9 01
            jmp b0_b0e6                 ; 0308A:  4c e6 b0

b0_b08d:    jsr b0_b21f                 ; 0308D:  20 1f b2
            dec $06de                   ; 03090:  ce de 06
            bne b0_b0e5                 ; 03093:  d0 50
            inc $0769                   ; 03095:  ee 69 07
            jmp b0_b315                 ; 03098:  4c 15 b3

b0_b09b:    lda $0758                   ; 0309B:  ad 58 07
            bne b0_b0ac                 ; 0309E:  d0 0c
            lda #$ff                    ; 030A0:  a9 ff
            jsr b0_b200                 ; 030A2:  20 00 b2
            lda $ce                     ; 030A5:  a5 ce
            cmp #$91                    ; 030A7:  c9 91
            bcc b0_b0d3                 ; 030A9:  90 28
            rts                         ; 030AB:  60

b0_b0ac:    lda $0399                   ; 030AC:  ad 99 03
            cmp #$60                    ; 030AF:  c9 60
            bne b0_b0e5                 ; 030B1:  d0 32
            lda $ce                     ; 030B3:  a5 ce
            cmp #$99                    ; 030B5:  c9 99
            ldy #$00                    ; 030B7:  a0 00
            lda #$01                    ; 030B9:  a9 01
            bcc b0_b0c7                 ; 030BB:  90 0a
            lda #$03                    ; 030BD:  a9 03
            sta $1d                     ; 030BF:  85 1d
            iny                         ; 030C1:  c8
            lda #$08                    ; 030C2:  a9 08
            sta $05b4                   ; 030C4:  8d b4 05
b0_b0c7:    sty $0716                   ; 030C7:  8c 16 07
            jsr b0_b0e6                 ; 030CA:  20 e6 b0
            lda $86                     ; 030CD:  a5 86
            cmp #$48                    ; 030CF:  c9 48
            bcc b0_b0e5                 ; 030D1:  90 12
b0_b0d3:    lda #$08                    ; 030D3:  a9 08
            sta $0e                     ; 030D5:  85 0e
            lda #$01                    ; 030D7:  a9 01
            sta $33                     ; 030D9:  85 33
            lsr a                       ; 030DB:  4a
            sta $0752                   ; 030DC:  8d 52 07
            sta $0716                   ; 030DF:  8d 16 07
            sta $0758                   ; 030E2:  8d 58 07
b0_b0e5:    rts                         ; 030E5:  60

b0_b0e6:    sta $06fc                   ; 030E6:  8d fc 06
b0_b0e9:    lda $0e                     ; 030E9:  a5 0e
            cmp #$0b                    ; 030EB:  c9 0b
            beq b0_b12b                 ; 030ED:  f0 3c
            lda $074e                   ; 030EF:  ad 4e 07
            bne b0_b104                 ; 030F2:  d0 10
            ldy $b5                     ; 030F4:  a4 b5
            dey                         ; 030F6:  88
            bne b0_b0ff                 ; 030F7:  d0 06
            lda $ce                     ; 030F9:  a5 ce
            cmp #$d0                    ; 030FB:  c9 d0
            bcc b0_b104                 ; 030FD:  90 05
b0_b0ff:    lda #$00                    ; 030FF:  a9 00
            sta $06fc                   ; 03101:  8d fc 06
b0_b104:    lda $06fc                   ; 03104:  ad fc 06
            and #$c0                    ; 03107:  29 c0
            sta $0a                     ; 03109:  85 0a
            lda $06fc                   ; 0310B:  ad fc 06
            and #$03                    ; 0310E:  29 03
            sta $0c                     ; 03110:  85 0c
            lda $06fc                   ; 03112:  ad fc 06
            and #$0c                    ; 03115:  29 0c
            sta $0b                     ; 03117:  85 0b
            and #$04                    ; 03119:  29 04
            beq b0_b12b                 ; 0311B:  f0 0e
            lda $1d                     ; 0311D:  a5 1d
            bne b0_b12b                 ; 0311F:  d0 0a
            ldy $0c                     ; 03121:  a4 0c
            beq b0_b12b                 ; 03123:  f0 06
            lda #$00                    ; 03125:  a9 00
            sta $0c                     ; 03127:  85 0c
            sta $0b                     ; 03129:  85 0b
b0_b12b:    jsr tab_b0_b329             ; 0312B:  20 29 b3
            ldy #$01                    ; 0312E:  a0 01
            lda $0754                   ; 03130:  ad 54 07
            bne b0_b13e                 ; 03133:  d0 09
            ldy #$00                    ; 03135:  a0 00
            lda $0714                   ; 03137:  ad 14 07
            beq b0_b13e                 ; 0313A:  f0 02
            ldy #$02                    ; 0313C:  a0 02
b0_b13e:    sty $0499                   ; 0313E:  8c 99 04
            lda #$01                    ; 03141:  a9 01
            ldy $57                     ; 03143:  a4 57
            beq b0_b14c                 ; 03145:  f0 05
            bpl b0_b14a                 ; 03147:  10 01
            asl a                       ; 03149:  0a
b0_b14a:    sta $45                     ; 0314A:  85 45
b0_b14c:    jsr b0_af93                 ; 0314C:  20 93 af
            jsr $f180                   ; 0314F:  20 80 f1
            jsr $f12a                   ; 03152:  20 2a f1
            ldx #$00                    ; 03155:  a2 00
            jsr $e29c                   ; 03157:  20 9c e2
            jsr $dc64                   ; 0315A:  20 64 dc
            lda $ce                     ; 0315D:  a5 ce
            cmp #$40                    ; 0315F:  c9 40
            bcc b0_b179                 ; 03161:  90 16
            lda $0e                     ; 03163:  a5 0e
            cmp #$05                    ; 03165:  c9 05
            beq b0_b179                 ; 03167:  f0 10
            cmp #$07                    ; 03169:  c9 07
            beq b0_b179                 ; 0316B:  f0 0c
            cmp #$04                    ; 0316D:  c9 04
            bcc b0_b179                 ; 0316F:  90 08
            lda $03c4                   ; 03171:  ad c4 03
            and #$df                    ; 03174:  29 df
            sta $03c4                   ; 03176:  8d c4 03
b0_b179:    lda $b5                     ; 03179:  a5 b5
            cmp #$02                    ; 0317B:  c9 02
            bmi b0_b1ba                 ; 0317D:  30 3b
            ldx #$01                    ; 0317F:  a2 01
            stx $0723                   ; 03181:  8e 23 07
            ldy #$04                    ; 03184:  a0 04
            sty $07                     ; 03186:  84 07
            ldx #$00                    ; 03188:  a2 00
            ldy $0759                   ; 0318A:  ac 59 07
            bne b0_b194                 ; 0318D:  d0 05
            ldy $0743                   ; 0318F:  ac 43 07
            bne b0_b1aa                 ; 03192:  d0 16
b0_b194:    inx                         ; 03194:  e8
            ldy $0e                     ; 03195:  a4 0e
            cpy #$0b                    ; 03197:  c0 0b
            beq b0_b1aa                 ; 03199:  f0 0f
            ldy $0712                   ; 0319B:  ac 12 07
            bne b0_b1a6                 ; 0319E:  d0 06
            iny                         ; 031A0:  c8
            sty $fc                     ; 031A1:  84 fc
            sty $0712                   ; 031A3:  8c 12 07
b0_b1a6:    ldy #$06                    ; 031A6:  a0 06
            sty $07                     ; 031A8:  84 07
b0_b1aa:    cmp $07                     ; 031AA:  c5 07
            bmi b0_b1ba                 ; 031AC:  30 0c
            dex                         ; 031AE:  ca
            bmi b0_b1bb                 ; 031AF:  30 0a
            ldy $07b1                   ; 031B1:  ac b1 07
            bne b0_b1ba                 ; 031B4:  d0 04
            lda #$06                    ; 031B6:  a9 06
            sta $0e                     ; 031B8:  85 0e
b0_b1ba:    rts                         ; 031BA:  60

b0_b1bb:    lda #$00                    ; 031BB:  a9 00
            sta $0758                   ; 031BD:  8d 58 07
            jsr b0_b1dd                 ; 031C0:  20 dd b1
            inc $0752                   ; 031C3:  ee 52 07
            rts                         ; 031C6:  60

            lda $b5                     ; 031C7:  a5 b5
            bne b0_b1d1                 ; 031C9:  d0 06
            lda $ce                     ; 031CB:  a5 ce
            cmp #$e4                    ; 031CD:  c9 e4
            bcc b0_b1dd                 ; 031CF:  90 0c
b0_b1d1:    lda #$08                    ; 031D1:  a9 08
            sta $0758                   ; 031D3:  8d 58 07
            ldy #$03                    ; 031D6:  a0 03
            sty $1d                     ; 031D8:  84 1d
            jmp b0_b0e6                 ; 031DA:  4c e6 b0

b0_b1dd:    lda #$02                    ; 031DD:  a9 02
            sta $0752                   ; 031DF:  8d 52 07
            jmp b0_b213                 ; 031E2:  4c 13 b2

            lda #$01                    ; 031E5:  a9 01
            jsr b0_b200                 ; 031E7:  20 00 b2
            jsr b0_af93                 ; 031EA:  20 93 af
            ldy #$00                    ; 031ED:  a0 00
            lda $06d6                   ; 031EF:  ad d6 06
            bne b0_b20b                 ; 031F2:  d0 17
            iny                         ; 031F4:  c8
            lda $074e                   ; 031F5:  ad 4e 07
            cmp #$03                    ; 031F8:  c9 03
            bne b0_b20b                 ; 031FA:  d0 0f
            iny                         ; 031FC:  c8
            jmp b0_b20b                 ; 031FD:  4c 0b b2

b0_b200:    clc                         ; 03200:  18
            adc $ce                     ; 03201:  65 ce
            sta $ce                     ; 03203:  85 ce
            rts                         ; 03205:  60

            jsr b0_b21f                 ; 03206:  20 1f b2
            ldy #$02                    ; 03209:  a0 02
b0_b20b:    dec $06de                   ; 0320B:  ce de 06
            bne b0_b21e                 ; 0320E:  d0 0e
            sty $0752                   ; 03210:  8c 52 07
b0_b213:    inc $0774                   ; 03213:  ee 74 07
            lda #$00                    ; 03216:  a9 00
            sta $0772                   ; 03218:  8d 72 07
            sta $0722                   ; 0321B:  8d 22 07
b0_b21e:    rts                         ; 0321E:  60

b0_b21f:    lda #$08                    ; 0321F:  a9 08
            sta $57                     ; 03221:  85 57
            ldy #$01                    ; 03223:  a0 01
            lda $86                     ; 03225:  a5 86
            and #$0f                    ; 03227:  29 0f
            bne b0_b22e                 ; 03229:  d0 03
            sta $57                     ; 0322B:  85 57
            tay                         ; 0322D:  a8
b0_b22e:    tya                         ; 0322E:  98
            jsr b0_b0e6                 ; 0322F:  20 e6 b0
            rts                         ; 03232:  60

            lda $0747                   ; 03233:  ad 47 07
            cmp #$f8                    ; 03236:  c9 f8
            bne b0_b23d                 ; 03238:  d0 03
            jmp b0_b255                 ; 0323A:  4c 55 b2

b0_b23d:    cmp #$c4                    ; 0323D:  c9 c4
            bne b0_b244                 ; 0323F:  d0 03
            jsr b0_b273                 ; 03241:  20 73 b2
b0_b244:    rts                         ; 03244:  60

            lda $0747                   ; 03245:  ad 47 07
            cmp #$f0                    ; 03248:  c9 f0
            bcs b0_b253                 ; 0324A:  b0 07
            cmp #$c8                    ; 0324C:  c9 c8
            beq b0_b273                 ; 0324E:  f0 23
            jmp b0_b0e9                 ; 03250:  4c e9 b0

b0_b253:    bne b0_b268                 ; 03253:  d0 13
b0_b255:    ldy $070b                   ; 03255:  ac 0b 07
            bne b0_b268                 ; 03258:  d0 0e
            sty $070d                   ; 0325A:  8c 0d 07
            inc $070b                   ; 0325D:  ee 0b 07
            lda $0754                   ; 03260:  ad 54 07
            eor #$01                    ; 03263:  49 01
            sta $0754                   ; 03265:  8d 54 07
b0_b268:    rts                         ; 03268:  60

            lda $0747                   ; 03269:  ad 47 07
            cmp #$f0                    ; 0326C:  c9 f0
            bcs tab_b0_b2a3             ; 0326E:  b0 33
            jmp b0_b0e9                 ; 03270:  4c e9 b0

b0_b273:    lda #$00                    ; 03273:  a9 00
            sta $0747                   ; 03275:  8d 47 07
            lda #$08                    ; 03278:  a9 08
            sta $0e                     ; 0327A:  85 0e
            rts                         ; 0327C:  60

            lda $0747                   ; 0327D:  ad 47 07
            cmp #$c0                    ; 03280:  c9 c0
            beq b0_b297                 ; 03282:  f0 13
            lda $09                     ; 03284:  a5 09
            lsr a                       ; 03286:  4a
            lsr a                       ; 03287:  4a
b0_b288:    and #$03                    ; 03288:  29 03
            sta $00                     ; 0328A:  85 00
            lda $03c4                   ; 0328C:  ad c4 03
            and #$fc                    ; 0328F:  29 fc
            ora $00                     ; 03291:  05 00
            sta $03c4                   ; 03293:  8d c4 03
            rts                         ; 03296:  60

b0_b297:    jsr b0_b273                 ; 03297:  20 73 b2
b0_b29a:    lda $03c4                   ; 0329A:  ad c4 03
            and #$fc                    ; 0329D:  29 fc
            sta $03c4                   ; 0329F:  8d c4 03
            rts                         ; 032A2:  60

tab_b0_b2a3: ; 1 bytes
            hex 60                      ; 032A3:  60

            lda $1b                     ; 032A4:  a5 1b
            cmp #$30                    ; 032A6:  c9 30
            bne b0_b2bf                 ; 032A8:  d0 15
            lda $0713                   ; 032AA:  ad 13 07
            sta $ff                     ; 032AD:  85 ff
            lda #$00                    ; 032AF:  a9 00
            sta $0713                   ; 032B1:  8d 13 07
            ldy $ce                     ; 032B4:  a4 ce
            cpy #$9e                    ; 032B6:  c0 9e
            bcs b0_b2bc                 ; 032B8:  b0 02
            lda #$04                    ; 032BA:  a9 04
b0_b2bc:    jmp b0_b0e6                 ; 032BC:  4c e6 b0

b0_b2bf:    inc $0e                     ; 032BF:  e6 0e
            rts                         ; 032C1:  60

tab_b0_b2c2: ; 8 bytes
            hex 15 23 16 1b 17 18 23 63 ; 032C2:  15 23 16 1b 17 18 23 63

            lda #$01                    ; 032CA:  a9 01
            jsr b0_b0e6                 ; 032CC:  20 e6 b0
            lda $ce                     ; 032CF:  a5 ce
            cmp #$ae                    ; 032D1:  c9 ae
            bcc b0_b2e3                 ; 032D3:  90 0e
            lda $0723                   ; 032D5:  ad 23 07
            beq b0_b2e3                 ; 032D8:  f0 09
            lda #$20                    ; 032DA:  a9 20
            sta $fc                     ; 032DC:  85 fc
            lda #$00                    ; 032DE:  a9 00
            sta $0723                   ; 032E0:  8d 23 07
b0_b2e3:    lda $0490                   ; 032E3:  ad 90 04
            lsr a                       ; 032E6:  4a
            bcs b0_b2f6                 ; 032E7:  b0 0d
            lda $0746                   ; 032E9:  ad 46 07
            bne b0_b2f1                 ; 032EC:  d0 03
            inc $0746                   ; 032EE:  ee 46 07
b0_b2f1:    lda #$20                    ; 032F1:  a9 20
            sta $03c4                   ; 032F3:  8d c4 03
b0_b2f6:    lda $0746                   ; 032F6:  ad 46 07
            cmp #$05                    ; 032F9:  c9 05
            bne b0_b328                 ; 032FB:  d0 2b
            inc $075c                   ; 032FD:  ee 5c 07
            lda $075c                   ; 03300:  ad 5c 07
            cmp #$03                    ; 03303:  c9 03
            bne b0_b315                 ; 03305:  d0 0e
            ldy $075f                   ; 03307:  ac 5f 07
            lda $0748                   ; 0330A:  ad 48 07
            cmp tab_b0_b2c2,y           ; 0330D:  d9 c2 b2
            bcc b0_b315                 ; 03310:  90 03
            inc $075d                   ; 03312:  ee 5d 07
b0_b315:    inc $0760                   ; 03315:  ee 60 07
            jsr b0_9c03                 ; 03318:  20 03 9c
            inc $0757                   ; 0331B:  ee 57 07
            jsr b0_b213                 ; 0331E:  20 13 b2
            sta $075b                   ; 03321:  8d 5b 07
            lda #$80                    ; 03324:  a9 80
            sta $fc                     ; 03326:  85 fc
b0_b328:    rts                         ; 03328:  60

tab_b0_b329: ; 49 bytes
            hex a9 00 ac 54 07 d0 08 a5 ; 03329:  a9 00 ac 54 07 d0 08 a5
            hex 1d d0 07 a5 0b 29 04 8d ; 03331:  1d d0 07 a5 0b 29 04 8d
            hex 14 07 20 50 b4 ad 0b 07 ; 03339:  14 07 20 50 b4 ad 0b 07
            hex d0 16 a5 1d c9 03 f0 05 ; 03341:  d0 16 a5 1d c9 03 f0 05
            hex a0 18 8c 89 07 20 04 8e ; 03349:  a0 18 8c 89 07 20 04 8e
            hex 5a b3 76 b3 6d b3 cf b3 ; 03351:  5a b3 76 b3 6d b3 cf b3
            hex 60                      ; 03359:  60

            jsr b0_b58f                 ; 0335A:  20 8f b5
            lda $0c                     ; 0335D:  a5 0c
            beq b0_b363                 ; 0335F:  f0 02
            sta $33                     ; 03361:  85 33
b0_b363:    jsr b0_b5cc                 ; 03363:  20 cc b5
            jsr b0_bf09                 ; 03366:  20 09 bf
            sta $06ff                   ; 03369:  8d ff 06
            rts                         ; 0336C:  60

            lda $070a                   ; 0336D:  ad 0a 07
            sta $0709                   ; 03370:  8d 09 07
            jmp b0_b3ac                 ; 03373:  4c ac b3

            ldy $9f                     ; 03376:  a4 9f
            bpl b0_b38d                 ; 03378:  10 13
            lda $0a                     ; 0337A:  a5 0a
            and #$80                    ; 0337C:  29 80
            and $0d                     ; 0337E:  25 0d
            bne b0_b393                 ; 03380:  d0 11
            lda $0708                   ; 03382:  ad 08 07
            sec                         ; 03385:  38
            sbc $ce                     ; 03386:  e5 ce
            cmp $0706                   ; 03388:  cd 06 07
            bcc b0_b393                 ; 0338B:  90 06
b0_b38d:    lda $070a                   ; 0338D:  ad 0a 07
            sta $0709                   ; 03390:  8d 09 07
b0_b393:    lda $0704                   ; 03393:  ad 04 07
            beq b0_b3ac                 ; 03396:  f0 14
            jsr b0_b58f                 ; 03398:  20 8f b5
            lda $ce                     ; 0339B:  a5 ce
            cmp #$14                    ; 0339D:  c9 14
            bcs b0_b3a6                 ; 0339F:  b0 05
            lda #$18                    ; 033A1:  a9 18
            sta $0709                   ; 033A3:  8d 09 07
b0_b3a6:    lda $0c                     ; 033A6:  a5 0c
            beq b0_b3ac                 ; 033A8:  f0 02
            sta $33                     ; 033AA:  85 33
b0_b3ac:    lda $0c                     ; 033AC:  a5 0c
            beq b0_b3b3                 ; 033AE:  f0 03
            jsr b0_b5cc                 ; 033B0:  20 cc b5
b0_b3b3:    jsr b0_bf09                 ; 033B3:  20 09 bf
            sta $06ff                   ; 033B6:  8d ff 06
            lda $0e                     ; 033B9:  a5 0e
            cmp #$0b                    ; 033BB:  c9 0b
            bne b0_b3c4                 ; 033BD:  d0 05
            lda #$28                    ; 033BF:  a9 28
            sta $0709                   ; 033C1:  8d 09 07
b0_b3c4:    jmp b0_bf4d                 ; 033C4:  4c 4d bf

tab_b0_b3c7: ; 8 bytes
            hex 0e 04 fc f2 00 00 ff ff ; 033C7:  0e 04 fc f2 00 00 ff ff

            lda $0416                   ; 033CF:  ad 16 04
            clc                         ; 033D2:  18
            adc $0433                   ; 033D3:  6d 33 04
            sta $0416                   ; 033D6:  8d 16 04
            ldy #$00                    ; 033D9:  a0 00
            lda $9f                     ; 033DB:  a5 9f
            bpl b0_b3e0                 ; 033DD:  10 01
            dey                         ; 033DF:  88
b0_b3e0:    sty $00                     ; 033E0:  84 00
            adc $ce                     ; 033E2:  65 ce
            sta $ce                     ; 033E4:  85 ce
            lda $b5                     ; 033E6:  a5 b5
            adc $00                     ; 033E8:  65 00
            sta $b5                     ; 033EA:  85 b5
            lda $0c                     ; 033EC:  a5 0c
            and $0490                   ; 033EE:  2d 90 04
            beq b0_b420                 ; 033F1:  f0 2d
            ldy $0789                   ; 033F3:  ac 89 07
            bne b0_b41f                 ; 033F6:  d0 27
            ldy #$18                    ; 033F8:  a0 18
            sty $0789                   ; 033FA:  8c 89 07
            ldx #$00                    ; 033FD:  a2 00
            ldy $33                     ; 033FF:  a4 33
            lsr a                       ; 03401:  4a
            bcs b0_b406                 ; 03402:  b0 02
            inx                         ; 03404:  e8
            inx                         ; 03405:  e8
b0_b406:    dey                         ; 03406:  88
            beq b0_b40a                 ; 03407:  f0 01
            inx                         ; 03409:  e8
b0_b40a:    lda $86                     ; 0340A:  a5 86
            clc                         ; 0340C:  18
            adc tab_b0_b3c7,x           ; 0340D:  7d c7 b3
            sta $86                     ; 03410:  85 86
            lda $6d                     ; 03412:  a5 6d
            adc tab_b0_b3c7+4,x         ; 03414:  7d cb b3
            sta $6d                     ; 03417:  85 6d
            lda $0c                     ; 03419:  a5 0c
            eor #$03                    ; 0341B:  49 03
            sta $33                     ; 0341D:  85 33
b0_b41f:    rts                         ; 0341F:  60

b0_b420:    sta $0789                   ; 03420:  8d 89 07
            rts                         ; 03423:  60

tab_b0_b424: ; 40 bytes
            hex 20 20 1e 28 28 0d 04 70 ; 03424:  20 20 1e 28 28 0d 04 70
            hex 70 60 90 90 0a 09 fc fc ; 0342C:  70 60 90 90 0a 09 fc fc
            hex fc fb fb fe ff 00 00 00 ; 03434:  fc fb fb fe ff 00 00 00
            hex 00 00 80 00 d8 e8 f0 28 ; 0343C:  00 00 80 00 d8 e8 f0 28
            hex 18 10 0c e4 98 d0 00 ff ; 03444:  18 10 0c e4 98 d0 00 ff

b0_b44c:    ora ($00,x)                 ; 0344C:  01 00
            jsr tab_b0_a547+184         ; 0344E:  20 ff a5
            ora $03c9,x                 ; 03451:  1d c9 03
            bne b0_b479                 ; 03454:  d0 23
            ldy #$00                    ; 03456:  a0 00
            lda $0b                     ; 03458:  a5 0b
            and $0490                   ; 0345A:  2d 90 04
            beq b0_b465                 ; 0345D:  f0 06
            iny                         ; 0345F:  c8
            and #$08                    ; 03460:  29 08
            bne b0_b465                 ; 03462:  d0 01
            iny                         ; 03464:  c8
b0_b465:    ldx b0_b44c+1,y             ; 03465:  be 4d b4
            stx $0433                   ; 03468:  8e 33 04
            lda #$08                    ; 0346B:  a9 08
            ldx tab_b0_b424+38,y        ; 0346D:  be 4a b4
            stx $9f                     ; 03470:  86 9f
            bmi b0_b475                 ; 03472:  30 01
            lsr a                       ; 03474:  4a
b0_b475:    sta $070c                   ; 03475:  8d 0c 07
            rts                         ; 03478:  60

b0_b479:    lda $070e                   ; 03479:  ad 0e 07
            bne b0_b488                 ; 0347C:  d0 0a
            lda $0a                     ; 0347E:  a5 0a
            and #$80                    ; 03480:  29 80
            beq b0_b488                 ; 03482:  f0 04
            and $0d                     ; 03484:  25 0d
            beq b0_b48b                 ; 03486:  f0 03
b0_b488:    jmp b0_b51c                 ; 03488:  4c 1c b5

b0_b48b:    lda $1d                     ; 0348B:  a5 1d
            beq b0_b4a0                 ; 0348D:  f0 11
            lda $0704                   ; 0348F:  ad 04 07
            beq b0_b488                 ; 03492:  f0 f4
            lda $0782                   ; 03494:  ad 82 07
            bne b0_b4a0                 ; 03497:  d0 07
            lda $9f                     ; 03499:  a5 9f
            bpl b0_b4a0                 ; 0349B:  10 03
            jmp b0_b51c                 ; 0349D:  4c 1c b5

b0_b4a0:    lda #$20                    ; 034A0:  a9 20
            sta $0782                   ; 034A2:  8d 82 07
            ldy #$00                    ; 034A5:  a0 00
            sty $0416                   ; 034A7:  8c 16 04
            sty $0433                   ; 034AA:  8c 33 04
            lda $b5                     ; 034AD:  a5 b5
            sta $0707                   ; 034AF:  8d 07 07
            lda $ce                     ; 034B2:  a5 ce
            sta $0708                   ; 034B4:  8d 08 07
            lda #$01                    ; 034B7:  a9 01
            sta $1d                     ; 034B9:  85 1d
            lda $0700                   ; 034BB:  ad 00 07
            cmp #$09                    ; 034BE:  c9 09
            bcc b0_b4d2                 ; 034C0:  90 10
            iny                         ; 034C2:  c8
            cmp #$10                    ; 034C3:  c9 10
            bcc b0_b4d2                 ; 034C5:  90 0b
            iny                         ; 034C7:  c8
            cmp #$19                    ; 034C8:  c9 19
            bcc b0_b4d2                 ; 034CA:  90 06
            iny                         ; 034CC:  c8
            cmp #$1c                    ; 034CD:  c9 1c
            bcc b0_b4d2                 ; 034CF:  90 01
            iny                         ; 034D1:  c8
b0_b4d2:    lda #$01                    ; 034D2:  a9 01
            sta $0706                   ; 034D4:  8d 06 07
            lda $0704                   ; 034D7:  ad 04 07
            beq b0_b4e4                 ; 034DA:  f0 08
            ldy #$05                    ; 034DC:  a0 05
            lda $047d                   ; 034DE:  ad 7d 04
            beq b0_b4e4                 ; 034E1:  f0 01
            iny                         ; 034E3:  c8
b0_b4e4:    lda tab_b0_b424,y           ; 034E4:  b9 24 b4
            sta $0709                   ; 034E7:  8d 09 07
            lda tab_b0_b424+7,y         ; 034EA:  b9 2b b4
            sta $070a                   ; 034ED:  8d 0a 07
            lda tab_b0_b424+21,y        ; 034F0:  b9 39 b4
            sta $0433                   ; 034F3:  8d 33 04
            lda tab_b0_b424+14,y        ; 034F6:  b9 32 b4
            sta $9f                     ; 034F9:  85 9f
            lda $0704                   ; 034FB:  ad 04 07
            beq b0_b511                 ; 034FE:  f0 11
            lda #$04                    ; 03500:  a9 04
            sta $ff                     ; 03502:  85 ff
            lda $ce                     ; 03504:  a5 ce
            cmp #$14                    ; 03506:  c9 14
            bcs b0_b51c                 ; 03508:  b0 12
            lda #$00                    ; 0350A:  a9 00
            sta $9f                     ; 0350C:  85 9f
            jmp b0_b51c                 ; 0350E:  4c 1c b5

b0_b511:    lda #$01                    ; 03511:  a9 01
            ldy $0754                   ; 03513:  ac 54 07
            beq b0_b51a                 ; 03516:  f0 02
            lda #$80                    ; 03518:  a9 80
b0_b51a:    sta $ff                     ; 0351A:  85 ff
b0_b51c:    ldy #$00                    ; 0351C:  a0 00
            sty $00                     ; 0351E:  84 00
            lda $1d                     ; 03520:  a5 1d
            beq b0_b52d                 ; 03522:  f0 09
            lda $0700                   ; 03524:  ad 00 07
            cmp #$19                    ; 03527:  c9 19
            bcs b0_b55e                 ; 03529:  b0 33
            bcc b0_b545                 ; 0352B:  90 18
b0_b52d:    iny                         ; 0352D:  c8
            lda $074e                   ; 0352E:  ad 4e 07
            beq b0_b545                 ; 03531:  f0 12
            dey                         ; 03533:  88
            lda $0c                     ; 03534:  a5 0c
            cmp $45                     ; 03536:  c5 45
            bne b0_b545                 ; 03538:  d0 0b
            lda $0a                     ; 0353A:  a5 0a
            and #$40                    ; 0353C:  29 40
            bne b0_b559                 ; 0353E:  d0 19
            lda $0783                   ; 03540:  ad 83 07
            bne b0_b55e                 ; 03543:  d0 19
b0_b545:    iny                         ; 03545:  c8
            inc $00                     ; 03546:  e6 00
            lda $0703                   ; 03548:  ad 03 07
            bne b0_b554                 ; 0354B:  d0 07
            lda $0700                   ; 0354D:  ad 00 07
            cmp #$21                    ; 03550:  c9 21
            bcc b0_b55e                 ; 03552:  90 0a
b0_b554:    inc $00                     ; 03554:  e6 00
            jmp b0_b55e                 ; 03556:  4c 5e b5

b0_b559:    lda #$0a                    ; 03559:  a9 0a
            sta $0783                   ; 0355B:  8d 83 07
b0_b55e:    lda tab_b0_b424+28,y        ; 0355E:  b9 40 b4
            sta $0450                   ; 03561:  8d 50 04
            lda $0e                     ; 03564:  a5 0e
            cmp #$07                    ; 03566:  c9 07
            bne b0_b56c                 ; 03568:  d0 02
            ldy #$03                    ; 0356A:  a0 03
b0_b56c:    lda tab_b0_b424+31,y        ; 0356C:  b9 43 b4
            sta $0456                   ; 0356F:  8d 56 04
            ldy $00                     ; 03572:  a4 00
            lda tab_b0_b424+35,y        ; 03574:  b9 47 b4
            sta $0702                   ; 03577:  8d 02 07
            lda #$00                    ; 0357A:  a9 00
            sta $0701                   ; 0357C:  8d 01 07
            lda $33                     ; 0357F:  a5 33
            cmp $45                     ; 03581:  c5 45
            beq b0_b58b                 ; 03583:  f0 06
            asl $0702                   ; 03585:  0e 02 07
            rol $0701                   ; 03588:  2e 01 07
b0_b58b:    rts                         ; 0358B:  60

tab_b0_b58c: ; 3 bytes
            hex 02 04 07                ; 0358C:  02 04 07

b0_b58f:    ldy #$00                    ; 0358F:  a0 00
            lda $0700                   ; 03591:  ad 00 07
            cmp #$1c                    ; 03594:  c9 1c
            bcs b0_b5ad                 ; 03596:  b0 15
            iny                         ; 03598:  c8
            cmp #$0e                    ; 03599:  c9 0e
            bcs b0_b59e                 ; 0359B:  b0 01
            iny                         ; 0359D:  c8
b0_b59e:    lda $06fc                   ; 0359E:  ad fc 06
            and #$7f                    ; 035A1:  29 7f
            beq b0_b5c5                 ; 035A3:  f0 20
            and #$03                    ; 035A5:  29 03
            cmp $45                     ; 035A7:  c5 45
            bne b0_b5b3                 ; 035A9:  d0 08
            lda #$00                    ; 035AB:  a9 00
b0_b5ad:    sta $0703                   ; 035AD:  8d 03 07
            jmp b0_b5c5                 ; 035B0:  4c c5 b5

b0_b5b3:    lda $0700                   ; 035B3:  ad 00 07
            cmp #$0b                    ; 035B6:  c9 0b
            bcs b0_b5c5                 ; 035B8:  b0 0b
            lda $33                     ; 035BA:  a5 33
            sta $45                     ; 035BC:  85 45
            lda #$00                    ; 035BE:  a9 00
            sta $57                     ; 035C0:  85 57
            sta $0705                   ; 035C2:  8d 05 07
b0_b5c5:    lda tab_b0_b58c,y           ; 035C5:  b9 8c b5
            sta $070c                   ; 035C8:  8d 0c 07
            rts                         ; 035CB:  60

b0_b5cc:    and $0490                   ; 035CC:  2d 90 04
            cmp #$00                    ; 035CF:  c9 00
            bne b0_b5db                 ; 035D1:  d0 08
            lda $57                     ; 035D3:  a5 57
            beq b0_b620                 ; 035D5:  f0 49
            bpl b0_b5fc                 ; 035D7:  10 23
            bmi b0_b5de                 ; 035D9:  30 03
b0_b5db:    lsr a                       ; 035DB:  4a
            bcc b0_b5fc                 ; 035DC:  90 1e
b0_b5de:    lda $0705                   ; 035DE:  ad 05 07
            clc                         ; 035E1:  18
            adc $0702                   ; 035E2:  6d 02 07
            sta $0705                   ; 035E5:  8d 05 07
            lda $57                     ; 035E8:  a5 57
            adc $0701                   ; 035EA:  6d 01 07
            sta $57                     ; 035ED:  85 57
            cmp $0456                   ; 035EF:  cd 56 04
            bmi b0_b617                 ; 035F2:  30 23
            lda $0456                   ; 035F4:  ad 56 04
            sta $57                     ; 035F7:  85 57
            jmp b0_b620                 ; 035F9:  4c 20 b6

b0_b5fc:    lda $0705                   ; 035FC:  ad 05 07
            sec                         ; 035FF:  38
            sbc $0702                   ; 03600:  ed 02 07
            sta $0705                   ; 03603:  8d 05 07
            lda $57                     ; 03606:  a5 57
            sbc $0701                   ; 03608:  ed 01 07
            sta $57                     ; 0360B:  85 57
            cmp $0450                   ; 0360D:  cd 50 04
            bpl b0_b617                 ; 03610:  10 05
            lda $0450                   ; 03612:  ad 50 04
            sta $57                     ; 03615:  85 57
b0_b617:    cmp #$00                    ; 03617:  c9 00
            bpl b0_b620                 ; 03619:  10 05
            eor #$ff                    ; 0361B:  49 ff
            clc                         ; 0361D:  18
            adc #$01                    ; 0361E:  69 01
b0_b620:    sta $0700                   ; 03620:  8d 00 07
            rts                         ; 03623:  60

b0_b624:    lda $0756                   ; 03624:  ad 56 07
            cmp #$02                    ; 03627:  c9 02
            bcc b0_b66e                 ; 03629:  90 43
            lda $0a                     ; 0362B:  a5 0a
            and #$40                    ; 0362D:  29 40
            beq b0_b664                 ; 0362F:  f0 33
            and $0d                     ; 03631:  25 0d
            bne b0_b664                 ; 03633:  d0 2f
            lda $06ce                   ; 03635:  ad ce 06
            and #$01                    ; 03638:  29 01
            tax                         ; 0363A:  aa
            lda $24,x                   ; 0363B:  b5 24
            bne b0_b664                 ; 0363D:  d0 25
            ldy $b5                     ; 0363F:  a4 b5
            dey                         ; 03641:  88
            bne b0_b664                 ; 03642:  d0 20
            lda $0714                   ; 03644:  ad 14 07
            bne b0_b664                 ; 03647:  d0 1b
            lda $1d                     ; 03649:  a5 1d
            cmp #$03                    ; 0364B:  c9 03
            beq b0_b664                 ; 0364D:  f0 15
            lda #$20                    ; 0364F:  a9 20
            sta $ff                     ; 03651:  85 ff
            lda #$02                    ; 03653:  a9 02
            sta $24,x                   ; 03655:  95 24
            ldy $070c                   ; 03657:  ac 0c 07
            sty $0711                   ; 0365A:  8c 11 07
            dey                         ; 0365D:  88
            sty $0781                   ; 0365E:  8c 81 07
            inc $06ce                   ; 03661:  ee ce 06
b0_b664:    ldx #$00                    ; 03664:  a2 00
            jsr b0_b688+1               ; 03666:  20 89 b6
            ldx #$01                    ; 03669:  a2 01
            jsr b0_b688+1               ; 0366B:  20 89 b6
b0_b66e:    lda $074e                   ; 0366E:  ad 4e 07
            bne b0_b686                 ; 03671:  d0 13
            ldx #$02                    ; 03673:  a2 02
b0_b675:    stx $08                     ; 03675:  86 08
            jsr b0_b6f9                 ; 03677:  20 f9 b6
            jsr $f131                   ; 0367A:  20 31 f1
            jsr $f191                   ; 0367D:  20 91 f1
            jsr $ede1                   ; 03680:  20 e1 ed
            dex                         ; 03683:  ca
            bpl b0_b675                 ; 03684:  10 ef
b0_b686:    rts                         ; 03686:  60

tab_b0_b687: ; 1 bytes
            hex 40                      ; 03687:  40

b0_b688:    cpy #$86                    ; 03688:  c0 86
            php                         ; 0368A:  08
            lda $24,x                   ; 0368B:  b5 24
            asl a                       ; 0368D:  0a
            bcs b0_b6f3                 ; 0368E:  b0 63
            ldy $24,x                   ; 03690:  b4 24
            beq b0_b6f2                 ; 03692:  f0 5e
            dey                         ; 03694:  88
            beq b0_b6be                 ; 03695:  f0 27
            lda $86                     ; 03697:  a5 86
            adc #$04                    ; 03699:  69 04
            sta $8d,x                   ; 0369B:  95 8d
            lda $6d                     ; 0369D:  a5 6d
            adc #$00                    ; 0369F:  69 00
            sta $74,x                   ; 036A1:  95 74
            lda $ce                     ; 036A3:  a5 ce
            sta $d5,x                   ; 036A5:  95 d5
            lda #$01                    ; 036A7:  a9 01
            sta $bc,x                   ; 036A9:  95 bc
            ldy $33                     ; 036AB:  a4 33
            dey                         ; 036AD:  88
            lda tab_b0_b687,y           ; 036AE:  b9 87 b6
            sta $5e,x                   ; 036B1:  95 5e
            lda #$04                    ; 036B3:  a9 04
            sta $a6,x                   ; 036B5:  95 a6
            lda #$07                    ; 036B7:  a9 07
            sta $04a0,x                 ; 036B9:  9d a0 04
            dec $24,x                   ; 036BC:  d6 24
b0_b6be:    txa                         ; 036BE:  8a
            clc                         ; 036BF:  18
            adc #$07                    ; 036C0:  69 07
            tax                         ; 036C2:  aa
            lda #$50                    ; 036C3:  a9 50
            sta $00                     ; 036C5:  85 00
            lda #$03                    ; 036C7:  a9 03
            sta $02                     ; 036C9:  85 02
            lda #$00                    ; 036CB:  a9 00
            jsr tab_b0_bfd7             ; 036CD:  20 d7 bf
            jsr b0_bf0f                 ; 036D0:  20 0f bf
            ldx $08                     ; 036D3:  a6 08
            jsr $f13b                   ; 036D5:  20 3b f1
            jsr $f187                   ; 036D8:  20 87 f1
            jsr $e22d                   ; 036DB:  20 2d e2
            jsr $e1c8                   ; 036DE:  20 c8 e1
            lda $03d2                   ; 036E1:  ad d2 03
            and #$cc                    ; 036E4:  29 cc
            bne b0_b6ee                 ; 036E6:  d0 06
            jsr $d6d9                   ; 036E8:  20 d9 d6
            jmp $ecde                   ; 036EB:  4c de ec

b0_b6ee:    lda #$00                    ; 036EE:  a9 00
            sta $24,x                   ; 036F0:  95 24
b0_b6f2:    rts                         ; 036F2:  60

b0_b6f3:    jsr $f13b                   ; 036F3:  20 3b f1
            jmp $ed09                   ; 036F6:  4c 09 ed

b0_b6f9:    lda $07a8,x                 ; 036F9:  bd a8 07
            and #$01                    ; 036FC:  29 01
            sta $07                     ; 036FE:  85 07
            lda $e4,x                   ; 03700:  b5 e4
            cmp #$f8                    ; 03702:  c9 f8
            bne b0_b732                 ; 03704:  d0 2c
            lda $0792                   ; 03706:  ad 92 07
            bne b0_b74a                 ; 03709:  d0 3f
b0_b70b:    ldy #$00                    ; 0370B:  a0 00
            lda $33                     ; 0370D:  a5 33
            lsr a                       ; 0370F:  4a
            bcc b0_b714                 ; 03710:  90 02
            ldy #$08                    ; 03712:  a0 08
b0_b714:    tya                         ; 03714:  98
            adc $86                     ; 03715:  65 86
            sta $9c,x                   ; 03717:  95 9c
            lda $6d                     ; 03719:  a5 6d
            adc #$00                    ; 0371B:  69 00
            sta $83,x                   ; 0371D:  95 83
            lda $ce                     ; 0371F:  a5 ce
            clc                         ; 03721:  18
            adc #$08                    ; 03722:  69 08
            sta $e4,x                   ; 03724:  95 e4
            lda #$01                    ; 03726:  a9 01
            sta $cb,x                   ; 03728:  95 cb
            ldy $07                     ; 0372A:  a4 07
            lda tab_b0_b74b+2,y         ; 0372C:  b9 4d b7
            sta $0792                   ; 0372F:  8d 92 07
b0_b732:    ldy $07                     ; 03732:  a4 07
            lda $042c,x                 ; 03734:  bd 2c 04
            sec                         ; 03737:  38
            sbc tab_b0_b74b,y           ; 03738:  f9 4b b7
            sta $042c,x                 ; 0373B:  9d 2c 04
            lda $e4,x                   ; 0373E:  b5 e4
            sbc #$00                    ; 03740:  e9 00
            cmp #$20                    ; 03742:  c9 20
            bcs b0_b748                 ; 03744:  b0 02
            lda #$f8                    ; 03746:  a9 f8
b0_b748:    sta $e4,x                   ; 03748:  95 e4
b0_b74a:    rts                         ; 0374A:  60

tab_b0_b74b: ; 7 bytes
            hex ff 50 40 20 ad 70 07    ; 0374B:  ff 50 40 20 ad 70 07

            beq b0_b7a3                 ; 03752:  f0 4f
            lda $0e                     ; 03754:  a5 0e
            cmp #$08                    ; 03756:  c9 08
            bcc b0_b7a3                 ; 03758:  90 49
            cmp #$0b                    ; 0375A:  c9 0b
            beq b0_b7a3                 ; 0375C:  f0 45
            lda $b5                     ; 0375E:  a5 b5
            cmp #$02                    ; 03760:  c9 02
            bcs b0_b7a3                 ; 03762:  b0 3f
            lda $0787                   ; 03764:  ad 87 07
            bne b0_b7a3                 ; 03767:  d0 3a
            lda $07f8                   ; 03769:  ad f8 07
            ora $07f9                   ; 0376C:  0d f9 07
            ora $07fa                   ; 0376F:  0d fa 07
            beq b0_b79a                 ; 03772:  f0 26
            ldy $07f8                   ; 03774:  ac f8 07
            dey                         ; 03777:  88
            bne b0_b786                 ; 03778:  d0 0c
            lda $07f9                   ; 0377A:  ad f9 07
            ora $07fa                   ; 0377D:  0d fa 07
            bne b0_b786                 ; 03780:  d0 04
            lda #$40                    ; 03782:  a9 40
            sta $fc                     ; 03784:  85 fc
b0_b786:    lda #$18                    ; 03786:  a9 18
            sta $0787                   ; 03788:  8d 87 07
            ldy #$23                    ; 0378B:  a0 23
            lda #$ff                    ; 0378D:  a9 ff
            sta $0139                   ; 0378F:  8d 39 01
            jsr b0_8f5f                 ; 03792:  20 5f 8f
            lda #$a4                    ; 03795:  a9 a4
            jmp b0_8f04+2               ; 03797:  4c 06 8f

b0_b79a:    sta $0756                   ; 0379A:  8d 56 07
            jsr $d931                   ; 0379D:  20 31 d9
            inc $0759                   ; 037A0:  ee 59 07
b0_b7a3:    rts                         ; 037A3:  60

            lda $0723                   ; 037A4:  ad 23 07
            beq b0_b7a3                 ; 037A7:  f0 fa
            lda $ce                     ; 037A9:  a5 ce
            and $b5                     ; 037AB:  25 b5
            bne b0_b7a3                 ; 037AD:  d0 f4
            sta $0723                   ; 037AF:  8d 23 07
            inc $06d6                   ; 037B2:  ee d6 06
            jmp $c998                   ; 037B5:  4c 98 c9

b0_b7b8:    lda $074e                   ; 037B8:  ad 4e 07
            bne b0_b7f4                 ; 037BB:  d0 37
            sta $047d                   ; 037BD:  8d 7d 04
            lda $0747                   ; 037C0:  ad 47 07
            bne b0_b7f4                 ; 037C3:  d0 2f
            ldy #$04                    ; 037C5:  a0 04
b0_b7c7:    lda $0471,y                 ; 037C7:  b9 71 04
            clc                         ; 037CA:  18
            adc $0477,y                 ; 037CB:  79 77 04
            sta $02                     ; 037CE:  85 02
            lda $046b,y                 ; 037D0:  b9 6b 04
            beq b0_b7f1                 ; 037D3:  f0 1c
            adc #$00                    ; 037D5:  69 00
            sta $01                     ; 037D7:  85 01
            lda $86                     ; 037D9:  a5 86
            sec                         ; 037DB:  38
            sbc $0471,y                 ; 037DC:  f9 71 04
            lda $6d                     ; 037DF:  a5 6d
            sbc $046b,y                 ; 037E1:  f9 6b 04
            bmi b0_b7f1                 ; 037E4:  30 0b
            lda $02                     ; 037E6:  a5 02
            sec                         ; 037E8:  38
            sbc $86                     ; 037E9:  e5 86
            lda $01                     ; 037EB:  a5 01
            sbc $6d                     ; 037ED:  e5 6d
            bpl b0_b7f5                 ; 037EF:  10 04
b0_b7f1:    dey                         ; 037F1:  88
            bpl b0_b7c7                 ; 037F2:  10 d3
b0_b7f4:    rts                         ; 037F4:  60

b0_b7f5:    lda $0477,y                 ; 037F5:  b9 77 04
            lsr a                       ; 037F8:  4a
            sta $00                     ; 037F9:  85 00
            lda $0471,y                 ; 037FB:  b9 71 04
            clc                         ; 037FE:  18
            adc $00                     ; 037FF:  65 00
            sta $01                     ; 03801:  85 01
            lda $046b,y                 ; 03803:  b9 6b 04
            adc #$00                    ; 03806:  69 00
            sta $00                     ; 03808:  85 00
            lda $09                     ; 0380A:  a5 09
            lsr a                       ; 0380C:  4a
            bcc b0_b83b                 ; 0380D:  90 2c
            lda $01                     ; 0380F:  a5 01
            sec                         ; 03811:  38
            sbc $86                     ; 03812:  e5 86
            lda $00                     ; 03814:  a5 00
            sbc $6d                     ; 03816:  e5 6d
            bpl b0_b828                 ; 03818:  10 0e
            lda $86                     ; 0381A:  a5 86
            sec                         ; 0381C:  38
            sbc #$01                    ; 0381D:  e9 01
            sta $86                     ; 0381F:  85 86
            lda $6d                     ; 03821:  a5 6d
            sbc #$00                    ; 03823:  e9 00
            jmp b0_b839                 ; 03825:  4c 39 b8

b0_b828:    lda $0490                   ; 03828:  ad 90 04
            lsr a                       ; 0382B:  4a
            bcc b0_b83b                 ; 0382C:  90 0d
            lda $86                     ; 0382E:  a5 86
            clc                         ; 03830:  18
            adc #$01                    ; 03831:  69 01
            sta $86                     ; 03833:  85 86
            lda $6d                     ; 03835:  a5 6d
            adc #$00                    ; 03837:  69 00
b0_b839:    sta $6d                     ; 03839:  85 6d
b0_b83b:    lda #$10                    ; 0383B:  a9 10
            sta $00                     ; 0383D:  85 00
            lda #$01                    ; 0383F:  a9 01
            sta $047d                   ; 03841:  8d 7d 04
            sta $02                     ; 03844:  85 02
            lsr a                       ; 03846:  4a
            tax                         ; 03847:  aa
            jmp tab_b0_bfd7             ; 03848:  4c d7 bf

tab_b0_b84b: ; 10 bytes
            hex 05 02 08 04 01 03 03 04 ; 0384B:  05 02 08 04 01 03 03 04
            hex 04 04                   ; 03853:  04 04

b0_b855:    ldx #$05                    ; 03855:  a2 05
            stx $08                     ; 03857:  86 08
            lda $16,x                   ; 03859:  b5 16
            cmp #$30                    ; 0385B:  c9 30
            bne b0_b8b5                 ; 0385D:  d0 56
            lda $0e                     ; 0385F:  a5 0e
            cmp #$04                    ; 03861:  c9 04
            bne b0_b896                 ; 03863:  d0 31
            lda $1d                     ; 03865:  a5 1d
            cmp #$03                    ; 03867:  c9 03
            bne b0_b896                 ; 03869:  d0 2b
            lda $cf,x                   ; 0386B:  b5 cf
            cmp #$aa                    ; 0386D:  c9 aa
            bcs b0_b899                 ; 0386F:  b0 28
            lda $ce                     ; 03871:  a5 ce
            cmp #$a2                    ; 03873:  c9 a2
            bcs b0_b899                 ; 03875:  b0 22
            lda $0417,x                 ; 03877:  bd 17 04
            adc #$ff                    ; 0387A:  69 ff
            sta $0417,x                 ; 0387C:  9d 17 04
            lda $cf,x                   ; 0387F:  b5 cf
            adc #$01                    ; 03881:  69 01
            sta $cf,x                   ; 03883:  95 cf
            lda $010e                   ; 03885:  ad 0e 01
            sec                         ; 03888:  38
            sbc #$ff                    ; 03889:  e9 ff
            sta $010e                   ; 0388B:  8d 0e 01
            lda $010d                   ; 0388E:  ad 0d 01
            sbc #$01                    ; 03891:  e9 01
            sta $010d                   ; 03893:  8d 0d 01
b0_b896:    jmp b0_b8ac                 ; 03896:  4c ac b8

b0_b899:    ldy $010f                   ; 03899:  ac 0f 01
            lda tab_b0_b84b,y           ; 0389C:  b9 4b b8
            ldx tab_b0_b84b+5,y         ; 0389F:  be 50 b8
            sta $0134,x                 ; 038A2:  9d 34 01
            jsr b0_bc27                 ; 038A5:  20 27 bc
            lda #$05                    ; 038A8:  a9 05
            sta $0e                     ; 038AA:  85 0e
b0_b8ac:    jsr $f1af                   ; 038AC:  20 af f1
            jsr $f152                   ; 038AF:  20 52 f1
            jsr $e54b                   ; 038B2:  20 4b e5
b0_b8b5:    rts                         ; 038B5:  60

tab_b0_b8b6: ; 10 bytes
            hex 08 10 08 00 20 af f1 ad ; 038B6:  08 10 08 00 20 af f1 ad
            hex 47 07                   ; 038BE:  47 07

            bne b0_b902                 ; 038C0:  d0 40
            lda $070e                   ; 038C2:  ad 0e 07
            beq b0_b902                 ; 038C5:  f0 3b
            tay                         ; 038C7:  a8
            dey                         ; 038C8:  88
            tya                         ; 038C9:  98
            and #$02                    ; 038CA:  29 02
            bne b0_b8d5                 ; 038CC:  d0 07
            inc $ce                     ; 038CE:  e6 ce
            inc $ce                     ; 038D0:  e6 ce
            jmp b0_b8d9                 ; 038D2:  4c d9 b8

b0_b8d5:    dec $ce                     ; 038D5:  c6 ce
            dec $ce                     ; 038D7:  c6 ce
b0_b8d9:    lda $58,x                   ; 038D9:  b5 58
            clc                         ; 038DB:  18
            adc tab_b0_b8b6,y           ; 038DC:  79 b6 b8
            sta $cf,x                   ; 038DF:  95 cf
            cpy #$01                    ; 038E1:  c0 01
            bcc b0_b8f4                 ; 038E3:  90 0f
            lda $0a                     ; 038E5:  a5 0a
            and #$80                    ; 038E7:  29 80
            beq b0_b8f4                 ; 038E9:  f0 09
            and $0d                     ; 038EB:  25 0d
            bne b0_b8f4                 ; 038ED:  d0 05
            lda #$f4                    ; 038EF:  a9 f4
            sta $06db                   ; 038F1:  8d db 06
b0_b8f4:    cpy #$03                    ; 038F4:  c0 03
            bne b0_b902                 ; 038F6:  d0 0a
            lda $06db                   ; 038F8:  ad db 06
            sta $9f                     ; 038FB:  85 9f
            lda #$00                    ; 038FD:  a9 00
            sta $070e                   ; 038FF:  8d 0e 07
b0_b902:    jsr $f152                   ; 03902:  20 52 f1
            jsr $e87d                   ; 03905:  20 7d e8
            jsr $d67a                   ; 03908:  20 7a d6
            lda $070e                   ; 0390B:  ad 0e 07
            beq b0_b91d                 ; 0390E:  f0 0d
            lda $0786                   ; 03910:  ad 86 07
            bne b0_b91d                 ; 03913:  d0 08
            lda #$04                    ; 03915:  a9 04
            sta $0786                   ; 03917:  8d 86 07
            inc $070e                   ; 0391A:  ee 0e 07
b0_b91d:    rts                         ; 0391D:  60

b0_b91e:    lda #$2f                    ; 0391E:  a9 2f
            sta $16,x                   ; 03920:  95 16
            lda #$01                    ; 03922:  a9 01
            sta $0f,x                   ; 03924:  95 0f
            hex b9 76 00 ; lda $0076,y  ; 03926:  b9 76 00
            sta $6e,x                   ; 03929:  95 6e
            hex b9 8f 00 ; lda $008f,y  ; 0392B:  b9 8f 00
            sta $87,x                   ; 0392E:  95 87
            hex b9 d7 00 ; lda $00d7,y  ; 03930:  b9 d7 00
            sta $cf,x                   ; 03933:  95 cf
            ldy $0398                   ; 03935:  ac 98 03
            bne b0_b93d                 ; 03938:  d0 03
            sta $039d                   ; 0393A:  8d 9d 03
b0_b93d:    txa                         ; 0393D:  8a
            sta $039a,y                 ; 0393E:  99 9a 03
            inc $0398                   ; 03941:  ee 98 03
            lda #$04                    ; 03944:  a9 04
            sta $fe                     ; 03946:  85 fe
            rts                         ; 03948:  60

b0_b949:    bmi b0_b9ab                 ; 03949:  30 60
            cpx #$05                    ; 0394B:  e0 05
            bne b0_b9b7                 ; 0394D:  d0 68
            ldy $0398                   ; 0394F:  ac 98 03
            dey                         ; 03952:  88
            lda $0399                   ; 03953:  ad 99 03
            cmp b0_b949,y               ; 03956:  d9 49 b9
            beq b0_b96a                 ; 03959:  f0 0f
            lda $09                     ; 0395B:  a5 09
            lsr a                       ; 0395D:  4a
            lsr a                       ; 0395E:  4a
            bcc b0_b96a                 ; 0395F:  90 09
            lda $d4                     ; 03961:  a5 d4
            sbc #$01                    ; 03963:  e9 01
            sta $d4                     ; 03965:  85 d4
            inc $0399                   ; 03967:  ee 99 03
b0_b96a:    lda $0399                   ; 0396A:  ad 99 03
            cmp #$08                    ; 0396D:  c9 08
            bcc b0_b9b7                 ; 0396F:  90 46
            jsr $f152                   ; 03971:  20 52 f1
            jsr $f1af                   ; 03974:  20 af f1
            ldy #$00                    ; 03977:  a0 00
b0_b979:    jsr $e435                   ; 03979:  20 35 e4
            iny                         ; 0397C:  c8
            cpy $0398                   ; 0397D:  cc 98 03
            bne b0_b979                 ; 03980:  d0 f7
            lda $03d1                   ; 03982:  ad d1 03
            and #$0c                    ; 03985:  29 0c
            beq b0_b999                 ; 03987:  f0 10
            dey                         ; 03989:  88
b0_b98a:    ldx $039a,y                 ; 0398A:  be 9a 03
            jsr $c998                   ; 0398D:  20 98 c9
            dey                         ; 03990:  88
            bpl b0_b98a                 ; 03991:  10 f7
            sta $0398                   ; 03993:  8d 98 03
            sta $0399                   ; 03996:  8d 99 03
b0_b999:    lda $0399                   ; 03999:  ad 99 03
            cmp #$20                    ; 0399C:  c9 20
            bcc b0_b9b7                 ; 0399E:  90 17
            ldx #$06                    ; 039A0:  a2 06
            lda #$01                    ; 039A2:  a9 01
            ldy #$1b                    ; 039A4:  a0 1b
            jsr $e3f0                   ; 039A6:  20 f0 e3
            ldy $02                     ; 039A9:  a4 02
b0_b9ab:    cpy #$d0                    ; 039AB:  c0 d0
            bcs b0_b9b7                 ; 039AD:  b0 08
            lda ($06),y                 ; 039AF:  b1 06
            bne b0_b9b7                 ; 039B1:  d0 04
            lda #$26                    ; 039B3:  a9 26
            sta ($06),y                 ; 039B5:  91 06
b0_b9b7:    ldx $08                     ; 039B7:  a6 08
            rts                         ; 039B9:  60

tab_b0_b9ba: ; 2 bytes
            hex 0f 07                   ; 039BA:  0f 07

b0_b9bc:    lda $074e                   ; 039BC:  ad 4e 07
            beq b0_ba30                 ; 039BF:  f0 6f
            ldx #$02                    ; 039C1:  a2 02
b0_b9c3:    stx $08                     ; 039C3:  86 08
            lda $0f,x                   ; 039C5:  b5 0f
            bne b0_ba1a                 ; 039C7:  d0 51
            lda $07a8,x                 ; 039C9:  bd a8 07
            ldy $06cc                   ; 039CC:  ac cc 06
            and tab_b0_b9ba,y           ; 039CF:  39 ba b9
            cmp #$06                    ; 039D2:  c9 06
            bcs b0_ba1a                 ; 039D4:  b0 44
            tay                         ; 039D6:  a8
            lda $046b,y                 ; 039D7:  b9 6b 04
            beq b0_ba1a                 ; 039DA:  f0 3e
            lda $047d,y                 ; 039DC:  b9 7d 04
            beq b0_b9e9                 ; 039DF:  f0 08
            sbc #$00                    ; 039E1:  e9 00
            sta $047d,y                 ; 039E3:  99 7d 04
            jmp b0_ba1a                 ; 039E6:  4c 1a ba

b0_b9e9:    lda $0747                   ; 039E9:  ad 47 07
            bne b0_ba1a                 ; 039EC:  d0 2c
            lda #$0e                    ; 039EE:  a9 0e
            sta $047d,y                 ; 039F0:  99 7d 04
            lda $046b,y                 ; 039F3:  b9 6b 04
            sta $6e,x                   ; 039F6:  95 6e
            lda $0471,y                 ; 039F8:  b9 71 04
            sta $87,x                   ; 039FB:  95 87
            lda $0477,y                 ; 039FD:  b9 77 04
            sec                         ; 03A00:  38
            sbc #$08                    ; 03A01:  e9 08
            sta $cf,x                   ; 03A03:  95 cf
            lda #$01                    ; 03A05:  a9 01
            sta $b6,x                   ; 03A07:  95 b6
            sta $0f,x                   ; 03A09:  95 0f
            lsr a                       ; 03A0B:  4a
            sta $1e,x                   ; 03A0C:  95 1e
            lda #$09                    ; 03A0E:  a9 09
            sta $049a,x                 ; 03A10:  9d 9a 04
            lda #$33                    ; 03A13:  a9 33
            sta $16,x                   ; 03A15:  95 16
            jmp b0_ba2d                 ; 03A17:  4c 2d ba

b0_ba1a:    lda $16,x                   ; 03A1A:  b5 16
            cmp #$33                    ; 03A1C:  c9 33
            bne b0_ba2d                 ; 03A1E:  d0 0d
            jsr $d67a                   ; 03A20:  20 7a d6
            lda $0f,x                   ; 03A23:  b5 0f
            beq b0_ba2d                 ; 03A25:  f0 06
            jsr $f1af                   ; 03A27:  20 af f1
            jsr b0_ba33                 ; 03A2A:  20 33 ba
b0_ba2d:    dex                         ; 03A2D:  ca
            bpl b0_b9c3                 ; 03A2E:  10 93
b0_ba30:    rts                         ; 03A30:  60

b0_ba31:    clc                         ; 03A31:  18
            inx                         ; 03A32:  e8
b0_ba33:    lda $0747                   ; 03A33:  ad 47 07
            bne b0_ba76                 ; 03A36:  d0 3e
            lda $1e,x                   ; 03A38:  b5 1e
            bne b0_ba6a                 ; 03A3A:  d0 2e
            lda $03d1                   ; 03A3C:  ad d1 03
            and #$0c                    ; 03A3F:  29 0c
            cmp #$0c                    ; 03A41:  c9 0c
            beq b0_ba85                 ; 03A43:  f0 40
            ldy #$01                    ; 03A45:  a0 01
            jsr $e143                   ; 03A47:  20 43 e1
            bmi b0_ba4d                 ; 03A4A:  30 01
            iny                         ; 03A4C:  c8
b0_ba4d:    sty $46,x                   ; 03A4D:  94 46
            dey                         ; 03A4F:  88
            lda b0_ba31,y               ; 03A50:  b9 31 ba
            sta $58,x                   ; 03A53:  95 58
            lda $00                     ; 03A55:  a5 00
            adc #$28                    ; 03A57:  69 28
            cmp #$50                    ; 03A59:  c9 50
            bcc b0_ba85                 ; 03A5B:  90 28
            lda #$01                    ; 03A5D:  a9 01
            sta $1e,x                   ; 03A5F:  95 1e
            lda #$0a                    ; 03A61:  a9 0a
            sta $078a,x                 ; 03A63:  9d 8a 07
            lda #$08                    ; 03A66:  a9 08
            sta $fe                     ; 03A68:  85 fe
b0_ba6a:    lda $1e,x                   ; 03A6A:  b5 1e
            and #$20                    ; 03A6C:  29 20
            beq b0_ba73                 ; 03A6E:  f0 03
            jsr b0_bf63                 ; 03A70:  20 63 bf
b0_ba73:    jsr b0_bf02                 ; 03A73:  20 02 bf
b0_ba76:    jsr $f1af                   ; 03A76:  20 af f1
            jsr $f152                   ; 03A79:  20 52 f1
            jsr $e243                   ; 03A7C:  20 43 e2
            jsr $d853                   ; 03A7F:  20 53 d8
b0_ba82:    jmp $e87d                   ; 03A82:  4c 7d e8

b0_ba85:    jsr $c998                   ; 03A85:  20 98 c9
            rts                         ; 03A88:  60

tab_b0_ba89: ; 3 bytes
            hex 04 04 04                ; 03A89:  04 04 04

            ora $05                     ; 03A8C:  05 05
            ora $06                     ; 03A8E:  05 06
            asl $06                     ; 03A90:  06 06
b0_ba92:    bpl b0_ba82+2               ; 03A92:  10 f0
            lda $07a8                   ; 03A94:  ad a8 07
            and #$07                    ; 03A97:  29 07
            bne b0_baa0                 ; 03A99:  d0 05
            lda $07a8                   ; 03A9B:  ad a8 07
            and #$08                    ; 03A9E:  29 08
b0_baa0:    tay                         ; 03AA0:  a8
            hex b9 2a 00 ; lda $002a,y  ; 03AA1:  b9 2a 00
            bne b0_babf                 ; 03AA4:  d0 19
            ldx tab_b0_ba89,y           ; 03AA6:  be 89 ba
            lda $0f,x                   ; 03AA9:  b5 0f
            bne b0_babf                 ; 03AAB:  d0 12
            ldx $08                     ; 03AAD:  a6 08
            txa                         ; 03AAF:  8a
            sta $06ae,y                 ; 03AB0:  99 ae 06
            lda #$90                    ; 03AB3:  a9 90
            hex 99 2a 00 ; sta $002a,y  ; 03AB5:  99 2a 00
            lda #$07                    ; 03AB8:  a9 07
            sta $04a2,y                 ; 03ABA:  99 a2 04
            sec                         ; 03ABD:  38
            rts                         ; 03ABE:  60

b0_babf:    ldx $08                     ; 03ABF:  a6 08
            clc                         ; 03AC1:  18
            rts                         ; 03AC2:  60

b0_bac3:    lda $0747                   ; 03AC3:  ad 47 07
            bne b0_bb2b                 ; 03AC6:  d0 63
            lda $2a,x                   ; 03AC8:  b5 2a
            and #$7f                    ; 03ACA:  29 7f
            ldy $06ae,x                 ; 03ACC:  bc ae 06
            cmp #$02                    ; 03ACF:  c9 02
            beq b0_baf3                 ; 03AD1:  f0 20
            bcs b0_bb09                 ; 03AD3:  b0 34
            txa                         ; 03AD5:  8a
            clc                         ; 03AD6:  18
            adc #$0d                    ; 03AD7:  69 0d
            tax                         ; 03AD9:  aa
            lda #$10                    ; 03ADA:  a9 10
            sta $00                     ; 03ADC:  85 00
            lda #$0f                    ; 03ADE:  a9 0f
            sta $01                     ; 03AE0:  85 01
            lda #$04                    ; 03AE2:  a9 04
            sta $02                     ; 03AE4:  85 02
            lda #$00                    ; 03AE6:  a9 00
            jsr tab_b0_bfd7             ; 03AE8:  20 d7 bf
            jsr b0_bf0f                 ; 03AEB:  20 0f bf
            ldx $08                     ; 03AEE:  a6 08
            jmp b0_bb28                 ; 03AF0:  4c 28 bb

b0_baf3:    lda #$fe                    ; 03AF3:  a9 fe
            sta $ac,x                   ; 03AF5:  95 ac
            hex b9 1e 00 ; lda $001e,y  ; 03AF7:  b9 1e 00
            and #$f7                    ; 03AFA:  29 f7
            hex 99 1e 00 ; sta $001e,y  ; 03AFC:  99 1e 00
            ldx $46,y                   ; 03AFF:  b6 46
            dex                         ; 03B01:  ca
            lda b0_ba92,x               ; 03B02:  bd 92 ba
            ldx $08                     ; 03B05:  a6 08
            sta $64,x                   ; 03B07:  95 64
b0_bb09:    dec $2a,x                   ; 03B09:  d6 2a
            hex b9 87 00 ; lda $0087,y  ; 03B0B:  b9 87 00
            clc                         ; 03B0E:  18
            adc #$02                    ; 03B0F:  69 02
            sta $93,x                   ; 03B11:  95 93
            hex b9 6e 00 ; lda $006e,y  ; 03B13:  b9 6e 00
            adc #$00                    ; 03B16:  69 00
            sta $7a,x                   ; 03B18:  95 7a
            hex b9 cf 00 ; lda $00cf,y  ; 03B1A:  b9 cf 00
            sec                         ; 03B1D:  38
            sbc #$0a                    ; 03B1E:  e9 0a
            sta $db,x                   ; 03B20:  95 db
            lda #$01                    ; 03B22:  a9 01
            sta $c2,x                   ; 03B24:  95 c2
            bne b0_bb2b                 ; 03B26:  d0 03
b0_bb28:    jsr $d7c4                   ; 03B28:  20 c4 d7
b0_bb2b:    jsr $f19b                   ; 03B2B:  20 9b f1
            jsr $f148                   ; 03B2E:  20 48 f1
            jsr $e236                   ; 03B31:  20 36 e2
            jsr $e4dc                   ; 03B34:  20 dc e4
            rts                         ; 03B37:  60

            jsr b0_bb84                 ; 03B38:  20 84 bb
            lda $76,x                   ; 03B3B:  b5 76
            hex 99 7a 00 ; sta $007a,y  ; 03B3D:  99 7a 00
            lda $8f,x                   ; 03B40:  b5 8f
            ora #$05                    ; 03B42:  09 05
            hex 99 93 00 ; sta $0093,y  ; 03B44:  99 93 00
            lda $d7,x                   ; 03B47:  b5 d7
            sbc #$10                    ; 03B49:  e9 10
            hex 99 db 00 ; sta $00db,y  ; 03B4B:  99 db 00
            jmp b0_bb6c                 ; 03B4E:  4c 6c bb

b0_bb51:    jsr b0_bb84                 ; 03B51:  20 84 bb
            lda $03ea,x                 ; 03B54:  bd ea 03
            hex 99 7a 00 ; sta $007a,y  ; 03B57:  99 7a 00
            lda $06                     ; 03B5A:  a5 06
            asl a                       ; 03B5C:  0a
            asl a                       ; 03B5D:  0a
            asl a                       ; 03B5E:  0a
            asl a                       ; 03B5F:  0a
            ora #$05                    ; 03B60:  09 05
            hex 99 93 00 ; sta $0093,y  ; 03B62:  99 93 00
            lda $02                     ; 03B65:  a5 02
            adc #$20                    ; 03B67:  69 20
            hex 99 db 00 ; sta $00db,y  ; 03B69:  99 db 00
b0_bb6c:    lda #$fb                    ; 03B6C:  a9 fb
            hex 99 ac 00 ; sta $00ac,y  ; 03B6E:  99 ac 00
            lda #$01                    ; 03B71:  a9 01
            hex 99 c2 00 ; sta $00c2,y  ; 03B73:  99 c2 00
            hex 99 2a 00 ; sta $002a,y  ; 03B76:  99 2a 00
            sta $fe                     ; 03B79:  85 fe
            stx $08                     ; 03B7B:  86 08
            jsr b0_bbfe                 ; 03B7D:  20 fe bb
            inc $0748                   ; 03B80:  ee 48 07
            rts                         ; 03B83:  60

b0_bb84:    ldy #$08                    ; 03B84:  a0 08
b0_bb86:    hex b9 2a 00 ; lda $002a,y  ; 03B86:  b9 2a 00
            beq b0_bb92                 ; 03B89:  f0 07
            dey                         ; 03B8B:  88
            cpy #$05                    ; 03B8C:  c0 05
            bne b0_bb86                 ; 03B8E:  d0 f6
            ldy #$08                    ; 03B90:  a0 08
b0_bb92:    sty $06b7                   ; 03B92:  8c b7 06
            rts                         ; 03B95:  60

b0_bb96:    ldx #$08                    ; 03B96:  a2 08
b0_bb98:    stx $08                     ; 03B98:  86 08
            lda $2a,x                   ; 03B9A:  b5 2a
            beq b0_bbf4                 ; 03B9C:  f0 56
            asl a                       ; 03B9E:  0a
            bcc b0_bba7                 ; 03B9F:  90 06
            jsr b0_bac3                 ; 03BA1:  20 c3 ba
            jmp b0_bbf4                 ; 03BA4:  4c f4 bb

b0_bba7:    ldy $2a,x                   ; 03BA7:  b4 2a
            dey                         ; 03BA9:  88
            beq b0_bbc9                 ; 03BAA:  f0 1d
            inc $2a,x                   ; 03BAC:  f6 2a
            lda $93,x                   ; 03BAE:  b5 93
            clc                         ; 03BB0:  18
            adc $0775                   ; 03BB1:  6d 75 07
            sta $93,x                   ; 03BB4:  95 93
            lda $7a,x                   ; 03BB6:  b5 7a
            adc #$00                    ; 03BB8:  69 00
            sta $7a,x                   ; 03BBA:  95 7a
            lda $2a,x                   ; 03BBC:  b5 2a
            cmp #$30                    ; 03BBE:  c9 30
            bne b0_bbe8                 ; 03BC0:  d0 26
            lda #$00                    ; 03BC2:  a9 00
            sta $2a,x                   ; 03BC4:  95 2a
            jmp b0_bbf4                 ; 03BC6:  4c f4 bb

b0_bbc9:    txa                         ; 03BC9:  8a
            clc                         ; 03BCA:  18
            adc #$0d                    ; 03BCB:  69 0d
            tax                         ; 03BCD:  aa
            lda #$50                    ; 03BCE:  a9 50
            sta $00                     ; 03BD0:  85 00
            lda #$06                    ; 03BD2:  a9 06
            sta $02                     ; 03BD4:  85 02
            lsr a                       ; 03BD6:  4a
            sta $01                     ; 03BD7:  85 01
            lda #$00                    ; 03BD9:  a9 00
            jsr tab_b0_bfd7             ; 03BDB:  20 d7 bf
            ldx $08                     ; 03BDE:  a6 08
            lda $ac,x                   ; 03BE0:  b5 ac
            cmp #$05                    ; 03BE2:  c9 05
            bne b0_bbe8                 ; 03BE4:  d0 02
            inc $2a,x                   ; 03BE6:  f6 2a
b0_bbe8:    jsr $f148                   ; 03BE8:  20 48 f1
            jsr $f19b                   ; 03BEB:  20 9b f1
            jsr $e236                   ; 03BEE:  20 36 e2
            jsr $e686                   ; 03BF1:  20 86 e6
b0_bbf4:    dex                         ; 03BF4:  ca
            bpl b0_bb98                 ; 03BF5:  10 a1
            rts                         ; 03BF7:  60

tab_b0_bbf8: ; 6 bytes
            hex 17 1d 0b 11 02 13       ; 03BF8:  17 1d 0b 11 02 13

b0_bbfe:    lda #$01                    ; 03BFE:  a9 01
            sta $0139                   ; 03C00:  8d 39 01
            ldx $0753                   ; 03C03:  ae 53 07
            ldy tab_b0_bbf8,x           ; 03C06:  bc f8 bb
            jsr b0_8f5f                 ; 03C09:  20 5f 8f
            inc $075e                   ; 03C0C:  ee 5e 07
            lda $075e                   ; 03C0F:  ad 5e 07
            cmp #$64                    ; 03C12:  c9 64
            bne b0_bc22                 ; 03C14:  d0 0c
            lda #$00                    ; 03C16:  a9 00
            sta $075e                   ; 03C18:  8d 5e 07
            inc $075a                   ; 03C1B:  ee 5a 07
            lda #$40                    ; 03C1E:  a9 40
            sta $fe                     ; 03C20:  85 fe
b0_bc22:    lda #$02                    ; 03C22:  a9 02
            sta $0138                   ; 03C24:  8d 38 01
b0_bc27:    ldx $0753                   ; 03C27:  ae 53 07
            ldy tab_b0_bbf8+2,x         ; 03C2A:  bc fa bb
            jsr b0_8f5f                 ; 03C2D:  20 5f 8f
b0_bc30:    ldy $0753                   ; 03C30:  ac 53 07
            lda tab_b0_bbf8+4,y         ; 03C33:  b9 fc bb
b0_bc36:    jsr b0_8f04+2               ; 03C36:  20 06 8f
            ldy $0300                   ; 03C39:  ac 00 03
            lda $02fb,y                 ; 03C3C:  b9 fb 02
            bne b0_bc46                 ; 03C3F:  d0 05
            lda #$24                    ; 03C41:  a9 24
            sta $02fb,y                 ; 03C43:  99 fb 02
b0_bc46:    ldx $08                     ; 03C46:  a6 08
            rts                         ; 03C48:  60

b0_bc49:    lda #$2e                    ; 03C49:  a9 2e
            sta $1b                     ; 03C4B:  85 1b
            lda $76,x                   ; 03C4D:  b5 76
            sta $73                     ; 03C4F:  85 73
            lda $8f,x                   ; 03C51:  b5 8f
            sta $8c                     ; 03C53:  85 8c
            lda #$01                    ; 03C55:  a9 01
            sta $bb                     ; 03C57:  85 bb
            lda $d7,x                   ; 03C59:  b5 d7
            sec                         ; 03C5B:  38
            sbc #$08                    ; 03C5C:  e9 08
            sta $d4                     ; 03C5E:  85 d4
            lda #$01                    ; 03C60:  a9 01
            sta $23                     ; 03C62:  85 23
            sta $14                     ; 03C64:  85 14
            lda #$03                    ; 03C66:  a9 03
            sta $049f                   ; 03C68:  8d 9f 04
            lda $39                     ; 03C6B:  a5 39
            cmp #$02                    ; 03C6D:  c9 02
            bcs b0_bc7b                 ; 03C6F:  b0 0a
            lda $0756                   ; 03C71:  ad 56 07
            cmp #$02                    ; 03C74:  c9 02
            bcc b0_bc79                 ; 03C76:  90 01
            lsr a                       ; 03C78:  4a
b0_bc79:    sta $39                     ; 03C79:  85 39
b0_bc7b:    lda #$20                    ; 03C7B:  a9 20
            sta $03ca                   ; 03C7D:  8d ca 03
            lda #$02                    ; 03C80:  a9 02
            sta $fe                     ; 03C82:  85 fe
            rts                         ; 03C84:  60

            ldx #$05                    ; 03C85:  a2 05
            stx $08                     ; 03C87:  86 08
            lda $23                     ; 03C89:  a5 23
            beq b0_bcea                 ; 03C8B:  f0 5d
            asl a                       ; 03C8D:  0a
            bcc b0_bcb3                 ; 03C8E:  90 23
            lda $0747                   ; 03C90:  ad 47 07
            bne b0_bcd8                 ; 03C93:  d0 43
            lda $39                     ; 03C95:  a5 39
            beq b0_bcaa                 ; 03C97:  f0 11
            cmp #$03                    ; 03C99:  c9 03
            beq b0_bcaa                 ; 03C9B:  f0 0d
            cmp #$02                    ; 03C9D:  c9 02
            bne b0_bcd8                 ; 03C9F:  d0 37
            jsr $caf9                   ; 03CA1:  20 f9 ca
            jsr $e163                   ; 03CA4:  20 63 e1
            jmp b0_bcd8                 ; 03CA7:  4c d8 bc

b0_bcaa:    jsr $ca77                   ; 03CAA:  20 77 ca
            jsr $dfc1                   ; 03CAD:  20 c1 df
            jmp b0_bcd8                 ; 03CB0:  4c d8 bc

b0_bcb3:    lda $09                     ; 03CB3:  a5 09
            and #$03                    ; 03CB5:  29 03
            bne b0_bcd2                 ; 03CB7:  d0 19
            dec $d4                     ; 03CB9:  c6 d4
            lda $23                     ; 03CBB:  a5 23
            inc $23                     ; 03CBD:  e6 23
            cmp #$11                    ; 03CBF:  c9 11
            bcc b0_bcd2                 ; 03CC1:  90 0f
            lda #$10                    ; 03CC3:  a9 10
            sta $58,x                   ; 03CC5:  95 58
            lda #$80                    ; 03CC7:  a9 80
            sta $23                     ; 03CC9:  85 23
            asl a                       ; 03CCB:  0a
            sta $03ca                   ; 03CCC:  8d ca 03
            rol a                       ; 03CCF:  2a
            sta $46,x                   ; 03CD0:  95 46
b0_bcd2:    lda $23                     ; 03CD2:  a5 23
            cmp #$06                    ; 03CD4:  c9 06
            bcc b0_bcea                 ; 03CD6:  90 12
b0_bcd8:    jsr $f152                   ; 03CD8:  20 52 f1
            jsr $f1af                   ; 03CDB:  20 af f1
            jsr $e243                   ; 03CDE:  20 43 e2
            jsr $e6d2                   ; 03CE1:  20 d2 e6
            jsr $d853                   ; 03CE4:  20 53 d8
            jsr $d67a                   ; 03CE7:  20 7a d6
b0_bcea:    rts                         ; 03CEA:  60

tab_b0_bceb: ; 2 bytes
            hex 04 12                   ; 03CEB:  04 12

            pha                         ; 03CED:  48
            lda #$11                    ; 03CEE:  a9 11
            ldx $03ee                   ; 03CF0:  ae ee 03
            ldy $0754                   ; 03CF3:  ac 54 07
            bne b0_bcfa                 ; 03CF6:  d0 02
            lda #$12                    ; 03CF8:  a9 12
b0_bcfa:    sta $26,x                   ; 03CFA:  95 26
            jsr b0_8a6b                 ; 03CFC:  20 6b 8a
            ldx $03ee                   ; 03CFF:  ae ee 03
            lda $02                     ; 03D02:  a5 02
            sta $03e4,x                 ; 03D04:  9d e4 03
            tay                         ; 03D07:  a8
            lda $06                     ; 03D08:  a5 06
            sta $03e6,x                 ; 03D0A:  9d e6 03
            lda ($06),y                 ; 03D0D:  b1 06
            jsr b0_bdf4+2               ; 03D0F:  20 f6 bd
            sta $00                     ; 03D12:  85 00
            ldy $0754                   ; 03D14:  ac 54 07
            bne b0_bd1a                 ; 03D17:  d0 01
            tya                         ; 03D19:  98
b0_bd1a:    bcc b0_bd41                 ; 03D1A:  90 25
            ldy #$11                    ; 03D1C:  a0 11
            sty $26,x                   ; 03D1E:  94 26
            lda #$c4                    ; 03D20:  a9 c4
            ldy $00                     ; 03D22:  a4 00
            cpy #$58                    ; 03D24:  c0 58
            beq b0_bd2c                 ; 03D26:  f0 04
            cpy #$5d                    ; 03D28:  c0 5d
            bne b0_bd41                 ; 03D2A:  d0 15
b0_bd2c:    lda $06bc                   ; 03D2C:  ad bc 06
            bne b0_bd39                 ; 03D2F:  d0 08
            lda #$0b                    ; 03D31:  a9 0b
            sta $079d                   ; 03D33:  8d 9d 07
            inc $06bc                   ; 03D36:  ee bc 06
b0_bd39:    lda $079d                   ; 03D39:  ad 9d 07
            bne b0_bd40                 ; 03D3C:  d0 02
            ldy #$c4                    ; 03D3E:  a0 c4
b0_bd40:    tya                         ; 03D40:  98
b0_bd41:    sta $03e8,x                 ; 03D41:  9d e8 03
            jsr b0_bd84                 ; 03D44:  20 84 bd
            ldy $02                     ; 03D47:  a4 02
            lda #$23                    ; 03D49:  a9 23
            sta ($06),y                 ; 03D4B:  91 06
            lda #$10                    ; 03D4D:  a9 10
            sta $0784                   ; 03D4F:  8d 84 07
            pla                         ; 03D52:  68
            sta $05                     ; 03D53:  85 05
            ldy #$00                    ; 03D55:  a0 00
            lda $0714                   ; 03D57:  ad 14 07
            bne b0_bd61                 ; 03D5A:  d0 05
            lda $0754                   ; 03D5C:  ad 54 07
            beq b0_bd62                 ; 03D5F:  f0 01
b0_bd61:    iny                         ; 03D61:  c8
b0_bd62:    lda $ce                     ; 03D62:  a5 ce
            clc                         ; 03D64:  18
            adc tab_b0_bceb,y           ; 03D65:  79 eb bc
            and #$f0                    ; 03D68:  29 f0
            sta $d7,x                   ; 03D6A:  95 d7
            ldy $26,x                   ; 03D6C:  b4 26
            cpy #$11                    ; 03D6E:  c0 11
            beq b0_bd78                 ; 03D70:  f0 06
            jsr b0_be02                 ; 03D72:  20 02 be
            jmp b0_bd7b                 ; 03D75:  4c 7b bd

b0_bd78:    jsr tab_b0_bd9b             ; 03D78:  20 9b bd
b0_bd7b:    lda $03ee                   ; 03D7B:  ad ee 03
            eor #$01                    ; 03D7E:  49 01
            sta $03ee                   ; 03D80:  8d ee 03
            rts                         ; 03D83:  60

b0_bd84:    lda $86                     ; 03D84:  a5 86
            clc                         ; 03D86:  18
            adc #$08                    ; 03D87:  69 08
            and #$f0                    ; 03D89:  29 f0
            sta $8f,x                   ; 03D8B:  95 8f
            lda $6d                     ; 03D8D:  a5 6d
            adc #$00                    ; 03D8F:  69 00
            sta $76,x                   ; 03D91:  95 76
            sta $03ea,x                 ; 03D93:  9d ea 03
            lda $b5                     ; 03D96:  a5 b5
            sta $be,x                   ; 03D98:  95 be
            rts                         ; 03D9A:  60

tab_b0_bd9b: ; 53 bytes
            hex 20 1f be a9 02 85 ff a9 ; 03D9B:  20 1f be a9 02 85 ff a9
            hex 00 95 60 9d 3c 04 85 9f ; 03DA3:  00 95 60 9d 3c 04 85 9f
            hex a9 fe 95 a8 a5 05 20 f6 ; 03DAB:  a9 fe 95 a8 a5 05 20 f6
            hex bd 90 31 98 c9 09 90 02 ; 03DB3:  bd 90 31 98 c9 09 90 02
            hex e9 05 20 04 8e d2 bd 38 ; 03DBB:  e9 05 20 04 8e d2 bd 38
            hex bb 38 bb d8 bd d2 bd df ; 03DC3:  bb 38 bb d8 bd d2 bd df
            hex bd d5 bd 38 bb          ; 03DCB:  bd d5 bd 38 bb

            cld                         ; 03DD0:  d8
            hex bd a9 00 ; lda $00a9,x  ; 03DD1:  bd a9 00
            bit $02a9                   ; 03DD4:  2c a9 02
            bit $03a9                   ; 03DD7:  2c a9 03
            sta $39                     ; 03DDA:  85 39
            jmp b0_bc49                 ; 03DDC:  4c 49 bc

            ldx #$05                    ; 03DDF:  a2 05
            ldy $03ee                   ; 03DE1:  ac ee 03
            jsr b0_b91e                 ; 03DE4:  20 1e b9
            rts                         ; 03DE7:  60

tab_b0_bde8: ; 12 bytes
            hex c1 c0 5f 60 55 56 57 58 ; 03DE8:  c1 c0 5f 60 55 56 57 58
            hex 59 5a 5b 5c             ; 03DF0:  59 5a 5b 5c

b0_bdf4:    eor tab_b0_9f40+286,x       ; 03DF4:  5d 5e a0
b0_bdf7:    ora $e8d9                   ; 03DF7:  0d d9 e8
            lda $04f0,x                 ; 03DFA:  bd f0 04
            dey                         ; 03DFD:  88
            bpl b0_bdf7+1               ; 03DFE:  10 f8
            clc                         ; 03E00:  18
            rts                         ; 03E01:  60

b0_be02:    jsr b0_be1f                 ; 03E02:  20 1f be
            lda #$01                    ; 03E05:  a9 01
            sta $03ec,x                 ; 03E07:  9d ec 03
            sta $fd                     ; 03E0A:  85 fd
            jsr b0_be41                 ; 03E0C:  20 41 be
            lda #$fe                    ; 03E0F:  a9 fe
            sta $9f                     ; 03E11:  85 9f
            lda #$05                    ; 03E13:  a9 05
            sta $0139                   ; 03E15:  8d 39 01
            jsr b0_bc27                 ; 03E18:  20 27 bc
            ldx $03ee                   ; 03E1B:  ae ee 03
            rts                         ; 03E1E:  60

b0_be1f:    ldx $03ee                   ; 03E1F:  ae ee 03
            ldy $02                     ; 03E22:  a4 02
            beq b0_be40                 ; 03E24:  f0 1a
            tya                         ; 03E26:  98
            sec                         ; 03E27:  38
            sbc #$10                    ; 03E28:  e9 10
            sta $02                     ; 03E2A:  85 02
            tay                         ; 03E2C:  a8
            lda ($06),y                 ; 03E2D:  b1 06
            cmp #$c2                    ; 03E2F:  c9 c2
            bne b0_be40                 ; 03E31:  d0 0d
            lda #$00                    ; 03E33:  a9 00
            sta ($06),y                 ; 03E35:  91 06
            jsr tab_b0_8a39+20          ; 03E37:  20 4d 8a
            ldx $03ee                   ; 03E3A:  ae ee 03
            jsr b0_bb51                 ; 03E3D:  20 51 bb
b0_be40:    rts                         ; 03E40:  60

b0_be41:    lda $8f,x                   ; 03E41:  b5 8f
            sta $03f1,x                 ; 03E43:  9d f1 03
            lda #$f0                    ; 03E46:  a9 f0
            sta $60,x                   ; 03E48:  95 60
            sta $62,x                   ; 03E4A:  95 62
            lda #$fa                    ; 03E4C:  a9 fa
            sta $a8,x                   ; 03E4E:  95 a8
            lda #$fc                    ; 03E50:  a9 fc
            sta $aa,x                   ; 03E52:  95 aa
            lda #$00                    ; 03E54:  a9 00
            sta $043c,x                 ; 03E56:  9d 3c 04
            sta $043e,x                 ; 03E59:  9d 3e 04
            lda $76,x                   ; 03E5C:  b5 76
            sta $78,x                   ; 03E5E:  95 78
            lda $8f,x                   ; 03E60:  b5 8f
            sta $91,x                   ; 03E62:  95 91
            lda $d7,x                   ; 03E64:  b5 d7
            clc                         ; 03E66:  18
            adc #$08                    ; 03E67:  69 08
            sta $d9,x                   ; 03E69:  95 d9
            lda #$fa                    ; 03E6B:  a9 fa
            sta $a8,x                   ; 03E6D:  95 a8
            rts                         ; 03E6F:  60

b0_be70:    lda $26,x                   ; 03E70:  b5 26
            beq b0_bed1                 ; 03E72:  f0 5d
            and #$0f                    ; 03E74:  29 0f
            pha                         ; 03E76:  48
            tay                         ; 03E77:  a8
            txa                         ; 03E78:  8a
            clc                         ; 03E79:  18
            adc #$09                    ; 03E7A:  69 09
            tax                         ; 03E7C:  aa
            dey                         ; 03E7D:  88
            beq b0_beb3                 ; 03E7E:  f0 33
            jsr b0_bfa3+1               ; 03E80:  20 a4 bf
            jsr b0_bf0f                 ; 03E83:  20 0f bf
            txa                         ; 03E86:  8a
            clc                         ; 03E87:  18
            adc #$02                    ; 03E88:  69 02
            tax                         ; 03E8A:  aa
            jsr b0_bfa3+1               ; 03E8B:  20 a4 bf
            jsr b0_bf0f                 ; 03E8E:  20 0f bf
            ldx $08                     ; 03E91:  a6 08
            jsr $f159                   ; 03E93:  20 59 f1
            jsr $f1b6                   ; 03E96:  20 b6 f1
            jsr $ec53                   ; 03E99:  20 53 ec
            pla                         ; 03E9C:  68
            ldy $be,x                   ; 03E9D:  b4 be
            beq b0_bed1                 ; 03E9F:  f0 30
            pha                         ; 03EA1:  48
            lda #$f0                    ; 03EA2:  a9 f0
            cmp $d9,x                   ; 03EA4:  d5 d9
            bcs b0_beaa                 ; 03EA6:  b0 02
            sta $d9,x                   ; 03EA8:  95 d9
b0_beaa:    lda $d7,x                   ; 03EAA:  b5 d7
            cmp #$f0                    ; 03EAC:  c9 f0
            pla                         ; 03EAE:  68
            bcc b0_bed1                 ; 03EAF:  90 20
            bcs b0_becf                 ; 03EB1:  b0 1c
b0_beb3:    jsr b0_bfa3+1               ; 03EB3:  20 a4 bf
            ldx $08                     ; 03EB6:  a6 08
            jsr $f159                   ; 03EB8:  20 59 f1
            jsr $f1b6                   ; 03EBB:  20 b6 f1
            jsr $ebd1                   ; 03EBE:  20 d1 eb
            lda $d7,x                   ; 03EC1:  b5 d7
            and #$0f                    ; 03EC3:  29 0f
            cmp #$05                    ; 03EC5:  c9 05
            pla                         ; 03EC7:  68
            bcs b0_bed1                 ; 03EC8:  b0 07
            lda #$01                    ; 03ECA:  a9 01
            sta $03ec,x                 ; 03ECC:  9d ec 03
b0_becf:    lda #$00                    ; 03ECF:  a9 00
b0_bed1:    sta $26,x                   ; 03ED1:  95 26
            rts                         ; 03ED3:  60

b0_bed4:    ldx #$01                    ; 03ED4:  a2 01
b0_bed6:    stx $08                     ; 03ED6:  86 08
            lda $0301                   ; 03ED8:  ad 01 03
            bne b0_befe                 ; 03EDB:  d0 21
            lda $03ec,x                 ; 03EDD:  bd ec 03
            beq b0_befe                 ; 03EE0:  f0 1c
            lda $03e6,x                 ; 03EE2:  bd e6 03
            sta $06                     ; 03EE5:  85 06
            lda #$05                    ; 03EE7:  a9 05
            sta $07                     ; 03EE9:  85 07
            lda $03e4,x                 ; 03EEB:  bd e4 03
            sta $02                     ; 03EEE:  85 02
            tay                         ; 03EF0:  a8
            lda $03e8,x                 ; 03EF1:  bd e8 03
            sta ($06),y                 ; 03EF4:  91 06
            jsr b0_8a61                 ; 03EF6:  20 61 8a
            lda #$00                    ; 03EF9:  a9 00
            sta $03ec,x                 ; 03EFB:  9d ec 03
b0_befe:    dex                         ; 03EFE:  ca
            bpl b0_bed6                 ; 03EFF:  10 d5
            rts                         ; 03F01:  60

b0_bf02:    inx                         ; 03F02:  e8
            jsr b0_bf0f                 ; 03F03:  20 0f bf
            ldx $08                     ; 03F06:  a6 08
            rts                         ; 03F08:  60

b0_bf09:    lda $070e                   ; 03F09:  ad 0e 07
            bne b0_bf4c                 ; 03F0C:  d0 3e
            tax                         ; 03F0E:  aa
b0_bf0f:    lda $57,x                   ; 03F0F:  b5 57
            asl a                       ; 03F11:  0a
            asl a                       ; 03F12:  0a
            asl a                       ; 03F13:  0a
            asl a                       ; 03F14:  0a
            sta $01                     ; 03F15:  85 01
            lda $57,x                   ; 03F17:  b5 57
            lsr a                       ; 03F19:  4a
            lsr a                       ; 03F1A:  4a
            lsr a                       ; 03F1B:  4a
            lsr a                       ; 03F1C:  4a
            cmp #$08                    ; 03F1D:  c9 08
            bcc b0_bf23                 ; 03F1F:  90 02
            ora #$f0                    ; 03F21:  09 f0
b0_bf23:    sta $00                     ; 03F23:  85 00
            ldy #$00                    ; 03F25:  a0 00
            cmp #$00                    ; 03F27:  c9 00
            bpl b0_bf2c                 ; 03F29:  10 01
            dey                         ; 03F2B:  88
b0_bf2c:    sty $02                     ; 03F2C:  84 02
            lda $0400,x                 ; 03F2E:  bd 00 04
            clc                         ; 03F31:  18
            adc $01                     ; 03F32:  65 01
            sta $0400,x                 ; 03F34:  9d 00 04
            lda #$00                    ; 03F37:  a9 00
            rol a                       ; 03F39:  2a
            pha                         ; 03F3A:  48
            ror a                       ; 03F3B:  6a
            lda $86,x                   ; 03F3C:  b5 86
            adc $00                     ; 03F3E:  65 00
            sta $86,x                   ; 03F40:  95 86
            lda $6d,x                   ; 03F42:  b5 6d
            adc $02                     ; 03F44:  65 02
            sta $6d,x                   ; 03F46:  95 6d
            pla                         ; 03F48:  68
            clc                         ; 03F49:  18
            adc $00                     ; 03F4A:  65 00
b0_bf4c:    rts                         ; 03F4C:  60

b0_bf4d:    ldx #$00                    ; 03F4D:  a2 00
            lda $0747                   ; 03F4F:  ad 47 07
            bne b0_bf59                 ; 03F52:  d0 05
            lda $070e                   ; 03F54:  ad 0e 07
            bne b0_bf4c                 ; 03F57:  d0 f3
b0_bf59:    lda $0709                   ; 03F59:  ad 09 07
            sta $00                     ; 03F5C:  85 00
            lda #$04                    ; 03F5E:  a9 04
            jmp b0_bfad                 ; 03F60:  4c ad bf

b0_bf63:    ldy #$3d                    ; 03F63:  a0 3d
            lda $1e,x                   ; 03F65:  b5 1e
            cmp #$05                    ; 03F67:  c9 05
            bne b0_bf6d                 ; 03F69:  d0 02
            ldy #$20                    ; 03F6B:  a0 20
b0_bf6d:    jmp b0_bf94                 ; 03F6D:  4c 94 bf

            ldy #$00                    ; 03F70:  a0 00
            jmp b0_bf77                 ; 03F72:  4c 77 bf

            ldy #$01                    ; 03F75:  a0 01
b0_bf77:    inx                         ; 03F77:  e8
            lda #$03                    ; 03F78:  a9 03
            sta $00                     ; 03F7A:  85 00
            lda #$06                    ; 03F7C:  a9 06
            sta $01                     ; 03F7E:  85 01
            lda #$02                    ; 03F80:  a9 02
            sta $02                     ; 03F82:  85 02
            tya                         ; 03F84:  98
            jmp b0_bfd1                 ; 03F85:  4c d1 bf

            ldy #$7f                    ; 03F88:  a0 7f
            bne b0_bf8e                 ; 03F8A:  d0 02
            ldy #$0f                    ; 03F8C:  a0 0f
b0_bf8e:    lda #$02                    ; 03F8E:  a9 02
            bne b0_bf96                 ; 03F90:  d0 04
            ldy #$1c                    ; 03F92:  a0 1c
b0_bf94:    lda #$03                    ; 03F94:  a9 03
b0_bf96:    sty $00                     ; 03F96:  84 00
            inx                         ; 03F98:  e8
            jsr b0_bfad                 ; 03F99:  20 ad bf
            ldx $08                     ; 03F9C:  a6 08
            rts                         ; 03F9E:  60

b0_bf9f:    asl $08                     ; 03F9F:  06 08
            ldy #$00                    ; 03FA1:  a0 00
b0_bfa3:    bit $01a0                   ; 03FA3:  2c a0 01
            lda #$50                    ; 03FA6:  a9 50
            sta $00                     ; 03FA8:  85 00
            lda b0_bf9f,y               ; 03FAA:  b9 9f bf
b0_bfad:    sta $02                     ; 03FAD:  85 02
            lda #$00                    ; 03FAF:  a9 00
            jmp tab_b0_bfd7             ; 03FB1:  4c d7 bf

            lda #$00                    ; 03FB4:  a9 00
            bit $01a9                   ; 03FB6:  2c a9 01
            pha                         ; 03FB9:  48
            ldy $16,x                   ; 03FBA:  b4 16
            inx                         ; 03FBC:  e8
            lda #$05                    ; 03FBD:  a9 05
            cpy #$29                    ; 03FBF:  c0 29
            bne b0_bfc5                 ; 03FC1:  d0 02
            lda #$09                    ; 03FC3:  a9 09
b0_bfc5:    sta $00                     ; 03FC5:  85 00
            lda #$0a                    ; 03FC7:  a9 0a
            sta $01                     ; 03FC9:  85 01
            lda #$03                    ; 03FCB:  a9 03
            sta $02                     ; 03FCD:  85 02
            pla                         ; 03FCF:  68
            tay                         ; 03FD0:  a8
b0_bfd1:    jsr tab_b0_bfd7             ; 03FD1:  20 d7 bf
            ldx $08                     ; 03FD4:  a6 08
            rts                         ; 03FD6:  60

tab_b0_bfd7: ; 41 bytes
            hex 48 bd 16 04 18 7d 33 04 ; 03FD7:  48 bd 16 04 18 7d 33 04
            hex 9d 16 04 a0 00 b5 9f 10 ; 03FDF:  9d 16 04 a0 00 b5 9f 10
            hex 01 88 84 07 75 ce 95 ce ; 03FE7:  01 88 84 07 75 ce 95 ce
            hex b5 b5 65 07 95 b5 bd 33 ; 03FEF:  b5 b5 65 07 95 b5 bd 33
            hex 04 18 65 00 9d 33 04 b5 ; 03FF7:  04 18 65 00 9d 33 04 b5
            hex 9f                      ; 03FFF:  9f



.base $c000

            adc #$00                    ; 04000:  69 00
            sta $9f,x                   ; 04002:  95 9f
            cmp $02                     ; 04004:  c5 02
            bmi b1_c018                 ; 04006:  30 10
            lda $0433,x                 ; 04008:  bd 33 04
            cmp #$80                    ; 0400B:  c9 80
            bcc b1_c018                 ; 0400D:  90 09
            lda $02                     ; 0400F:  a5 02
            sta $9f,x                   ; 04011:  95 9f
            lda #$00                    ; 04013:  a9 00
            sta $0433,x                 ; 04015:  9d 33 04
b1_c018:    pla                         ; 04018:  68
            beq b1_c046                 ; 04019:  f0 2b
            lda $02                     ; 0401B:  a5 02
            eor #$ff                    ; 0401D:  49 ff
            tay                         ; 0401F:  a8
            iny                         ; 04020:  c8
            sty $07                     ; 04021:  84 07
            lda $0433,x                 ; 04023:  bd 33 04
            sec                         ; 04026:  38
            sbc $01                     ; 04027:  e5 01
            sta $0433,x                 ; 04029:  9d 33 04
            lda $9f,x                   ; 0402C:  b5 9f
            sbc #$00                    ; 0402E:  e9 00
            sta $9f,x                   ; 04030:  95 9f
            cmp $07                     ; 04032:  c5 07
            bpl b1_c046                 ; 04034:  10 10
            lda $0433,x                 ; 04036:  bd 33 04
            cmp #$80                    ; 04039:  c9 80
            bcs b1_c046                 ; 0403B:  b0 09
            lda $07                     ; 0403D:  a5 07
            sta $9f,x                   ; 0403F:  95 9f
            lda #$ff                    ; 04041:  a9 ff
            sta $0433,x                 ; 04043:  9d 33 04
b1_c046:    rts                         ; 04046:  60

            lda $0f,x                   ; 04047:  b5 0f
            pha                         ; 04049:  48
            asl a                       ; 0404A:  0a
            bcs b1_c05f                 ; 0404B:  b0 12
            pla                         ; 0404D:  68
            beq b1_c053                 ; 0404E:  f0 03
            jmp tab_b1_c881+1           ; 04050:  4c 82 c8

b1_c053:    lda $071f                   ; 04053:  ad 1f 07
            and #$07                    ; 04056:  29 07
            cmp #$07                    ; 04058:  c9 07
            beq b1_c06a                 ; 0405A:  f0 0e
            jmp b1_c0cc                 ; 0405C:  4c cc c0

b1_c05f:    pla                         ; 0405F:  68
            and #$0f                    ; 04060:  29 0f
            tay                         ; 04062:  a8
            hex b9 0f 00 ; lda $000f,y  ; 04063:  b9 0f 00
            bne b1_c06a                 ; 04066:  d0 02
            sta $0f,x                   ; 04068:  95 0f
b1_c06a:    rts                         ; 0406A:  60

tab_b1_c06b: ; 38 bytes
            hex 03 03 06 06 06 06 06 06 ; 0406B:  03 03 06 06 06 06 06 06
            hex 07 07 07 05 09 04 05 06 ; 04073:  07 07 07 05 09 04 05 06
            hex 08 09 0a 06 0b 10 40 b0 ; 0407B:  08 09 0a 06 0b 10 40 b0
            hex b0 80 40 40 80 40 f0 f0 ; 04083:  b0 80 40 40 80 40 f0 f0
            hex f0 a5 6d 38 e9 04       ; 0408B:  f0 a5 6d 38 e9 04

            sta $6d                     ; 04091:  85 6d
            lda $0725                   ; 04093:  ad 25 07
            sec                         ; 04096:  38
            sbc #$04                    ; 04097:  e9 04
            sta $0725                   ; 04099:  8d 25 07
            lda $071a                   ; 0409C:  ad 1a 07
            sec                         ; 0409F:  38
            sbc #$04                    ; 040A0:  e9 04
            sta $071a                   ; 040A2:  8d 1a 07
            lda $071b                   ; 040A5:  ad 1b 07
            sec                         ; 040A8:  38
            sbc #$04                    ; 040A9:  e9 04
            sta $071b                   ; 040AB:  8d 1b 07
            lda $072a                   ; 040AE:  ad 2a 07
            sec                         ; 040B1:  38
            sbc #$04                    ; 040B2:  e9 04
            sta $072a                   ; 040B4:  8d 2a 07
            lda #$00                    ; 040B7:  a9 00
            sta $073b                   ; 040B9:  8d 3b 07
            sta $072b                   ; 040BC:  8d 2b 07
            sta $0739                   ; 040BF:  8d 39 07
            sta $073a                   ; 040C2:  8d 3a 07
            lda $9bf8,y                 ; 040C5:  b9 f8 9b
            sta $072c                   ; 040C8:  8d 2c 07
            rts                         ; 040CB:  60

b1_c0cc:    lda $0745                   ; 040CC:  ad 45 07
            beq b1_c12f                 ; 040CF:  f0 5e
            lda $0726                   ; 040D1:  ad 26 07
            bne b1_c12f                 ; 040D4:  d0 59
            ldy #$0b                    ; 040D6:  a0 0b
b1_c0d8:    dey                         ; 040D8:  88
            bmi b1_c12f                 ; 040D9:  30 54
            lda $075f                   ; 040DB:  ad 5f 07
            cmp tab_b1_c06b,y           ; 040DE:  d9 6b c0
            bne b1_c0d8                 ; 040E1:  d0 f5
            lda $0725                   ; 040E3:  ad 25 07
            cmp tab_b1_c06b+11,y        ; 040E6:  d9 76 c0
            bne b1_c0d8                 ; 040E9:  d0 ed
            lda $ce                     ; 040EB:  a5 ce
            cmp tab_b1_c06b+22,y        ; 040ED:  d9 81 c0
            bne b1_c115                 ; 040F0:  d0 23
            lda $1d                     ; 040F2:  a5 1d
            cmp #$00                    ; 040F4:  c9 00
            bne b1_c115                 ; 040F6:  d0 1d
            lda $075f                   ; 040F8:  ad 5f 07
            cmp #$06                    ; 040FB:  c9 06
            bne b1_c122                 ; 040FD:  d0 23
            inc $06d9                   ; 040FF:  ee d9 06
b1_c102:    inc $06da                   ; 04102:  ee da 06
            lda $06da                   ; 04105:  ad da 06
            cmp #$03                    ; 04108:  c9 03
            bne b1_c12a                 ; 0410A:  d0 1e
            lda $06d9                   ; 0410C:  ad d9 06
            cmp #$03                    ; 0410F:  c9 03
            beq b1_c122                 ; 04111:  f0 0f
            bne b1_c11c                 ; 04113:  d0 07
b1_c115:    lda $075f                   ; 04115:  ad 5f 07
            cmp #$06                    ; 04118:  c9 06
            beq b1_c102                 ; 0411A:  f0 e6
b1_c11c:    jsr tab_b1_c06b+33          ; 0411C:  20 8c c0
            jsr b1_d071                 ; 0411F:  20 71 d0
b1_c122:    lda #$00                    ; 04122:  a9 00
            sta $06da                   ; 04124:  8d da 06
            sta $06d9                   ; 04127:  8d d9 06
b1_c12a:    lda #$00                    ; 0412A:  a9 00
            sta $0745                   ; 0412C:  8d 45 07
b1_c12f:    lda $06cd                   ; 0412F:  ad cd 06
            beq b1_c144                 ; 04132:  f0 10
            sta $16,x                   ; 04134:  95 16
            lda #$01                    ; 04136:  a9 01
            sta $0f,x                   ; 04138:  95 0f
            lda #$00                    ; 0413A:  a9 00
            sta $1e,x                   ; 0413C:  95 1e
            sta $06cd                   ; 0413E:  8d cd 06
            jmp b1_c226                 ; 04141:  4c 26 c2

b1_c144:    ldy $0739                   ; 04144:  ac 39 07
            lda ($e9),y                 ; 04147:  b1 e9
            cmp #$ff                    ; 04149:  c9 ff
            bne b1_c150                 ; 0414B:  d0 03
            jmp b1_c216                 ; 0414D:  4c 16 c2

b1_c150:    and #$0f                    ; 04150:  29 0f
            cmp #$0e                    ; 04152:  c9 0e
            beq b1_c164                 ; 04154:  f0 0e
            cpx #$05                    ; 04156:  e0 05
            bcc b1_c164                 ; 04158:  90 0a
            iny                         ; 0415A:  c8
            lda ($e9),y                 ; 0415B:  b1 e9
            and #$3f                    ; 0415D:  29 3f
            cmp #$2e                    ; 0415F:  c9 2e
            beq b1_c164                 ; 04161:  f0 01
            rts                         ; 04163:  60

b1_c164:    lda $071d                   ; 04164:  ad 1d 07
            clc                         ; 04167:  18
            adc #$30                    ; 04168:  69 30
            and #$f0                    ; 0416A:  29 f0
            sta $07                     ; 0416C:  85 07
            lda $071b                   ; 0416E:  ad 1b 07
            adc #$00                    ; 04171:  69 00
            sta $06                     ; 04173:  85 06
            ldy $0739                   ; 04175:  ac 39 07
            iny                         ; 04178:  c8
            lda ($e9),y                 ; 04179:  b1 e9
            asl a                       ; 0417B:  0a
            bcc b1_c189                 ; 0417C:  90 0b
            lda $073b                   ; 0417E:  ad 3b 07
            bne b1_c189                 ; 04181:  d0 06
            inc $073b                   ; 04183:  ee 3b 07
            inc $073a                   ; 04186:  ee 3a 07
b1_c189:    dey                         ; 04189:  88
            lda ($e9),y                 ; 0418A:  b1 e9
            and #$0f                    ; 0418C:  29 0f
            cmp #$0f                    ; 0418E:  c9 0f
            bne b1_c1ab                 ; 04190:  d0 19
            lda $073b                   ; 04192:  ad 3b 07
            bne b1_c1ab                 ; 04195:  d0 14
            iny                         ; 04197:  c8
            lda ($e9),y                 ; 04198:  b1 e9
            and #$3f                    ; 0419A:  29 3f
            sta $073a                   ; 0419C:  8d 3a 07
            inc $0739                   ; 0419F:  ee 39 07
            inc $0739                   ; 041A2:  ee 39 07
            inc $073b                   ; 041A5:  ee 3b 07
            jmp b1_c0cc                 ; 041A8:  4c cc c0

b1_c1ab:    lda $073a                   ; 041AB:  ad 3a 07
            sta $6e,x                   ; 041AE:  95 6e
            lda ($e9),y                 ; 041B0:  b1 e9
            and #$f0                    ; 041B2:  29 f0
            sta $87,x                   ; 041B4:  95 87
            cmp $071d                   ; 041B6:  cd 1d 07
            lda $6e,x                   ; 041B9:  b5 6e
            sbc $071b                   ; 041BB:  ed 1b 07
            bcs b1_c1cb                 ; 041BE:  b0 0b
            lda ($e9),y                 ; 041C0:  b1 e9
            and #$0f                    ; 041C2:  29 0f
            cmp #$0e                    ; 041C4:  c9 0e
            beq b1_c231                 ; 041C6:  f0 69
            jmp b1_c250                 ; 041C8:  4c 50 c2

b1_c1cb:    lda $07                     ; 041CB:  a5 07
            cmp $87,x                   ; 041CD:  d5 87
            lda $06                     ; 041CF:  a5 06
            sbc $6e,x                   ; 041D1:  f5 6e
            bcc b1_c216                 ; 041D3:  90 41
            lda #$01                    ; 041D5:  a9 01
            sta $b6,x                   ; 041D7:  95 b6
            lda ($e9),y                 ; 041D9:  b1 e9
            asl a                       ; 041DB:  0a
            asl a                       ; 041DC:  0a
            asl a                       ; 041DD:  0a
            asl a                       ; 041DE:  0a
            sta $cf,x                   ; 041DF:  95 cf
            cmp #$e0                    ; 041E1:  c9 e0
            beq b1_c231                 ; 041E3:  f0 4c
            iny                         ; 041E5:  c8
            lda ($e9),y                 ; 041E6:  b1 e9
            and #$40                    ; 041E8:  29 40
            beq b1_c1f1                 ; 041EA:  f0 05
            lda $06cc                   ; 041EC:  ad cc 06
            beq b1_c25e                 ; 041EF:  f0 6d
b1_c1f1:    lda ($e9),y                 ; 041F1:  b1 e9
            and #$3f                    ; 041F3:  29 3f
            cmp #$37                    ; 041F5:  c9 37
            bcc b1_c1fd                 ; 041F7:  90 04
            cmp #$3f                    ; 041F9:  c9 3f
            bcc tab_b1_c22e             ; 041FB:  90 31
b1_c1fd:    cmp #$06                    ; 041FD:  c9 06
            bne b1_c208                 ; 041FF:  d0 07
            ldy $076a                   ; 04201:  ac 6a 07
            beq b1_c208                 ; 04204:  f0 02
            lda #$02                    ; 04206:  a9 02
b1_c208:    sta $16,x                   ; 04208:  95 16
            lda #$01                    ; 0420A:  a9 01
            sta $0f,x                   ; 0420C:  95 0f
            jsr b1_c226                 ; 0420E:  20 26 c2
            lda $0f,x                   ; 04211:  b5 0f
            bne b1_c25e                 ; 04213:  d0 49
            rts                         ; 04215:  60

b1_c216:    lda $06cb                   ; 04216:  ad cb 06
            bne b1_c224                 ; 04219:  d0 09
            lda $0398                   ; 0421B:  ad 98 03
            cmp #$01                    ; 0421E:  c9 01
            bne b1_c22d                 ; 04220:  d0 0b
            lda #$2f                    ; 04222:  a9 2f
b1_c224:    sta $16,x                   ; 04224:  95 16
b1_c226:    lda #$00                    ; 04226:  a9 00
            sta $1e,x                   ; 04228:  95 1e
            jsr tab_b1_c26c             ; 0422A:  20 6c c2
b1_c22d:    rts                         ; 0422D:  60

tab_b1_c22e: ; 3 bytes
            hex 4c 1b c7                ; 0422E:  4c 1b c7

b1_c231:    iny                         ; 04231:  c8
            iny                         ; 04232:  c8
            lda ($e9),y                 ; 04233:  b1 e9
            lsr a                       ; 04235:  4a
            lsr a                       ; 04236:  4a
            lsr a                       ; 04237:  4a
            lsr a                       ; 04238:  4a
            lsr a                       ; 04239:  4a
            cmp $075f                   ; 0423A:  cd 5f 07
            bne b1_c24d                 ; 0423D:  d0 0e
            dey                         ; 0423F:  88
            lda ($e9),y                 ; 04240:  b1 e9
            sta $0750                   ; 04242:  8d 50 07
            iny                         ; 04245:  c8
            lda ($e9),y                 ; 04246:  b1 e9
            and #$1f                    ; 04248:  29 1f
            sta $0751                   ; 0424A:  8d 51 07
b1_c24d:    jmp b1_c25b                 ; 0424D:  4c 5b c2

b1_c250:    ldy $0739                   ; 04250:  ac 39 07
            lda ($e9),y                 ; 04253:  b1 e9
            and #$0f                    ; 04255:  29 0f
            cmp #$0e                    ; 04257:  c9 0e
            bne b1_c25e                 ; 04259:  d0 03
b1_c25b:    inc $0739                   ; 0425B:  ee 39 07
b1_c25e:    inc $0739                   ; 0425E:  ee 39 07
            inc $0739                   ; 04261:  ee 39 07
            lda #$00                    ; 04264:  a9 00
            sta $073b                   ; 04266:  8d 3b 07
            ldx $08                     ; 04269:  a6 08
            rts                         ; 0426B:  60

tab_b1_c26c: ; 111 bytes
            hex b5 16 c9 15 b0 0d a8 b5 ; 0426C:  b5 16 c9 15 b0 0d a8 b5
            hex cf 69 08 95 cf a9 01 9d ; 04274:  cf 69 08 95 cf a9 01 9d
            hex d8 03 98 20 04 8e 0e c3 ; 0427C:  d8 03 98 20 04 8e 0e c3
            hex 0e c3 0e c3 1e c3 f0 c2 ; 04284:  0e c3 0e c3 1e c3 f0 c2
            hex 28 c3 f1 c2 42 c3 6b c3 ; 0428C:  28 c3 f1 c2 42 c3 6b c3
            hex f0 c2 75 c3 75 c3 f7 c2 ; 04294:  f0 c2 75 c3 75 c3 f7 c2
            hex 87 c7 d1 c7 4a c3 3d c3 ; 0429C:  87 c7 d1 c7 4a c3 3d c3
            hex 85 c3 a0 c7 f0 c2 a0 c7 ; 042A4:  85 c3 a0 c7 f0 c2 a0 c7
            hex a0 c7 a0 c7 a0 c7 b8 c7 ; 042AC:  a0 c7 a0 c7 a0 c7 b8 c7
            hex f0 c2 f0 c2 5c c4 5c c4 ; 042B4:  f0 c2 f0 c2 5c c4 5c c4
            hex 5c c4 5c c4 59 c4 f0 c2 ; 042BC:  5c c4 5c c4 59 c4 f0 c2
            hex f0 c2 f0 c2 f0 c2 df c7 ; 042C4:  f0 c2 f0 c2 f0 c2 df c7
            hex 12 c8 3f c8 45 c8 0b c8 ; 042CC:  12 c8 3f c8 45 c8 0b c8
            hex 03 c8 0b c8 4b c8 57    ; 042D4:  03 c8 0b c8 4b c8 57

            iny                         ; 042DB:  c8
            eor #$c5                    ; 042DC:  49 c5
            rts                         ; 042DE:  60

            hex bc 1e b9 f0 c2 f0 c2 f0 ; 042DF:  bc 1e b9 f0 c2 f0 c2 f0
            hex c2 f0 c2 f0 c2 07 c3    ; 042E7:  c2 f0 c2 f0 c2 07 c3

            sta ($c8,x)                 ; 042EE:  81 c8
            rts                         ; 042F0:  60

            jsr b1_c30e                 ; 042F1:  20 0e c3
            jmp b1_c346                 ; 042F4:  4c 46 c3

b1_c2f7:    lda #$02                    ; 042F7:  a9 02
            sta $b6,x                   ; 042F9:  95 b6
            sta $cf,x                   ; 042FB:  95 cf
            lsr a                       ; 042FD:  4a
            sta $0796,x                 ; 042FE:  9d 96 07
            lsr a                       ; 04301:  4a
            sta $1e,x                   ; 04302:  95 1e
            jmp b1_c346                 ; 04304:  4c 46 c3

            lda #$b8                    ; 04307:  a9 b8
            sta $cf,x                   ; 04309:  95 cf
            rts                         ; 0430B:  60

tab_b1_c30c: ; 2 bytes
            hex f8 f4                   ; 0430C:  f8 f4

b1_c30e:    ldy #$01                    ; 0430E:  a0 01
            lda $076a                   ; 04310:  ad 6a 07
            bne b1_c316                 ; 04313:  d0 01
            dey                         ; 04315:  88
b1_c316:    lda tab_b1_c30c,y           ; 04316:  b9 0c c3
b1_c319:    sta $58,x                   ; 04319:  95 58
            jmp b1_c35a                 ; 0431B:  4c 5a c3

            jsr b1_c30e                 ; 0431E:  20 0e c3
            lda #$01                    ; 04321:  a9 01
            sta $1e,x                   ; 04323:  95 1e
            rts                         ; 04325:  60

tab_b1_c326: ; 1 bytes
            hex 80                      ; 04326:  80

            bvc tab_b1_c26c+102         ; 04327:  50 a9
            brk                         ; 04329:  00
            hex 9d                      ; 0432A:  9d
            ldx #$03                    ; 0432B:  a2 03
            sta $58,x                   ; 0432D:  95 58
            ldy $06cc                   ; 0432F:  ac cc 06
            lda tab_b1_c326,y           ; 04332:  b9 26 c3
            sta $0796,x                 ; 04335:  9d 96 07
            lda #$0b                    ; 04338:  a9 0b
            jmp b1_c35c                 ; 0433A:  4c 5c c3

b1_c33d:    lda #$00                    ; 0433D:  a9 00
            jmp b1_c319                 ; 0433F:  4c 19 c3

            lda #$00                    ; 04342:  a9 00
            sta $58,x                   ; 04344:  95 58
b1_c346:    lda #$09                    ; 04346:  a9 09
            bne b1_c35c                 ; 04348:  d0 12
            ldy #$30                    ; 0434A:  a0 30
            lda $cf,x                   ; 0434C:  b5 cf
            sta $0401,x                 ; 0434E:  9d 01 04
            bpl b1_c355                 ; 04351:  10 02
            ldy #$e0                    ; 04353:  a0 e0
b1_c355:    tya                         ; 04355:  98
            adc $cf,x                   ; 04356:  75 cf
            sta $58,x                   ; 04358:  95 58
b1_c35a:    lda #$03                    ; 0435A:  a9 03
b1_c35c:    sta $049a,x                 ; 0435C:  9d 9a 04
            lda #$02                    ; 0435F:  a9 02
            sta $46,x                   ; 04361:  95 46
b1_c363:    lda #$00                    ; 04363:  a9 00
            sta $a0,x                   ; 04365:  95 a0
            sta $0434,x                 ; 04367:  9d 34 04
            rts                         ; 0436A:  60

            lda #$02                    ; 0436B:  a9 02
            sta $46,x                   ; 0436D:  95 46
            lda #$09                    ; 0436F:  a9 09
            sta $049a,x                 ; 04371:  9d 9a 04
            rts                         ; 04374:  60

            jsr b1_c346                 ; 04375:  20 46 c3
            lda $07a7,x                 ; 04378:  bd a7 07
            and #$10                    ; 0437B:  29 10
            sta $58,x                   ; 0437D:  95 58
            lda $cf,x                   ; 0437F:  b5 cf
            sta $0434,x                 ; 04381:  9d 34 04
            rts                         ; 04384:  60

            lda $06cb                   ; 04385:  ad cb 06
            bne tab_b1_c395             ; 04388:  d0 0b
b1_c38a:    lda #$00                    ; 0438A:  a9 00
            sta $06d1                   ; 0438C:  8d d1 06
            jsr b1_c33d                 ; 0438F:  20 3d c3
            jmp b1_c7d9                 ; 04392:  4c d9 c7

tab_b1_c395: ; 13 bytes
            hex 4c 98 c9 26 2c 32 38 20 ; 04395:  4c 98 c9 26 2c 32 38 20
            hex 22 24 26 13 14          ; 0439D:  22 24 26 13 14

            ora $16,x                   ; 043A2:  15 16
            lda $078f                   ; 043A4:  ad 8f 07
            bne b1_c3e5                 ; 043A7:  d0 3c
            cpx #$05                    ; 043A9:  e0 05
            bcs b1_c3e5                 ; 043AB:  b0 38
            lda #$80                    ; 043AD:  a9 80
            sta $078f                   ; 043AF:  8d 8f 07
            ldy #$04                    ; 043B2:  a0 04
b1_c3b4:    hex b9 16 00 ; lda $0016,y  ; 043B4:  b9 16 00
            cmp #$11                    ; 043B7:  c9 11
            beq b1_c3e6                 ; 043B9:  f0 2b
            dey                         ; 043BB:  88
            bpl b1_c3b4                 ; 043BC:  10 f6
            inc $06d1                   ; 043BE:  ee d1 06
            lda $06d1                   ; 043C1:  ad d1 06
            cmp #$07                    ; 043C4:  c9 07
            bcc b1_c3e5                 ; 043C6:  90 1d
            ldx #$04                    ; 043C8:  a2 04
b1_c3ca:    lda $0f,x                   ; 043CA:  b5 0f
            beq b1_c3d3                 ; 043CC:  f0 05
            dex                         ; 043CE:  ca
            bpl b1_c3ca                 ; 043CF:  10 f9
            bmi b1_c3e3                 ; 043D1:  30 10
b1_c3d3:    lda #$00                    ; 043D3:  a9 00
            sta $1e,x                   ; 043D5:  95 1e
            lda #$11                    ; 043D7:  a9 11
            sta $16,x                   ; 043D9:  95 16
            jsr b1_c38a                 ; 043DB:  20 8a c3
            lda #$20                    ; 043DE:  a9 20
            jsr b1_c5d8                 ; 043E0:  20 d8 c5
b1_c3e3:    ldx $08                     ; 043E3:  a6 08
b1_c3e5:    rts                         ; 043E5:  60

b1_c3e6:    lda $ce                     ; 043E6:  a5 ce
            cmp #$2c                    ; 043E8:  c9 2c
            bcc b1_c3e5                 ; 043EA:  90 f9
            hex b9 1e 00 ; lda $001e,y  ; 043EC:  b9 1e 00
            bne b1_c3e5                 ; 043EF:  d0 f4
            hex b9 6e 00 ; lda $006e,y  ; 043F1:  b9 6e 00
            sta $6e,x                   ; 043F4:  95 6e
            hex b9 87 00 ; lda $0087,y  ; 043F6:  b9 87 00
            sta $87,x                   ; 043F9:  95 87
            lda #$01                    ; 043FB:  a9 01
            sta $b6,x                   ; 043FD:  95 b6
            hex b9 cf 00 ; lda $00cf,y  ; 043FF:  b9 cf 00
            sec                         ; 04402:  38
            sbc #$08                    ; 04403:  e9 08
            sta $cf,x                   ; 04405:  95 cf
            lda $07a7,x                 ; 04407:  bd a7 07
            and #$03                    ; 0440A:  29 03
            tay                         ; 0440C:  a8
            ldx #$02                    ; 0440D:  a2 02
b1_c40f:    lda tab_b1_c395+3,y         ; 0440F:  b9 98 c3
            sta $01,x                   ; 04412:  95 01
            iny                         ; 04414:  c8
            iny                         ; 04415:  c8
            iny                         ; 04416:  c8
            iny                         ; 04417:  c8
            dex                         ; 04418:  ca
            bpl b1_c40f                 ; 04419:  10 f4
            ldx $08                     ; 0441B:  a6 08
            jsr b1_cf6c                 ; 0441D:  20 6c cf
            ldy $57                     ; 04420:  a4 57
            cpy #$08                    ; 04422:  c0 08
            bcs b1_c434                 ; 04424:  b0 0e
            tay                         ; 04426:  a8
            lda $07a8,x                 ; 04427:  bd a8 07
            and #$03                    ; 0442A:  29 03
            beq b1_c433                 ; 0442C:  f0 05
            tya                         ; 0442E:  98
            eor #$ff                    ; 0442F:  49 ff
            tay                         ; 04431:  a8
            iny                         ; 04432:  c8
b1_c433:    tya                         ; 04433:  98
b1_c434:    jsr b1_c346                 ; 04434:  20 46 c3
            ldy #$02                    ; 04437:  a0 02
            sta $58,x                   ; 04439:  95 58
            cmp #$00                    ; 0443B:  c9 00
            bmi b1_c440                 ; 0443D:  30 01
            dey                         ; 0443F:  88
b1_c440:    sty $46,x                   ; 04440:  94 46
            lda #$fd                    ; 04442:  a9 fd
            sta $a0,x                   ; 04444:  95 a0
            lda #$01                    ; 04446:  a9 01
            sta $0f,x                   ; 04448:  95 0f
            lda #$05                    ; 0444A:  a9 05
            sta $1e,x                   ; 0444C:  95 1e
b1_c44e:    rts                         ; 0444E:  60

b1_c44f:    plp                         ; 0444F:  28
            sec                         ; 04450:  38
            plp                         ; 04451:  28
            sec                         ; 04452:  38
            plp                         ; 04453:  28
b1_c454:    brk                         ; 04454:  00
            hex 00                      ; 04455:  00
            bpl b1_c466+2               ; 04456:  10 10
            brk                         ; 04458:  00
            hex 20                      ; 04459:  20
            adc $c5,x                   ; 0445A:  75 c5
            lda #$00                    ; 0445C:  a9 00
            sta $58,x                   ; 0445E:  95 58
            lda $16,x                   ; 04460:  b5 16
            sec                         ; 04462:  38
            sbc #$1b                    ; 04463:  e9 1b
            tay                         ; 04465:  a8
b1_c466:    lda b1_c44f,y               ; 04466:  b9 4f c4
            sta $0388,x                 ; 04469:  9d 88 03
            lda b1_c454,y               ; 0446C:  b9 54 c4
            sta $34,x                   ; 0446F:  95 34
            lda $cf,x                   ; 04471:  b5 cf
            clc                         ; 04473:  18
            adc #$04                    ; 04474:  69 04
            sta $cf,x                   ; 04476:  95 cf
            lda $87,x                   ; 04478:  b5 87
            clc                         ; 0447A:  18
            adc #$04                    ; 0447B:  69 04
            sta $87,x                   ; 0447D:  95 87
            lda $6e,x                   ; 0447F:  b5 6e
            adc #$00                    ; 04481:  69 00
            sta $6e,x                   ; 04483:  95 6e
            jmp b1_c7d9                 ; 04485:  4c d9 c7

tab_b1_c488: ; 4 bytes
            hex 80 30 40 80             ; 04488:  80 30 40 80

            bmi b1_c4dd+1               ; 0448C:  30 50
            bvc b1_c500                 ; 0448E:  50 70
            jsr $8040                   ; 04490:  20 40 80
            ldy #$70                    ; 04493:  a0 70
            rti                         ; 04495:  40

tab_b1_c496: ; 21 bytes
            hex 90 68 0e 05 06 0e 1c 20 ; 04496:  90 68 0e 05 06 0e 1c 20
            hex 10 0c 1e 22 18 14 10 60 ; 0449E:  10 0c 1e 22 18 14 10 60
            hex 20 48 ad 8f 07          ; 044A6:  20 48 ad 8f 07

            bne b1_c44e                 ; 044AB:  d0 a1
            jsr b1_c346                 ; 044AD:  20 46 c3
            lda $07a8,x                 ; 044B0:  bd a8 07
            and #$03                    ; 044B3:  29 03
            tay                         ; 044B5:  a8
            lda tab_b1_c496+14,y        ; 044B6:  b9 a4 c4
            sta $078f                   ; 044B9:  8d 8f 07
            ldy #$03                    ; 044BC:  a0 03
            lda $06cc                   ; 044BE:  ad cc 06
            beq b1_c4c4                 ; 044C1:  f0 01
            iny                         ; 044C3:  c8
b1_c4c4:    sty $00                     ; 044C4:  84 00
            cpx $00                     ; 044C6:  e4 00
            bcs b1_c44e                 ; 044C8:  b0 84
            lda $07a7,x                 ; 044CA:  bd a7 07
            and #$03                    ; 044CD:  29 03
            sta $00                     ; 044CF:  85 00
            sta $01                     ; 044D1:  85 01
            lda #$fb                    ; 044D3:  a9 fb
            sta $a0,x                   ; 044D5:  95 a0
            lda #$00                    ; 044D7:  a9 00
            ldy $57                     ; 044D9:  a4 57
            beq b1_c4e4                 ; 044DB:  f0 07
b1_c4dd:    lda #$04                    ; 044DD:  a9 04
            cpy #$19                    ; 044DF:  c0 19
            bcc b1_c4e4                 ; 044E1:  90 01
            asl a                       ; 044E3:  0a
b1_c4e4:    pha                         ; 044E4:  48
            clc                         ; 044E5:  18
            adc $00                     ; 044E6:  65 00
            sta $00                     ; 044E8:  85 00
            lda $07a8,x                 ; 044EA:  bd a8 07
            and #$03                    ; 044ED:  29 03
            beq b1_c4f8                 ; 044EF:  f0 07
            lda $07a9,x                 ; 044F1:  bd a9 07
            and #$0f                    ; 044F4:  29 0f
            sta $00                     ; 044F6:  85 00
b1_c4f8:    pla                         ; 044F8:  68
            clc                         ; 044F9:  18
            adc $01                     ; 044FA:  65 01
            tay                         ; 044FC:  a8
            lda tab_b1_c496+2,y         ; 044FD:  b9 98 c4
b1_c500:    sta $58,x                   ; 04500:  95 58
            lda #$01                    ; 04502:  a9 01
            sta $46,x                   ; 04504:  95 46
            lda $57                     ; 04506:  a5 57
            bne b1_c51c                 ; 04508:  d0 12
            ldy $00                     ; 0450A:  a4 00
            tya                         ; 0450C:  98
            and #$02                    ; 0450D:  29 02
            beq b1_c51c                 ; 0450F:  f0 0b
            lda $58,x                   ; 04511:  b5 58
            eor #$ff                    ; 04513:  49 ff
            clc                         ; 04515:  18
            adc #$01                    ; 04516:  69 01
            sta $58,x                   ; 04518:  95 58
            inc $46,x                   ; 0451A:  f6 46
b1_c51c:    tya                         ; 0451C:  98
            and #$02                    ; 0451D:  29 02
            beq b1_c530                 ; 0451F:  f0 0f
            lda $86                     ; 04521:  a5 86
            clc                         ; 04523:  18
            adc tab_b1_c488,y           ; 04524:  79 88 c4
            sta $87,x                   ; 04527:  95 87
            lda $6d                     ; 04529:  a5 6d
            adc #$00                    ; 0452B:  69 00
            jmp b1_c53c                 ; 0452D:  4c 3c c5

b1_c530:    lda $86                     ; 04530:  a5 86
            sec                         ; 04532:  38
            sbc tab_b1_c488,y           ; 04533:  f9 88 c4
            sta $87,x                   ; 04536:  95 87
            lda $6d                     ; 04538:  a5 6d
            sbc #$00                    ; 0453A:  e9 00
b1_c53c:    sta $6e,x                   ; 0453C:  95 6e
            lda #$01                    ; 0453E:  a9 01
            sta $0f,x                   ; 04540:  95 0f
            sta $b6,x                   ; 04542:  95 b6
            lda #$f8                    ; 04544:  a9 f8
            sta $cf,x                   ; 04546:  95 cf
            rts                         ; 04548:  60

            jsr b1_c575                 ; 04549:  20 75 c5
            stx $0368                   ; 0454C:  8e 68 03
            lda #$00                    ; 0454F:  a9 00
            sta $0363                   ; 04551:  8d 63 03
            sta $0369                   ; 04554:  8d 69 03
            lda $87,x                   ; 04557:  b5 87
            sta $0366                   ; 04559:  8d 66 03
            lda #$df                    ; 0455C:  a9 df
            sta $0790                   ; 0455E:  8d 90 07
            sta $46,x                   ; 04561:  95 46
            lda #$20                    ; 04563:  a9 20
            sta $0364                   ; 04565:  8d 64 03
            sta $078a,x                 ; 04568:  9d 8a 07
            lda #$05                    ; 0456B:  a9 05
            sta $0483                   ; 0456D:  8d 83 04
            lsr a                       ; 04570:  4a
            sta $0365                   ; 04571:  8d 65 03
            rts                         ; 04574:  60

b1_c575:    ldy #$ff                    ; 04575:  a0 ff
b1_c577:    iny                         ; 04577:  c8
            hex b9 0f 00 ; lda $000f,y  ; 04578:  b9 0f 00
            bne b1_c577                 ; 0457B:  d0 fa
            sty $06cf                   ; 0457D:  8c cf 06
            txa                         ; 04580:  8a
            ora #$80                    ; 04581:  09 80
            hex 99 0f 00 ; sta $000f,y  ; 04583:  99 0f 00
            lda $6e,x                   ; 04586:  b5 6e
            hex 99 6e 00 ; sta $006e,y  ; 04588:  99 6e 00
            lda $87,x                   ; 0458B:  b5 87
            hex 99 87 00 ; sta $0087,y  ; 0458D:  99 87 00
            lda #$01                    ; 04590:  a9 01
            sta $0f,x                   ; 04592:  95 0f
            hex 99 b6 00 ; sta $00b6,y  ; 04594:  99 b6 00
            lda $cf,x                   ; 04597:  b5 cf
            hex 99 cf 00 ; sta $00cf,y  ; 04599:  99 cf 00
b1_c59c:    rts                         ; 0459C:  60

tab_b1_c59d: ; 9 bytes
            hex 90 80 70 90 ff 01 ad 8f ; 0459D:  90 80 70 90 ff 01 ad 8f
            hex 07                      ; 045A5:  07

            bne b1_c59c                 ; 045A6:  d0 f4
            sta $0434,x                 ; 045A8:  9d 34 04
            lda $fd                     ; 045AB:  a5 fd
            ora #$02                    ; 045AD:  09 02
            sta $fd                     ; 045AF:  85 fd
            ldy $0368                   ; 045B1:  ac 68 03
            hex b9 16 00 ; lda $0016,y  ; 045B4:  b9 16 00
            cmp #$2d                    ; 045B7:  c9 2d
            beq b1_c5ec                 ; 045B9:  f0 31
            jsr b1_d1d9                 ; 045BB:  20 d9 d1
            clc                         ; 045BE:  18
            adc #$20                    ; 045BF:  69 20
            ldy $06cc                   ; 045C1:  ac cc 06
            beq b1_c5c9                 ; 045C4:  f0 03
            sec                         ; 045C6:  38
            sbc #$10                    ; 045C7:  e9 10
b1_c5c9:    sta $078f                   ; 045C9:  8d 8f 07
            lda $07a7,x                 ; 045CC:  bd a7 07
            and #$03                    ; 045CF:  29 03
            sta $0417,x                 ; 045D1:  9d 17 04
            tay                         ; 045D4:  a8
            lda tab_b1_c59d,y           ; 045D5:  b9 9d c5
b1_c5d8:    sta $cf,x                   ; 045D8:  95 cf
            lda $071d                   ; 045DA:  ad 1d 07
            clc                         ; 045DD:  18
            adc #$20                    ; 045DE:  69 20
            sta $87,x                   ; 045E0:  95 87
            lda $071b                   ; 045E2:  ad 1b 07
            adc #$00                    ; 045E5:  69 00
            sta $6e,x                   ; 045E7:  95 6e
            jmp b1_c61f                 ; 045E9:  4c 1f c6

b1_c5ec:    hex b9 87 00 ; lda $0087,y  ; 045EC:  b9 87 00
            sec                         ; 045EF:  38
            sbc #$0e                    ; 045F0:  e9 0e
            sta $87,x                   ; 045F2:  95 87
            hex b9 6e 00 ; lda $006e,y  ; 045F4:  b9 6e 00
            sta $6e,x                   ; 045F7:  95 6e
            hex b9 cf 00 ; lda $00cf,y  ; 045F9:  b9 cf 00
            clc                         ; 045FC:  18
            adc #$08                    ; 045FD:  69 08
            sta $cf,x                   ; 045FF:  95 cf
            lda $07a7,x                 ; 04601:  bd a7 07
            and #$03                    ; 04604:  29 03
            sta $0417,x                 ; 04606:  9d 17 04
            tay                         ; 04609:  a8
            lda tab_b1_c59d,y           ; 0460A:  b9 9d c5
            ldy #$00                    ; 0460D:  a0 00
            cmp $cf,x                   ; 0460F:  d5 cf
            bcc b1_c614                 ; 04611:  90 01
            iny                         ; 04613:  c8
b1_c614:    lda tab_b1_c59d+4,y         ; 04614:  b9 a1 c5
            sta $0434,x                 ; 04617:  9d 34 04
            lda #$00                    ; 0461A:  a9 00
            sta $06cb                   ; 0461C:  8d cb 06
b1_c61f:    lda #$08                    ; 0461F:  a9 08
            sta $049a,x                 ; 04621:  9d 9a 04
b1_c624:    lda #$01                    ; 04624:  a9 01
            sta $b6,x                   ; 04626:  95 b6
            sta $0f,x                   ; 04628:  95 0f
            lsr a                       ; 0462A:  4a
            sta $0401,x                 ; 0462B:  9d 01 04
            sta $1e,x                   ; 0462E:  95 1e
            rts                         ; 04630:  60

b1_c631:    brk                         ; 04631:  00
            hex 30                      ; 04632:  30
            rts                         ; 04633:  60

            hex 60                      ; 04634:  60

            brk                         ; 04635:  00
            hex 20                      ; 04636:  20
b1_c637:    rts                         ; 04637:  60

            hex 40                      ; 04638:  40

            bvs b1_c67a+1               ; 04639:  70 40
            rts                         ; 0463B:  60

            hex 30 ad 8f 07             ; 0463C:  30 ad 8f 07

            bne b1_c689                 ; 04640:  d0 47
            lda #$20                    ; 04642:  a9 20
            sta $078f                   ; 04644:  8d 8f 07
            dec $06d7                   ; 04647:  ce d7 06
            ldy #$06                    ; 0464A:  a0 06
b1_c64c:    dey                         ; 0464C:  88
            hex b9 16 00 ; lda $0016,y  ; 0464D:  b9 16 00
            cmp #$31                    ; 04650:  c9 31
            bne b1_c64c                 ; 04652:  d0 f8
            hex b9 87 00 ; lda $0087,y  ; 04654:  b9 87 00
            sec                         ; 04657:  38
            sbc #$30                    ; 04658:  e9 30
            pha                         ; 0465A:  48
            hex b9 6e 00 ; lda $006e,y  ; 0465B:  b9 6e 00
            sbc #$00                    ; 0465E:  e9 00
            sta $00                     ; 04660:  85 00
            lda $06d7                   ; 04662:  ad d7 06
            clc                         ; 04665:  18
            hex 79 1e 00 ; adc $001e,y  ; 04666:  79 1e 00
            tay                         ; 04669:  a8
            pla                         ; 0466A:  68
            clc                         ; 0466B:  18
            adc b1_c631,y               ; 0466C:  79 31 c6
            sta $87,x                   ; 0466F:  95 87
            lda $00                     ; 04671:  a5 00
            adc #$00                    ; 04673:  69 00
            sta $6e,x                   ; 04675:  95 6e
            lda b1_c637,y               ; 04677:  b9 37 c6
b1_c67a:    sta $cf,x                   ; 0467A:  95 cf
            lda #$01                    ; 0467C:  a9 01
            sta $b6,x                   ; 0467E:  95 b6
            sta $0f,x                   ; 04680:  95 0f
            lsr a                       ; 04682:  4a
            sta $58,x                   ; 04683:  95 58
            lda #$08                    ; 04685:  a9 08
            sta $a0,x                   ; 04687:  95 a0
b1_c689:    rts                         ; 04689:  60

tab_b1_c68a: ; 3 bytes
            hex 01 02 04                ; 0468A:  01 02 04

            php                         ; 0468D:  08
            bpl b1_c6af+1               ; 0468E:  10 20
            rti                         ; 04690:  40

tab_b1_c691: ; 2 bytes
            hex 80 40                   ; 04691:  80 40

            bmi b1_c624+1               ; 04693:  30 90
            bvc b1_c6b7                 ; 04695:  50 20
            rts                         ; 04697:  60

tab_b1_c698: ; 4 bytes
            hex a0 70 0a 0b             ; 04698:  a0 70 0a 0b

            lda $078f                   ; 0469C:  ad 8f 07
            bne b1_c710                 ; 0469F:  d0 6f
            lda $074e                   ; 046A1:  ad 4e 07
            bne b1_c6fd                 ; 046A4:  d0 57
            cpx #$03                    ; 046A6:  e0 03
            bcs b1_c710                 ; 046A8:  b0 66
            ldy #$00                    ; 046AA:  a0 00
            lda $07a7,x                 ; 046AC:  bd a7 07
b1_c6af:    cmp #$aa                    ; 046AF:  c9 aa
            bcc b1_c6b4                 ; 046B1:  90 01
            iny                         ; 046B3:  c8
b1_c6b4:    lda $075f                   ; 046B4:  ad 5f 07
b1_c6b7:    cmp #$01                    ; 046B7:  c9 01
            beq b1_c6bc                 ; 046B9:  f0 01
            iny                         ; 046BB:  c8
b1_c6bc:    tya                         ; 046BC:  98
            and #$01                    ; 046BD:  29 01
            tay                         ; 046BF:  a8
            lda tab_b1_c698+2,y         ; 046C0:  b9 9a c6
b1_c6c3:    sta $16,x                   ; 046C3:  95 16
            lda $06dd                   ; 046C5:  ad dd 06
            cmp #$ff                    ; 046C8:  c9 ff
            bne b1_c6d1                 ; 046CA:  d0 05
            lda #$00                    ; 046CC:  a9 00
            sta $06dd                   ; 046CE:  8d dd 06
b1_c6d1:    lda $07a7,x                 ; 046D1:  bd a7 07
            and #$07                    ; 046D4:  29 07
b1_c6d6:    tay                         ; 046D6:  a8
            lda tab_b1_c68a,y           ; 046D7:  b9 8a c6
            bit $06dd                   ; 046DA:  2c dd 06
            beq b1_c6e6                 ; 046DD:  f0 07
            iny                         ; 046DF:  c8
            tya                         ; 046E0:  98
            and #$07                    ; 046E1:  29 07
            jmp b1_c6d6                 ; 046E3:  4c d6 c6

b1_c6e6:    ora $06dd                   ; 046E6:  0d dd 06
            sta $06dd                   ; 046E9:  8d dd 06
            lda tab_b1_c691+1,y         ; 046EC:  b9 92 c6
            jsr b1_c5d8                 ; 046EF:  20 d8 c5
            sta $0417,x                 ; 046F2:  9d 17 04
            lda #$20                    ; 046F5:  a9 20
            sta $078f                   ; 046F7:  8d 8f 07
            jmp tab_b1_c26c             ; 046FA:  4c 6c c2

b1_c6fd:    ldy #$ff                    ; 046FD:  a0 ff
b1_c6ff:    iny                         ; 046FF:  c8
            cpy #$05                    ; 04700:  c0 05
            bcs b1_c711                 ; 04702:  b0 0d
            hex b9 0f 00 ; lda $000f,y  ; 04704:  b9 0f 00
            beq b1_c6ff                 ; 04707:  f0 f6
            hex b9 16 00 ; lda $0016,y  ; 04709:  b9 16 00
            cmp #$08                    ; 0470C:  c9 08
            bne b1_c6ff                 ; 0470E:  d0 ef
b1_c710:    rts                         ; 04710:  60

b1_c711:    lda $fe                     ; 04711:  a5 fe
            ora #$08                    ; 04713:  09 08
            sta $fe                     ; 04715:  85 fe
            lda #$08                    ; 04717:  a9 08
            bne b1_c6c3                 ; 04719:  d0 a8
            ldy #$00                    ; 0471B:  a0 00
            sec                         ; 0471D:  38
            sbc #$37                    ; 0471E:  e9 37
            pha                         ; 04720:  48
            cmp #$04                    ; 04721:  c9 04
            bcs b1_c730                 ; 04723:  b0 0b
            pha                         ; 04725:  48
            ldy #$06                    ; 04726:  a0 06
            lda $076a                   ; 04728:  ad 6a 07
            beq b1_c72f                 ; 0472B:  f0 02
            ldy #$02                    ; 0472D:  a0 02
b1_c72f:    pla                         ; 0472F:  68
b1_c730:    sty $01                     ; 04730:  84 01
            ldy #$b0                    ; 04732:  a0 b0
            and #$02                    ; 04734:  29 02
            beq b1_c73a                 ; 04736:  f0 02
            ldy #$70                    ; 04738:  a0 70
b1_c73a:    sty $00                     ; 0473A:  84 00
            lda $071b                   ; 0473C:  ad 1b 07
            sta $02                     ; 0473F:  85 02
            lda $071d                   ; 04741:  ad 1d 07
            sta $03                     ; 04744:  85 03
            ldy #$02                    ; 04746:  a0 02
            pla                         ; 04748:  68
            lsr a                       ; 04749:  4a
            bcc b1_c74d                 ; 0474A:  90 01
            iny                         ; 0474C:  c8
b1_c74d:    sty $06d3                   ; 0474D:  8c d3 06
b1_c750:    ldx #$ff                    ; 04750:  a2 ff
b1_c752:    inx                         ; 04752:  e8
            cpx #$05                    ; 04753:  e0 05
            bcs b1_c784                 ; 04755:  b0 2d
            lda $0f,x                   ; 04757:  b5 0f
            bne b1_c752                 ; 04759:  d0 f7
            lda $01                     ; 0475B:  a5 01
            sta $16,x                   ; 0475D:  95 16
            lda $02                     ; 0475F:  a5 02
            sta $6e,x                   ; 04761:  95 6e
            lda $03                     ; 04763:  a5 03
            sta $87,x                   ; 04765:  95 87
            clc                         ; 04767:  18
            adc #$18                    ; 04768:  69 18
            sta $03                     ; 0476A:  85 03
            lda $02                     ; 0476C:  a5 02
            adc #$00                    ; 0476E:  69 00
            sta $02                     ; 04770:  85 02
            lda $00                     ; 04772:  a5 00
            sta $cf,x                   ; 04774:  95 cf
            lda #$01                    ; 04776:  a9 01
            sta $b6,x                   ; 04778:  95 b6
            sta $0f,x                   ; 0477A:  95 0f
            jsr tab_b1_c26c             ; 0477C:  20 6c c2
            dec $06d3                   ; 0477F:  ce d3 06
            bne b1_c750                 ; 04782:  d0 cc
b1_c784:    jmp b1_c25e                 ; 04784:  4c 5e c2

            lda #$01                    ; 04787:  a9 01
            sta $58,x                   ; 04789:  95 58
            lsr a                       ; 0478B:  4a
            sta $1e,x                   ; 0478C:  95 1e
            sta $a0,x                   ; 0478E:  95 a0
            lda $cf,x                   ; 04790:  b5 cf
            sta $0434,x                 ; 04792:  9d 34 04
            sec                         ; 04795:  38
            sbc #$18                    ; 04796:  e9 18
            sta $0417,x                 ; 04798:  9d 17 04
            lda #$09                    ; 0479B:  a9 09
            jmp b1_c7db                 ; 0479D:  4c db c7

            hex b5 16 8d cb 06 38 e9 12 ; 047A0:  b5 16 8d cb 06 38 e9 12
            hex 20 04 8e a4 c3 b7 c7    ; 047A8:  20 04 8e a4 c3 b7 c7

            tay                         ; 047AF:  a8
            cpy $a3                     ; 047B0:  c4 a3
            cmp $3d                     ; 047B2:  c5 3d
            dec $9c                     ; 047B4:  c6 9c
            dec $60                     ; 047B6:  c6 60
            ldy #$05                    ; 047B8:  a0 05
b1_c7ba:    hex b9 16 00 ; lda $0016,y  ; 047BA:  b9 16 00
            cmp #$11                    ; 047BD:  c9 11
            bne b1_c7c6                 ; 047BF:  d0 05
            lda #$01                    ; 047C1:  a9 01
            hex 99 1e 00 ; sta $001e,y  ; 047C3:  99 1e 00
b1_c7c6:    dey                         ; 047C6:  88
            bpl b1_c7ba                 ; 047C7:  10 f1
            lda #$00                    ; 047C9:  a9 00
            sta $06cb                   ; 047CB:  8d cb 06
            sta $0f,x                   ; 047CE:  95 0f
            rts                         ; 047D0:  60

            lda #$02                    ; 047D1:  a9 02
            sta $46,x                   ; 047D3:  95 46
            lda #$f8                    ; 047D5:  a9 f8
            sta $58,x                   ; 047D7:  95 58
b1_c7d9:    lda #$03                    ; 047D9:  a9 03
b1_c7db:    sta $049a,x                 ; 047DB:  9d 9a 04
            rts                         ; 047DE:  60

            dec $cf,x                   ; 047DF:  d6 cf
            dec $cf,x                   ; 047E1:  d6 cf
            ldy $06cc                   ; 047E3:  ac cc 06
            bne b1_c7ed                 ; 047E6:  d0 05
            ldy #$02                    ; 047E8:  a0 02
            jsr b1_c871                 ; 047EA:  20 71 c8
b1_c7ed:    ldy #$ff                    ; 047ED:  a0 ff
            lda $03a0                   ; 047EF:  ad a0 03
            sta $1e,x                   ; 047F2:  95 1e
            bpl b1_c7f8                 ; 047F4:  10 02
            txa                         ; 047F6:  8a
            tay                         ; 047F7:  a8
b1_c7f8:    sty $03a0                   ; 047F8:  8c a0 03
            lda #$00                    ; 047FB:  a9 00
            sta $46,x                   ; 047FD:  95 46
            tay                         ; 047FF:  a8
            jsr b1_c871                 ; 04800:  20 71 c8
            lda #$ff                    ; 04803:  a9 ff
            sta $03a2,x                 ; 04805:  9d a2 03
            jmp b1_c828                 ; 04808:  4c 28 c8

            lda #$00                    ; 0480B:  a9 00
            sta $58,x                   ; 0480D:  95 58
            jmp b1_c828                 ; 0480F:  4c 28 c8

            ldy #$40                    ; 04812:  a0 40
            lda $cf,x                   ; 04814:  b5 cf
            bpl b1_c81f                 ; 04816:  10 07
            eor #$ff                    ; 04818:  49 ff
            clc                         ; 0481A:  18
            adc #$01                    ; 0481B:  69 01
            ldy #$c0                    ; 0481D:  a0 c0
b1_c81f:    sta $0401,x                 ; 0481F:  9d 01 04
            tya                         ; 04822:  98
            clc                         ; 04823:  18
            adc $cf,x                   ; 04824:  75 cf
            sta $58,x                   ; 04826:  95 58
b1_c828:    jsr b1_c363                 ; 04828:  20 63 c3
b1_c82b:    lda #$05                    ; 0482B:  a9 05
            ldy $074e                   ; 0482D:  ac 4e 07
            cpy #$03                    ; 04830:  c0 03
            beq b1_c83b                 ; 04832:  f0 07
            ldy $06cc                   ; 04834:  ac cc 06
            bne b1_c83b                 ; 04837:  d0 02
            lda #$06                    ; 04839:  a9 06
b1_c83b:    sta $049a,x                 ; 0483B:  9d 9a 04
            rts                         ; 0483E:  60

            jsr b1_c84b                 ; 0483F:  20 4b c8
            jmp b1_c848                 ; 04842:  4c 48 c8

            jsr b1_c857                 ; 04845:  20 57 c8
b1_c848:    jmp b1_c82b                 ; 04848:  4c 2b c8

b1_c84b:    lda #$10                    ; 0484B:  a9 10
            sta $0434,x                 ; 0484D:  9d 34 04
            lda #$ff                    ; 04850:  a9 ff
            sta $a0,x                   ; 04852:  95 a0
            jmp b1_c860                 ; 04854:  4c 60 c8

b1_c857:    lda #$f0                    ; 04857:  a9 f0
            sta $0434,x                 ; 04859:  9d 34 04
            lda #$00                    ; 0485C:  a9 00
            sta $a0,x                   ; 0485E:  95 a0
b1_c860:    ldy #$01                    ; 04860:  a0 01
            jsr b1_c871                 ; 04862:  20 71 c8
            lda #$04                    ; 04865:  a9 04
            sta $049a,x                 ; 04867:  9d 9a 04
            rts                         ; 0486A:  60

tab_b1_c86b: ; 6 bytes
            hex 08 0c f8 00 00 ff       ; 0486B:  08 0c f8 00 00 ff

b1_c871:    lda $87,x                   ; 04871:  b5 87
            clc                         ; 04873:  18
            adc tab_b1_c86b,y           ; 04874:  79 6b c8
            sta $87,x                   ; 04877:  95 87
            lda $6e,x                   ; 04879:  b5 6e
            adc tab_b1_c86b+3,y         ; 0487B:  79 6e c8
            sta $6e,x                   ; 0487E:  95 6e
            rts                         ; 04880:  60

tab_b1_c881: ; 84 bytes
            hex 60 a6 08 a9 00 b4 16 c0 ; 04881:  60 a6 08 a9 00 b4 16 c0
            hex 15 90 03 98 e9 14 20 04 ; 04889:  15 90 03 98 e9 14 20 04
            hex 8e e0 c8 35 c9 95 d2 d6 ; 04891:  8e e0 c8 35 c9 95 d2 d6
            hex c8 d6 c8 d6 c8 d6 c8 47 ; 04899:  c8 d6 c8 d6 c8 d6 c8 47
            hex c9 47 c9 47 c9 47 c9 47 ; 048A1:  c9 47 c9 47 c9 47 c9 47
            hex c9 47 c9 47 c9 47 c9 d6 ; 048A9:  c9 47 c9 47 c9 47 c9 d6
            hex c8 65 c9 65 c9 65 c9 65 ; 048B1:  c8 65 c9 65 c9 65 c9 65
            hex c9 65 c9 65 c9 65 c9 4d ; 048B9:  c9 65 c9 65 c9 65 c9 4d
            hex c9 4d c9 65 d0 85 bc 4b ; 048C1:  c9 4d c9 65 d0 85 bc 4b
            hex b9 d6 c8 d9 d2 ba b8 d6 ; 048C9:  b9 d6 c8 d9 d2 ba b8 d6
            hex c8 a4 b7 d7             ; 048D1:  c8 a4 b7 d7

            iny                         ; 048D5:  c8
            rts                         ; 048D6:  60

b1_c8d7:    jsr b1_f1af                 ; 048D7:  20 af f1
            jsr b1_f152                 ; 048DA:  20 52 f1
            jmp b1_e87d                 ; 048DD:  4c 7d e8

            lda #$00                    ; 048E0:  a9 00
            sta $03c5,x                 ; 048E2:  9d c5 03
            jsr b1_f1af                 ; 048E5:  20 af f1
            jsr b1_f152                 ; 048E8:  20 52 f1
            jsr b1_e87d                 ; 048EB:  20 7d e8
            jsr b1_e243                 ; 048EE:  20 43 e2
            jsr b1_dfc0+1               ; 048F1:  20 c1 df
            jsr b1_da32+1               ; 048F4:  20 33 da
            jsr b1_d853                 ; 048F7:  20 53 d8
            ldy $0747                   ; 048FA:  ac 47 07
            bne b1_c902                 ; 048FD:  d0 03
            jsr tab_b1_c905             ; 048FF:  20 05 c9
b1_c902:    jmp b1_d67a                 ; 04902:  4c 7a d6

tab_b1_c905: ; 60 bytes
            hex b5 16 20 04 8e 77 ca 77 ; 04905:  b5 16 20 04 8e 77 ca 77
            hex ca 77 ca 77 ca 77 ca d8 ; 0490D:  ca 77 ca 77 ca 77 ca d8
            hex c9 77 ca 89 cb 36 cc 34 ; 04915:  c9 77 ca 89 cb 36 cc 34
            hex c9 4a cc 4a cc b0 c9 b0 ; 0491D:  c9 4a cc 4a cc b0 c9 b0
            hex d3 f9 ca ff ca 25 cb 28 ; 04925:  d3 f9 ca ff ca 25 cb 28
            hex cf 77 ca 34 c9 df ce 60 ; 0492D:  cf 77 ca 34 c9 df ce 60
            hex 20 eb d1 20 af f1 20 52 ; 04935:  20 eb d1 20 af f1 20 52
            hex f1 20 43 e2             ; 0493D:  f1 20 43 e2

            jsr b1_d853                 ; 04941:  20 53 d8
            jmp b1_d67a                 ; 04944:  4c 7a d6

            jsr b1_cd3c                 ; 04947:  20 3c cd
            jmp b1_d67a                 ; 0494A:  4c 7a d6

            jsr b1_f1af                 ; 0494D:  20 af f1
            jsr b1_f152                 ; 04950:  20 52 f1
            jsr b1_e24c                 ; 04953:  20 4c e2
            jsr b1_db7b                 ; 04956:  20 7b db
            jsr b1_f152                 ; 04959:  20 52 f1
            jsr b1_ed66                 ; 0495C:  20 66 ed
            jsr b1_d655                 ; 0495F:  20 55 d6
            jmp b1_d67a                 ; 04962:  4c 7a d6

            jsr b1_f1af                 ; 04965:  20 af f1
            jsr b1_f152                 ; 04968:  20 52 f1
            jsr b1_e273                 ; 0496B:  20 73 e2
            jsr b1_db45                 ; 0496E:  20 45 db
            lda $0747                   ; 04971:  ad 47 07
            bne b1_c979                 ; 04974:  d0 03
            jsr tab_b1_c982             ; 04976:  20 82 c9
b1_c979:    jsr b1_f152                 ; 04979:  20 52 f1
            jsr b1_e5c8                 ; 0497C:  20 c8 e5
            jmp b1_d67a                 ; 0497F:  4c 7a d6

tab_b1_c982: ; 26 bytes
            hex b5 16 38 e9 24 20 04 8e ; 04982:  b5 16 38 e9 24 20 04 8e
            hex 32 d4 d3 d5 4f d6 4f d6 ; 0498A:  32 d4 d3 d5 4f d6 4f d6
            hex 07 d6 31 d6 3d d6 a9 00 ; 04992:  07 d6 31 d6 3d d6 a9 00
            hex 95 0f                   ; 0499A:  95 0f

            sta $16,x                   ; 0499C:  95 16
            sta $1e,x                   ; 0499E:  95 1e
            sta $0110,x                 ; 049A0:  9d 10 01
            sta $0796,x                 ; 049A3:  9d 96 07
            sta $0125,x                 ; 049A6:  9d 25 01
            sta $03c5,x                 ; 049A9:  9d c5 03
            sta $078a,x                 ; 049AC:  9d 8a 07
            rts                         ; 049AF:  60

            lda $0796,x                 ; 049B0:  bd 96 07
            bne b1_c9cb                 ; 049B3:  d0 16
            jsr b1_c2f7                 ; 049B5:  20 f7 c2
            lda $07a8,x                 ; 049B8:  bd a8 07
            ora #$80                    ; 049BB:  09 80
            sta $0434,x                 ; 049BD:  9d 34 04
            and #$0f                    ; 049C0:  29 0f
            ora #$06                    ; 049C2:  09 06
            sta $0796,x                 ; 049C4:  9d 96 07
            lda #$f9                    ; 049C7:  a9 f9
            sta $a0,x                   ; 049C9:  95 a0
b1_c9cb:    jmp $bf92                   ; 049CB:  4c 92 bf

tab_b1_c9ce: ; 10 bytes
            hex 30 1c 00 e8 00 18 08 f8 ; 049CE:  30 1c 00 e8 00 18 08 f8
            hex 0c f4                   ; 049D6:  0c f4

            lda $1e,x                   ; 049D8:  b5 1e
            and #$20                    ; 049DA:  29 20
            beq b1_c9e1                 ; 049DC:  f0 03
            jmp b1_cae5                 ; 049DE:  4c e5 ca

b1_c9e1:    lda $3c,x                   ; 049E1:  b5 3c
            beq b1_ca10+2               ; 049E3:  f0 2d
            dec $3c,x                   ; 049E5:  d6 3c
            lda $03d1                   ; 049E7:  ad d1 03
            and #$0c                    ; 049EA:  29 0c
            bne b1_ca58                 ; 049EC:  d0 6a
            lda $03a2,x                 ; 049EE:  bd a2 03
            bne b1_ca0a                 ; 049F1:  d0 17
            ldy $06cc                   ; 049F3:  ac cc 06
            lda tab_b1_c9ce,y           ; 049F6:  b9 ce c9
            sta $03a2,x                 ; 049F9:  9d a2 03
            jsr $ba94                   ; 049FC:  20 94 ba
            bcc b1_ca0a                 ; 049FF:  90 09
            lda $1e,x                   ; 04A01:  b5 1e
            ora #$08                    ; 04A03:  09 08
            sta $1e,x                   ; 04A05:  95 1e
            jmp b1_ca58                 ; 04A07:  4c 58 ca

b1_ca0a:    dec $03a2,x                 ; 04A0A:  de a2 03
            jmp b1_ca58                 ; 04A0D:  4c 58 ca

b1_ca10:    jsr $b537                   ; 04A10:  20 37 b5
            asl $0729,x                 ; 04A13:  1e 29 07
            cmp #$01                    ; 04A16:  c9 01
            beq b1_ca58                 ; 04A18:  f0 3e
            lda #$00                    ; 04A1A:  a9 00
            sta $00                     ; 04A1C:  85 00
            ldy #$fa                    ; 04A1E:  a0 fa
            lda $cf,x                   ; 04A20:  b5 cf
            bmi b1_ca37                 ; 04A22:  30 13
            ldy #$fd                    ; 04A24:  a0 fd
            cmp #$70                    ; 04A26:  c9 70
            inc $00                     ; 04A28:  e6 00
            bcc b1_ca37                 ; 04A2A:  90 0b
            dec $00                     ; 04A2C:  c6 00
            lda $07a8,x                 ; 04A2E:  bd a8 07
            and #$01                    ; 04A31:  29 01
            bne b1_ca37                 ; 04A33:  d0 02
            ldy #$fa                    ; 04A35:  a0 fa
b1_ca37:    sty $a0,x                   ; 04A37:  94 a0
            lda $1e,x                   ; 04A39:  b5 1e
            ora #$01                    ; 04A3B:  09 01
            sta $1e,x                   ; 04A3D:  95 1e
            lda $00                     ; 04A3F:  a5 00
            and $07a9,x                 ; 04A41:  3d a9 07
            tay                         ; 04A44:  a8
            lda $06cc                   ; 04A45:  ad cc 06
            bne b1_ca4b                 ; 04A48:  d0 01
            tay                         ; 04A4A:  a8
b1_ca4b:    lda b1_ca10,y               ; 04A4B:  b9 10 ca
            sta $078a,x                 ; 04A4E:  9d 8a 07
            lda $07a8,x                 ; 04A51:  bd a8 07
            ora #$c0                    ; 04A54:  09 c0
            sta $3c,x                   ; 04A56:  95 3c
b1_ca58:    ldy #$fc                    ; 04A58:  a0 fc
            lda $09                     ; 04A5A:  a5 09
            and #$40                    ; 04A5C:  29 40
            bne b1_ca62                 ; 04A5E:  d0 02
            ldy #$04                    ; 04A60:  a0 04
b1_ca62:    sty $58,x                   ; 04A62:  94 58
            ldy #$01                    ; 04A64:  a0 01
            jsr b1_e143                 ; 04A66:  20 43 e1
            bmi b1_ca75                 ; 04A69:  30 0a
            iny                         ; 04A6B:  c8
            lda $0796,x                 ; 04A6C:  bd 96 07
            bne b1_ca75                 ; 04A6F:  d0 04
            lda #$f8                    ; 04A71:  a9 f8
            sta $58,x                   ; 04A73:  95 58
b1_ca75:    sty $46,x                   ; 04A75:  94 46
            ldy #$00                    ; 04A77:  a0 00
            lda $1e,x                   ; 04A79:  b5 1e
            and #$40                    ; 04A7B:  29 40
            bne b1_ca98                 ; 04A7D:  d0 19
            lda $1e,x                   ; 04A7F:  b5 1e
            asl a                       ; 04A81:  0a
            bcs b1_cab4                 ; 04A82:  b0 30
            lda $1e,x                   ; 04A84:  b5 1e
            and #$20                    ; 04A86:  29 20
            bne b1_cae5                 ; 04A88:  d0 5b
            lda $1e,x                   ; 04A8A:  b5 1e
            and #$07                    ; 04A8C:  29 07
            beq b1_cab4                 ; 04A8E:  f0 24
            cmp #$05                    ; 04A90:  c9 05
            beq b1_ca98                 ; 04A92:  f0 04
            cmp #$03                    ; 04A94:  c9 03
            bcs b1_cac8                 ; 04A96:  b0 30
b1_ca98:    jsr $bf63                   ; 04A98:  20 63 bf
            ldy #$00                    ; 04A9B:  a0 00
            lda $1e,x                   ; 04A9D:  b5 1e
            cmp #$02                    ; 04A9F:  c9 02
            beq b1_caaf                 ; 04AA1:  f0 0c
            and #$40                    ; 04AA3:  29 40
            beq b1_cab4                 ; 04AA5:  f0 0d
            lda $16,x                   ; 04AA7:  b5 16
            cmp #$2e                    ; 04AA9:  c9 2e
            beq b1_cab4                 ; 04AAB:  f0 07
            bne b1_cab2                 ; 04AAD:  d0 03
b1_caaf:    jmp $bf02                   ; 04AAF:  4c 02 bf

b1_cab2:    ldy #$01                    ; 04AB2:  a0 01
b1_cab4:    lda $58,x                   ; 04AB4:  b5 58
            pha                         ; 04AB6:  48
            bpl b1_cabb                 ; 04AB7:  10 02
            iny                         ; 04AB9:  c8
            iny                         ; 04ABA:  c8
b1_cabb:    clc                         ; 04ABB:  18
            adc tab_b1_c9ce+2,y         ; 04ABC:  79 d0 c9
            sta $58,x                   ; 04ABF:  95 58
            jsr $bf02                   ; 04AC1:  20 02 bf
            pla                         ; 04AC4:  68
            sta $58,x                   ; 04AC5:  95 58
            rts                         ; 04AC7:  60

b1_cac8:    lda $0796,x                 ; 04AC8:  bd 96 07
            bne b1_caeb                 ; 04ACB:  d0 1e
            sta $1e,x                   ; 04ACD:  95 1e
            lda $09                     ; 04ACF:  a5 09
            and #$01                    ; 04AD1:  29 01
            tay                         ; 04AD3:  a8
            iny                         ; 04AD4:  c8
            sty $46,x                   ; 04AD5:  94 46
            dey                         ; 04AD7:  88
            lda $076a                   ; 04AD8:  ad 6a 07
            beq b1_cadf                 ; 04ADB:  f0 02
            iny                         ; 04ADD:  c8
            iny                         ; 04ADE:  c8
b1_cadf:    lda tab_b1_c9ce+6,y         ; 04ADF:  b9 d4 c9
            sta $58,x                   ; 04AE2:  95 58
            rts                         ; 04AE4:  60

b1_cae5:    jsr $bf63                   ; 04AE5:  20 63 bf
            jmp $bf02                   ; 04AE8:  4c 02 bf

b1_caeb:    cmp #$0e                    ; 04AEB:  c9 0e
            bne b1_caf8                 ; 04AED:  d0 09
            lda $16,x                   ; 04AEF:  b5 16
            cmp #$06                    ; 04AF1:  c9 06
            bne b1_caf8                 ; 04AF3:  d0 03
            jsr tab_b1_c982+22          ; 04AF5:  20 98 c9
b1_caf8:    rts                         ; 04AF8:  60

            jsr $bf92                   ; 04AF9:  20 92 bf
            jmp $bf02                   ; 04AFC:  4c 02 bf

            lda $a0,x                   ; 04AFF:  b5 a0
            ora $0434,x                 ; 04B01:  1d 34 04
            bne b1_cb19                 ; 04B04:  d0 13
            sta $0417,x                 ; 04B06:  9d 17 04
            lda $cf,x                   ; 04B09:  b5 cf
            cmp $0401,x                 ; 04B0B:  dd 01 04
            bcs b1_cb19                 ; 04B0E:  b0 09
            lda $09                     ; 04B10:  a5 09
            and #$07                    ; 04B12:  29 07
            bne b1_cb18                 ; 04B14:  d0 02
            inc $cf,x                   ; 04B16:  f6 cf
b1_cb18:    rts                         ; 04B18:  60

b1_cb19:    lda $cf,x                   ; 04B19:  b5 cf
            cmp $58,x                   ; 04B1B:  d5 58
            bcc tab_b1_cb22             ; 04B1D:  90 03
            jmp $bf75                   ; 04B1F:  4c 75 bf

tab_b1_cb22: ; 3 bytes
            hex 4c 70 bf                ; 04B22:  4c 70 bf

            jsr b1_cb45                 ; 04B25:  20 45 cb
            jsr b1_cb66                 ; 04B28:  20 66 cb
            ldy #$01                    ; 04B2B:  a0 01
            lda $09                     ; 04B2D:  a5 09
            and #$03                    ; 04B2F:  29 03
            bne b1_cb44                 ; 04B31:  d0 11
            lda $09                     ; 04B33:  a5 09
            and #$40                    ; 04B35:  29 40
            bne b1_cb3b                 ; 04B37:  d0 02
            ldy #$ff                    ; 04B39:  a0 ff
b1_cb3b:    sty $00                     ; 04B3B:  84 00
            lda $cf,x                   ; 04B3D:  b5 cf
            clc                         ; 04B3F:  18
            adc $00                     ; 04B40:  65 00
            sta $cf,x                   ; 04B42:  95 cf
b1_cb44:    rts                         ; 04B44:  60

b1_cb45:    lda #$13                    ; 04B45:  a9 13
b1_cb47:    sta $01                     ; 04B47:  85 01
            lda $09                     ; 04B49:  a5 09
            and #$03                    ; 04B4B:  29 03
            bne b1_cb5c                 ; 04B4D:  d0 0d
            ldy $58,x                   ; 04B4F:  b4 58
            lda $a0,x                   ; 04B51:  b5 a0
            lsr a                       ; 04B53:  4a
            bcs b1_cb60                 ; 04B54:  b0 0a
            cpy $01                     ; 04B56:  c4 01
            beq b1_cb5d                 ; 04B58:  f0 03
            inc $58,x                   ; 04B5A:  f6 58
b1_cb5c:    rts                         ; 04B5C:  60

b1_cb5d:    inc $a0,x                   ; 04B5D:  f6 a0
            rts                         ; 04B5F:  60

b1_cb60:    tya                         ; 04B60:  98
            beq b1_cb5d                 ; 04B61:  f0 fa
            dec $58,x                   ; 04B63:  d6 58
            rts                         ; 04B65:  60

b1_cb66:    lda $58,x                   ; 04B66:  b5 58
            pha                         ; 04B68:  48
            ldy #$01                    ; 04B69:  a0 01
            lda $a0,x                   ; 04B6B:  b5 a0
            and #$02                    ; 04B6D:  29 02
            bne b1_cb7c                 ; 04B6F:  d0 0b
            lda $58,x                   ; 04B71:  b5 58
            eor #$ff                    ; 04B73:  49 ff
            clc                         ; 04B75:  18
            adc #$01                    ; 04B76:  69 01
            sta $58,x                   ; 04B78:  95 58
            ldy #$02                    ; 04B7A:  a0 02
b1_cb7c:    sty $46,x                   ; 04B7C:  94 46
            jsr $bf02                   ; 04B7E:  20 02 bf
            sta $00                     ; 04B81:  85 00
            pla                         ; 04B83:  68
            sta $58,x                   ; 04B84:  95 58
            rts                         ; 04B86:  60

tab_b1_cb87: ; 2 bytes
            hex 3f 03                   ; 04B87:  3f 03

            lda $1e,x                   ; 04B89:  b5 1e
            and #$20                    ; 04B8B:  29 20
            bne tab_b1_cbdc             ; 04B8D:  d0 4d
            ldy $06cc                   ; 04B8F:  ac cc 06
            lda $07a8,x                 ; 04B92:  bd a8 07
            and tab_b1_cb87,y           ; 04B95:  39 87 cb
            bne b1_cbac                 ; 04B98:  d0 12
            txa                         ; 04B9A:  8a
            lsr a                       ; 04B9B:  4a
            bcc b1_cba2                 ; 04B9C:  90 04
            ldy $45                     ; 04B9E:  a4 45
            bcs b1_cbaa                 ; 04BA0:  b0 08
b1_cba2:    ldy #$02                    ; 04BA2:  a0 02
            jsr b1_e143                 ; 04BA4:  20 43 e1
            bpl b1_cbaa                 ; 04BA7:  10 01
            dey                         ; 04BA9:  88
b1_cbaa:    sty $46,x                   ; 04BAA:  94 46
b1_cbac:    jsr b1_cbdf                 ; 04BAC:  20 df cb
            lda $cf,x                   ; 04BAF:  b5 cf
            sec                         ; 04BB1:  38
            sbc $0434,x                 ; 04BB2:  fd 34 04
            cmp #$20                    ; 04BB5:  c9 20
            bcc b1_cbbb                 ; 04BB7:  90 02
            sta $cf,x                   ; 04BB9:  95 cf
b1_cbbb:    ldy $46,x                   ; 04BBB:  b4 46
            dey                         ; 04BBD:  88
            bne b1_cbce                 ; 04BBE:  d0 0e
            lda $87,x                   ; 04BC0:  b5 87
            clc                         ; 04BC2:  18
            adc $58,x                   ; 04BC3:  75 58
            sta $87,x                   ; 04BC5:  95 87
            lda $6e,x                   ; 04BC7:  b5 6e
            adc #$00                    ; 04BC9:  69 00
            sta $6e,x                   ; 04BCB:  95 6e
            rts                         ; 04BCD:  60

b1_cbce:    lda $87,x                   ; 04BCE:  b5 87
            sec                         ; 04BD0:  38
            sbc $58,x                   ; 04BD1:  f5 58
            sta $87,x                   ; 04BD3:  95 87
            lda $6e,x                   ; 04BD5:  b5 6e
            sbc #$00                    ; 04BD7:  e9 00
            sta $6e,x                   ; 04BD9:  95 6e
            rts                         ; 04BDB:  60

tab_b1_cbdc: ; 3 bytes
            hex 4c 8c bf                ; 04BDC:  4c 8c bf

b1_cbdf:    lda $a0,x                   ; 04BDF:  b5 a0
            and #$02                    ; 04BE1:  29 02
            bne b1_cc1c                 ; 04BE3:  d0 37
            lda $09                     ; 04BE5:  a5 09
            and #$07                    ; 04BE7:  29 07
            pha                         ; 04BE9:  48
            lda $a0,x                   ; 04BEA:  b5 a0
            lsr a                       ; 04BEC:  4a
            bcs b1_cc04                 ; 04BED:  b0 15
            pla                         ; 04BEF:  68
            bne b1_cc03                 ; 04BF0:  d0 11
            lda $0434,x                 ; 04BF2:  bd 34 04
            clc                         ; 04BF5:  18
            adc #$01                    ; 04BF6:  69 01
            sta $0434,x                 ; 04BF8:  9d 34 04
            sta $58,x                   ; 04BFB:  95 58
            cmp #$02                    ; 04BFD:  c9 02
            bne b1_cc03                 ; 04BFF:  d0 02
            inc $a0,x                   ; 04C01:  f6 a0
b1_cc03:    rts                         ; 04C03:  60

b1_cc04:    pla                         ; 04C04:  68
            bne b1_cc1b                 ; 04C05:  d0 14
            lda $0434,x                 ; 04C07:  bd 34 04
            sec                         ; 04C0A:  38
            sbc #$01                    ; 04C0B:  e9 01
            sta $0434,x                 ; 04C0D:  9d 34 04
            sta $58,x                   ; 04C10:  95 58
            bne b1_cc1b                 ; 04C12:  d0 07
            inc $a0,x                   ; 04C14:  f6 a0
            lda #$02                    ; 04C16:  a9 02
            sta $0796,x                 ; 04C18:  9d 96 07
b1_cc1b:    rts                         ; 04C1B:  60

b1_cc1c:    lda $0796,x                 ; 04C1C:  bd 96 07
            beq b1_cc29                 ; 04C1F:  f0 08
b1_cc21:    lda $09                     ; 04C21:  a5 09
            lsr a                       ; 04C23:  4a
            bcs b1_cc28                 ; 04C24:  b0 02
            inc $cf,x                   ; 04C26:  f6 cf
b1_cc28:    rts                         ; 04C28:  60

b1_cc29:    lda $cf,x                   ; 04C29:  b5 cf
            adc #$10                    ; 04C2B:  69 10
            cmp $ce                     ; 04C2D:  c5 ce
            bcc b1_cc21                 ; 04C2F:  90 f0
            lda #$00                    ; 04C31:  a9 00
            sta $a0,x                   ; 04C33:  95 a0
            rts                         ; 04C35:  60

            lda $1e,x                   ; 04C36:  b5 1e
            and #$20                    ; 04C38:  29 20
            beq b1_cc3f                 ; 04C3A:  f0 03
            jmp $bf92                   ; 04C3C:  4c 92 bf

b1_cc3f:    lda #$e8                    ; 04C3F:  a9 e8
            sta $58,x                   ; 04C41:  95 58
            jmp $bf02                   ; 04C43:  4c 02 bf

tab_b1_cc46: ; 4 bytes
            hex 40 80 04 04             ; 04C46:  40 80 04 04

            lda $1e,x                   ; 04C4A:  b5 1e
            and #$20                    ; 04C4C:  29 20
            beq b1_cc53                 ; 04C4E:  f0 03
            jmp $bf8c                   ; 04C50:  4c 8c bf

b1_cc53:    sta $03                     ; 04C53:  85 03
            lda $16,x                   ; 04C55:  b5 16
            sec                         ; 04C57:  38
            sbc #$0a                    ; 04C58:  e9 0a
            tay                         ; 04C5A:  a8
            lda tab_b1_cc46,y           ; 04C5B:  b9 46 cc
            sta $02                     ; 04C5E:  85 02
            lda $0401,x                 ; 04C60:  bd 01 04
            sec                         ; 04C63:  38
            sbc $02                     ; 04C64:  e5 02
            sta $0401,x                 ; 04C66:  9d 01 04
            lda $87,x                   ; 04C69:  b5 87
            sbc #$00                    ; 04C6B:  e9 00
            sta $87,x                   ; 04C6D:  95 87
            lda $6e,x                   ; 04C6F:  b5 6e
            sbc #$00                    ; 04C71:  e9 00
            sta $6e,x                   ; 04C73:  95 6e
            lda #$20                    ; 04C75:  a9 20
            sta $02                     ; 04C77:  85 02
            cpx #$02                    ; 04C79:  e0 02
            bcc b1_ccc6                 ; 04C7B:  90 49
            lda $58,x                   ; 04C7D:  b5 58
            cmp #$10                    ; 04C7F:  c9 10
            bcc b1_cc99                 ; 04C81:  90 16
            lda $0417,x                 ; 04C83:  bd 17 04
            clc                         ; 04C86:  18
            adc $02                     ; 04C87:  65 02
            sta $0417,x                 ; 04C89:  9d 17 04
            lda $cf,x                   ; 04C8C:  b5 cf
            adc $03                     ; 04C8E:  65 03
            sta $cf,x                   ; 04C90:  95 cf
            lda $b6,x                   ; 04C92:  b5 b6
            adc #$00                    ; 04C94:  69 00
            jmp b1_ccac                 ; 04C96:  4c ac cc

b1_cc99:    lda $0417,x                 ; 04C99:  bd 17 04
            sec                         ; 04C9C:  38
            sbc $02                     ; 04C9D:  e5 02
            sta $0417,x                 ; 04C9F:  9d 17 04
            lda $cf,x                   ; 04CA2:  b5 cf
            sbc $03                     ; 04CA4:  e5 03
            sta $cf,x                   ; 04CA6:  95 cf
            lda $b6,x                   ; 04CA8:  b5 b6
            sbc #$00                    ; 04CAA:  e9 00
b1_ccac:    sta $b6,x                   ; 04CAC:  95 b6
            ldy #$00                    ; 04CAE:  a0 00
            lda $cf,x                   ; 04CB0:  b5 cf
            sec                         ; 04CB2:  38
            sbc $0434,x                 ; 04CB3:  fd 34 04
            bpl b1_ccbf                 ; 04CB6:  10 07
            ldy #$10                    ; 04CB8:  a0 10
            eor #$ff                    ; 04CBA:  49 ff
            clc                         ; 04CBC:  18
            adc #$01                    ; 04CBD:  69 01
b1_ccbf:    cmp #$0f                    ; 04CBF:  c9 0f
            bcc b1_ccc6                 ; 04CC1:  90 03
            tya                         ; 04CC3:  98
            sta $58,x                   ; 04CC4:  95 58
b1_ccc6:    rts                         ; 04CC6:  60

tab_b1_ccc7: ; 116 bytes
            hex 00 01 03 04 05 06 07 07 ; 04CC7:  00 01 03 04 05 06 07 07
            hex 08 00 03 06 09 0b 0d 0e ; 04CCF:  08 00 03 06 09 0b 0d 0e
            hex 0f 10 00 04 09 0d 10 13 ; 04CD7:  0f 10 00 04 09 0d 10 13
            hex 16 17 18 00 06 0c 12 16 ; 04CDF:  16 17 18 00 06 0c 12 16
            hex 1a 1d 1f 20 00 07 0f 16 ; 04CE7:  1a 1d 1f 20 00 07 0f 16
            hex 1c 21 25 27 28 00 09 12 ; 04CEF:  1c 21 25 27 28 00 09 12
            hex 1b 21 27 2c 2f 30 00 0b ; 04CF7:  1b 21 27 2c 2f 30 00 0b
            hex 15 1f 27 2e 33 37 38 00 ; 04CFF:  15 1f 27 2e 33 37 38 00
            hex 0c 18 24 2d 35 3b 3e 40 ; 04D07:  0c 18 24 2d 35 3b 3e 40
            hex 00 0e 1b 28 32 3b 42 46 ; 04D0F:  00 0e 1b 28 32 3b 42 46
            hex 48 00 0f 1f 2d 38 42 4a ; 04D17:  48 00 0f 1f 2d 38 42 4a
            hex 4e 50 00 11 22 31 3e 49 ; 04D1F:  4e 50 00 11 22 31 3e 49
            hex 51 56 58 01 03 02 00 00 ; 04D27:  51 56 58 01 03 02 00 00
            hex 09 12 1b 24 2d 36 3f 48 ; 04D2F:  09 12 1b 24 2d 36 3f 48
            hex 51 5a 63 0c             ; 04D37:  51 5a 63 0c

            clc                         ; 04D3B:  18
b1_cd3c:    jsr b1_f1af                 ; 04D3C:  20 af f1
            lda $03d1                   ; 04D3F:  ad d1 03
            and #$08                    ; 04D42:  29 08
            bne b1_cdba                 ; 04D44:  d0 74
            lda $0747                   ; 04D46:  ad 47 07
            bne b1_cd55                 ; 04D49:  d0 0a
            lda $0388,x                 ; 04D4B:  bd 88 03
            jsr b1_d410                 ; 04D4E:  20 10 d4
            and #$1f                    ; 04D51:  29 1f
            sta $a0,x                   ; 04D53:  95 a0
b1_cd55:    lda $a0,x                   ; 04D55:  b5 a0
            ldy $16,x                   ; 04D57:  b4 16
            cpy #$1f                    ; 04D59:  c0 1f
            bcc b1_cd6a                 ; 04D5B:  90 0d
            cmp #$08                    ; 04D5D:  c9 08
            beq b1_cd65                 ; 04D5F:  f0 04
            cmp #$18                    ; 04D61:  c9 18
            bne b1_cd6a                 ; 04D63:  d0 05
b1_cd65:    clc                         ; 04D65:  18
            adc #$01                    ; 04D66:  69 01
            sta $a0,x                   ; 04D68:  95 a0
b1_cd6a:    sta $ef                     ; 04D6A:  85 ef
            jsr b1_f152                 ; 04D6C:  20 52 f1
            jsr b1_ce8e                 ; 04D6F:  20 8e ce
            ldy $06e5,x                 ; 04D72:  bc e5 06
            lda $03b9                   ; 04D75:  ad b9 03
            sta $0200,y                 ; 04D78:  99 00 02
            sta $07                     ; 04D7B:  85 07
            lda $03ae                   ; 04D7D:  ad ae 03
            sta $0203,y                 ; 04D80:  99 03 02
            sta $06                     ; 04D83:  85 06
            lda #$01                    ; 04D85:  a9 01
            sta $00                     ; 04D87:  85 00
            jsr b1_ce08                 ; 04D89:  20 08 ce
            ldy #$05                    ; 04D8C:  a0 05
            lda $16,x                   ; 04D8E:  b5 16
            cmp #$1f                    ; 04D90:  c9 1f
            bcc b1_cd96                 ; 04D92:  90 02
            ldy #$0b                    ; 04D94:  a0 0b
b1_cd96:    sty $ed                     ; 04D96:  84 ed
            lda #$00                    ; 04D98:  a9 00
            sta $00                     ; 04D9A:  85 00
b1_cd9c:    lda $ef                     ; 04D9C:  a5 ef
            jsr b1_ce8e                 ; 04D9E:  20 8e ce
            jsr b1_cdbb                 ; 04DA1:  20 bb cd
            lda $00                     ; 04DA4:  a5 00
            cmp #$04                    ; 04DA6:  c9 04
            bne b1_cdb2                 ; 04DA8:  d0 08
            ldy $06cf                   ; 04DAA:  ac cf 06
            lda $06e5,y                 ; 04DAD:  b9 e5 06
            sta $06                     ; 04DB0:  85 06
b1_cdb2:    inc $00                     ; 04DB2:  e6 00
            lda $00                     ; 04DB4:  a5 00
            cmp $ed                     ; 04DB6:  c5 ed
            bcc b1_cd9c                 ; 04DB8:  90 e2
b1_cdba:    rts                         ; 04DBA:  60

b1_cdbb:    lda $03                     ; 04DBB:  a5 03
            sta $05                     ; 04DBD:  85 05
            ldy $06                     ; 04DBF:  a4 06
            lda $01                     ; 04DC1:  a5 01
            lsr $05                     ; 04DC3:  46 05
            bcs b1_cdcb                 ; 04DC5:  b0 04
            eor #$ff                    ; 04DC7:  49 ff
            adc #$01                    ; 04DC9:  69 01
b1_cdcb:    clc                         ; 04DCB:  18
            adc $03ae                   ; 04DCC:  6d ae 03
            sta $0203,y                 ; 04DCF:  99 03 02
            sta $06                     ; 04DD2:  85 06
            cmp $03ae                   ; 04DD4:  cd ae 03
            bcs b1_cde2                 ; 04DD7:  b0 09
            lda $03ae                   ; 04DD9:  ad ae 03
            sec                         ; 04DDC:  38
            sbc $06                     ; 04DDD:  e5 06
            jmp b1_cde6                 ; 04DDF:  4c e6 cd

b1_cde2:    sec                         ; 04DE2:  38
            sbc $03ae                   ; 04DE3:  ed ae 03
b1_cde6:    cmp #$59                    ; 04DE6:  c9 59
            bcc b1_cdee                 ; 04DE8:  90 04
            lda #$f8                    ; 04DEA:  a9 f8
            bne b1_ce03                 ; 04DEC:  d0 15
b1_cdee:    lda $03b9                   ; 04DEE:  ad b9 03
            cmp #$f8                    ; 04DF1:  c9 f8
            beq b1_ce03                 ; 04DF3:  f0 0e
            lda $02                     ; 04DF5:  a5 02
            lsr $05                     ; 04DF7:  46 05
            bcs b1_cdff                 ; 04DF9:  b0 04
            eor #$ff                    ; 04DFB:  49 ff
            adc #$01                    ; 04DFD:  69 01
b1_cdff:    clc                         ; 04DFF:  18
            adc $03b9                   ; 04E00:  6d b9 03
b1_ce03:    sta $0200,y                 ; 04E03:  99 00 02
            sta $07                     ; 04E06:  85 07
b1_ce08:    jsr b1_eced                 ; 04E08:  20 ed ec
            tya                         ; 04E0B:  98
            pha                         ; 04E0C:  48
            lda $079f                   ; 04E0D:  ad 9f 07
            ora $0747                   ; 04E10:  0d 47 07
            bne b1_ce85                 ; 04E13:  d0 70
            sta $05                     ; 04E15:  85 05
            ldy $b5                     ; 04E17:  a4 b5
            dey                         ; 04E19:  88
            bne b1_ce85                 ; 04E1A:  d0 69
            ldy $ce                     ; 04E1C:  a4 ce
            lda $0754                   ; 04E1E:  ad 54 07
            bne b1_ce28                 ; 04E21:  d0 05
            lda $0714                   ; 04E23:  ad 14 07
            beq b1_ce31                 ; 04E26:  f0 09
b1_ce28:    inc $05                     ; 04E28:  e6 05
            inc $05                     ; 04E2A:  e6 05
            tya                         ; 04E2C:  98
            clc                         ; 04E2D:  18
            adc #$18                    ; 04E2E:  69 18
            tay                         ; 04E30:  a8
b1_ce31:    tya                         ; 04E31:  98
b1_ce32:    sec                         ; 04E32:  38
            sbc $07                     ; 04E33:  e5 07
            bpl b1_ce3c                 ; 04E35:  10 05
            eor #$ff                    ; 04E37:  49 ff
            clc                         ; 04E39:  18
            adc #$01                    ; 04E3A:  69 01
b1_ce3c:    cmp #$08                    ; 04E3C:  c9 08
            bcs b1_ce5c                 ; 04E3E:  b0 1c
            lda $06                     ; 04E40:  a5 06
            cmp #$f0                    ; 04E42:  c9 f0
            bcs b1_ce5c                 ; 04E44:  b0 16
            lda $0207                   ; 04E46:  ad 07 02
            clc                         ; 04E49:  18
            adc #$04                    ; 04E4A:  69 04
            sta $04                     ; 04E4C:  85 04
            sec                         ; 04E4E:  38
            sbc $06                     ; 04E4F:  e5 06
            bpl b1_ce58                 ; 04E51:  10 05
            eor #$ff                    ; 04E53:  49 ff
            clc                         ; 04E55:  18
            adc #$01                    ; 04E56:  69 01
b1_ce58:    cmp #$08                    ; 04E58:  c9 08
            bcc b1_ce6f                 ; 04E5A:  90 13
b1_ce5c:    lda $05                     ; 04E5C:  a5 05
            cmp #$02                    ; 04E5E:  c9 02
            beq b1_ce85                 ; 04E60:  f0 23
            ldy $05                     ; 04E62:  a4 05
            lda $ce                     ; 04E64:  a5 ce
            clc                         ; 04E66:  18
            adc tab_b1_ccc7+115,y       ; 04E67:  79 3a cd
            inc $05                     ; 04E6A:  e6 05
            jmp b1_ce32                 ; 04E6C:  4c 32 ce

b1_ce6f:    ldx #$01                    ; 04E6F:  a2 01
            lda $04                     ; 04E71:  a5 04
            cmp $06                     ; 04E73:  c5 06
            bcs b1_ce78                 ; 04E75:  b0 01
            inx                         ; 04E77:  e8
b1_ce78:    stx $46                     ; 04E78:  86 46
            ldx #$00                    ; 04E7A:  a2 00
            lda $00                     ; 04E7C:  a5 00
            pha                         ; 04E7E:  48
            jsr b1_d92c                 ; 04E7F:  20 2c d9
            pla                         ; 04E82:  68
            sta $00                     ; 04E83:  85 00
b1_ce85:    pla                         ; 04E85:  68
            clc                         ; 04E86:  18
            adc #$04                    ; 04E87:  69 04
            sta $06                     ; 04E89:  85 06
            ldx $08                     ; 04E8B:  a6 08
            rts                         ; 04E8D:  60

b1_ce8e:    pha                         ; 04E8E:  48
            and #$0f                    ; 04E8F:  29 0f
            cmp #$09                    ; 04E91:  c9 09
            bcc b1_ce9a                 ; 04E93:  90 05
            eor #$0f                    ; 04E95:  49 0f
            clc                         ; 04E97:  18
            adc #$01                    ; 04E98:  69 01
b1_ce9a:    sta $01                     ; 04E9A:  85 01
            ldy $00                     ; 04E9C:  a4 00
            lda tab_b1_ccc7+103,y       ; 04E9E:  b9 2e cd
            clc                         ; 04EA1:  18
            adc $01                     ; 04EA2:  65 01
            tay                         ; 04EA4:  a8
            lda tab_b1_ccc7,y           ; 04EA5:  b9 c7 cc
            sta $01                     ; 04EA8:  85 01
            pla                         ; 04EAA:  68
            pha                         ; 04EAB:  48
            clc                         ; 04EAC:  18
            adc #$08                    ; 04EAD:  69 08
            and #$0f                    ; 04EAF:  29 0f
            cmp #$09                    ; 04EB1:  c9 09
            bcc b1_ceba                 ; 04EB3:  90 05
            eor #$0f                    ; 04EB5:  49 0f
            clc                         ; 04EB7:  18
            adc #$01                    ; 04EB8:  69 01
b1_ceba:    sta $02                     ; 04EBA:  85 02
            ldy $00                     ; 04EBC:  a4 00
            lda tab_b1_ccc7+103,y       ; 04EBE:  b9 2e cd
            clc                         ; 04EC1:  18
            adc $02                     ; 04EC2:  65 02
            tay                         ; 04EC4:  a8
            lda tab_b1_ccc7,y           ; 04EC5:  b9 c7 cc
            sta $02                     ; 04EC8:  85 02
            pla                         ; 04ECA:  68
            lsr a                       ; 04ECB:  4a
            lsr a                       ; 04ECC:  4a
            lsr a                       ; 04ECD:  4a
            tay                         ; 04ECE:  a8
            lda tab_b1_ccc7+99,y        ; 04ECF:  b9 2a cd
            sta $03                     ; 04ED2:  85 03
            rts                         ; 04ED4:  60

b1_ced5:    sed                         ; 04ED5:  f8
            ldy #$70                    ; 04ED6:  a0 70
b1_ced8:    lda PPUCTRL,x               ; 04ED8:  bd 00 20
            jsr $0020                   ; 04EDB:  20 20 00
            brk                         ; 04EDE:  00
            hex b5                      ; 04EDF:  b5
            asl $2029,x                 ; 04EE0:  1e 29 20
            beq b1_ceed                 ; 04EE3:  f0 08
            lda #$00                    ; 04EE5:  a9 00
            sta $03c5,x                 ; 04EE7:  9d c5 03
            jmp $bf92                   ; 04EEA:  4c 92 bf

b1_ceed:    jsr $bf02                   ; 04EED:  20 02 bf
            ldy #$0d                    ; 04EF0:  a0 0d
            lda #$05                    ; 04EF2:  a9 05
            jsr $bf96                   ; 04EF4:  20 96 bf
            lda $0434,x                 ; 04EF7:  bd 34 04
            lsr a                       ; 04EFA:  4a
            lsr a                       ; 04EFB:  4a
            lsr a                       ; 04EFC:  4a
            lsr a                       ; 04EFD:  4a
            tay                         ; 04EFE:  a8
            lda $cf,x                   ; 04EFF:  b5 cf
            sec                         ; 04F01:  38
            sbc b1_ced5,y               ; 04F02:  f9 d5 ce
            bpl b1_cf0c                 ; 04F05:  10 05
            eor #$ff                    ; 04F07:  49 ff
            clc                         ; 04F09:  18
            adc #$01                    ; 04F0A:  69 01
b1_cf0c:    cmp #$08                    ; 04F0C:  c9 08
            bcs b1_cf1e                 ; 04F0E:  b0 0e
            lda $0434,x                 ; 04F10:  bd 34 04
            clc                         ; 04F13:  18
            adc #$10                    ; 04F14:  69 10
            sta $0434,x                 ; 04F16:  9d 34 04
            lsr a                       ; 04F19:  4a
            lsr a                       ; 04F1A:  4a
            lsr a                       ; 04F1B:  4a
            lsr a                       ; 04F1C:  4a
            tay                         ; 04F1D:  a8
b1_cf1e:    lda b1_ced8+2,y             ; 04F1E:  b9 da ce
            sta $03c5,x                 ; 04F21:  9d c5 03
            rts                         ; 04F24:  60

b1_cf25:    ora $30,x                   ; 04F25:  15 30
            rti                         ; 04F27:  40

            lda $1e,x                   ; 04F28:  b5 1e
            and #$20                    ; 04F2A:  29 20
            beq b1_cf31                 ; 04F2C:  f0 03
            jmp $bf63                   ; 04F2E:  4c 63 bf

b1_cf31:    lda $1e,x                   ; 04F31:  b5 1e
            beq b1_cf40                 ; 04F33:  f0 0b
            lda #$00                    ; 04F35:  a9 00
            sta $a0,x                   ; 04F37:  95 a0
            sta $06cb                   ; 04F39:  8d cb 06
            lda #$10                    ; 04F3C:  a9 10
            bne b1_cf53                 ; 04F3E:  d0 13
b1_cf40:    lda #$12                    ; 04F40:  a9 12
            sta $06cb                   ; 04F42:  8d cb 06
            ldy #$02                    ; 04F45:  a0 02
b1_cf47:    lda b1_cf25,y               ; 04F47:  b9 25 cf
            hex 99 01 00 ; sta $0001,y  ; 04F4A:  99 01 00
            dey                         ; 04F4D:  88
            bpl b1_cf47                 ; 04F4E:  10 f7
            jsr b1_cf6c                 ; 04F50:  20 6c cf
b1_cf53:    sta $58,x                   ; 04F53:  95 58
            ldy #$01                    ; 04F55:  a0 01
            lda $a0,x                   ; 04F57:  b5 a0
            and #$01                    ; 04F59:  29 01
            bne b1_cf67                 ; 04F5B:  d0 0a
            lda $58,x                   ; 04F5D:  b5 58
            eor #$ff                    ; 04F5F:  49 ff
            clc                         ; 04F61:  18
            adc #$01                    ; 04F62:  69 01
            sta $58,x                   ; 04F64:  95 58
            iny                         ; 04F66:  c8
b1_cf67:    sty $46,x                   ; 04F67:  94 46
            jmp $bf02                   ; 04F69:  4c 02 bf

b1_cf6c:    ldy #$00                    ; 04F6C:  a0 00
            jsr b1_e143                 ; 04F6E:  20 43 e1
            bpl b1_cf7d                 ; 04F71:  10 0a
            iny                         ; 04F73:  c8
            lda $00                     ; 04F74:  a5 00
            eor #$ff                    ; 04F76:  49 ff
            clc                         ; 04F78:  18
            adc #$01                    ; 04F79:  69 01
            sta $00                     ; 04F7B:  85 00
b1_cf7d:    lda $00                     ; 04F7D:  a5 00
            cmp #$3c                    ; 04F7F:  c9 3c
            bcc b1_cf9f                 ; 04F81:  90 1c
            lda #$3c                    ; 04F83:  a9 3c
            sta $00                     ; 04F85:  85 00
            lda $16,x                   ; 04F87:  b5 16
            cmp #$11                    ; 04F89:  c9 11
            bne b1_cf9f                 ; 04F8B:  d0 12
            tya                         ; 04F8D:  98
            cmp $a0,x                   ; 04F8E:  d5 a0
            beq b1_cf9f                 ; 04F90:  f0 0d
            lda $a0,x                   ; 04F92:  b5 a0
            beq b1_cf9c                 ; 04F94:  f0 06
            dec $58,x                   ; 04F96:  d6 58
            lda $58,x                   ; 04F98:  b5 58
            bne b1_cfdc                 ; 04F9A:  d0 40
b1_cf9c:    tya                         ; 04F9C:  98
            sta $a0,x                   ; 04F9D:  95 a0
b1_cf9f:    lda $00                     ; 04F9F:  a5 00
            and #$3c                    ; 04FA1:  29 3c
            lsr a                       ; 04FA3:  4a
            lsr a                       ; 04FA4:  4a
            sta $00                     ; 04FA5:  85 00
            ldy #$00                    ; 04FA7:  a0 00
            lda $57                     ; 04FA9:  a5 57
            beq b1_cfd1                 ; 04FAB:  f0 24
            lda $0775                   ; 04FAD:  ad 75 07
            beq b1_cfd1                 ; 04FB0:  f0 1f
            iny                         ; 04FB2:  c8
            lda $57                     ; 04FB3:  a5 57
b1_cfb5:    cmp #$19                    ; 04FB5:  c9 19
            bcc b1_cfc1                 ; 04FB7:  90 08
            lda $0775                   ; 04FB9:  ad 75 07
            cmp #$02                    ; 04FBC:  c9 02
            bcc b1_cfc1                 ; 04FBE:  90 01
            iny                         ; 04FC0:  c8
b1_cfc1:    lda $16,x                   ; 04FC1:  b5 16
            cmp #$12                    ; 04FC3:  c9 12
            bne b1_cfcb                 ; 04FC5:  d0 04
            lda $57                     ; 04FC7:  a5 57
            bne b1_cfd1                 ; 04FC9:  d0 06
b1_cfcb:    lda $a0,x                   ; 04FCB:  b5 a0
            bne b1_cfd1                 ; 04FCD:  d0 02
            ldy #$00                    ; 04FCF:  a0 00
b1_cfd1:    hex b9 01 00 ; lda $0001,y  ; 04FD1:  b9 01 00
            ldy $00                     ; 04FD4:  a4 00
b1_cfd6:    sec                         ; 04FD6:  38
            sbc #$01                    ; 04FD7:  e9 01
            dey                         ; 04FD9:  88
            bpl b1_cfd6                 ; 04FDA:  10 fa
b1_cfdc:    rts                         ; 04FDC:  60

tab_b1_cfdd: ; 15 bytes
            hex 1a 58 98 96 94 92 90 8e ; 04FDD:  1a 58 98 96 94 92 90 8e
            hex 8c 8a 88 86 84 82 80    ; 04FE5:  8c 8a 88 86 84 82 80

            ldx $0368                   ; 04FEC:  ae 68 03
            lda $16,x                   ; 04FEF:  b5 16
            cmp #$2d                    ; 04FF1:  c9 2d
            bne b1_d005                 ; 04FF3:  d0 10
            stx $08                     ; 04FF5:  86 08
            lda $1e,x                   ; 04FF7:  b5 1e
            beq b1_d015                 ; 04FF9:  f0 1a
            and #$40                    ; 04FFB:  29 40
            beq b1_d005                 ; 04FFD:  f0 06
            lda $cf,x                   ; 04FFF:  b5 cf
            cmp #$e0                    ; 05001:  c9 e0
            bcc b1_d00f                 ; 05003:  90 0a
b1_d005:    lda #$80                    ; 05005:  a9 80
            sta $fc                     ; 05007:  85 fc
            inc $0772                   ; 05009:  ee 72 07
            jmp b1_d071                 ; 0500C:  4c 71 d0

b1_d00f:    jsr $bf8c                   ; 0500F:  20 8c bf
            jmp b1_d17b                 ; 05012:  4c 7b d1

b1_d015:    dec $0364                   ; 05015:  ce 64 03
            bne b1_d05e                 ; 05018:  d0 44
            lda #$04                    ; 0501A:  a9 04
            sta $0364                   ; 0501C:  8d 64 03
            lda $0363                   ; 0501F:  ad 63 03
            eor #$01                    ; 05022:  49 01
            sta $0363                   ; 05024:  8d 63 03
            lda #$22                    ; 05027:  a9 22
            sta $05                     ; 05029:  85 05
            ldy $0369                   ; 0502B:  ac 69 03
            lda tab_b1_cfdd,y           ; 0502E:  b9 dd cf
            sta $04                     ; 05031:  85 04
            ldy $0300                   ; 05033:  ac 00 03
            iny                         ; 05036:  c8
            ldx #$0c                    ; 05037:  a2 0c
            jsr $8acd                   ; 05039:  20 cd 8a
            ldx $08                     ; 0503C:  a6 08
            jsr $8a8f                   ; 0503E:  20 8f 8a
            lda #$08                    ; 05041:  a9 08
            sta $fe                     ; 05043:  85 fe
            lda #$01                    ; 05045:  a9 01
            sta $fd                     ; 05047:  85 fd
            inc $0369                   ; 05049:  ee 69 03
            lda $0369                   ; 0504C:  ad 69 03
            cmp #$0f                    ; 0504F:  c9 0f
            bne b1_d05e                 ; 05051:  d0 0b
            jsr b1_c363                 ; 05053:  20 63 c3
            lda #$40                    ; 05056:  a9 40
            sta $1e,x                   ; 05058:  95 1e
            lda #$80                    ; 0505A:  a9 80
            sta $fe                     ; 0505C:  85 fe
b1_d05e:    jmp b1_d17b                 ; 0505E:  4c 7b d1

b1_d061:    and ($41,x)                 ; 05061:  21 41
            ora ($31),y                 ; 05063:  11 31
            lda $1e,x                   ; 05065:  b5 1e
            and #$20                    ; 05067:  29 20
            beq b1_d07f                 ; 05069:  f0 14
            lda $cf,x                   ; 0506B:  b5 cf
            cmp #$e0                    ; 0506D:  c9 e0
            bcc b1_d00f                 ; 0506F:  90 9e
b1_d071:    ldx #$04                    ; 05071:  a2 04
b1_d073:    jsr tab_b1_c982+22          ; 05073:  20 98 c9
            dex                         ; 05076:  ca
            bpl b1_d073                 ; 05077:  10 fa
            sta $06cb                   ; 05079:  8d cb 06
            ldx $08                     ; 0507C:  a6 08
            rts                         ; 0507E:  60

b1_d07f:    lda #$00                    ; 0507F:  a9 00
            sta $06cb                   ; 05081:  8d cb 06
            lda $0747                   ; 05084:  ad 47 07
            beq b1_d08c                 ; 05087:  f0 03
            jmp b1_d139                 ; 05089:  4c 39 d1

b1_d08c:    lda $0363                   ; 0508C:  ad 63 03
            bpl b1_d094                 ; 0508F:  10 03
            jmp b1_d10f                 ; 05091:  4c 0f d1

b1_d094:    dec $0364                   ; 05094:  ce 64 03
            bne b1_d0a6                 ; 05097:  d0 0d
            lda #$20                    ; 05099:  a9 20
            sta $0364                   ; 0509B:  8d 64 03
            lda $0363                   ; 0509E:  ad 63 03
            eor #$01                    ; 050A1:  49 01
            sta $0363                   ; 050A3:  8d 63 03
b1_d0a6:    lda $09                     ; 050A6:  a5 09
            and #$0f                    ; 050A8:  29 0f
            bne b1_d0b0                 ; 050AA:  d0 04
            lda #$02                    ; 050AC:  a9 02
            sta $46,x                   ; 050AE:  95 46
b1_d0b0:    lda $078a,x                 ; 050B0:  bd 8a 07
            beq b1_d0d1                 ; 050B3:  f0 1c
            jsr b1_e143                 ; 050B5:  20 43 e1
            bpl b1_d0d1                 ; 050B8:  10 17
            lda #$01                    ; 050BA:  a9 01
            sta $46,x                   ; 050BC:  95 46
            lda #$02                    ; 050BE:  a9 02
            sta $0365                   ; 050C0:  8d 65 03
            lda #$20                    ; 050C3:  a9 20
            sta $078a,x                 ; 050C5:  9d 8a 07
            sta $0790                   ; 050C8:  8d 90 07
            lda $87,x                   ; 050CB:  b5 87
            cmp #$c8                    ; 050CD:  c9 c8
            bcs b1_d10f                 ; 050CF:  b0 3e
b1_d0d1:    lda $09                     ; 050D1:  a5 09
            and #$03                    ; 050D3:  29 03
            bne b1_d10f                 ; 050D5:  d0 38
            lda $87,x                   ; 050D7:  b5 87
            cmp $0366                   ; 050D9:  cd 66 03
            bne b1_d0ea                 ; 050DC:  d0 0c
            lda $07a7,x                 ; 050DE:  bd a7 07
            and #$03                    ; 050E1:  29 03
            tay                         ; 050E3:  a8
            lda b1_d061,y               ; 050E4:  b9 61 d0
            sta $06dc                   ; 050E7:  8d dc 06
b1_d0ea:    lda $87,x                   ; 050EA:  b5 87
            clc                         ; 050EC:  18
            adc $0365                   ; 050ED:  6d 65 03
            sta $87,x                   ; 050F0:  95 87
            ldy $46,x                   ; 050F2:  b4 46
            cpy #$01                    ; 050F4:  c0 01
            beq b1_d10f                 ; 050F6:  f0 17
            ldy #$ff                    ; 050F8:  a0 ff
            sec                         ; 050FA:  38
            sbc $0366                   ; 050FB:  ed 66 03
            bpl b1_d107                 ; 050FE:  10 07
            eor #$ff                    ; 05100:  49 ff
            clc                         ; 05102:  18
            adc #$01                    ; 05103:  69 01
            ldy #$01                    ; 05105:  a0 01
b1_d107:    cmp $06dc                   ; 05107:  cd dc 06
            bcc b1_d10f                 ; 0510A:  90 03
            sty $0365                   ; 0510C:  8c 65 03
b1_d10f:    lda $078a,x                 ; 0510F:  bd 8a 07
            bne b1_d13c                 ; 05112:  d0 28
            jsr $bf8c                   ; 05114:  20 8c bf
            lda $075f                   ; 05117:  ad 5f 07
            cmp #$05                    ; 0511A:  c9 05
            bcc b1_d127                 ; 0511C:  90 09
            lda $09                     ; 0511E:  a5 09
            and #$03                    ; 05120:  29 03
            bne b1_d127                 ; 05122:  d0 03
            jsr $ba94                   ; 05124:  20 94 ba
b1_d127:    lda $cf,x                   ; 05127:  b5 cf
            cmp #$80                    ; 05129:  c9 80
            bcc b1_d149                 ; 0512B:  90 1c
            lda $07a7,x                 ; 0512D:  bd a7 07
            and #$03                    ; 05130:  29 03
            tay                         ; 05132:  a8
            lda b1_d061,y               ; 05133:  b9 61 d0
            sta $078a,x                 ; 05136:  9d 8a 07
b1_d139:    jmp b1_d149                 ; 05139:  4c 49 d1

b1_d13c:    cmp #$01                    ; 0513C:  c9 01
            bne b1_d149                 ; 0513E:  d0 09
            dec $cf,x                   ; 05140:  d6 cf
            jsr b1_c363                 ; 05142:  20 63 c3
            lda #$fe                    ; 05145:  a9 fe
            sta $a0,x                   ; 05147:  95 a0
b1_d149:    lda $075f                   ; 05149:  ad 5f 07
            cmp #$07                    ; 0514C:  c9 07
            beq b1_d154                 ; 0514E:  f0 04
            cmp #$05                    ; 05150:  c9 05
            bcs b1_d17b                 ; 05152:  b0 27
b1_d154:    lda $0790                   ; 05154:  ad 90 07
            bne b1_d17b                 ; 05157:  d0 22
            lda #$20                    ; 05159:  a9 20
            sta $0790                   ; 0515B:  8d 90 07
            lda $0363                   ; 0515E:  ad 63 03
            eor #$80                    ; 05161:  49 80
            sta $0363                   ; 05163:  8d 63 03
            bmi b1_d149                 ; 05166:  30 e1
            jsr b1_d1d9                 ; 05168:  20 d9 d1
            ldy $06cc                   ; 0516B:  ac cc 06
            beq b1_d173                 ; 0516E:  f0 03
            sec                         ; 05170:  38
            sbc #$10                    ; 05171:  e9 10
b1_d173:    sta $0790                   ; 05173:  8d 90 07
            lda #$15                    ; 05176:  a9 15
            sta $06cb                   ; 05178:  8d cb 06
b1_d17b:    jsr b1_d1bc                 ; 0517B:  20 bc d1
            ldy #$10                    ; 0517E:  a0 10
            lda $46,x                   ; 05180:  b5 46
            lsr a                       ; 05182:  4a
            bcc b1_d187                 ; 05183:  90 02
            ldy #$f0                    ; 05185:  a0 f0
b1_d187:    tya                         ; 05187:  98
            clc                         ; 05188:  18
            adc $87,x                   ; 05189:  75 87
            ldy $06cf                   ; 0518B:  ac cf 06
            hex 99 87 00 ; sta $0087,y  ; 0518E:  99 87 00
            lda $cf,x                   ; 05191:  b5 cf
            clc                         ; 05193:  18
            adc #$08                    ; 05194:  69 08
            hex 99 cf 00 ; sta $00cf,y  ; 05196:  99 cf 00
            lda $1e,x                   ; 05199:  b5 1e
            hex 99 1e 00 ; sta $001e,y  ; 0519B:  99 1e 00
            lda $46,x                   ; 0519E:  b5 46
            hex 99 46 00 ; sta $0046,y  ; 051A0:  99 46 00
            lda $08                     ; 051A3:  a5 08
            pha                         ; 051A5:  48
            ldx $06cf                   ; 051A6:  ae cf 06
            stx $08                     ; 051A9:  86 08
            lda #$2d                    ; 051AB:  a9 2d
            sta $16,x                   ; 051AD:  95 16
            jsr b1_d1bc                 ; 051AF:  20 bc d1
            pla                         ; 051B2:  68
            sta $08                     ; 051B3:  85 08
            tax                         ; 051B5:  aa
            lda #$00                    ; 051B6:  a9 00
            sta $036a                   ; 051B8:  8d 6a 03
b1_d1bb:    rts                         ; 051BB:  60

b1_d1bc:    inc $036a                   ; 051BC:  ee 6a 03
            jsr b1_c8d7                 ; 051BF:  20 d7 c8
            lda $1e,x                   ; 051C2:  b5 1e
            bne b1_d1bb                 ; 051C4:  d0 f5
            lda #$0a                    ; 051C6:  a9 0a
            sta $049a,x                 ; 051C8:  9d 9a 04
            jsr b1_e243                 ; 051CB:  20 43 e2
            jmp b1_d853                 ; 051CE:  4c 53 d8

tab_b1_d1d1: ; 8 bytes
            hex bf 40 bf bf bf 40 40 bf ; 051D1:  bf 40 bf bf bf 40 40 bf

b1_d1d9:    ldy $0367                   ; 051D9:  ac 67 03
            inc $0367                   ; 051DC:  ee 67 03
            lda $0367                   ; 051DF:  ad 67 03
            and #$07                    ; 051E2:  29 07
            sta $0367                   ; 051E4:  8d 67 03
            lda tab_b1_d1d1,y           ; 051E7:  b9 d1 d1
b1_d1ea:    rts                         ; 051EA:  60

            lda $0747                   ; 051EB:  ad 47 07
            bne b1_d220                 ; 051EE:  d0 30
            lda #$40                    ; 051F0:  a9 40
            ldy $06cc                   ; 051F2:  ac cc 06
            beq b1_d1f9                 ; 051F5:  f0 02
            lda #$60                    ; 051F7:  a9 60
b1_d1f9:    sta $00                     ; 051F9:  85 00
            lda $0401,x                 ; 051FB:  bd 01 04
            sec                         ; 051FE:  38
            sbc $00                     ; 051FF:  e5 00
            sta $0401,x                 ; 05201:  9d 01 04
            lda $87,x                   ; 05204:  b5 87
            sbc #$01                    ; 05206:  e9 01
            sta $87,x                   ; 05208:  95 87
            lda $6e,x                   ; 0520A:  b5 6e
            sbc #$00                    ; 0520C:  e9 00
            sta $6e,x                   ; 0520E:  95 6e
            ldy $0417,x                 ; 05210:  bc 17 04
            lda $cf,x                   ; 05213:  b5 cf
            cmp tab_b1_c59d,y           ; 05215:  d9 9d c5
            beq b1_d220                 ; 05218:  f0 06
            clc                         ; 0521A:  18
            adc $0434,x                 ; 0521B:  7d 34 04
            sta $cf,x                   ; 0521E:  95 cf
b1_d220:    jsr b1_f152                 ; 05220:  20 52 f1
            lda $1e,x                   ; 05223:  b5 1e
            bne b1_d1ea                 ; 05225:  d0 c3
            lda #$51                    ; 05227:  a9 51
            sta $00                     ; 05229:  85 00
            ldy #$02                    ; 0522B:  a0 02
            lda $09                     ; 0522D:  a5 09
            and #$02                    ; 0522F:  29 02
            beq b1_d235                 ; 05231:  f0 02
            ldy #$82                    ; 05233:  a0 82
b1_d235:    sty $01                     ; 05235:  84 01
            ldy $06e5,x                 ; 05237:  bc e5 06
            ldx #$00                    ; 0523A:  a2 00
b1_d23c:    lda $03b9                   ; 0523C:  ad b9 03
            sta $0200,y                 ; 0523F:  99 00 02
            lda $00                     ; 05242:  a5 00
            sta $0201,y                 ; 05244:  99 01 02
            inc $00                     ; 05247:  e6 00
            lda $01                     ; 05249:  a5 01
            sta $0202,y                 ; 0524B:  99 02 02
            lda $03ae                   ; 0524E:  ad ae 03
            sta $0203,y                 ; 05251:  99 03 02
            clc                         ; 05254:  18
            adc #$08                    ; 05255:  69 08
            sta $03ae                   ; 05257:  8d ae 03
            iny                         ; 0525A:  c8
            iny                         ; 0525B:  c8
            iny                         ; 0525C:  c8
            iny                         ; 0525D:  c8
            inx                         ; 0525E:  e8
            cpx #$03                    ; 0525F:  e0 03
            bcc b1_d23c                 ; 05261:  90 d9
            ldx $08                     ; 05263:  a6 08
            jsr b1_f1af                 ; 05265:  20 af f1
            ldy $06e5,x                 ; 05268:  bc e5 06
            lda $03d1                   ; 0526B:  ad d1 03
            lsr a                       ; 0526E:  4a
            pha                         ; 0526F:  48
            bcc b1_d277                 ; 05270:  90 05
            lda #$f8                    ; 05272:  a9 f8
            sta $020c,y                 ; 05274:  99 0c 02
b1_d277:    pla                         ; 05277:  68
            lsr a                       ; 05278:  4a
            pha                         ; 05279:  48
            bcc b1_d281                 ; 0527A:  90 05
            lda #$f8                    ; 0527C:  a9 f8
            sta $0208,y                 ; 0527E:  99 08 02
b1_d281:    pla                         ; 05281:  68
            lsr a                       ; 05282:  4a
            pha                         ; 05283:  48
            bcc b1_d28b                 ; 05284:  90 05
            lda #$f8                    ; 05286:  a9 f8
            sta $0204,y                 ; 05288:  99 04 02
b1_d28b:    pla                         ; 0528B:  68
            lsr a                       ; 0528C:  4a
            bcc b1_d294                 ; 0528D:  90 05
            lda #$f8                    ; 0528F:  a9 f8
            sta $0200,y                 ; 05291:  99 00 02
b1_d294:    rts                         ; 05294:  60

            dec $a0,x                   ; 05295:  d6 a0
            bne b1_d2a5                 ; 05297:  d0 0c
            lda #$08                    ; 05299:  a9 08
            sta $a0,x                   ; 0529B:  95 a0
            inc $58,x                   ; 0529D:  f6 58
            lda $58,x                   ; 0529F:  b5 58
            cmp #$03                    ; 052A1:  c9 03
            bcs b1_d2bd                 ; 052A3:  b0 18
b1_d2a5:    jsr b1_f152                 ; 052A5:  20 52 f1
            lda $03b9                   ; 052A8:  ad b9 03
            sta $03ba                   ; 052AB:  8d ba 03
            lda $03ae                   ; 052AE:  ad ae 03
            sta $03af                   ; 052B1:  8d af 03
            ldy $06e5,x                 ; 052B4:  bc e5 06
            lda $58,x                   ; 052B7:  b5 58
            jsr b1_ed17                 ; 052B9:  20 17 ed
            rts                         ; 052BC:  60

b1_d2bd:    lda #$00                    ; 052BD:  a9 00
            sta $0f,x                   ; 052BF:  95 0f
            lda #$08                    ; 052C1:  a9 08
            sta $fe                     ; 052C3:  85 fe
            lda #$05                    ; 052C5:  a9 05
            sta $0138                   ; 052C7:  8d 38 01
            jmp b1_d336                 ; 052CA:  4c 36 d3

tab_b1_d2cd: ; 37 bytes
            hex 00 00 08 08 00 08 00 08 ; 052CD:  00 00 08 08 00 08 00 08
            hex 54 55 56 57 a9 00 8d cb ; 052D5:  54 55 56 57 a9 00 8d cb
            hex 06 ad 46 07 c9 05 b0 2c ; 052DD:  06 ad 46 07 c9 05 b0 2c
            hex 20 04 8e 11 d3 f2 d2 12 ; 052E5:  20 04 8e 11 d3 f2 d2 12
            hex d3 4e d3 a2 d3          ; 052ED:  d3 4e d3 a2 d3

            ldy #$05                    ; 052F2:  a0 05
            lda $07fa                   ; 052F4:  ad fa 07
            cmp #$01                    ; 052F7:  c9 01
            beq b1_d309                 ; 052F9:  f0 0e
            ldy #$03                    ; 052FB:  a0 03
            cmp #$03                    ; 052FD:  c9 03
            beq b1_d309                 ; 052FF:  f0 08
            ldy #$00                    ; 05301:  a0 00
            cmp #$06                    ; 05303:  c9 06
            beq b1_d309                 ; 05305:  f0 02
            lda #$ff                    ; 05307:  a9 ff
b1_d309:    sta $06d7                   ; 05309:  8d d7 06
            sty $1e,x                   ; 0530C:  94 1e
b1_d30e:    inc $0746                   ; 0530E:  ee 46 07
            rts                         ; 05311:  60

            lda $07f8                   ; 05312:  ad f8 07
            ora $07f9                   ; 05315:  0d f9 07
            ora $07fa                   ; 05318:  0d fa 07
            beq b1_d30e                 ; 0531B:  f0 f1
            lda $09                     ; 0531D:  a5 09
            and #$04                    ; 0531F:  29 04
            beq b1_d327                 ; 05321:  f0 04
            lda #$10                    ; 05323:  a9 10
            sta $fe                     ; 05325:  85 fe
b1_d327:    ldy #$23                    ; 05327:  a0 23
            lda #$ff                    ; 05329:  a9 ff
            sta $0139                   ; 0532B:  8d 39 01
            jsr $8f5f                   ; 0532E:  20 5f 8f
            lda #$05                    ; 05331:  a9 05
            sta $0139                   ; 05333:  8d 39 01
b1_d336:    ldy #$0b                    ; 05336:  a0 0b
            lda $0753                   ; 05338:  ad 53 07
            beq b1_d33f                 ; 0533B:  f0 02
            ldy #$11                    ; 0533D:  a0 11
b1_d33f:    jsr $8f5f                   ; 0533F:  20 5f 8f
            lda $0753                   ; 05342:  ad 53 07
            asl a                       ; 05345:  0a
            asl a                       ; 05346:  0a
            asl a                       ; 05347:  0a
            asl a                       ; 05348:  0a
            ora #$04                    ; 05349:  09 04
            jmp $bc36                   ; 0534B:  4c 36 bc

            lda $cf,x                   ; 0534E:  b5 cf
            cmp #$72                    ; 05350:  c9 72
            bcc b1_d359                 ; 05352:  90 05
            dec $cf,x                   ; 05354:  d6 cf
            jmp b1_d365                 ; 05356:  4c 65 d3

b1_d359:    lda $06d7                   ; 05359:  ad d7 06
            beq b1_d396                 ; 0535C:  f0 38
            bmi b1_d396                 ; 0535E:  30 36
            lda #$16                    ; 05360:  a9 16
            sta $06cb                   ; 05362:  8d cb 06
b1_d365:    jsr b1_f152                 ; 05365:  20 52 f1
            ldy $06e5,x                 ; 05368:  bc e5 06
            ldx #$03                    ; 0536B:  a2 03
b1_d36d:    lda $03b9                   ; 0536D:  ad b9 03
            clc                         ; 05370:  18
            adc tab_b1_d2cd,x           ; 05371:  7d cd d2
            sta $0200,y                 ; 05374:  99 00 02
            lda tab_b1_d2cd+8,x         ; 05377:  bd d5 d2
            sta $0201,y                 ; 0537A:  99 01 02
            lda #$22                    ; 0537D:  a9 22
            sta $0202,y                 ; 0537F:  99 02 02
            lda $03ae                   ; 05382:  ad ae 03
            clc                         ; 05385:  18
            adc tab_b1_d2cd+4,x         ; 05386:  7d d1 d2
            sta $0203,y                 ; 05389:  99 03 02
            iny                         ; 0538C:  c8
            iny                         ; 0538D:  c8
            iny                         ; 0538E:  c8
            iny                         ; 0538F:  c8
            dex                         ; 05390:  ca
            bpl b1_d36d                 ; 05391:  10 da
            ldx $08                     ; 05393:  a6 08
            rts                         ; 05395:  60

b1_d396:    jsr b1_d365                 ; 05396:  20 65 d3
            lda #$06                    ; 05399:  a9 06
            sta $0796,x                 ; 0539B:  9d 96 07
b1_d39e:    inc $0746                   ; 0539E:  ee 46 07
            rts                         ; 053A1:  60

            jsr b1_d365                 ; 053A2:  20 65 d3
            lda $0796,x                 ; 053A5:  bd 96 07
            bne b1_d3af                 ; 053A8:  d0 05
            lda $07b1                   ; 053AA:  ad b1 07
            beq b1_d39e                 ; 053AD:  f0 ef
b1_d3af:    rts                         ; 053AF:  60

            lda $1e,x                   ; 053B0:  b5 1e
            bne b1_d40a                 ; 053B2:  d0 56
            lda $078a,x                 ; 053B4:  bd 8a 07
            bne b1_d40a                 ; 053B7:  d0 51
            lda $a0,x                   ; 053B9:  b5 a0
            bne b1_d3e0                 ; 053BB:  d0 23
            lda $58,x                   ; 053BD:  b5 58
            bmi b1_d3d5                 ; 053BF:  30 14
            jsr b1_e143                 ; 053C1:  20 43 e1
            bpl b1_d3cf                 ; 053C4:  10 09
            lda $00                     ; 053C6:  a5 00
            eor #$ff                    ; 053C8:  49 ff
            clc                         ; 053CA:  18
            adc #$01                    ; 053CB:  69 01
            sta $00                     ; 053CD:  85 00
b1_d3cf:    lda $00                     ; 053CF:  a5 00
            cmp #$21                    ; 053D1:  c9 21
            bcc b1_d40a                 ; 053D3:  90 35
b1_d3d5:    lda $58,x                   ; 053D5:  b5 58
            eor #$ff                    ; 053D7:  49 ff
            clc                         ; 053D9:  18
            adc #$01                    ; 053DA:  69 01
            sta $58,x                   ; 053DC:  95 58
            inc $a0,x                   ; 053DE:  f6 a0
b1_d3e0:    lda $0434,x                 ; 053E0:  bd 34 04
            ldy $58,x                   ; 053E3:  b4 58
            bpl b1_d3ea                 ; 053E5:  10 03
            lda $0417,x                 ; 053E7:  bd 17 04
b1_d3ea:    sta $00                     ; 053EA:  85 00
            lda $09                     ; 053EC:  a5 09
            lsr a                       ; 053EE:  4a
            bcc b1_d40a                 ; 053EF:  90 19
            lda $0747                   ; 053F1:  ad 47 07
            bne b1_d40a                 ; 053F4:  d0 14
            lda $cf,x                   ; 053F6:  b5 cf
            clc                         ; 053F8:  18
            adc $58,x                   ; 053F9:  75 58
            sta $cf,x                   ; 053FB:  95 cf
            cmp $00                     ; 053FD:  c5 00
            bne b1_d40a                 ; 053FF:  d0 09
            lda #$00                    ; 05401:  a9 00
            sta $a0,x                   ; 05403:  95 a0
            lda #$40                    ; 05405:  a9 40
            sta $078a,x                 ; 05407:  9d 8a 07
b1_d40a:    lda #$20                    ; 0540A:  a9 20
            sta $03c5,x                 ; 0540C:  9d c5 03
            rts                         ; 0540F:  60

b1_d410:    sta $07                     ; 05410:  85 07
            lda $34,x                   ; 05412:  b5 34
            bne b1_d424                 ; 05414:  d0 0e
            ldy #$18                    ; 05416:  a0 18
            lda $58,x                   ; 05418:  b5 58
            clc                         ; 0541A:  18
            adc $07                     ; 0541B:  65 07
            sta $58,x                   ; 0541D:  95 58
            lda $a0,x                   ; 0541F:  b5 a0
            adc #$00                    ; 05421:  69 00
            rts                         ; 05423:  60

b1_d424:    ldy #$08                    ; 05424:  a0 08
            lda $58,x                   ; 05426:  b5 58
            sec                         ; 05428:  38
            sbc $07                     ; 05429:  e5 07
            sta $58,x                   ; 0542B:  95 58
            lda $a0,x                   ; 0542D:  b5 a0
            sbc #$00                    ; 0542F:  e9 00
            rts                         ; 05431:  60

            lda $b6,x                   ; 05432:  b5 b6
            cmp #$03                    ; 05434:  c9 03
            bne b1_d43b                 ; 05436:  d0 03
            jmp tab_b1_c982+22          ; 05438:  4c 98 c9

b1_d43b:    lda $1e,x                   ; 0543B:  b5 1e
            bpl b1_d440                 ; 0543D:  10 01
            rts                         ; 0543F:  60

b1_d440:    tay                         ; 05440:  a8
            lda $03a2,x                 ; 05441:  bd a2 03
            sta $00                     ; 05444:  85 00
            lda $46,x                   ; 05446:  b5 46
            beq b1_d44d                 ; 05448:  f0 03
            jmp b1_d5bb                 ; 0544A:  4c bb d5

b1_d44d:    lda #$2d                    ; 0544D:  a9 2d
            cmp $cf,x                   ; 0544F:  d5 cf
            bcc b1_d462                 ; 05451:  90 0f
            cpy $00                     ; 05453:  c4 00
            beq tab_b1_d45f             ; 05455:  f0 08
            clc                         ; 05457:  18
            adc #$02                    ; 05458:  69 02
            sta $cf,x                   ; 0545A:  95 cf
            jmp b1_d5b1                 ; 0545C:  4c b1 d5

tab_b1_d45f: ; 3 bytes
            hex 4c 98 d5                ; 0545F:  4c 98 d5

b1_d462:    hex d9 cf 00 ; cmp $00cf,y  ; 05462:  d9 cf 00
            bcc b1_d474                 ; 05465:  90 0d
            cpx $00                     ; 05467:  e4 00
            beq tab_b1_d45f             ; 05469:  f0 f4
            clc                         ; 0546B:  18
            adc #$02                    ; 0546C:  69 02
            hex 99 cf 00 ; sta $00cf,y  ; 0546E:  99 cf 00
            jmp b1_d5b1                 ; 05471:  4c b1 d5

b1_d474:    lda $cf,x                   ; 05474:  b5 cf
            pha                         ; 05476:  48
            lda $03a2,x                 ; 05477:  bd a2 03
            bpl b1_d494                 ; 0547A:  10 18
            lda $0434,x                 ; 0547C:  bd 34 04
            clc                         ; 0547F:  18
            adc #$05                    ; 05480:  69 05
            sta $00                     ; 05482:  85 00
            lda $a0,x                   ; 05484:  b5 a0
            adc #$00                    ; 05486:  69 00
            bmi b1_d4a4                 ; 05488:  30 1a
            bne b1_d498                 ; 0548A:  d0 0c
            lda $00                     ; 0548C:  a5 00
            cmp #$0b                    ; 0548E:  c9 0b
            bcc b1_d49e                 ; 05490:  90 0c
            bcs b1_d498                 ; 05492:  b0 04
b1_d494:    cmp $08                     ; 05494:  c5 08
            beq b1_d4a4                 ; 05496:  f0 0c
b1_d498:    jsr $bfb7                   ; 05498:  20 b7 bf
            jmp b1_d4a7                 ; 0549B:  4c a7 d4

b1_d49e:    jsr b1_d5b1                 ; 0549E:  20 b1 d5
            jmp b1_d4a7                 ; 054A1:  4c a7 d4

b1_d4a4:    jsr $bfb4                   ; 054A4:  20 b4 bf
b1_d4a7:    ldy $1e,x                   ; 054A7:  b4 1e
            pla                         ; 054A9:  68
            sec                         ; 054AA:  38
            sbc $cf,x                   ; 054AB:  f5 cf
            clc                         ; 054AD:  18
            hex 79 cf 00 ; adc $00cf,y  ; 054AE:  79 cf 00
            hex 99 cf 00 ; sta $00cf,y  ; 054B1:  99 cf 00
            lda $03a2,x                 ; 054B4:  bd a2 03
            bmi b1_d4bd                 ; 054B7:  30 04
            tax                         ; 054B9:  aa
            jsr b1_dc20+1               ; 054BA:  20 21 dc
b1_d4bd:    ldy $08                     ; 054BD:  a4 08
            hex b9 a0 00 ; lda $00a0,y  ; 054BF:  b9 a0 00
            ora $0434,y                 ; 054C2:  19 34 04
            beq b1_d53e                 ; 054C5:  f0 77
            ldx $0300                   ; 054C7:  ae 00 03
            cpx #$20                    ; 054CA:  e0 20
            bcs b1_d53e                 ; 054CC:  b0 70
            hex b9 a0 00 ; lda $00a0,y  ; 054CE:  b9 a0 00
            pha                         ; 054D1:  48
            pha                         ; 054D2:  48
            jsr b1_d541                 ; 054D3:  20 41 d5
            lda $01                     ; 054D6:  a5 01
            sta $0301,x                 ; 054D8:  9d 01 03
            lda $00                     ; 054DB:  a5 00
            sta $0302,x                 ; 054DD:  9d 02 03
            lda #$02                    ; 054E0:  a9 02
            sta $0303,x                 ; 054E2:  9d 03 03
            hex b9 a0 00 ; lda $00a0,y  ; 054E5:  b9 a0 00
            bmi b1_d4f7                 ; 054E8:  30 0d
            lda #$a2                    ; 054EA:  a9 a2
            sta $0304,x                 ; 054EC:  9d 04 03
            lda #$a3                    ; 054EF:  a9 a3
            sta $0305,x                 ; 054F1:  9d 05 03
            jmp b1_d4ff                 ; 054F4:  4c ff d4

b1_d4f7:    lda #$24                    ; 054F7:  a9 24
            sta $0304,x                 ; 054F9:  9d 04 03
            sta $0305,x                 ; 054FC:  9d 05 03
b1_d4ff:    hex b9 1e 00 ; lda $001e,y  ; 054FF:  b9 1e 00
            tay                         ; 05502:  a8
            pla                         ; 05503:  68
            eor #$ff                    ; 05504:  49 ff
            jsr b1_d541                 ; 05506:  20 41 d5
            lda $01                     ; 05509:  a5 01
            sta $0306,x                 ; 0550B:  9d 06 03
            lda $00                     ; 0550E:  a5 00
            sta $0307,x                 ; 05510:  9d 07 03
            lda #$02                    ; 05513:  a9 02
            sta $0308,x                 ; 05515:  9d 08 03
            pla                         ; 05518:  68
            bpl b1_d528                 ; 05519:  10 0d
            lda #$a2                    ; 0551B:  a9 a2
            sta $0309,x                 ; 0551D:  9d 09 03
            lda #$a3                    ; 05520:  a9 a3
            sta $030a,x                 ; 05522:  9d 0a 03
            jmp b1_d530                 ; 05525:  4c 30 d5

b1_d528:    lda #$24                    ; 05528:  a9 24
            sta $0309,x                 ; 0552A:  9d 09 03
            sta $030a,x                 ; 0552D:  9d 0a 03
b1_d530:    lda #$00                    ; 05530:  a9 00
            sta $030b,x                 ; 05532:  9d 0b 03
            lda $0300                   ; 05535:  ad 00 03
            clc                         ; 05538:  18
            adc #$0a                    ; 05539:  69 0a
            sta $0300                   ; 0553B:  8d 00 03
b1_d53e:    ldx $08                     ; 0553E:  a6 08
            rts                         ; 05540:  60

b1_d541:    pha                         ; 05541:  48
            hex b9 87 00 ; lda $0087,y  ; 05542:  b9 87 00
            clc                         ; 05545:  18
            adc #$08                    ; 05546:  69 08
            ldx $06cc                   ; 05548:  ae cc 06
            bne b1_d550                 ; 0554B:  d0 03
            clc                         ; 0554D:  18
            adc #$10                    ; 0554E:  69 10
b1_d550:    pha                         ; 05550:  48
            hex b9 6e 00 ; lda $006e,y  ; 05551:  b9 6e 00
            adc #$00                    ; 05554:  69 00
            sta $02                     ; 05556:  85 02
            pla                         ; 05558:  68
            and #$f0                    ; 05559:  29 f0
            lsr a                       ; 0555B:  4a
            lsr a                       ; 0555C:  4a
            lsr a                       ; 0555D:  4a
            sta $00                     ; 0555E:  85 00
            ldx $cf,y                   ; 05560:  b6 cf
            pla                         ; 05562:  68
            bpl b1_d56a                 ; 05563:  10 05
            txa                         ; 05565:  8a
            clc                         ; 05566:  18
            adc #$08                    ; 05567:  69 08
            tax                         ; 05569:  aa
b1_d56a:    txa                         ; 0556A:  8a
            ldx $0300                   ; 0556B:  ae 00 03
            asl a                       ; 0556E:  0a
            rol a                       ; 0556F:  2a
            pha                         ; 05570:  48
            rol a                       ; 05571:  2a
            and #$03                    ; 05572:  29 03
            ora #$20                    ; 05574:  09 20
            sta $01                     ; 05576:  85 01
            lda $02                     ; 05578:  a5 02
            and #$01                    ; 0557A:  29 01
            asl a                       ; 0557C:  0a
            asl a                       ; 0557D:  0a
            ora $01                     ; 0557E:  05 01
            sta $01                     ; 05580:  85 01
            pla                         ; 05582:  68
            and #$e0                    ; 05583:  29 e0
            clc                         ; 05585:  18
            adc $00                     ; 05586:  65 00
            sta $00                     ; 05588:  85 00
            hex b9 cf 00 ; lda $00cf,y  ; 0558A:  b9 cf 00
            cmp #$e8                    ; 0558D:  c9 e8
            bcc b1_d597                 ; 0558F:  90 06
            lda $00                     ; 05591:  a5 00
            and #$bf                    ; 05593:  29 bf
            sta $00                     ; 05595:  85 00
b1_d597:    rts                         ; 05597:  60

            tya                         ; 05598:  98
            tax                         ; 05599:  aa
            jsr b1_f1af                 ; 0559A:  20 af f1
            lda #$06                    ; 0559D:  a9 06
            jsr b1_da11                 ; 0559F:  20 11 da
            lda $03ad                   ; 055A2:  ad ad 03
            sta $0117,x                 ; 055A5:  9d 17 01
            lda $ce                     ; 055A8:  a5 ce
            sta $011e,x                 ; 055AA:  9d 1e 01
            lda #$01                    ; 055AD:  a9 01
            sta $46,x                   ; 055AF:  95 46
b1_d5b1:    jsr b1_c363                 ; 055B1:  20 63 c3
            hex 99 a0 00 ; sta $00a0,y  ; 055B4:  99 a0 00
            sta $0434,y                 ; 055B7:  99 34 04
            rts                         ; 055BA:  60

b1_d5bb:    tya                         ; 055BB:  98
            pha                         ; 055BC:  48
            jsr $bf6b                   ; 055BD:  20 6b bf
            pla                         ; 055C0:  68
            tax                         ; 055C1:  aa
            jsr $bf6b                   ; 055C2:  20 6b bf
            ldx $08                     ; 055C5:  a6 08
            lda $03a2,x                 ; 055C7:  bd a2 03
            bmi b1_d5d0                 ; 055CA:  30 04
            tax                         ; 055CC:  aa
            jsr b1_dc20+1               ; 055CD:  20 21 dc
b1_d5d0:    ldx $08                     ; 055D0:  a6 08
            rts                         ; 055D2:  60

            lda $a0,x                   ; 055D3:  b5 a0
            ora $0434,x                 ; 055D5:  1d 34 04
            bne b1_d5ef                 ; 055D8:  d0 15
            sta $0417,x                 ; 055DA:  9d 17 04
            lda $cf,x                   ; 055DD:  b5 cf
            cmp $0401,x                 ; 055DF:  dd 01 04
            bcs b1_d5ef                 ; 055E2:  b0 0b
            lda $09                     ; 055E4:  a5 09
            and #$07                    ; 055E6:  29 07
            bne b1_d5ec                 ; 055E8:  d0 02
            inc $cf,x                   ; 055EA:  f6 cf
b1_d5ec:    jmp b1_d5fe                 ; 055EC:  4c fe d5

b1_d5ef:    lda $cf,x                   ; 055EF:  b5 cf
            cmp $58,x                   ; 055F1:  d5 58
            bcc b1_d5fb                 ; 055F3:  90 06
            jsr $bfb7                   ; 055F5:  20 b7 bf
            jmp b1_d5fe                 ; 055F8:  4c fe d5

b1_d5fb:    jsr $bfb4                   ; 055FB:  20 b4 bf
b1_d5fe:    lda $03a2,x                 ; 055FE:  bd a2 03
            bmi b1_d606                 ; 05601:  30 03
            jsr b1_dc20+1               ; 05603:  20 21 dc
b1_d606:    rts                         ; 05606:  60

            lda #$0e                    ; 05607:  a9 0e
            jsr b1_cb47                 ; 05609:  20 47 cb
            jsr b1_cb66                 ; 0560C:  20 66 cb
            lda $03a2,x                 ; 0560F:  bd a2 03
            bmi b1_d630                 ; 05612:  30 1c
b1_d614:    lda $86                     ; 05614:  a5 86
            clc                         ; 05616:  18
            adc $00                     ; 05617:  65 00
            sta $86                     ; 05619:  85 86
            lda $6d                     ; 0561B:  a5 6d
            ldy $00                     ; 0561D:  a4 00
            bmi b1_d626                 ; 0561F:  30 05
            adc #$00                    ; 05621:  69 00
            jmp b1_d628                 ; 05623:  4c 28 d6

b1_d626:    sbc #$00                    ; 05626:  e9 00
b1_d628:    sta $6d                     ; 05628:  85 6d
            sty $03a1                   ; 0562A:  8c a1 03
            jsr b1_dc20+1               ; 0562D:  20 21 dc
b1_d630:    rts                         ; 05630:  60

            lda $03a2,x                 ; 05631:  bd a2 03
            bmi b1_d63c                 ; 05634:  30 06
            jsr $bf88                   ; 05636:  20 88 bf
            jsr b1_dc20+1               ; 05639:  20 21 dc
b1_d63c:    rts                         ; 0563C:  60

            jsr $bf02                   ; 0563D:  20 02 bf
            sta $00                     ; 05640:  85 00
            lda $03a2,x                 ; 05642:  bd a2 03
            bmi b1_d64e                 ; 05645:  30 07
            lda #$10                    ; 05647:  a9 10
            sta $58,x                   ; 05649:  95 58
            jsr b1_d614                 ; 0564B:  20 14 d6
b1_d64e:    rts                         ; 0564E:  60

            jsr b1_d65b                 ; 0564F:  20 5b d6
            jmp b1_d5fe                 ; 05652:  4c fe d5

b1_d655:    jsr b1_d65b                 ; 05655:  20 5b d6
            jmp b1_d671                 ; 05658:  4c 71 d6

b1_d65b:    lda $0747                   ; 0565B:  ad 47 07
            bne b1_d679                 ; 0565E:  d0 19
            lda $0417,x                 ; 05660:  bd 17 04
            clc                         ; 05663:  18
            adc $0434,x                 ; 05664:  7d 34 04
            sta $0417,x                 ; 05667:  9d 17 04
            lda $cf,x                   ; 0566A:  b5 cf
            adc $a0,x                   ; 0566C:  75 a0
            sta $cf,x                   ; 0566E:  95 cf
            rts                         ; 05670:  60

b1_d671:    lda $03a2,x                 ; 05671:  bd a2 03
            beq b1_d679                 ; 05674:  f0 03
            jsr b1_dc18+1               ; 05676:  20 19 dc
b1_d679:    rts                         ; 05679:  60

b1_d67a:    lda $16,x                   ; 0567A:  b5 16
            cmp #$14                    ; 0567C:  c9 14
            beq b1_d6d5                 ; 0567E:  f0 55
            lda $071c                   ; 05680:  ad 1c 07
            ldy $16,x                   ; 05683:  b4 16
            cpy #$05                    ; 05685:  c0 05
            beq b1_d68d                 ; 05687:  f0 04
            cpy #$0d                    ; 05689:  c0 0d
            bne b1_d68f                 ; 0568B:  d0 02
b1_d68d:    adc #$38                    ; 0568D:  69 38
b1_d68f:    sbc #$48                    ; 0568F:  e9 48
            sta $01                     ; 05691:  85 01
            lda $071a                   ; 05693:  ad 1a 07
            sbc #$00                    ; 05696:  e9 00
            sta $00                     ; 05698:  85 00
            lda $071d                   ; 0569A:  ad 1d 07
            adc #$48                    ; 0569D:  69 48
            sta $03                     ; 0569F:  85 03
            lda $071b                   ; 056A1:  ad 1b 07
            adc #$00                    ; 056A4:  69 00
            sta $02                     ; 056A6:  85 02
            lda $87,x                   ; 056A8:  b5 87
            cmp $01                     ; 056AA:  c5 01
            lda $6e,x                   ; 056AC:  b5 6e
            sbc $00                     ; 056AE:  e5 00
            bmi b1_d6d2                 ; 056B0:  30 20
            lda $87,x                   ; 056B2:  b5 87
            cmp $03                     ; 056B4:  c5 03
            lda $6e,x                   ; 056B6:  b5 6e
            sbc $02                     ; 056B8:  e5 02
            bmi b1_d6d5                 ; 056BA:  30 19
            lda $1e,x                   ; 056BC:  b5 1e
            cmp #$05                    ; 056BE:  c9 05
            beq b1_d6d5                 ; 056C0:  f0 13
            cpy #$0d                    ; 056C2:  c0 0d
            beq b1_d6d5                 ; 056C4:  f0 0f
            cpy #$30                    ; 056C6:  c0 30
            beq b1_d6d5                 ; 056C8:  f0 0b
            cpy #$31                    ; 056CA:  c0 31
            beq b1_d6d5                 ; 056CC:  f0 07
            cpy #$32                    ; 056CE:  c0 32
            beq b1_d6d5                 ; 056D0:  f0 03
b1_d6d2:    jsr tab_b1_c982+22          ; 056D2:  20 98 c9
b1_d6d5:    rts                         ; 056D5:  60

            hex ff ff ff                ; 056D6:  ff ff ff

            lda $24,x                   ; 056D9:  b5 24
            beq b1_d733                 ; 056DB:  f0 56
            asl a                       ; 056DD:  0a
            bcs b1_d733                 ; 056DE:  b0 53
            lda $09                     ; 056E0:  a5 09
            lsr a                       ; 056E2:  4a
            bcs b1_d733                 ; 056E3:  b0 4e
            txa                         ; 056E5:  8a
            asl a                       ; 056E6:  0a
            asl a                       ; 056E7:  0a
            clc                         ; 056E8:  18
            adc #$1c                    ; 056E9:  69 1c
            tay                         ; 056EB:  a8
            ldx #$04                    ; 056EC:  a2 04
b1_d6ee:    stx $01                     ; 056EE:  86 01
            tya                         ; 056F0:  98
            pha                         ; 056F1:  48
            lda $1e,x                   ; 056F2:  b5 1e
            and #$20                    ; 056F4:  29 20
            bne b1_d72c                 ; 056F6:  d0 34
            lda $0f,x                   ; 056F8:  b5 0f
            beq b1_d72c                 ; 056FA:  f0 30
            lda $16,x                   ; 056FC:  b5 16
            cmp #$24                    ; 056FE:  c9 24
            bcc b1_d706                 ; 05700:  90 04
            cmp #$2b                    ; 05702:  c9 2b
            bcc b1_d72c                 ; 05704:  90 26
b1_d706:    cmp #$06                    ; 05706:  c9 06
            bne b1_d710                 ; 05708:  d0 06
            lda $1e,x                   ; 0570A:  b5 1e
            cmp #$02                    ; 0570C:  c9 02
            bcs b1_d72c                 ; 0570E:  b0 1c
b1_d710:    lda $03d8,x                 ; 05710:  bd d8 03
            bne b1_d72c                 ; 05713:  d0 17
            txa                         ; 05715:  8a
            asl a                       ; 05716:  0a
            asl a                       ; 05717:  0a
            clc                         ; 05718:  18
            adc #$04                    ; 05719:  69 04
            tax                         ; 0571B:  aa
            jsr b1_e327                 ; 0571C:  20 27 e3
            ldx $08                     ; 0571F:  a6 08
            bcc b1_d72c                 ; 05721:  90 09
            lda #$80                    ; 05723:  a9 80
            sta $24,x                   ; 05725:  95 24
            ldx $01                     ; 05727:  a6 01
            jsr b1_d73e                 ; 05729:  20 3e d7
b1_d72c:    pla                         ; 0572C:  68
            tay                         ; 0572D:  a8
            ldx $01                     ; 0572E:  a6 01
            dex                         ; 05730:  ca
            bpl b1_d6ee                 ; 05731:  10 bb
b1_d733:    ldx $08                     ; 05733:  a6 08
            rts                         ; 05735:  60

tab_b1_d736: ; 4 bytes
            hex 06 00 02 12             ; 05736:  06 00 02 12

            ora ($07),y                 ; 0573A:  11 07
            ora $2d                     ; 0573C:  05 2d
b1_d73e:    jsr b1_f152                 ; 0573E:  20 52 f1
            ldx $01                     ; 05741:  a6 01
            lda $0f,x                   ; 05743:  b5 0f
            bpl b1_d752                 ; 05745:  10 0b
            and #$0f                    ; 05747:  29 0f
            tax                         ; 05749:  aa
            lda $16,x                   ; 0574A:  b5 16
            cmp #$2d                    ; 0574C:  c9 2d
            beq b1_d75c                 ; 0574E:  f0 0c
            ldx $01                     ; 05750:  a6 01
b1_d752:    lda $16,x                   ; 05752:  b5 16
            cmp #$02                    ; 05754:  c9 02
            beq b1_d7c3                 ; 05756:  f0 6b
            cmp #$2d                    ; 05758:  c9 2d
            bne b1_d789                 ; 0575A:  d0 2d
b1_d75c:    dec $0483                   ; 0575C:  ce 83 04
            bne b1_d7c3                 ; 0575F:  d0 62
            jsr b1_c363                 ; 05761:  20 63 c3
            sta $58,x                   ; 05764:  95 58
            sta $06cb                   ; 05766:  8d cb 06
            lda #$fe                    ; 05769:  a9 fe
            sta $a0,x                   ; 0576B:  95 a0
            ldy $075f                   ; 0576D:  ac 5f 07
            lda tab_b1_d736,y           ; 05770:  b9 36 d7
            sta $16,x                   ; 05773:  95 16
            lda #$20                    ; 05775:  a9 20
            cpy #$03                    ; 05777:  c0 03
            bcs b1_d77d                 ; 05779:  b0 02
            ora #$03                    ; 0577B:  09 03
b1_d77d:    sta $1e,x                   ; 0577D:  95 1e
            lda #$80                    ; 0577F:  a9 80
            sta $fe                     ; 05781:  85 fe
            ldx $01                     ; 05783:  a6 01
            lda #$09                    ; 05785:  a9 09
            bne b1_d7bc                 ; 05787:  d0 33
b1_d789:    cmp #$08                    ; 05789:  c9 08
            beq b1_d7c3                 ; 0578B:  f0 36
            cmp #$0c                    ; 0578D:  c9 0c
            beq b1_d7c3                 ; 0578F:  f0 32
            cmp #$15                    ; 05791:  c9 15
            bcs b1_d7c3                 ; 05793:  b0 2e
b1_d795:    lda $16,x                   ; 05795:  b5 16
            cmp #$0d                    ; 05797:  c9 0d
            bne b1_d7a1                 ; 05799:  d0 06
            lda $cf,x                   ; 0579B:  b5 cf
            adc #$18                    ; 0579D:  69 18
            sta $cf,x                   ; 0579F:  95 cf
b1_d7a1:    jsr b1_e01b                 ; 057A1:  20 1b e0
            lda $1e,x                   ; 057A4:  b5 1e
            and #$1f                    ; 057A6:  29 1f
            ora #$20                    ; 057A8:  09 20
            sta $1e,x                   ; 057AA:  95 1e
            lda #$02                    ; 057AC:  a9 02
            ldy $16,x                   ; 057AE:  b4 16
            cpy #$05                    ; 057B0:  c0 05
            bne b1_d7b6                 ; 057B2:  d0 02
            lda #$06                    ; 057B4:  a9 06
b1_d7b6:    cpy #$06                    ; 057B6:  c0 06
            bne b1_d7bc                 ; 057B8:  d0 02
            lda #$01                    ; 057BA:  a9 01
b1_d7bc:    jsr b1_da11                 ; 057BC:  20 11 da
            lda #$08                    ; 057BF:  a9 08
            sta $ff                     ; 057C1:  85 ff
b1_d7c3:    rts                         ; 057C3:  60

            lda $09                     ; 057C4:  a5 09
            lsr a                       ; 057C6:  4a
            bcc b1_d7ff                 ; 057C7:  90 36
            lda $0747                   ; 057C9:  ad 47 07
            ora $03d6                   ; 057CC:  0d d6 03
            bne b1_d7ff                 ; 057CF:  d0 2e
            txa                         ; 057D1:  8a
            asl a                       ; 057D2:  0a
            asl a                       ; 057D3:  0a
            clc                         ; 057D4:  18
            adc #$24                    ; 057D5:  69 24
            tay                         ; 057D7:  a8
            jsr b1_e325                 ; 057D8:  20 25 e3
            ldx $08                     ; 057DB:  a6 08
            bcc b1_d7fa                 ; 057DD:  90 1b
            lda $06be,x                 ; 057DF:  bd be 06
            bne b1_d7ff                 ; 057E2:  d0 1b
            lda #$01                    ; 057E4:  a9 01
            sta $06be,x                 ; 057E6:  9d be 06
            lda $64,x                   ; 057E9:  b5 64
            eor #$ff                    ; 057EB:  49 ff
            clc                         ; 057ED:  18
            adc #$01                    ; 057EE:  69 01
            sta $64,x                   ; 057F0:  95 64
            lda $079f                   ; 057F2:  ad 9f 07
            bne b1_d7ff                 ; 057F5:  d0 08
            jmp b1_d92c                 ; 057F7:  4c 2c d9

b1_d7fa:    lda #$00                    ; 057FA:  a9 00
            sta $06be,x                 ; 057FC:  9d be 06
b1_d7ff:    rts                         ; 057FF:  60

b1_d800:    jsr tab_b1_c982+22          ; 05800:  20 98 c9
            lda #$06                    ; 05803:  a9 06
            jsr b1_da11                 ; 05805:  20 11 da
            lda #$20                    ; 05808:  a9 20
            sta $fe                     ; 0580A:  85 fe
            lda $39                     ; 0580C:  a5 39
            cmp #$02                    ; 0580E:  c9 02
            bcc b1_d820                 ; 05810:  90 0e
            cmp #$03                    ; 05812:  c9 03
            beq b1_d83a                 ; 05814:  f0 24
            lda #$23                    ; 05816:  a9 23
            sta $079f                   ; 05818:  8d 9f 07
            lda #$40                    ; 0581B:  a9 40
            sta $fb                     ; 0581D:  85 fb
            rts                         ; 0581F:  60

b1_d820:    lda $0756                   ; 05820:  ad 56 07
            beq b1_d840                 ; 05823:  f0 1b
            cmp #$01                    ; 05825:  c9 01
            bne b1_d84c                 ; 05827:  d0 23
            ldx $08                     ; 05829:  a6 08
            lda #$02                    ; 0582B:  a9 02
            sta $0756                   ; 0582D:  8d 56 07
            jsr $85f1                   ; 05830:  20 f1 85
            ldx $08                     ; 05833:  a6 08
            lda #$0c                    ; 05835:  a9 0c
            jmp b1_d847                 ; 05837:  4c 47 d8

b1_d83a:    lda #$0b                    ; 0583A:  a9 0b
            sta $0110,x                 ; 0583C:  9d 10 01
            rts                         ; 0583F:  60

b1_d840:    lda #$01                    ; 05840:  a9 01
            sta $0756                   ; 05842:  8d 56 07
            lda #$09                    ; 05845:  a9 09
b1_d847:    ldy #$00                    ; 05847:  a0 00
            jsr b1_d948                 ; 05849:  20 48 d9
b1_d84c:    rts                         ; 0584C:  60

            clc                         ; 0584D:  18
            inx                         ; 0584E:  e8
b1_d84f:    bmi b1_d820+1               ; 0584F:  30 d0
b1_d851:    php                         ; 05851:  08
            sed                         ; 05852:  f8
b1_d853:    lda $09                     ; 05853:  a5 09
            lsr a                       ; 05855:  4a
            bcs b1_d84c                 ; 05856:  b0 f4
            jsr b1_dc41                 ; 05858:  20 41 dc
            bcs b1_d880                 ; 0585B:  b0 23
            lda $03d8,x                 ; 0585D:  bd d8 03
            bne b1_d880                 ; 05860:  d0 1e
            lda $0e                     ; 05862:  a5 0e
            cmp #$08                    ; 05864:  c9 08
            bne b1_d880                 ; 05866:  d0 18
            lda $1e,x                   ; 05868:  b5 1e
            and #$20                    ; 0586A:  29 20
            bne b1_d880                 ; 0586C:  d0 12
            jsr b1_dc52                 ; 0586E:  20 52 dc
            jsr b1_e325                 ; 05871:  20 25 e3
            ldx $08                     ; 05874:  a6 08
            bcs b1_d881                 ; 05876:  b0 09
            lda $0491,x                 ; 05878:  bd 91 04
            and #$fe                    ; 0587B:  29 fe
            sta $0491,x                 ; 0587D:  9d 91 04
b1_d880:    rts                         ; 05880:  60

b1_d881:    ldy $16,x                   ; 05881:  b4 16
            cpy #$2e                    ; 05883:  c0 2e
            bne b1_d88a                 ; 05885:  d0 03
            jmp b1_d800                 ; 05887:  4c 00 d8

b1_d88a:    lda $079f                   ; 0588A:  ad 9f 07
            beq b1_d895                 ; 0588D:  f0 06
            jmp b1_d795                 ; 0588F:  4c 95 d7

b1_d892:    asl a                       ; 05892:  0a
            asl $04                     ; 05893:  06 04
b1_d895:    lda $0491,x                 ; 05895:  bd 91 04
            and #$01                    ; 05898:  29 01
            ora $03d8,x                 ; 0589A:  1d d8 03
            bne b1_d8f8                 ; 0589D:  d0 59
            lda #$01                    ; 0589F:  a9 01
            ora $0491,x                 ; 058A1:  1d 91 04
            sta $0491,x                 ; 058A4:  9d 91 04
            cpy #$12                    ; 058A7:  c0 12
            beq b1_d8f9                 ; 058A9:  f0 4e
            cpy #$0d                    ; 058AB:  c0 0d
            beq b1_d92c                 ; 058AD:  f0 7d
            cpy #$0c                    ; 058AF:  c0 0c
            beq b1_d92c                 ; 058B1:  f0 79
            cpy #$33                    ; 058B3:  c0 33
            beq b1_d8f9                 ; 058B5:  f0 42
            cpy #$15                    ; 058B7:  c0 15
            bcs b1_d92c                 ; 058B9:  b0 71
            lda $074e                   ; 058BB:  ad 4e 07
            beq b1_d92c                 ; 058BE:  f0 6c
            lda $1e,x                   ; 058C0:  b5 1e
            asl a                       ; 058C2:  0a
            bcs b1_d8f9                 ; 058C3:  b0 34
            lda $1e,x                   ; 058C5:  b5 1e
            and #$07                    ; 058C7:  29 07
            cmp #$02                    ; 058C9:  c9 02
            bcc b1_d8f9                 ; 058CB:  90 2c
            lda $16,x                   ; 058CD:  b5 16
            cmp #$06                    ; 058CF:  c9 06
            beq b1_d8f8                 ; 058D1:  f0 25
            lda #$08                    ; 058D3:  a9 08
            sta $ff                     ; 058D5:  85 ff
            lda $1e,x                   ; 058D7:  b5 1e
            ora #$80                    ; 058D9:  09 80
            sta $1e,x                   ; 058DB:  95 1e
            jsr b1_da05                 ; 058DD:  20 05 da
            lda b1_d84f,y               ; 058E0:  b9 4f d8
            sta $58,x                   ; 058E3:  95 58
            lda #$03                    ; 058E5:  a9 03
            clc                         ; 058E7:  18
            adc $0484                   ; 058E8:  6d 84 04
            ldy $0796,x                 ; 058EB:  bc 96 07
            cpy #$03                    ; 058EE:  c0 03
            bcs b1_d8f5                 ; 058F0:  b0 03
            lda b1_d892,y               ; 058F2:  b9 92 d8
b1_d8f5:    jsr b1_da11                 ; 058F5:  20 11 da
b1_d8f8:    rts                         ; 058F8:  60

b1_d8f9:    lda $9f                     ; 058F9:  a5 9f
            bmi b1_d8ff                 ; 058FB:  30 02
            bne tab_b1_d958+17          ; 058FD:  d0 6a
b1_d8ff:    lda $16,x                   ; 058FF:  b5 16
            cmp #$07                    ; 05901:  c9 07
            bcc b1_d90e                 ; 05903:  90 09
            lda $ce                     ; 05905:  a5 ce
            clc                         ; 05907:  18
            adc #$0c                    ; 05908:  69 0c
            cmp $cf,x                   ; 0590A:  d5 cf
            bcc tab_b1_d958+17          ; 0590C:  90 5b
b1_d90e:    lda $0791                   ; 0590E:  ad 91 07
            bne tab_b1_d958+17          ; 05911:  d0 56
            lda $079e                   ; 05913:  ad 9e 07
            bne b1_d955                 ; 05916:  d0 3d
            lda $03ad                   ; 05918:  ad ad 03
            cmp $03ae                   ; 0591B:  cd ae 03
            bcc b1_d923                 ; 0591E:  90 03
            jmp b1_d9f6                 ; 05920:  4c f6 d9

b1_d923:    lda $46,x                   ; 05923:  b5 46
            cmp #$01                    ; 05925:  c9 01
            bne b1_d92c                 ; 05927:  d0 03
            jmp b1_d9ff                 ; 05929:  4c ff d9

b1_d92c:    lda $079e                   ; 0592C:  ad 9e 07
            bne b1_d955                 ; 0592F:  d0 24
            ldx $0756                   ; 05931:  ae 56 07
            beq tab_b1_d958             ; 05934:  f0 22
            sta $0756                   ; 05936:  8d 56 07
            lda #$08                    ; 05939:  a9 08
            sta $079e                   ; 0593B:  8d 9e 07
            asl a                       ; 0593E:  0a
            sta $ff                     ; 0593F:  85 ff
            jsr $85f1                   ; 05941:  20 f1 85
            lda #$0a                    ; 05944:  a9 0a
            ldy #$01                    ; 05946:  a0 01
b1_d948:    sta $0e                     ; 05948:  85 0e
            sty $1d                     ; 0594A:  84 1d
            ldy #$ff                    ; 0594C:  a0 ff
            sty $0747                   ; 0594E:  8c 47 07
            iny                         ; 05951:  c8
            sty $0775                   ; 05952:  8c 75 07
b1_d955:    ldx $08                     ; 05955:  a6 08
            rts                         ; 05957:  60

tab_b1_d958: ; 21 bytes
            hex 86 57 e8 86 fc a9 fc 85 ; 05958:  86 57 e8 86 fc a9 fc 85
            hex 9f a9 0b d0 e1 02 06 05 ; 05960:  9f a9 0b d0 e1 02 06 05
            hex 06 b5 16 c9 12          ; 05968:  06 b5 16 c9 12

            beq b1_d92c                 ; 0596D:  f0 bd
            lda #$04                    ; 0596F:  a9 04
            sta $ff                     ; 05971:  85 ff
            lda $16,x                   ; 05973:  b5 16
            ldy #$00                    ; 05975:  a0 00
            cmp #$14                    ; 05977:  c9 14
            beq b1_d996                 ; 05979:  f0 1b
            cmp #$08                    ; 0597B:  c9 08
            beq b1_d996                 ; 0597D:  f0 17
            cmp #$33                    ; 0597F:  c9 33
            beq b1_d996                 ; 05981:  f0 13
            cmp #$0c                    ; 05983:  c9 0c
            beq b1_d996                 ; 05985:  f0 0f
            iny                         ; 05987:  c8
            cmp #$05                    ; 05988:  c9 05
            beq b1_d996                 ; 0598A:  f0 0a
            iny                         ; 0598C:  c8
            cmp #$11                    ; 0598D:  c9 11
            beq b1_d996                 ; 0598F:  f0 05
            iny                         ; 05991:  c8
            cmp #$07                    ; 05992:  c9 07
            bne b1_d9b3                 ; 05994:  d0 1d
b1_d996:    lda tab_b1_d958+13,y        ; 05996:  b9 65 d9
            jsr b1_da11                 ; 05999:  20 11 da
            lda $46,x                   ; 0599C:  b5 46
            pha                         ; 0599E:  48
            jsr b1_e02f                 ; 0599F:  20 2f e0
            pla                         ; 059A2:  68
            sta $46,x                   ; 059A3:  95 46
            lda #$20                    ; 059A5:  a9 20
            sta $1e,x                   ; 059A7:  95 1e
            jsr b1_c363                 ; 059A9:  20 63 c3
            sta $58,x                   ; 059AC:  95 58
            lda #$fd                    ; 059AE:  a9 fd
            sta $9f                     ; 059B0:  85 9f
            rts                         ; 059B2:  60

b1_d9b3:    cmp #$09                    ; 059B3:  c9 09
            bcc b1_d9d4                 ; 059B5:  90 1d
            and #$01                    ; 059B7:  29 01
            sta $16,x                   ; 059B9:  95 16
            ldy #$00                    ; 059BB:  a0 00
            sty $1e,x                   ; 059BD:  94 1e
            lda #$03                    ; 059BF:  a9 03
            jsr b1_da11                 ; 059C1:  20 11 da
            jsr b1_c363                 ; 059C4:  20 63 c3
            jsr b1_da05                 ; 059C7:  20 05 da
            lda b1_d851,y               ; 059CA:  b9 51 d8
            sta $58,x                   ; 059CD:  95 58
            jmp b1_d9f1                 ; 059CF:  4c f1 d9

b1_d9d2:    bpl b1_d9df                 ; 059D2:  10 0b
b1_d9d4:    lda #$04                    ; 059D4:  a9 04
            sta $1e,x                   ; 059D6:  95 1e
            inc $0484                   ; 059D8:  ee 84 04
            lda $0484                   ; 059DB:  ad 84 04
            clc                         ; 059DE:  18
b1_d9df:    adc $0791                   ; 059DF:  6d 91 07
            jsr b1_da11                 ; 059E2:  20 11 da
            inc $0791                   ; 059E5:  ee 91 07
            ldy $076a                   ; 059E8:  ac 6a 07
            lda b1_d9d2,y               ; 059EB:  b9 d2 d9
            sta $0796,x                 ; 059EE:  9d 96 07
b1_d9f1:    lda #$fc                    ; 059F1:  a9 fc
            sta $9f                     ; 059F3:  85 9f
            rts                         ; 059F5:  60

b1_d9f6:    lda $46,x                   ; 059F6:  b5 46
            cmp #$01                    ; 059F8:  c9 01
            bne b1_d9ff                 ; 059FA:  d0 03
            jmp b1_d92c                 ; 059FC:  4c 2c d9

b1_d9ff:    jsr b1_db1c                 ; 059FF:  20 1c db
            jmp b1_d92c                 ; 05A02:  4c 2c d9

b1_da05:    ldy #$01                    ; 05A05:  a0 01
            jsr b1_e143                 ; 05A07:  20 43 e1
            bpl b1_da0d                 ; 05A0A:  10 01
            iny                         ; 05A0C:  c8
b1_da0d:    sty $46,x                   ; 05A0D:  94 46
            dey                         ; 05A0F:  88
            rts                         ; 05A10:  60

b1_da11:    sta $0110,x                 ; 05A11:  9d 10 01
            lda #$30                    ; 05A14:  a9 30
            sta $012c,x                 ; 05A16:  9d 2c 01
            lda $cf,x                   ; 05A19:  b5 cf
            sta $011e,x                 ; 05A1B:  9d 1e 01
            lda $03ae                   ; 05A1E:  ad ae 03
            sta $0117,x                 ; 05A21:  9d 17 01
b1_da24:    rts                         ; 05A24:  60

tab_b1_da25: ; 13 bytes
            hex 80 40 20 10 08 04 02 7f ; 05A25:  80 40 20 10 08 04 02 7f
            hex bf df ef f7 fb          ; 05A2D:  bf df ef f7 fb

b1_da32:    sbc $09a5,x                 ; 05A32:  fd a5 09
            lsr a                       ; 05A35:  4a
            bcc b1_da24                 ; 05A36:  90 ec
            lda $074e                   ; 05A38:  ad 4e 07
            beq b1_da24                 ; 05A3B:  f0 e7
            lda $16,x                   ; 05A3D:  b5 16
            cmp #$15                    ; 05A3F:  c9 15
            bcs b1_dab1                 ; 05A41:  b0 6e
            cmp #$11                    ; 05A43:  c9 11
            beq b1_dab1                 ; 05A45:  f0 6a
            cmp #$0d                    ; 05A47:  c9 0d
            beq b1_dab1                 ; 05A49:  f0 66
            lda $03d8,x                 ; 05A4B:  bd d8 03
            bne b1_dab1                 ; 05A4E:  d0 61
            jsr b1_dc52                 ; 05A50:  20 52 dc
            dex                         ; 05A53:  ca
            bmi b1_dab1                 ; 05A54:  30 5b
b1_da56:    stx $01                     ; 05A56:  86 01
            tya                         ; 05A58:  98
            pha                         ; 05A59:  48
            lda $0f,x                   ; 05A5A:  b5 0f
            beq b1_daaa                 ; 05A5C:  f0 4c
            lda $16,x                   ; 05A5E:  b5 16
            cmp #$15                    ; 05A60:  c9 15
            bcs b1_daaa                 ; 05A62:  b0 46
            cmp #$11                    ; 05A64:  c9 11
            beq b1_daaa                 ; 05A66:  f0 42
            cmp #$0d                    ; 05A68:  c9 0d
            beq b1_daaa                 ; 05A6A:  f0 3e
            lda $03d8,x                 ; 05A6C:  bd d8 03
            bne b1_daaa                 ; 05A6F:  d0 39
            txa                         ; 05A71:  8a
            asl a                       ; 05A72:  0a
            asl a                       ; 05A73:  0a
            clc                         ; 05A74:  18
            adc #$04                    ; 05A75:  69 04
            tax                         ; 05A77:  aa
            jsr b1_e327                 ; 05A78:  20 27 e3
            ldx $08                     ; 05A7B:  a6 08
            ldy $01                     ; 05A7D:  a4 01
            bcc b1_daa1                 ; 05A7F:  90 20
            lda $1e,x                   ; 05A81:  b5 1e
            hex 19 1e 00 ; ora $001e,y  ; 05A83:  19 1e 00
            and #$80                    ; 05A86:  29 80
            bne b1_da9b                 ; 05A88:  d0 11
            lda $0491,y                 ; 05A8A:  b9 91 04
            and tab_b1_da25,x           ; 05A8D:  3d 25 da
            bne b1_daaa                 ; 05A90:  d0 18
            lda $0491,y                 ; 05A92:  b9 91 04
            ora tab_b1_da25,x           ; 05A95:  1d 25 da
            sta $0491,y                 ; 05A98:  99 91 04
b1_da9b:    jsr b1_dab4                 ; 05A9B:  20 b4 da
            jmp b1_daaa                 ; 05A9E:  4c aa da

b1_daa1:    lda $0491,y                 ; 05AA1:  b9 91 04
            and tab_b1_da25+7,x         ; 05AA4:  3d 2c da
            sta $0491,y                 ; 05AA7:  99 91 04
b1_daaa:    pla                         ; 05AAA:  68
            tay                         ; 05AAB:  a8
            ldx $01                     ; 05AAC:  a6 01
            dex                         ; 05AAE:  ca
            bpl b1_da56                 ; 05AAF:  10 a5
b1_dab1:    ldx $08                     ; 05AB1:  a6 08
            rts                         ; 05AB3:  60

b1_dab4:    hex b9 1e 00 ; lda $001e,y  ; 05AB4:  b9 1e 00
            ora $1e,x                   ; 05AB7:  15 1e
            and #$20                    ; 05AB9:  29 20
            bne b1_daf0                 ; 05ABB:  d0 33
            lda $1e,x                   ; 05ABD:  b5 1e
            cmp #$06                    ; 05ABF:  c9 06
            bcc b1_daf1                 ; 05AC1:  90 2e
            lda $16,x                   ; 05AC3:  b5 16
            cmp #$05                    ; 05AC5:  c9 05
            beq b1_daf0                 ; 05AC7:  f0 27
            hex b9 1e 00 ; lda $001e,y  ; 05AC9:  b9 1e 00
            asl a                       ; 05ACC:  0a
            bcc b1_dad9                 ; 05ACD:  90 0a
            lda #$06                    ; 05ACF:  a9 06
            jsr b1_da11                 ; 05AD1:  20 11 da
            jsr b1_d795                 ; 05AD4:  20 95 d7
            ldy $01                     ; 05AD7:  a4 01
b1_dad9:    tya                         ; 05AD9:  98
            tax                         ; 05ADA:  aa
            jsr b1_d795                 ; 05ADB:  20 95 d7
            ldx $08                     ; 05ADE:  a6 08
            lda $0125,x                 ; 05AE0:  bd 25 01
            clc                         ; 05AE3:  18
            adc #$04                    ; 05AE4:  69 04
            ldx $01                     ; 05AE6:  a6 01
            jsr b1_da11                 ; 05AE8:  20 11 da
            ldx $08                     ; 05AEB:  a6 08
            inc $0125,x                 ; 05AED:  fe 25 01
b1_daf0:    rts                         ; 05AF0:  60

b1_daf1:    hex b9 1e 00 ; lda $001e,y  ; 05AF1:  b9 1e 00
            cmp #$06                    ; 05AF4:  c9 06
            bcc b1_db15                 ; 05AF6:  90 1d
            hex b9 16 00 ; lda $0016,y  ; 05AF8:  b9 16 00
            cmp #$05                    ; 05AFB:  c9 05
            beq b1_daf0                 ; 05AFD:  f0 f1
            jsr b1_d795                 ; 05AFF:  20 95 d7
            ldy $01                     ; 05B02:  a4 01
            lda $0125,y                 ; 05B04:  b9 25 01
            clc                         ; 05B07:  18
            adc #$04                    ; 05B08:  69 04
            ldx $08                     ; 05B0A:  a6 08
            jsr b1_da11                 ; 05B0C:  20 11 da
            ldx $01                     ; 05B0F:  a6 01
            inc $0125,x                 ; 05B11:  fe 25 01
            rts                         ; 05B14:  60

b1_db15:    tya                         ; 05B15:  98
            tax                         ; 05B16:  aa
            jsr b1_db1c                 ; 05B17:  20 1c db
            ldx $08                     ; 05B1A:  a6 08
b1_db1c:    lda $16,x                   ; 05B1C:  b5 16
            cmp #$0d                    ; 05B1E:  c9 0d
            beq b1_db44                 ; 05B20:  f0 22
            cmp #$11                    ; 05B22:  c9 11
            beq b1_db44                 ; 05B24:  f0 1e
            cmp #$05                    ; 05B26:  c9 05
            beq b1_db44                 ; 05B28:  f0 1a
            cmp #$12                    ; 05B2A:  c9 12
            beq b1_db36                 ; 05B2C:  f0 08
            cmp #$0e                    ; 05B2E:  c9 0e
            beq b1_db36                 ; 05B30:  f0 04
            cmp #$07                    ; 05B32:  c9 07
            bcs b1_db44                 ; 05B34:  b0 0e
b1_db36:    lda $58,x                   ; 05B36:  b5 58
            eor #$ff                    ; 05B38:  49 ff
            tay                         ; 05B3A:  a8
            iny                         ; 05B3B:  c8
            sty $58,x                   ; 05B3C:  94 58
            lda $46,x                   ; 05B3E:  b5 46
            eor #$03                    ; 05B40:  49 03
            sta $46,x                   ; 05B42:  95 46
b1_db44:    rts                         ; 05B44:  60

b1_db45:    lda #$ff                    ; 05B45:  a9 ff
            sta $03a2,x                 ; 05B47:  9d a2 03
            lda $0747                   ; 05B4A:  ad 47 07
            bne b1_db78                 ; 05B4D:  d0 29
            lda $1e,x                   ; 05B4F:  b5 1e
            bmi b1_db78                 ; 05B51:  30 25
            lda $16,x                   ; 05B53:  b5 16
            cmp #$24                    ; 05B55:  c9 24
            bne b1_db5f                 ; 05B57:  d0 06
            lda $1e,x                   ; 05B59:  b5 1e
            tax                         ; 05B5B:  aa
            jsr b1_db5f                 ; 05B5C:  20 5f db
b1_db5f:    jsr b1_dc41                 ; 05B5F:  20 41 dc
            bcs b1_db78                 ; 05B62:  b0 14
            txa                         ; 05B64:  8a
            jsr b1_dc54                 ; 05B65:  20 54 dc
            lda $cf,x                   ; 05B68:  b5 cf
            sta $00                     ; 05B6A:  85 00
            txa                         ; 05B6C:  8a
            pha                         ; 05B6D:  48
            jsr b1_e325                 ; 05B6E:  20 25 e3
            pla                         ; 05B71:  68
            tax                         ; 05B72:  aa
            bcc b1_db78                 ; 05B73:  90 03
            jsr b1_dbbc                 ; 05B75:  20 bc db
b1_db78:    ldx $08                     ; 05B78:  a6 08
            rts                         ; 05B7A:  60

b1_db7b:    lda $0747                   ; 05B7B:  ad 47 07
            bne b1_dbb7                 ; 05B7E:  d0 37
            sta $03a2,x                 ; 05B80:  9d a2 03
            jsr b1_dc41                 ; 05B83:  20 41 dc
            bcs b1_dbb7                 ; 05B86:  b0 2f
            lda #$02                    ; 05B88:  a9 02
            sta $00                     ; 05B8A:  85 00
b1_db8c:    ldx $08                     ; 05B8C:  a6 08
            jsr b1_dc52                 ; 05B8E:  20 52 dc
            and #$02                    ; 05B91:  29 02
            bne b1_dbb7                 ; 05B93:  d0 22
            lda $04ad,y                 ; 05B95:  b9 ad 04
            cmp #$20                    ; 05B98:  c9 20
            bcc b1_dba1                 ; 05B9A:  90 05
            jsr b1_e325                 ; 05B9C:  20 25 e3
            bcs b1_dbba                 ; 05B9F:  b0 19
b1_dba1:    lda $04ad,y                 ; 05BA1:  b9 ad 04
            clc                         ; 05BA4:  18
            adc #$80                    ; 05BA5:  69 80
            sta $04ad,y                 ; 05BA7:  99 ad 04
            lda $04af,y                 ; 05BAA:  b9 af 04
            clc                         ; 05BAD:  18
            adc #$80                    ; 05BAE:  69 80
            sta $04af,y                 ; 05BB0:  99 af 04
            dec $00                     ; 05BB3:  c6 00
            bne b1_db8c                 ; 05BB5:  d0 d5
b1_dbb7:    ldx $08                     ; 05BB7:  a6 08
            rts                         ; 05BB9:  60

b1_dbba:    ldx $08                     ; 05BBA:  a6 08
b1_dbbc:    lda $04af,y                 ; 05BBC:  b9 af 04
            sec                         ; 05BBF:  38
            sbc $04ad                   ; 05BC0:  ed ad 04
            cmp #$04                    ; 05BC3:  c9 04
            bcs b1_dbcf                 ; 05BC5:  b0 08
            lda $9f                     ; 05BC7:  a5 9f
            bpl b1_dbcf                 ; 05BC9:  10 04
            lda #$01                    ; 05BCB:  a9 01
            sta $9f                     ; 05BCD:  85 9f
b1_dbcf:    lda $04af                   ; 05BCF:  ad af 04
            sec                         ; 05BD2:  38
            sbc $04ad,y                 ; 05BD3:  f9 ad 04
            cmp #$06                    ; 05BD6:  c9 06
            bcs b1_dbf5                 ; 05BD8:  b0 1b
            lda $9f                     ; 05BDA:  a5 9f
            bmi b1_dbf5                 ; 05BDC:  30 17
            lda $00                     ; 05BDE:  a5 00
            ldy $16,x                   ; 05BE0:  b4 16
            cpy #$2b                    ; 05BE2:  c0 2b
            beq b1_dbeb                 ; 05BE4:  f0 05
            cpy #$2c                    ; 05BE6:  c0 2c
            beq b1_dbeb                 ; 05BE8:  f0 01
            txa                         ; 05BEA:  8a
b1_dbeb:    ldx $08                     ; 05BEB:  a6 08
            sta $03a2,x                 ; 05BED:  9d a2 03
            lda #$00                    ; 05BF0:  a9 00
            sta $1d                     ; 05BF2:  85 1d
            rts                         ; 05BF4:  60

b1_dbf5:    lda #$01                    ; 05BF5:  a9 01
            sta $00                     ; 05BF7:  85 00
            lda $04ae                   ; 05BF9:  ad ae 04
            sec                         ; 05BFC:  38
            sbc $04ac,y                 ; 05BFD:  f9 ac 04
            cmp #$08                    ; 05C00:  c9 08
            bcc b1_dc11                 ; 05C02:  90 0d
            inc $00                     ; 05C04:  e6 00
            lda $04ae,y                 ; 05C06:  b9 ae 04
            clc                         ; 05C09:  18
            sbc $04ac                   ; 05C0A:  ed ac 04
            cmp #$09                    ; 05C0D:  c9 09
            bcs b1_dc14                 ; 05C0F:  b0 03
b1_dc11:    jsr b1_df4b                 ; 05C11:  20 4b df
b1_dc14:    ldx $08                     ; 05C14:  a6 08
b1_dc16:    rts                         ; 05C16:  60

            hex 80                      ; 05C17:  80

b1_dc18:    brk                         ; 05C18:  00
            hex a8                      ; 05C19:  a8
            lda $cf,x                   ; 05C1A:  b5 cf
            clc                         ; 05C1C:  18
            adc b1_dc16,y               ; 05C1D:  79 16 dc
b1_dc20:    bit b1_cfb5                 ; 05C20:  2c b5 cf
            ldy $0e                     ; 05C23:  a4 0e
            cpy #$0b                    ; 05C25:  c0 0b
            beq b1_dc40                 ; 05C27:  f0 17
            ldy $b6,x                   ; 05C29:  b4 b6
            cpy #$01                    ; 05C2B:  c0 01
            bne b1_dc40                 ; 05C2D:  d0 11
            sec                         ; 05C2F:  38
            sbc #$20                    ; 05C30:  e9 20
            sta $ce                     ; 05C32:  85 ce
            tya                         ; 05C34:  98
            sbc #$00                    ; 05C35:  e9 00
            sta $b5                     ; 05C37:  85 b5
            lda #$00                    ; 05C39:  a9 00
            sta $9f                     ; 05C3B:  85 9f
            sta $0433                   ; 05C3D:  8d 33 04
b1_dc40:    rts                         ; 05C40:  60

b1_dc41:    lda $03d0                   ; 05C41:  ad d0 03
            cmp #$f0                    ; 05C44:  c9 f0
            bcs b1_dc51                 ; 05C46:  b0 09
            ldy $b5                     ; 05C48:  a4 b5
            dey                         ; 05C4A:  88
            bne b1_dc51                 ; 05C4B:  d0 04
            lda $ce                     ; 05C4D:  a5 ce
            cmp #$d0                    ; 05C4F:  c9 d0
b1_dc51:    rts                         ; 05C51:  60

b1_dc52:    lda $08                     ; 05C52:  a5 08
b1_dc54:    asl a                       ; 05C54:  0a
            asl a                       ; 05C55:  0a
            clc                         ; 05C56:  18
            adc #$04                    ; 05C57:  69 04
            tay                         ; 05C59:  a8
            lda $03d1                   ; 05C5A:  ad d1 03
            and #$0f                    ; 05C5D:  29 0f
            cmp #$0f                    ; 05C5F:  c9 0f
            rts                         ; 05C61:  60

b1_dc62:    jsr $ad10                   ; 05C62:  20 10 ad
            asl $07,x                   ; 05C65:  16 07
            bne b1_dc97                 ; 05C67:  d0 2e
            lda $0e                     ; 05C69:  a5 0e
            cmp #$0b                    ; 05C6B:  c9 0b
            beq b1_dc97                 ; 05C6D:  f0 28
            cmp #$04                    ; 05C6F:  c9 04
            bcc b1_dc97                 ; 05C71:  90 24
            lda #$01                    ; 05C73:  a9 01
            ldy $0704                   ; 05C75:  ac 04 07
            bne b1_dc84                 ; 05C78:  d0 0a
            lda $1d                     ; 05C7A:  a5 1d
            beq b1_dc82                 ; 05C7C:  f0 04
            cmp #$03                    ; 05C7E:  c9 03
            bne b1_dc86                 ; 05C80:  d0 04
b1_dc82:    lda #$02                    ; 05C82:  a9 02
b1_dc84:    sta $1d                     ; 05C84:  85 1d
b1_dc86:    lda $b5                     ; 05C86:  a5 b5
            cmp #$01                    ; 05C88:  c9 01
            bne b1_dc97                 ; 05C8A:  d0 0b
            lda #$ff                    ; 05C8C:  a9 ff
            sta $0490                   ; 05C8E:  8d 90 04
            lda $ce                     ; 05C91:  a5 ce
            cmp #$cf                    ; 05C93:  c9 cf
            bcc b1_dc98                 ; 05C95:  90 01
b1_dc97:    rts                         ; 05C97:  60

b1_dc98:    ldy #$02                    ; 05C98:  a0 02
            lda $0714                   ; 05C9A:  ad 14 07
            bne b1_dcab                 ; 05C9D:  d0 0c
            lda $0754                   ; 05C9F:  ad 54 07
            bne b1_dcab                 ; 05CA2:  d0 07
            dey                         ; 05CA4:  88
            lda $0704                   ; 05CA5:  ad 04 07
            bne b1_dcab                 ; 05CA8:  d0 01
            dey                         ; 05CAA:  88
b1_dcab:    lda tab_b1_e3ad,y           ; 05CAB:  b9 ad e3
            sta $eb                     ; 05CAE:  85 eb
            tay                         ; 05CB0:  a8
            ldx $0754                   ; 05CB1:  ae 54 07
            lda $0714                   ; 05CB4:  ad 14 07
            beq b1_dcba                 ; 05CB7:  f0 01
            inx                         ; 05CB9:  e8
b1_dcba:    lda $ce                     ; 05CBA:  a5 ce
            cmp b1_dc62,x               ; 05CBC:  dd 62 dc
            bcc b1_dcf6                 ; 05CBF:  90 35
            jsr b1_e3e9                 ; 05CC1:  20 e9 e3
            beq b1_dcf6                 ; 05CC4:  f0 30
            jsr b1_dfa1                 ; 05CC6:  20 a1 df
            bcs b1_dd1a                 ; 05CC9:  b0 4f
            ldy $9f                     ; 05CCB:  a4 9f
            bpl b1_dcf6                 ; 05CCD:  10 27
            ldy $04                     ; 05CCF:  a4 04
            cpy #$04                    ; 05CD1:  c0 04
            bcc b1_dcf6                 ; 05CD3:  90 21
            jsr b1_df8e+1               ; 05CD5:  20 8f df
            bcs b1_dcea                 ; 05CD8:  b0 10
            ldy $074e                   ; 05CDA:  ac 4e 07
            beq b1_dcf2                 ; 05CDD:  f0 13
            ldy $0784                   ; 05CDF:  ac 84 07
            bne b1_dcf2                 ; 05CE2:  d0 0e
            jsr $bced                   ; 05CE4:  20 ed bc
            jmp b1_dcf6                 ; 05CE7:  4c f6 dc

b1_dcea:    cmp #$26                    ; 05CEA:  c9 26
            beq b1_dcf2                 ; 05CEC:  f0 04
            lda #$02                    ; 05CEE:  a9 02
            sta $ff                     ; 05CF0:  85 ff
b1_dcf2:    lda #$01                    ; 05CF2:  a9 01
            sta $9f                     ; 05CF4:  85 9f
b1_dcf6:    ldy $eb                     ; 05CF6:  a4 eb
            lda $ce                     ; 05CF8:  a5 ce
            cmp #$cf                    ; 05CFA:  c9 cf
            bcs b1_dd5e                 ; 05CFC:  b0 60
            jsr b1_e3e7+1               ; 05CFE:  20 e8 e3
            jsr b1_dfa1                 ; 05D01:  20 a1 df
            bcs b1_dd1a                 ; 05D04:  b0 14
            pha                         ; 05D06:  48
            jsr b1_e3e7+1               ; 05D07:  20 e8 e3
            sta $00                     ; 05D0A:  85 00
            pla                         ; 05D0C:  68
            sta $01                     ; 05D0D:  85 01
            bne b1_dd1d                 ; 05D0F:  d0 0c
            lda $00                     ; 05D11:  a5 00
            beq b1_dd5e                 ; 05D13:  f0 49
            jsr b1_dfa1                 ; 05D15:  20 a1 df
            bcc b1_dd1d                 ; 05D18:  90 03
b1_dd1a:    jmp b1_de05                 ; 05D1A:  4c 05 de

b1_dd1d:    jsr b1_df99+1               ; 05D1D:  20 9a df
            bcs b1_dd5e                 ; 05D20:  b0 3c
            ldy $9f                     ; 05D22:  a4 9f
            bmi b1_dd5e                 ; 05D24:  30 38
            cmp #$c5                    ; 05D26:  c9 c5
            bne b1_dd2d                 ; 05D28:  d0 03
            jmp b1_de0e                 ; 05D2A:  4c 0e de

b1_dd2d:    jsr b1_debd                 ; 05D2D:  20 bd de
            beq b1_dd5e                 ; 05D30:  f0 2c
            ldy $070e                   ; 05D32:  ac 0e 07
            bne b1_dd5a                 ; 05D35:  d0 23
            ldy $04                     ; 05D37:  a4 04
            cpy #$05                    ; 05D39:  c0 05
            bcc b1_dd44                 ; 05D3B:  90 07
            lda $45                     ; 05D3D:  a5 45
            sta $00                     ; 05D3F:  85 00
            jmp b1_df4b                 ; 05D41:  4c 4b df

b1_dd44:    jsr b1_dec4                 ; 05D44:  20 c4 de
            lda #$f0                    ; 05D47:  a9 f0
            and $ce                     ; 05D49:  25 ce
            sta $ce                     ; 05D4B:  85 ce
            jsr b1_dee8                 ; 05D4D:  20 e8 de
            lda #$00                    ; 05D50:  a9 00
            sta $9f                     ; 05D52:  85 9f
            sta $0433                   ; 05D54:  8d 33 04
            sta $0484                   ; 05D57:  8d 84 04
b1_dd5a:    lda #$00                    ; 05D5A:  a9 00
            sta $1d                     ; 05D5C:  85 1d
b1_dd5e:    ldy $eb                     ; 05D5E:  a4 eb
            iny                         ; 05D60:  c8
            iny                         ; 05D61:  c8
            lda #$02                    ; 05D62:  a9 02
            sta $00                     ; 05D64:  85 00
b1_dd66:    iny                         ; 05D66:  c8
            sty $eb                     ; 05D67:  84 eb
            lda $ce                     ; 05D69:  a5 ce
            cmp #$20                    ; 05D6B:  c9 20
            bcc b1_dd85                 ; 05D6D:  90 16
            cmp #$e4                    ; 05D6F:  c9 e4
            bcs b1_dd9b                 ; 05D71:  b0 28
            jsr b1_e3eb+1               ; 05D73:  20 ec e3
            beq b1_dd85                 ; 05D76:  f0 0d
            cmp #$1c                    ; 05D78:  c9 1c
            beq b1_dd85                 ; 05D7A:  f0 09
            cmp #$6b                    ; 05D7C:  c9 6b
            beq b1_dd85                 ; 05D7E:  f0 05
            jsr b1_df99+1               ; 05D80:  20 9a df
            bcc b1_dd9c                 ; 05D83:  90 17
b1_dd85:    ldy $eb                     ; 05D85:  a4 eb
            iny                         ; 05D87:  c8
            lda $ce                     ; 05D88:  a5 ce
            cmp #$08                    ; 05D8A:  c9 08
            bcc b1_dd9b                 ; 05D8C:  90 0d
            cmp #$d0                    ; 05D8E:  c9 d0
            bcs b1_dd9b                 ; 05D90:  b0 09
            jsr b1_e3eb+1               ; 05D92:  20 ec e3
            bne b1_dd9c                 ; 05D95:  d0 05
            dec $00                     ; 05D97:  c6 00
            bne b1_dd66                 ; 05D99:  d0 cb
b1_dd9b:    rts                         ; 05D9B:  60

b1_dd9c:    jsr b1_debd                 ; 05D9C:  20 bd de
            beq b1_de02                 ; 05D9F:  f0 61
            jsr b1_df99+1               ; 05DA1:  20 9a df
            bcc b1_dda9                 ; 05DA4:  90 03
            jmp tab_b1_de25+9           ; 05DA6:  4c 2e de

b1_dda9:    jsr b1_dfa1                 ; 05DA9:  20 a1 df
            bcs b1_de05                 ; 05DAC:  b0 57
            jsr b1_dedd                 ; 05DAE:  20 dd de
            bcc b1_ddbb                 ; 05DB1:  90 08
            lda $070e                   ; 05DB3:  ad 0e 07
            bne b1_de02                 ; 05DB6:  d0 4a
            jmp b1_ddff                 ; 05DB8:  4c ff dd

b1_ddbb:    ldy $1d                     ; 05DBB:  a4 1d
            cpy #$00                    ; 05DBD:  c0 00
            bne b1_ddff                 ; 05DBF:  d0 3e
            ldy $33                     ; 05DC1:  a4 33
            dey                         ; 05DC3:  88
            bne b1_ddff                 ; 05DC4:  d0 39
            cmp #$6c                    ; 05DC6:  c9 6c
            beq b1_ddce                 ; 05DC8:  f0 04
            cmp #$1f                    ; 05DCA:  c9 1f
            bne b1_ddff                 ; 05DCC:  d0 31
b1_ddce:    lda $03c4                   ; 05DCE:  ad c4 03
            bne b1_ddd7                 ; 05DD1:  d0 04
            ldy #$10                    ; 05DD3:  a0 10
            sty $ff                     ; 05DD5:  84 ff
b1_ddd7:    ora #$20                    ; 05DD7:  09 20
            sta $03c4                   ; 05DD9:  8d c4 03
            lda $86                     ; 05DDC:  a5 86
            and #$0f                    ; 05DDE:  29 0f
            beq b1_ddf0                 ; 05DE0:  f0 0e
            ldy #$00                    ; 05DE2:  a0 00
            lda $071a                   ; 05DE4:  ad 1a 07
            beq b1_ddea                 ; 05DE7:  f0 01
            iny                         ; 05DE9:  c8
b1_ddea:    lda b1_de03,y               ; 05DEA:  b9 03 de
            sta $06de                   ; 05DED:  8d de 06
b1_ddf0:    lda $0e                     ; 05DF0:  a5 0e
            cmp #$07                    ; 05DF2:  c9 07
            beq b1_de02                 ; 05DF4:  f0 0c
            cmp #$08                    ; 05DF6:  c9 08
            bne b1_de02                 ; 05DF8:  d0 08
            lda #$02                    ; 05DFA:  a9 02
            sta $0e                     ; 05DFC:  85 0e
            rts                         ; 05DFE:  60

b1_ddff:    jsr b1_df4b                 ; 05DFF:  20 4b df
b1_de02:    rts                         ; 05E02:  60

b1_de03:    ldy #$34                    ; 05E03:  a0 34
b1_de05:    jsr b1_de1c                 ; 05E05:  20 1c de
            inc $0748                   ; 05E08:  ee 48 07
            jmp $bbfe                   ; 05E0B:  4c fe bb

b1_de0e:    lda #$00                    ; 05E0E:  a9 00
            sta $0772                   ; 05E10:  8d 72 07
            lda #$02                    ; 05E13:  a9 02
            sta $0770                   ; 05E15:  8d 70 07
            lda #$18                    ; 05E18:  a9 18
            sta $57                     ; 05E1A:  85 57
b1_de1c:    ldy $02                     ; 05E1C:  a4 02
            lda #$00                    ; 05E1E:  a9 00
            sta ($06),y                 ; 05E20:  91 06
b1_de22:    jmp $8a4d                   ; 05E22:  4c 4d 8a

tab_b1_de25: ; 11 bytes
            hex f9 07 ff 00 18 22 50 68 ; 05E25:  f9 07 ff 00 18 22 50 68
            hex 90 a4 04                ; 05E2D:  90 a4 04

            cpy #$06                    ; 05E30:  c0 06
            bcc b1_de38                 ; 05E32:  90 04
            cpy #$0a                    ; 05E34:  c0 0a
            bcc b1_de39                 ; 05E36:  90 01
b1_de38:    rts                         ; 05E38:  60

b1_de39:    cmp #$24                    ; 05E39:  c9 24
            beq b1_de41                 ; 05E3B:  f0 04
            cmp #$25                    ; 05E3D:  c9 25
            bne b1_de7a                 ; 05E3F:  d0 39
b1_de41:    lda $0e                     ; 05E41:  a5 0e
            cmp #$05                    ; 05E43:  c9 05
            beq b1_de88                 ; 05E45:  f0 41
            lda #$01                    ; 05E47:  a9 01
            sta $33                     ; 05E49:  85 33
            inc $0723                   ; 05E4B:  ee 23 07
            lda $0e                     ; 05E4E:  a5 0e
            cmp #$04                    ; 05E50:  c9 04
            beq b1_de73                 ; 05E52:  f0 1f
            lda #$33                    ; 05E54:  a9 33
            jsr $9716                   ; 05E56:  20 16 97
            lda #$80                    ; 05E59:  a9 80
            sta $fc                     ; 05E5B:  85 fc
            lsr a                       ; 05E5D:  4a
            sta $0713                   ; 05E5E:  8d 13 07
            ldx #$04                    ; 05E61:  a2 04
            lda $ce                     ; 05E63:  a5 ce
            sta $070f                   ; 05E65:  8d 0f 07
b1_de68:    cmp tab_b1_de25+4,x         ; 05E68:  dd 29 de
            bcs b1_de70                 ; 05E6B:  b0 03
            dex                         ; 05E6D:  ca
            bne b1_de68                 ; 05E6E:  d0 f8
b1_de70:    stx $010f                   ; 05E70:  8e 0f 01
b1_de73:    lda #$04                    ; 05E73:  a9 04
            sta $0e                     ; 05E75:  85 0e
            jmp b1_de88                 ; 05E77:  4c 88 de

b1_de7a:    cmp #$26                    ; 05E7A:  c9 26
            bne b1_de88                 ; 05E7C:  d0 0a
            lda $ce                     ; 05E7E:  a5 ce
            cmp #$20                    ; 05E80:  c9 20
            bcs b1_de88                 ; 05E82:  b0 04
            lda #$01                    ; 05E84:  a9 01
            sta $0e                     ; 05E86:  85 0e
b1_de88:    lda #$03                    ; 05E88:  a9 03
            sta $1d                     ; 05E8A:  85 1d
            lda #$00                    ; 05E8C:  a9 00
            sta $57                     ; 05E8E:  85 57
            sta $0705                   ; 05E90:  8d 05 07
            lda $86                     ; 05E93:  a5 86
            sec                         ; 05E95:  38
            sbc $071c                   ; 05E96:  ed 1c 07
            cmp #$10                    ; 05E99:  c9 10
            bcs b1_dea1                 ; 05E9B:  b0 04
            lda #$02                    ; 05E9D:  a9 02
            sta $33                     ; 05E9F:  85 33
b1_dea1:    ldy $33                     ; 05EA1:  a4 33
            lda $06                     ; 05EA3:  a5 06
            asl a                       ; 05EA5:  0a
            asl a                       ; 05EA6:  0a
            asl a                       ; 05EA7:  0a
            asl a                       ; 05EA8:  0a
            clc                         ; 05EA9:  18
            adc b1_de22+2,y             ; 05EAA:  79 24 de
            sta $86                     ; 05EAD:  85 86
            lda $06                     ; 05EAF:  a5 06
            bne b1_debc                 ; 05EB1:  d0 09
            lda $071b                   ; 05EB3:  ad 1b 07
            clc                         ; 05EB6:  18
            adc tab_b1_de25+1,y         ; 05EB7:  79 26 de
            sta $6d                     ; 05EBA:  85 6d
b1_debc:    rts                         ; 05EBC:  60

b1_debd:    cmp #$5f                    ; 05EBD:  c9 5f
            beq b1_dec3                 ; 05EBF:  f0 02
            cmp #$60                    ; 05EC1:  c9 60
b1_dec3:    rts                         ; 05EC3:  60

b1_dec4:    jsr b1_dedd                 ; 05EC4:  20 dd de
            bcc b1_dedc                 ; 05EC7:  90 13
            lda #$70                    ; 05EC9:  a9 70
            sta $0709                   ; 05ECB:  8d 09 07
            lda #$f9                    ; 05ECE:  a9 f9
            sta $06db                   ; 05ED0:  8d db 06
            lda #$03                    ; 05ED3:  a9 03
            sta $0786                   ; 05ED5:  8d 86 07
            lsr a                       ; 05ED8:  4a
            sta $070e                   ; 05ED9:  8d 0e 07
b1_dedc:    rts                         ; 05EDC:  60

b1_dedd:    cmp #$67                    ; 05EDD:  c9 67
            beq b1_dee6                 ; 05EDF:  f0 05
            cmp #$68                    ; 05EE1:  c9 68
            clc                         ; 05EE3:  18
            bne b1_dee7                 ; 05EE4:  d0 01
b1_dee6:    sec                         ; 05EE6:  38
b1_dee7:    rts                         ; 05EE7:  60

b1_dee8:    lda $0b                     ; 05EE8:  a5 0b
            and #$04                    ; 05EEA:  29 04
            beq b1_df4a                 ; 05EEC:  f0 5c
            lda $00                     ; 05EEE:  a5 00
            cmp #$11                    ; 05EF0:  c9 11
            bne b1_df4a                 ; 05EF2:  d0 56
            lda $01                     ; 05EF4:  a5 01
            cmp #$10                    ; 05EF6:  c9 10
            bne b1_df4a                 ; 05EF8:  d0 50
            lda #$30                    ; 05EFA:  a9 30
            sta $06de                   ; 05EFC:  8d de 06
            lda #$03                    ; 05EFF:  a9 03
            sta $0e                     ; 05F01:  85 0e
            lda #$10                    ; 05F03:  a9 10
            sta $ff                     ; 05F05:  85 ff
            lda #$20                    ; 05F07:  a9 20
            sta $03c4                   ; 05F09:  8d c4 03
            lda $06d6                   ; 05F0C:  ad d6 06
            beq b1_df4a                 ; 05F0F:  f0 39
            and #$03                    ; 05F11:  29 03
            asl a                       ; 05F13:  0a
            asl a                       ; 05F14:  0a
            tax                         ; 05F15:  aa
            lda $86                     ; 05F16:  a5 86
            cmp #$60                    ; 05F18:  c9 60
            bcc b1_df22                 ; 05F1A:  90 06
            inx                         ; 05F1C:  e8
            cmp #$a0                    ; 05F1D:  c9 a0
            bcc b1_df22                 ; 05F1F:  90 01
            inx                         ; 05F21:  e8
b1_df22:    ldy $87f2,x                 ; 05F22:  bc f2 87
            dey                         ; 05F25:  88
            sty $075f                   ; 05F26:  8c 5f 07
            ldx $9cb4,y                 ; 05F29:  be b4 9c
            lda $9cbc,x                 ; 05F2C:  bd bc 9c
            sta $0750                   ; 05F2F:  8d 50 07
            lda #$80                    ; 05F32:  a9 80
            sta $fc                     ; 05F34:  85 fc
            lda #$00                    ; 05F36:  a9 00
            sta $0751                   ; 05F38:  8d 51 07
            sta $0760                   ; 05F3B:  8d 60 07
            sta $075c                   ; 05F3E:  8d 5c 07
            sta $0752                   ; 05F41:  8d 52 07
            inc $075d                   ; 05F44:  ee 5d 07
            inc $0757                   ; 05F47:  ee 57 07
b1_df4a:    rts                         ; 05F4A:  60

b1_df4b:    lda #$00                    ; 05F4B:  a9 00
            ldy $57                     ; 05F4D:  a4 57
            ldx $00                     ; 05F4F:  a6 00
            dex                         ; 05F51:  ca
            bne b1_df5e                 ; 05F52:  d0 0a
            inx                         ; 05F54:  e8
            cpy #$00                    ; 05F55:  c0 00
            bmi b1_df81                 ; 05F57:  30 28
            lda #$ff                    ; 05F59:  a9 ff
            jmp b1_df66                 ; 05F5B:  4c 66 df

b1_df5e:    ldx #$02                    ; 05F5E:  a2 02
            cpy #$01                    ; 05F60:  c0 01
            bpl b1_df81                 ; 05F62:  10 1d
            lda #$01                    ; 05F64:  a9 01
b1_df66:    ldy #$10                    ; 05F66:  a0 10
            sty $0785                   ; 05F68:  8c 85 07
            ldy #$00                    ; 05F6B:  a0 00
            sty $57                     ; 05F6D:  84 57
            cmp #$00                    ; 05F6F:  c9 00
b1_df71:    bpl b1_df74                 ; 05F71:  10 01
            dey                         ; 05F73:  88
b1_df74:    sty $00                     ; 05F74:  84 00
            clc                         ; 05F76:  18
b1_df77:    adc $86                     ; 05F77:  65 86
            sta $86                     ; 05F79:  85 86
b1_df7b:    lda $6d                     ; 05F7B:  a5 6d
            adc $00                     ; 05F7D:  65 00
            sta $6d                     ; 05F7F:  85 6d
b1_df81:    txa                         ; 05F81:  8a
            eor #$ff                    ; 05F82:  49 ff
            and $0490                   ; 05F84:  2d 90 04
            sta $0490                   ; 05F87:  8d 90 04
            rts                         ; 05F8A:  60

b1_df8b:    bpl b1_dfee                 ; 05F8B:  10 61
            dey                         ; 05F8D:  88
b1_df8e:    cpy $20                     ; 05F8E:  c4 20
            bcs b1_df71                 ; 05F90:  b0 df
            cmp b1_df8b,x               ; 05F92:  dd 8b df
            rts                         ; 05F95:  60

b1_df96:    bit $6d                     ; 05F96:  24 6d
            txa                         ; 05F98:  8a
b1_df99:    dec $20                     ; 05F99:  c6 20
            bcs b1_df7b+1               ; 05F9B:  b0 df
            cmp b1_df96,x               ; 05F9D:  dd 96 df
            rts                         ; 05FA0:  60

b1_dfa1:    cmp #$c2                    ; 05FA1:  c9 c2
            beq b1_dfab                 ; 05FA3:  f0 06
            cmp #$c3                    ; 05FA5:  c9 c3
            beq b1_dfab                 ; 05FA7:  f0 02
            clc                         ; 05FA9:  18
            rts                         ; 05FAA:  60

b1_dfab:    lda #$01                    ; 05FAB:  a9 01
            sta $fe                     ; 05FAD:  85 fe
            rts                         ; 05FAF:  60

            tay                         ; 05FB0:  a8
            and #$c0                    ; 05FB1:  29 c0
            asl a                       ; 05FB3:  0a
            rol a                       ; 05FB4:  2a
            rol a                       ; 05FB5:  2a
            tax                         ; 05FB6:  aa
            tya                         ; 05FB7:  98
b1_dfb8:    rts                         ; 05FB8:  60

tab_b1_dfb9: ; 5 bytes
            hex 01 01 02 02 02          ; 05FB9:  01 01 02 02 02

b1_dfbe:    ora $10                     ; 05FBE:  05 10
b1_dfc0:    beq b1_df77                 ; 05FC0:  f0 b5
            asl $2029,x                 ; 05FC2:  1e 29 20
            bne b1_dfb8                 ; 05FC5:  d0 f1
            jsr b1_e15b                 ; 05FC7:  20 5b e1
            bcc b1_dfb8                 ; 05FCA:  90 ec
            ldy $16,x                   ; 05FCC:  b4 16
            cpy #$12                    ; 05FCE:  c0 12
            bne b1_dfd8                 ; 05FD0:  d0 06
            lda $cf,x                   ; 05FD2:  b5 cf
            cmp #$25                    ; 05FD4:  c9 25
            bcc b1_dfb8                 ; 05FD6:  90 e0
b1_dfd8:    cpy #$0e                    ; 05FD8:  c0 0e
            bne b1_dfdf                 ; 05FDA:  d0 03
            jmp b1_e163                 ; 05FDC:  4c 63 e1

b1_dfdf:    cpy #$05                    ; 05FDF:  c0 05
            bne b1_dfe6                 ; 05FE1:  d0 03
            jmp b1_e185                 ; 05FE3:  4c 85 e1

b1_dfe6:    cpy #$12                    ; 05FE6:  c0 12
            beq b1_dff2                 ; 05FE8:  f0 08
            cpy #$2e                    ; 05FEA:  c0 2e
            beq b1_dff2                 ; 05FEC:  f0 04
b1_dfee:    cpy #$07                    ; 05FEE:  c0 07
            bcs b1_e066                 ; 05FF0:  b0 74
b1_dff2:    jsr b1_e1ae                 ; 05FF2:  20 ae e1
            bne b1_dffa                 ; 05FF5:  d0 03
b1_dff7:    jmp b1_e0e2                 ; 05FF7:  4c e2 e0

b1_dffa:    jsr b1_e1b5                 ; 05FFA:  20 b5 e1
            beq b1_dff7                 ; 05FFD:  f0 f8
            cmp #$23                    ; 05FFF:  c9 23
            bne b1_e067                 ; 06001:  d0 64
            ldy $02                     ; 06003:  a4 02
            lda #$00                    ; 06005:  a9 00
            sta ($06),y                 ; 06007:  91 06
            lda $16,x                   ; 06009:  b5 16
            cmp #$15                    ; 0600B:  c9 15
            bcs b1_e01b                 ; 0600D:  b0 0c
            cmp #$06                    ; 0600F:  c9 06
            bne b1_e016                 ; 06011:  d0 03
            jsr b1_e18e                 ; 06013:  20 8e e1
b1_e016:    lda #$01                    ; 06016:  a9 01
            jsr b1_da11                 ; 06018:  20 11 da
b1_e01b:    cmp #$09                    ; 0601B:  c9 09
            bcc b1_e02f                 ; 0601D:  90 10
            cmp #$11                    ; 0601F:  c9 11
            bcs b1_e02f                 ; 06021:  b0 0c
            cmp #$0a                    ; 06023:  c9 0a
            bcc b1_e02b                 ; 06025:  90 04
            cmp #$0d                    ; 06027:  c9 0d
            bcc b1_e02f                 ; 06029:  90 04
b1_e02b:    and #$01                    ; 0602B:  29 01
            sta $16,x                   ; 0602D:  95 16
b1_e02f:    lda $1e,x                   ; 0602F:  b5 1e
            and #$f0                    ; 06031:  29 f0
            ora #$02                    ; 06033:  09 02
            sta $1e,x                   ; 06035:  95 1e
            dec $cf,x                   ; 06037:  d6 cf
            dec $cf,x                   ; 06039:  d6 cf
            lda $16,x                   ; 0603B:  b5 16
            cmp #$07                    ; 0603D:  c9 07
            beq b1_e048                 ; 0603F:  f0 07
            lda #$fd                    ; 06041:  a9 fd
            ldy $074e                   ; 06043:  ac 4e 07
            bne b1_e04a                 ; 06046:  d0 02
b1_e048:    lda #$ff                    ; 06048:  a9 ff
b1_e04a:    sta $a0,x                   ; 0604A:  95 a0
            ldy #$01                    ; 0604C:  a0 01
            jsr b1_e143                 ; 0604E:  20 43 e1
            bpl b1_e054                 ; 06051:  10 01
            iny                         ; 06053:  c8
b1_e054:    lda $16,x                   ; 06054:  b5 16
            cmp #$33                    ; 06056:  c9 33
            beq b1_e060                 ; 06058:  f0 06
            cmp #$08                    ; 0605A:  c9 08
            beq b1_e060                 ; 0605C:  f0 02
            sty $46,x                   ; 0605E:  94 46
b1_e060:    dey                         ; 06060:  88
            lda b1_dfbe+1,y             ; 06061:  b9 bf df
            sta $58,x                   ; 06064:  95 58
b1_e066:    rts                         ; 06066:  60

b1_e067:    lda $04                     ; 06067:  a5 04
            sec                         ; 06069:  38
            sbc #$08                    ; 0606A:  e9 08
            cmp #$05                    ; 0606C:  c9 05
            bcs b1_e0e2                 ; 0606E:  b0 72
            lda $1e,x                   ; 06070:  b5 1e
            and #$40                    ; 06072:  29 40
            bne b1_e0cd                 ; 06074:  d0 57
            lda $1e,x                   ; 06076:  b5 1e
            asl a                       ; 06078:  0a
            bcc b1_e07e                 ; 06079:  90 03
b1_e07b:    jmp b1_e0fe                 ; 0607B:  4c fe e0

b1_e07e:    lda $1e,x                   ; 0607E:  b5 1e
            beq b1_e07b                 ; 06080:  f0 f9
            cmp #$05                    ; 06082:  c9 05
            beq b1_e0a5                 ; 06084:  f0 1f
            cmp #$03                    ; 06086:  c9 03
            bcs b1_e0a4                 ; 06088:  b0 1a
            lda $1e,x                   ; 0608A:  b5 1e
            cmp #$02                    ; 0608C:  c9 02
            bne b1_e0a5                 ; 0608E:  d0 15
            lda #$10                    ; 06090:  a9 10
            ldy $16,x                   ; 06092:  b4 16
            cpy #$12                    ; 06094:  c0 12
            bne b1_e09a                 ; 06096:  d0 02
            lda #$00                    ; 06098:  a9 00
b1_e09a:    sta $0796,x                 ; 0609A:  9d 96 07
            lda #$03                    ; 0609D:  a9 03
            sta $1e,x                   ; 0609F:  95 1e
            jsr b1_e14f                 ; 060A1:  20 4f e1
b1_e0a4:    rts                         ; 060A4:  60

b1_e0a5:    lda $16,x                   ; 060A5:  b5 16
            cmp #$06                    ; 060A7:  c9 06
            beq b1_e0cd                 ; 060A9:  f0 22
            cmp #$12                    ; 060AB:  c9 12
            bne b1_e0bd                 ; 060AD:  d0 0e
            lda #$01                    ; 060AF:  a9 01
            sta $46,x                   ; 060B1:  95 46
            lda #$08                    ; 060B3:  a9 08
            sta $58,x                   ; 060B5:  95 58
            lda $09                     ; 060B7:  a5 09
            and #$07                    ; 060B9:  29 07
            beq b1_e0cd                 ; 060BB:  f0 10
b1_e0bd:    ldy #$01                    ; 060BD:  a0 01
            jsr b1_e143                 ; 060BF:  20 43 e1
            bpl b1_e0c5                 ; 060C2:  10 01
            iny                         ; 060C4:  c8
b1_e0c5:    tya                         ; 060C5:  98
            cmp $46,x                   ; 060C6:  d5 46
            bne b1_e0cd                 ; 060C8:  d0 03
            jsr b1_e124                 ; 060CA:  20 24 e1
b1_e0cd:    jsr b1_e14f                 ; 060CD:  20 4f e1
            lda $1e,x                   ; 060D0:  b5 1e
            and #$80                    ; 060D2:  29 80
            bne b1_e0db                 ; 060D4:  d0 05
            lda #$00                    ; 060D6:  a9 00
            sta $1e,x                   ; 060D8:  95 1e
            rts                         ; 060DA:  60

b1_e0db:    lda $1e,x                   ; 060DB:  b5 1e
            and #$bf                    ; 060DD:  29 bf
            sta $1e,x                   ; 060DF:  95 1e
            rts                         ; 060E1:  60

b1_e0e2:    lda $16,x                   ; 060E2:  b5 16
            cmp #$03                    ; 060E4:  c9 03
            bne b1_e0ec                 ; 060E6:  d0 04
            lda $1e,x                   ; 060E8:  b5 1e
            beq b1_e124                 ; 060EA:  f0 38
b1_e0ec:    lda $1e,x                   ; 060EC:  b5 1e
            tay                         ; 060EE:  a8
            asl a                       ; 060EF:  0a
            bcc b1_e0f9                 ; 060F0:  90 07
            lda $1e,x                   ; 060F2:  b5 1e
            ora #$40                    ; 060F4:  09 40
            jmp b1_e0fc                 ; 060F6:  4c fc e0

b1_e0f9:    lda tab_b1_dfb9,y           ; 060F9:  b9 b9 df
b1_e0fc:    sta $1e,x                   ; 060FC:  95 1e
b1_e0fe:    lda $cf,x                   ; 060FE:  b5 cf
            cmp #$20                    ; 06100:  c9 20
            bcc b1_e123                 ; 06102:  90 1f
            ldy #$16                    ; 06104:  a0 16
            lda #$02                    ; 06106:  a9 02
            sta $eb                     ; 06108:  85 eb
b1_e10a:    lda $eb                     ; 0610A:  a5 eb
            cmp $46,x                   ; 0610C:  d5 46
            bne b1_e11c                 ; 0610E:  d0 0c
            lda #$01                    ; 06110:  a9 01
            jsr b1_e388                 ; 06112:  20 88 e3
            beq b1_e11c                 ; 06115:  f0 05
            jsr b1_e1b5                 ; 06117:  20 b5 e1
            bne b1_e124                 ; 0611A:  d0 08
b1_e11c:    dec $eb                     ; 0611C:  c6 eb
            iny                         ; 0611E:  c8
            cpy #$18                    ; 0611F:  c0 18
            bcc b1_e10a                 ; 06121:  90 e7
b1_e123:    rts                         ; 06123:  60

b1_e124:    cpx #$05                    ; 06124:  e0 05
            beq b1_e131                 ; 06126:  f0 09
            lda $1e,x                   ; 06128:  b5 1e
            asl a                       ; 0612A:  0a
            bcc b1_e131                 ; 0612B:  90 04
            lda #$02                    ; 0612D:  a9 02
            sta $ff                     ; 0612F:  85 ff
b1_e131:    lda $16,x                   ; 06131:  b5 16
            cmp #$05                    ; 06133:  c9 05
            bne tab_b1_e140             ; 06135:  d0 09
            lda #$00                    ; 06137:  a9 00
            sta $00                     ; 06139:  85 00
            ldy #$fa                    ; 0613B:  a0 fa
            jmp b1_ca37                 ; 0613D:  4c 37 ca

tab_b1_e140: ; 3 bytes
            hex 4c 36 db                ; 06140:  4c 36 db

b1_e143:    lda $87,x                   ; 06143:  b5 87
            sec                         ; 06145:  38
            sbc $86                     ; 06146:  e5 86
            sta $00                     ; 06148:  85 00
            lda $6e,x                   ; 0614A:  b5 6e
            sbc $6d                     ; 0614C:  e5 6d
            rts                         ; 0614E:  60

b1_e14f:    jsr b1_c363                 ; 0614F:  20 63 c3
            lda $cf,x                   ; 06152:  b5 cf
            and #$f0                    ; 06154:  29 f0
            ora #$08                    ; 06156:  09 08
            sta $cf,x                   ; 06158:  95 cf
            rts                         ; 0615A:  60

b1_e15b:    lda $cf,x                   ; 0615B:  b5 cf
            clc                         ; 0615D:  18
            adc #$3e                    ; 0615E:  69 3e
            cmp #$44                    ; 06160:  c9 44
            rts                         ; 06162:  60

b1_e163:    jsr b1_e15b                 ; 06163:  20 5b e1
            bcc b1_e182                 ; 06166:  90 1a
            lda $a0,x                   ; 06168:  b5 a0
            clc                         ; 0616A:  18
            adc #$02                    ; 0616B:  69 02
            cmp #$03                    ; 0616D:  c9 03
            bcc b1_e182                 ; 0616F:  90 11
            jsr b1_e1ae                 ; 06171:  20 ae e1
            beq b1_e182                 ; 06174:  f0 0c
            jsr b1_e1b5                 ; 06176:  20 b5 e1
            beq b1_e182                 ; 06179:  f0 07
            jsr b1_e14f                 ; 0617B:  20 4f e1
            lda #$fd                    ; 0617E:  a9 fd
            sta $a0,x                   ; 06180:  95 a0
b1_e182:    jmp b1_e0fe                 ; 06182:  4c fe e0

b1_e185:    jsr b1_e1ae                 ; 06185:  20 ae e1
            beq b1_e1a7                 ; 06188:  f0 1d
            cmp #$23                    ; 0618A:  c9 23
            bne b1_e196                 ; 0618C:  d0 08
b1_e18e:    jsr b1_d795                 ; 0618E:  20 95 d7
            lda #$fc                    ; 06191:  a9 fc
            sta $a0,x                   ; 06193:  95 a0
            rts                         ; 06195:  60

b1_e196:    lda $078a,x                 ; 06196:  bd 8a 07
            bne b1_e1a7                 ; 06199:  d0 0c
            lda $1e,x                   ; 0619B:  b5 1e
            and #$88                    ; 0619D:  29 88
            sta $1e,x                   ; 0619F:  95 1e
            jsr b1_e14f                 ; 061A1:  20 4f e1
            jmp b1_e0fe                 ; 061A4:  4c fe e0

b1_e1a7:    lda $1e,x                   ; 061A7:  b5 1e
            ora #$01                    ; 061A9:  09 01
            sta $1e,x                   ; 061AB:  95 1e
            rts                         ; 061AD:  60

b1_e1ae:    lda #$00                    ; 061AE:  a9 00
            ldy #$15                    ; 061B0:  a0 15
            jmp b1_e388                 ; 061B2:  4c 88 e3

b1_e1b5:    cmp #$26                    ; 061B5:  c9 26
            beq b1_e1c7                 ; 061B7:  f0 0e
            cmp #$c2                    ; 061B9:  c9 c2
            beq b1_e1c7                 ; 061BB:  f0 0a
            cmp #$c3                    ; 061BD:  c9 c3
            beq b1_e1c7                 ; 061BF:  f0 06
            cmp #$5f                    ; 061C1:  c9 5f
            beq b1_e1c7                 ; 061C3:  f0 02
            cmp #$60                    ; 061C5:  c9 60
b1_e1c7:    rts                         ; 061C7:  60

            lda $d5,x                   ; 061C8:  b5 d5
            cmp #$18                    ; 061CA:  c9 18
            bcc b1_e1ef                 ; 061CC:  90 21
            jsr b1_e39c                 ; 061CE:  20 9c e3
            beq b1_e1ef                 ; 061D1:  f0 1c
            jsr b1_e1b5                 ; 061D3:  20 b5 e1
            beq b1_e1ef                 ; 061D6:  f0 17
            lda $a6,x                   ; 061D8:  b5 a6
            bmi b1_e1f4                 ; 061DA:  30 18
            lda $3a,x                   ; 061DC:  b5 3a
            bne b1_e1f4                 ; 061DE:  d0 14
            lda #$fd                    ; 061E0:  a9 fd
            sta $a6,x                   ; 061E2:  95 a6
            lda #$01                    ; 061E4:  a9 01
            sta $3a,x                   ; 061E6:  95 3a
            lda $d5,x                   ; 061E8:  b5 d5
            and #$f8                    ; 061EA:  29 f8
            sta $d5,x                   ; 061EC:  95 d5
            rts                         ; 061EE:  60

b1_e1ef:    lda #$00                    ; 061EF:  a9 00
            sta $3a,x                   ; 061F1:  95 3a
            rts                         ; 061F3:  60

b1_e1f4:    lda #$80                    ; 061F4:  a9 80
            sta $24,x                   ; 061F6:  95 24
            lda #$02                    ; 061F8:  a9 02
            sta $ff                     ; 061FA:  85 ff
            rts                         ; 061FC:  60

tab_b1_e1fd: ; 48 bytes
            hex 02 08 0e 20 03 14 0d 20 ; 061FD:  02 08 0e 20 03 14 0d 20
            hex 02 14 0e 20 02 09 0e 15 ; 06205:  02 14 0e 20 02 09 0e 15
            hex 00 00 18 06 00 00 20 0d ; 0620D:  00 00 18 06 00 00 20 0d
            hex 00 00 30 0d 00 00 08 08 ; 06215:  00 00 30 0d 00 00 08 08
            hex 06 04 0a 08 03 0e 0d 14 ; 0621D:  06 04 0a 08 03 0e 0d 14
            hex 00 02 10 15 04 04 0c 1c ; 06225:  00 02 10 15 04 04 0c 1c

            txa                         ; 0622D:  8a
            clc                         ; 0622E:  18
            adc #$07                    ; 0622F:  69 07
            tax                         ; 06231:  aa
            ldy #$02                    ; 06232:  a0 02
            bne b1_e23d                 ; 06234:  d0 07
            txa                         ; 06236:  8a
            clc                         ; 06237:  18
            adc #$09                    ; 06238:  69 09
            tax                         ; 0623A:  aa
            ldy #$06                    ; 0623B:  a0 06
b1_e23d:    jsr b1_e29c                 ; 0623D:  20 9c e2
            jmp b1_e2de                 ; 06240:  4c de e2

b1_e243:    ldy #$48                    ; 06243:  a0 48
            sty $00                     ; 06245:  84 00
            ldy #$44                    ; 06247:  a0 44
            jmp b1_e252                 ; 06249:  4c 52 e2

b1_e24c:    ldy #$08                    ; 0624C:  a0 08
            sty $00                     ; 0624E:  84 00
            ldy #$04                    ; 06250:  a0 04
b1_e252:    lda $87,x                   ; 06252:  b5 87
            sec                         ; 06254:  38
            sbc $071c                   ; 06255:  ed 1c 07
            sta $01                     ; 06258:  85 01
            lda $6e,x                   ; 0625A:  b5 6e
            sbc $071a                   ; 0625C:  ed 1a 07
            bmi b1_e267                 ; 0625F:  30 06
            ora $01                     ; 06261:  05 01
            beq b1_e267                 ; 06263:  f0 02
            ldy $00                     ; 06265:  a4 00
b1_e267:    tya                         ; 06267:  98
            and $03d1                   ; 06268:  2d d1 03
            sta $03d8,x                 ; 0626B:  9d d8 03
            bne b1_e289                 ; 0626E:  d0 19
            jmp b1_e27c                 ; 06270:  4c 7c e2

b1_e273:    inx                         ; 06273:  e8
            jsr b1_f1f6                 ; 06274:  20 f6 f1
            dex                         ; 06277:  ca
            cmp #$fe                    ; 06278:  c9 fe
            bcs b1_e289                 ; 0627A:  b0 0d
b1_e27c:    txa                         ; 0627C:  8a
            clc                         ; 0627D:  18
            adc #$01                    ; 0627E:  69 01
            tax                         ; 06280:  aa
            ldy #$01                    ; 06281:  a0 01
            jsr b1_e29c                 ; 06283:  20 9c e2
            jmp b1_e2de                 ; 06286:  4c de e2

b1_e289:    txa                         ; 06289:  8a
            asl a                       ; 0628A:  0a
            asl a                       ; 0628B:  0a
            tay                         ; 0628C:  a8
            lda #$ff                    ; 0628D:  a9 ff
            sta $04b0,y                 ; 0628F:  99 b0 04
            sta $04b1,y                 ; 06292:  99 b1 04
            sta $04b2,y                 ; 06295:  99 b2 04
            sta $04b3,y                 ; 06298:  99 b3 04
            rts                         ; 0629B:  60

b1_e29c:    stx $00                     ; 0629C:  86 00
            lda $03b8,y                 ; 0629E:  b9 b8 03
            sta $02                     ; 062A1:  85 02
            lda $03ad,y                 ; 062A3:  b9 ad 03
            sta $01                     ; 062A6:  85 01
            txa                         ; 062A8:  8a
            asl a                       ; 062A9:  0a
            asl a                       ; 062AA:  0a
            pha                         ; 062AB:  48
            tay                         ; 062AC:  a8
            lda $0499,x                 ; 062AD:  bd 99 04
            asl a                       ; 062B0:  0a
            asl a                       ; 062B1:  0a
            tax                         ; 062B2:  aa
            lda $01                     ; 062B3:  a5 01
            clc                         ; 062B5:  18
            adc tab_b1_e1fd,x           ; 062B6:  7d fd e1
            sta $04ac,y                 ; 062B9:  99 ac 04
            lda $01                     ; 062BC:  a5 01
            clc                         ; 062BE:  18
            adc tab_b1_e1fd+2,x         ; 062BF:  7d ff e1
            sta $04ae,y                 ; 062C2:  99 ae 04
            inx                         ; 062C5:  e8
            iny                         ; 062C6:  c8
            lda $02                     ; 062C7:  a5 02
            clc                         ; 062C9:  18
            adc tab_b1_e1fd,x           ; 062CA:  7d fd e1
            sta $04ac,y                 ; 062CD:  99 ac 04
            lda $02                     ; 062D0:  a5 02
            clc                         ; 062D2:  18
            adc tab_b1_e1fd+2,x         ; 062D3:  7d ff e1
            sta $04ae,y                 ; 062D6:  99 ae 04
            pla                         ; 062D9:  68
            tay                         ; 062DA:  a8
            ldx $00                     ; 062DB:  a6 00
            rts                         ; 062DD:  60

b1_e2de:    lda $071c                   ; 062DE:  ad 1c 07
            clc                         ; 062E1:  18
            adc #$80                    ; 062E2:  69 80
            sta $02                     ; 062E4:  85 02
            lda $071a                   ; 062E6:  ad 1a 07
            adc #$00                    ; 062E9:  69 00
            sta $01                     ; 062EB:  85 01
            lda $86,x                   ; 062ED:  b5 86
            cmp $02                     ; 062EF:  c5 02
            lda $6d,x                   ; 062F1:  b5 6d
            sbc $01                     ; 062F3:  e5 01
            bcc b1_e30c                 ; 062F5:  90 15
            lda $04ae,y                 ; 062F7:  b9 ae 04
            bmi b1_e309                 ; 062FA:  30 0d
            lda #$ff                    ; 062FC:  a9 ff
            ldx $04ac,y                 ; 062FE:  be ac 04
            bmi b1_e306                 ; 06301:  30 03
            sta $04ac,y                 ; 06303:  99 ac 04
b1_e306:    sta $04ae,y                 ; 06306:  99 ae 04
b1_e309:    ldx $08                     ; 06309:  a6 08
            rts                         ; 0630B:  60

b1_e30c:    lda $04ac,y                 ; 0630C:  b9 ac 04
            bpl b1_e322                 ; 0630F:  10 11
            cmp #$a0                    ; 06311:  c9 a0
            bcc b1_e322                 ; 06313:  90 0d
            lda #$00                    ; 06315:  a9 00
            ldx $04ae,y                 ; 06317:  be ae 04
            bpl b1_e31f                 ; 0631A:  10 03
            sta $04ae,y                 ; 0631C:  99 ae 04
b1_e31f:    sta $04ac,y                 ; 0631F:  99 ac 04
b1_e322:    ldx $08                     ; 06322:  a6 08
            rts                         ; 06324:  60

b1_e325:    ldx #$00                    ; 06325:  a2 00
b1_e327:    sty $06                     ; 06327:  84 06
            lda #$01                    ; 06329:  a9 01
            sta $07                     ; 0632B:  85 07
b1_e32d:    lda $04ac,y                 ; 0632D:  b9 ac 04
            cmp $04ac,x                 ; 06330:  dd ac 04
            bcs b1_e35f                 ; 06333:  b0 2a
            cmp $04ae,x                 ; 06335:  dd ae 04
            bcc b1_e34c                 ; 06338:  90 12
            beq b1_e37e                 ; 0633A:  f0 42
            lda $04ae,y                 ; 0633C:  b9 ae 04
            cmp $04ac,y                 ; 0633F:  d9 ac 04
            bcc b1_e37e                 ; 06342:  90 3a
            cmp $04ac,x                 ; 06344:  dd ac 04
            bcs b1_e37e                 ; 06347:  b0 35
            ldy $06                     ; 06349:  a4 06
            rts                         ; 0634B:  60

b1_e34c:    lda $04ae,x                 ; 0634C:  bd ae 04
            cmp $04ac,x                 ; 0634F:  dd ac 04
            bcc b1_e37e                 ; 06352:  90 2a
            lda $04ae,y                 ; 06354:  b9 ae 04
            cmp $04ac,x                 ; 06357:  dd ac 04
            bcs b1_e37e                 ; 0635A:  b0 22
            ldy $06                     ; 0635C:  a4 06
            rts                         ; 0635E:  60

b1_e35f:    cmp $04ac,x                 ; 0635F:  dd ac 04
            beq b1_e37e                 ; 06362:  f0 1a
            cmp $04ae,x                 ; 06364:  dd ae 04
            bcc b1_e37e                 ; 06367:  90 15
            beq b1_e37e                 ; 06369:  f0 13
            cmp $04ae,y                 ; 0636B:  d9 ae 04
            bcc b1_e37a                 ; 0636E:  90 0a
            beq b1_e37a                 ; 06370:  f0 08
            lda $04ae,y                 ; 06372:  b9 ae 04
            cmp $04ac,x                 ; 06375:  dd ac 04
            bcs b1_e37e                 ; 06378:  b0 04
b1_e37a:    clc                         ; 0637A:  18
            ldy $06                     ; 0637B:  a4 06
            rts                         ; 0637D:  60

b1_e37e:    inx                         ; 0637E:  e8
            iny                         ; 0637F:  c8
            dec $07                     ; 06380:  c6 07
            bpl b1_e32d                 ; 06382:  10 a9
            sec                         ; 06384:  38
            ldy $06                     ; 06385:  a4 06
            rts                         ; 06387:  60

b1_e388:    pha                         ; 06388:  48
            txa                         ; 06389:  8a
            clc                         ; 0638A:  18
            adc #$01                    ; 0638B:  69 01
            tax                         ; 0638D:  aa
            pla                         ; 0638E:  68
            jmp b1_e3a5                 ; 0638F:  4c a5 e3

            txa                         ; 06392:  8a
            clc                         ; 06393:  18
            adc #$0d                    ; 06394:  69 0d
            tax                         ; 06396:  aa
            ldy #$1b                    ; 06397:  a0 1b
            jmp b1_e3a3                 ; 06399:  4c a3 e3

b1_e39c:    ldy #$1a                    ; 0639C:  a0 1a
            txa                         ; 0639E:  8a
            clc                         ; 0639F:  18
            adc #$07                    ; 063A0:  69 07
            tax                         ; 063A2:  aa
b1_e3a3:    lda #$00                    ; 063A3:  a9 00
b1_e3a5:    jsr b1_e3f0                 ; 063A5:  20 f0 e3
            ldx $08                     ; 063A8:  a6 08
            cmp #$00                    ; 063AA:  c9 00
            rts                         ; 063AC:  60

tab_b1_e3ad: ; 55 bytes
            hex 00 07 0e 08 03 0c 02 02 ; 063AD:  00 07 0e 08 03 0c 02 02
            hex 0d 0d 08 03 0c 02 02 0d ; 063B5:  0d 0d 08 03 0c 02 02 0d
            hex 0d 08 03 0c 02 02 0d 0d ; 063BD:  0d 08 03 0c 02 02 0d 0d
            hex 08 00 10 04 14 04 04 04 ; 063C5:  08 00 10 04 14 04 04 04
            hex 20 20 08 18 08 18 02 20 ; 063CD:  20 20 08 18 08 18 02 20
            hex 20 08 18 08 18 12 20 20 ; 063D5:  20 08 18 08 18 12 20 20
            hex 18 18 18 18 18 14 14    ; 063DD:  18 18 18 18 18 14 14

            asl $06                     ; 063E4:  06 06
            php                         ; 063E6:  08
b1_e3e7:    bpl tab_b1_e3ad+4           ; 063E7:  10 c8
b1_e3e9:    lda #$00                    ; 063E9:  a9 00
b1_e3eb:    bit $01a9                   ; 063EB:  2c a9 01
            ldx #$00                    ; 063EE:  a2 00
b1_e3f0:    pha                         ; 063F0:  48
            sty $04                     ; 063F1:  84 04
            lda tab_b1_e3ad+3,y         ; 063F3:  b9 b0 e3
            clc                         ; 063F6:  18
            adc $86,x                   ; 063F7:  75 86
            sta $05                     ; 063F9:  85 05
            lda $6d,x                   ; 063FB:  b5 6d
            adc #$00                    ; 063FD:  69 00
            and #$01                    ; 063FF:  29 01
            lsr a                       ; 06401:  4a
            ora $05                     ; 06402:  05 05
            ror a                       ; 06404:  6a
            lsr a                       ; 06405:  4a
            lsr a                       ; 06406:  4a
            lsr a                       ; 06407:  4a
            jsr $9be1                   ; 06408:  20 e1 9b
            ldy $04                     ; 0640B:  a4 04
            lda $ce,x                   ; 0640D:  b5 ce
            clc                         ; 0640F:  18
            adc tab_b1_e3ad+31,y        ; 06410:  79 cc e3
            and #$f0                    ; 06413:  29 f0
            sec                         ; 06415:  38
            sbc #$20                    ; 06416:  e9 20
            sta $02                     ; 06418:  85 02
            tay                         ; 0641A:  a8
            lda ($06),y                 ; 0641B:  b1 06
            sta $03                     ; 0641D:  85 03
            ldy $04                     ; 0641F:  a4 04
            pla                         ; 06421:  68
            bne b1_e429                 ; 06422:  d0 05
            lda $ce,x                   ; 06424:  b5 ce
            jmp b1_e42b                 ; 06426:  4c 2b e4

b1_e429:    lda $86,x                   ; 06429:  b5 86
b1_e42b:    and #$0f                    ; 0642B:  29 0f
            sta $04                     ; 0642D:  85 04
            lda $03                     ; 0642F:  a5 03
            rts                         ; 06431:  60

            hex ff                      ; 06432:  ff

b1_e433:    brk                         ; 06433:  00
            hex 30                      ; 06434:  30
            sty $00                     ; 06435:  84 00
            lda $03b9                   ; 06437:  ad b9 03
            clc                         ; 0643A:  18
            adc b1_e433,y               ; 0643B:  79 33 e4
            ldx $039a,y                 ; 0643E:  be 9a 03
            ldy $06e5,x                 ; 06441:  bc e5 06
            sty $02                     ; 06444:  84 02
            jsr b1_e4ae                 ; 06446:  20 ae e4
            lda $03ae                   ; 06449:  ad ae 03
            sta $0203,y                 ; 0644C:  99 03 02
            sta $020b,y                 ; 0644F:  99 0b 02
            sta $0213,y                 ; 06452:  99 13 02
            clc                         ; 06455:  18
            adc #$06                    ; 06456:  69 06
            sta $0207,y                 ; 06458:  99 07 02
            sta $020f,y                 ; 0645B:  99 0f 02
            sta $0217,y                 ; 0645E:  99 17 02
            lda #$21                    ; 06461:  a9 21
            sta $0202,y                 ; 06463:  99 02 02
            sta $020a,y                 ; 06466:  99 0a 02
            sta $0212,y                 ; 06469:  99 12 02
            ora #$40                    ; 0646C:  09 40
            sta $0206,y                 ; 0646E:  99 06 02
            sta $020e,y                 ; 06471:  99 0e 02
            sta $0216,y                 ; 06474:  99 16 02
            ldx #$05                    ; 06477:  a2 05
b1_e479:    lda #$e1                    ; 06479:  a9 e1
            sta $0201,y                 ; 0647B:  99 01 02
            iny                         ; 0647E:  c8
            iny                         ; 0647F:  c8
            iny                         ; 06480:  c8
            iny                         ; 06481:  c8
            dex                         ; 06482:  ca
            bpl b1_e479                 ; 06483:  10 f4
            ldy $02                     ; 06485:  a4 02
            lda $00                     ; 06487:  a5 00
            bne b1_e490                 ; 06489:  d0 05
            lda #$e0                    ; 0648B:  a9 e0
            sta $0201,y                 ; 0648D:  99 01 02
b1_e490:    ldx #$00                    ; 06490:  a2 00
b1_e492:    lda $039d                   ; 06492:  ad 9d 03
            sec                         ; 06495:  38
            sbc $0200,y                 ; 06496:  f9 00 02
            cmp #$64                    ; 06499:  c9 64
            bcc b1_e4a2                 ; 0649B:  90 05
            lda #$f8                    ; 0649D:  a9 f8
            sta $0200,y                 ; 0649F:  99 00 02
b1_e4a2:    iny                         ; 064A2:  c8
            iny                         ; 064A3:  c8
            iny                         ; 064A4:  c8
            iny                         ; 064A5:  c8
            inx                         ; 064A6:  e8
            cpx #$06                    ; 064A7:  e0 06
            bne b1_e492                 ; 064A9:  d0 e7
            ldy $00                     ; 064AB:  a4 00
            rts                         ; 064AD:  60

b1_e4ae:    ldx #$06                    ; 064AE:  a2 06
b1_e4b0:    sta $0200,y                 ; 064B0:  99 00 02
            clc                         ; 064B3:  18
            adc #$08                    ; 064B4:  69 08
            iny                         ; 064B6:  c8
            iny                         ; 064B7:  c8
            iny                         ; 064B8:  c8
            iny                         ; 064B9:  c8
            dex                         ; 064BA:  ca
            bne b1_e4b0                 ; 064BB:  d0 f3
            ldy $02                     ; 064BD:  a4 02
            rts                         ; 064BF:  60

tab_b1_e4c0: ; 28 bytes
            hex 04 00 04 00 00 04 00 04 ; 064C0:  04 00 04 00 00 04 00 04
            hex 00 08 00 08 08 00 08 00 ; 064C8:  00 08 00 08 08 00 08 00
            hex 80 82 81 83 81 83 80 82 ; 064D0:  80 82 81 83 81 83 80 82
            hex 03 03 c3 c3             ; 064D8:  03 03 c3 c3

            ldy $06f3,x                 ; 064DC:  bc f3 06
            lda $0747                   ; 064DF:  ad 47 07
            bne b1_e4ec                 ; 064E2:  d0 08
            lda $2a,x                   ; 064E4:  b5 2a
            and #$7f                    ; 064E6:  29 7f
            cmp #$01                    ; 064E8:  c9 01
            beq b1_e4f0                 ; 064EA:  f0 04
b1_e4ec:    ldx #$00                    ; 064EC:  a2 00
            beq b1_e4f7                 ; 064EE:  f0 07
b1_e4f0:    lda $09                     ; 064F0:  a5 09
            lsr a                       ; 064F2:  4a
            lsr a                       ; 064F3:  4a
            and #$03                    ; 064F4:  29 03
            tax                         ; 064F6:  aa
b1_e4f7:    lda $03be                   ; 064F7:  ad be 03
            clc                         ; 064FA:  18
            adc tab_b1_e4c0+4,x         ; 064FB:  7d c4 e4
            sta $0200,y                 ; 064FE:  99 00 02
            clc                         ; 06501:  18
            adc tab_b1_e4c0+12,x        ; 06502:  7d cc e4
            sta $0204,y                 ; 06505:  99 04 02
            lda $03b3                   ; 06508:  ad b3 03
            clc                         ; 0650B:  18
            adc tab_b1_e4c0,x           ; 0650C:  7d c0 e4
            sta $0203,y                 ; 0650F:  99 03 02
            clc                         ; 06512:  18
            adc tab_b1_e4c0+8,x         ; 06513:  7d c8 e4
            sta $0207,y                 ; 06516:  99 07 02
            lda tab_b1_e4c0+16,x        ; 06519:  bd d0 e4
            sta $0201,y                 ; 0651C:  99 01 02
            lda tab_b1_e4c0+20,x        ; 0651F:  bd d4 e4
            sta $0205,y                 ; 06522:  99 05 02
            lda tab_b1_e4c0+24,x        ; 06525:  bd d8 e4
            sta $0202,y                 ; 06528:  99 02 02
            sta $0206,y                 ; 0652B:  99 06 02
            ldx $08                     ; 0652E:  a6 08
            lda $03d6                   ; 06530:  ad d6 03
            and #$fc                    ; 06533:  29 fc
            beq b1_e540                 ; 06535:  f0 09
            lda #$00                    ; 06537:  a9 00
            sta $2a,x                   ; 06539:  95 2a
            lda #$f8                    ; 0653B:  a9 f8
            jsr b1_e5c1                 ; 0653D:  20 c1 e5
b1_e540:    rts                         ; 06540:  60

tab_b1_e541: ; 8 bytes
            hex f9 50 f7 50 fa fb f8 fb ; 06541:  f9 50 f7 50 fa fb f8 fb

            inc $fb,x                   ; 06549:  f6 fb
            ldy $06e5,x                 ; 0654B:  bc e5 06
            lda $03ae                   ; 0654E:  ad ae 03
            sta $0203,y                 ; 06551:  99 03 02
            clc                         ; 06554:  18
            adc #$08                    ; 06555:  69 08
            sta $0207,y                 ; 06557:  99 07 02
            sta $020b,y                 ; 0655A:  99 0b 02
            clc                         ; 0655D:  18
            adc #$0c                    ; 0655E:  69 0c
            sta $05                     ; 06560:  85 05
            lda $cf,x                   ; 06562:  b5 cf
            jsr b1_e5c1                 ; 06564:  20 c1 e5
            adc #$08                    ; 06567:  69 08
            sta $0208,y                 ; 06569:  99 08 02
            lda $010d                   ; 0656C:  ad 0d 01
            sta $02                     ; 0656F:  85 02
            lda #$01                    ; 06571:  a9 01
            sta $03                     ; 06573:  85 03
            sta $04                     ; 06575:  85 04
            sta $0202,y                 ; 06577:  99 02 02
            sta $0206,y                 ; 0657A:  99 06 02
            sta $020a,y                 ; 0657D:  99 0a 02
            lda #$7e                    ; 06580:  a9 7e
            sta $0201,y                 ; 06582:  99 01 02
            sta $0209,y                 ; 06585:  99 09 02
            lda #$7f                    ; 06588:  a9 7f
            sta $0205,y                 ; 0658A:  99 05 02
            lda $070f                   ; 0658D:  ad 0f 07
            beq b1_e5a7                 ; 06590:  f0 15
            tya                         ; 06592:  98
            clc                         ; 06593:  18
            adc #$0c                    ; 06594:  69 0c
            tay                         ; 06596:  a8
            lda $010f                   ; 06597:  ad 0f 01
            asl a                       ; 0659A:  0a
            tax                         ; 0659B:  aa
            lda tab_b1_e541,x           ; 0659C:  bd 41 e5
            sta $00                     ; 0659F:  85 00
            lda tab_b1_e541+1,x         ; 065A1:  bd 42 e5
            jsr b1_ebb2                 ; 065A4:  20 b2 eb
b1_e5a7:    ldx $08                     ; 065A7:  a6 08
            ldy $06e5,x                 ; 065A9:  bc e5 06
            lda $03d1                   ; 065AC:  ad d1 03
            and #$0e                    ; 065AF:  29 0e
            beq b1_e5c7                 ; 065B1:  f0 14
b1_e5b3:    lda #$f8                    ; 065B3:  a9 f8
b1_e5b5:    sta $0214,y                 ; 065B5:  99 14 02
            sta $0210,y                 ; 065B8:  99 10 02
b1_e5bb:    sta $020c,y                 ; 065BB:  99 0c 02
b1_e5be:    sta $0208,y                 ; 065BE:  99 08 02
b1_e5c1:    sta $0204,y                 ; 065C1:  99 04 02
            sta $0200,y                 ; 065C4:  99 00 02
b1_e5c7:    rts                         ; 065C7:  60

b1_e5c8:    ldy $06e5,x                 ; 065C8:  bc e5 06
            sty $02                     ; 065CB:  84 02
            iny                         ; 065CD:  c8
            iny                         ; 065CE:  c8
            iny                         ; 065CF:  c8
            lda $03ae                   ; 065D0:  ad ae 03
            jsr b1_e4ae                 ; 065D3:  20 ae e4
            ldx $08                     ; 065D6:  a6 08
            lda $cf,x                   ; 065D8:  b5 cf
            jsr b1_e5bb                 ; 065DA:  20 bb e5
            ldy $074e                   ; 065DD:  ac 4e 07
            cpy #$03                    ; 065E0:  c0 03
            beq b1_e5e9                 ; 065E2:  f0 05
            ldy $06cc                   ; 065E4:  ac cc 06
            beq b1_e5eb                 ; 065E7:  f0 02
b1_e5e9:    lda #$f8                    ; 065E9:  a9 f8
b1_e5eb:    ldy $06e5,x                 ; 065EB:  bc e5 06
            sta $0210,y                 ; 065EE:  99 10 02
            sta $0214,y                 ; 065F1:  99 14 02
            lda #$5b                    ; 065F4:  a9 5b
            ldx $0743                   ; 065F6:  ae 43 07
            beq b1_e5fd                 ; 065F9:  f0 02
            lda #$75                    ; 065FB:  a9 75
b1_e5fd:    ldx $08                     ; 065FD:  a6 08
            iny                         ; 065FF:  c8
            jsr b1_e5b5                 ; 06600:  20 b5 e5
            lda #$02                    ; 06603:  a9 02
            iny                         ; 06605:  c8
            jsr b1_e5b5                 ; 06606:  20 b5 e5
            inx                         ; 06609:  e8
            jsr b1_f1f6                 ; 0660A:  20 f6 f1
            dex                         ; 0660D:  ca
            ldy $06e5,x                 ; 0660E:  bc e5 06
            asl a                       ; 06611:  0a
            pha                         ; 06612:  48
            bcc b1_e61a                 ; 06613:  90 05
            lda #$f8                    ; 06615:  a9 f8
            sta $0200,y                 ; 06617:  99 00 02
b1_e61a:    pla                         ; 0661A:  68
            asl a                       ; 0661B:  0a
            pha                         ; 0661C:  48
            bcc b1_e624                 ; 0661D:  90 05
            lda #$f8                    ; 0661F:  a9 f8
            sta $0204,y                 ; 06621:  99 04 02
b1_e624:    pla                         ; 06624:  68
            asl a                       ; 06625:  0a
            pha                         ; 06626:  48
            bcc b1_e62e                 ; 06627:  90 05
            lda #$f8                    ; 06629:  a9 f8
            sta $0208,y                 ; 0662B:  99 08 02
b1_e62e:    pla                         ; 0662E:  68
            asl a                       ; 0662F:  0a
            pha                         ; 06630:  48
            bcc b1_e638                 ; 06631:  90 05
            lda #$f8                    ; 06633:  a9 f8
            sta $020c,y                 ; 06635:  99 0c 02
b1_e638:    pla                         ; 06638:  68
            asl a                       ; 06639:  0a
            pha                         ; 0663A:  48
            bcc b1_e642                 ; 0663B:  90 05
            lda #$f8                    ; 0663D:  a9 f8
            sta $0210,y                 ; 0663F:  99 10 02
b1_e642:    pla                         ; 06642:  68
            asl a                       ; 06643:  0a
            bcc b1_e64b                 ; 06644:  90 05
            lda #$f8                    ; 06646:  a9 f8
            sta $0214,y                 ; 06648:  99 14 02
b1_e64b:    lda $03d1                   ; 0664B:  ad d1 03
            asl a                       ; 0664E:  0a
            bcc b1_e654                 ; 0664F:  90 03
            jsr b1_e5b3                 ; 06651:  20 b3 e5
b1_e654:    rts                         ; 06654:  60

b1_e655:    lda $09                     ; 06655:  a5 09
            lsr a                       ; 06657:  4a
            bcs b1_e65c                 ; 06658:  b0 02
            dec $db,x                   ; 0665A:  d6 db
b1_e65c:    lda $db,x                   ; 0665C:  b5 db
            jsr b1_e5c1                 ; 0665E:  20 c1 e5
            lda $03b3                   ; 06661:  ad b3 03
            sta $0203,y                 ; 06664:  99 03 02
            clc                         ; 06667:  18
            adc #$08                    ; 06668:  69 08
            sta $0207,y                 ; 0666A:  99 07 02
            lda #$02                    ; 0666D:  a9 02
            sta $0202,y                 ; 0666F:  99 02 02
            sta $0206,y                 ; 06672:  99 06 02
            lda #$f7                    ; 06675:  a9 f7
            sta $0201,y                 ; 06677:  99 01 02
            lda #$fb                    ; 0667A:  a9 fb
            sta $0205,y                 ; 0667C:  99 05 02
            jmp b1_e6bd                 ; 0667F:  4c bd e6

tab_b1_e682: ; 4 bytes
            hex 60 61 62 63             ; 06682:  60 61 62 63

            ldy $06f3,x                 ; 06686:  bc f3 06
            lda $2a,x                   ; 06689:  b5 2a
            cmp #$02                    ; 0668B:  c9 02
            bcs b1_e655                 ; 0668D:  b0 c6
            lda $db,x                   ; 0668F:  b5 db
            sta $0200,y                 ; 06691:  99 00 02
            clc                         ; 06694:  18
            adc #$08                    ; 06695:  69 08
            sta $0204,y                 ; 06697:  99 04 02
            lda $03b3                   ; 0669A:  ad b3 03
            sta $0203,y                 ; 0669D:  99 03 02
            sta $0207,y                 ; 066A0:  99 07 02
            lda $09                     ; 066A3:  a5 09
            lsr a                       ; 066A5:  4a
            and #$03                    ; 066A6:  29 03
            tax                         ; 066A8:  aa
            lda tab_b1_e682,x           ; 066A9:  bd 82 e6
            iny                         ; 066AC:  c8
            jsr b1_e5c1                 ; 066AD:  20 c1 e5
            dey                         ; 066B0:  88
            lda #$02                    ; 066B1:  a9 02
            sta $0202,y                 ; 066B3:  99 02 02
            lda #$82                    ; 066B6:  a9 82
            sta $0206,y                 ; 066B8:  99 06 02
            ldx $08                     ; 066BB:  a6 08
b1_e6bd:    rts                         ; 066BD:  60

tab_b1_e6be: ; 19 bytes
            hex 76 77 78 79 d6 d6 d9 d9 ; 066BE:  76 77 78 79 d6 d6 d9 d9
            hex 8d 8d e4 e4 76 77 78 79 ; 066C6:  8d 8d e4 e4 76 77 78 79
            hex 02 01 02                ; 066CE:  02 01 02

            ora ($ac,x)                 ; 066D1:  01 ac
            nop                         ; 066D3:  ea
            asl $ad                     ; 066D4:  06 ad
            lda $1803,y                 ; 066D6:  b9 03 18
            adc #$08                    ; 066D9:  69 08
            sta $02                     ; 066DB:  85 02
            lda $03ae                   ; 066DD:  ad ae 03
            sta $05                     ; 066E0:  85 05
            ldx $39                     ; 066E2:  a6 39
            lda tab_b1_e6be+16,x        ; 066E4:  bd ce e6
            ora $03ca                   ; 066E7:  0d ca 03
            sta $04                     ; 066EA:  85 04
            txa                         ; 066EC:  8a
            pha                         ; 066ED:  48
            asl a                       ; 066EE:  0a
            asl a                       ; 066EF:  0a
            tax                         ; 066F0:  aa
            lda #$01                    ; 066F1:  a9 01
            sta $07                     ; 066F3:  85 07
            sta $03                     ; 066F5:  85 03
b1_e6f7:    lda tab_b1_e6be,x           ; 066F7:  bd be e6
            sta $00                     ; 066FA:  85 00
            lda tab_b1_e6be+1,x         ; 066FC:  bd bf e6
            jsr b1_ebb2                 ; 066FF:  20 b2 eb
            dec $07                     ; 06702:  c6 07
            bpl b1_e6f7                 ; 06704:  10 f1
            ldy $06ea                   ; 06706:  ac ea 06
            pla                         ; 06709:  68
            beq b1_e73b                 ; 0670A:  f0 2f
            cmp #$03                    ; 0670C:  c9 03
            beq b1_e73b                 ; 0670E:  f0 2b
            sta $00                     ; 06710:  85 00
            lda $09                     ; 06712:  a5 09
            lsr a                       ; 06714:  4a
            and #$03                    ; 06715:  29 03
            ora $03ca                   ; 06717:  0d ca 03
            sta $0202,y                 ; 0671A:  99 02 02
            sta $0206,y                 ; 0671D:  99 06 02
            ldx $00                     ; 06720:  a6 00
            dex                         ; 06722:  ca
            beq b1_e72b                 ; 06723:  f0 06
            sta $020a,y                 ; 06725:  99 0a 02
            sta $020e,y                 ; 06728:  99 0e 02
b1_e72b:    lda $0206,y                 ; 0672B:  b9 06 02
            ora #$40                    ; 0672E:  09 40
            sta $0206,y                 ; 06730:  99 06 02
            lda $020e,y                 ; 06733:  b9 0e 02
            ora #$40                    ; 06736:  09 40
            sta $020e,y                 ; 06738:  99 0e 02
b1_e73b:    jmp b1_eb64                 ; 0673B:  4c 64 eb

tab_b1_e73e: ; 312 bytes
            hex fc fc aa ab ac ad fc fc ; 0673E:  fc fc aa ab ac ad fc fc
            hex ae af b0 b1 fc a5 a6 a7 ; 06746:  ae af b0 b1 fc a5 a6 a7
            hex a8 a9 fc a0 a1 a2 a3 a4 ; 0674E:  a8 a9 fc a0 a1 a2 a3 a4
            hex 69 a5 6a a7 a8 a9 6b a0 ; 06756:  69 a5 6a a7 a8 a9 6b a0
            hex 6c a2 a3 a4 fc fc 96 97 ; 0675E:  6c a2 a3 a4 fc fc 96 97
            hex 98 99 fc fc 9a 9b 9c 9d ; 06766:  98 99 fc fc 9a 9b 9c 9d
            hex fc fc 8f 8e 8e 8f fc fc ; 0676E:  fc fc 8f 8e 8e 8f fc fc
            hex 95 94 94 95 fc fc dc dc ; 06776:  95 94 94 95 fc fc dc dc
            hex df df dc dc dd dd de de ; 0677E:  df df dc dc dd dd de de
            hex fc fc b2 b3 b4 b5 fc fc ; 06786:  fc fc b2 b3 b4 b5 fc fc
            hex b6 b3 b7 b5 fc fc 70 71 ; 0678E:  b6 b3 b7 b5 fc fc 70 71
            hex 72 73 fc fc 6e 6e 6f 6f ; 06796:  72 73 fc fc 6e 6e 6f 6f
            hex fc fc 6d 6d 6f 6f fc fc ; 0679E:  fc fc 6d 6d 6f 6f fc fc
            hex 6f 6f 6e 6e fc fc 6f 6f ; 067A6:  6f 6f 6e 6e fc fc 6f 6f
            hex 6d 6d fc fc f4 f4 f5 f5 ; 067AE:  6d 6d fc fc f4 f4 f5 f5
            hex fc fc f4 f4 f5 f5 fc fc ; 067B6:  fc fc f4 f4 f5 f5 fc fc
            hex f5 f5 f4 f4 fc fc f5 f5 ; 067BE:  f5 f5 f4 f4 fc fc f5 f5
            hex f4 f4 fc fc fc fc ef ef ; 067C6:  f4 f4 fc fc fc fc ef ef
            hex b9 b8 bb ba bc bc fc fc ; 067CE:  b9 b8 bb ba bc bc fc fc
            hex bd bd bc bc 7a 7b da db ; 067D6:  bd bd bc bc 7a 7b da db
            hex d8 d8 cd cd ce ce cf cf ; 067DE:  d8 d8 cd cd ce ce cf cf
            hex 7d 7c d1 8c d3 d2 7d 7c ; 067E6:  7d 7c d1 8c d3 d2 7d 7c
            hex 89 88 8b 8a d5 d4 e3 e2 ; 067EE:  89 88 8b 8a d5 d4 e3 e2
            hex d3 d2 d5 d4 e3 e2 8b 8a ; 067F6:  d3 d2 d5 d4 e3 e2 8b 8a
            hex e5 e5 e6 e6 eb eb ec ec ; 067FE:  e5 e5 e6 e6 eb eb ec ec
            hex ed ed ee ee fc fc d0 d0 ; 06806:  ed ed ee ee fc fc d0 d0
            hex d7 d7 bf be c1 c0 c2 fc ; 0680E:  d7 d7 bf be c1 c0 c2 fc
            hex c4 c3 c6 c5 c8 c7 bf be ; 06816:  c4 c3 c6 c5 c8 c7 bf be
            hex ca c9 c2 fc c4 c3 c6 c5 ; 0681E:  ca c9 c2 fc c4 c3 c6 c5
            hex cc cb fc fc e8 e7 ea e9 ; 06826:  cc cb fc fc e8 e7 ea e9
            hex f2 f2 f3 f3 f2 f2 f1 f1 ; 0682E:  f2 f2 f3 f3 f2 f2 f1 f1
            hex f1 f1 fc fc f0 f0 fc fc ; 06836:  f1 f1 fc fc f0 f0 fc fc
            hex fc fc 0c 0c 00 0c 0c a8 ; 0683E:  fc fc 0c 0c 00 0c 0c a8
            hex 54 3c ea 18 48 48 cc c0 ; 06846:  54 3c ea 18 48 48 cc c0
            hex 18 18 18 90 24 ff 48 9c ; 0684E:  18 18 18 90 24 ff 48 9c
            hex d2 d8 f0 f6 fc 01 02 03 ; 06856:  d2 d8 f0 f6 fc 01 02 03
            hex 02 01 01 03 03 03 01 01 ; 0685E:  02 01 01 03 03 03 01 01
            hex 02 02 21 01 02 01 01 02 ; 06866:  02 02 21 01 02 01 01 02
            hex ff 02 02 01 01 02 02 02 ; 0686E:  ff 02 02 01 01 02 02 02

b1_e876:    php                         ; 06876:  08
            clc                         ; 06877:  18
b1_e878:    clc                         ; 06878:  18
            ora $191a,y                 ; 06879:  19 1a 19
            clc                         ; 0687C:  18
b1_e87d:    lda $cf,x                   ; 0687D:  b5 cf
            sta $02                     ; 0687F:  85 02
            lda $03ae                   ; 06881:  ad ae 03
            sta $05                     ; 06884:  85 05
            ldy $06e5,x                 ; 06886:  bc e5 06
            sty $eb                     ; 06889:  84 eb
            lda #$00                    ; 0688B:  a9 00
            sta $0109                   ; 0688D:  8d 09 01
            lda $46,x                   ; 06890:  b5 46
            sta $03                     ; 06892:  85 03
            lda $03c5,x                 ; 06894:  bd c5 03
            sta $04                     ; 06897:  85 04
            lda $16,x                   ; 06899:  b5 16
            cmp #$0d                    ; 0689B:  c9 0d
            bne b1_e8a9                 ; 0689D:  d0 0a
            ldy $58,x                   ; 0689F:  b4 58
            bmi b1_e8a9                 ; 068A1:  30 06
            ldy $078a,x                 ; 068A3:  bc 8a 07
            beq b1_e8a9                 ; 068A6:  f0 01
            rts                         ; 068A8:  60

b1_e8a9:    lda $1e,x                   ; 068A9:  b5 1e
            sta $ed                     ; 068AB:  85 ed
            and #$1f                    ; 068AD:  29 1f
            tay                         ; 068AF:  a8
            lda $16,x                   ; 068B0:  b5 16
            cmp #$35                    ; 068B2:  c9 35
            bne b1_e8be                 ; 068B4:  d0 08
            ldy #$00                    ; 068B6:  a0 00
            lda #$01                    ; 068B8:  a9 01
            sta $03                     ; 068BA:  85 03
            lda #$15                    ; 068BC:  a9 15
b1_e8be:    cmp #$33                    ; 068BE:  c9 33
            bne b1_e8d5                 ; 068C0:  d0 13
            dec $02                     ; 068C2:  c6 02
            lda #$03                    ; 068C4:  a9 03
            ldy $078a,x                 ; 068C6:  bc 8a 07
            beq b1_e8cd                 ; 068C9:  f0 02
            ora #$20                    ; 068CB:  09 20
b1_e8cd:    sta $04                     ; 068CD:  85 04
            ldy #$00                    ; 068CF:  a0 00
            sty $ed                     ; 068D1:  84 ed
            lda #$08                    ; 068D3:  a9 08
b1_e8d5:    cmp #$32                    ; 068D5:  c9 32
            bne b1_e8e1                 ; 068D7:  d0 08
            ldy #$03                    ; 068D9:  a0 03
            ldx $070e                   ; 068DB:  ae 0e 07
            lda b1_e878,x               ; 068DE:  bd 78 e8
b1_e8e1:    sta $ef                     ; 068E1:  85 ef
            sty $ec                     ; 068E3:  84 ec
            ldx $08                     ; 068E5:  a6 08
            cmp #$0c                    ; 068E7:  c9 0c
            bne b1_e8f2                 ; 068E9:  d0 07
            lda $a0,x                   ; 068EB:  b5 a0
            bmi b1_e8f2                 ; 068ED:  30 03
            inc $0109                   ; 068EF:  ee 09 01
b1_e8f2:    lda $036a                   ; 068F2:  ad 6a 03
            beq b1_e900                 ; 068F5:  f0 09
            ldy #$16                    ; 068F7:  a0 16
            cmp #$01                    ; 068F9:  c9 01
            beq b1_e8fe                 ; 068FB:  f0 01
            iny                         ; 068FD:  c8
b1_e8fe:    sty $ef                     ; 068FE:  84 ef
b1_e900:    ldy $ef                     ; 06900:  a4 ef
            cpy #$06                    ; 06902:  c0 06
            bne b1_e923                 ; 06904:  d0 1d
            lda $1e,x                   ; 06906:  b5 1e
            cmp #$02                    ; 06908:  c9 02
            bcc b1_e910                 ; 0690A:  90 04
            ldx #$04                    ; 0690C:  a2 04
            stx $ec                     ; 0690E:  86 ec
b1_e910:    and #$20                    ; 06910:  29 20
            ora $0747                   ; 06912:  0d 47 07
            bne b1_e923                 ; 06915:  d0 0c
            lda $09                     ; 06917:  a5 09
            and #$08                    ; 06919:  29 08
            bne b1_e923                 ; 0691B:  d0 06
            lda $03                     ; 0691D:  a5 03
            eor #$03                    ; 0691F:  49 03
            sta $03                     ; 06921:  85 03
b1_e923:    lda tab_b1_e73e+285,y       ; 06923:  b9 5b e8
            ora $04                     ; 06926:  05 04
            sta $04                     ; 06928:  85 04
            lda tab_b1_e73e+258,y       ; 0692A:  b9 40 e8
            tax                         ; 0692D:  aa
            ldy $ec                     ; 0692E:  a4 ec
            lda $036a                   ; 06930:  ad 6a 03
            beq b1_e965                 ; 06933:  f0 30
            cmp #$01                    ; 06935:  c9 01
            bne b1_e94c                 ; 06937:  d0 13
            lda $0363                   ; 06939:  ad 63 03
            bpl b1_e940                 ; 0693C:  10 02
            ldx #$de                    ; 0693E:  a2 de
b1_e940:    lda $ed                     ; 06940:  a5 ed
            and #$20                    ; 06942:  29 20
            beq b1_e949                 ; 06944:  f0 03
b1_e946:    stx $0109                   ; 06946:  8e 09 01
b1_e949:    jmp b1_ea4b                 ; 06949:  4c 4b ea

b1_e94c:    lda $0363                   ; 0694C:  ad 63 03
            and #$01                    ; 0694F:  29 01
            beq b1_e955                 ; 06951:  f0 02
            ldx #$e4                    ; 06953:  a2 e4
b1_e955:    lda $ed                     ; 06955:  a5 ed
            and #$20                    ; 06957:  29 20
            beq b1_e949                 ; 06959:  f0 ee
            lda $02                     ; 0695B:  a5 02
            sec                         ; 0695D:  38
            sbc #$10                    ; 0695E:  e9 10
            sta $02                     ; 06960:  85 02
            jmp b1_e946                 ; 06962:  4c 46 e9

b1_e965:    cpx #$24                    ; 06965:  e0 24
            bne b1_e97a                 ; 06967:  d0 11
            cpy #$05                    ; 06969:  c0 05
            bne b1_e977                 ; 0696B:  d0 0a
            ldx #$30                    ; 0696D:  a2 30
            lda #$02                    ; 0696F:  a9 02
            sta $03                     ; 06971:  85 03
            lda #$05                    ; 06973:  a9 05
            sta $ec                     ; 06975:  85 ec
b1_e977:    jmp b1_e9ca                 ; 06977:  4c ca e9

b1_e97a:    cpx #$90                    ; 0697A:  e0 90
            bne b1_e990                 ; 0697C:  d0 12
            lda $ed                     ; 0697E:  a5 ed
            and #$20                    ; 06980:  29 20
            bne b1_e98d                 ; 06982:  d0 09
            lda $078f                   ; 06984:  ad 8f 07
            cmp #$10                    ; 06987:  c9 10
            bcs b1_e98d                 ; 06989:  b0 02
            ldx #$96                    ; 0698B:  a2 96
b1_e98d:    jmp b1_ea37                 ; 0698D:  4c 37 ea

b1_e990:    lda $ef                     ; 06990:  a5 ef
            cmp #$04                    ; 06992:  c9 04
            bcs b1_e9a6                 ; 06994:  b0 10
            cpy #$02                    ; 06996:  c0 02
            bcc b1_e9a6                 ; 06998:  90 0c
            ldx #$5a                    ; 0699A:  a2 5a
            ldy $ef                     ; 0699C:  a4 ef
            cpy #$02                    ; 0699E:  c0 02
            bne b1_e9a6                 ; 069A0:  d0 04
            ldx #$7e                    ; 069A2:  a2 7e
            inc $02                     ; 069A4:  e6 02
b1_e9a6:    lda $ec                     ; 069A6:  a5 ec
            cmp #$04                    ; 069A8:  c9 04
            bne b1_e9ca                 ; 069AA:  d0 1e
            ldx #$72                    ; 069AC:  a2 72
            inc $02                     ; 069AE:  e6 02
            ldy $ef                     ; 069B0:  a4 ef
            cpy #$02                    ; 069B2:  c0 02
            beq b1_e9ba                 ; 069B4:  f0 04
            ldx #$66                    ; 069B6:  a2 66
            inc $02                     ; 069B8:  e6 02
b1_e9ba:    cpy #$06                    ; 069BA:  c0 06
            bne b1_e9ca                 ; 069BC:  d0 0c
            ldx #$54                    ; 069BE:  a2 54
            lda $ed                     ; 069C0:  a5 ed
            and #$20                    ; 069C2:  29 20
            bne b1_e9ca                 ; 069C4:  d0 04
            ldx #$8a                    ; 069C6:  a2 8a
            dec $02                     ; 069C8:  c6 02
b1_e9ca:    ldy $08                     ; 069CA:  a4 08
            lda $ef                     ; 069CC:  a5 ef
            cmp #$05                    ; 069CE:  c9 05
            bne b1_e9de                 ; 069D0:  d0 0c
            lda $ed                     ; 069D2:  a5 ed
            beq b1_e9fa                 ; 069D4:  f0 24
            and #$08                    ; 069D6:  29 08
            beq b1_ea37                 ; 069D8:  f0 5d
            ldx #$b4                    ; 069DA:  a2 b4
            bne b1_e9fa                 ; 069DC:  d0 1c
b1_e9de:    cpx #$48                    ; 069DE:  e0 48
            beq b1_e9fa                 ; 069E0:  f0 18
            lda $0796,y                 ; 069E2:  b9 96 07
            cmp #$05                    ; 069E5:  c9 05
            bcs b1_ea37                 ; 069E7:  b0 4e
            cpx #$3c                    ; 069E9:  e0 3c
            bne b1_e9fa                 ; 069EB:  d0 0d
            cmp #$01                    ; 069ED:  c9 01
            beq b1_ea37                 ; 069EF:  f0 46
            inc $02                     ; 069F1:  e6 02
            inc $02                     ; 069F3:  e6 02
            inc $02                     ; 069F5:  e6 02
            jmp b1_ea29                 ; 069F7:  4c 29 ea

b1_e9fa:    lda $ef                     ; 069FA:  a5 ef
            cmp #$06                    ; 069FC:  c9 06
            beq b1_ea37                 ; 069FE:  f0 37
            cmp #$08                    ; 06A00:  c9 08
            beq b1_ea37                 ; 06A02:  f0 33
            cmp #$0c                    ; 06A04:  c9 0c
            beq b1_ea37                 ; 06A06:  f0 2f
            cmp #$18                    ; 06A08:  c9 18
            bcs b1_ea37                 ; 06A0A:  b0 2b
            ldy #$00                    ; 06A0C:  a0 00
            cmp #$15                    ; 06A0E:  c9 15
            bne b1_ea22                 ; 06A10:  d0 10
            iny                         ; 06A12:  c8
            lda $075f                   ; 06A13:  ad 5f 07
            cmp #$07                    ; 06A16:  c9 07
            bcs b1_ea37                 ; 06A18:  b0 1d
            ldx #$a2                    ; 06A1A:  a2 a2
            lda #$03                    ; 06A1C:  a9 03
            sta $ec                     ; 06A1E:  85 ec
            bne b1_ea37                 ; 06A20:  d0 15
b1_ea22:    lda $09                     ; 06A22:  a5 09
            and b1_e876,y               ; 06A24:  39 76 e8
            bne b1_ea37                 ; 06A27:  d0 0e
b1_ea29:    lda $ed                     ; 06A29:  a5 ed
            and #$a0                    ; 06A2B:  29 a0
            ora $0747                   ; 06A2D:  0d 47 07
            bne b1_ea37                 ; 06A30:  d0 05
            txa                         ; 06A32:  8a
            clc                         ; 06A33:  18
            adc #$06                    ; 06A34:  69 06
            tax                         ; 06A36:  aa
b1_ea37:    lda $ed                     ; 06A37:  a5 ed
            and #$20                    ; 06A39:  29 20
            beq b1_ea4b                 ; 06A3B:  f0 0e
            lda $ef                     ; 06A3D:  a5 ef
            cmp #$04                    ; 06A3F:  c9 04
            bcc b1_ea4b                 ; 06A41:  90 08
            ldy #$01                    ; 06A43:  a0 01
            sty $0109                   ; 06A45:  8c 09 01
            dey                         ; 06A48:  88
            sty $ec                     ; 06A49:  84 ec
b1_ea4b:    ldy $eb                     ; 06A4B:  a4 eb
            jsr b1_ebaa                 ; 06A4D:  20 aa eb
            jsr b1_ebaa                 ; 06A50:  20 aa eb
            jsr b1_ebaa                 ; 06A53:  20 aa eb
            ldx $08                     ; 06A56:  a6 08
            ldy $06e5,x                 ; 06A58:  bc e5 06
            lda $ef                     ; 06A5B:  a5 ef
            cmp #$08                    ; 06A5D:  c9 08
            bne b1_ea64                 ; 06A5F:  d0 03
b1_ea61:    jmp b1_eb64                 ; 06A61:  4c 64 eb

b1_ea64:    lda $0109                   ; 06A64:  ad 09 01
            beq b1_eaa6                 ; 06A67:  f0 3d
            lda $0202,y                 ; 06A69:  b9 02 02
            ora #$80                    ; 06A6C:  09 80
            iny                         ; 06A6E:  c8
            iny                         ; 06A6F:  c8
            jsr b1_e5b5                 ; 06A70:  20 b5 e5
            dey                         ; 06A73:  88
            dey                         ; 06A74:  88
            tya                         ; 06A75:  98
            tax                         ; 06A76:  aa
            lda $ef                     ; 06A77:  a5 ef
            cmp #$05                    ; 06A79:  c9 05
            beq b1_ea8a                 ; 06A7B:  f0 0d
            cmp #$11                    ; 06A7D:  c9 11
            beq b1_ea8a                 ; 06A7F:  f0 09
            cmp #$15                    ; 06A81:  c9 15
            bcs b1_ea8a                 ; 06A83:  b0 05
            txa                         ; 06A85:  8a
            clc                         ; 06A86:  18
            adc #$08                    ; 06A87:  69 08
            tax                         ; 06A89:  aa
b1_ea8a:    lda $0201,x                 ; 06A8A:  bd 01 02
            pha                         ; 06A8D:  48
            lda $0205,x                 ; 06A8E:  bd 05 02
            pha                         ; 06A91:  48
            lda $0211,y                 ; 06A92:  b9 11 02
            sta $0201,x                 ; 06A95:  9d 01 02
            lda $0215,y                 ; 06A98:  b9 15 02
            sta $0205,x                 ; 06A9B:  9d 05 02
            pla                         ; 06A9E:  68
            sta $0215,y                 ; 06A9F:  99 15 02
            pla                         ; 06AA2:  68
            sta $0211,y                 ; 06AA3:  99 11 02
b1_eaa6:    lda $036a                   ; 06AA6:  ad 6a 03
            bne b1_ea61                 ; 06AA9:  d0 b6
            lda $ef                     ; 06AAB:  a5 ef
            ldx $ec                     ; 06AAD:  a6 ec
            cmp #$05                    ; 06AAF:  c9 05
            bne b1_eab6                 ; 06AB1:  d0 03
            jmp b1_eb64                 ; 06AB3:  4c 64 eb

b1_eab6:    cmp #$07                    ; 06AB6:  c9 07
            beq b1_ead7                 ; 06AB8:  f0 1d
            cmp #$0d                    ; 06ABA:  c9 0d
            beq b1_ead7                 ; 06ABC:  f0 19
            cmp #$0c                    ; 06ABE:  c9 0c
            beq b1_ead7                 ; 06AC0:  f0 15
            cmp #$12                    ; 06AC2:  c9 12
            bne b1_eaca                 ; 06AC4:  d0 04
            cpx #$05                    ; 06AC6:  e0 05
            bne b1_eb12                 ; 06AC8:  d0 48
b1_eaca:    cmp #$15                    ; 06ACA:  c9 15
            bne b1_ead3                 ; 06ACC:  d0 05
            lda #$42                    ; 06ACE:  a9 42
            sta $0216,y                 ; 06AD0:  99 16 02
b1_ead3:    cpx #$02                    ; 06AD3:  e0 02
            bcc b1_eb12                 ; 06AD5:  90 3b
b1_ead7:    lda $036a                   ; 06AD7:  ad 6a 03
            bne b1_eb12                 ; 06ADA:  d0 36
            lda $0202,y                 ; 06ADC:  b9 02 02
            and #$a3                    ; 06ADF:  29 a3
            sta $0202,y                 ; 06AE1:  99 02 02
            sta $020a,y                 ; 06AE4:  99 0a 02
            sta $0212,y                 ; 06AE7:  99 12 02
            ora #$40                    ; 06AEA:  09 40
            cpx #$05                    ; 06AEC:  e0 05
            bne b1_eaf2                 ; 06AEE:  d0 02
            ora #$80                    ; 06AF0:  09 80
b1_eaf2:    sta $0206,y                 ; 06AF2:  99 06 02
            sta $020e,y                 ; 06AF5:  99 0e 02
            sta $0216,y                 ; 06AF8:  99 16 02
            cpx #$04                    ; 06AFB:  e0 04
            bne b1_eb12                 ; 06AFD:  d0 13
            lda $020a,y                 ; 06AFF:  b9 0a 02
            ora #$80                    ; 06B02:  09 80
            sta $020a,y                 ; 06B04:  99 0a 02
            sta $0212,y                 ; 06B07:  99 12 02
            ora #$40                    ; 06B0A:  09 40
            sta $020e,y                 ; 06B0C:  99 0e 02
            sta $0216,y                 ; 06B0F:  99 16 02
b1_eb12:    lda $ef                     ; 06B12:  a5 ef
            cmp #$11                    ; 06B14:  c9 11
            bne b1_eb4e                 ; 06B16:  d0 36
            lda $0109                   ; 06B18:  ad 09 01
            bne b1_eb3e                 ; 06B1B:  d0 21
            lda $0212,y                 ; 06B1D:  b9 12 02
            and #$81                    ; 06B20:  29 81
            sta $0212,y                 ; 06B22:  99 12 02
            lda $0216,y                 ; 06B25:  b9 16 02
            ora #$41                    ; 06B28:  09 41
            sta $0216,y                 ; 06B2A:  99 16 02
            ldx $078f                   ; 06B2D:  ae 8f 07
            cpx #$10                    ; 06B30:  e0 10
            bcs b1_eb64                 ; 06B32:  b0 30
            sta $020e,y                 ; 06B34:  99 0e 02
            and #$81                    ; 06B37:  29 81
            sta $020a,y                 ; 06B39:  99 0a 02
            bcc b1_eb64                 ; 06B3C:  90 26
b1_eb3e:    lda $0202,y                 ; 06B3E:  b9 02 02
            and #$81                    ; 06B41:  29 81
            sta $0202,y                 ; 06B43:  99 02 02
            lda $0206,y                 ; 06B46:  b9 06 02
            ora #$41                    ; 06B49:  09 41
            sta $0206,y                 ; 06B4B:  99 06 02
b1_eb4e:    lda $ef                     ; 06B4E:  a5 ef
            cmp #$18                    ; 06B50:  c9 18
            bcc b1_eb64                 ; 06B52:  90 10
            lda #$82                    ; 06B54:  a9 82
            sta $020a,y                 ; 06B56:  99 0a 02
            sta $0212,y                 ; 06B59:  99 12 02
            ora #$40                    ; 06B5C:  09 40
            sta $020e,y                 ; 06B5E:  99 0e 02
            sta $0216,y                 ; 06B61:  99 16 02
b1_eb64:    ldx $08                     ; 06B64:  a6 08
            lda $03d1                   ; 06B66:  ad d1 03
            lsr a                       ; 06B69:  4a
            lsr a                       ; 06B6A:  4a
            lsr a                       ; 06B6B:  4a
            pha                         ; 06B6C:  48
            bcc b1_eb74                 ; 06B6D:  90 05
            lda #$04                    ; 06B6F:  a9 04
            jsr b1_ebc1                 ; 06B71:  20 c1 eb
b1_eb74:    pla                         ; 06B74:  68
            lsr a                       ; 06B75:  4a
            pha                         ; 06B76:  48
            bcc b1_eb7e                 ; 06B77:  90 05
            lda #$00                    ; 06B79:  a9 00
            jsr b1_ebc1                 ; 06B7B:  20 c1 eb
b1_eb7e:    pla                         ; 06B7E:  68
            lsr a                       ; 06B7F:  4a
            lsr a                       ; 06B80:  4a
            pha                         ; 06B81:  48
            bcc b1_eb89                 ; 06B82:  90 05
            lda #$10                    ; 06B84:  a9 10
            jsr b1_ebb7                 ; 06B86:  20 b7 eb
b1_eb89:    pla                         ; 06B89:  68
            lsr a                       ; 06B8A:  4a
            pha                         ; 06B8B:  48
            bcc b1_eb93                 ; 06B8C:  90 05
            lda #$08                    ; 06B8E:  a9 08
            jsr b1_ebb7                 ; 06B90:  20 b7 eb
b1_eb93:    pla                         ; 06B93:  68
            lsr a                       ; 06B94:  4a
            bcc b1_eba9                 ; 06B95:  90 12
            jsr b1_ebb7                 ; 06B97:  20 b7 eb
            lda $16,x                   ; 06B9A:  b5 16
            cmp #$0c                    ; 06B9C:  c9 0c
            beq b1_eba9                 ; 06B9E:  f0 09
            lda $b6,x                   ; 06BA0:  b5 b6
            cmp #$02                    ; 06BA2:  c9 02
            bne b1_eba9                 ; 06BA4:  d0 03
            jsr tab_b1_c982+22          ; 06BA6:  20 98 c9
b1_eba9:    rts                         ; 06BA9:  60

b1_ebaa:    lda tab_b1_e73e,x           ; 06BAA:  bd 3e e7
            sta $00                     ; 06BAD:  85 00
            lda tab_b1_e73e+1,x         ; 06BAF:  bd 3f e7
b1_ebb2:    sta $01                     ; 06BB2:  85 01
            jmp b1_f282                 ; 06BB4:  4c 82 f2

b1_ebb7:    clc                         ; 06BB7:  18
            adc $06e5,x                 ; 06BB8:  7d e5 06
            tay                         ; 06BBB:  a8
            lda #$f8                    ; 06BBC:  a9 f8
            jmp b1_e5c1                 ; 06BBE:  4c c1 e5

b1_ebc1:    clc                         ; 06BC1:  18
            adc $06e5,x                 ; 06BC2:  7d e5 06
            tay                         ; 06BC5:  a8
            jsr b1_ec4a                 ; 06BC6:  20 4a ec
            sta $0210,y                 ; 06BC9:  99 10 02
            rts                         ; 06BCC:  60

b1_ebcd:    sta $85                     ; 06BCD:  85 85
            stx $86                     ; 06BCF:  86 86
            lda $03bc                   ; 06BD1:  ad bc 03
            sta $02                     ; 06BD4:  85 02
            lda $03b1                   ; 06BD6:  ad b1 03
            sta $05                     ; 06BD9:  85 05
            lda #$03                    ; 06BDB:  a9 03
            sta $04                     ; 06BDD:  85 04
            lsr a                       ; 06BDF:  4a
            sta $03                     ; 06BE0:  85 03
            ldy $06ec,x                 ; 06BE2:  bc ec 06
            ldx #$00                    ; 06BE5:  a2 00
b1_ebe7:    lda b1_ebcd,x               ; 06BE7:  bd cd eb
            sta $00                     ; 06BEA:  85 00
            lda b1_ebcd+1,x             ; 06BEC:  bd ce eb
            jsr b1_ebb2                 ; 06BEF:  20 b2 eb
            cpx #$04                    ; 06BF2:  e0 04
            bne b1_ebe7                 ; 06BF4:  d0 f1
            ldx $08                     ; 06BF6:  a6 08
            ldy $06ec,x                 ; 06BF8:  bc ec 06
            lda $074e                   ; 06BFB:  ad 4e 07
            cmp #$01                    ; 06BFE:  c9 01
            beq b1_ec0a                 ; 06C00:  f0 08
            lda #$86                    ; 06C02:  a9 86
            sta $0201,y                 ; 06C04:  99 01 02
            sta $0205,y                 ; 06C07:  99 05 02
b1_ec0a:    lda $03e8,x                 ; 06C0A:  bd e8 03
            cmp #$c4                    ; 06C0D:  c9 c4
            bne b1_ec35                 ; 06C0F:  d0 24
            lda #$87                    ; 06C11:  a9 87
            iny                         ; 06C13:  c8
            jsr b1_e5bb                 ; 06C14:  20 bb e5
            dey                         ; 06C17:  88
            lda #$03                    ; 06C18:  a9 03
            ldx $074e                   ; 06C1A:  ae 4e 07
            dex                         ; 06C1D:  ca
            beq b1_ec21                 ; 06C1E:  f0 01
            lsr a                       ; 06C20:  4a
b1_ec21:    ldx $08                     ; 06C21:  a6 08
            sta $0202,y                 ; 06C23:  99 02 02
            ora #$40                    ; 06C26:  09 40
            sta $0206,y                 ; 06C28:  99 06 02
            ora #$80                    ; 06C2B:  09 80
            sta $020e,y                 ; 06C2D:  99 0e 02
            and #$83                    ; 06C30:  29 83
            sta $020a,y                 ; 06C32:  99 0a 02
b1_ec35:    lda $03d4                   ; 06C35:  ad d4 03
            pha                         ; 06C38:  48
            and #$04                    ; 06C39:  29 04
            beq b1_ec45                 ; 06C3B:  f0 08
            lda #$f8                    ; 06C3D:  a9 f8
            sta $0204,y                 ; 06C3F:  99 04 02
            sta $020c,y                 ; 06C42:  99 0c 02
b1_ec45:    pla                         ; 06C45:  68
b1_ec46:    and #$08                    ; 06C46:  29 08
            beq b1_ec52                 ; 06C48:  f0 08
b1_ec4a:    lda #$f8                    ; 06C4A:  a9 f8
            sta $0200,y                 ; 06C4C:  99 00 02
            sta $0208,y                 ; 06C4F:  99 08 02
b1_ec52:    rts                         ; 06C52:  60

            lda #$02                    ; 06C53:  a9 02
            sta $00                     ; 06C55:  85 00
            lda #$75                    ; 06C57:  a9 75
            ldy $0e                     ; 06C59:  a4 0e
            cpy #$05                    ; 06C5B:  c0 05
            beq b1_ec65                 ; 06C5D:  f0 06
            lda #$03                    ; 06C5F:  a9 03
            sta $00                     ; 06C61:  85 00
            lda #$84                    ; 06C63:  a9 84
b1_ec65:    ldy $06ec,x                 ; 06C65:  bc ec 06
            iny                         ; 06C68:  c8
            jsr b1_e5bb                 ; 06C69:  20 bb e5
            lda $09                     ; 06C6C:  a5 09
            asl a                       ; 06C6E:  0a
            asl a                       ; 06C6F:  0a
            asl a                       ; 06C70:  0a
            asl a                       ; 06C71:  0a
            and #$c0                    ; 06C72:  29 c0
            ora $00                     ; 06C74:  05 00
            iny                         ; 06C76:  c8
            jsr b1_e5bb                 ; 06C77:  20 bb e5
            dey                         ; 06C7A:  88
            dey                         ; 06C7B:  88
            lda $03bc                   ; 06C7C:  ad bc 03
            jsr b1_e5c1                 ; 06C7F:  20 c1 e5
            lda $03b1                   ; 06C82:  ad b1 03
            sta $0203,y                 ; 06C85:  99 03 02
            lda $03f1,x                 ; 06C88:  bd f1 03
            sec                         ; 06C8B:  38
            sbc $071c                   ; 06C8C:  ed 1c 07
            sta $00                     ; 06C8F:  85 00
            sec                         ; 06C91:  38
            sbc $03b1                   ; 06C92:  ed b1 03
            adc $00                     ; 06C95:  65 00
            adc #$06                    ; 06C97:  69 06
            sta $0207,y                 ; 06C99:  99 07 02
            lda $03bd                   ; 06C9C:  ad bd 03
            sta $0208,y                 ; 06C9F:  99 08 02
            sta $020c,y                 ; 06CA2:  99 0c 02
            lda $03b2                   ; 06CA5:  ad b2 03
            sta $020b,y                 ; 06CA8:  99 0b 02
            lda $00                     ; 06CAB:  a5 00
            sec                         ; 06CAD:  38
            sbc $03b2                   ; 06CAE:  ed b2 03
            adc $00                     ; 06CB1:  65 00
            adc #$06                    ; 06CB3:  69 06
            sta $020f,y                 ; 06CB5:  99 0f 02
            lda $03d4                   ; 06CB8:  ad d4 03
            jsr b1_ec46                 ; 06CBB:  20 46 ec
            lda $03d4                   ; 06CBE:  ad d4 03
            asl a                       ; 06CC1:  0a
            bcc b1_ecc9                 ; 06CC2:  90 05
            lda #$f8                    ; 06CC4:  a9 f8
            jsr b1_e5c1                 ; 06CC6:  20 c1 e5
b1_ecc9:    lda $00                     ; 06CC9:  a5 00
            bpl b1_ecdd                 ; 06CCB:  10 10
            lda $0203,y                 ; 06CCD:  b9 03 02
            cmp $0207,y                 ; 06CD0:  d9 07 02
            bcc b1_ecdd                 ; 06CD3:  90 08
            lda #$f8                    ; 06CD5:  a9 f8
            sta $0204,y                 ; 06CD7:  99 04 02
            sta $020c,y                 ; 06CDA:  99 0c 02
b1_ecdd:    rts                         ; 06CDD:  60

            ldy $06f1,x                 ; 06CDE:  bc f1 06
            lda $03ba                   ; 06CE1:  ad ba 03
            sta $0200,y                 ; 06CE4:  99 00 02
            lda $03af                   ; 06CE7:  ad af 03
            sta $0203,y                 ; 06CEA:  99 03 02
b1_eced:    lda $09                     ; 06CED:  a5 09
            lsr a                       ; 06CEF:  4a
            lsr a                       ; 06CF0:  4a
            pha                         ; 06CF1:  48
            and #$01                    ; 06CF2:  29 01
            eor #$64                    ; 06CF4:  49 64
            sta $0201,y                 ; 06CF6:  99 01 02
            pla                         ; 06CF9:  68
            lsr a                       ; 06CFA:  4a
            lsr a                       ; 06CFB:  4a
            lda #$02                    ; 06CFC:  a9 02
            bcc b1_ed02                 ; 06CFE:  90 02
            ora #$c0                    ; 06D00:  09 c0
b1_ed02:    sta $0202,y                 ; 06D02:  99 02 02
            rts                         ; 06D05:  60

tab_b1_ed06: ; 2 bytes
            hex 68 67                   ; 06D06:  68 67

            ror $bc                     ; 06D08:  66 bc
            cpx $b506                   ; 06D0A:  ec 06 b5
            bit $f6                     ; 06D0D:  24 f6
            bit $4a                     ; 06D0F:  24 4a
            and #$07                    ; 06D11:  29 07
            cmp #$03                    ; 06D13:  c9 03
            bcs b1_ed61                 ; 06D15:  b0 4a
b1_ed17:    tax                         ; 06D17:  aa
            lda tab_b1_ed06,x           ; 06D18:  bd 06 ed
            iny                         ; 06D1B:  c8
            jsr b1_e5bb                 ; 06D1C:  20 bb e5
            dey                         ; 06D1F:  88
            ldx $08                     ; 06D20:  a6 08
            lda $03ba                   ; 06D22:  ad ba 03
            sec                         ; 06D25:  38
            sbc #$04                    ; 06D26:  e9 04
            sta $0200,y                 ; 06D28:  99 00 02
            sta $0208,y                 ; 06D2B:  99 08 02
            clc                         ; 06D2E:  18
            adc #$08                    ; 06D2F:  69 08
            sta $0204,y                 ; 06D31:  99 04 02
            sta $020c,y                 ; 06D34:  99 0c 02
            lda $03af                   ; 06D37:  ad af 03
            sec                         ; 06D3A:  38
            sbc #$04                    ; 06D3B:  e9 04
            sta $0203,y                 ; 06D3D:  99 03 02
            sta $0207,y                 ; 06D40:  99 07 02
            clc                         ; 06D43:  18
            adc #$08                    ; 06D44:  69 08
            sta $020b,y                 ; 06D46:  99 0b 02
            sta $020f,y                 ; 06D49:  99 0f 02
            lda #$02                    ; 06D4C:  a9 02
            sta $0202,y                 ; 06D4E:  99 02 02
            lda #$82                    ; 06D51:  a9 82
            sta $0206,y                 ; 06D53:  99 06 02
            lda #$42                    ; 06D56:  a9 42
            sta $020a,y                 ; 06D58:  99 0a 02
            lda #$c2                    ; 06D5B:  a9 c2
            sta $020e,y                 ; 06D5D:  99 0e 02
            rts                         ; 06D60:  60

b1_ed61:    lda #$00                    ; 06D61:  a9 00
            sta $24,x                   ; 06D63:  95 24
            rts                         ; 06D65:  60

b1_ed66:    ldy $06e5,x                 ; 06D66:  bc e5 06
            lda #$5b                    ; 06D69:  a9 5b
            iny                         ; 06D6B:  c8
            jsr b1_e5b5                 ; 06D6C:  20 b5 e5
            iny                         ; 06D6F:  c8
            lda #$02                    ; 06D70:  a9 02
            jsr b1_e5b5                 ; 06D72:  20 b5 e5
            dey                         ; 06D75:  88
            dey                         ; 06D76:  88
            lda $03ae                   ; 06D77:  ad ae 03
            sta $0203,y                 ; 06D7A:  99 03 02
            sta $020f,y                 ; 06D7D:  99 0f 02
            clc                         ; 06D80:  18
            adc #$08                    ; 06D81:  69 08
            sta $0207,y                 ; 06D83:  99 07 02
            sta $0213,y                 ; 06D86:  99 13 02
            clc                         ; 06D89:  18
            adc #$08                    ; 06D8A:  69 08
            sta $020b,y                 ; 06D8C:  99 0b 02
            sta $0217,y                 ; 06D8F:  99 17 02
            lda $cf,x                   ; 06D92:  b5 cf
            tax                         ; 06D94:  aa
            pha                         ; 06D95:  48
            cpx #$20                    ; 06D96:  e0 20
            bcs b1_ed9c                 ; 06D98:  b0 02
            lda #$f8                    ; 06D9A:  a9 f8
b1_ed9c:    jsr b1_e5be                 ; 06D9C:  20 be e5
            pla                         ; 06D9F:  68
            clc                         ; 06DA0:  18
            adc #$80                    ; 06DA1:  69 80
            tax                         ; 06DA3:  aa
            cpx #$20                    ; 06DA4:  e0 20
            bcs b1_edaa                 ; 06DA6:  b0 02
            lda #$f8                    ; 06DA8:  a9 f8
b1_edaa:    sta $020c,y                 ; 06DAA:  99 0c 02
            sta $0210,y                 ; 06DAD:  99 10 02
            sta $0214,y                 ; 06DB0:  99 14 02
            lda $03d1                   ; 06DB3:  ad d1 03
            pha                         ; 06DB6:  48
            and #$08                    ; 06DB7:  29 08
            beq b1_edc3                 ; 06DB9:  f0 08
            lda #$f8                    ; 06DBB:  a9 f8
            sta $0200,y                 ; 06DBD:  99 00 02
            sta $020c,y                 ; 06DC0:  99 0c 02
b1_edc3:    pla                         ; 06DC3:  68
            pha                         ; 06DC4:  48
            and #$04                    ; 06DC5:  29 04
            beq b1_edd1                 ; 06DC7:  f0 08
            lda #$f8                    ; 06DC9:  a9 f8
            sta $0204,y                 ; 06DCB:  99 04 02
            sta $0210,y                 ; 06DCE:  99 10 02
b1_edd1:    pla                         ; 06DD1:  68
            and #$02                    ; 06DD2:  29 02
            beq b1_edde                 ; 06DD4:  f0 08
            lda #$f8                    ; 06DD6:  a9 f8
            sta $0208,y                 ; 06DD8:  99 08 02
            sta $0214,y                 ; 06DDB:  99 14 02
b1_edde:    ldx $08                     ; 06DDE:  a6 08
            rts                         ; 06DE0:  60

            ldy $b5                     ; 06DE1:  a4 b5
            dey                         ; 06DE3:  88
            bne b1_ee06                 ; 06DE4:  d0 20
            lda $03d3                   ; 06DE6:  ad d3 03
            and #$08                    ; 06DE9:  29 08
            bne b1_ee06                 ; 06DEB:  d0 19
            ldy $06ee,x                 ; 06DED:  bc ee 06
            lda $03b0                   ; 06DF0:  ad b0 03
            sta $0203,y                 ; 06DF3:  99 03 02
            lda $03bb                   ; 06DF6:  ad bb 03
            sta $0200,y                 ; 06DF9:  99 00 02
            lda #$74                    ; 06DFC:  a9 74
            sta $0201,y                 ; 06DFE:  99 01 02
            lda #$02                    ; 06E01:  a9 02
            sta $0202,y                 ; 06E03:  99 02 02
b1_ee06:    rts                         ; 06E06:  60

tab_b1_ee07: ; 9 bytes
            hex 20 28 c8 18 00 40 50 58 ; 06E07:  20 28 c8 18 00 40 50 58
            hex 80                      ; 06E0F:  80

            dey                         ; 06E10:  88
            clv                         ; 06E11:  b8
            sei                         ; 06E12:  78
            rts                         ; 06E13:  60

tab_b1_ee14: ; 127 bytes
            hex a0 b0 b8 00 01 02 03 04 ; 06E14:  a0 b0 b8 00 01 02 03 04
            hex 05 06 07 08 09 0a 0b 0c ; 06E1C:  05 06 07 08 09 0a 0b 0c
            hex 0d 0e 0f 10 11 12 13 14 ; 06E24:  0d 0e 0f 10 11 12 13 14
            hex 15 16 17 18 19 1a 1b 1c ; 06E2C:  15 16 17 18 19 1a 1b 1c
            hex 1d 1e 1f 20 21 22 23 24 ; 06E34:  1d 1e 1f 20 21 22 23 24
            hex 25 26 27 08 09 28 29 2a ; 06E3C:  25 26 27 08 09 28 29 2a
            hex 2b 2c 2d 08 09 0a 0b 0c ; 06E44:  2b 2c 2d 08 09 0a 0b 0c
            hex 30 2c 2d 08 09 0a 0b 2e ; 06E4C:  30 2c 2d 08 09 0a 0b 2e
            hex 2f 2c 2d 08 09 28 29 2a ; 06E54:  2f 2c 2d 08 09 28 29 2a
            hex 2b 5c 5d 08 09 0a 0b 0c ; 06E5C:  2b 5c 5d 08 09 0a 0b 0c
            hex 0d 5e 5f fc fc 08 09 58 ; 06E64:  0d 5e 5f fc fc 08 09 58
            hex 59 5a 5a 08 09 28 29 2a ; 06E6C:  59 5a 5a 08 09 28 29 2a
            hex 2b 0e 0f fc fc fc fc 32 ; 06E74:  2b 0e 0f fc fc fc fc 32
            hex 33 34 35 fc fc fc fc 36 ; 06E7C:  33 34 35 fc fc fc fc 36
            hex 37 38 39 fc fc fc fc 3a ; 06E84:  37 38 39 fc fc fc fc 3a
            hex 37 3b 3c fc fc fc fc    ; 06E8C:  37 3b 3c fc fc fc fc

            and $3f3e,x                 ; 06E93:  3d 3e 3f
            rti                         ; 06E96:  40

tab_b1_ee97: ; 66 bytes
            hex fc fc fc fc 32 41 42 43 ; 06E97:  fc fc fc fc 32 41 42 43
            hex fc fc fc fc 32 33 44 45 ; 06E9F:  fc fc fc fc 32 33 44 45
            hex fc fc fc fc 32 33 44 47 ; 06EA7:  fc fc fc fc 32 33 44 47
            hex fc fc fc fc 32 33 48 49 ; 06EAF:  fc fc fc fc 32 33 48 49
            hex fc fc fc fc 32 33 90 91 ; 06EB7:  fc fc fc fc 32 33 90 91
            hex fc fc fc fc 3a 37 92 93 ; 06EBF:  fc fc fc fc 3a 37 92 93
            hex fc fc fc fc 9e 9e 9f 9f ; 06EC7:  fc fc fc fc 9e 9e 9f 9f
            hex fc fc fc fc 3a 37 4f 4f ; 06ECF:  fc fc fc fc 3a 37 4f 4f
            hex fc fc                   ; 06ED7:  fc fc

            brk                         ; 06ED9:  00
            hex 01                      ; 06EDA:  01
            jmp $4e4d                   ; 06EDB:  4c 4d 4e

            lsr $0100                   ; 06EDE:  4e 00 01
            jmp $4a4d                   ; 06EE1:  4c 4d 4a

            hex 4a 4b 4b                ; 06EE4:  4a 4b 4b

b1_eee7:    and ($46),y                 ; 06EE7:  31 46
            lda $079e                   ; 06EE9:  ad 9e 07
            beq b1_eef3                 ; 06EEC:  f0 05
            lda $09                     ; 06EEE:  a5 09
            lsr a                       ; 06EF0:  4a
            bcs b1_ef33                 ; 06EF1:  b0 40
b1_eef3:    lda $0e                     ; 06EF3:  a5 0e
            cmp #$0b                    ; 06EF5:  c9 0b
            beq b1_ef40                 ; 06EF7:  f0 47
            lda $070b                   ; 06EF9:  ad 0b 07
            bne b1_ef3a                 ; 06EFC:  d0 3c
            ldy $0704                   ; 06EFE:  ac 04 07
            beq b1_ef34                 ; 06F01:  f0 31
            lda $1d                     ; 06F03:  a5 1d
            cmp #$00                    ; 06F05:  c9 00
            beq b1_ef34                 ; 06F07:  f0 2b
            jsr b1_ef34                 ; 06F09:  20 34 ef
            lda $09                     ; 06F0C:  a5 09
            and #$04                    ; 06F0E:  29 04
            bne b1_ef33                 ; 06F10:  d0 21
            tax                         ; 06F12:  aa
            ldy $06e4                   ; 06F13:  ac e4 06
            lda $33                     ; 06F16:  a5 33
            lsr a                       ; 06F18:  4a
            bcs b1_ef1f                 ; 06F19:  b0 04
            iny                         ; 06F1B:  c8
            iny                         ; 06F1C:  c8
            iny                         ; 06F1D:  c8
            iny                         ; 06F1E:  c8
b1_ef1f:    lda $0754                   ; 06F1F:  ad 54 07
            beq b1_ef2d                 ; 06F22:  f0 09
            lda $0219,y                 ; 06F24:  b9 19 02
            cmp tab_b1_ee97+30          ; 06F27:  cd b5 ee
            beq b1_ef33                 ; 06F2A:  f0 07
            inx                         ; 06F2C:  e8
b1_ef2d:    lda b1_eee7,x               ; 06F2D:  bd e7 ee
            sta $0219,y                 ; 06F30:  99 19 02
b1_ef33:    rts                         ; 06F33:  60

b1_ef34:    jsr b1_efec                 ; 06F34:  20 ec ef
            jmp b1_ef45                 ; 06F37:  4c 45 ef

b1_ef3a:    jsr tab_b1_f09c+20          ; 06F3A:  20 b0 f0
            jmp b1_ef45                 ; 06F3D:  4c 45 ef

b1_ef40:    ldy #$0e                    ; 06F40:  a0 0e
            lda tab_b1_ee07,y           ; 06F42:  b9 07 ee
b1_ef45:    sta $06d5                   ; 06F45:  8d d5 06
            lda #$04                    ; 06F48:  a9 04
            jsr b1_efbe                 ; 06F4A:  20 be ef
            jsr b1_f0e9                 ; 06F4D:  20 e9 f0
            lda $0711                   ; 06F50:  ad 11 07
            beq b1_ef7a                 ; 06F53:  f0 25
            ldy #$00                    ; 06F55:  a0 00
            lda $0781                   ; 06F57:  ad 81 07
            cmp $0711                   ; 06F5A:  cd 11 07
            sty $0711                   ; 06F5D:  8c 11 07
            bcs b1_ef7a                 ; 06F60:  b0 18
            sta $0711                   ; 06F62:  8d 11 07
            ldy #$07                    ; 06F65:  a0 07
            lda tab_b1_ee07,y           ; 06F67:  b9 07 ee
            sta $06d5                   ; 06F6A:  8d d5 06
            ldy #$04                    ; 06F6D:  a0 04
            lda $57                     ; 06F6F:  a5 57
            ora $0c                     ; 06F71:  05 0c
            beq b1_ef76                 ; 06F73:  f0 01
            dey                         ; 06F75:  88
b1_ef76:    tya                         ; 06F76:  98
            jsr b1_efbe                 ; 06F77:  20 be ef
b1_ef7a:    lda $03d0                   ; 06F7A:  ad d0 03
            lsr a                       ; 06F7D:  4a
            lsr a                       ; 06F7E:  4a
            lsr a                       ; 06F7F:  4a
            lsr a                       ; 06F80:  4a
            sta $00                     ; 06F81:  85 00
            ldx #$03                    ; 06F83:  a2 03
            lda $06e4                   ; 06F85:  ad e4 06
            clc                         ; 06F88:  18
            adc #$18                    ; 06F89:  69 18
            tay                         ; 06F8B:  a8
b1_ef8c:    lda #$f8                    ; 06F8C:  a9 f8
            lsr $00                     ; 06F8E:  46 00
            bcc b1_ef95                 ; 06F90:  90 03
            jsr b1_e5c1                 ; 06F92:  20 c1 e5
b1_ef95:    tya                         ; 06F95:  98
            sec                         ; 06F96:  38
            sbc #$08                    ; 06F97:  e9 08
            tay                         ; 06F99:  a8
            dex                         ; 06F9A:  ca
            bpl b1_ef8c                 ; 06F9B:  10 ef
            rts                         ; 06F9D:  60

b1_ef9e:    cli                         ; 06F9E:  58
            ora ($00,x)                 ; 06F9F:  01 00
            rts                         ; 06FA1:  60

            hex ff 04                   ; 06FA2:  ff 04

            ldx #$05                    ; 06FA4:  a2 05
b1_efa6:    lda b1_ef9e,x               ; 06FA6:  bd 9e ef
            sta $02,x                   ; 06FA9:  95 02
            dex                         ; 06FAB:  ca
            bpl b1_efa6                 ; 06FAC:  10 f8
            ldx #$b8                    ; 06FAE:  a2 b8
            ldy #$04                    ; 06FB0:  a0 04
            jsr b1_efdc                 ; 06FB2:  20 dc ef
            lda $0226                   ; 06FB5:  ad 26 02
            ora #$40                    ; 06FB8:  09 40
            sta $0222                   ; 06FBA:  8d 22 02
            rts                         ; 06FBD:  60

b1_efbe:    sta $07                     ; 06FBE:  85 07
            lda $03ad                   ; 06FC0:  ad ad 03
            sta $0755                   ; 06FC3:  8d 55 07
            sta $05                     ; 06FC6:  85 05
            lda $03b8                   ; 06FC8:  ad b8 03
            sta $02                     ; 06FCB:  85 02
            lda $33                     ; 06FCD:  a5 33
            sta $03                     ; 06FCF:  85 03
            lda $03c4                   ; 06FD1:  ad c4 03
            sta $04                     ; 06FD4:  85 04
            ldx $06d5                   ; 06FD6:  ae d5 06
            ldy $06e4                   ; 06FD9:  ac e4 06
b1_efdc:    lda tab_b1_ee14+3,x         ; 06FDC:  bd 17 ee
            sta $00                     ; 06FDF:  85 00
            lda tab_b1_ee14+4,x         ; 06FE1:  bd 18 ee
            jsr b1_ebb2                 ; 06FE4:  20 b2 eb
            dec $07                     ; 06FE7:  c6 07
            bne b1_efdc                 ; 06FE9:  d0 f1
            rts                         ; 06FEB:  60

b1_efec:    lda $1d                     ; 06FEC:  a5 1d
            cmp #$03                    ; 06FEE:  c9 03
            beq b1_f044                 ; 06FF0:  f0 52
            cmp #$02                    ; 06FF2:  c9 02
            beq b1_f034                 ; 06FF4:  f0 3e
            cmp #$01                    ; 06FF6:  c9 01
            bne b1_f00b                 ; 06FF8:  d0 11
            lda $0704                   ; 06FFA:  ad 04 07
            bne b1_f050                 ; 06FFD:  d0 51
            ldy #$06                    ; 06FFF:  a0 06
            lda $0714                   ; 07001:  ad 14 07
            bne b1_f028                 ; 07004:  d0 22
            ldy #$00                    ; 07006:  a0 00
            jmp b1_f028                 ; 07008:  4c 28 f0

b1_f00b:    ldy #$06                    ; 0700B:  a0 06
            lda $0714                   ; 0700D:  ad 14 07
            bne b1_f028                 ; 07010:  d0 16
            ldy #$02                    ; 07012:  a0 02
            lda $57                     ; 07014:  a5 57
            ora $0c                     ; 07016:  05 0c
            beq b1_f028                 ; 07018:  f0 0e
            lda $0700                   ; 0701A:  ad 00 07
            cmp #$09                    ; 0701D:  c9 09
            bcc b1_f03c                 ; 0701F:  90 1b
            lda $45                     ; 07021:  a5 45
            and $33                     ; 07023:  25 33
            bne b1_f03c                 ; 07025:  d0 15
            iny                         ; 07027:  c8
b1_f028:    jsr b1_f091                 ; 07028:  20 91 f0
            lda #$00                    ; 0702B:  a9 00
            sta $070d                   ; 0702D:  8d 0d 07
            lda tab_b1_ee07,y           ; 07030:  b9 07 ee
            rts                         ; 07033:  60

b1_f034:    ldy #$04                    ; 07034:  a0 04
            jsr b1_f091                 ; 07036:  20 91 f0
            jmp b1_f062                 ; 07039:  4c 62 f0

b1_f03c:    ldy #$04                    ; 0703C:  a0 04
            jsr b1_f091                 ; 0703E:  20 91 f0
            jmp b1_f068                 ; 07041:  4c 68 f0

b1_f044:    ldy #$05                    ; 07044:  a0 05
            lda $9f                     ; 07046:  a5 9f
            beq b1_f028                 ; 07048:  f0 de
            jsr b1_f091                 ; 0704A:  20 91 f0
            jmp b1_f06d                 ; 0704D:  4c 6d f0

b1_f050:    ldy #$01                    ; 07050:  a0 01
            jsr b1_f091                 ; 07052:  20 91 f0
            lda $0782                   ; 07055:  ad 82 07
            ora $070d                   ; 07058:  0d 0d 07
            bne b1_f068                 ; 0705B:  d0 0b
            lda $0a                     ; 0705D:  a5 0a
            asl a                       ; 0705F:  0a
            bcs b1_f068                 ; 07060:  b0 06
b1_f062:    lda $070d                   ; 07062:  ad 0d 07
            jmp b1_f0d0                 ; 07065:  4c d0 f0

b1_f068:    lda #$03                    ; 07068:  a9 03
            jmp b1_f06f                 ; 0706A:  4c 6f f0

b1_f06d:    lda #$02                    ; 0706D:  a9 02
b1_f06f:    sta $00                     ; 0706F:  85 00
            jsr b1_f062                 ; 07071:  20 62 f0
            pha                         ; 07074:  48
            lda $0781                   ; 07075:  ad 81 07
            bne b1_f08f                 ; 07078:  d0 15
            lda $070c                   ; 0707A:  ad 0c 07
            sta $0781                   ; 0707D:  8d 81 07
            lda $070d                   ; 07080:  ad 0d 07
            clc                         ; 07083:  18
            adc #$01                    ; 07084:  69 01
            cmp $00                     ; 07086:  c5 00
            bcc b1_f08c                 ; 07088:  90 02
            lda #$00                    ; 0708A:  a9 00
b1_f08c:    sta $070d                   ; 0708C:  8d 0d 07
b1_f08f:    pla                         ; 0708F:  68
            rts                         ; 07090:  60

b1_f091:    lda $0754                   ; 07091:  ad 54 07
            beq b1_f09b                 ; 07094:  f0 05
            tya                         ; 07096:  98
            clc                         ; 07097:  18
            adc #$08                    ; 07098:  69 08
            tay                         ; 0709A:  a8
b1_f09b:    rts                         ; 0709B:  60

tab_b1_f09c: ; 27 bytes
            hex 00 01 00 01 00 01 02 00 ; 0709C:  00 01 00 01 00 01 02 00
            hex 01 02 02 00 02 00 02 00 ; 070A4:  01 02 02 00 02 00 02 00
            hex 02 00 02 00 ac 0d 07 a5 ; 070AC:  02 00 02 00 ac 0d 07 a5
            hex 09 29 03                ; 070B4:  09 29 03

            bne b1_f0c6                 ; 070B7:  d0 0d
            iny                         ; 070B9:  c8
            cpy #$0a                    ; 070BA:  c0 0a
            bcc b1_f0c3                 ; 070BC:  90 05
            ldy #$00                    ; 070BE:  a0 00
            sty $070b                   ; 070C0:  8c 0b 07
b1_f0c3:    sty $070d                   ; 070C3:  8c 0d 07
b1_f0c6:    lda $0754                   ; 070C6:  ad 54 07
            bne b1_f0d7                 ; 070C9:  d0 0c
            lda tab_b1_f09c,y           ; 070CB:  b9 9c f0
            ldy #$0f                    ; 070CE:  a0 0f
b1_f0d0:    asl a                       ; 070D0:  0a
            asl a                       ; 070D1:  0a
            asl a                       ; 070D2:  0a
            adc tab_b1_ee07,y           ; 070D3:  79 07 ee
            rts                         ; 070D6:  60

b1_f0d7:    tya                         ; 070D7:  98
            clc                         ; 070D8:  18
            adc #$0a                    ; 070D9:  69 0a
            tax                         ; 070DB:  aa
            ldy #$09                    ; 070DC:  a0 09
            lda tab_b1_f09c,x           ; 070DE:  bd 9c f0
            bne b1_f0e5                 ; 070E1:  d0 02
            ldy #$01                    ; 070E3:  a0 01
b1_f0e5:    lda tab_b1_ee07,y           ; 070E5:  b9 07 ee
            rts                         ; 070E8:  60

b1_f0e9:    ldy $06e4                   ; 070E9:  ac e4 06
            lda $0e                     ; 070EC:  a5 0e
            cmp #$0b                    ; 070EE:  c9 0b
            beq b1_f105                 ; 070F0:  f0 13
            lda $06d5                   ; 070F2:  ad d5 06
            cmp #$50                    ; 070F5:  c9 50
            beq b1_f117                 ; 070F7:  f0 1e
            cmp #$b8                    ; 070F9:  c9 b8
            beq b1_f117                 ; 070FB:  f0 1a
            cmp #$c0                    ; 070FD:  c9 c0
            beq b1_f117                 ; 070FF:  f0 16
            cmp #$c8                    ; 07101:  c9 c8
            bne b1_f129                 ; 07103:  d0 24
b1_f105:    lda $0212,y                 ; 07105:  b9 12 02
            and #$3f                    ; 07108:  29 3f
            sta $0212,y                 ; 0710A:  99 12 02
            lda $0216,y                 ; 0710D:  b9 16 02
            and #$3f                    ; 07110:  29 3f
            ora #$40                    ; 07112:  09 40
            sta $0216,y                 ; 07114:  99 16 02
b1_f117:    lda $021a,y                 ; 07117:  b9 1a 02
            and #$3f                    ; 0711A:  29 3f
            sta $021a,y                 ; 0711C:  99 1a 02
            lda $021e,y                 ; 0711F:  b9 1e 02
            and #$3f                    ; 07122:  29 3f
            ora #$40                    ; 07124:  09 40
            sta $021e,y                 ; 07126:  99 1e 02
b1_f129:    rts                         ; 07129:  60

            ldx #$00                    ; 0712A:  a2 00
            ldy #$00                    ; 0712C:  a0 00
            jmp b1_f142                 ; 0712E:  4c 42 f1

            ldy #$01                    ; 07131:  a0 01
            jsr b1_f1a8                 ; 07133:  20 a8 f1
            ldy #$03                    ; 07136:  a0 03
            jmp b1_f142                 ; 07138:  4c 42 f1

            ldy #$00                    ; 0713B:  a0 00
            jsr b1_f1a8                 ; 0713D:  20 a8 f1
            ldy #$02                    ; 07140:  a0 02
b1_f142:    jsr b1_f171                 ; 07142:  20 71 f1
            ldx $08                     ; 07145:  a6 08
            rts                         ; 07147:  60

            ldy #$02                    ; 07148:  a0 02
            jsr b1_f1a8                 ; 0714A:  20 a8 f1
            ldy #$06                    ; 0714D:  a0 06
            jmp b1_f142                 ; 0714F:  4c 42 f1

b1_f152:    lda #$01                    ; 07152:  a9 01
            ldy #$01                    ; 07154:  a0 01
            jmp b1_f165                 ; 07156:  4c 65 f1

            lda #$09                    ; 07159:  a9 09
            ldy #$04                    ; 0715B:  a0 04
            jsr b1_f165                 ; 0715D:  20 65 f1
            inx                         ; 07160:  e8
            inx                         ; 07161:  e8
            lda #$09                    ; 07162:  a9 09
            iny                         ; 07164:  c8
b1_f165:    stx $00                     ; 07165:  86 00
            clc                         ; 07167:  18
            adc $00                     ; 07168:  65 00
            tax                         ; 0716A:  aa
            jsr b1_f171                 ; 0716B:  20 71 f1
            ldx $08                     ; 0716E:  a6 08
            rts                         ; 07170:  60

b1_f171:    lda $ce,x                   ; 07171:  b5 ce
            sta $03b8,y                 ; 07173:  99 b8 03
            lda $86,x                   ; 07176:  b5 86
            sec                         ; 07178:  38
            sbc $071c                   ; 07179:  ed 1c 07
            sta $03ad,y                 ; 0717C:  99 ad 03
            rts                         ; 0717F:  60

            ldx #$00                    ; 07180:  a2 00
            ldy #$00                    ; 07182:  a0 00
            jmp b1_f1c0                 ; 07184:  4c c0 f1

            ldy #$00                    ; 07187:  a0 00
            jsr b1_f1a8                 ; 07189:  20 a8 f1
            ldy #$02                    ; 0718C:  a0 02
            jmp b1_f1c0                 ; 0718E:  4c c0 f1

            ldy #$01                    ; 07191:  a0 01
            jsr b1_f1a8                 ; 07193:  20 a8 f1
            ldy #$03                    ; 07196:  a0 03
            jmp b1_f1c0                 ; 07198:  4c c0 f1

            ldy #$02                    ; 0719B:  a0 02
            jsr b1_f1a8                 ; 0719D:  20 a8 f1
            ldy #$06                    ; 071A0:  a0 06
            jmp b1_f1c0                 ; 071A2:  4c c0 f1

tab_b1_f1a5: ; 1 bytes
            hex 07                      ; 071A5:  07

            asl $0d,x                   ; 071A6:  16 0d
b1_f1a8:    txa                         ; 071A8:  8a
            clc                         ; 071A9:  18
            adc tab_b1_f1a5,y           ; 071AA:  79 a5 f1
            tax                         ; 071AD:  aa
            rts                         ; 071AE:  60

b1_f1af:    lda #$01                    ; 071AF:  a9 01
            ldy #$01                    ; 071B1:  a0 01
            jmp b1_f1ba                 ; 071B3:  4c ba f1

            lda #$09                    ; 071B6:  a9 09
            ldy #$04                    ; 071B8:  a0 04
b1_f1ba:    stx $00                     ; 071BA:  86 00
            clc                         ; 071BC:  18
            adc $00                     ; 071BD:  65 00
            tax                         ; 071BF:  aa
b1_f1c0:    tya                         ; 071C0:  98
            pha                         ; 071C1:  48
            jsr b1_f1d7                 ; 071C2:  20 d7 f1
            asl a                       ; 071C5:  0a
            asl a                       ; 071C6:  0a
            asl a                       ; 071C7:  0a
            asl a                       ; 071C8:  0a
            ora $00                     ; 071C9:  05 00
            sta $00                     ; 071CB:  85 00
            pla                         ; 071CD:  68
            tay                         ; 071CE:  a8
            lda $00                     ; 071CF:  a5 00
            sta $03d0,y                 ; 071D1:  99 d0 03
            ldx $08                     ; 071D4:  a6 08
            rts                         ; 071D6:  60

b1_f1d7:    jsr b1_f1f6                 ; 071D7:  20 f6 f1
            lsr a                       ; 071DA:  4a
            lsr a                       ; 071DB:  4a
            lsr a                       ; 071DC:  4a
            lsr a                       ; 071DD:  4a
            sta $00                     ; 071DE:  85 00
            jmp tab_b1_f22b+14          ; 071E0:  4c 39 f2

tab_b1_f1e3: ; 19 bytes
            hex 7f 3f 1f 0f 07 03 01 00 ; 071E3:  7f 3f 1f 0f 07 03 01 00
            hex 80 c0 e0 f0 f8 fc fe ff ; 071EB:  80 c0 e0 f0 f8 fc fe ff
            hex 07 0f 07                ; 071F3:  07 0f 07

b1_f1f6:    stx $04                     ; 071F6:  86 04
            ldy #$01                    ; 071F8:  a0 01
b1_f1fa:    lda $071c,y                 ; 071FA:  b9 1c 07
            sec                         ; 071FD:  38
            sbc $86,x                   ; 071FE:  f5 86
            sta $07                     ; 07200:  85 07
            lda $071a,y                 ; 07202:  b9 1a 07
            sbc $6d,x                   ; 07205:  f5 6d
            ldx tab_b1_f1e3+16,y        ; 07207:  be f3 f1
            cmp #$00                    ; 0720A:  c9 00
            bmi b1_f21e                 ; 0720C:  30 10
            ldx tab_b1_f1e3+17,y        ; 0720E:  be f4 f1
            cmp #$01                    ; 07211:  c9 01
            bpl b1_f21e                 ; 07213:  10 09
            lda #$38                    ; 07215:  a9 38
            sta $06                     ; 07217:  85 06
            lda #$08                    ; 07219:  a9 08
            jsr b1_f26d                 ; 0721B:  20 6d f2
b1_f21e:    lda tab_b1_f1e3,x           ; 0721E:  bd e3 f1
            ldx $04                     ; 07221:  a6 04
            cmp #$00                    ; 07223:  c9 00
            bne b1_f22a                 ; 07225:  d0 03
            dey                         ; 07227:  88
            bpl b1_f1fa                 ; 07228:  10 d0
b1_f22a:    rts                         ; 0722A:  60

tab_b1_f22b: ; 16 bytes
            hex 00 08 0c 0e 0f 07 03 01 ; 0722B:  00 08 0c 0e 0f 07 03 01
            hex 00 04 00 04 ff 00 86 04 ; 07233:  00 04 00 04 ff 00 86 04

            ldy #$01                    ; 0723B:  a0 01
b1_f23d:    lda tab_b1_f22b+12,y        ; 0723D:  b9 37 f2
            sec                         ; 07240:  38
            sbc $ce,x                   ; 07241:  f5 ce
            sta $07                     ; 07243:  85 07
            lda #$01                    ; 07245:  a9 01
            sbc $b5,x                   ; 07247:  f5 b5
            ldx tab_b1_f22b+9,y         ; 07249:  be 34 f2
            cmp #$00                    ; 0724C:  c9 00
            bmi b1_f260                 ; 0724E:  30 10
            ldx tab_b1_f22b+10,y        ; 07250:  be 35 f2
            cmp #$01                    ; 07253:  c9 01
            bpl b1_f260                 ; 07255:  10 09
            lda #$20                    ; 07257:  a9 20
            sta $06                     ; 07259:  85 06
            lda #$04                    ; 0725B:  a9 04
            jsr b1_f26d                 ; 0725D:  20 6d f2
b1_f260:    lda tab_b1_f22b,x           ; 07260:  bd 2b f2
            ldx $04                     ; 07263:  a6 04
            cmp #$00                    ; 07265:  c9 00
            bne b1_f26c                 ; 07267:  d0 03
            dey                         ; 07269:  88
            bpl b1_f23d                 ; 0726A:  10 d1
b1_f26c:    rts                         ; 0726C:  60

b1_f26d:    sta $05                     ; 0726D:  85 05
            lda $07                     ; 0726F:  a5 07
            cmp $06                     ; 07271:  c5 06
            bcs b1_f281                 ; 07273:  b0 0c
            lsr a                       ; 07275:  4a
            lsr a                       ; 07276:  4a
            lsr a                       ; 07277:  4a
            and #$07                    ; 07278:  29 07
            cpy #$01                    ; 0727A:  c0 01
            bcs b1_f280                 ; 0727C:  b0 02
            adc $05                     ; 0727E:  65 05
b1_f280:    tax                         ; 07280:  aa
b1_f281:    rts                         ; 07281:  60

b1_f282:    lda $03                     ; 07282:  a5 03
            lsr a                       ; 07284:  4a
            lsr a                       ; 07285:  4a
            lda $00                     ; 07286:  a5 00
            bcc b1_f296                 ; 07288:  90 0c
            sta $0205,y                 ; 0728A:  99 05 02
            lda $01                     ; 0728D:  a5 01
            sta $0201,y                 ; 0728F:  99 01 02
            lda #$40                    ; 07292:  a9 40
            bne b1_f2a0                 ; 07294:  d0 0a
b1_f296:    sta $0201,y                 ; 07296:  99 01 02
            lda $01                     ; 07299:  a5 01
            sta $0205,y                 ; 0729B:  99 05 02
            lda #$00                    ; 0729E:  a9 00
b1_f2a0:    ora $04                     ; 072A0:  05 04
            sta $0202,y                 ; 072A2:  99 02 02
            sta $0206,y                 ; 072A5:  99 06 02
            lda $02                     ; 072A8:  a5 02
            sta $0200,y                 ; 072AA:  99 00 02
            sta $0204,y                 ; 072AD:  99 04 02
            lda $05                     ; 072B0:  a5 05
            sta $0203,y                 ; 072B2:  99 03 02
            clc                         ; 072B5:  18
            adc #$08                    ; 072B6:  69 08
            sta $0207,y                 ; 072B8:  99 07 02
            lda $02                     ; 072BB:  a5 02
            clc                         ; 072BD:  18
            adc #$08                    ; 072BE:  69 08
            sta $02                     ; 072C0:  85 02
            tya                         ; 072C2:  98
            clc                         ; 072C3:  18
            adc #$08                    ; 072C4:  69 08
            tay                         ; 072C6:  a8
            inx                         ; 072C7:  e8
            inx                         ; 072C8:  e8
            rts                         ; 072C9:  60

            hex ff ff ff ff ff ff       ; 072CA:  ff ff ff ff ff ff

            lda $0770                   ; 072D0:  ad 70 07
            bne b1_f2d9                 ; 072D3:  d0 04
            sta SND_CHN                 ; 072D5:  8d 15 40
            rts                         ; 072D8:  60

b1_f2d9:    lda #$ff                    ; 072D9:  a9 ff
            sta JOY2                    ; 072DB:  8d 17 40
            lda #$0f                    ; 072DE:  a9 0f
            sta SND_CHN                 ; 072E0:  8d 15 40
            lda $07c6                   ; 072E3:  ad c6 07
            bne b1_f2ee                 ; 072E6:  d0 06
            lda $fa                     ; 072E8:  a5 fa
            cmp #$01                    ; 072EA:  c9 01
            bne b1_f34b                 ; 072EC:  d0 5d
b1_f2ee:    lda $07b2                   ; 072EE:  ad b2 07
            bne b1_f316                 ; 072F1:  d0 23
            lda $fa                     ; 072F3:  a5 fa
            beq b1_f35d                 ; 072F5:  f0 66
            sta $07b2                   ; 072F7:  8d b2 07
            sta $07c6                   ; 072FA:  8d c6 07
            lda #$00                    ; 072FD:  a9 00
            sta SND_CHN                 ; 072FF:  8d 15 40
            sta $f1                     ; 07302:  85 f1
            sta $f2                     ; 07304:  85 f2
            sta $f3                     ; 07306:  85 f3
            lda #$0f                    ; 07308:  a9 0f
            sta SND_CHN                 ; 0730A:  8d 15 40
            lda #$2a                    ; 0730D:  a9 2a
            sta $07bb                   ; 0730F:  8d bb 07
b1_f312:    lda #$44                    ; 07312:  a9 44
            bne b1_f327                 ; 07314:  d0 11
b1_f316:    lda $07bb                   ; 07316:  ad bb 07
            cmp #$24                    ; 07319:  c9 24
            beq b1_f325                 ; 0731B:  f0 08
            cmp #$1e                    ; 0731D:  c9 1e
            beq b1_f312                 ; 0731F:  f0 f1
            cmp #$18                    ; 07321:  c9 18
            bne b1_f32e                 ; 07323:  d0 09
b1_f325:    lda #$64                    ; 07325:  a9 64
b1_f327:    ldx #$84                    ; 07327:  a2 84
            ldy #$7f                    ; 07329:  a0 7f
            jsr b1_f388                 ; 0732B:  20 88 f3
b1_f32e:    dec $07bb                   ; 0732E:  ce bb 07
            bne b1_f35d                 ; 07331:  d0 2a
            lda #$00                    ; 07333:  a9 00
            sta SND_CHN                 ; 07335:  8d 15 40
            lda $07b2                   ; 07338:  ad b2 07
            cmp #$02                    ; 0733B:  c9 02
            bne b1_f344                 ; 0733D:  d0 05
            lda #$00                    ; 0733F:  a9 00
            sta $07c6                   ; 07341:  8d c6 07
b1_f344:    lda #$00                    ; 07344:  a9 00
            sta $07b2                   ; 07346:  8d b2 07
            beq b1_f35d                 ; 07349:  f0 12
b1_f34b:    jsr b1_f41b                 ; 0734B:  20 1b f4
            jsr b1_f57c                 ; 0734E:  20 7c f5
            jsr b1_f667                 ; 07351:  20 67 f6
            jsr b1_f694                 ; 07354:  20 94 f6
            lda #$00                    ; 07357:  a9 00
            sta $fb                     ; 07359:  85 fb
            sta $fc                     ; 0735B:  85 fc
b1_f35d:    lda #$00                    ; 0735D:  a9 00
            sta $ff                     ; 0735F:  85 ff
            sta $fe                     ; 07361:  85 fe
            sta $fd                     ; 07363:  85 fd
            sta $fa                     ; 07365:  85 fa
            ldy $07c0                   ; 07367:  ac c0 07
            lda $f4                     ; 0736A:  a5 f4
            and #$03                    ; 0736C:  29 03
            beq b1_f377                 ; 0736E:  f0 07
            inc $07c0                   ; 07370:  ee c0 07
            cpy #$30                    ; 07373:  c0 30
            bcc b1_f37d                 ; 07375:  90 06
b1_f377:    tya                         ; 07377:  98
            beq b1_f37d                 ; 07378:  f0 03
            dec $07c0                   ; 0737A:  ce c0 07
b1_f37d:    sty DMC_RAW                 ; 0737D:  8c 11 40
            rts                         ; 07380:  60

b1_f381:    sty SQ1_SWEEP               ; 07381:  8c 01 40
            stx SQ1_VOL                 ; 07384:  8e 00 40
            rts                         ; 07387:  60

b1_f388:    jsr b1_f381                 ; 07388:  20 81 f3
b1_f38b:    ldx #$00                    ; 0738B:  a2 00
            tay                         ; 0738D:  a8
            lda tab_b1_fd32+463,y       ; 0738E:  b9 01 ff
            beq b1_f39e                 ; 07391:  f0 0b
            sta SQ1_LO,x                ; 07393:  9d 02 40
            lda tab_b1_fd32+462,y       ; 07396:  b9 00 ff
            ora #$08                    ; 07399:  09 08
            sta SQ1_HI,x                ; 0739B:  9d 03 40
b1_f39e:    rts                         ; 0739E:  60

b1_f39f:    stx SQ2_VOL                 ; 0739F:  8e 04 40
            sty SQ2_SWEEP               ; 073A2:  8c 05 40
            rts                         ; 073A5:  60

tab_b1_f3a6: ; 25 bytes
            hex 20 9f f3 a2 04 d0 e0 a2 ; 073A6:  20 9f f3 a2 04 d0 e0 a2
            hex 08 d0 dc 9f 9b 98 96 95 ; 073AE:  08 d0 dc 9f 9b 98 96 95
            hex 94 92 90 90 9a 97 95 93 ; 073B6:  94 92 90 90 9a 97 95 93
            hex 92                      ; 073BE:  92

b1_f3bf:    lda #$40                    ; 073BF:  a9 40
            sta $07bb                   ; 073C1:  8d bb 07
            lda #$62                    ; 073C4:  a9 62
            jsr b1_f38b                 ; 073C6:  20 8b f3
            ldx #$99                    ; 073C9:  a2 99
            bne b1_f3f2                 ; 073CB:  d0 25
b1_f3cd:    lda #$26                    ; 073CD:  a9 26
            bne b1_f3d3                 ; 073CF:  d0 02
b1_f3d1:    lda #$18                    ; 073D1:  a9 18
b1_f3d3:    ldx #$82                    ; 073D3:  a2 82
            ldy #$a7                    ; 073D5:  a0 a7
            jsr b1_f388                 ; 073D7:  20 88 f3
            lda #$28                    ; 073DA:  a9 28
            sta $07bb                   ; 073DC:  8d bb 07
b1_f3df:    lda $07bb                   ; 073DF:  ad bb 07
            cmp #$25                    ; 073E2:  c9 25
            bne b1_f3ec                 ; 073E4:  d0 06
            ldx #$5f                    ; 073E6:  a2 5f
            ldy #$f6                    ; 073E8:  a0 f6
            bne b1_f3f4                 ; 073EA:  d0 08
b1_f3ec:    cmp #$20                    ; 073EC:  c9 20
            bne b1_f419                 ; 073EE:  d0 29
            ldx #$48                    ; 073F0:  a2 48
b1_f3f2:    ldy #$bc                    ; 073F2:  a0 bc
b1_f3f4:    jsr b1_f381                 ; 073F4:  20 81 f3
            bne b1_f419                 ; 073F7:  d0 20
b1_f3f9:    lda #$05                    ; 073F9:  a9 05
            ldy #$99                    ; 073FB:  a0 99
            bne b1_f403                 ; 073FD:  d0 04
b1_f3ff:    lda #$0a                    ; 073FF:  a9 0a
            ldy #$93                    ; 07401:  a0 93
b1_f403:    ldx #$9e                    ; 07403:  a2 9e
            sta $07bb                   ; 07405:  8d bb 07
            lda #$0c                    ; 07408:  a9 0c
            jsr b1_f388                 ; 0740A:  20 88 f3
b1_f40d:    lda $07bb                   ; 0740D:  ad bb 07
            cmp #$06                    ; 07410:  c9 06
            bne b1_f419                 ; 07412:  d0 05
            lda #$bb                    ; 07414:  a9 bb
            sta SQ1_SWEEP               ; 07416:  8d 01 40
b1_f419:    bne b1_f47b                 ; 07419:  d0 60
b1_f41b:    ldy $ff                     ; 0741B:  a4 ff
            beq b1_f43f                 ; 0741D:  f0 20
            sty $f1                     ; 0741F:  84 f1
            bmi b1_f3cd                 ; 07421:  30 aa
            lsr $ff                     ; 07423:  46 ff
            bcs b1_f3d1                 ; 07425:  b0 aa
            lsr $ff                     ; 07427:  46 ff
            bcs b1_f3ff                 ; 07429:  b0 d4
            lsr $ff                     ; 0742B:  46 ff
            bcs b1_f45b                 ; 0742D:  b0 2c
            lsr $ff                     ; 0742F:  46 ff
            bcs b1_f47d                 ; 07431:  b0 4a
            lsr $ff                     ; 07433:  46 ff
            bcs b1_f4b6                 ; 07435:  b0 7f
            lsr $ff                     ; 07437:  46 ff
            bcs b1_f3f9                 ; 07439:  b0 be
            lsr $ff                     ; 0743B:  46 ff
            bcs b1_f3bf                 ; 0743D:  b0 80
b1_f43f:    lda $f1                     ; 0743F:  a5 f1
            beq b1_f45a                 ; 07441:  f0 17
            bmi b1_f3df                 ; 07443:  30 9a
            lsr a                       ; 07445:  4a
            bcs b1_f3df                 ; 07446:  b0 97
            lsr a                       ; 07448:  4a
            bcs b1_f40d                 ; 07449:  b0 c2
            lsr a                       ; 0744B:  4a
            bcs b1_f469                 ; 0744C:  b0 1b
            lsr a                       ; 0744E:  4a
            bcs b1_f48d                 ; 0744F:  b0 3c
            lsr a                       ; 07451:  4a
            bcs b1_f4bb                 ; 07452:  b0 67
            lsr a                       ; 07454:  4a
            bcs b1_f40d                 ; 07455:  b0 b6
            lsr a                       ; 07457:  4a
            bcs b1_f4a2                 ; 07458:  b0 48
b1_f45a:    rts                         ; 0745A:  60

b1_f45b:    lda #$0e                    ; 0745B:  a9 0e
            sta $07bb                   ; 0745D:  8d bb 07
            ldy #$9c                    ; 07460:  a0 9c
            ldx #$9e                    ; 07462:  a2 9e
            lda #$26                    ; 07464:  a9 26
            jsr b1_f388                 ; 07466:  20 88 f3
b1_f469:    ldy $07bb                   ; 07469:  ac bb 07
            lda tab_b1_f3a6+10,y        ; 0746C:  b9 b0 f3
            sta SQ1_VOL                 ; 0746F:  8d 00 40
            cpy #$06                    ; 07472:  c0 06
            bne b1_f47b                 ; 07474:  d0 05
            lda #$9e                    ; 07476:  a9 9e
            sta SQ1_LO                  ; 07478:  8d 02 40
b1_f47b:    bne b1_f4a2                 ; 0747B:  d0 25
b1_f47d:    lda #$0e                    ; 0747D:  a9 0e
            ldy #$cb                    ; 0747F:  a0 cb
            ldx #$9f                    ; 07481:  a2 9f
            sta $07bb                   ; 07483:  8d bb 07
            lda #$28                    ; 07486:  a9 28
            jsr b1_f388                 ; 07488:  20 88 f3
            bne b1_f4a2                 ; 0748B:  d0 15
b1_f48d:    ldy $07bb                   ; 0748D:  ac bb 07
            cpy #$08                    ; 07490:  c0 08
            bne b1_f49d                 ; 07492:  d0 09
            lda #$a0                    ; 07494:  a9 a0
            sta SQ1_LO                  ; 07496:  8d 02 40
            lda #$9f                    ; 07499:  a9 9f
            bne b1_f49f                 ; 0749B:  d0 02
b1_f49d:    lda #$90                    ; 0749D:  a9 90
b1_f49f:    sta SQ1_VOL                 ; 0749F:  8d 00 40
b1_f4a2:    dec $07bb                   ; 074A2:  ce bb 07
            bne b1_f4b5                 ; 074A5:  d0 0e
b1_f4a7:    ldx #$00                    ; 074A7:  a2 00
            stx $f1                     ; 074A9:  86 f1
            ldx #$0e                    ; 074AB:  a2 0e
            stx SND_CHN                 ; 074AD:  8e 15 40
            ldx #$0f                    ; 074B0:  a2 0f
            stx SND_CHN                 ; 074B2:  8e 15 40
b1_f4b5:    rts                         ; 074B5:  60

b1_f4b6:    lda #$2f                    ; 074B6:  a9 2f
            sta $07bb                   ; 074B8:  8d bb 07
b1_f4bb:    lda $07bb                   ; 074BB:  ad bb 07
            lsr a                       ; 074BE:  4a
            bcs b1_f4d1                 ; 074BF:  b0 10
            lsr a                       ; 074C1:  4a
            bcs b1_f4d1                 ; 074C2:  b0 0d
            and #$02                    ; 074C4:  29 02
            beq b1_f4d1                 ; 074C6:  f0 09
            ldy #$91                    ; 074C8:  a0 91
            ldx #$9a                    ; 074CA:  a2 9a
            lda #$44                    ; 074CC:  a9 44
            jsr b1_f388                 ; 074CE:  20 88 f3
b1_f4d1:    jmp b1_f4a2                 ; 074D1:  4c a2 f4

tab_b1_f4d4: ; 66 bytes
            hex 58 02 54 56 4e 44 4c 52 ; 074D4:  58 02 54 56 4e 44 4c 52
            hex 4c 48 3e 36 3e 36 30 28 ; 074DC:  4c 48 3e 36 3e 36 30 28
            hex 4a 50 4a 64 3c 32 3c 32 ; 074E4:  4a 50 4a 64 3c 32 3c 32
            hex 2c 24 3a 64 3a 34 2c 22 ; 074EC:  2c 24 3a 64 3a 34 2c 22
            hex 2c 22 1c 14 14 04 22 24 ; 074F4:  2c 22 1c 14 14 04 22 24
            hex 16 04 24 26 18 04 26 28 ; 074FC:  16 04 24 26 18 04 26 28
            hex 1a 04 28 2a 1c 04 2a 2c ; 07504:  1a 04 28 2a 1c 04 2a 2c
            hex 1e 04 2c 2e 20 04 2e 30 ; 0750C:  1e 04 2c 2e 20 04 2e 30
            hex 22 04                   ; 07514:  22 04

            bmi b1_f54a                 ; 07516:  30 32
b1_f518:    lda #$35                    ; 07518:  a9 35
            ldx #$8d                    ; 0751A:  a2 8d
            bne b1_f522                 ; 0751C:  d0 04
b1_f51e:    lda #$06                    ; 0751E:  a9 06
            ldx #$98                    ; 07520:  a2 98
b1_f522:    sta $07bd                   ; 07522:  8d bd 07
            ldy #$7f                    ; 07525:  a0 7f
            lda #$42                    ; 07527:  a9 42
            jsr tab_b1_f3a6             ; 07529:  20 a6 f3
            lda $07bd                   ; 0752C:  ad bd 07
            cmp #$30                    ; 0752F:  c9 30
            bne b1_f538                 ; 07531:  d0 05
            lda #$54                    ; 07533:  a9 54
            sta SQ2_LO                  ; 07535:  8d 06 40
b1_f538:    bne b1_f568                 ; 07538:  d0 2e
b1_f53a:    lda #$20                    ; 0753A:  a9 20
            sta $07bd                   ; 0753C:  8d bd 07
            ldy #$94                    ; 0753F:  a0 94
            lda #$5e                    ; 07541:  a9 5e
            bne b1_f550                 ; 07543:  d0 0b
b1_f545:    lda $07bd                   ; 07545:  ad bd 07
            cmp #$18                    ; 07548:  c9 18
b1_f54a:    bne b1_f568                 ; 0754A:  d0 1c
            ldy #$93                    ; 0754C:  a0 93
            lda #$18                    ; 0754E:  a9 18
b1_f550:    bne b1_f5d1                 ; 07550:  d0 7f
b1_f552:    lda #$36                    ; 07552:  a9 36
            sta $07bd                   ; 07554:  8d bd 07
b1_f557:    lda $07bd                   ; 07557:  ad bd 07
            lsr a                       ; 0755A:  4a
            bcs b1_f568                 ; 0755B:  b0 0b
            tay                         ; 0755D:  a8
            lda tab_b1_f4d4+5,y         ; 0755E:  b9 d9 f4
            ldx #$5d                    ; 07561:  a2 5d
            ldy #$7f                    ; 07563:  a0 7f
b1_f565:    jsr tab_b1_f3a6             ; 07565:  20 a6 f3
b1_f568:    dec $07bd                   ; 07568:  ce bd 07
            bne b1_f57b                 ; 0756B:  d0 0e
            ldx #$00                    ; 0756D:  a2 00
            stx $f2                     ; 0756F:  86 f2
b1_f571:    ldx #$0d                    ; 07571:  a2 0d
            stx SND_CHN                 ; 07573:  8e 15 40
            ldx #$0f                    ; 07576:  a2 0f
            stx SND_CHN                 ; 07578:  8e 15 40
b1_f57b:    rts                         ; 0757B:  60

b1_f57c:    lda $f2                     ; 0757C:  a5 f2
            and #$40                    ; 0757E:  29 40
            bne b1_f5e7                 ; 07580:  d0 65
            ldy $fe                     ; 07582:  a4 fe
            beq b1_f5a6                 ; 07584:  f0 20
            sty $f2                     ; 07586:  84 f2
            bmi b1_f5c8                 ; 07588:  30 3e
            lsr $fe                     ; 0758A:  46 fe
            bcs b1_f518                 ; 0758C:  b0 8a
            lsr $fe                     ; 0758E:  46 fe
            bcs b1_f5fc                 ; 07590:  b0 6a
            lsr $fe                     ; 07592:  46 fe
            bcs b1_f600                 ; 07594:  b0 6a
            lsr $fe                     ; 07596:  46 fe
            bcs b1_f53a                 ; 07598:  b0 a0
            lsr $fe                     ; 0759A:  46 fe
            bcs b1_f51e                 ; 0759C:  b0 80
            lsr $fe                     ; 0759E:  46 fe
            bcs b1_f552                 ; 075A0:  b0 b0
            lsr $fe                     ; 075A2:  46 fe
            bcs b1_f5e2                 ; 075A4:  b0 3c
b1_f5a6:    lda $f2                     ; 075A6:  a5 f2
            beq b1_f5c1                 ; 075A8:  f0 17
            bmi b1_f5d3                 ; 075AA:  30 27
            lsr a                       ; 075AC:  4a
            bcs tab_b1_f5c2             ; 075AD:  b0 13
            lsr a                       ; 075AF:  4a
            bcs b1_f60f                 ; 075B0:  b0 5d
            lsr a                       ; 075B2:  4a
            bcs b1_f60f                 ; 075B3:  b0 5a
            lsr a                       ; 075B5:  4a
            bcs b1_f545                 ; 075B6:  b0 8d
            lsr a                       ; 075B8:  4a
            bcs tab_b1_f5c2             ; 075B9:  b0 07
            lsr a                       ; 075BB:  4a
            bcs b1_f557                 ; 075BC:  b0 99
            lsr a                       ; 075BE:  4a
            bcs b1_f5e7                 ; 075BF:  b0 26
b1_f5c1:    rts                         ; 075C1:  60

tab_b1_f5c2: ; 6 bytes
            hex 4c 2c f5 4c 68 f5       ; 075C2:  4c 2c f5 4c 68 f5

b1_f5c8:    lda #$38                    ; 075C8:  a9 38
            sta $07bd                   ; 075CA:  8d bd 07
            ldy #$c4                    ; 075CD:  a0 c4
            lda #$18                    ; 075CF:  a9 18
b1_f5d1:    bne b1_f5de                 ; 075D1:  d0 0b
b1_f5d3:    lda $07bd                   ; 075D3:  ad bd 07
            cmp #$08                    ; 075D6:  c9 08
            bne b1_f568                 ; 075D8:  d0 8e
            ldy #$a4                    ; 075DA:  a0 a4
            lda #$5a                    ; 075DC:  a9 5a
b1_f5de:    ldx #$9f                    ; 075DE:  a2 9f
b1_f5e0:    bne b1_f565                 ; 075E0:  d0 83
b1_f5e2:    lda #$30                    ; 075E2:  a9 30
            sta $07bd                   ; 075E4:  8d bd 07
b1_f5e7:    lda $07bd                   ; 075E7:  ad bd 07
            ldx #$03                    ; 075EA:  a2 03
b1_f5ec:    lsr a                       ; 075EC:  4a
            bcs tab_b1_f5c2+3           ; 075ED:  b0 d6
            dex                         ; 075EF:  ca
            bne b1_f5ec                 ; 075F0:  d0 fa
            tay                         ; 075F2:  a8
            lda b1_f4d1+2,y             ; 075F3:  b9 d3 f4
            ldx #$82                    ; 075F6:  a2 82
            ldy #$7f                    ; 075F8:  a0 7f
            bne b1_f5e0                 ; 075FA:  d0 e4
b1_f5fc:    lda #$10                    ; 075FC:  a9 10
            bne b1_f602                 ; 075FE:  d0 02
b1_f600:    lda #$20                    ; 07600:  a9 20
b1_f602:    sta $07bd                   ; 07602:  8d bd 07
            lda #$7f                    ; 07605:  a9 7f
            sta SQ2_SWEEP               ; 07607:  8d 05 40
            lda #$00                    ; 0760A:  a9 00
            sta $07be                   ; 0760C:  8d be 07
b1_f60f:    inc $07be                   ; 0760F:  ee be 07
            lda $07be                   ; 07612:  ad be 07
            lsr a                       ; 07615:  4a
            tay                         ; 07616:  a8
            cpy $07bd                   ; 07617:  cc bd 07
            beq tab_b1_f628             ; 0761A:  f0 0c
            lda #$9d                    ; 0761C:  a9 9d
            sta SQ2_VOL                 ; 0761E:  8d 04 40
            lda tab_b1_f4d4+36,y        ; 07621:  b9 f8 f4
            jsr tab_b1_f3a6+3           ; 07624:  20 a9 f3
            rts                         ; 07627:  60

tab_b1_f628: ; 11 bytes
            hex 4c 6d f5 01 0e 0e 0d 0b ; 07628:  4c 6d f5 01 0e 0e 0d 0b
            hex 06 0c 0f                ; 07630:  06 0c 0f

            asl a                       ; 07633:  0a
            ora #$03                    ; 07634:  09 03
            ora $0d08                   ; 07636:  0d 08 0d
            asl $0c                     ; 07639:  06 0c
b1_f63b:    lda #$20                    ; 0763B:  a9 20
            sta $07bf                   ; 0763D:  8d bf 07
b1_f640:    lda $07bf                   ; 07640:  ad bf 07
            lsr a                       ; 07643:  4a
            bcc b1_f658                 ; 07644:  90 12
            tay                         ; 07646:  a8
            ldx tab_b1_f628+3,y         ; 07647:  be 2b f6
            lda tab_b1_ff73+119,y       ; 0764A:  b9 ea ff
b1_f64d:    sta NOISE_VOL               ; 0764D:  8d 0c 40
            stx NOISE_PER               ; 07650:  8e 0e 40
            lda #$18                    ; 07653:  a9 18
            sta NOISE_LEN               ; 07655:  8d 0f 40
b1_f658:    dec $07bf                   ; 07658:  ce bf 07
            bne b1_f666                 ; 0765B:  d0 09
            lda #$f0                    ; 0765D:  a9 f0
            sta NOISE_VOL               ; 0765F:  8d 0c 40
            lda #$00                    ; 07662:  a9 00
            sta $f3                     ; 07664:  85 f3
b1_f666:    rts                         ; 07666:  60

b1_f667:    ldy $fd                     ; 07667:  a4 fd
            beq b1_f675                 ; 07669:  f0 0a
            sty $f3                     ; 0766B:  84 f3
            lsr $fd                     ; 0766D:  46 fd
            bcs b1_f63b                 ; 0766F:  b0 ca
            lsr $fd                     ; 07671:  46 fd
            bcs b1_f680                 ; 07673:  b0 0b
b1_f675:    lda $f3                     ; 07675:  a5 f3
            beq b1_f67f                 ; 07677:  f0 06
            lsr a                       ; 07679:  4a
            bcs b1_f640                 ; 0767A:  b0 c4
            lsr a                       ; 0767C:  4a
            bcs b1_f685                 ; 0767D:  b0 06
b1_f67f:    rts                         ; 0767F:  60

b1_f680:    lda #$40                    ; 07680:  a9 40
            sta $07bf                   ; 07682:  8d bf 07
b1_f685:    lda $07bf                   ; 07685:  ad bf 07
            lsr a                       ; 07688:  4a
            tay                         ; 07689:  a8
            ldx #$0f                    ; 0768A:  a2 0f
            lda tab_b1_ff73+86,y        ; 0768C:  b9 c9 ff
            bne b1_f64d                 ; 0768F:  d0 bc
b1_f691:    jmp b1_f73a                 ; 07691:  4c 3a f7

b1_f694:    lda $fc                     ; 07694:  a5 fc
            bne b1_f6a4                 ; 07696:  d0 0c
            lda $fb                     ; 07698:  a5 fb
            bne b1_f6c8                 ; 0769A:  d0 2c
            lda $07b1                   ; 0769C:  ad b1 07
            ora $f4                     ; 0769F:  05 f4
            bne b1_f691                 ; 076A1:  d0 ee
            rts                         ; 076A3:  60

b1_f6a4:    sta $07b1                   ; 076A4:  8d b1 07
            cmp #$01                    ; 076A7:  c9 01
            bne b1_f6b1                 ; 076A9:  d0 06
            jsr b1_f4a7                 ; 076AB:  20 a7 f4
            jsr b1_f571                 ; 076AE:  20 71 f5
b1_f6b1:    ldx $f4                     ; 076B1:  a6 f4
            stx $07c5                   ; 076B3:  8e c5 07
            ldy #$00                    ; 076B6:  a0 00
            sty $07c4                   ; 076B8:  8c c4 07
            sty $f4                     ; 076BB:  84 f4
            cmp #$40                    ; 076BD:  c9 40
            bne b1_f6f1                 ; 076BF:  d0 30
            ldx #$08                    ; 076C1:  a2 08
            stx $07c4                   ; 076C3:  8e c4 07
            bne b1_f6f1                 ; 076C6:  d0 29
b1_f6c8:    cmp #$04                    ; 076C8:  c9 04
            bne b1_f6cf                 ; 076CA:  d0 03
            jsr b1_f4a7                 ; 076CC:  20 a7 f4
b1_f6cf:    ldy #$10                    ; 076CF:  a0 10
b1_f6d1:    sty $07c7                   ; 076D1:  8c c7 07
            ldy #$00                    ; 076D4:  a0 00
            sty $07b1                   ; 076D6:  8c b1 07
            sta $f4                     ; 076D9:  85 f4
            cmp #$01                    ; 076DB:  c9 01
            bne b1_f6ed                 ; 076DD:  d0 0e
            inc $07c7                   ; 076DF:  ee c7 07
            ldy $07c7                   ; 076E2:  ac c7 07
            cpy #$32                    ; 076E5:  c0 32
            bne b1_f6f5                 ; 076E7:  d0 0c
            ldy #$11                    ; 076E9:  a0 11
            bne b1_f6d1                 ; 076EB:  d0 e4
b1_f6ed:    ldy #$08                    ; 076ED:  a0 08
            sty $f7                     ; 076EF:  84 f7
b1_f6f1:    iny                         ; 076F1:  c8
            lsr a                       ; 076F2:  4a
            bcc b1_f6f1                 ; 076F3:  90 fc
b1_f6f5:    lda b1_f90c,y               ; 076F5:  b9 0c f9
            tay                         ; 076F8:  a8
            lda tab_b1_f90d,y           ; 076F9:  b9 0d f9
            sta $f0                     ; 076FC:  85 f0
            lda tab_b1_f90d+1,y         ; 076FE:  b9 0e f9
            sta $f5                     ; 07701:  85 f5
            lda tab_b1_f90d+2,y         ; 07703:  b9 0f f9
            sta $f6                     ; 07706:  85 f6
            lda tab_b1_f90d+3,y         ; 07708:  b9 10 f9
            sta $f9                     ; 0770B:  85 f9
            lda tab_b1_f90d+4,y         ; 0770D:  b9 11 f9
            sta $f8                     ; 07710:  85 f8
            lda tab_b1_f90d+5,y         ; 07712:  b9 12 f9
            sta $07b0                   ; 07715:  8d b0 07
            sta $07c1                   ; 07718:  8d c1 07
            lda #$01                    ; 0771B:  a9 01
            sta $07b4                   ; 0771D:  8d b4 07
            sta $07b6                   ; 07720:  8d b6 07
            sta $07b9                   ; 07723:  8d b9 07
            sta $07ba                   ; 07726:  8d ba 07
            lda #$00                    ; 07729:  a9 00
            sta $f7                     ; 0772B:  85 f7
            sta $07ca                   ; 0772D:  8d ca 07
            lda #$0b                    ; 07730:  a9 0b
            sta SND_CHN                 ; 07732:  8d 15 40
            lda #$0f                    ; 07735:  a9 0f
            sta SND_CHN                 ; 07737:  8d 15 40
b1_f73a:    dec $07b4                   ; 0773A:  ce b4 07
            bne b1_f79e                 ; 0773D:  d0 5f
            ldy $f7                     ; 0773F:  a4 f7
            inc $f7                     ; 07741:  e6 f7
            lda ($f5),y                 ; 07743:  b1 f5
            beq b1_f74b                 ; 07745:  f0 04
            bpl b1_f786                 ; 07747:  10 3d
            bne b1_f77a                 ; 07749:  d0 2f
b1_f74b:    lda $07b1                   ; 0774B:  ad b1 07
            cmp #$40                    ; 0774E:  c9 40
            bne b1_f757                 ; 07750:  d0 05
            lda $07c5                   ; 07752:  ad c5 07
            bne tab_b1_f774             ; 07755:  d0 1d
b1_f757:    and #$04                    ; 07757:  29 04
            bne tab_b1_f774+3           ; 07759:  d0 1c
            lda $f4                     ; 0775B:  a5 f4
            and #$5f                    ; 0775D:  29 5f
            bne tab_b1_f774             ; 0775F:  d0 13
            lda #$00                    ; 07761:  a9 00
            sta $f4                     ; 07763:  85 f4
            sta $07b1                   ; 07765:  8d b1 07
            sta TRI_LINEAR              ; 07768:  8d 08 40
            lda #$90                    ; 0776B:  a9 90
            sta SQ1_VOL                 ; 0776D:  8d 00 40
            sta SQ2_VOL                 ; 07770:  8d 04 40
            rts                         ; 07773:  60

tab_b1_f774: ; 6 bytes
            hex 4c d4 f6 4c a4 f6       ; 07774:  4c d4 f6 4c a4 f6

b1_f77a:    jsr b1_f8cb                 ; 0777A:  20 cb f8
            sta $07b3                   ; 0777D:  8d b3 07
            ldy $f7                     ; 07780:  a4 f7
            inc $f7                     ; 07782:  e6 f7
            lda ($f5),y                 ; 07784:  b1 f5
b1_f786:    ldx $f2                     ; 07786:  a6 f2
            bne b1_f798                 ; 07788:  d0 0e
            jsr tab_b1_f3a6+3           ; 0778A:  20 a9 f3
            beq b1_f792                 ; 0778D:  f0 03
            jsr b1_f8d8                 ; 0778F:  20 d8 f8
b1_f792:    sta $07b5                   ; 07792:  8d b5 07
            jsr b1_f39f                 ; 07795:  20 9f f3
b1_f798:    lda $07b3                   ; 07798:  ad b3 07
            sta $07b4                   ; 0779B:  8d b4 07
b1_f79e:    lda $f2                     ; 0779E:  a5 f2
            bne b1_f7bc                 ; 077A0:  d0 1a
            lda $07b1                   ; 077A2:  ad b1 07
            and #$91                    ; 077A5:  29 91
            bne b1_f7bc                 ; 077A7:  d0 13
            ldy $07b5                   ; 077A9:  ac b5 07
            beq b1_f7b1                 ; 077AC:  f0 03
            dec $07b5                   ; 077AE:  ce b5 07
b1_f7b1:    jsr b1_f8f4                 ; 077B1:  20 f4 f8
            sta SQ2_VOL                 ; 077B4:  8d 04 40
            ldx #$7f                    ; 077B7:  a2 7f
            stx SQ2_SWEEP               ; 077B9:  8e 05 40
b1_f7bc:    ldy $f8                     ; 077BC:  a4 f8
            beq b1_f81a                 ; 077BE:  f0 5a
            dec $07b6                   ; 077C0:  ce b6 07
            bne b1_f7f7                 ; 077C3:  d0 32
b1_f7c5:    ldy $f8                     ; 077C5:  a4 f8
            inc $f8                     ; 077C7:  e6 f8
            lda ($f5),y                 ; 077C9:  b1 f5
            bne b1_f7dc                 ; 077CB:  d0 0f
            lda #$83                    ; 077CD:  a9 83
            sta SQ1_VOL                 ; 077CF:  8d 00 40
            lda #$94                    ; 077D2:  a9 94
            sta SQ1_SWEEP               ; 077D4:  8d 01 40
            sta $07ca                   ; 077D7:  8d ca 07
            bne b1_f7c5                 ; 077DA:  d0 e9
b1_f7dc:    jsr b1_f8c5                 ; 077DC:  20 c5 f8
            sta $07b6                   ; 077DF:  8d b6 07
            ldy $f1                     ; 077E2:  a4 f1
            bne b1_f81a                 ; 077E4:  d0 34
            txa                         ; 077E6:  8a
            and #$3e                    ; 077E7:  29 3e
            jsr b1_f38b                 ; 077E9:  20 8b f3
            beq b1_f7f1                 ; 077EC:  f0 03
            jsr b1_f8d8                 ; 077EE:  20 d8 f8
b1_f7f1:    sta $07b7                   ; 077F1:  8d b7 07
            jsr b1_f381                 ; 077F4:  20 81 f3
b1_f7f7:    lda $f1                     ; 077F7:  a5 f1
            bne b1_f81a                 ; 077F9:  d0 1f
            lda $07b1                   ; 077FB:  ad b1 07
            and #$91                    ; 077FE:  29 91
            bne b1_f810                 ; 07800:  d0 0e
            ldy $07b7                   ; 07802:  ac b7 07
            beq b1_f80a                 ; 07805:  f0 03
            dec $07b7                   ; 07807:  ce b7 07
b1_f80a:    jsr b1_f8f4                 ; 0780A:  20 f4 f8
            sta SQ1_VOL                 ; 0780D:  8d 00 40
b1_f810:    lda $07ca                   ; 07810:  ad ca 07
            bne b1_f817                 ; 07813:  d0 02
            lda #$7f                    ; 07815:  a9 7f
b1_f817:    sta SQ1_SWEEP               ; 07817:  8d 01 40
b1_f81a:    lda $f9                     ; 0781A:  a5 f9
            dec $07b9                   ; 0781C:  ce b9 07
            bne b1_f86d                 ; 0781F:  d0 4c
            ldy $f9                     ; 07821:  a4 f9
            inc $f9                     ; 07823:  e6 f9
            lda ($f5),y                 ; 07825:  b1 f5
            beq b1_f86a                 ; 07827:  f0 41
            bpl b1_f83e                 ; 07829:  10 13
            jsr b1_f8cb                 ; 0782B:  20 cb f8
            sta $07b8                   ; 0782E:  8d b8 07
            lda #$1f                    ; 07831:  a9 1f
            sta TRI_LINEAR              ; 07833:  8d 08 40
            ldy $f9                     ; 07836:  a4 f9
            inc $f9                     ; 07838:  e6 f9
            lda ($f5),y                 ; 0783A:  b1 f5
            beq b1_f86a                 ; 0783C:  f0 2c
b1_f83e:    jsr tab_b1_f3a6+7           ; 0783E:  20 ad f3
            ldx $07b8                   ; 07841:  ae b8 07
            stx $07b9                   ; 07844:  8e b9 07
            lda $07b1                   ; 07847:  ad b1 07
            and #$6e                    ; 0784A:  29 6e
            bne b1_f854                 ; 0784C:  d0 06
            lda $f4                     ; 0784E:  a5 f4
            and #$0a                    ; 07850:  29 0a
            beq b1_f86d                 ; 07852:  f0 19
b1_f854:    txa                         ; 07854:  8a
            cmp #$12                    ; 07855:  c9 12
            bcs b1_f868                 ; 07857:  b0 0f
            lda $07b1                   ; 07859:  ad b1 07
            and #$08                    ; 0785C:  29 08
            beq b1_f864                 ; 0785E:  f0 04
            lda #$0f                    ; 07860:  a9 0f
            bne b1_f86a                 ; 07862:  d0 06
b1_f864:    lda #$1f                    ; 07864:  a9 1f
            bne b1_f86a                 ; 07866:  d0 02
b1_f868:    lda #$ff                    ; 07868:  a9 ff
b1_f86a:    sta TRI_LINEAR              ; 0786A:  8d 08 40
b1_f86d:    lda $f4                     ; 0786D:  a5 f4
            and #$f3                    ; 0786F:  29 f3
            beq b1_f8c4                 ; 07871:  f0 51
            dec $07ba                   ; 07873:  ce ba 07
            bne b1_f8c4                 ; 07876:  d0 4c
b1_f878:    ldy $07b0                   ; 07878:  ac b0 07
            inc $07b0                   ; 0787B:  ee b0 07
            lda ($f5),y                 ; 0787E:  b1 f5
            bne b1_f88a                 ; 07880:  d0 08
            lda $07c1                   ; 07882:  ad c1 07
            sta $07b0                   ; 07885:  8d b0 07
            bne b1_f878                 ; 07888:  d0 ee
b1_f88a:    jsr b1_f8c5                 ; 0788A:  20 c5 f8
            sta $07ba                   ; 0788D:  8d ba 07
            txa                         ; 07890:  8a
            and #$3e                    ; 07891:  29 3e
            beq b1_f8b9                 ; 07893:  f0 24
            cmp #$30                    ; 07895:  c9 30
            beq b1_f8b1                 ; 07897:  f0 18
            cmp #$20                    ; 07899:  c9 20
            beq b1_f8a9                 ; 0789B:  f0 0c
            and #$10                    ; 0789D:  29 10
            beq b1_f8b9                 ; 0789F:  f0 18
            lda #$1c                    ; 078A1:  a9 1c
            ldx #$03                    ; 078A3:  a2 03
            ldy #$18                    ; 078A5:  a0 18
            bne b1_f8bb                 ; 078A7:  d0 12
b1_f8a9:    lda #$1c                    ; 078A9:  a9 1c
            ldx #$0c                    ; 078AB:  a2 0c
            ldy #$18                    ; 078AD:  a0 18
            bne b1_f8bb                 ; 078AF:  d0 0a
b1_f8b1:    lda #$1c                    ; 078B1:  a9 1c
            ldx #$03                    ; 078B3:  a2 03
            ldy #$58                    ; 078B5:  a0 58
            bne b1_f8bb                 ; 078B7:  d0 02
b1_f8b9:    lda #$10                    ; 078B9:  a9 10
b1_f8bb:    sta NOISE_VOL               ; 078BB:  8d 0c 40
            stx NOISE_PER               ; 078BE:  8e 0e 40
            sty NOISE_LEN               ; 078C1:  8c 0f 40
b1_f8c4:    rts                         ; 078C4:  60

b1_f8c5:    tax                         ; 078C5:  aa
            ror a                       ; 078C6:  6a
            txa                         ; 078C7:  8a
            rol a                       ; 078C8:  2a
            rol a                       ; 078C9:  2a
            rol a                       ; 078CA:  2a
b1_f8cb:    and #$07                    ; 078CB:  29 07
            clc                         ; 078CD:  18
            adc $f0                     ; 078CE:  65 f0
            adc $07c4                   ; 078D0:  6d c4 07
            tay                         ; 078D3:  a8
            lda tab_b1_fd32+564,y       ; 078D4:  b9 66 ff
            rts                         ; 078D7:  60

b1_f8d8:    lda $07b1                   ; 078D8:  ad b1 07
            and #$08                    ; 078DB:  29 08
            beq b1_f8e3                 ; 078DD:  f0 04
            lda #$04                    ; 078DF:  a9 04
            bne b1_f8ef                 ; 078E1:  d0 0c
b1_f8e3:    lda $f4                     ; 078E3:  a5 f4
            and #$7d                    ; 078E5:  29 7d
            beq b1_f8ed                 ; 078E7:  f0 04
            lda #$08                    ; 078E9:  a9 08
            bne b1_f8ef                 ; 078EB:  d0 02
b1_f8ed:    lda #$28                    ; 078ED:  a9 28
b1_f8ef:    ldx #$82                    ; 078EF:  a2 82
            ldy #$7f                    ; 078F1:  a0 7f
            rts                         ; 078F3:  60

b1_f8f4:    lda $07b1                   ; 078F4:  ad b1 07
            and #$08                    ; 078F7:  29 08
            beq b1_f8ff                 ; 078F9:  f0 04
            lda tab_b1_ff73+35,y        ; 078FB:  b9 96 ff
            rts                         ; 078FE:  60

b1_f8ff:    lda $f4                     ; 078FF:  a5 f4
            and #$7d                    ; 07901:  29 7d
            beq b1_f909                 ; 07903:  f0 04
            lda tab_b1_ff73+39,y        ; 07905:  b9 9a ff
            rts                         ; 07908:  60

b1_f909:    lda tab_b1_ff73+47,y        ; 07909:  b9 a2 ff
b1_f90c:    rts                         ; 0790C:  60

tab_b1_f90d: ; 96 bytes
            hex a5 59 54 64 59 3c 31 4b ; 0790D:  a5 59 54 64 59 3c 31 4b
            hex 69 5e 46 4f 36 8d 36 4b ; 07915:  69 5e 46 4f 36 8d 36 4b
            hex 8d 69 69 6f 75 6f 7b 6f ; 0791D:  8d 69 69 6f 75 6f 7b 6f
            hex 75 6f 7b 81 87 81 8d 69 ; 07925:  75 6f 7b 81 87 81 8d 69
            hex 69 93 99 93 9f 93 99 93 ; 0792D:  69 93 99 93 9f 93 99 93
            hex 9f 81 87 81 8d 93 99 93 ; 07935:  9f 81 87 81 8d 93 99 93
            hex 9f 08 72 fc 27 18 20 b8 ; 0793D:  9f 08 72 fc 27 18 20 b8
            hex f9 2e 1a 40 20 b0 fc 3d ; 07945:  f9 2e 1a 40 20 b0 fc 3d
            hex 21 20 c4 fc 3f 1d 18 11 ; 0794D:  21 20 c4 fc 3f 1d 18 11
            hex fd 00 00 08 1c fa 00 00 ; 07955:  fd 00 00 08 1c fa 00 00
            hex a4 fb 93 62 10 c8 fe 24 ; 0795D:  a4 fb 93 62 10 c8 fe 24
            hex 14 18 45 fc 1e 14 08 52 ; 07965:  14 18 45 fc 1e 14 08 52

            sbc $70a0,x                 ; 0796D:  fd a0 70
            pla                         ; 07970:  68
            php                         ; 07971:  08
            eor ($fe),y                 ; 07972:  51 fe
            jmp $1824                   ; 07974:  4c 24 18

tab_b1_f977: ; 469 bytes
            hex 01 fa 2d 1c b8 18 49 fa ; 07977:  01 fa 2d 1c b8 18 49 fa
            hex 20 12 70 18 75 fa 1b 10 ; 0797F:  20 12 70 18 75 fa 1b 10
            hex 44 18 9d fa 11 0a 1c 18 ; 07987:  44 18 9d fa 11 0a 1c 18
            hex c2 fa 2d 10 58 18 db fa ; 0798F:  c2 fa 2d 10 58 18 db fa
            hex 14 0d 3f 18 f9 fa 15 0d ; 07997:  14 0d 3f 18 f9 fa 15 0d
            hex 21 18 25 fb 18 10 7a 18 ; 0799F:  21 18 25 fb 18 10 7a 18
            hex 4b fb 19 0f 54 18 74 fb ; 079A7:  4b fb 19 0f 54 18 74 fb
            hex 1e 12 2b 18 72 fb 1e 0f ; 079AF:  1e 12 2b 18 72 fb 1e 0f
            hex 2d 84 2c 2c 2c 82 04 2c ; 079B7:  2d 84 2c 2c 2c 82 04 2c
            hex 04 85 2c 84 2c 2c 2a 2a ; 079BF:  04 85 2c 84 2c 2c 2a 2a
            hex 2a 82 04 2a 04 85 2a 84 ; 079C7:  2a 82 04 2a 04 85 2a 84
            hex 2a 2a 00 1f 1f 1f 98 1f ; 079CF:  2a 2a 00 1f 1f 1f 98 1f
            hex 1f 98 9e 98 1f 1d 1d 1d ; 079D7:  1f 98 9e 98 1f 1d 1d 1d
            hex 94 1d 1d 94 9c 94 1d 86 ; 079DF:  94 1d 1d 94 9c 94 1d 86
            hex 18 85 26 30 84 04 26 30 ; 079E7:  18 85 26 30 84 04 26 30
            hex 86 14 85 22 2c 84 04 22 ; 079EF:  86 14 85 22 2c 84 04 22
            hex 2c 21 d0 c4 d0 31 d0 c4 ; 079F7:  2c 21 d0 c4 d0 31 d0 c4
            hex d0 00 85 2c 22 1c 84 26 ; 079FF:  d0 00 85 2c 22 1c 84 26
            hex 2a 82 28 26 04 87 22 34 ; 07A07:  2a 82 28 26 04 87 22 34
            hex 3a 82 40 04 36 84 3a 34 ; 07A0F:  3a 82 40 04 36 84 3a 34
            hex 82 2c 30 85 2a 00 5d 55 ; 07A17:  82 2c 30 85 2a 00 5d 55
            hex 4d 15 19 96 15 d5 e3 eb ; 07A1F:  4d 15 19 96 15 d5 e3 eb
            hex 2d a6 2b 27 9c 9e 59 85 ; 07A27:  2d a6 2b 27 9c 9e 59 85
            hex 22 1c 14 84 1e 22 82 20 ; 07A2F:  22 1c 14 84 1e 22 82 20
            hex 1e 04 87 1c 2c 34 82 36 ; 07A37:  1e 04 87 1c 2c 34 82 36
            hex 04 30 34 04 2c 04 26 2a ; 07A3F:  04 30 34 04 2c 04 26 2a
            hex 85 22 84 04 82 3a 38 36 ; 07A47:  85 22 84 04 82 3a 38 36
            hex 32 04 34 04 24 26 2c 04 ; 07A4F:  32 04 34 04 24 26 2c 04
            hex 26 2c 30 00 05 b4 b2 b0 ; 07A57:  26 2c 30 00 05 b4 b2 b0
            hex 2b ac 84 9c 9e a2 84 94 ; 07A5F:  2b ac 84 9c 9e a2 84 94
            hex 9c 9e 85 14 22 84 2c 85 ; 07A67:  9c 9e 85 14 22 84 2c 85
            hex 1e 82 2c 84 2c 1e 84 04 ; 07A6F:  1e 82 2c 84 2c 1e 84 04
            hex 82 3a 38 36 32 04 34 04 ; 07A77:  82 3a 38 36 32 04 34 04
            hex 64 04 64 86 64 00 05 b4 ; 07A7F:  64 04 64 86 64 00 05 b4
            hex b2 b0 2b ac 84 37 b6 b6 ; 07A87:  b2 b0 2b ac 84 37 b6 b6
            hex 45 85 14 1c 82 22 84 2c ; 07A8F:  45 85 14 1c 82 22 84 2c
            hex 4e 82 4e 84 4e 22 84 04 ; 07A97:  4e 82 4e 84 4e 22 84 04
            hex 85 32 85 30 86 2c 04 00 ; 07A9F:  85 32 85 30 86 2c 04 00
            hex 05 a4 05 9e 05 9d 85 84 ; 07AA7:  05 a4 05 9e 05 9d 85 84
            hex 14 85 24 28 2c 82 22 84 ; 07AAF:  14 85 24 28 2c 82 22 84
            hex 22 14 21 d0 c4 d0 31 d0 ; 07AB7:  22 14 21 d0 c4 d0 31 d0
            hex c4 d0 00 82 2c 84 2c 2c ; 07ABF:  c4 d0 00 82 2c 84 2c 2c
            hex 82 2c 30 04 34 2c 04 26 ; 07AC7:  82 2c 30 04 34 2c 04 26
            hex 86 22 00 a4 25 25 a4 29 ; 07ACF:  86 22 00 a4 25 25 a4 29
            hex a2 1d 9c 95 82 2c 2c 04 ; 07AD7:  a2 1d 9c 95 82 2c 2c 04
            hex 2c 04 2c 30 85 34 04 04 ; 07ADF:  2c 04 2c 30 85 34 04 04
            hex 00 a4 25 25 a4 a8 63 04 ; 07AE7:  00 a4 25 25 a4 a8 63 04
            hex 85 0e 1a 84 24 85 22 14 ; 07AEF:  85 0e 1a 84 24 85 22 14
            hex 84 0c 82 34 84 34 34 82 ; 07AF7:  84 0c 82 34 84 34 34 82
            hex 2c 84 34 86 3a 04 00 a0 ; 07AFF:  2c 84 34 86 3a 04 00 a0
            hex 21 21 a0 21 2b 05 a3 82 ; 07B07:  21 21 a0 21 2b 05 a3 82
            hex 18 84 18 18 82 18 18 04 ; 07B0F:  18 84 18 18 82 18 18 04
            hex 86 3a 22 31 90 31 90 31 ; 07B17:  86 3a 22 31 90 31 90 31
            hex 71 31 90 90 90 00 82 34 ; 07B1F:  71 31 90 90 90 00 82 34
            hex 84 2c 85 22 84 24 82 26 ; 07B27:  84 2c 85 22 84 24 82 26
            hex 36 04 36 86 26 00 ac 27 ; 07B2F:  36 04 36 86 26 00 ac 27
            hex 5d 1d 9e 2d ac 9f 85 14 ; 07B37:  5d 1d 9e 2d ac 9f 85 14
            hex 82 20 84 22 2c 1e 1e 82 ; 07B3F:  82 20 84 22 2c 1e 1e 82
            hex 2c 2c 1e 04 87          ; 07B47:  2c 2c 1e 04 87

            rol a                       ; 07B4C:  2a
            rti                         ; 07B4D:  40

            hex 40 40 3a 36 82 34 2c 04 ; 07B4E:  40 40 3a 36 82 34 2c 04
            hex 26 86 22 00 e3 f7 f7 f7 ; 07B56:  26 86 22 00 e3 f7 f7 f7
            hex f5 f1 ac 27 9e 9d 85 18 ; 07B5E:  f5 f1 ac 27 9e 9d 85 18
            hex 82 1e 84 22 2a 22 22 82 ; 07B66:  82 1e 84 22 2a 22 22 82
            hex 2c 2c 22 04 86 04 82    ; 07B6E:  2c 2c 22 04 86 04 82

            rol a                       ; 07B75:  2a
            rol $04,x                   ; 07B76:  36 04
            rol $87,x                   ; 07B78:  36 87
            rol $34,x                   ; 07B7A:  36 34
            bmi tab_b1_f977+397         ; 07B7C:  30 86
            hex 2c 04 00 ; bit $0004    ; 07B7E:  2c 04 00
            brk                         ; 07B81:  00
            hex 68                      ; 07B82:  68
            ror a                       ; 07B83:  6a
            jmp ($a245)                 ; 07B84:  6c 45 a2

            hex 31 b0 f1 ed eb a2 1d 9c ; 07B87:  31 b0 f1 ed eb a2 1d 9c
            hex 95 86 04 85 22 82 22 87 ; 07B8F:  95 86 04 85 22 82 22 87
            hex 22 26 2a 84 2c 22 86 14 ; 07B97:  22 26 2a 84 2c 22 86 14
            hex 51 90 31 11 00 80 22 28 ; 07B9F:  51 90 31 11 00 80 22 28
            hex 22 26 22 24 22 26 22 28 ; 07BA7:  22 26 22 24 22 26 22 28
            hex 22 2a 22 28 22 26 22 28 ; 07BAF:  22 2a 22 28 22 26 22 28
            hex 22 26 22 24 22 26 22 28 ; 07BB7:  22 26 22 24 22 26 22 28
            hex 22 2a 22 28 22 26 20 26 ; 07BBF:  22 2a 22 28 22 26 20 26
            hex 20 24 20 26 20 28 20 26 ; 07BC7:  20 24 20 26 20 28 20 26
            hex 20 28 20 26 20 24 20 26 ; 07BCF:  20 28 20 26 20 24 20 26
            hex 20 24 20 26 20 28 20 26 ; 07BD7:  20 24 20 26 20 28 20 26
            hex 20 28 20 26 20 24 28 30 ; 07BDF:  20 28 20 26 20 24 28 30
            hex 28 32 28 30 28 2e 28 30 ; 07BE7:  28 32 28 30 28 2e 28 30
            hex 28 2e 28 2c 28 2e 28 30 ; 07BEF:  28 2e 28 2c 28 2e 28 30
            hex 28 32                   ; 07BF7:  28 32

            plp                         ; 07BF9:  28
            bmi b1_fc24                 ; 07BFA:  30 28
            rol $3028                   ; 07BFC:  2e 28 30
            plp                         ; 07BFF:  28
            rol $2c28                   ; 07C00:  2e 28 2c
            plp                         ; 07C03:  28
            rol $0400                   ; 07C04:  2e 00 04
            bvs tab_b1_fc29+78          ; 07C07:  70 6e
            jmp ($706e)                 ; 07C09:  6c 6e 70

            hex 72                      ; 07C0C:  72

            bvs tab_b1_fc29+84          ; 07C0D:  70 6e
            bvs tab_b1_fc29+86          ; 07C0F:  70 6e
            jmp ($706e)                 ; 07C11:  6c 6e 70

            hex 72                      ; 07C14:  72

            bvs tab_b1_fc29+92          ; 07C15:  70 6e
            ror $6e6c                   ; 07C17:  6e 6c 6e
            bvs tab_b1_fc29+97          ; 07C1A:  70 6e
            bvs tab_b1_fc29+99          ; 07C1C:  70 6e
            jmp ($6c6e)                 ; 07C1E:  6c 6e 6c

            ror $6e70                   ; 07C21:  6e 70 6e
b1_fc24:    bvs tab_b1_fc29+107         ; 07C24:  70 6e
            jmp ($7876)                 ; 07C26:  6c 76 78

tab_b1_fc29: ; 251 bytes
            hex 76 74 76 74 72 74 76 78 ; 07C29:  76 74 76 74 72 74 76 78
            hex 76 74 76 74 72 74 84 1a ; 07C31:  76 74 76 74 72 74 84 1a
            hex 83 18 20 84 1e 83 1c 28 ; 07C39:  83 18 20 84 1e 83 1c 28
            hex 26 1c 1a 1c 82 2c 04 04 ; 07C41:  26 1c 1a 1c 82 2c 04 04
            hex 22 04 04 84 1c 87 26 2a ; 07C49:  22 04 04 84 1c 87 26 2a
            hex 26 84 24 28 24 80 22 00 ; 07C51:  26 84 24 28 24 80 22 00
            hex 9c 05 94 05 0d 9f 1e 9c ; 07C59:  9c 05 94 05 0d 9f 1e 9c
            hex 98 9d 82 22 04 04 1c 04 ; 07C61:  98 9d 82 22 04 04 1c 04
            hex 04 84 14 86 1e 80 16 80 ; 07C69:  04 84 14 86 1e 80 16 80
            hex 14 81 1c 30 04 30 30 04 ; 07C71:  14 81 1c 30 04 30 30 04
            hex 1e 32 04 32 32 04 20 34 ; 07C79:  1e 32 04 32 32 04 20 34
            hex 04 34 34 04 36 04 84 36 ; 07C81:  04 34 34 04 36 04 84 36
            hex 00 46 a4 64 a4 48 a6 66 ; 07C89:  00 46 a4 64 a4 48 a6 66
            hex a6 4a a8 68 a8 6a 44 2b ; 07C91:  a6 4a a8 68 a8 6a 44 2b
            hex 81 2a 42 04 42 42 04 2c ; 07C99:  81 2a 42 04 42 42 04 2c
            hex 64 04 64 64 04 2e 46 04 ; 07CA1:  64 04 64 64 04 2e 46 04
            hex 46 46 04 22 04 84 22 87 ; 07CA9:  46 46 04 22 04 84 22 87
            hex 04 06 0c 14 1c 22 86 2c ; 07CB1:  04 06 0c 14 1c 22 86 2c
            hex 22 87 04 60 0e 14 1a 24 ; 07CB9:  22 87 04 60 0e 14 1a 24
            hex 86 2c 24 87 04 08 10 18 ; 07CC1:  86 2c 24 87 04 08 10 18
            hex 1e 28 86 30 30 80 64 00 ; 07CC9:  1e 28 86 30 30 80 64 00
            hex cd d5 dd e3 ed f5 bb b5 ; 07CD1:  cd d5 dd e3 ed f5 bb b5
            hex cf d5 db e5 ed f3 bd b3 ; 07CD9:  cf d5 db e5 ed f3 bd b3
            hex d1 d9 df e9 f1 f7 bf ff ; 07CE1:  d1 d9 df e9 f1 f7 bf ff
            hex ff ff 34 00 86 04 87 14 ; 07CE9:  ff ff 34 00 86 04 87 14
            hex 1c 22 86 34 84 2c 04 04 ; 07CF1:  1c 22 86 34 84 2c 04 04
            hex 04 87 14 1a 24 86 32 84 ; 07CF9:  04 87 14 1a 24 86 32 84
            hex 2c 04 86 04 87 18 1e 28 ; 07D01:  2c 04 86 04 87 18 1e 28
            hex 86 36 87 30 30 30 80 2c ; 07D09:  86 36 87 30 30 30 80 2c
            hex 82 14 2c 62 26 10 28 80 ; 07D11:  82 14 2c 62 26 10 28 80
            hex 04 82 14 2c 62 26 10 28 ; 07D19:  04 82 14 2c 62 26 10 28
            hex 80 04 82                ; 07D21:  80 04 82

            php                         ; 07D24:  08
            asl $185e,x                 ; 07D25:  1e 5e 18
            rts                         ; 07D28:  60

            hex 1a 80 04 82             ; 07D29:  1a 80 04 82

            php                         ; 07D2D:  08
            asl $185e,x                 ; 07D2E:  1e 5e 18
            rts                         ; 07D31:  60

tab_b1_fd32: ; 573 bytes
            hex 1a 86 04 83 1a 18 16 84 ; 07D32:  1a 86 04 83 1a 18 16 84
            hex 14 1a 18 0e 0c 16 83 14 ; 07D3A:  14 1a 18 0e 0c 16 83 14
            hex 20 1e 1c 28 26 87 24 1a ; 07D42:  20 1e 1c 28 26 87 24 1a
            hex 12 10 62 0e 80 04 04 00 ; 07D4A:  12 10 62 0e 80 04 04 00
            hex 82 18 1c 20 22 26 28 81 ; 07D52:  82 18 1c 20 22 26 28 81
            hex 2a 2a 2a 04 2a 04 83 2a ; 07D5A:  2a 2a 2a 04 2a 04 83 2a
            hex 82 22 86 34 32 34 81 04 ; 07D62:  82 22 86 34 32 34 81 04
            hex 22 26 2a 2c 30 86 34 83 ; 07D6A:  22 26 2a 2c 30 86 34 83
            hex 32 82 36 84 34 85 04 81 ; 07D72:  32 82 36 84 34 85 04 81
            hex 22 86 30 2e 30 81 04 22 ; 07D7A:  22 86 30 2e 30 81 04 22
            hex 26 2a 2c 2e 86 30 83 22 ; 07D82:  26 2a 2c 2e 86 30 83 22
            hex 82 36 84 34 85 04 81 22 ; 07D8A:  82 36 84 34 85 04 81 22
            hex 86 3a 3a 3a 82 3a 81 40 ; 07D92:  86 3a 3a 3a 82 3a 81 40
            hex 82 04 81 3a 86 36 36 36 ; 07D9A:  82 04 81 3a 86 36 36 36
            hex 82 36 81 3a 82 04 81 36 ; 07DA2:  82 36 81 3a 82 04 81 36
            hex 86 34 82 26 2a 36 81 34 ; 07DAA:  86 34 82 26 2a 36 81 34
            hex 34 85 34 81 2a 86 2c 00 ; 07DB2:  34 85 34 81 2a 86 2c 00
            hex 84 90 b0 84 50 50 b0 00 ; 07DBA:  84 90 b0 84 50 50 b0 00
            hex 98 96 94 92 94 96 58 58 ; 07DC2:  98 96 94 92 94 96 58 58
            hex 58 44 5c 44 9f a3 a1 a3 ; 07DCA:  58 44 5c 44 9f a3 a1 a3
            hex 85 a3 e0 a6 23 c4 9f 9d ; 07DD2:  85 a3 e0 a6 23 c4 9f 9d
            hex 9f 85 9f d2 a6 23 c4 b5 ; 07DDA:  9f 85 9f d2 a6 23 c4 b5
            hex b1 af 85 b1 af ad 85 95 ; 07DE2:  b1 af 85 b1 af ad 85 95
            hex 9e a2 aa 6a 6a 6b 5e 9d ; 07DEA:  9e a2 aa 6a 6a 6b 5e 9d
            hex 84 04 04 82 22 86 22 82 ; 07DF2:  84 04 04 82 22 86 22 82
            hex 14 22 2c 12 22 2a 14 22 ; 07DFA:  14 22 2c 12 22 2a 14 22
            hex 2c 1c 22 2c 14 22 2c 12 ; 07E02:  2c 1c 22 2c 14 22 2c 12
            hex 22 2a 14 22 2c 1c 22 2c ; 07E0A:  22 2a 14 22 2c 1c 22 2c
            hex 18 22 2a 16 20 28 18 22 ; 07E12:  18 22 2a 16 20 28 18 22
            hex 2a 12 22 2a 18 22 2a 12 ; 07E1A:  2a 12 22 2a 18 22 2a 12
            hex 22 2a 14 22 2c 0c 22 2c ; 07E22:  22 2a 14 22 2c 0c 22 2c
            hex 14 22 34 12 22 30 10 22 ; 07E2A:  14 22 34 12 22 30 10 22
            hex 2e 16 22 34 18 26 36 16 ; 07E32:  2e 16 22 34 18 26 36 16
            hex 26 36 14 26 36 12 22 36 ; 07E3A:  26 36 14 26 36 12 22 36
            hex 5c 22 34 0c 22 22 81 1e ; 07E42:  5c 22 34 0c 22 22 81 1e
            hex 1e 85 1e 81 12 86 14 81 ; 07E4A:  1e 85 1e 81 12 86 14 81
            hex 2c 22 1c 2c 22 1c 85 2c ; 07E52:  2c 22 1c 2c 22 1c 85 2c
            hex 04 81 2e 24 1e 2e 24 1e ; 07E5A:  04 81 2e 24 1e 2e 24 1e
            hex 85 2e 04 81 32 28 22 32 ; 07E62:  85 2e 04 81 32 28 22 32
            hex 28 22 85 32 87 36 36 36 ; 07E6A:  28 22 85 32 87 36 36 36
            hex 84 3a 00 5c 54 4c 5c 54 ; 07E72:  84 3a 00 5c 54 4c 5c 54
            hex 4c 5c 1c 1c 5c 5c 5c 5c ; 07E7A:  4c 5c 1c 1c 5c 5c 5c 5c
            hex 5e 56 4e 5e 56 4e 5e 1e ; 07E82:  5e 56 4e 5e 56 4e 5e 1e
            hex 1e 5e 5e 5e 5e 62 5a 50 ; 07E8A:  1e 5e 5e 5e 5e 62 5a 50
            hex 62 5a 50 62 22 22 62 e7 ; 07E92:  62 5a 50 62 22 22 62 e7
            hex e7 e7 2b 86 14 81 14 80 ; 07E9A:  e7 e7 2b 86 14 81 14 80
            hex 14 14 81 14 14 14 14 86 ; 07EA2:  14 14 81 14 14 14 14 86
            hex 16 81 16 80 16 16 81 16 ; 07EAA:  16 81 16 80 16 16 81 16
            hex 16 16 16 81 28 22 1a 28 ; 07EB2:  16 16 16 81 28 22 1a 28
            hex 22 1a 28 80 28 28 81 28 ; 07EBA:  22 1a 28 80 28 28 81 28
            hex 87 2c 2c 2c 84 30 83 04 ; 07EC2:  87 2c 2c 2c 84 30 83 04
            hex 84 0c 83 62 10 84 12 83 ; 07ECA:  84 0c 83 62 10 84 12 83
            hex 1c 22 1e 22 26 18 1e 04 ; 07ED2:  1c 22 1e 22 26 18 1e 04
            hex 1c 00 e3 e1 e3 1d de e0 ; 07EDA:  1c 00 e3 e1 e3 1d de e0
            hex 23 ec 75 74 f0 f4 f6 ea ; 07EE2:  23 ec 75 74 f0 f4 f6 ea
            hex 31 2d 83 12 14 04 18 1a ; 07EEA:  31 2d 83 12 14 04 18 1a
            hex 1c 14 26 22 1e 1c 18 1e ; 07EF2:  1c 14 26 22 1e 1c 18 1e
            hex 22 0c 14 ff ff ff 00 88 ; 07EFA:  22 0c 14 ff ff ff 00 88
            hex 00 2f 00 00 02 a6 02 80 ; 07F02:  00 2f 00 00 02 a6 02 80
            hex 02 5c 02 3a 02 1a 01 df ; 07F0A:  02 5c 02 3a 02 1a 01 df
            hex 01 c4 01 ab 01 93 01 7c ; 07F12:  01 c4 01 ab 01 93 01 7c
            hex 01 67 01 53 01 40 01 2e ; 07F1A:  01 67 01 53 01 40 01 2e
            hex 01 1d 01 0d 00 fe 00 ef ; 07F22:  01 1d 01 0d 00 fe 00 ef
            hex 00 e2 00 d5 00 c9 00 be ; 07F2A:  00 e2 00 d5 00 c9 00 be
            hex 00 b3 00 a9 00 a0 00 97 ; 07F32:  00 b3 00 a9 00 a0 00 97
            hex 00 8e 00 86 00 77 00 7e ; 07F3A:  00 8e 00 86 00 77 00 7e
            hex 00 71 00 54 00 64 00 5f ; 07F42:  00 71 00 54 00 64 00 5f
            hex 00 59 00 50 00 47 00 43 ; 07F4A:  00 59 00 50 00 47 00 43
            hex 00 3b 00 35 00 2a 00 23 ; 07F52:  00 3b 00 35 00 2a 00 23
            hex 04 75 03 57 02 f9 02 cf ; 07F5A:  04 75 03 57 02 f9 02 cf
            hex 01 fc 00 6a 05 0a 14 28 ; 07F62:  01 fc 00 6a 05 0a 14 28
            hex 50 1e 3c 02 04          ; 07F6A:  50 1e 3c 02 04

            php                         ; 07F6F:  08
            bpl tab_b1_ff73+31          ; 07F70:  10 20
            rti                         ; 07F72:  40

tab_b1_ff73: ; 135 bytes
            hex 18 30 0c 03 06 0c 18 30 ; 07F73:  18 30 0c 03 06 0c 18 30
            hex 12 24 08 36 03 09 06 12 ; 07F7B:  12 24 08 36 03 09 06 12
            hex 1b 24 0c 24 02 06 04 0c ; 07F83:  1b 24 0c 24 02 06 04 0c
            hex 12 18 08 12 01 03 02 06 ; 07F8B:  12 18 08 12 01 03 02 06
            hex 09 0c 04 98 99 9a 9b 90 ; 07F93:  09 0c 04 98 99 9a 9b 90
            hex 94 94 95 95 96 97 98 90 ; 07F9B:  94 94 95 95 96 97 98 90
            hex 91 92 92 93 93 93 94 94 ; 07FA3:  91 92 92 93 93 93 94 94
            hex 94 94 94 94 95 95 95 95 ; 07FAB:  94 94 94 94 95 95 95 95
            hex 95 95 96 96 96 96 96 96 ; 07FB3:  95 95 96 96 96 96 96 96
            hex 96 96 96 96 96 96 96 96 ; 07FBB:  96 96 96 96 96 96 96 96
            hex 96 96 96 95 95 94 93 15 ; 07FC3:  96 96 96 95 95 94 93 15
            hex 16 16 17 17 18 19 19 1a ; 07FCB:  16 16 17 17 18 19 19 1a
            hex 1a 1c 1d 1d 1e 1e 1f 1f ; 07FD3:  1a 1c 1d 1d 1e 1e 1f 1f
            hex 1f 1f 1e 1d 1c 1e 1f 1f ; 07FDB:  1f 1f 1e 1d 1c 1e 1f 1f
            hex 1e 1d 1c 1a 18 16 14 15 ; 07FE3:  1e 1d 1c 1a 18 16 14 15
            hex 16 16 17 17 18 19 19 1a ; 07FEB:  16 16 17 17 18 19 19 1a
            hex 1a 1c 1d 1d 1e 1e 1f    ; 07FF3:  1a 1c 1d 1d 1e 1e 1f

NMI:        word $8082                  ; 07FFA: 82 80
RESET:      word $8000                  ; 07FFC: 00 80
IRQ:        word tab_b1_ff73+125        ; 07FFE: f0 ff


