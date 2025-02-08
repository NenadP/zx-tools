/* ------------------------------------------------------------------
   License
   ------------------------------------------------------------------
  
   Copyright (C) 2025 - present, Nenad Pantic
  
   Permission is granted to use, copy, modify, and distribute
   this software with attribution. Provided "as is", without warranty.
   The author is not liable for any damages resulting from its use.
  
 ------------------------------------------------------------------
*/

class LoFiExport {

    name = 'default';

    constructor(options) {
        this.options = options;
    }

    setExport() {

        const exportButton = document.getElementById("export-button");

        const name = document.getElementById("export-name");

        name.oninput = () => {
            this.name = name.value;
        }

        exportButton.addEventListener("click", () => {

            this.exportCharacterData();
            this.exportAttributeData();
        });
    }

    exportCharacterData() {

        const exportCharacterData = document.getElementById("export-data");

        let characterData = '';

        let pointer = 0;
        let byte = '';

        characterData = `char_${this.name}:\n`;
        characterData += `defb ${this.options.getData().width},${this.options.getData().height}\n`;
        characterData += `defb 0,0\n`; // TODO: wire up x,y coords

        this.options.getData()
            .map
            .forEach(item => {

                if (pointer === 0) {
                    characterData += "defb ";
                }

                byte += item.bits;

                if (byte.length === 8) {
                    characterData += parseInt(byte, 2);
                    byte = '';
                }

                pointer++;


                if (pointer === this.options.getData().width) {
                    characterData += '\n';
                    pointer = 0;
                } else if (byte.length === 0) {
                    characterData += ',';
                }
            });

        characterData += '\n';
        exportCharacterData.textContent = characterData;
    }

    exportAttributeData() {

        const exportAttributeData = document.getElementById("export-data");

        let attributeData = `attr_${this.name}:\n`;

        let pointer = 0;
        let byte = '';

        attributeData += `defb ${this.options.getData().width},${this.options.getData().height}\n`;
        attributeData += `defb 0,0\n`; // TODO: wire up x,y coords

        this.options.getData()
            .map
            .forEach(item => {

                if (pointer === 0) {
                    attributeData += "defb ";
                }

                const flash = '0';

                attributeData += parseInt(`${flash}${item.brightness}${item.paper}${item.ink}`, 2);

                pointer++;

                if (pointer === this.options.getData().width) {
                    attributeData += '\n';
                    pointer = 0;
                } else if (byte.length === 0) {
                    attributeData += ',';
                }
            });

        exportAttributeData.textContent += attributeData;
    }
}
