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

clear_screen:
        ld hl, 16384        ; pixels
        ld de, 16385        ; pixels + 1
        ld bc, 6143         ; pixels area length - 1
        ld (hl), 0          ; set first byte to '0'
        ldir                ; copy bytes
        ret

; Input:        
; - bc = coords data (x, y)
; Output: 
; - hl = adjusted coords (x, y)
; - de = offset (x, y) - offset from the adjusted coords
;
; Description:
; Since the ZX Spectrum pixels can't be individually addressed, we need to adjust the coordinates
; to the nearest 8x8 pixel block. In a nutshell, we drop the 3 least significant bits of the x and y
; to get to the nearest 8x8 pixel block starting point.
; We also calculate the offset from the starting point to the actual x and y coordinates, by storing
; the 3 least significant bits of the x and y in d and e.
get_adjusted_coords:
        ld a, b
        and %11111000
        ld h, a
        
        ld a, c
        and %11111000
        ld l, a

        ld a, h
        and %00000111
        ld d, a
        
        ld a, l
       and %00000111
        ld e, a

        ret

; Input:        
; - bc = coords data (x, y)
; Output: 
; - hl = screen address
;
; We need to account for the specific ZX Spectrum screen layout,
; which is screen resolution is 256px(x) x 192px(y)
; The mapping goes like this:
;
; H                      L
; 0 1 0 y7 y6 y2 y1 y0   y5 y4 y3 x7 x6 x5 x4 x3 x2 x1 x0
;
get_screen_address_from_coords:
; first we deal with the x bits - loaded from b register of bc
; we shift the bits 3 times to the right, effectively dividing it by 8,
; this is because x position in the layout above is 8 bits long.
; we will restore the offset in the other procedure.     
        ld a, b
        srl a
        srl a
        srl a
        ld l, a
; lets now deal with y5, y4, y3, to complete l register
; according to the above layout, we need to take c (y coord) and shift it 
; 2 times to the left.
        ld a, c
        sla a
        sla a         
; lets not take only the bits we need
        and %11100000
; and add it to the l
        add a, l
        ld l, a                

; now we deal with the h bits of hl. First lets position y7 and y6 in the right place.
; we need tho shift c (y location) 3 times to the right first...
        ld a, c
        srl a
        srl a
        srl a      
; then, let's take only 2 relevant bits
        and %00011000
        ld h, a
; lets now add y2, y1 and y0 which are already in correct position
        ld a, c
        and %00000111
        add a, h
        ld h, a
; lastly, we need to add 010 to h as this is the zx spectrum screen address ($4000, 16384)
        ld a, %01000000
        add a, h
        ld h, a
        ret
