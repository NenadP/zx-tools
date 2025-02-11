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
        call test_routine
        ret

test_routine:
 
        ld a, 0
        ld bc, $0000
moving_sprite_loop:
        ld hl, smiley
        
        push af
        push bc
        call draw_sprite
        pop bc
        pop af
        inc a
        ld b, a
        ld c, a
        cp 150
        jp nz, moving_sprite_loop
        ; now in reverse
        ld a, 150
        ld bc, $0000
        ld b, a
        ld c, a
moving_sprite_loop_reverse:
        ld hl, smiley
        push af
        push bc
        call draw_sprite
        pop bc
        pop af
        dec a
        ld b, a
        ld c, a
        cp 0
        jp nz, moving_sprite_loop_reverse
        ; keep looping forever
        jp moving_sprite_loop
        ret


;this just draws diagonal set of black blocks.
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

end $8000