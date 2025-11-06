# DemoScriptaLive - TODO

## Current Status

**DemoScriptaLive is NOT in working order** following the compiler refactoring. The application needs significant updates to work with the new API.

## Issues

DemoScriptaLive is much more complex than DemoSimple and DemoTOC, which makes the refactoring more involved. The main compilation issues are:

### 1. API Signature Changes

Two key functions have changed signatures and are used extensively throughout the codebase:

- **`ScriptaV2.DifferentialCompiler.editRecordToCompilerOutput`**
  - Old: `editRecordToCompilerOutput theme filter displaySettings editRecord`
  - New: `editRecordToCompilerOutput compilerParameters editRecord`

- **`Render.Settings.makeSettings`**
  - Old: `makeSettings displaySettings theme selectedId selectedSlug scale windowWidth data`
  - New: `makeSettings compilerParameters`

### 2. Many Call Sites to Update

There are 20+ locations in `src/Main.elm` that call these functions with the old signatures:

- ~9 calls to `editRecordToCompilerOutput`
- ~4 calls to `makeSettings`
- Multiple variations with different parameter combinations (e.g., `model.theme` vs `newTheme`)

### 3. Complex Data Flow Issues

- **DisplaySettings doesn't have a language field** - The `Render.Settings.DisplaySettings` type no longer includes language, but `CompilerParameters` requires it. Need to track language separately or restructure how settings are managed.

- **State management complexity** - DemoScriptaLive manages:
  - Document loading/saving
  - Auto-save functionality
  - Theme switching with re-compilation
  - Window resizing with re-compilation
  - Live editing with differential compilation
  - User authentication state
  - Multiple export formats

  This complex state makes it harder to refactor systematically without breaking functionality.

## Work Required

To fix DemoScriptaLive, the following steps are needed:

### Step 1: Create Helper Function

Create a helper function to build `CompilerParameters` from the model's state:

```elm
makeCompilerParametersFromModel : Model -> Filter -> CompilerParameters
makeCompilerParametersFromModel model filter =
    { lang = model.language  -- Need to track this in Model
    , docWidth = model.displaySettings.windowWidth
    , editCount = model.count
    , selectedId = model.selectId
    , selectedSlug = Nothing
    , idsOfOpenNodes = model.displaySettings.idsOfOpenNodes
    , filter = filter
    , theme = Theme.mapTheme model.theme
    , windowWidth = model.windowWidth
    , scale = model.displaySettings.scale
    , longEquationLimit = model.displaySettings.longEquationLimit
    , numberToLevel = model.displaySettings.numberToLevel
    , data = model.displaySettings.data
    }
```

### Step 2: Add Language to Model

The Model type needs to track the current language (MiniLaTeXLang, ScriptaLang, etc.) since DisplaySettings no longer has it.

### Step 3: Update All Call Sites

Systematically update each call to `editRecordToCompilerOutput` and `makeSettings`:

**For editRecordToCompilerOutput:**
```elm
-- Old:
ScriptaV2.DifferentialCompiler.editRecordToCompilerOutput
    (Theme.mapTheme model.theme)
    SuppressDocumentBlocks
    model.displaySettings
    editRecord

-- New:
ScriptaV2.DifferentialCompiler.editRecordToCompilerOutput
    (makeCompilerParametersFromModel model SuppressDocumentBlocks)
    editRecord
```

**For makeSettings:**
```elm
-- Old:
Render.Settings.makeSettings
    model.displaySettings
    (Theme.mapTheme model.theme)
    model.selectId
    Nothing
    1.0
    model.windowWidth
    Dict.empty

-- New:
Render.Settings.makeSettings
    (makeCompilerParametersFromModel model NoFilter)
```

### Step 4: Handle Filter Import

Add to imports:
```elm
import ScriptaV2.Types exposing (Filter(..))
```

And update all references:
- Change `ScriptaV2.Compiler.SuppressDocumentBlocks` to `SuppressDocumentBlocks`
- Change `ScriptaV2.Compiler.NoFilter` to `NoFilter`

### Step 5: Test Thoroughly

After compilation succeeds, test all functionality:
- Document creation/loading/saving
- Live editing and differential compilation
- Theme switching
- Window resizing
- Export to LaTeX
- Auto-save
- Document list management
- User authentication flow

## Related Files

The main files that need updates:
- `src/Main.elm` - Primary location of issues (~20+ call sites)
- `src/Model.elm` - May need to add language field
- `src/Common/Model.elm` - Check if Model type defined here needs updates

## Additional Packages

The missing packages have already been installed:
- ✅ `avh4/elm-color`
- ✅ `rtfeldman/elm-css`

## Notes

- DemoScriptaLive is a production-quality application, not just a demo
- It has many more features than DemoSimple or DemoTOC
- The refactoring is feasible but requires careful, systematic work
- Consider this an opportunity to improve the app's architecture while fixing the compilation issues

## Estimated Effort

- **Time**: 2-3 hours for careful refactoring and testing
- **Complexity**: Medium-High due to number of call sites and state management
- **Risk**: Medium - Many moving parts, but changes are mechanical once the pattern is established
