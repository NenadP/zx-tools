/* ------------------------------------------------------------------
   License
   ------------------------------------------------------------------
  
   Copyright (C) 2025 - present, Nenad Pantic
  
   Permission is granted to use, copy, modify, and distribute
   this software with attribution. Provided "as is", without warranty.
   The author is not liable for any damages resulting from its use.
  
 ------------------------------------------------------------------
*/

class LoFiIo {

    name = 'default';

    constructor(options) {

        this.options = options;
    }

    setSave() {

        const saveButton = document.getElementById("save-button");

        const name = document.getElementById("save-name");

        name.oninput = () => {
            this.name = name.value;
        }

        saveButton.addEventListener("click", () => {

            this.saveFile();
        });
    }

    setLoad() {

        const fileSelector = document.getElementById('file-selector');

        fileSelector.addEventListener('change', (event) => {
            this.loadData(event.target.files[0]);

        });
    }

    loadData(file) {

        const reader = new FileReader();
        reader.addEventListener('load', (event) => {
            const data = JSON.parse(event.target.result);
            this.options.onLoad(data);
        });
        reader.readAsText(file);
    }

    saveFile() {

        const element = document.createElement('a');
        element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(JSON.stringify(this.options.onSave())));
        element.setAttribute('download', `${this.name}.json`);

        element.style.display = 'none';
        document.body.appendChild(element);

        element.click();

        document.body.removeChild(element);
    }
}
