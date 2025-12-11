const { Elm } = require('./main.js');

const app = Elm.Main.init();

app.ports.results.subscribe((output) => {
    console.log(output);
    process.exit(0);
});
