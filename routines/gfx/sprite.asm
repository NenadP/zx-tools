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

; Input:  
; - hl = sprite data
; - bc = sprite coords
; operation:
; bc - keep sprite coords
; de - sprite size, that is loaded from sprite data. We use this to control looping
; hl - sprite data, but also at one moment used for screen address
draw_sprite:
    ld a, (hl)             
    ld d, a                                 ; load x sprite size address into d
    inc hl
    ld a, (hl)
    ld e, a                                 ; load y sprite size address into e
    inc hl                                  ; hl now points to the first sprite data address
    call sprite_y_loop
    ret
sprite_y_loop:
    push bc                                 ; save bc, de so we can 
    push de                                 ; reset x size and x coord each y iteration
    call sprite_x_loop
    pop de                                  ; restore bc and de, so we can increase y cord
    pop bc                                  ; and decrease y size

    inc c                                   ; increase y coord
    dec e                                   ; decrease y size
    ld a, e
    cp 0
    jp nz, sprite_y_loop
    ret
sprite_x_loop:
    push de
    ld d, (hl)                              ; load 8 pixels of data into d
    inc hl                                  ; we can now go to next 8 pixel data address
    push hl                                 ; push hl, as we are going to load screen address into it
    call get_screen_address_from_coords     ; address is now in hl
    ld (hl), d                              ; lod 8 pixels into the screen address
    pop hl
    pop de
    
    ld a, b                                 ; increase x coord by 8 bytes,
    add a, 8                                ; as we are going to plot next 8 bytes in the next iteration
    ld b, a                                   

    dec d                                   ; decrease x size
    ld a, d                                 
    cp 0                                    ; if x size is 0
    jp nz, sprite_x_loop                    ; loop back
    ret 
