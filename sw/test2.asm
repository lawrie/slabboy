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
jr nz, lab2        ; opcode 0x20
inc a
lab2:
ld hl, $1234       ; opcode 0x21
ld [hl+], a        ; opcode 0x22
inc hl             ; opcode 0x23
inc h              ; opcode 0x24
dec h              ; opcode 0x25
ld h,$aa           ; opcode 0x26
daa                ; opcode 0x27
jr z, lab3         ; opcode 0x28
inc a
lab3:
add hl, hl         ; opcode 0x29
ld a, [hl+]        ; opcode 0x2a
dec hl             ; opcode 0x2b
inc l              ; opcode 0x2c
dec l              ; opcode 0x2d
ld l, $55          ; opcode 0x2e
cpl                ; opcode 0x2f
jr nc, lab4        ; opcode 0x30
inc a
lab4:
ld sp, $0400       ; opcode 0x31
ld [hl-], a        ; opcode 0x32
inc sp             ; opcode 0x33
inc [hl]           ; opcode 0x34
dec [hl]           ; opcode 0x35
ld [hl], $42       ; opcode 0x36
scf                ; opcode 0x37
jr c, lab5         ; opcode 0x38
inc a
lab5:
add hl, sp         ; opcode 0x39
ld a,[hl-]         ; opcode 0x3a
dec sp             ; opcode 0x3b
inc a              ; opcode 0x3c
dec a              ; opcode 0x3d
ld a, $42          ; opcode 0x3e
ccf                ; opcode 0x3f
ld b, b            ; opcode 0x40
ld b, c            ; opcode 0x41
ld b, d            ; opcode 0x42
ld b, e            ; opcode 0x43
ld b, h            ; opcode 0x44
ld b, l            ; opcode 0x45
ld b, [hl]         ; opcode 0x46
ld b, a            ; opcode 0x47
ld c, b            ; opcode 0x48
ld c, c            ; opcode 0x49
ld c, d            ; opcode 0x4a
ld c, e            ; opcode 0x4b
ld c, h            ; opcode 0x4c
ld c, l            ; opcode 0x4d
ld c, [hl]         ; opcode 0x4e
ld c, a            ; opcode 0x4f
ld d, b            ; opcode 0x50
ld d, c            ; opcode 0x51
ld d, d            ; opcode 0x52
ld d, e            ; opcode 0x53
ld d, h            ; opcode 0x54
ld d, l            ; opcode 0x55
ld d, [hl]         ; opcode 0x56
ld d, a            ; opcode 0x57
ld e, b            ; opcode 0x58
ld e, c            ; opcode 0x59
ld e, d            ; opcode 0x5a
ld e, e            ; opcode 0x5b
ld e, h            ; opcode 0x5c
ld e, l            ; opcode 0x5d
ld e, [hl]         ; opcode 0x5e
ld e, a            ; opcode 0x5f
ld h, b            ; opcode 0x60
ld h, c            ; opcode 0x61
ld h, d            ; opcode 0x62
ld h, e            ; opcode 0x63
ld h, h            ; opcode 0x64
ld h, l            ; opcode 0x65
ld h, [hl]         ; opcode 0x66
ld h, a            ; opcode 0x67
ld l, b            ; opcode 0x68
ld l, c            ; opcode 0x69
ld l, d            ; opcode 0x6a
ld l, e            ; opcode 0x6b
ld l, h            ; opcode 0x6c
ld l, l            ; opcode 0x6d
ld l, [hl]         ; opcode 0x6e
ld l, a            ; opcode 0x6f
ld [hl], b         ; opcode 0x70
ld [hl], c         ; opcode 0x71
ld [hl], d         ; opcode 0x72
ld [hl], e         ; opcode 0x73
ld [hl], h         ; opcode 0x74
ld [hl], l         ; opcode 0x75

ld [hl], a         ; opcode 0x77
ld a, b            ; opcode 0x78
ld a, c            ; opcode 0x79
ld a, d            ; opcode 0x7a
ld a, e            ; opcode 0x7b
ld a, h            ; opcode 0x7c
ld a, l            ; opcode 0x7d
ld a, [hl]         ; opcode 0x7e
ld a, a            ; opcode 0x7f

add a, b           ; opcode 0x80
add a, c           ; opcode 0x81
add a, d           ; opcode 0x82
add a, e           ; opcode 0x83
add a, h           ; opcode 0x84
add a, l           ; opcode 0x85
add a, [hl]        ; opcode 0x86
add a, a           ; opcode 0x87
adc a, b           ; opcode 0x88
adc a, c           ; opcode 0x89
adc a, d           ; opcode 0x8a
adc a, e           ; opcode 0x8b
adc a, h           ; opcode 0x8c
adc a, l           ; opcode 0x8d
adc a, [hl]        ; opcode 0x8e
adc a, a           ; opcode 0x8f

sub a, b           ; opcode 0x90
sub a, c           ; opcode 0x91
sub a, d           ; opcode 0x92
sub a, e           ; opcode 0x93
sub a, h           ; opcode 0x94
sub a, l           ; opcode 0x95
sub a, [hl]        ; opcode 0x96
sub a, a           ; opcode 0x97
sbc a, b           ; opcode 0x98
sbc a, c           ; opcode 0x99
sbc a, d           ; opcode 0x9a
sbc a, e           ; opcode 0x9b
sbc a, h           ; opcode 0x9c
sbc a, l           ; opcode 0x9d
sbc a, [hl]        ; opcode 0x9e
sbc a, a           ; opcode 0x9f

and a, b           ; opcode 0xa0
and a, c           ; opcode 0xa1
and a, d           ; opcode 0xa2
and a, e           ; opcode 0xa3
and a, h           ; opcode 0xa4
and a, l           ; opcode 0xa5
and a, [hl]        ; opcode 0xa6
and a, a           ; opcode 0xa7
xor a, b           ; opcode 0xa8
xor a, c           ; opcode 0xa9
xor a, d           ; opcode 0xaa
xor a, e           ; opcode 0xab
xor a, h           ; opcode 0xac
xor a, l           ; opcode 0xad
xor a, [hl]        ; opcode 0xae
xor a, a           ; opcode 0xaf

or a, b            ; opcode 0xb0
or a, c            ; opcode 0xb1
or a, d            ; opcode 0xb2
or a, e            ; opcode 0xb3
or a, h            ; opcode 0xb4
or a, l            ; opcode 0xb5
or a, [hl]         ; opcode 0xb6
or a, a            ; opcode 0xb7
cp a, b            ; opcode 0xb8
cp a, c            ; opcode 0xb9
cp a, d            ; opcode 0xba
cp a, e            ; opcode 0xbb
cp a, h            ; opcode 0xbc
cp a, l            ; opcode 0xbd
cp a, [hl]         ; opcode 0xbe
cp a, a            ; opcode 0xbf

;ret nz             ; opcode 0xc0
pop bc             ; opcode 0xc1

;rst $00            ; opcode 0xc7

halt               ; opcode 0x76

data1:
db $99



