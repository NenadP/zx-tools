;;; ------------------------------------------------------------------
;;; Routine License
;;; ------------------------------------------------------------------
;;;
;;; Copyright (C) 2025 - present, Nenad Pantic
;;;
;;; Permission is granted to use, copy, modify, and distribute
;;; this software with attribution. Provided "as is", without warranty.
;;; The author is not liable for any damages resulting from its use.
;;;
;;; ------------------------------------------------------------------

; This routine fills the screen memory with 1s, effectively filling the screen
; with ink (black) color. The ZX Spectrum divides the screen into three thirds
; of 64 lines each, which don't progress sequentially in memory, but are
; interleaved. The memory addresses that refer to each screen byte (pixel area)
; are coded in this way:
; H         L
; 010B BCCC DDDE EEEE
;
; Where:
; B is the third (0 to 2),
; C is the character (0 to 8),
; D is the row (0 to 7) and
; E is the column (0 to 31).
     
   
start: equ $8000
    org start
    ; we start with the hl holding the start screen memory address,
    ; in hexadecimal $4000, in decimal 16384
    ld h, %01000000
    ld l, %00000000 

    ld b, h ; track area value
    ld c, h ; track character value
    ld d, l ; track row value
    ld e, l ; track column value

; Columns loop iterates 32 times to cover all x positions
; it is L value of HL register, last 5 bits e.g. 000xxxxx
columns_loop:
    ld b, %01000000
    call area_loop
    ld a, e
    add a, %00000001
    cp %00011111
    jr z, Exit
    ld a, e
    add a, %00000001
    ld e, a
    ld l, a
    jr columns_loop

; Area loop iterates 3 times to cover three areas of the screen
; it is H value of HL register,  bits 4,5 000xx000
; the values are: 00 - 1st area, 01 - 2nd area, 10 - 3rd area
; 11 - not used
area_loop:
    ld d, $00
    call rows_loop
    ld a, b
    and %00010000
    cp %00010000
    ret z
    ld a, b
    add a, %00001000
    ld b, a
    ld h, a
    jr area_loop 

; Rows loop iterates 8 times to cover all rows inside th area
; it is L value of HL register, last 3 bits e.g. xxx00000
rows_loop:
    ld c, $00 
    ld a , d
    or e
    ld l, a
    call character_loop
    ld a, d
    cp %11100000
    ret z
    ld a, d
    add a, %00100000
    ld d, a
    ld l, a
    jr rows_loop

; Once we selected the area, column and row, we need to fill the character
; for demonstration purposes we fill it with %11111111 so we will end up with
; a black screen. We iterate 8 times to fill the character (8x8 pixels)
; it is H value of HL register, first 3 bits e.g. 00000xxx
character_loop:
    ld a, c
    or b
    ld h, a
    ld (hl), %11111111 
    ld a, c
    and %00000111
    cp  %00000111
    ret z
    inc c
    jr character_loop

Exit:
    ret
    end $8000
       