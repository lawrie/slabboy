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

set 0, b
set 1, b
set 2, b
set 3, b
set 4, b
set 5, b
set 6, b
set 7, b

res 0, b
res 1, b
res 2, b
res 3, b
res 4, b
res 5, b
res 6, b
res 7, b

halt

