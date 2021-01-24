class LoFiEditor {

    canvas = document.getElementById("canvas");
    data = [];
    history = [];

    ink = 'black';
    paper = 'white';
    tool = 'pen';
    mode = 'characters';
    isPainting = false;
    brightness = '0';
    width = 32;
    height = 24;
    name = 'default';

    constructor() {

        this.setBrightness();
        this.setTools();
        this.setResize();
        this.setExport();
        this.setMode();

        this.createData(this.width, this.height);

        this.createCanvas(this.data);
    }

    setBrightness() {

        const toggle = document.getElementById("brightness-button");

        toggle.addEventListener("click", (e) => {

            this.brightness = this.brightness === '1' ? '0' : '1';

            toggle.innerText = this.brightness === '1' ? 'bright' : 'normal';

            const ink = document.getElementById("ink");
            const paper = document.getElementById("paper");

            if (this.brightness === '1') {
                ink.setAttribute("class", "palette-bright");
                paper.setAttribute("class", "palette-bright");
            } else {
                ink.removeAttribute("class");
                paper.removeAttribute("class");
            }
        });
    }

    setTools() {

        const pen = document.getElementById("tool-pen");
        const eraser = document.getElementById("tool-eraser");
        const undo = document.getElementById("tool-undo");

        const colours = [
            'black',
            'blue',
            'red',
            'pink',
            'green',
            'cyan',
            'yellow',
            'white'
        ];

        pen.addEventListener("click", (e) => {
            this.tool = 'pen';
        });

        eraser.addEventListener("click", (e) => {
            this.tool = 'eraser';
        })

        undo.addEventListener("click", (e) => {
            this.undo();
        });

        colours.forEach((item) => {
            this.createPaletteColorItem(item);
        })

        colours.forEach((item) => {
            this.createPaletteBgItem(item);
        })
    }

    setMode() {

        const modeCharacters = document.getElementById("mode-characters");
        const modeAttributes = document.getElementById("mode-attributes");
        const modeBoth = document.getElementById("mode-both");


        modeCharacters.addEventListener("click", (e) => {
            this.mode = 'characters';
        });

        modeAttributes.addEventListener("click", (e) => {
            this.mode = 'attributes';
        })

        modeBoth.addEventListener("click", (e) => {
            this.mode = 'both';
        });
    }

    setResize() {

        const resize = document.getElementById("canvas-resize");
        const width = document.getElementById("canvas-width");
        const height = document.getElementById("canvas-height");


        width.oninput = () => {
            this.width = parseInt(width.value, 10);
        }

        height.oninput = () => {
            this.height = parseInt(height.value, 10);
        }

        resize.addEventListener("click", () => {
            if (width.value <= 32 && height.value <= 24) {
                this.resizeData(width.value, height.value, this.data);
                this.createCanvas(this.data);
            }
        })
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

        const exportCharacterData = document.getElementById("export-character-data");

        let characterData = '';

        let pointer = 0;
        let byte = '';

        characterData = `char_${this.name}:\n`;
        characterData += `defb ${this.width},${this.height}\n`;
        characterData += `defb 0,0\n`; // TODO: wire up x,y coords

        this.data.forEach(item => {

            if (pointer === 0) {
                characterData += "defb ";
            }

            byte += item.bits;

            if (byte.length === 8) {
                characterData += parseInt(byte, 2);
                byte = '';
            }

            pointer++;

            if (pointer === this.width) {
                characterData += '\n';
                pointer = 0;
            } else if (byte.length === 0) {
                characterData += ',';
            }
        });

        exportCharacterData.textContent = characterData;
    }

    exportAttributeData() {

        const exportAttributeData = document.getElementById("export-attribute-data");

        let attributeData = `attr_${this.name}:\n`;

        let pointer = 0;
        let byte = '';

        attributeData += `defb ${this.width},${this.height}\n`;
        attributeData += `defb 0,0\n`; // TODO: wire up x,y coords

        this.data.forEach(item => {

            if (pointer === 0) {
                attributeData += "defb ";
            }

            const flash = '0';

            attributeData += parseInt(`${flash}${item.brightness}${item.paper}${item.ink}`, 2);

            pointer++;

            if (pointer === this.width) {
                attributeData += '\n';
                pointer = 0;
            } else if (byte.length === 0) {
                attributeData += ',';
            }
        });

        exportAttributeData.textContent = attributeData;
    }

    createPaletteColorItem(id) {

        const item = document.getElementById('ink-' + id);
        item.addEventListener("click", () => {

            this.ink = id;

            const parent = document.getElementById('ink');

            parent.childNodes.forEach((node) => {
                node.className = 'palette-item';
            })

            item.setAttribute("class", 'palette-item selected');

        })
    }

    createPaletteBgItem(id) {

        const item = document.getElementById('paper-' + id);

        item.addEventListener("click", () => {
            this.paper = id;

            const parent = document.getElementById('paper');

            parent.childNodes.forEach((node) => {
                node.className = 'palette-item';
            })

            item.setAttribute("class", 'palette-item selected');
        })
    }

    paint(pixel, attribute) {

        const map = this.getBinaryFromColors();

        if (this.tool === 'pen' && this.mode !== 'characters') {

            console.log("painting attrs");
            attribute.setAttribute(
                "class",
                'character'
                + ' ink-' + this.ink
                + ' paper-' + this.paper
                + ' ' +
                (this.brightness === '1' ? 'br' : '')
            );

            attribute.setAttribute('ink', map[this.ink]);
            attribute.setAttribute('paper', map[this.paper]);
            attribute.setAttribute('brightness', this.brightness);
        }

        if (this.tool === 'eraser' && this.mode !== 'characters') {

            console.log("erasin attrs");

            attribute.setAttribute(
                "class",
                'character'
                + ' ink-black'
                + ' paper-white'
            );

            attribute.setAttribute('ink', '000');
            attribute.setAttribute('paper', '111');
            attribute.setAttribute('brightness', '0');
        }

        if (this.tool === 'pen' && this.mode !== 'attributes') {
            console.log("painting chars");
            pixel.setAttribute("class", 'bit1');
            pixel.setAttribute("bit", '1');
        }

        if (this.tool === 'eraser' && this.mode !== 'attributes') {
            console.log("erasing chasr");
            pixel.setAttribute("class", 'bit0');
            pixel.setAttribute("bit", '0');
        }

        this.updateData(attribute);
    }

    updateData(attribute) {

        let bits = '';
        const bit0 = attribute.children.item(0);
        bits += bit0.getAttribute("bit");
        const bit1 = attribute.children.item(1);
        bits += bit1.getAttribute("bit");
        const bit2 = attribute.children.item(2);
        bits += bit2.getAttribute("bit");
        const bit3 = attribute.children.item(3);
        bits += bit3.getAttribute("bit");

        attribute.setAttribute("bits", bits)

        let uid = attribute.getAttribute("uid");

        let match = this.data.find((item) => item.uid === uid);

        if (match) {
            match.brightness = attribute.getAttribute("brightness");
            match.ink = attribute.getAttribute("ink");
            match.paper = attribute.getAttribute("paper");
            match.bits = attribute.getAttribute("bits");
        }
    }

    createData(width, height) {
        
        for (let i = 0; i < height; i++) {

            for (let j = 0; j < width; j++) {

                const uid = j + 'x' + i;

                this.data.push({
                    uid,
                    brightness: '0',
                    bits: '0000',
                    ink: '000',
                    paper: '111'
                })
            }
        }
    }

    resizeData(width, height, data) {

        const dataCopy = this.getArrayClone(data);

        this.data = [];

        for (let i = 0; i < height; i++) {

            for (let j = 0; j < width; j++) {

                const uid = j + 'x' + i;

                const match = dataCopy.find(item => item.uid === uid);

                if (match) {
                    this.data.push(match);
                } else {
                    this.data.push({
                        uid,
                        brightness: '0',
                        bits: '0000',
                        ink: '000',
                        paper: '111'
                    })
                }
            }
        }
    }

    createCanvas(data) {

        this.canvas.innerHTML = '';

        this.canvas.setAttribute("style", "width:" + (this.width * 20) + 'px');

        data.forEach(item => {

            const map = this.getColorsFromBinary();

            const attribute = document.createElement("div", {});

            attribute.setAttribute("class", `character ink-${map[item.ink]} paper-${map[item.paper]}`);
            attribute.setAttribute("uid", item.uid);
            attribute.setAttribute("ink", item.ink);
            attribute.setAttribute("paper", item.paper);
            attribute.setAttribute("brightness", item.brightness);

            attribute.addEventListener("mouseover", (e) => {

                e.stopPropagation();
                if (!this.isPainting) return;
              //  attribute.setAttribute("class", 'character' + ' ink-' + this.ink + ' paper-' + this.paper);
            })

            for (let k = 0; k < 4; k++) {

                const pixel = document.createElement("div");
                attribute.appendChild(pixel);

                pixel.setAttribute("class", `bit${item.bits.charAt(k)}`);
                pixel.setAttribute("bit", item.bits.charAt(k));

                pixel.addEventListener("mousemove", (e) => {

                    if (!this.isPainting) return;

                    this.paint(pixel, attribute);
                })

                pixel.addEventListener("mousedown", (e) => {
                    this.saveDataToHistory();
                    e.preventDefault();
                    this.isPainting = true;

                    this.paint(pixel, attribute);
                })

                pixel.addEventListener("mouseup", (e) => {

                    e.preventDefault();


                    this.isPainting = false;
                })
            }

            this.canvas.appendChild(attribute);
        });
    }

    saveDataToHistory() {
        this.history.push({
            width: this.width,
            height: this.height,
            data: this.data.map(a => ({...a}))
        });
    }

    getArrayClone(data) {
        return data.map(a => ({...a}));
    }

    undo() {
        if (this.history.length === 0) {
            return;
        }

        const lastHistoryEntry = this.history.pop();

        this.data = lastHistoryEntry.data;
        this.width = lastHistoryEntry.width;
        this.height = lastHistoryEntry.height;

        const widthElement = document.getElementById("canvas-width");
        const heightElement = document.getElementById("canvas-height");

        widthElement.value = lastHistoryEntry.width;
        heightElement.value = lastHistoryEntry.height;

        this.createCanvas(this.data);
    }

    getColorsFromBinary() {
        return {
            '000': 'black',
            '001': 'blue',
            '010': 'red',
            '011': 'pink',
            '100': 'green',
            '101': 'cyan',
            '110': 'yellow',
            '111': 'white',
        }
    }

    getBinaryFromColors() {
        return {
            'black': '000',
            'blue': '001',
            'red': '010',
            'pink': '011',
            'green': '100',
            'cyan': '101',
            'yellow': '110',
            'white': '111',
        }
    }
}

let editor = new LoFiEditor();
