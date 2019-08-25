INCLUDE "gbhw.inc"
INCLUDE "ibmpc1.inc"

SECTION "ROM0", ROM0
jp start

SECTION "Rst8", ROM0[$08]
halt

SECTION "Rst10", ROM0[$10]
halt

SECTION "Rst18", ROM0[$18]
halt

SECTION "Rst20", ROM0[$20]
halt

SECTION "Rst28", ROM0[$28]
halt

SECTION "Rst30", ROM0[$30]
halt

SECTION "Rst38", ROM0[$38]
halt

SECTION "Start", ROM0[$100]
start:

	ld	hl, TileData
	ld	de, _VRAM		; $8000
	ld	bc, 8*128 		; the ASCII character set: 128 characters, each with 8 bytes of display data
	call	mem_CopyMono	; load tile data

	ld	a, 32		; ASCII FOR BLANK SPACE
	ld	hl, _SCRN0
	ld	bc, SCRN_VX_B * SCRN_VY_B
	call	mem_Set

	ld	hl,Title
	ld	de, _SCRN0+3+(SCRN_VY_B*7) ; 
	ld	bc, TitleEnd-Title
	call	mem_Copy
;halt
; Flash leds (A register)
loop:
	inc d
	jr nz, loop
	inc c
	jr nz, loop
	inc a
	jp loop

INCLUDE "memory.asm"

Title:
	DB	"Hello World !"
TitleEnd:
SECTION "TileData", ROM0[$200]

TileData:
  chr_IBMPC1 1,4

halt

