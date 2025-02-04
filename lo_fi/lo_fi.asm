        org 40000

        call clear_screen

image_address:
        defb #00, #00

        ld b, 100

main_loop:
        push bc
        call test_routine
        pop bc
        djnz main_loop
        ret

test_routine:
        ld hl, image_sample
        ld (image_address), hl
        call print_lofi_image

        call clear_screen

        ld hl, attribute_sample
        ld (image_address), hl
        call print_attributes
        ret


        INCLUDE images/images.asm
        INCLUDE ../routines/math/arithmetic.asm
        INCLUDE ../routines/gfx/print_character.asm
        INCLUDE ../routines/gfx/base.asm
        INCLUDE ./routines/print_attributes.asm
        INCLUDE ./routines/print_lofi_image.asm


END 40000
