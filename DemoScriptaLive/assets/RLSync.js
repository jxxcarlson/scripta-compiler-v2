
exports.init = async function init(app) {

    console.log("@@@ I am loading RLSync.js")

    app.ports.getSelectionForAnchor.subscribe(function() {
        var selection = window.getSelection();
        console.log("!!@@!!selection", selection);
        console.log("@@!! selectionNODE", selection.anchorNode.textContent);
        if (selection.type === "Range") {
            var data
                = {   "anchorOffset": selection.anchorOffset
                    , "focusOffset": selection.focusOffset
                    , "text": selection.anchorNode.textContent };
            console.log("!!@@!! selection data::", data);
            app.ports.anchorOffset.send(data);
        }
    })
}
