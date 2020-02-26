SECTION "ROM0", ROM0

ld de, 0
dec de
ld bc, $ffff
inc bc
halt

