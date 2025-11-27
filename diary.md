# Development Diary

## Nov 16, 2025

### Changes in refactor-compiler branch:

**Core refactoring:**
- Exposed `parseToForestWithAccumulator` function from ScriptaV2.Compiler
- Removed unused language argument from `Generic.Compiler.parse_`
- Consolidated compiler API to use unified `compile` function
- See [compilation pipeline documentation](src/ScriptaV2/codePath.md) for details

**Naming improvements:**
- Renamed `M/` folder to `Scripta/` (all modules: Expression, PrimitiveBlock, etc.)
- Renamed parser functions: `parseL` → `parseMiniLaTeX`, `parseX` → `parseSMarkdown`, `parseM` → `parseScripta`
- Renamed `nullParser` → `neverUsedParser`
- Cleaned up Scripta.PrimitiveBlock (removed test helpers from exports)

**Demo fixes:**
- Fixed DemoTOC and DemoSimple to use new `defaultCompilerParameters` API
- Added README.md and run.sh scripts to both demos
- Documented DemoScriptaLive issues in TODO.md (didn't fix it)

**Testing & documentation:**
- Created `tests/ToForestAndAccumulatorTest.elm` (9 tests)
- Created `tests/ToExpressionBlockTest.elm`
- Created `tests/ScriptaPrimitiveBlockTest.elm`
- Added `src/ScriptaV2/codePath.md` documenting compilation pipeline

### Changes to main since then:

- **Renamed MicroLaTeX → MiniLaTeX** (folder and all module imports throughout codebase)
- **Renamed Render.Export.Enclosure → Render.Export.Scripta**
- **Added Render.Pretty module** for tree-based pretty printing with indentation
- **Added Generic.Language.printBlock** function to convert ExpressionBlocks back to source text
- **Removed DemoScriptaLive entirely** (57k+ lines) since it needed extensive refactoring

### Notes:

The refactor-compiler branch has been merged into main and deleted. All work now continues on main branch.
