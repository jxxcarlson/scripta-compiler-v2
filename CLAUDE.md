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
elm-test                    # Run all tests
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

### Language Modules
- `MicroLaTeX/` - LaTeX-like syntax implementation
- `XMarkdown/` - Extended Markdown (Scientific Markdown)
- `M/` - Enclosure/L0 language implementation
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

- The project uses elm-watch for development with hot reloading
- Generated JavaScript files (main.js) are git-ignored
- Tests are in the `tests/` directory and use elm-test
- Math rendering requires KaTeX to be loaded in the HTML
- The compiler supports differential compilation for efficient live editing
- Interactive blocks include charts (terezka/elm-charts), tables, and iframes
- Theme support allows customizing the rendered output appearance