Screen layout
Source: https://www.overtakenbyevents.com/lets-talk-about-the-zx-specrum-screen-layout/


# Attributes

Attributes in memory: starting at #5800 there are 32 attributes per screen row and 24 rows.

Each block of 8x8 pixels has a single byte of attribute data packed as follows:

|7|6|5|4|3|2|1|0
--|-|-|-|-|-|-|-
F|B|P2|P2|P1|I0|I1|I0

- Bit 7 - color flash.  
- Bit 6 - use bright.  
- 5 to 3 - background (0 valued bytes)  
- 2 to 0 - ink (1 valued bytes)  

**In a nutshell:**  
- Black: 000  
- Blue: 001  
- Red: 010  
- Magenta: 011  
- Green: 100  
- Cyan: 101  
- Yellow: 110  
- White: 111  


**Colours table:**

| Dec      | Bin      | Color    | Normal   | Bright   |
|----------|----------|----------|----------|----------|
| 0        | 000      | Black    | <div style="background-color:#000000; width:20px; height:20px;"></div> | <div style="background-color:#000000; width:20px; height:20px;"></div> |
| 1        | 001      | Blue     | <div style="background-color:#0000D7; width:20px; height:20px;"></div> | <div style="background-color:#0000FF; width:20px; height:20px;"></div> |
| 2        | 010      | Red      | <div style="background-color:#D70000; width:20px; height:20px;"></div> | <div style="background-color:#FF0000; width:20px; height:20px;"></div> |
| 3        | 011      | Magenta  | <div style="background-color:#D700D7; width:20px; height:20px;"></div> | <div style="background-color:#FF00FF; width:20px; height:20px;"></div> |
| 4        | 100      | Green    | <div style="background-color:#00D700; width:20px; height:20px;"></div> | <div style="background-color:#00FF00; width:20px; height:20px;"></div> |
| 5        | 101      | Cyan     | <div style="background-color:#00D7D7; width:20px; height:20px;"></div> | <div style="background-color:#00FFFF; width:20px; height:20px;"></div> |
| 6        | 110      | Yellow   | <div style="background-color:#D7D700; width:20px; height:20px;"></div> | <div style="background-color:#FFFF00; width:20px; height:20px;"></div> |
| 7        | 111      | White    | <div style="background-color:#D7D7D7; width:20px; height:20px;"></div> | <div style="background-color:#FFFFFF; width:20px; height:20px;"></div> |

## Border color
**Port 0xfe**
Port 0xfe is I/O port, but lower 3 bits are used to select the border color.

Color values are same as in character attributes.

| 7 | 6 | 5 | 4       | 3   | 2   1   0 |
|---|---|---|---------|-----|-----------|
|   |   |   | Speaker | Mic |   Border  |
            