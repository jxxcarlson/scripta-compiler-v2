# Demo - Scripta Compiler V2 Interactive Demo

A full-featured web-based demo application for the Scripta Compiler V2 that provides live editing and real-time rendering of three markup languages in a split-pane interface.

## What This App Does

Demo is an interactive compiler demonstration that:

- **Live Editing**: Edit markup text in the left pane and see instant rendering in the right pane
- **Multi-Language Support**: Switch between three markup languages:
  - **MicroLaTeX** - LaTeX-like syntax with mathematical expressions (via KaTeX)
  - **Scripta** (L0/M language) - Enclosure-based markup with pipe syntax
  - **SMarkdown** - Extended Markdown with scientific notation support
- **Responsive Layout**: Automatically adjusts to window resizing
- **Sample Content**: Each language comes with pre-loaded example text demonstrating its features
- **Real-time Compilation**: Uses differential compilation for efficient updates as you type

## Quick Start

The easiest way to run the demo:

```bash
./run.sh
```

This will:
1. Kill any existing process on port 56907
2. Start the development server with hot reloading
3. Open the demo in Firefox

## Alternative Ways to Run

### Manual Start

```bash
# Start elm-watch in hot reload mode
npx elm-watch hot

# Then open in your browser:
open assets/index.html
```

The development server will watch for file changes and automatically recompile.

### Production Build

```bash
# Build optimized JavaScript
elm make src/Main.elm --output=./assets/main.js

# Then open assets/index.html in any browser
```

## Using the Demo

1. **Select a Language**: Click one of the language buttons at the top (M, MicroLaTeX, or SMarkdown)
2. **Edit Text**: Type or modify text in the left panel (Source text)
3. **View Results**: See the rendered output instantly in the right panel (Rendered Text)
4. **Resize Window**: The layout automatically adjusts to your window size

## Features Demonstrated

- **Mathematical Expressions**: Try `\strong{bold}` or `$x^2 + y^2 = z^2$` in MicroLaTeX
- **Sections & Structure**: Document hierarchy with sections and subsections
- **Code Blocks**: Syntax-highlighted code examples
- **Lists & Tables**: Various formatting options
- **Cross-references**: Internal document linking
- **Live Compilation**: Efficient differential compilation updates only changed parts

## Architecture

The demo application:
- Uses The Elm Architecture (TEA) pattern
- Calls `ScriptaV2.APISimple.compile` for rendering
- Loads sample data from `Data/` modules (Data.M, Data.MicroLaTeX, Data.XMarkdown)
- Renders using elm-ui for responsive layout
- Uses KaTeX (loaded in HTML) for mathematical expressions

## Sample Data Files

- `src/Data/M.elm` - Scripta/L0 language examples
- `src/Data/MicroLaTeX.elm` - MicroLaTeX examples with math
- `src/Data/XMarkdown.elm` - SMarkdown examples

## Development

```bash
# Watch mode with hot reloading (recommended)
npx elm-watch hot

# Run tests (from parent directory)
cd .. && elm-test

# Code quality checks
npm run review
```

## Configuration

The demo is configured via:
- `elm-watch.json` - Development server settings (port 56907)
- `elm.json` - Package dependencies
- `assets/index.html` - HTML wrapper with KaTeX loading

## Troubleshooting

**Port already in use**: If you see port 56907 is busy, run:
```bash
lsof -ti:56907 | xargs kill -9
```

**Compilation errors**: Make sure you're in the Demo directory and all dependencies are installed:
```bash
elm-json install --yes avh4/elm-color rtfeldman/elm-css
```

**Browser not opening**: Manually open `assets/index.html` in your preferred browser after starting elm-watch.

## Related Demos

- **DemoSimple** - Simplified version focusing on basic compilation
- **DemoTOC** - Demonstrates table of contents generation
- **DemoScriptaLive** - Full production application (requires additional setup)

## More Information

For details on the compiler architecture and supported languages, see the main project README in the parent directory.
