INCLUDE "gbhw.inc"

ClockDiv	EQU	0
TimerHertz	EQU	TACF_START|TACF_4KHZ
ScoreLocation   EQU (_SCRN0)+(7)+(SCRN_VY_B*1)

SECTION "Timer_Overflow",HOME[$0050]
	call	UpdateScore
	reti

SECTION "start",HOME[$0100]
	nop
	jp      begin

; ROM header
        ROM_HEADER      ROM_NOMBC, ROM_SIZE_32KBYTE, RAM_SIZE_0KBYTE
INCLUDE "memory.asm"

begin:
        nop
        di
        ld      sp, $ffff 		; Set SP

init:
        ld      a, %11100100 		; Set palette
	ld      [rBGP], a

        ld      a,0                     ; SET SCREEN TO TO UPPER RIGHT HAND CORNER
        ld      [rSCX], a
        ld      [rSCY], a

        ;call    StopLCD                 ; YOU CAN NOT LOAD $8000 WITH LCD ON
        ld      hl, Sprites
        ld      de, _VRAM               ; $8000
        ld      bc, 16 * 32
        call    mem_Copy        	; load tile data

        ; Set the LCDC register
        ld      a, LCDCF_ON|LCDCF_BG8000|LCDCF_BG9800|LCDCF_BGON|LCDCF_OBJ8|LCDCF_OBJON
        ld      [rLCDC], a

        ld      a, $17          ; First make the whole screen black
        ld      hl, _SCRN0
        ld      bc, SCRN_VX_B * SCRN_VY_B
        call    mem_SetVRAM

        ld      a, ClockDiv             ; load number of counts of timer
        ld      [rTMA],a
        ld      a,TimerHertz            ; load timer speed
        ld      [rTAC],a

	ld	a, 0
	ld	[Score], a

        ld      a, IEF_VBLANK|IEF_TIMER
        ld      [rIE],a                 ; ENABLE VBLANK AND TIMER INTERRUPT
	ei
mainloop:
	ld	a, [Score]
	sla	a
	ld      hl, ScoreLocation
        call Draw8by16Sprite
	jr	mainloop

; Arguments:
;       a = Top sprite tile number
;       hl = Top Sprite screen location
Draw8by16Sprite:
        push bc                         ; Save the values in these registers
        push hl
        push af                         ; Save the vram tile location
        ld       bc,1
        call mem_SetVRAM
        pop      af
        inc      a
        pop      hl
        ld       de,SCRN_VY_B   ; Move the screen sprite location down one 
        add      hl,de
        ld       bc,1                   ; Just in case
        call mem_SetVRAM
        pop  bc
        reti

UpdateScore:
	;ld	bc, 0
.loop
	;dec	bc
	;ld	a, b
	;or	c
	;jr 	nz, .loop
	ld	a, [Score]
	inc	a
	cp	10
	jr	c, .ok
	ld	a, 0
.ok
	ld	[Score], a
	ret

SECTION "Vars", WRAM0
Score	ds	1

include "PongSprites.z80"

