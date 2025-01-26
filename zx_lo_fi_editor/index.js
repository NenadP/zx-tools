class LoFiEditor {

    canvas = document.getElementById("canvas");

    data = {
        width: 32,
        height: 24,
        map: []
    };

    history = [];

    ink = 'black';
    paper = 'white';
    tool = 'pen';
    mode = 'characters';
    isPainting = false;
    brightness = '0';

    updateCanvasCallback = (data) => {

        this.data = data;
        this.restoreDimensionsInputs();
        this.createCanvas(this.data);
    };

    getDataCallBack = () => {

        return this.data;
    }
    

    constructor() {

        this.loFiExport = new LoFiExport({ getData: this.getDataCallBack })
        this.loFiExport.setExport();

        this.loFiIo = new LoFiIo({ onSave: this.getDataCallBack, onLoad: this.updateCanvasCallback });
        this.loFiIo.setSave();
        this.loFiIo.setLoad();

        this.setBrightness();
        this.setTools();
        this.setResize();
        this.setMode();

        this.createData(this.data.width, this.data.height);

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
            this.data.width = parseInt(width.value, 10);
        }

        height.oninput = () => {
            this.data.height = parseInt(height.value, 10);
        }

        resize.addEventListener("click", () => {
            if (width.value <= 32 && height.value <= 24) {
                this.resizeData(this.data);
                this.saveDataToHistory();
                this.createCanvas(this.data);
            }
        })
    }

    createPaletteColorItem(id) {

        const item = document.getElementById('ink-' + id);
        item.addEventListener("click", () => {

            this.ink = id;

            const parent = document.getElementById('ink');

            parent.childNodes.forEach((node) => {
                node.className = 'btn palette-item';
            })

            item.setAttribute("class", 'btn palette-item selected');

        })
    }

    createPaletteBgItem(id) {

        const item = document.getElementById('paper-' + id);

        item.addEventListener("click", () => {
            this.paper = id;

            const parent = document.getElementById('paper');

            parent.childNodes.forEach((node) => {
                node.className = 'btn palette-item';
            })

            item.setAttribute("class", 'btn palette-item selected');
        })
    }

    paint(pixel, attribute) {

        const map = this.getBinaryFromColors();

        if (this.tool === 'pen' && this.mode !== 'characters') {

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
            pixel.setAttribute("class", 'bit1');
            pixel.setAttribute("bit", '1');
        }

        if (this.tool === 'eraser' && this.mode !== 'attributes') {
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

        let match = this.data.map.find((item) => item.uid === uid);

        if (match) {
            match.brightness = attribute.getAttribute("brightness");
            match.ink = attribute.getAttribute("ink");
            match.paper = attribute.getAttribute("paper");
            match.bits = attribute.getAttribute("bits");
        }
    }

    createData(width, height) {

        this.data.width = 32;
        this.data.height = 24;

        for (let i = 0; i < height; i++) {

            for (let j = 0; j < width; j++) {

                const uid = j + 'x' + i;

                this.data.map.push({
                    uid,
                    brightness: '0',
                    bits: '0000',
                    ink: '000',
                    paper: '111'
                })
            }
        }
    }

    resizeData(data) {

        const dataCopy = this.getDataClone(data);

        this.data = {
            width: dataCopy.width,
            height: dataCopy.height,
            map: []
        };

        for (let i = 0; i < this.data.height; i++) {

            for (let j = 0; j < this.data.width; j++) {

                const uid = j + 'x' + i;

                const match = dataCopy.map.find(item => item.uid === uid);

                if (match) {
                    this.data.map.push(match);
                } else {
                    this.data.map.push({
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

        this.canvas.setAttribute("style", "width:" + (data.width * 20) + 'px');

        data.map.forEach(item => {

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
        this.history.push(this.getDataClone(this.data));
    }

    getDataClone(data) {
        return {
            width: this.data.width,
            height: this.data.height,
            map: data.map.map(a => ({...a}))
        };
    }

    undo() {
        if (this.history.length === 0) {
            return;
        }

        const lastHistoryEntry = this.history.pop();

        this.data = lastHistoryEntry;
        this.restoreDimensionsInputs();

        this.createCanvas(this.data);
    }

    restoreDimensionsInputs() {

        const widthElement = document.getElementById("canvas-width");
        const heightElement = document.getElementById("canvas-height");

        widthElement.value = this.data.width;
        heightElement.value = this.data.height;
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
