const { Elm } = require('./main.js');

const reps = parseInt(process.argv[2]) || 100;

const app = Elm.Main.init({ flags: reps });

app.ports.results.subscribe((output) => {
    console.log(output);
    process.exit(0);
});
