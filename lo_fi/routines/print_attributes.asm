
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

print_attributes:                     ; attribute data - load attribute set in ix REGISTER
                                      ; first byte: width, second: height; third: xpos, fourth: ypos; 5th: start of attribute data
        ld ix, (image_address)
                                      ; Move the attribute data to x,y position
        ld b, 32                      ; lenght of line (characters)
        ld c, (ix+3)                  ; ypos
        call multiply                 ; b * c
        ld de, $5800
        add hl, de                    ; move to ypos
        ld b, 0
        ld c, (ix+2)                  ; xpos
        add hl, bc                    ; move to xpos

        ld b, (ix+1)                  ; height of the attribute area - for the outer loop.
                                      ; represents 'height'
attr_lines_loop:
        push bc
        push ix
        ld ix, (image_address)
        ld b, (ix)                    ; width of the attribute area
        pop ix

attr_char_loop:
        ld a, (ix+4)                  ; start reading from 4 byte - start of attribute data
        ld (hl), a                    ; load attribute onto screen
        inc hl
        inc ix
        djnz attr_char_loop           ; inner loop - loop over characters in line

        ld a, 32                      ; number of attributes in each line
                                      ; we are calculating how many characters we need to skip
        push ix
        ld ix, (image_address)
        sub (ix)                      ; substract width (stored in first byte of attributes)
        pop ix

        ld d, 0
        ld e, a
        add hl, de                    ; increase memory addres by number of characters to skip
        pop bc                        ; restore bc as b is used in outer loop

        djnz attr_lines_loop          ; outer loop is over each line
        ret
