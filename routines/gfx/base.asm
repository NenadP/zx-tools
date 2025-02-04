clear_screen:
        ld hl, 16384        ; pixels
        ld de, 16385        ; pixels + 1
        ld bc, 6143         ; pixels area length - 1
        ld (hl), 0          ; set first byte to '0'
        ldir                ; copy bytes
        ret
