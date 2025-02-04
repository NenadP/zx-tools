character_paint_cursor:
        defb #00, #00

print_lofi_image:                           ; print the characters (graphic characters) based on compressed data.

        ld ix, (image_address)
        ld d, (ix+3)                        ; y
        ld e, (ix+2)                        ; x
        ld (character_paint_cursor), de

        ld b, (ix+1)                        ; load number of lines

image_line_loop:
        push bc
        push ix                             ; preserve ix as we will use it for character source
        ld ix, (image_address)
        ld b, (ix)                          ; load number of characters in the line
        srl b                               ; divide by 2, as we will be printing 2 characters in one go
        pop ix
image_char_loop:
        push bc
        ld de, (character_paint_cursor)     ; get x, y

        ld a, (ix+4)                        ; loads compressed character data. each bit has 2 character definitions
        and %11110000                       ; mask first 4 bits, to use to match first character
        rrca                                ; rotate bits right 4 times, so we can use single map of characters
        rrca
        rrca
        rrca

        call get_char_print_and_advance_x

        ld a, (ix+4)                        ; load the compressed character again,
        and %00001111                       ; this time mask first 4 bits

        call get_char_print_and_advance_x

        inc ix                              ; move to the next 2 characters

        pop bc
        djnz image_char_loop
        pop bc
                                            ; we want to restore x position to the cursor, but move y as we need to paint next line
        ld de, (character_paint_cursor)     ; get x, y
        inc d                               ; advance y
        push ix
        ld ix, (image_address)
        ld e, (ix+2)                        ; restore x
        pop ix
        ld (character_paint_cursor), de

        djnz image_line_loop
        ret

get_char_print_and_advance_x:
        call get_char_from_half_byte        ; get the first character
        call print_char               ; Print first the character

        ld de, (character_paint_cursor)     ; get x, y
        inc e                               ; advance x
        ld (character_paint_cursor), de     ; save new x, y
        ret

get_char_from_half_byte:                    ; mapping to map compressed character data to actual spectrum character codes.
        cp %00000000                        ; for character codes see http://www.breakintoprogram.co.uk/computers/zx-spectrum/zx-spectrum-character-set
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


char_80:                               ; load character definition in hl
        ld hl, char_80_gfx
        ret
char_81:
        ld hl, char_81_gfx
        ret
char_82:
        ld hl, char_82_gfx
        ret
char_83:
        ld hl, char_83_gfx
        ret
char_84:
        ld hl, char_84_gfx
        ret
char_85:
        ld hl, char_85_gfx
        ret
char_86:
        ld hl, char_86_gfx
        ret
char_87:
        ld hl, char_87_gfx
        ret
char_88:
        ld hl, char_88_gfx
        ret
char_89:
        ld hl, char_89_gfx
        ret
char_8A:
        ld hl, char_8A_gfx
        ret
char_8B:
        ld hl, char_8B_gfx
        ret
char_8C:
        ld hl, char_8C_gfx
        ret
char_8D:
        ld hl, char_8D_gfx
        ret
char_8E:
        ld hl, char_8E_gfx
        ret
char_8F:
        ld hl, char_8F_gfx
        ret

;character definitions
char_80_gfx:
        defb %00000000,%00000000,%00000000,%00000000,%00000000,%00000000,%00000000,%00000000
char_81_gfx:
        defb %00001111,%00001111,%00001111,%00001111,%00000000,%00000000,%00000000,%00000000
char_82_gfx:
        defb %11110000,%11110000,%11110000,%11110000,%00000000,%00000000,%00000000,%00000000
char_83_gfx:
        defb %11111111,%11111111,%11111111,%11111111,%00000000,%00000000,%00000000,%00000000
char_84_gfx:
        defb %00000000,%00000000,%00000000,%00000000,%00001111,%00001111,%00001111,%00001111
char_85_gfx:
        defb %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111
char_86_gfx:
        defb %11110000,%11110000,%11110000,%11110000,%00001111,%00001111,%00001111,%00001111
char_87_gfx:
        defb %11111111,%11111111,%11111111,%11111111,%00001111,%00001111,%00001111,%00001111
char_88_gfx:
        defb %00000000,%00000000,%00000000,%00000000,%11110000,%11110000,%11110000,%11110000
char_89_gfx:
        defb %00001111,%00001111,%00001111,%00001111,%11110000,%11110000,%11110000,%11110000
char_8A_gfx:
        defb %11110000,%11110000,%11110000,%11110000,%11110000,%11110000,%11110000,%11110000
char_8B_gfx:
        defb %11111111,%11111111,%11111111,%11111111,%11110000,%11110000,%11110000,%11110000
char_8C_gfx:
        defb %00000000,%00000000,%00000000,%00000000,%11111111,%11111111,%11111111,%11111111
char_8D_gfx:
        defb %00001111,%00001111,%00001111,%00001111,%11111111,%11111111,%11111111,%11111111
char_8E_gfx:
        defb %11110000,%11110000,%11110000,%11110000,%11111111,%11111111,%11111111,%11111111
char_8F_gfx:
        defb %11111111,%11111111,%11111111,%11111111,%11111111,%11111111,%11111111,%11111111
