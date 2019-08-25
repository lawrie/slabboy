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

; Set tile 0 to 0
ld a, $00
ld hl, _SCRN0
ld [hl+], a

; Set texture 0
ld a, $aa
ld hl, _VRAM
ld [hl+], a
ld [hl+], a
ld [hl+], a
ld [hl+], a
ld [hl+], a
ld [hl+], a
ld [hl+], a
ld [hl+], a
ld [hl+], a
ld [hl+], a
ld [hl+], a
ld [hl+], a
ld [hl+], a
ld [hl+], a
ld [hl+], a
ld [hl+], a

loop:
inc d
jr nz, loop
inc c
jr nz, loop
inc a
jp loop

INCLUDE "memory.asm"

TileData:
  chr_IBMPC1 1,4

halt

