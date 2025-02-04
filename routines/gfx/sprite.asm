screen_address defb $40, $00

sprite_coords_address:
        defb $00, $00
sprite_size_address:
        defb $00, $00        
sprite_data_address:
        defb $00, $00

unpack_sprite_header:
    ld a, b
    ld (sprite_coords_address), a
    ld a, c
    ld (sprite_coords_address + 1), a

    ld a, h
    ld (sprite_size_address), a
    inc hl

    ld a, l
    ld (sprite_size_address + 1), a
    inc hl

    ld a, h
    ld (sprite_data_address), a
    ld a, l
    ld (sprite_data_address + 1), a
    ret

; hl = sprite data
; bc = sprite coords
draw_sprite:
    call unpack_sprite_header
    ld a, (sprite_size_address)
    ld d, a
    ld a, (sprite_size_address + 1)
    ld e, a

    call sprite_y_loop

    ; ld a, (screen_address + 1)
    ; adc a, 32
    ; ld (screen_address + 1), a

    ret
sprite_y_loop:
    ld b, e
    push bc
    call sprite_x_loop
    pop bc
    dec b
    djnz sprite_y_loop
    ret

sprite_x_loop:
    ld b, d

    ld a, (sprite_data_address)
    ld h, a
    ld a, (sprite_data_address + 1)
    ld l, a

    ld c, (hl)
    inc hl

    ld a, h
    ld (sprite_data_address), a
    ld a, l
    ld (sprite_data_address + 1), a

    ld a, (screen_address)
    ld h, a
    ld a, (screen_address + 1)
    ld l, a

    ld (hl), c
    inc hl

    ld a, h
    ld (screen_address), a
    ld a, l
    ld (screen_address + 1), a

    dec b
    djnz sprite_x_loop
    ret 



