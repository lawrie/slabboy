SECTION "ROM0", ROM0
cp 0
jp nz, lab1
inc a
inc b
lab1:
inc c
halt               ; opcode 0x76


data1:
db $99



