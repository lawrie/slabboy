; Hello sprite
; David Pello 2010
; ladecadence.net
; For the tutorial(spanish): 
; http://wiki.ladecadence.net/doku.php?id=tutorial_de_ensamblador
 
INCLUDE "gbhw.inc"          ; We define constants to work with our sprite
 
; We define constants to work with our sprite
_SPR0_Y     EQU     _OAMRAM ; sprite Y 0 is the beginning of the sprite mem
_SPR0_X     EQU     _OAMRAM+1
_SPR0_NUM   EQU     _OAMRAM+2
_SPR0_ATT   EQU     _OAMRAM+3
 
; We create a couple of variables to see where we need to move the sprite
_MOVX       EQU     _RAM    ; start of RAM for data dispobible
_MOVY       EQU     _RAM+1
 
; The program begins here:
SECTION "start",HOME[$0100]
    nop
    jp      inicio
 
; Head of the ROM (Macro defined in gbhw.inc)
; defines a rom without mapper, without 32K RAM, the basics
; (Such as tetris)
    ROM_HEADER  ROM_NOMBC, ROM_SIZE_32KBYTE, RAM_SIZE_0KBYTE
 
; Here begins our program
inicio:
    nop
    di                      ; disables interrupts 
    ld      sp, $ffff       ; We aim pile atop the ram
 
inicializacion:
    ld      a, %11100100    ;  Palette colors from the darkest to
                            ; Lighter, 11 10 01 00
    ld      [rBGP], a       ; We write this in the background palette register
    ld      [rOBP0], a      ; and sprite palette 0
 
    ld      a, 0            ; write 0 records scroll in X and Y 
    ld      [rSCX], a       ; positioned so that the visible screen
    ld      [rSCY], a       ; at the beginning (upper left) of the fund.
 
    call    apaga_LCD       ;  We call the routine that turns off the LCD
 
    ; We load the tiles in memory of tiles
 
    ld      hl, Tiles       ; HL loaded in the direction of our tile
    ld      de, _VRAM       ; address in the video memory
    ld      b, 32           ; b = 32, number of bytes to copy (2 tiles)
 
.bucle_carga:
    ld      a,[hl]          ;  A load in the data pointed to by HL
    ld      [de], a         ; y and we put in the address pointed in DE 
    dec     b               ;decrement b, b = b-1
    jr      z, .fin_bucle_carga ; if b = 0, finished, nothing left to copy
    inc     hl              ; We increased the read direction
    inc     de              ;  We increased the write direction
    jr      .bucle_carga    ; we follow
.fin_bucle_carga:
 
    ; We clean the screen (fill entire background map), with tile 0
 
    ld      hl, _SCRN0
    ld      de, 32*32       ;number of tiles on the background map
.bucle_limpieza:
    ld      a, 0            ; tile 0 is our empty tile
    ld      [hl], a
    dec     de
    ; Now I have to check if it is zero, to see if I have it 
    ; finishes copying.  dec ningñun flag does not change, so I can not
    ; check the zero flag directly, but that is zero, dye
    ; They must be zero two, so I can make or including 
    ; and if the result is zero, both are zero.
    ld      a, d            ; d loaded in to
    or      e               ; and make a or e
    jp      z, .fin_bucle_limpieza  ; if d or e is zero, it is zero.  We ended.
    inc     hl              ;  We increased the write direction
    jp      .bucle_limpieza
.fin_bucle_limpieza
 
    ; Well, we have all the map tiles filled with tile 0, 
    ; Now we will create the sprite.
 
    ld      a, 30
    ld      [_SPR0_Y], a    ;Y position of the sprite     
    ld      a, 30
    ld      [_SPR0_X], a    ; X position of the sprite
    ld      a, 1
    ld      [_SPR0_NUM], a  ; number of tile on the table that we will use tiles
    ld      a, 0
    ld      [_SPR0_ATT], a  ; special attributes, so far nothing.
 
    ; configure and activate the display
    ld      a, LCDCF_ON|LCDCF_BG8000|LCDCF_BG9800|LCDCF_BGON|LCDCF_OBJ8|LCDCF_OBJON
    ld      [rLCDC], a
 
    ; We prepare animation variables
    ld      a, 1
    ld      [_MOVX], a
    ld      [_MOVY], a
 
    ; infinite loop
animacion:
    ; first, we wait for the VBlank, since we can not change
    ; VRAM out of it, or weird things will
.wait
    ld      a, [rLY]
    cp      145
    jr      nz, .wait
    ; incrementamos las y
    ld      a, [_SPR0_Y]    ;  And we load the current position of the sprite
    ld      hl, _MOVY       ; hl in the direction of increasing Y
    add     a, [hl]         ; add
    ld      hl, _SPR0_Y
    ld      [hl], a         ; keep
    ; compared to see if they change the direction
    cp      152             ; so you do not exit the screen (max Y)
    jr      z, .dec_y
    cp      16
    jr      z, .inc_y       ; the same minimum coordinate Y = 16
    ; do not change
    jr      .end_y
.dec_y:
    ld      a, -1           ; now we have to decrease the Y 
    ld      [_MOVY], a
    jr      .end_y
.inc_y:
    ld      a, 1            ; now we have to increase the Y
    ld      [_MOVY], a
.end_y:
    ; we go with the X, the same but changing the margins 
    ld      a, [_SPR0_X]    ; We load the current X position of the sprite
    ld      hl, _MOVX       ; hl, the incrementing direction X
    add     a, [hl]         ; add

    ld      hl, _SPR0_X
    ld      [hl], a         ; keep
    ; compared to see if they change the direction
    cp      160             ; so you do not exit the screen (max X)
    jr      z, .dec_x
    cp      8               ; the same minimum coord left = 8 
    jr      z, .inc_x
    ; do not change
    jr      .end_x
.dec_x:
    ld      a, -1           ; now we have to decrease the X 
    ld      [_MOVX], a
    jr      .end_x
.inc_x:
    ld      a, 1            ; now we have to increase the X 
    ld      [_MOVX], a
.end_x:
    ; a small delay 
    call retardo
    ; we start 
    jr      animacion
 
; LCD shutdown routine
apaga_LCD:
    ld      a,[rLCDC]
    rlca                    ; It sets the high bit of LCDC in the carry flag
    ret     nc              ; Display is already off, again.
 
    ; We VBlank hope to, because we can not turn off the screen
    ; some other time
 
.espera_VBlank
    ld      a, [rLY]
    cp      145
    jr      nz, .espera_VBlank
 
    ; we are in VBlank, we turn off the LCD
    ld      a,[rLCDC]       ; in A, the contents of the LCDC 
    res     7,a             ; we zero bit 7 (on the LCD)
    ld      [rLCDC],a       ; We wrote in the LCDC register content A
 
    ret                     ; return
 
; delay routine
retardo:
    ld      de, 2000        ; number of times to execute the loop
.delay:
    dec     de              ; decrement
    ld      a, d            ; see if zero
    or      e
    jr      z, .fin_delay
    nop
    jr      .delay
.fin_delay:
    ret
 
; Our tiles Facts
Tiles:
    DB  $AA, $00, $44, $00, $AA, $00, $11, $00
    DB  $AA, $00, $44, $00, $AA, $00, $11, $00
    DB  $3E, $3E, $41, $7F, $41, $6B, $41, $7F
    DB  $41, $63, $41, $7F, $3E, $3E, $00, $00
EndTiles:

