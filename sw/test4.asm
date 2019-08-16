SECTION "ROM0", ROM0
ld b, $12
ld c, $34

push bc

ld b, 0
ld c, 0

pop bc

halt               ; opcode 0x76


data1:
db $99



