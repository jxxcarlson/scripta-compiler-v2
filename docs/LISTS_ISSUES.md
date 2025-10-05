# List Handling Issues in LaTeXToScripta2

## Current Problems

### 1. Container blocks are rendered as empty strings
The `itemize` and `enumerate` blocks in `renderOrdinary` return `""`, which means the container environments are completely ignored. This works for simple lists but breaks nested lists because we lose the hierarchical structure.

### 2. Item detection relies on source text
The `renderItem` function checks if `"\\begin{enumerate}"` appears in `block.meta.sourceText` to determine whether to use `"- "` or `". "` prefix. This is fragile and may not work correctly for nested lists.

### 3. No indentation for nested items
The rendering doesn't account for the nesting level of items. For nested lists, we need to add indentation (like `"  - Inner"` for a nested item).

### 4. CompactItem works differently
The `compactItem` function is handled in `renderFunction` and directly outputs `"- " ++ content`, which works for simple cases but doesn't handle the enumerate variant or nesting.

### 5. Tree structure not being utilized
The LaTeX parser creates a tree structure with `itemize`/`enumerate` as parent nodes and `item` nodes as children, but we're flattening this structure by ignoring the parent nodes.

## Root Cause
The fundamental issue is that the current approach treats lists as a flat sequence of items rather than a hierarchical structure.

## Potential Solution Approach
To fix this properly, we'd need to:
- Track nesting depth through the tree structure
- Pass context about whether we're in itemize or enumerate
- Add appropriate indentation based on depth
- Handle the parent-child relationship between list containers and items

## Code References
- `renderOrdinary` in LaTeXToScripta2.elm: lines 205-209 (returns empty string for itemize/enumerate)
- `renderItem` in LaTeXToScripta2.elm: lines 531-554 (checks source text for enumerate detection)
- `renderFunction` in LaTeXToScripta2.elm: lines 405-406 (handles compactItem)
- `renderTree` in LaTeXToScripta2.elm: lines 121-149 (processes tree structure but doesn't pass context)