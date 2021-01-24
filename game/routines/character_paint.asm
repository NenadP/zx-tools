
print_image:                          ; print the characters (grahic characters) based on compressed data.

        ld ix, (image_address)

        ld a, 0x16                     ; positions intially the first character on xpos and ypos
        rst 0x10
        ld ix, (image_address)
        ld a, (ix+3)                  ; ypos
        rst 0x10
        ld a, (ix+2)                  ; y xpos
        rst 0x10

        ld a, 2                       ; Open Channel 2 (Screen)
        call #1601

        ld b, 1

image_line_loop:
        push bc
        push ix
        ld ix, (image_address)
        ld b, (ix+1)                  ; load number of characters in the line
        srl b                         ; divide by 2, as we will be printing 2 characters in one go
        pop ix
image_char_loop:
        ld a, (ix+4)                  ; loads compressed character data. each bit has 2 character definitions
        and %11110000                 ; mask first 4 bits, to use to match first character
        rrca                          ; rotate bits right 4 times, so we can use single map of characters
        rrca
        rrca
        rrca
        call get_char_from_half_byte  ; get the first character
        rst 0x10                      ; Print first the character

        ld a, (ix+4)                  ; load the compressed character again,
        and %00001111                 ; this time mask first 4 bits
        call get_char_from_half_byte  ; gets (the second) character
        rst 0x10                      ; Print the second character
        inc ix                        ; move to the next 2 characters
        djnz image_char_loop;

        pop bc
        push ix

        ld a, 0x16                       ; the subroutine moves AT to the next line - x position is always the same, but y will use increasing loop
        rst 0x10
        ld ix, (image_address)
        ld a, (ix+3)
        add a, b                       ; we add the iterator value b to a, to increase y position
        rst 0x10
        ld a, (ix+2)                   ; starting x position for the line stays the same
        rst 0x10

        inc b                          ; increasing loop iterator increased

        ld a, b                        ; the logic to stop looping, when b reaches image height. Loading iterator into a
        dec a
        ld d, (ix+1)                   ; image height loaded into d
        pop ix

        cp d                           ; if iterator reached image height, we exit the routine
        jp nz, image_line_loop
        ret

get_char_from_half_byte:               ; mapping to map compressed character data to actual spectrum character codes.
        cp %00000000                   ; for character codes see http://www.breakintoprogram.co.uk/computers/zx-spectrum/zx-spectrum-character-set
        jr z, char_80
        cp %00000100
        jr z, char_81
        cp %00001000
        jr z, char_82
        cp %00001100
        jr z, char_83
        cp %00000001
        jr z, char_84
        cp %00000101
        jr z, char_85
        cp %00001001
        jr z, char_86
        cp %00001101
        jr z, char_87
        cp %00000010
        jr z, char_88
        cp %00000110
        jr z, char_89
        cp %00001010
        jr z, char_8A
        cp %00001110
        jr z, char_8B
        cp %00000011
        jr z, char_8C
        cp %00000111
        jr z, char_8D
        cp %00001011
        jr z, char_8E
        cp %00001111
        jr z, char_8F
        ret

char_80:                               ; load characters into accumulator
        ld a, $80
        ret
char_81:
        ld a, $81
        ret
char_82:
        ld a, $82
        ret
char_83:
        ld a, $83
        ret
char_84:
        ld a, $84
        ret
char_85:
        ld a, $85
        ret
char_86:
        ld a, $86
        ret
char_87:
        ld a, $87
        ret
char_88:
        ld a, $88
        ret
char_89:
        ld a, $89
        ret
char_8A:
        ld a, $8A
        ret
char_8B:
        ld a, $8B
        ret
char_8C:
        ld a, $8C
        ret
char_8D:
        ld a, $8D
        ret
char_8E:
        ld a, $8E
        ret
char_8F:
        ld a, $8F
        ret
