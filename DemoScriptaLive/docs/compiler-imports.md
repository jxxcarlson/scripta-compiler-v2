# Compiler Imports Used in DemoScriptaLive

This document lists all functions and types imported from the Scripta compiler (`../src`) that are used in the DemoScriptaLive application, organized by fully qualified module name.

---

## ScriptaV2.API

**Exposed:** `compileStringWithTitle`

**Used in:**
- `src/Main.elm`
- `src/MainLocal.elm`
- `src/MainSQLite.elm`
- `src/MainTauri.elm`
- `src/Common/View.elm`

---

## ScriptaV2.Compiler

**Exposed:** `CompilerOutput`, `SuppressDocumentBlocks`, `parseFromString`, `viewTOC`

**Used in:**
- `src/Model.elm`
- `src/Main.elm`
- `src/MainLocal.elm`
- `src/MainSQLite.elm`
- `src/MainTauri.elm`
- `src/Common/Model.elm`
- `src/Common/View.elm`
- `src/Frontend/PDF.elm`

---

## ScriptaV2.DifferentialCompiler

**Exposed:** `EditRecord`, `init`, `update`, `editRecordToCompilerOutput`

**Used in:**
- `src/Model.elm`
- `src/Main.elm`
- `src/MainLocal.elm`
- `src/MainSQLite.elm`
- `src/MainTauri.elm`
- `src/Common/Model.elm`
- `src/Common/View.elm`

---

## ScriptaV2.Helper

**Exposed:** `getImageUrls`, `matchingIdsInAST`

**Used in:**
- `src/Main.elm`
- `src/MainLocal.elm`
- `src/MainSQLite.elm`
- `src/MainTauri.elm`
- `src/EditorSync.elm`
- `src/Frontend/PDF.elm`

---

## ScriptaV2.Language

**Exposed:** `Language`, `EnclosureLang`

**Used in:**
- `src/Model.elm`
- `src/Main.elm`
- `src/MainLocal.elm`
- `src/MainSQLite.elm`
- `src/MainTauri.elm`
- `src/Common/Model.elm`
- `src/Common/View.elm`
- `src/Frontend/PDF.elm`

---

## ScriptaV2.Msg

**Exposed:** `MarkupMsg(..)` (including `SelectId`, `SendLineNumber`)

**Used in:**
- `src/Model.elm`
- `src/Main.elm`
- `src/MainLocal.elm`
- `src/MainSQLite.elm`
- `src/MainTauri.elm`
- `src/Common/Model.elm`
- `src/Common/View.elm`

---

## ScriptaV2.Settings

**Exposed:** `DisplaySettings`

**Used in:**
- `src/Model.elm`
- `src/Common/Model.elm`

---

## Render.Export.LaTeX

**Exposed:** `export`, `rawExport`

**Used in:**
- `src/Main.elm`
- `src/MainLocal.elm`
- `src/MainSQLite.elm`
- `src/MainTauri.elm`
- `src/Frontend/PDF.elm`

---

## Render.Export.LaTeXToScripta

**Exposed:** Module imported for LaTeX to Scripta conversion (typically aliased as `L2S`)

**Used in:**
- `src/MainSQLite.elm`
- `src/DebugTest.elm`
- `src/TestFigure.elm`
- `src/QuickTest.elm`
- `src/MinimalHrefTest.elm`
- `src/DebugImageCaptioned.elm`
- `src/DebugSection.elm`
- `src/DebugAlign.elm`
- `src/DebugSubsection.elm`
- `src/TestImageCaptioned.elm`

---

## Render.Export.LaTeXToScriptaTest

**Exposed:** Test utilities (typically aliased as `Test`)

**Used in:**
- `src/TestDebug.elm`
- `src/TestDirect.elm`
- `src/DebugAlign.elm`
- `src/TestLaTeXToScripta.elm`

---

## Render.Export.Image

**Exposed:** `exportBlock`, `export`

**Used in:**
- `src/Export.elm`

---

## Render.Export.Preamble

**Exposed:** `make`

**Used in:**
- `src/Export.elm`

---

## Render.Export.Util

**Exposed:** `getTwoArgs`, `getOneArg`, `getArgs`

**Used in:**
- `src/Export.elm`

---

## Render.Settings

**Exposed:** `RenderSettings`, `makeSettings`, `getThemedElementColor`

**Used in:**
- `src/Main.elm`
- `src/MainLocal.elm`
- `src/MainSQLite.elm`
- `src/MainTauri.elm`
- `src/Export.elm`
- `src/Style.elm`
- `src/Frontend/PDF.elm`

---

## Render.Theme

**Exposed:** `Theme` (Light, Dark)

**Used in:**
- `src/Theme.elm`

---

## Render.NewColor

**Exposed:** Color values (all exposed: `whiteAlpha100`, `gray950`, `indigo200`, `gray900`, `gray920`, `gray100`, `gray700`, `gray200`, `blue100`, `gray400`, `blue700`, `gray600`, `transparentIndigo500`)

**Used in:**
- `src/Theme.elm`

---

## Render.Data

**Exposed:** `prepareTable`

**Used in:**
- `src/Export.elm`

---

## Render.Utility

**Exposed:** `getArg`

**Used in:**
- `src/Export.elm`

---

## Generic.ASTTools

**Exposed:** (as `ASTTools`) - `getBlockArgsByName`, `rawBlockNames`, `expressionNames`, `getVerbatimBlockValue`, `frontMatterDict`, `title`, `filterForestOnLabelNames`

**Used in:**
- `src/Export.elm`

---

## Generic.BlockUtilities

**Exposed:** `getExpressionBlockName`, `condenseUrls`, `updateMeta`

**Used in:**
- `src/Export.elm`

---

## Generic.Forest

**Exposed:** `Forest`, `map`

**Used in:**
- `src/Export.elm`

---

## Generic.Language

**Exposed:** `Expr(..)`, `Expression`, `ExpressionBlock`, `Heading(..)`, `PrimitiveBlock`, `Text`, `Fun`, `VFun`, `ExprList`, `expressionBlockEmpty`

**Used in:**
- `src/Export.elm`
- `src/DebugAlign.elm`

---

## Generic.TextMacro

**Exposed:** `getTextMacroFunctionNames`, `exportTexMacros`, `extract`, `toString`

**Used in:**
- `src/Export.elm`

---

## MicroLaTeX.Util

**Exposed:** `transformLabel`, `normalizedWord`

**Used in:**
- `src/Export.elm`

---

## ETeX.Transform

**Exposed:** `MathMacroDict`, `makeMacroDict`, `transformETeX`, `toLaTeXNewCommands`

**Used in:**
- `src/Export.elm`

---

## Summary Statistics

- **Total unique compiler modules imported:** 24
- **Most heavily used modules:**
  1. `ScriptaV2.Compiler` - 8 files
  2. `ScriptaV2.Language` - 8 files
  3. `ScriptaV2.DifferentialCompiler` - 7 files
  4. `ScriptaV2.Msg` - 7 files
  5. `Render.Export.LaTeX` - 5 files

### Main Application Files

The following files are the primary entry points using the compiler:
- `Main.elm` - Primary entry point with LocalStorage
- `MainSQLite.elm` - SQLite backend variant
- `MainTauri.elm` - Tauri desktop app variant
- `MainLocal.elm` - Local storage variant
- `Common/View.elm` - Shared view components
- `Common/Model.elm` - Shared model types

### Test and Debug Files

Multiple `Debug*.elm` and `Test*.elm` files use `Render.Export.LaTeXToScripta` for conversion testing.

### Usage Patterns

DemoScriptaLive primarily uses:
- **High-level API** (`ScriptaV2.*`) - For compilation and language handling
- **Differential Compiler** - For incremental updates during live editing
- **Rendering Utilities** (`Render.*`) - For settings, themes, and export
- **Generic Modules** - Used directly only in `Export.elm` for custom export functionality