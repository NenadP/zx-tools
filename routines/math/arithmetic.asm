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

; bc - values to multiply (b * c)
; mutates: af, de, hl, b
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
