# ETeX.KaTeX Module Documentation

## Development Log

I've created a comprehensive `ETeX.KaTeX` module with the `isKaTeX` function. The module includes:

1. **Greek Letters** - All standard Greek letters and variants
2. **Binary Operators** - Mathematical operators like `+`, `×`, `⊕`, etc.
3. **Relation Symbols** - Comparison and relation operators
4. **Arrows** - All arrow types including implications
5. **Delimiters** - Brackets, braces, angles, etc.
6. **Big Operators** - Summation, product, integrals
7. **Math Functions** - Trig functions, logs, limits, etc.
8. **Accents** - Hat, tilde, overline, etc.
9. **Fonts** - Math fonts like `\mathbb`, `\mathcal`, etc.
10. **Spacing** - Various spacing commands
11. **Logic and Set Theory** - Logical operators and set symbols
12. **Miscellaneous Symbols** - Special symbols, currency, etc.
13. **Fractions** - Fraction commands
14. **Binomials** - Binomial coefficient commands
15. **Roots** - Square root and related
16. **Text Operators** - Cancel, overline, stacking operators

The function `isKaTeX : String -> Bool` checks if a command (without the backslash) is supported by KaTeX. For example:
- `isKaTeX "sin"` returns `True`
- `isKaTeX "frac"` returns `True`
- `isKaTeX "notacommand"` returns `False`

This should cover the vast majority of KaTeX commands. The Set-based implementation ensures fast O(log n) lookups even with hundreds of commands.

# ETeX.MathMacros2 Parser with Function Call Support

The parser in `ETeX.MathMacros2` now correctly handles both KaTeX macros and function calls using lookahead parsing:

1. `parse "yoyo(pi)"` → `Ok [FCall "yoyo" [PArg [AlphaNum "pi"]]]` ✓
2. `parse "sin(pi)"` → `Ok [Macro "sin" [PArg [AlphaNum "pi"]]]` ✓ (because sin is a KaTeX command)
3. `parse "\\sin{pi}"` → `Ok [Macro "sin" [Arg [AlphaNum "pi"]]]` ✓

The parser now correctly:
- Distinguishes between KaTeX commands and regular function calls
- Uses `Macro` for KaTeX commands (like "sin")
- Uses `FCall` for non-KaTeX function calls (like "yoyo")
- Handles both parenthetical arguments `()` and brace arguments `{}`
- Properly parses commas in function arguments

The key improvements made:
1. Removed standalone `leftParenParser` and `rightParenParser` from the main parser list
2. Removed standalone `parentheticalExprParser` from the main parser list  
3. Added `Comma` type and `commaParser`
4. Excluded comma from `mathSymbolsParser`
5. Used lookahead parsing with `alphaNumWithLookaheadParser` to check for parentheses after alphanumeric strings

The lookahead parser implementation:
```elm
alphaNumWithLookaheadParser : PA.Parser Context Problem MathExpr
alphaNumWithLookaheadParser =
    succeed identity
        |= alphaNumParser_
        |> PA.andThen
            (\name ->
                oneOf
                    [ -- Check if followed by '(' and parse the parenthetical group
                      parentheticalExprParser
                        |> PA.map
                            (\arg ->
                                if isKaTeX name then
                                    Macro name [ arg ]
                                else
                                    FCall name [ arg ]
                            )
                    , -- Otherwise, just return as AlphaNum
                      succeed (AlphaNum name)
                    ]
            )
```

This approach avoids parser conflicts by using `andThen` to first parse an alphanumeric string, then check what follows it. If a parenthesis follows, it parses the parenthetical expression and decides whether to create a `Macro` or `FCall` based on the `isKaTeX` function.

## For Tests

1. `parse "2(x + y)" -> [ MathSymbols "2" ParenthExpr [AlphaNum "x",MathSymbols (" + "),AlphaNum "y"]]`
2. `parse "2(x + y) (x - y)" ->  [ MathSymbols "2" ParenthExpr [AlphaNum "x",MathSymbols (" + "),AlphaNum "y"], MathSymbols (" (") ParenthExpr [AlphaNum "x",MathSymbols (" - "),AlphaNum "y"] ]`
3. `> parseETeX fr -> [Macro "frac" [PArg [AlphaNum "dp",Comma,AlphaNum "dt"]]]
`

## ParenthExpr Support

The parser correctly distinguishes between:
- Function calls (when an alphanumeric string is followed by parentheses): `f(x)` → `FCall "f" [PArg [AlphaNum "x"]]`
- KaTeX macros with parentheses: `sin(x)` → `Macro "sin" [PArg [AlphaNum "x"]]`
- Standalone parenthetical expressions: `(x + y)` → `ParenthExpr [AlphaNum "x", MathSymbols " + ", AlphaNum "y"]`

The parser now supports:
1. Function calls with lookahead parsing (`FCall` for non-KaTeX, `Macro` for KaTeX)
2. Standalone parenthetical expressions (`ParenthExpr`)
3. Proper handling of commas in arguments
4. Distinction between `PArg` (function/macro arguments) and `ParenthExpr` (standalone parentheses)

Summary of the changes made:
1. Added `ParenthExpr (List MathExpr)` variant to the `MathExpr` type
2. Created `standaloneParenthExprParser` that maps to `ParenthExpr`
3. Added the standalone parser to `mathExprParser` list
4. Added print case for `ParenthExpr`

## Test Scripts

Here are various bash scripts to test the parser functionality:

### Test Function Calls and KaTeX Macros
```bash
elm repl <<'EOF'
import ETeX.MathMacros2 exposing (parse, printList)
parse "yoyo(pi)"
parse "sin(pi)"
parse "\\sin{pi}"
Result.map printList (parse "yoyo(pi)")
Result.map printList (parse "sin(pi)")
Result.map printList (parse "\\sin{pi}")
EOF
```

### Test Comma Support
```bash
elm repl <<'EOF'
import ETeX.MathMacros2 exposing (parse, printList)
parse "f(1,2,3)"
Result.map printList (parse "f(1,2,3)")
EOF
```

### Test Parenthetical Expressions
```bash
elm repl <<'EOF'
import ETeX.MathMacros2 exposing (parse)
parse "2(x + y)"
parse "(x + y)"
parse "2(x + y) (x - y)"
EOF
```

### Test Mixed Expressions
```bash
elm repl <<'EOF'
import ETeX.MathMacros2 exposing (parse)
parse "f(x)"
parse "sin(x)"
parse "2(x + y)f(z)"
EOF
```

### Expected Results

1. **Macros**:  `\\sin{\\pi}` -> `Ok [Macro "sin" [Arg [Macro "pi" []]]]` -> Ok "\\sin{\\pi}"
2. **Parenthesized macros**: `parse "sin(x)"` → `Ok [Macro "sin" [PArg [AlphaNum "x"]]]` -> Ok "\\sin{x}"
3. **Function calls**: `parse "f(x)"` → `Ok [FCall "f" [PArg [AlphaNum "x"]]]`
4. **??**: With `\newcommand{\space}{\reals^{#1}}` I get 

3. **Parenthetical expressions**: `parse "(x + y)"` → `Ok [ParenthExpr [AlphaNum "x", MathSymbols " + ", AlphaNum "y"]]`
4. **Mixed expressions**: `parse "2(x + y)f(z)"` → `Ok [MathSymbols "2", ParenthExpr [AlphaNum "x", MathSymbols " + ", AlphaNum "y"], FCall "f" [PArg [AlphaNum "z"]]]`


> "frac(dp,dt)" -> [Macro "frac" [PArg [AlphaNum "dp",Comma,AlphaNum "dt"]]]
> "frac(dp,dt)" -> [Macro "frac" [PArg [AlphaNum "dp"] ,Comma, PArg [AlphaNum "dt"]]] -> "\\frac{dp}{dt}"

PARSED: Ok [Macro "sin" [Arg [AlphaNum "pi"]]]
BODY: [Arg [AlphaNum "pi"]]
"\\sin{pi}" : String
> transformETeX "\\sin(pi)"
PARSED: Ok [Macro "sin" [],ParenthExpr [AlphaNum "pi"]]
BODY: []

## Comma-Separated Argument Parsing Fix

The parser now correctly handles comma-separated arguments in function calls:

1. **"frac(dp,dt)"** → parses as `[Macro "frac" [PArg [AlphaNum "dp"], Comma, PArg [AlphaNum "dt"]]]` → prints as `"\frac{dp,dt}"`
2. **"f(x,y,z)"** → parses as function call with comma-separated args → prints as `"f(x,y,z)"`
3. **"sin(x)"** → parses as KaTeX macro → prints as `"\sin{x}"`
4. **"yoyo(a,b)"** → parses as function call → prints as `"yoyo(a,b)"`

The key improvements made:
1. Created a proper comma-separated argument parser using `sepByComma` helper
2. Fixed the circular dependency by creating `alphaNumWithoutLookaheadParser`
3. Updated the print functions to handle comma-separated arguments correctly
4. Macros with comma-separated args in parentheses now convert to a single brace pair with commas inside

## KaTeX Macro Printing with Separate Braces

The solution now correctly handles any KaTeX function with comma-separated arguments:

1. **"frac(dp,dt)"** → `[Macro "frac" [PArg [AlphaNum "dp"], Comma, PArg [AlphaNum "dt"]]]` → **"\\frac{dp}{dt}"**
2. **"binom(n,k)"** → `[Macro "binom" [PArg [AlphaNum "n"], Comma, PArg [AlphaNum "k"]]]` → **"\\binom{n}{k}"**
3. **"overset(a,b)"** → `[Macro "overset" [PArg [AlphaNum "a"], Comma, PArg [AlphaNum "b"]]]` → **"\\overset{a}{b}"**
4. **"sin(x)"** → `[Macro "sin" [PArg [AlphaNum "x"]]]` → **"\\sin{x}"** (single argument)
5. **"f(x,y,z)"** → `[FCall "f" ...]` → **"f(x,y,z)"** (non-KaTeX function keeps parentheses)

The solution correctly:
- Identifies KaTeX macros using the `isKaTeX` function
- Parses comma-separated arguments as separate `PArg` items with `Comma` tokens between them
- Prints each argument in its own set of braces for KaTeX macros
- Preserves parentheses and commas for non-KaTeX function calls

This handles any KaTeX function of the form `f(a,b,c,...)` where `isKaTeX f` is true, converting it to the proper LaTeX format `\f{a}{b}{c}...`.

## Threading userMacroDict Through Parser

The parser has been successfully updated to thread the `userMacroDict` parameter through the entire parser chain:

1. **Added the `userMacroDict` parameter** to `alphaNumWithLookaheadParser` and updated it to check both `isKaTeX` and `isUserDefinedMacro`.

2. **Threaded the dictionary through all parsers** that needed it:
   - `mathExprParser`
   - `macroParser`
   - `argParser`
   - `standaloneParenthExprParser`
   - `subscriptParser`
   - `superscriptParser`
   - `decoParser`
   - `functionArgsParser`
   - `functionArgListParser`
   - `newCommandParser`, `newCommandParser1`, `newCommandParser2`

3. **Created wrapper functions** to maintain backward compatibility:
   - `parse` now calls `parseWithDict` with the provided dictionary
   - `parseMany` now accepts the dictionary parameter

4. **Removed unused parsers** that were causing type errors:
   - `leftParenParser`
   - `rightParenParser`
   - `parentheticalExprParser`
   - `parentheticalExprParserM`
   - `alphaNumParser`

5. **Added helper functions**:
   - `isUserDefinedMacro` to check if a name is in the user macro dictionary

The parser now correctly handles both KaTeX macros and user-defined macros when parsing function-like syntax with parentheses. When tested with `Dict.empty`, it maintains the same behavior as before, correctly parsing expressions like `"frac(dp,dt)"` as a KaTeX macro with separate brace-enclosed arguments.

# TODO

INCOMPLETE:

- expandMacroWithDict (line 209)
- replaceParam: (line 320)
Example of a test:

```bash
elm repl <<'EOF'                                                                                                                                                                                                                                                                                            │
│   import ETeX.Transform exposing (..)                                                                                                                                                                                                                                                                         │
│   evalStr testMacroDict "set(1,2,3)"                                                                                                                                                                                                                                                                          │
│   EOF 
````

```bash
elm repl <<'EOF'
import ETeX.Transform exposing (..)
evalStr testMacroDict "set(x in R, x > 0)"
EOF  
```

## Macro Arity Handling

The parser now correctly handles macros with different arities when processing comma-separated arguments in parentheses:

### Single-Argument Macros (Arity 1)
For macros with arity 1, all content between parentheses (including commas) is treated as a single argument:
- **`set(1,2,3)`** → `\{ {1,2,3} \}` - The entire "1,2,3" is kept together as one argument
- **`set(x in R, x > 0)`** → `\{ {x \in R, x > 0} \}` - Complex expressions with commas work correctly
- **`space(n+1)`** → `\mathbb{R}^{{n+1}}` - Expressions are passed as a single unit

### Multi-Argument Macros (Arity 2+)
For macros with arity 2 or more, content is parsed as comma-separated arguments:
- **`sett(x in reals, x > 0)`** → `\{\ {x \in \mathbb{R}} \ | \ { x > 0}\ \}` - Two distinct arguments separated by comma
- **`frac(dp,dt)`** → `\frac{dp}{dt}` - Each argument gets its own set of braces

### Implementation Details
The `expandMacroWithDict` function checks the macro's arity:
- If arity is 1: Uses `flattenForSingleArg` to combine all PArg contents and commas into a single Arg
- If arity is 2+: Uses `extractMacroArgs` to extract each PArg as a separate Arg, skipping Comma tokens

This ensures that macros behave correctly based on their defined parameter count, matching standard LaTeX macro behavior.

## Automatic Arity Deduction

The parser now automatically deduces macro arity from the macro body by finding the highest parameter number:
- If a macro body contains `#1`, the arity is at least 1
- If it contains `#2`, the arity is at least 2
- And so on...

This makes the system more robust as it doesn't rely on the `[n]` syntax being parsed correctly. The `findMaxParam` function recursively searches through all MathExpr nodes to find parameter references.

Examples:
- `\newcommand{\nat}{\mathbb{N}}` → arity 0 (no parameters)
- `\newcommand{\set}{\{ #1 \}}` → arity 1 (contains #1)
- `\newcommand{\sett}{\{\ #1 \ | \ #2\ \}}` → arity 2 (contains #1 and #2)

This deduction happens in the `makeEntry` function when building the macro dictionary, ensuring that all macros have the correct arity regardless of how they were defined.

## Simplified Macro Syntax

The parser now supports a simplified macro syntax that's much cleaner than the verbose `\newcommand` format:

```
nat:      mathbb N
reals:    mathbb R
space:    reals^{#1}
set:      \{ #1 \}
sett:     \{\ #1 \ | \ #2 \ \}
```

### Usage

```elm
import ETeX.Transform exposing (..)

-- Define macros using simple syntax
lines = 
    [ "nat:      mathbb N"
    , "reals:    mathbb R"
    , "space:    reals^{#1}"
    , "set:      \\{ #1 \\}"
    , "sett:     \\{\\ #1 \\ | \\ #2 \\ \\}"
    ]

-- Create dictionary
dict = makeMacroDictFromSimpleLines lines

-- Use the macros
evalStr dict "set(1,2,3)"         -- → "\{ {1,2,3} \}"
evalStr dict "sett(a,b)"          -- → "\{\ {a} \ | \ {b} \ \}"
evalStr dict "space(n)"           -- → "\mathbb{R}^{{n}}"
```

### Features

1. **Clean syntax**: Just `name: body` instead of `\newcommand{\name}{body}`
2. **Auto-conversion**: Common patterns like `mathbb N` are automatically converted to `\mathbb{N}`
3. **Macro references**: Macros can reference other macros (e.g., `space` uses `reals`)
4. **Automatic arity**: The arity is still deduced from parameter usage in the body

### Implementation

The `parseSimpleMacro` function:
1. Splits the line on `:`
2. Processes the body to handle common shortcuts (like `mathbb N` → `\mathbb{N}`)
3. Converts to standard `\newcommand` format
4. Uses the existing parser infrastructure

This makes it much easier to define mathematical macros in documents or configuration files.

### Robust Parsing Implementation

The parser now uses a tokenization approach with lookahead to make intelligent decisions:

1. **Tokenization**: The body is first tokenized into meaningful units:
   - `SimpleWord`: Alphabetic sequences
   - `SimpleSpace`: Whitespace
   - `SimpleSymbol`: Single symbols
   - `SimpleBrace`: Brace-enclosed content
   - `SimpleParam`: Parameter references like `#1`
   - `SimpleBackslash`: Literal backslashes

2. **Context-Aware Processing**: The parser maintains a list of known macro names and uses lookahead to identify patterns:
   - `mathbb N` → `\mathbb{N}` (recognizes the mathbb pattern)
   - `reals^{#1}` → `\reals^{#1}` (when `reals` is a known macro)
   - `sin(x)` → `\sin(x)` (recognizes KaTeX commands)

3. **Progressive Building**: Macros are added to the dictionary one by one, so later macros can reference earlier ones:
   ```elm
   lines = [ "nat: mathbb N", "reals: mathbb R", "space: reals^{#1}" ]
   -- When parsing "space", it knows "reals" is a macro
   ```

This approach is much more reliable than simple string replacement and correctly handles complex macro bodies with mixed content.

## Mixed Format Support

The `makeMacroDict` function now accepts both traditional `\newcommand` format and the simplified `name: body` format in the same input:

```elm
mixedMacros = """
\\newcommand{\\nat}{\\mathbb{N}}
reals: mathbb R
\\newcommand{\\set}[1]{\\{ #1 \\}}
sett: \\{ #1 \\ | \\ #2 \\ \\}
space: reals^{#1}
"""

dict = makeMacroDict mixedMacros
```

### How It Works

1. **Format Detection**: Each line is checked to determine its format:
   - Lines starting with `\newcommand` → traditional format
   - Lines containing `:` → simplified format
   - Other lines are skipped (allows comments and blank lines)

2. **Progressive Building**: The dictionary is built line by line, so later macros can reference earlier ones regardless of format

3. **Consistent Parsing**: Both formats ultimately use the same parsing infrastructure and arity deduction

This allows gradual migration from old to new format, or mixing formats based on preference. The simplified format is great for quick definitions, while the traditional format might be preferred for complex macros or when copying from existing LaTeX documents.

## Function-Style to Brace Conversion for Multi-Argument KaTeX Macros

The simple macro syntax now properly handles KaTeX commands that require multiple arguments in braces:

```elm
-- Define a macro using frac with parentheses
macros = makeMacroDict "pder: frac(partial #1, partial #2)"

-- Use it
evalStr macros "pder(S,E)"
-- Result: "\frac{\partial {S}}{ \partial {E}}"
```

### How It Works

When processing simple macro bodies, the parser detects KaTeX commands that need brace conversion:
- `frac(a,b)` → `\frac{a}{b}`
- `binom(n,k)` → `\binom{n}{k}`
- `overset(a,b)` → `\overset{a}{b}`

The following commands are automatically converted:
- `frac`, `tfrac`, `dfrac`, `cfrac`
- `binom`, `dbinom`, `tbinom`
- `overset`, `underset`, `stackrel`

This allows natural function-style syntax in macro definitions while producing correct LaTeX output.