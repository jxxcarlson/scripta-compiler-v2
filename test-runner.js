const { Elm } = require('./test-aligned-console.js');

const app = Elm.TestAlignedConsole.init();

app.ports.output.subscribe(function(message) {
    console.log(message);
    process.exit(0);
});
