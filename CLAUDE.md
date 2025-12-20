# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Scripta Compiler V2 is an Elm package that compiles three markup languages (MicroLaTeX, SMarkdown/XMarkdown, and Enclosure/L0) into HTML via elm-ui. The compiler supports mathematical expressions (via KaTeX), interactive elements, and live editing capabilities.

## Common Development Commands

### Development Server (Hot Reloading)
```bash
# From demo directories:
cd DemoSimple && ./make.sh
# or directly:
npx elm-watch hot
```

### Build Production
```bash
elm make src/Main.elm --output=./assets/main.js
```

### Run Tests
```bash
elm-test                   # Run all tests
elm-test --watch           # Watch mode
```

### Code Quality
```bash
# Review code
npm run review
# or
npx elm-review --ignore-dirs src/Evergreen/

# Auto-fix issues
npx elm-review --ignore-dirs src/Evergreen/ --fix-all

# Remove debug statements
npx elm-review --ignore-dirs src/Evergreen/ --fix-all --rules NoDebug.Log
```

### Code Metrics
```bash
cloc --by-file --exclude-dir=Evergreen src/ compiler/
```

### Benchmarking
```bash
# From Benchmark directory:
cd Benchmark
elm make src/Main.elm --optimize --output=main.js
node run.js [repetitions]  # Default: 100

# With advanced optimizations:
npx elm-optimize-level-2 src/Main.elm --output=main.js
```

### Scripts (scripts.yaml)
```bash
# Code review commands (also available via scripts.yaml):
npx elm-review --ignore-dirs src/Evergreen/ --fix      # Auto-fix single issues
rm -rf elm-stuff && rm -f assets/main-*.js             # Clean all build artifacts
```

## High-Level Architecture

### Compilation Pipeline
1. **Source Text** → Lines of text
2. **Primitive Block Parser** → Parse into blocks (headers, paragraphs, code blocks, etc.)
3. **Forest Transform** → Convert blocks into forest structure based on indentation
4. **Expression Parser** → Parse expressions within each block
5. **Render** → Convert AST to elm-ui Elements

### Key API Entry Points
- `ScriptaV2.APISimple` - Simple `compile` function for basic usage
- `ScriptaV2.API` - Full API with themes and advanced options
- `ScriptaV2.Compiler` - Core compiler with detailed configuration

### Two-Step vs Simple API
- **Simple API** (`ScriptaV2.APISimple.compile`): One-shot compilation from source string directly to elm-ui Elements
- **Two-Step API** (`ScriptaV2.API.compileOutput`): Returns a `CompilerOutput` with separate body, banner, toc, and title that can be rendered selectively with `viewBodyOnly`/`viewTOC`

### Language Modules
- `MiniLaTeX/` - LaTeX-like syntax implementation
- `XMarkdown/` - Extended Markdown (Scientific Markdown)
- `Scripta/` - Core parsing (Expression, Tokenizer, PrimitiveBlock)
- `ETeX/` - Extended TeX parser (experimental)

### Core Infrastructure
- `Generic.Compiler` - Language-agnostic compiler infrastructure
- `Generic.Pipeline` - Processing pipeline orchestration
- `Generic.Forest` - Tree/forest data structures for document hierarchy
- `Render/` - Rendering engine for converting AST to HTML/elm-ui
- `Differential/` - Incremental compilation for live editing
- `MicroScheme/` - Embedded Scheme interpreter for computations

### Demo Applications
- `Demo/` - Full-featured demo with all languages
- `DemoSimple/` - Simplified demo for testing specific features
- `DemoTOC/` - Demo focusing on table of contents functionality
- `CLI/` - Command-line tools for batch processing

## Important Notes

- Use `elm-json` to modify the important `elm.json` file
- The project uses elm-watch for development with hot reloading
- Generated JavaScript files (main.js) are git-ignored
- Tests are in the `tests/` directory and use elm-test
- `ToForestAndAccumulatorTest` exercises the entire pipeline (up to rendering) for all Scripta languages
- Math rendering requires KaTeX to be loaded in the HTML
- The compiler supports differential compilation for efficient live editing
- Interactive blocks include charts (terezka/elm-charts), tables, and iframes
- Theme support allows customizing the rendered output appearance
- When I say "show me the code", display a snippet of the code and its module name and line numbers