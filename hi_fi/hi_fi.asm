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

        org $8000
        call clear_screen

main_loop:
        call test_screen_address_routine
        ret

test_routine:
        ld hl, smiley
        ld bc, $0909
        call draw_sprite
        ret

        ld b, 0
        ld c, 0

; this just draws diagonal set of black blocks.
test_screen_address_routine:
        call get_screen_address_from_coords
        ld (hl), 255
        inc b
        inc c
        ld a, c
        cp 192
        jp nz, test_screen_address_routine
        endless: nop
        jp endless

        INCLUDE sprites.asm
        INCLUDE ../routines/math/arithmetic.asm
        INCLUDE ../routines/gfx/print_character.asm
        INCLUDE ../routines/gfx/base.asm
        INCLUDE ../routines/gfx/sprite.asm


END $8000
