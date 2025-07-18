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
1. **Function calls**: `parse "f(x)"` → `Ok [FCall "f" [PArg [AlphaNum "x"]]]`

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