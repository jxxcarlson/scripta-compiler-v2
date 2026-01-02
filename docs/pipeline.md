Here’s the Scripta compiler pipeline, end to end.

  - High-level flow

    - Source Text → Lines → Primitive Blocks → Forest → Expression Blocks → Accumulator Transform → Render → elm-ui Elements, as outlined in the Code Flow for ScriptaV2.APISimple.compile .


  - Entry points

    - Simple one-shot: ScriptaV2.APISimple.compile takes a source string, splits it into lines, compiles, then immediately lays out the final elements for display .
    - Two-step API: ScriptaV2.API.compileOutput produces a CompilerOutput (body, banner, toc, title), and viewBodyOnly/viewTOC render pieces of it as needed .


  - Core compile step

    - ScriptaV2.Compiler.compile delegates to parseToForestWithAccumulator, then passes its result to render; the return is a CompilerOutput that the view step arranges into the UI .


  - Parsing and language selection

    - parseToForestWithAccumulator chooses the parser from CompilerParameters.lang:

      - MicroLaTeXLang → parseL (MicroLaTeX)
      - SMarkdownLang/MarkdownLang → parseX (XMarkdown)
      - EnclosureLang → parseM (Enclosure/L0) It then optionally filters the forest and performs an accumulator transform, returning (Accumulator, Forest ExpressionBlock) . The supported languages are explicitly MicroLaTeX, SMarkdown/Markdown, and Enclosure/L0 .



  - Generic parsing pipeline

    - The generic parser builds structure in stages: primitiveBlockParser → forestFromBlocks → map toExpressionBlock, yielding a Forest of ExpressionBlocks ready for later passes .


  - Accumulator pass (now earlier)

    - The accumulator (for numbering, cross-references, etc.) is computed in parseToForestWithAccumulator rather than inside render, making it available to callers before rendering and improving modularity and flexibility .


  - Render phase

    - render receives the pre-transformed accumulator and forest, constructs render settings, generates the TOC, extracts banner/title, and renders the forest by mapping Render.Tree.renderTree recursively to elm-ui Elements .


  - Final layout

    - ScriptaV2.Compiler.view arranges the header (banner, title, TOC) and the body elements into the final list of elm-ui Elements for display . CompilerOutput contains body, banner, toc, and title, which the view step consumes .


  - Notes on incremental edits

    - CompilerParameters includes editCount to support differential (incremental) updates; the pipeline is designed to minimize work during live editing by reusing unchanged parts and re-rendering only what changed  .
