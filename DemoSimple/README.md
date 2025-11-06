# DemoSimple - Simple Scripta Compiler Demo

## What This App Does

DemoSimple is a minimal demonstration application for the Scripta Compiler V2. It provides a straightforward interface to:

- **Live Document Editing**: Edit source text in real-time and see the rendered output update immediately
- **Multi-Language Support**: Switch between three markup languages:
  - **MiniLaTeX** - LaTeX-like syntax with mathematical expressions via KaTeX
  - **Scripta (L0)** - Bracket-based markup language (formerly called Enclosure)
  - **SMarkdown** - Extended Markdown with scientific notation support
- **Split-Pane View**: Source text editor on the left, rendered output on the right
- **Simple API**: Demonstrates the `ScriptaV2.APISimple` module for basic compilation

This is the simplest demo in the Scripta Compiler V2 suite, focusing on core compilation functionality without additional features like table of contents or advanced navigation.

## How to Run

### Prerequisites

- Node.js and npm installed
- Elm 0.19.1 installed

### Quick Start (Recommended)

The easiest way to run the app:

```bash
cd DemoSimple
./run.sh
```

This script will:
- Start `elm-watch hot` for live reloading
- Automatically open Firefox with the app
- Recompile automatically when you save changes

### Alternative: Development Mode Only

If you prefer to open the browser manually:

```bash
cd DemoSimple
./make.sh
```

This runs `elm-watch hot`, which:
- Compiles the Elm code to JavaScript
- Starts a development server
- Automatically recompiles when you save changes
- You can then open `assets/index.html` in any browser

### Manual Build

If you prefer to build manually:

```bash
cd DemoSimple
elm make src/Main.elm --output=assets/main.js
```

Then open `assets/index.html` in your browser:

```bash
open assets/index.html
# or
ff assets/index.html  # Firefox
cr assets/index.html  # Chrome
```

### Managing Dependencies

If you need to add or update Elm packages, use `elm-json`:

```bash
elm-json install <package-name>
elm-json upgrade
```

## Features to Try

1. **Switch Languages**: Click the language buttons (Enclosure, SMarkdown, MicroLaTeX) to see different markup styles
2. **Edit Content**: Modify the source text on the left and watch the rendered output update immediately
3. **Add Sections**: Try adding new sections and formatted content
4. **Math Support**: In MiniLaTeX mode, try adding mathematical expressions like `$x^2 + y^2 = z^2$`

## Example Documents

The app includes sample documents for each language that demonstrate:
- Section headings
- Text formatting (bold, italic, etc.)
- Mathematical expressions (in MiniLaTeX)
- Code blocks
- Lists
- Blockquotes

## Differences from DemoTOC

Unlike DemoTOC, DemoSimple:
- Does not include table of contents functionality
- Has a simpler, more minimal interface
- Uses `ScriptaV2.APISimple` instead of the full API
- Is ideal for understanding the basic compilation workflow
