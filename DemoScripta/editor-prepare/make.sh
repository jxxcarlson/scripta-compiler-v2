npm start
sed 's/(function ()/window.initCodeMirror = function ()/' editor.bundle.js >editor.bundle2.js
sed 's/^})();/}/' editor.bundle2.js > editor.bundle3.js
cat editor.bundle3.js initializer.txt > codemirror-element.js
mv  codemirror-element.js ../assets
rm editor.bundle*.js


