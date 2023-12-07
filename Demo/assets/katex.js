const init = async function(app) {

  console.log("I am starting elm-katex: init");

  var katexJs = document.createElement('script');
  katexJs.type = 'text/javascript';
  katexJs.onload = function() {
    console.log("elm-katex: katex loading");
    initKatex();
    console.log("elm-katex: mhchem loading");
    loadMhchem();
  };
  katexJs.src = "https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js";

  document.head.appendChild(katexJs);
  console.log("elm-katex: I have appended katexJs to document.head");
}

function loadMhchem() {
  var mChemJs = document.createElement('script');
  mChemJs.type = 'text/javascript';
  mChemJs.onload = function() {
    console.log("elm-katex: mhchem loaded");
  };
  mChemJs.src = "https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/contrib/mhchem.min.js";

  document.head.appendChild(mChemJs);
  console.log("elm-katex: I have appended mChemJs to document.head");
}

function initKatex() {
  console.log("elm-katex: initializing");

  class MathText extends HTMLElement {
    constructor() {
      super();
    }

    connectedCallback() {
      this.attachShadow({mode: "open"});
      this.shadowRoot.innerHTML =
        katex.renderToString(
          this.content,
          { throwOnError: false, displayMode: this.display }
        );
      let link = document.createElement('link');
      link.setAttribute('rel', 'stylesheet');
      link.setAttribute('href', 'https://cdn.jsdelivr.net/npm/katex@0.13.3/dist/katex.min.css');
      this.shadowRoot.appendChild(link);
    }
  }

  customElements.define('math-text', MathText);
}
