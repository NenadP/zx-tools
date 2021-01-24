        org 40000

        call clear_screen

image_address:
        defb #00

        ld b, 1
main_loop:
        push bc
        call lsss_aa
        pop bc
        djnz main_loop
        ret

test_routine:

        ld hl, image_sample
        ld (image_address), hl
        call print_image
        ld hl, attribute_sample
        ld (image_address), hl
        call print_attributes
        ret

        INCLUDE images/images.asm
        INCLUDE routines/util/math_util.asm
        INCLUDE routines/util/gfx_util.asm
        INCLUDE routines/attribute_paint.asm
        INCLUDE routines/character_paint.asm

END 40000
