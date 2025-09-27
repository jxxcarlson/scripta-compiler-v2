# LaTeX to Scripta Translation

## Overview

Create a new module `Render.Export.LaTeXToScripta2` with a function `translate : String -> String` that maps LaTeX source code to Scripta (Enclosure) source code.

## Architecture

The translation function is factored into two pieces:

```elm
parseL : String -> List (Tree ExpressionBlock)  -- map LaTeX source code to AST
renderS : List (Tree ExpressionBlock) -> String  -- render the AST to a String

translate = parseL >> renderS
```

## Implementation Plan

### Phase 1: parseL Function
- Derive from existing MicroLaTeX parser code
- Convert LaTeX source to AST representation

### Phase 2: renderS Function
- Take the AST and render it as Scripta (Enclosure) syntax
- Will be implemented after parseL is complete

## Current Status
- Working on implementing parseL first
- renderS implementation to follow with further directions and suggestions