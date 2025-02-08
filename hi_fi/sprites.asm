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
    defb 2, 16                  ; sprite width (in bytes), height (in pixels)
    defb %00000000, %00000000
    defb %00000000, %00000000
    defb %00001111, %11110000
    defb %00010000, %00001000
    defb %00100000, %00000100
    defb %00100110, %01100100
    defb %01000000, %00000010
    defb %01000000, %00000010
    defb %01000000, %00000010
    defb %00100110, %01100100
    defb %00100000, %00000100
    defb %00010000, %00001000
    defb %00001111, %11110000
    defb %00000000, %00000000
    defb %00000000, %00000000
    defb %00000000, %00000000
