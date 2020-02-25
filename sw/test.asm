; Hello World 1.0
; February 2, 2007
; John Harrison
; Based mostly from GALP

INCLUDE "gbhw.inc" ; standard hardware definitions from devrs.com
INCLUDE "ibmpc1.inc" ; ASCII character set from devrs.com

; IRQs
SECTION	"Vblank",HOME[$0040]
	reti
SECTION	"LCDC",HOME[$0048]
	reti
SECTION	"Timer_Overflow",HOME[$0050]
	reti
SECTION	"Serial",HOME[$0058]
	reti
SECTION	"p1thru4",HOME[$0060]
	reti

; ****************************************************************************************
; boot loader jumps to here.
; ****************************************************************************************
SECTION	"start",HOME[$0100]
nop
jp	begin

; ****************************************************************************************
; ROM HEADER and ASCII character set
; ****************************************************************************************
; ROM header
	ROM_HEADER	ROM_NOMBC, ROM_SIZE_32KBYTE, RAM_SIZE_0KBYTE
INCLUDE "memory.asm"
TileData:
	chr_IBMPC1	1,8 ; LOAD ENTIRE CHARACTER SET

; ****************************************************************************************
; Main code Initialization:
; set the stack pointer, enable interrupts, set the palette, set the screen relative to the window
; copy the ASCII character table, clear the screen
; ****************************************************************************************
begin:
	nop
	di
	ld	sp, $ffff	; set the stack pointer to highest mem location + 1
init:
	ld	a, %11100100 	; Window palette colors, from darkest to lightest
	ld	[rBGP], a	; CLEAR THE SCREEN
	ld	a,0		; SET SCREEN TO TO UPPER RIGHT HAND CORNER
	ld	[rSCX], a
	ld	[rSCY], a		
	call	StopLCD		; YOU CAN NOT LOAD $8000 WITH LCD ON
	ld	hl, TileData
	ld	de, _VRAM	; $8000
	ld	bc, 8*256 	; the ASCII character set: 256 characters, each with 8 bytes of display data
	call	mem_CopyMono	; load tile data
	ld	a, LCDCF_ON|LCDCF_BG8000|LCDCF_BG9800|LCDCF_BGON|LCDCF_OBJ8|LCDCF_OBJON|LCDCF_WINON|LCDCF_WIN9C00
	ld	[rLCDC], a	
	ld	a, 112
	ld	[rWY], a
	ld	a, 8
	ld	[rWX], a
	ld	a, 32		; ASCII FOR BLANK SPACE
	ld	hl, _SCRN0
	ld	bc, SCRN_VX_B * SCRN_VY_B
	call	mem_SetVRAM
	ld	a, 43		; ASCII +
	ld	hl, _SCRN1	; Window
	ld	bc, SCRN_VX_B * SCRN_VY_B
	call	mem_SetVRAM
; ****************************************************************************************
; Main code:
; Print a character string in the middle of the screen
; ****************************************************************************************
	ld	hl, _OAMRAM
	ld	a, 16		; x and y = 16
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc 	hl
	ld	a, 1		; Tile 1
	ld	[hl], a
	ld	de, _SCRN1
	ld	hl,WinTitle
	ld	bc, WinTitleEnd-WinTitle
	call	mem_CopyVRAM
	ld	de, _SCRN0+3+(SCRN_VY_B*10) 
	ld	a, P1F_5
	ld	[rP1], A
loop:
	ld	hl,Title
	ld	bc, TitleEnd-Title
	push	de
	call	mem_CopyVRAM
	pop	de
	ld	a, [rP1]	; Check for key
	;bit	0, a		; Is right pressed
	;jr	z, right
	bit	1, a		; Is left pressed
	jr	z, left
	jr	loop
left:
	ld	a, [rP1]	; Wait until released
	bit     1, a
	jr	z, left
	push	de
	ld	hl, Blank	; Blank previous text
	ld	bc, TitleEnd-Title
	call	mem_CopyVRAM
	pop	de
	dec	de 		; Move back up char pos
        jr      loop
right:
	ld	a, [rP1]	; Check for key
	bit     0, a
	jr	z, right
	push	de
	ld	hl, Blank
	ld	bc, TitleEnd-Title
	call	mem_CopyVRAM
	pop	de
	inc	de 
        jr      loop
; ****************************************************************************************
; Prologue
; Wait patiently 'til somebody kills you
; ****************************************************************************************
wait:
	halt
	nop
	jr	wait
	
; ****************************************************************************************
; hard-coded data
; ****************************************************************************************
Title:
	DB	"Hello World !"
TitleEnd:
Blank:
	DB	"             "
WinTitle:
	DB	"Window"
WinTitleEnd:

; ****************************************************************************************
; StopLCD:
; turn off LCD if it is on
; and wait until the LCD is off
; ****************************************************************************************
StopLCD:
        ld      a,[rLCDC]
        rlca                    ; Put the high bit of LCDC into the Carry flag
        ret     nc              ; Screen is off already. Exit.

; Loop until we are in VBlank

.wait:
        ld      a,[rLY]
        cp      145             ; Is display on scan line 145 yet?
        jr      nz,.wait        ; no, keep waiting

; Turn off the LCD

        ld      a,[rLCDC]
        res     7,a             ; Reset bit 7 of LCDC
        ld      [rLCDC],a

        ret

