SECTION "ROM0", ROM0
nop                ; opcode 0x00
ld bc, data1       ; opcode 0x01
ld [bc], a         ; opcode 0x02
inc bc             ; opcode 0x03
inc b              ; opcode 0x04
dec b              ; opcode 0x05
ld b, $42          ; opcode 0x06
ld a, $42
rlca               ; opcode 0x07
ld [$0099], sp     ; opcode 0x08
add hl, bc         ; opcode 0x09
ld a, [bc]         ; opcode 0x0a
dec bc             ; opcode 0x0b
inc c              ; opcode 0x0c
dec c              ; opcode 0x0d
ld c, $56          ; opcode 0x0e
ld a,$42
rrca               ; opcode 0x0f
stop               ; opcode 0x10
ld de,$1234        ; opcode 0x11
ld [de], a         ; opcode 0x12
inc de             ; opcode 0x13
inc d              ; opcode 0x14
dec d              ; opcode 0x15
ld d,$73           ; opcode 0x16
rla                ; opcode 0x17
jr lab1            ; opcode 0x18
inc a
inc a
inc a
lab1:
add hl, de         ; opcode 0x19
ld a, [de]         ; opcode 0x1a
dec de             ; opcode 0x1b
inc e              ; opcode 0x1c
dec e              ; opcode 0x1d
ld e,$99           ; opcode 0x1e
rra                ; opcode 0x1f

halt               ; opcode 0x76


data1:
db $99



