# ZX Spectrum Assembler Playground

## Requirements

Requires:
- assembler eg. [Pasmo assembler](https://pasmo.speccy.org/)
- emulator, eg. :
  - [Zx Spin](https://www.zophar.net/sinclair/zx-spin.html)
  - [ZEsarUX](https://github.com/chernandezba/zesarux)



Compiling with Pasmo.
This assumes you downloaded Pasmo and added it to the path.

Compiling example:
```bash 
pasmo pasmo --name fill_screen --tapbas concepts/screen_layout/fill_screen.asm  taps/fill_screen.tap
```

Repository content: 

## concepts
- ZX Spectrum conceptual examples

## zx_lo_fi_editor
- Javacript based ZX Spectrum "lofi" editor to create images of 64x48 pixels only, and painting them with 32x24 character colors..

![zx-lofi-editor](images/zx-lofi-alpha-1.png)

## lo_fi
Routines / programs demonstrating lo-fi graphics on ZX Spectrum.