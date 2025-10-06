# LaTeX Export Source Line Annotation

## Overview

The LaTeX export annotates each exported block with a comment indicating its source line number, enabling better debugging, error reporting, and traceability between source documents and generated LaTeX.

## Example

Given source text:
```
| image
https://example.com/image.jpg
width: 400
caption: Humming bird
```

at line 500, the exported LaTeX will be:

```latex
%%% Line 500
\begin{figure}[h]
  \centering
  \includegraphics[width=0.51\textwidth]{https://example.com/image.jpg}
  \caption{Humming bird}
  \label{fig:hummingbird}
\end{figure}
```

## Architecture

### Export Pipeline

1. **`rawExport`** → processes a forest of `Tree ExpressionBlock`
2. **`exportTree`** → recursively handles each tree node (annotation happens here)
3. **`exportBlock`** → generates LaTeX for individual blocks

### Implementation Location

Annotations are injected at the **`exportTree`** level because:
- It's called once per tree node, before recursing into children
- Has access to `Tree.value tree` to get the `ExpressionBlock` metadata
- Can check if line number exists (to skip synthetic blocks)
- Easy to prepend comment before calling `exportBlock`

### Metadata Structure

Each `ExpressionBlock` contains a `meta` field with source location:

```elm
meta = {
  error = Nothing,
  id = "3-0",
  lineNumber = 1,           -- Source line number
  messages = [],
  numberOfLines = 3,
  position = 0,
  sourceText = "A:\n1\n2"
}
```

## Design Decisions

### Comment Format

- **Format**: `%%% Line N`
- **Rationale**: Matches existing `%%%` comment style in codebase
- **Alternative considered**: `%%% Line 500 (image)` - adds block type, but more verbose

### Comment Placement

Comments appear on their own line before the block:
```latex
%%% Line 500
\begin{figure}[h]
  ...
\end{figure}
```

Not inline:
```latex
\begin{figure}[h]  % Line 500  (NOT USED)
```

**Rationale**: Cleaner and doesn't interfere with LaTeX syntax

### What Gets Tagged

- **All blocks with valid source line numbers**: Sections, paragraphs, images, theorems, etc.
- **Excluded**: Synthetic blocks (e.g., `beginItemizedBlock`, `endItemizedBlock`) created by the compiler that don't correspond to source lines
- **Natural filtering**: Synthetic blocks lack valid line numbers, so they're automatically skipped

### Nested Structures

Each nested block receives its own annotation:
```latex
%%% Line 10
\section{Introduction}

%%% Line 12
This is a paragraph.

%%% Line 14
\begin{itemize}

%%% Line 15
\item First item

%%% Line 16
\item Second item

%%% Line 17
\end{itemize}
```

## Benefits

1. **Debugging**: When LaTeX compilation errors occur, immediately identify the source line
2. **Round-tripping**: Enables tools to navigate between source ↔ LaTeX ↔ PDF
3. **Error reporting**: Provides better error messages to users
4. **Minimal overhead**: Just string concatenation, no performance impact
5. **Audit trail**: Full traceability of how source maps to LaTeX

## Implementation

See `src/Render/Export/LaTeX.elm`:
- `exportTree` function checks `block.meta.lineNumber`
- Prepends `%%% Line N\n` when valid line number exists
- Synthetic blocks (no line number or lineNumber <= 0) are not annotated

## Future Enhancements

Potential improvements:
- Include block type in comment: `%%% Line 500 (image)`
- Generate source maps in separate file (JSON) for tool integration
- Add column number information if needed
- Optional flag to disable annotations for cleaner output
