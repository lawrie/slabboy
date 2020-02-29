; Hello World 1.0
; February 2, 2007
; John Harrison
; Based mostly from GALP

INCLUDE "gbhw.inc" ; standard hardware definitions from devrs.com
INCLUDE "ibmpc1.inc" ; ASCII character set from devrs.com

DPAD_DOWN						EQU		7
DPAD_UP							EQU		6
DPAD_LEFT						EQU		5
DPAD_RIGHT						EQU		4
START_BUTTON						EQU		3
SELECT_BUTTON						EQU		2
B_BUTTON						EQU		1
A_BUTTON						EQU		0

; IRQs
SECTION	"Vblank",ROM0[$0040]
	reti
SECTION	"LCDC",ROM0[$0048]
	reti
SECTION	"Timer_Overflow",ROM0[$0050]
	reti
SECTION	"Serial",ROM0[$0058]
	reti
SECTION	"p1thru4",ROM0[$0060]
	reti

; ****************************************************************************************
; boot loader jumps to here.
; ****************************************************************************************
SECTION	"start",ROM0[$0100]
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
	ld	[rBGP], a
	ld	a,3		; SET SCREEN TO TO UPPER RIGHT HAND CORNER
	ld	[rSCX], a
	ld	[rSCY], a		
	call	StopLCD		; YOU CAN NOT LOAD $8000 WITH LCD ON
	ld	hl, TileData
	ld	de, _VRAM	; $8000
	ld	bc, 8*256 	; the ASCII character set: 256 characters, each with 8 bytes of display data
	call	mem_CopyMono	; load tile data
	ld	a, LCDCF_ON|LCDCF_BG8000|LCDCF_BG9800|LCDCF_BGON|LCDCF_OBJ8|LCDCF_OBJON|LCDCF_WINON|LCDCF_WIN9C00
	ld	[rLCDC], a	
	ld	a, 112		; Create a Window
	ld	[rWY], a
	ld	a, 7
	ld	[rWX], a
	ld	a, 32		; ASCII FOR BLANK SPACE
	ld	hl, _SCRN0	; Clear the screen
	ld	bc, SCRN_VX_B * SCRN_VY_B
	call	mem_SetVRAM
	ld	a, 43		; ASCII +
	ld	hl, _SCRN1	; Fill window with + signs
	ld	bc, SCRN_VX_B * SCRN_VY_B
	call	mem_SetVRAM
	ld	hl, SpriteCache	; Create Sprite 0
	ld	a, 32		; x and y = 16
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc 	hl
	ld	a, 1		; Tile 1
	ld	[hl], a
	ld	de, _SCRN1	; Put title in windows
	ld	hl,WinTitle
	ld	bc, WinTitleEnd-WinTitle
	call	mem_CopyVRAM
; ****************************************************************************************
; Main code:
; Print a character string in the middle of the screen
; ****************************************************************************************
	ld	de, _SCRN0+3+(SCRN_VY_B*10) ; x = 3, y = 10
loop:
	ld	a, d			; Check that DE is within _SCRN0
	cp	$98
	jr	nc, ok1
	ld	de, _SCRN0
ok1:
	cp	$9c
        jr	C, ok2
	ld	de, _SCRN1-13
ok2:
	cp	$9b
	jr	c, ok3
	ld 	a, e
	cp 	$f4
	jr	c, ok3
	ld	de, _SCRN1-13
ok3:
	ld	hl,Title		; Copy Hello World to screen
	ld	bc, TitleEnd-Title
	push	de			; Save DE
	call	mem_CopyVRAM
	;ld	hl, SpriteCache		; Copy SpriteCache to OAM
	;ld	de, _OAMRAM		; Should use DMA
	;ld	bc, 160
	;call	mem_Copy
	ld	a, 0			; Sprite DMA - direct
	ld	[rDMA], a
	ld	a, $28
wait1:
	dec	a
	jr	nz, wait1
	call	READ_INPUT		; Read buttons
	pop	de			; restore DE
	ld	a, [joypad_down]
	and	a, $FB			; Test if any relevant button  pressed
	jr	z, loop
	push	de
	ld	hl, Blank		; Blank previous text
	ld	bc, TitleEnd-Title
	call	mem_CopyVRAM
	pop	de
	ld	a, [joypad_down]	; Test for specific buttons
	bit	DPAD_RIGHT, A
	jr	NZ, right
	bit	DPAD_LEFT, A
	jr	NZ, left
	bit	DPAD_DOWN, A
	jr	NZ, down
	bit	DPAD_UP, A
	jr	NZ, up
	bit	A_BUTTON, A
	jr	NZ, alignl
	bit	B_BUTTON, A
	jr	NZ, alignr
	bit	START_BUTTON, A
	jr	NZ, home1
	jr	loop
left:
	ld	hl, SpriteCache+1
	ld	a, [hl]
	sub	8
	ld	[hl], a
	dec	de 			; Move back up char pos
        jr      loop
right:
	ld	hl, SpriteCache+1	; Increment sprite xPos by 8
	ld	a, [hl]
	add	8
	ld	[hl], a
	inc	de 
        jr      loop
down:
	ld	hl, SpriteCache
	ld	a, [hl]
	add	8
	ld 	[hl], a
	ld 	b ,32
down1:
	inc	de
	dec	b
	jr	nz, down1
	jp	loop
up:
	ld	hl, SpriteCache
	ld	a, [hl]
	sub	8
	ld	[hl], a
	ld 	b ,32
up1:
	dec	de
	dec	b
	jr	nz, up1
	jp	loop
alignl:
	srl	e			; Align text to left
	srl	e
	srl	e
	srl	e
	srl	e
	sla	e
	sla	e
	sla	e
	sla	e
	sla	e
	jp	loop
alignr:
	srl	e			; Align text to right
	srl	e
	srl	e
	srl	e
	srl	e
	sla	e
	sla	e
	sla	e
	sla	e
	sla	e
	ld	a, 7
	add	a, e
	ld 	e, a
	jp	loop
home1:
	ld	de, _SCRN0
	jp	loop
; ****************************************************************************************
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

; Read the joypad. Loads two variables:
;	joypad_held	- what buttons are currently held
;	joypad_down	- what buttons went down since last joypad read
; Code from "Game Boy test 4" from Doug Lanford (opus@dnai.com)
;-----------------------------------------------------------------------
READ_INPUT:
	; get the d-pad buttons
	LD		A, 		P1F_5			; select d-pad
	LDH		[rP1], A		; send it to the joypad
	LDH		A, 		[rP1]
	LDH		A, 		[rP1]
	LDH		A, 		[rP1]
	LDH		A, 		[rP1]
	LDH		A, 		[rP1]
	LDH		A, 		[rP1]	; get the result back (takes a few cycles)
	CPL							; bit-flip the result
	AND		$0F			; mask out the output bits
	SWAP	A				; put the d-pad button results to top nibble
	LD		B, 		A	; and store it

	; get A / B / SELECT / START buttons
	LD		A, 		P1F_4	; select buttons
	LDH		[rP1], A		; send it to the joypad
	LDH		A, 		[rP1]
	LDH		A, 		[rP1]
	LDH		A, 		[rP1]
	LDH		A, 		[rP1]
	LDH		A, 		[rP1]
	LDH		A, 		[rP1]	; get the result back (takes even more cycles?)
	CPL							;	 bit-flip the result
	AND		$0F	; mask out the output bits
	OR		B					; add it to the other button bits
	LD		B, 		A		; put it back in c

	; calculate the buttons that went down since last joypad read
	LD		A, 		[joypad_held]	; grab last button bits
	CPL							; invert them
	AND		B					; combine the bits with current bits
	LD		[joypad_down], A	; store just-went-down button bits

	LD		A, 		B
	LD		[joypad_held], A	; store the held down button bits

	LD		A,	 	$30	; reset joypad
	LDH		[rP1], A

	RET

; Internal RAM
;-------------
SECTION	"Sprite_Cache", WRAM0[$C000]
SpriteCache:
DS		160		; Sprite definitions that are copied to OAM by DMA

SECTION	"RAM_Other_Variables", WRAM0[$C0A0]

joypad_held:
DS		1		; what buttons are currently held
joypad_down:
DS		1		; what buttons went down since last joypad read
