class LoFiEditor {

    pen = document.getElementById("tool-pen");
    eraser = document.getElementById("tool-eraser");
    canvas = document.getElementById("canvas");

    color = 'c-black';
    bgColor = 'bg-white-br';
    tool = 'pen';
    isPainting = false;

    constructor() {
        this.setTools();
        this.createCanvas();
    }

    setTools() {

        const colours = [
            'black',
            'blue',
            'blue-br',
            'red',
            'red-br',
            'pink',
            'pink-br',
            'green',
            'green-br',
            'cyan',
            'cyan-br',
            'yellow',
            'yellow-br',
            'white',
            'white-br'
        ];

        this.pen.addEventListener("click", (e) => {
            this.tool = 'pen';
        });

        this.eraser.addEventListener("click", (e) => {
            this.tool = 'eraser';
        })

        colours.forEach((item) => {
            this.createPaletteColorItem('c-' + item);
        })

        colours.forEach((item) => {
            this.createPaletteBgItem('bg-' + item);
        })
    }

    createPaletteColorItem(id) {
        const item = document.getElementById(id);
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

        const item = document.getElementById(id);

        item.addEventListener("click", () => {
            this.bgColor = id;

            const parent = document.getElementById('bg_colors');

            parent.childNodes.forEach((node) => {
                node.className = 'palette-item';
            })

            item.setAttribute("class", 'palette-item selected');
        })
    }

    paint(pixel) {
        if (this.tool === 'pen') {
            pixel.setAttribute("class", 'bit1');
        }
        if (this.tool === 'eraser') {
            pixel.setAttribute("class", 'bit0');
        }
    }

    createCanvas() {

        for (let i = 0; i < 24; i++) {

            for (let j = 0; j < 32; j++) {

                const attribute = document.createElement("div", {});
                attribute.setAttribute("class", "character c-black bg-white-br");

                attribute.addEventListener("mouseover", (e)=> {
                    e.stopPropagation();

                    if (!this.isPainting) return;
                    attribute.setAttribute("class", 'character' + ' ' + this.color + ' ' + this.bgColor);
                })

                for (let k = 0; k < 4; k++) {

                    const pixel = document.createElement("div");
                    attribute.appendChild(pixel);
                    pixel.setAttribute("class", "bit0");

                    pixel.addEventListener("mousemove", (e)=> {

                        if (!this.isPainting) return;

                        this.paint(pixel);
                    })

                    pixel.addEventListener("mousedown", (e)=> {

                        e.preventDefault();
                        this.isPainting = true;

                        this.paint(pixel);
                    })

                    pixel.addEventListener("mouseup", (e)=> {

                        e.preventDefault();
                        this.isPainting = false;
                    })
                }

                this.canvas.appendChild(attribute);
            }
        }
    }
}

let editor = new LoFiEditor();
