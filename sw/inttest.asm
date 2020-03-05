SECTION "ROM0", ROM0
jp begin

SECTION "Timer", ROM0[$50]
;halt
reti

SECTION "Start", ROM0[$100]
begin:
ld a, 0
loop:
dec a
jr nz, loop
halt

