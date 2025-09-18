# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the DemoSimple application for Scripta Compiler V2, a web-based compiler/renderer for multiple markup languages:
- MicroLaTeX (LaTeX-like syntax)
- SMarkdown (Scripta Markdown)
- Enclosure Language (pipe-based block syntax)

The demo provides a live editor with real-time rendering in a split-pane interface.

## Development Commands

```bash
# Start development server with hot reloading
./make.sh
# or directly:
npx elm-watch hot

# Run code review
npm run review

# Generate call graph
npm run cgraph

# Production build
elm make src/Main.elm --output=./assets/main.js
```

## Architecture

The project follows standard Elm Architecture with:
- **Main.elm**: Application entry point implementing TEA (The Elm Architecture)
- **ScriptaV2.API**: Core compiler API (`compile` function)
- **Data/*.elm**: Sample texts demonstrating each language syntax

Key architectural points:
- The actual compiler lives in `../src/ScriptaV2/` (parent directory)
- This demo wraps the compiler with a UI for testing
- Real-time compilation happens on every text change
- KaTeX is loaded for mathematical expression rendering

## Important Notes

- When modifying UI, ensure responsive layout works with window resizing
- Language switching loads sample data from `Data/` modules
- The `elm-watch.json` config enables hot reloading during development
- Review rules in `scripts.yaml` check for proper MagicToken usage