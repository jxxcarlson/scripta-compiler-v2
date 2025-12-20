const { Elm } = require('./main.js');

const bodyMultiplier = parseInt(process.argv[2]) || 1;
const reps = parseInt(process.argv[3]) || 100;

const app = Elm.Main.init({
    flags: {
        bodyMultiplier: bodyMultiplier,
        reps: reps
    }
});

function formatNumber(n) {
    return n.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}

function toSigFigs(n, sigFigs) {
    if (n === 0) return '0';
    const magnitude = Math.floor(Math.log10(Math.abs(n)));
    const scale = Math.pow(10, sigFigs - 1 - magnitude);
    return (Math.round(n * scale) / scale).toString();
}

app.ports.results.subscribe((output) => {
    const [msPerRunStr, runs, wordCountStr] = output.split('|');
    const msPerRun = parseFloat(msPerRunStr);
    const wordCount = parseInt(wordCountStr);
    const microsecondsPerWord = (msPerRun / wordCount) * 1000;

    console.log(`Body multiplier: ${bodyMultiplier}x`);
    console.log(`${toSigFigs(msPerRun, 3)} milliseconds per run in ${runs} runs for a document of ${formatNumber(wordCount)} words`);
    console.log(`${toSigFigs(microsecondsPerWord, 3)} microseconds per word`);
    process.exit(0);
});
