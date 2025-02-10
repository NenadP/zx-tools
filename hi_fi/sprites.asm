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

; 16px x 16px sprite data
smiley:
    defb %00000010, %00010000             ; sprite width (in bytes), height (in pixels)
    defb %00111111, %11111100
    defb %01000000, %00000010
    defb %10000000, %00000001
    defb %10001100, %00110001
    defb %10001100, %00110001
    defb %10000000, %00000001
    defb %10000000, %00000001
    defb %10000000, %00000001
    defb %10000000, %00000001
    defb %10010000, %00001001
    defb %10001111, %11110001
    defb %10000000, %00000001
    defb %10000000, %00000001
    defb %10000000, %00000001
    defb %01000000, %00000010
    defb %00111111, %11111100

