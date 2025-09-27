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
- parseL implemented using existing MicroLaTeX parser
- Working on renderS implementation

## renderS Implementation Details

### Block Rendering Approach
The renderS function uses a helper function `renderBlock : ExpressionBlock -> String` to convert individual blocks. The implementation traverses the forest structure and maintains proper indentation for Scripta's syntax.

### Indentation Strategy
Scripta (Enclosure language) uses indentation to represent hierarchical structure. The implementation:
- Uses `renderTree` with an indent parameter (starting at 0)
- Each level adds 2 spaces of indentation
- Children are rendered with `indent + 1`
- This preserves the tree structure that Scripta needs to parse correctly

Example output structure:
```
block
  block
    block
  block
block
```

### Implementation Pattern
```elm
renderS : Forest ExpressionBlock -> String
renderS forest =
    forest
        |> List.map (renderTree 0)
        |> String.join "\n\n"

renderTree : Int -> Tree ExpressionBlock -> String
renderTree indent tree =
    -- Create indentation, render current block
    -- Recursively render children with increased indentation
    -- Combine results

renderBlock : ExpressionBlock -> String
renderBlock block =
    -- Convert individual block to Scripta syntax
```

## Testing Implementation

### Test Module Structure
Created `Render.Export.LaTeXToScripta2Test` module with simple string-based tests that can be run in the browser:
- Test 1: Simple paragraph conversion
- Test 2: Section with content
- Test 3: Nested sections structure

### Test Runner
Created `TestLaTeXToScripta.elm` in DemoScriptaLive that compiles to HTML for viewing test results.

### Current Test Output
With the placeholder `renderBlock` implementation, the tests produce properly indented "block" strings, confirming the tree traversal and indentation logic works correctly.

## renderBlock Implementation Strategy

### Case Analysis Approach
The `renderBlock` function needs to perform case analysis on the ExpressionBlock to handle different LaTeX constructs. Implementation will proceed gradually by:

1. **Identifying block types** - Examine the ExpressionBlock structure to determine the type (section, paragraph, environment, etc.)
2. **Pattern matching** - Use case expressions to handle each block type
3. **Incremental implementation** - Add cases one at a time, testing each addition

### Planned Cases (to be implemented gradually):
```elm
renderBlock : ExpressionBlock -> String
renderBlock block =
    case getBlockType block of
        Paragraph ->
            -- Convert paragraph content

        Section level ->
            -- Convert \section, \subsection, etc.

        Environment name ->
            -- Convert \begin{env}...\end{env}

        MathBlock ->
            -- Convert display math

        Verbatim ->
            -- Convert verbatim/code blocks

        List listType ->
            -- Convert itemize, enumerate

        _ ->
            -- Default case for unhandled blocks
            "block"
```

Each case will be implemented and tested individually to ensure correctness.