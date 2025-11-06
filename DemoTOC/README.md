# DemoTOC - Table of Contents Demo

## What This App Does

DemoTOC is a demonstration application that showcases the table of contents (TOC) functionality of the Scripta Compiler V2. It provides:

- **Live Document Editing**: Edit source text in real-time and see the rendered output update immediately
- **Interactive Table of Contents**: Dynamically generated TOC based on document structure (sections, subsections, etc.)
- **Multi-Language Support**: Switch between three markup languages:
  - **MiniLaTeX** - LaTeX-like syntax with mathematical expressions
  - **Scripta (L0)** - Bracket-based markup language
  - **SMarkdown** - Extended Markdown with scientific notation support
- **Collapsible TOC Sections**: Click on TOC entries to expand/collapse nested sections
- **Split-Pane View**: Source text editor on the left, rendered output with TOC on the right

The app demonstrates how the compiler generates hierarchical document structures and produces navigable table of contents for structured documents.

## How to Run

### Prerequisites

- Node.js and npm installed
- Elm 0.19.1 installed

### Quick Start (Recommended)

The easiest way to run the app:

```bash
cd DemoTOC
./run.sh
```

This script will:
- Start `elm-watch hot` for live reloading
- Automatically open Firefox with the app
- Recompile automatically when you save changes

### Alternative: Development Mode Only

If you prefer to open the browser manually:

```bash
cd DemoTOC
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
cd DemoTOC
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

1. **Switch Languages**: Click the language buttons (M, MicroLaTeX, SMarkdown) to see different markup styles
2. **Edit Content**: Modify the source text on the left and watch the TOC update
3. **Navigate Structure**: Click TOC entries to expand/collapse sections
4. **Add Sections**: Try adding new sections/subsections to see the TOC grow dynamically

## Example Documents

The app includes sample documents for each language that demonstrate:
- Hierarchical section structure
- Mathematical expressions (in MiniLaTeX)
- Code blocks
- Lists and formatted text
- Interactive elements
