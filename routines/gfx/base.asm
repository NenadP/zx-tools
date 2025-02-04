clear_screen:
        ld hl, 16384        ; pixels
        ld de, 16385        ; pixels + 1
        ld bc, 6143         ; pixels area length - 1
        ld (hl), 0          ; set first byte to '0'
        ldir                ; copy bytes
        ret

; Input:        
; hl = coords data (x, y)
; Output: 
; - bc = adjusted coords (x, y)
; - de = offset (x, y) - offset from the adjusted coords
;
; Description:
; Since the ZX Spectrum pixels can't be individually addressed, we need to adjust the coordinates
; to the nearest 8x8 pixel block. In a nutshell, we drop the 3 least significant bits of the x and y
; to get to the nearest 8x8 pixel block starting point.
; We also calculate the offset from the starting point to the actual x and y coordinates, by storing
; the 3 least significant bits of the x and y in d and e.
ld h, $C
ld l, $C
get_adjusted_coords:
        ld a, h
        and %11111000
        ld b, a
        
        ld a, l
        and %11111000
        ld c, a

        ld a, h
        and %00000111
        ld d, a
        
        ld a, l
       and %00000111
        ld e, a

        ret
