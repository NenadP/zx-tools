        org $8000
        call clear_screen

main_loop:
        call test_routine
        ret

test_routine:
        ld hl, smiley
        ld bc, $0909
        call draw_sprite
        ret


        INCLUDE sprites.asm
        INCLUDE ../routines/math/arithmetic.asm
        INCLUDE ../routines/gfx/print_character.asm
        INCLUDE ../routines/gfx/base.asm
        INCLUDE ../routines/gfx/sprite.asm


END $8000
