class LoFiEditor {

    canvas = document.getElementById("canvas");
    data = [];
    history = [];

    color = 'black';
    bgColor = 'white';
    tool = 'pen';
    isPainting = false;
    brightness = '0';
    width = 32;
    height= 24;

    constructor() {

        this.setBrightness();
        this.setTools();
        this.setResize();
        this.createCanvas(this.width, this.height);
    }

    setBrightness() {

        const toggle = document.getElementById("brightness-button");

        toggle.addEventListener("click", (e) => {

            this.brightness = this.brightness === '1' ? '0' : '1';

            toggle.innerText = this.brightness === '1' ? 'bright' : 'normal';

            const colors = document.getElementById("colors");
            const bgColors = document.getElementById("bg_colors");

            if (this.brightness === '1') {
                colors.setAttribute("class", "palette-bright");
                bgColors.setAttribute("class", "palette-bright");
            } else {
                colors.removeAttribute("class");
                bgColors.removeAttribute("class");
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
            // this.canvas.innerHTML = '';
            // this.canvas.append(...this.history.pop());
            this.undo();
        });

        colours.forEach((item) => {
            this.createPaletteColorItem(item);
        })

        colours.forEach((item) => {
            this.createPaletteBgItem(item);
        })
    }

    setResize() {

        const resize = document.getElementById("canvas-resize");
        const width = document.getElementById("canvas-width");
        const height = document.getElementById("canvas-height");


        width.oninput = () => {
            this.width = width.value;
        }

        height.oninput = () => {
            this.height = height.value;
        }

        resize.addEventListener("click", () => {
            if (width.value <= 32 && height.value <=24) {
                this.createCanvas(this.width, this.height);
            }
        })
    }

    createPaletteColorItem(id) {

        const item = document.getElementById('c-' + id);
        item.addEventListener("click", () => {

            this.color = id;

            const parent = document.getElementById('colors');

            parent.childNodes.forEach((node) => {
                node.className = 'palette-item';
            })

            item.setAttribute("class", 'palette-item selected');

        })
    }

    createPaletteBgItem(id) {

        const item = document.getElementById('bg-' + id);

        item.addEventListener("click", () => {
            this.bgColor = id;

            const parent = document.getElementById('bg_colors');

            parent.childNodes.forEach((node) => {
                node.className = 'palette-item';
            })

            item.setAttribute("class", 'palette-item selected');
        })
    }

    paint(pixel, attribute) {

        const map = {
            'black': '000',
            'blue': '001',
            'red': '010',
            'pink': '011',
            'green': '100',
            'cyan': '101',
            'yellow': '110',
            'white': '111',
        }

        attribute.setAttribute("class", 'character' + ' c-' + this.color + ' bg-' + this.bgColor + ' ' +
            (this.brightness === '1' ? 'br' : '')) ;

        attribute.setAttribute('color', map[this.color]);
        attribute.setAttribute('bgColor', map[this.bgColor]);
        attribute.setAttribute('brightness', this.brightness);

        if (this.tool === 'pen') {
            pixel.setAttribute("class", 'bit1');
            pixel.setAttribute("bit", '1');
        }
        if (this.tool === 'eraser') {
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

        console.log(uid);
        let match = this.data.find((item) => item.uid === uid);

        if (match) {
            match.brightness = attribute.getAttribute("brightness");
            match.color = attribute.getAttribute("color");
            match.bgColor = attribute.getAttribute("bgColor");
            match.bits = attribute.getAttribute("bits");
        }

        console.log(this.data);
    }

    createCanvas(width, height) {

        this.canvas.innerHTML = '';
        this.data = [];

        for(let i = 0; i < width * height; i++) {

        }

        this.canvas.setAttribute("style","width:" + (width * 20) + 'px');

        for (let i = 0; i < height; i++) {

            for (let j = 0; j < width; j++) {

                const uid = j + 'x' + i;

                // TODO: extract to separate loop. Load below class/nodes definitions based on data provided
                this.data.push({
                    uid,
                    brightness: '0',
                    bits: '0000',
                    color: '000',
                    bgColor: '111'
                })

                const attribute = document.createElement("div", {});

                attribute.setAttribute("class", "character c-black bg-white");
                attribute.setAttribute("uid", uid);
                attribute.setAttribute("color", '000');
                attribute.setAttribute("bgColor", '111');
                attribute.setAttribute("brightness", '0');

                attribute.addEventListener("mouseover", (e)=> {

                    e.stopPropagation();
                    if (!this.isPainting) return;
                    attribute.setAttribute("class", 'character' + ' c-' + this.color + ' bg-' + this.bgColor);
                })

                for (let k = 0; k < 4; k++) {

                    const pixel = document.createElement("div");
                    attribute.appendChild(pixel);

                    pixel.setAttribute("class", "bit0");
                    pixel.setAttribute("bit",0);

                    pixel.addEventListener("mousemove", (e)=> {

                        if (!this.isPainting) return;

                        this.paint(pixel, attribute);
                    })

                    pixel.addEventListener("mousedown", (e)=> {

                        e.preventDefault();
                        this.isPainting = true;

                        this.paint(pixel, attribute);
                    })

                    pixel.addEventListener("mouseup", (e)=> {

                        e.preventDefault();

                        this.history.push(this.data);

                        this.isPainting = false;
                    })
                }

                this.canvas.appendChild(attribute);
            }
        }
    }

    undo() {
        this.canvas.childNodes.forEach(node=> {
            // TODO - recreate from data
        })
    }
}

let editor = new LoFiEditor();
