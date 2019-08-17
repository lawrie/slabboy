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

ld b, 0
ld hl, hello

loop:
ld a,[hl+]
cp 0
jp z, done
inc b
jp loop

done:
halt


hello:
db "Hello World\n!"



