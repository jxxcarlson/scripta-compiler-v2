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

1. **Function calls**: `parse "f(x)"` → `Ok [FCall "f" [PArg [AlphaNum "x"]]]`
2. **KaTeX macros**: `parse "sin(x)"` → `Ok [Macro "sin" [PArg [AlphaNum "x"]]]`
3. **Parenthetical expressions**: `parse "(x + y)"` → `Ok [ParenthExpr [AlphaNum "x", MathSymbols " + ", AlphaNum "y"]]`
4. **Mixed expressions**: `parse "2(x + y)f(z)"` → `Ok [MathSymbols "2", ParenthExpr [AlphaNum "x", MathSymbols " + ", AlphaNum "y"], FCall "f" [PArg [AlphaNum "z"]]]`