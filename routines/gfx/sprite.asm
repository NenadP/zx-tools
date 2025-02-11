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
    call sprite_y_loop_check_overlap
    ret
sprite_y_loop_check_overlap:

    ld a, b                                 ; in case the sprite is not perfectly lying on
    and %00000111                           ; the x printing address,
    cp 0                                    ; (comparing if there is no remainder)
    jr z, sprite_y_loop          ; (if there is no remainder, its nz, so don't increase size by 1)
    ld a, d                                 ; we will add extra 1 point of size
    add a, 1
    ld d, a
sprite_y_loop:
    push bc                                 ; save bc, de so we can 
    push de                                 ; reset x size and x coord each y iteration
    ld ixl, d                                ; we will use ix to track where are we in iteration
    call sprite_x_loop
    pop de                                  ; restore bc and de, so we can increase y cord
    pop bc                                  ; and decrease y size

    inc c                                   ; increase y coord
    dec e                                   ; decrease y size
    ld a, e
    cp 0
    jr nz, sprite_y_loop
    ret
sprite_x_loop:
    push de

    ld a, b                                 ; in case the sprite is perfectly lying on
    and %00000111                           ; the x printing address,
    cp 0                                    ; 
    jr z, sprite_x_loop_no_overlap          ; we can advance without change
    ld a, d                                 ; load the sprite size
    cp ixl                                  ; if this is not the first iteration,
    jr nz, check_x_loop_last_iteration      ; jump to last iteration check
    ld d, (hl)                              ; load the 8 pixels of data into d
    inc hl                                  ; increment hl to get to the next 8 pixels of data
    ld a, b                                 ; see how many times need to shift
    and %00000111                           ; number of times to shift
sprite_x_shift_head_loop:    
    srl d                                   ; shift right  
    dec a
    jr nz, sprite_x_shift_head_loop         ; loop until we shift all the bits
    jr sprite_x_with_overlap                ; once we shift all the bits, we can proceed with plotting

check_x_loop_last_iteration:
    ld a, d                                 ; load the sprite size
    cp 1                                    ; check if this is the last iteration
    jr nz, check_x_middle_iteration         ; if not, jump to middle iteration
    dec hl                                  ; decrement hl, as we are going to load 8 pixels of data from previous address
    ld d, (hl)                              ; load 8 pixels of data into d
    inc hl                                  ; increment hl to get back where we were
                                            ; note: we are not incrementing hl here as we are on the last iteration

    push bc                                 ; since we are going to shift bits to the left,    
    ld a, b                                 ; we need to shift 8 - offset times
    and %00000111                           ; we first find the offset (b last 3 bits)
    ld b, a                                 ; and then we subtract it from 8
    ld a, 8
    sub b
    pop bc

sprite_x_shift_last_loop:    
    sla d                                   ; shift left
    dec a
    jr nz, sprite_x_shift_last_loop         ; loop until we shift all the bits
    jr sprite_x_with_overlap                ; once we shift all the bits, we can proceed with plotting

check_x_middle_iteration:    
    dec hl                                  ; decrement hl, as we are going to load 8 pixels of data from previous address
    ld d, (hl)                              ; load 8 pixels of data into d
    inc hl                                  ; increment hl to get back where we were

    push bc                                 ; since we are going to shift bits to the left,    
    ld a, b                                 ; we need to shift 8 - offset times
    and %00000111                           ; we first find the offset (b last 3 bits)
    ld b, a                                 ; and then we subtract it from 8
    ld a, 8
    sub b
    pop bc

sprite_x_shift_middle_left_loop:    
    sla d                                   ; shift left
    dec a                       
    jr nz, sprite_x_shift_middle_left_loop  ; loop until we shift all the bits
    
    ld a, d                                 ; load the shifted data into d
    push af                                 ; save it, as we are going to blend it with the next 8 pixels

    ld a, b                                 ; see how many times need to shift
    and %00000111                           ; number of times to shift
    ld d, (hl)                              ; load 8 pixels of data into d
    inc hl                                  ; increment hl to get to the next 8 pixels of data
sprite_x_shift_middle_right_loop:
    srl d                                   ; shift right
    dec a
    jr nz, sprite_x_shift_middle_right_loop ; loop until we shift all the bits

    pop af                                  ; load the shifted data from middle left loop
    add a, d                                ; blend it with the shifted data from middle right loop
    ld d, a                                 ; load the blended data into d

    jr sprite_x_with_overlap                ; once we shift all the bits, we can proceed with plotting
    ret
sprite_x_loop_no_overlap:
    ld d, (hl)                              ; load 8 pixels of data into d
    inc hl                                  ; we can now go to next 8 pixel data address
sprite_x_with_overlap:    
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
    jr nz, sprite_x_loop                    ; loop back
    ret
