; bc - values to multiply (b * c)
; mutats: af, de, hl, b
; result loaded in hl
multiply:
        ld hl,0
        ld a,b
        or a
        ret z
        ld d,0
        ld e,c
multiply_loop:
        add hl,de
        djnz multiply_loop
        ret
