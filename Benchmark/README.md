# Scripta Compiler Benchmark

Measures the compilation performance of the Scripta compiler by timing repeated compilations of a test document.

## How It Works

The benchmark runs in Node.js using a compiled Elm worker:

1. **Main.elm** creates a `Platform.worker` that accepts a repetition count as a flag
2. The `runBenchMarkTaskMany` function compiles a test document N times using `ScriptaV2.APISimple.compile`
3. Timestamps are captured before and after the batch using `Time.now`
4. The elapsed time is divided by the repetition count to get milliseconds per compilation
5. Results are sent to Node.js via an Elm port

## Test Data

The benchmark compiles `DataSci.elm`, a Scripta document containing:
- Math macros
- LaTeX equations
- Markdown-style headers and lists
- Inline math expressions

## Usage

### Build

```bash
# Standard optimized build
elm make src/Main.elm --optimize --output=main.js

# Advanced optimizations (slower build, faster runtime)
npx elm-optimize-level-2 src/Main.elm --output=main.js
```

### Run

```bash
node run.js [body_multiplier] [repetitions]
```

- `body_multiplier` - Number of times to repeat the body section (default: 1)
- `repetitions` - Number of times to compile the test document (default: 100)

The test document is constructed as `header + N x body`, where N is the body multiplier. This allows testing how compilation time scales with document size.

### Examples

```bash
node run.js              # 1x body, 100 iterations
node run.js 1 100        # 1x body, 100 iterations (explicit)
node run.js 4 200        # 4x body, 200 iterations
node run.js 10 50        # 10x body, 50 iterations (larger document, fewer runs)
```

### Output

```
Body multiplier: 4x
24.8 milliseconds per run in 200 runs for a document of 4,246 words
5.84 microseconds per word
```

All timing results are reported to 3 significant figures.

## Sample Results

```
Words in Doc | ms/doc  | µs/word | runs
-----------------------------------------
       1,111 |    7.03 |   6.33  | 100
      10,516 |   59.4  |   5.65  | 200
     104,506 |   57.5  |   5.5   |  20
   1,045,060 | 7020    |   6.72  |  20
```
