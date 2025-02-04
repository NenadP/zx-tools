; Adopted from http://www.breakintoprogram.co.uk/computers/zx-spectrum/assembly-language/z80-tutorials/print-in-assembly-language
; by Dean Belfield

; Print a single character out to a screen address
; hl: address of 8x8 sprite
; d: character Y position
; e: character X position
;
print_char:
        call get_char_address   ; Get screen position in de
        ld b,8                  ; Loop counter - 8 bytes per character
print_char_line:
        ld a,(hl)               ; Get the byte from the sprite address into a
        ld (de),a               ; print a onto the screen (de has current memory address)
        inc hl                  ; Goto next byte of character
        inc d                   ; Goto next line on screen
        djnz print_char_line      ; Loop around whilst b is not zero
        ret

; Get screen address from a character (x,y) coordinate
; d = y character position (0-23)
; e = x character position (0-31)
; Returns screen address in de
;
get_char_address:       LD a,d
        and %00000111
        rra
        rra
        rra
        rra
        or e
        ld e,a
        ld a,d
        and %00011000
        or %01000000
        ld d,a
        ret                     ; Returns screen address in DE
