# Code Flow: ScriptaV2.APISimple.compile

This document traces the execution path when invoking `ScriptaV2.APISimple.compile`.

## Overview

The compilation process transforms markup source text through a multi-stage pipeline:

```
Source Text → Lines → Primitive Blocks → Forest → Expression Blocks → Accumulator Transform → Render → elm-ui Elements
```

## Detailed Flow

### 1. Entry Point: ScriptaV2.APISimple.compile
**Location:** `src/ScriptaV2/APISimple.elm:52-54`

```elm
compile : CompilerParameters -> String -> List (Element MarkupMsg)
compile params sourceText =
    ScriptaV2.Compiler.compile params (String.lines sourceText)
    |> ScriptaV2.Compiler.view params.docWidth
```

**What it does:**
- Converts source text to lines using `String.lines`
- Passes to the core compiler
- Pipes the result to view function for final rendering

---

### 2. Core Compilation: ScriptaV2.Compiler.compile
**Location:** `src/ScriptaV2/Compiler.elm:159-161`

```elm
compile : CompilerParameters -> List String -> CompilerOutput
compile params lines =
    render params (parseToForestWithAccumulator params lines)
```

**What it does:**
- Calls `parseToForestWithAccumulator` to parse lines and transform accumulator
- Passes the result to `render` for final rendering
- Returns a `CompilerOutput` containing body, banner, toc, and title

---

### 3. Parse to Forest with Accumulator: parseToForestWithAccumulator
**Location:** `src/ScriptaV2/Compiler.elm:286-307`

```elm
parseToForestWithAccumulator : CompilerParameters -> List String -> ( Accumulator, Forest ExpressionBlock )
parseToForestWithAccumulator params lines =
    let
        parser =
            case params.lang of
                EnclosureLang -> parseM
                MicroLaTeXLang -> parseL
                SMarkdownLang -> parseX
                MarkdownLang -> parseX

        forest =
            filterForest params.filter (parser Config.idPrefix params.editCount lines)
    in
    Generic.Acc.transformAccumulate Generic.Acc.initialData forest
```

**What it does:**
1. Selects the appropriate parser based on `params.lang`
2. Parses lines into a Forest using the selected parser (parseL, parseM, or parseX)
3. Applies optional filtering with `filterForest`
4. Transforms the forest with accumulator to track cross-references, numbering, etc.
5. Returns a tuple of `(Accumulator, Forest ExpressionBlock)`

**Note:** This function consolidates the logic previously split across `compileL`, `compileM`, and `compileX`, making the accumulator transformation accessible earlier in the pipeline.

---

### 4. Parsing: parseL / parseM / parseX
**Location:** `src/ScriptaV2/Compiler.elm:250-252` (parseL example)

```elm
parseL : String -> Int -> List String -> Forest ExpressionBlock
parseL idPrefix outerCount lines =
    Generic.Compiler.parse_ MicroLaTeXLang
        MicroLaTeX.PrimitiveBlock.parse
        MicroLaTeX.Expression.parse
        idPrefix
        outerCount
        lines
```

**What it does:**
- Calls the generic parser with language-specific parsers
- `MicroLaTeX.PrimitiveBlock.parse` for block-level parsing
- `MicroLaTeX.Expression.parse` for inline expression parsing

---

### 5. Generic Parsing Pipeline: Generic.Compiler.parse_
**Location:** `src/Generic/Compiler.elm:19-31`

```elm
parse_ : Language
    -> (String -> Int -> List String -> List Generic.Language.PrimitiveBlock)
    -> (Int -> String -> List Generic.Language.Expression)
    -> String
    -> Int
    -> List String
    -> List (RoseTree.Tree.Tree ExpressionBlock)
parse_ lang primitiveBlockParser exprParser idPrefix outerCount lines =
    lines
        |> primitiveBlockParser idPrefix outerCount
        |> Generic.ForestTransform.forestFromBlocks .indent
        |> Generic.Forest.map (Generic.Pipeline.toExpressionBlock exprParser)
```

**The pipeline consists of three steps:**

#### Step 5a: Primitive Block Parsing
- Takes lines of text and groups them into structured blocks
- Recognizes block types: paragraphs, headers, code blocks, lists, etc.
- Preserves indentation information

#### Step 5b: Forest Transform
**Location:** `src/Generic/ForestTransform.elm:56-58`

```elm
forestFromBlocks : (b -> Int) -> List b -> List (Tree b)
forestFromBlocks indentation blocks =
    Library.Forest.makeForest indentation blocks
```

- Converts flat list of blocks into a tree/forest structure
- Uses indentation to determine parent-child relationships
- Creates hierarchical document structure (sections, subsections, etc.)

#### Step 5c: Expression Block Transform
**Location:** `src/Generic/Pipeline.elm:12-15`

```elm
toExpressionBlock : (Int -> String -> List Expression) -> PrimitiveBlock -> ExpressionBlock
toExpressionBlock parser block =
    toExpressionBlock_ (parser block.meta.lineNumber) block
        |> Generic.Language.boostBlock
```

- Parses inline expressions within each block
- Handles different block types (Paragraph, Ordinary, Verbatim)
- Converts text content to parsed expression trees
- Special handling for lists, tables, and other structured content

---

### 6. Filtering: filterForest
**Location:** `src/ScriptaV2/Compiler.elm:280-289`

```elm
filterForest : Filter -> Forest ExpressionBlock -> Forest ExpressionBlock
filterForest filter forest =
    case filter of
        NoFilter -> forest
        SuppressDocumentBlocks ->
            forest
                |> Generic.ASTTools.filterForestOnLabelNames (\name -> name /= Just "document")
                |> Generic.ASTTools.filterForestOnLabelNames (\name -> name /= Just "title")
```

**What it does:**
- Optionally filters out certain block types
- Useful for embedding documents or showing partial content

---

### 7. Rendering: render
**Location:** `src/ScriptaV2/Compiler.elm:310-348`

```elm
render : CompilerParameters -> ( Accumulator, Forest ExpressionBlock ) -> CompilerOutput
render params ( accumulator_, forest_ ) =
    let
        renderSettings : Render.Settings.RenderSettings
        renderSettings =
            Render.Settings.defaultRenderSettings params

        viewParameters =
            { idsOfOpenNodes = params.idsOfOpenNodes
            , selectedId = params.selectedId
            , counter = params.editCount
            , attr = []
            , settings = renderSettings
            }

        toc : List (Element MarkupMsg)
        toc =
            Render.TOCTree.view params.theme viewParameters accumulator_ forest_

        banner : Maybe (Element MarkupMsg)
        banner =
            Generic.ASTTools.banner forest_
                |> Maybe.map (Render.Block.renderBody params.editCount accumulator_ renderSettings [ Font.color (Element.rgb 1 0 0) ])
                |> Maybe.map (Element.row [ Element.height (Element.px 40) ])

        title : Element MarkupMsg
        title =
            Element.paragraph [] [ Element.text <| Generic.ASTTools.title forest_ ]
    in
    { body =
        renderForest params renderSettings accumulator_ forest_
    , banner = banner
    , toc = toc
    , title = title
    }
```

**What it does:**
1. Accepts a tuple of `(Accumulator, Forest ExpressionBlock)` from `parseToForestWithAccumulator`
2. Creates render settings from parameters
3. Creates view parameters for rendering
4. Generates table of contents using the pre-transformed accumulator
5. Extracts and renders banner (if present)
6. Extracts document title
7. Renders the main body using `renderForest` with the pre-transformed accumulator

**Key change:** The accumulator is now passed in as a parameter rather than being computed inside `render`. This allows external code to access the accumulator before rendering, enabling more advanced use cases.

---

### 8. Forest Rendering: renderForest
**Location:** `src/ScriptaV2/Compiler.elm:379-386`

```elm
renderForest : CompilerParameters
    -> Render.Settings.RenderSettings
    -> Generic.Acc.Accumulator
    -> List (RoseTree.Tree.Tree ExpressionBlock)
    -> List (Element MarkupMsg)
renderForest params settings accumulator forest =
    List.map (Render.Tree.renderTree params settings accumulator []) forest
```

**What it does:**
- Maps `Render.Tree.renderTree` over each tree in the forest
- Each tree becomes a rendered elm-ui `Element`

---

### 9. Tree Rendering: Render.Tree.renderTree
**Location:** `src/Render/Tree.elm:30-100`

```elm
renderTree : CompilerParameters
    -> RenderSettings
    -> Accumulator
    -> List (Element.Attribute MarkupMsg)
    -> Tree ExpressionBlock
    -> Element MarkupMsg
```

**What it does:**
- Recursively renders each tree node and its children
- Applies styling based on block type and theme
- Handles special cases like box-like blocks with borders
- Delegates to block-type-specific renderers
- Returns elm-ui `Element` nodes

---

### 10. Final Layout: ScriptaV2.Compiler.view
**Location:** `src/ScriptaV2/Compiler.elm:69-74`

```elm
view : Int -> CompilerOutput -> List (Element MarkupMsg)
view width_ compiled =
    [ Element.column [ Element.width (Element.px (width_ - 60)) ]
        (header compiled)
    , body compiled
    ]
```

**What it does:**
- Arranges the compiled output into final layout
- `header` includes banner (if present), title, and table of contents
- `body` contains the main rendered content
- Returns list of elm-ui Elements ready for display

**Header function** (line 120-133):
```elm
header : CompilerOutput -> List (Element MarkupMsg)
header compiled =
    case compiled.banner of
        Nothing ->
            Element.el [ Font.size 32, bottomPadding 18 ] compiled.title
                :: Element.column [ Element.spacing 8, bottomPadding 72 ] compiled.toc
                :: []
        Just banner ->
            Element.el [] banner
                :: Element.el [ Font.size 32, bottomPadding 18 ] compiled.title
                :: Element.column [ Element.spacing 8, bottomPadding 36 ] compiled.toc
                :: []
```

**Body function** (line 137-140):
```elm
body : CompilerOutput -> Element MarkupMsg
body compiled =
    Element.column [ Element.spacing 18, Element.alignTop ] compiled.body
```

---

## Key Data Structures

### CompilerParameters
Defined in `ScriptaV2.Types`:
- `lang: Language` - Which markup language to compile
- `docWidth: Int` - Width of rendered document in pixels
- `editCount: Int` - Counter for differential compilation
- `selectedId: String` - Currently selected element ID
- `idsOfOpenNodes: List String` - For collapsible sections
- `filter: Filter` - Optional filtering of blocks
- `theme: Theme` - Light or dark theme

### CompilerOutput
Defined in `src/ScriptaV2/Compiler.elm:260-265`:
```elm
type alias CompilerOutput =
    { body : List (Element MarkupMsg)
    , banner : Maybe (Element MarkupMsg)
    , toc : List (Element MarkupMsg)
    , title : Element MarkupMsg
    }
```

### Forest ExpressionBlock
- A forest is a `List (Tree ExpressionBlock)`
- Each tree represents a top-level section and its nested content
- ExpressionBlock contains:
  - `heading`: Block type (Paragraph, Ordinary name, Verbatim name)
  - `indent`: Indentation level
  - `body`: Either raw text (Left) or parsed expressions (Right)
  - `properties`: Dictionary of metadata
  - `meta`: Line numbers, IDs, etc.

---

## Pipeline Summary

```
1. ScriptaV2.APISimple.compile
   ↓
2. String.lines (convert to line list)
   ↓
3. ScriptaV2.Compiler.compile
   ↓
4. parseToForestWithAccumulator
   ├─ Select parser based on language (parseL/M/X)
   ├─ Generic.Compiler.parse_
   │  ├─ primitiveBlockParser → List PrimitiveBlock
   │  ├─ forestFromBlocks → Forest PrimitiveBlock
   │  └─ map toExpressionBlock → Forest ExpressionBlock
   ├─ filterForest (optional filtering)
   └─ Generic.Acc.transformAccumulate → (Accumulator, Forest)
   ↓
5. render (receives pre-transformed accumulator and forest)
   ├─ Create render settings
   ├─ Generate TOC using accumulator
   ├─ Extract and render banner
   ├─ Extract title
   └─ renderForest
      └─ map Render.Tree.renderTree
         └─ Recursive tree rendering to elm-ui Elements
   ↓
6. ScriptaV2.Compiler.view (final layout)
   ↓
7. List (Element MarkupMsg) - Ready for display
```

**Key architectural change:** The accumulator transformation now happens in `parseToForestWithAccumulator` (step 4) rather than inside `render` (step 5). This makes the accumulator available earlier and allows external code to access it before rendering.

---

## Refactoring Benefits

### Consolidated Architecture
The refactoring consolidates three language-specific compilation functions (`compileL`, `compileM`, `compileX`) into a single unified flow through `parseToForestWithAccumulator`. This:
- Reduces code duplication
- Makes the compilation flow easier to understand
- Simplifies maintenance and future changes

### Early Accumulator Access
Moving the accumulator transformation from `render` into `parseToForestWithAccumulator` provides several advantages:

1. **External Access**: Code outside the compiler can now call `parseToForestWithAccumulator` to get both the accumulator and the forest, enabling advanced use cases like:
   - Custom TOC generation before rendering
   - Cross-reference extraction
   - Section numbering queries
   - Custom transformations based on accumulator data

2. **Flexibility**: The `render` function now accepts a pre-transformed accumulator, allowing callers to:
   - Modify the accumulator before rendering
   - Use the same accumulator for multiple render operations
   - Implement custom accumulator logic

3. **Separation of Concerns**: Parsing and accumulator transformation are now clearly separated from rendering, making the architecture more modular.

### Backward Compatibility
Despite these internal changes, the public API remains unchanged:
- `ScriptaV2.APISimple.compile` works exactly as before
- `ScriptaV2.Compiler.compile` maintains the same signature
- Existing code continues to work without modification

---

## Key Abstractions

### Generic Pipeline
The compiler is language-agnostic at its core. Each language provides:
1. **Primitive Block Parser**: Recognizes block-level structures
2. **Expression Parser**: Parses inline expressions

These plug into the generic pipeline in `Generic.Compiler.parse_`.

### Accumulator Pattern
The accumulator (`Generic.Acc`) tracks cross-cutting concerns during rendering:
- Section numbering (1, 1.1, 1.2, etc.)
- Cross-references and labels
- Footnote numbering
- Equation numbering
- Pass data between blocks

### Forest Structure
Documents are represented as forests (lists of trees) rather than flat lists:
- Naturally represents document hierarchy
- Enables collapsible sections
- Simplifies TOC generation
- Supports nested content (lists, quotations, etc.)

---

## Example Execution

Given input:
```latex
\\section{Introduction}

This is a paragraph with \\strong{bold} text.

\\subsection{Details}

More content here.
```

Flow:
1. Split into lines: `["\\section{Introduction}", "", "This is...", ...]`
2. Parse primitive blocks: Three blocks (section, paragraph, subsection)
3. Build forest: Section tree with paragraph and subsection as children
4. Parse expressions: `\\strong{bold}` becomes `Fun "strong" [Text "bold"] meta`
5. Transform accumulator: Assign section numbers
6. Render trees: Each block becomes elm-ui Elements
7. Assemble layout: Header with TOC, body with rendered content

---

## Performance Considerations

### Differential Compilation
The `editCount` parameter enables incremental updates:
- Changed blocks are re-parsed and re-rendered
- Unchanged blocks reuse previous render
- Crucial for live editing with large documents

### Accumulator Pass
Single pass through the document for:
- Section numbering
- Cross-reference resolution
- Label collection
- More efficient than multiple traversals
