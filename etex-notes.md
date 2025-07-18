# TeX Macro Forms

In TeX/LaTeX, a macro (control sequence) follows these rules:

1. **Control word**: `\` followed by letters only (a-z, A-Z)
   - Examples: `\alpha`, `\section`, `\LaTeX`
   - Ends when a non-letter is encountered
   - Multiple spaces after are treated as one space

2. **Control symbol**: `\` followed by a single non-letter character
   - Examples: `\$`, `\%`, `\{`, `\\`, `\ ` (backslash-space)
   - The character immediately ends the macro

So the general forms are:
- `\[a-zA-Z]+` (one or more letters)
- `\[^a-zA-Z]` (exactly one non-letter)

## Implementation Note

Looking at the parser in `src/Generic/MathMacro.elm:393-395`:

```elm
f0Parser : PA.Parser Context Problem MathExpr
f0Parser =
    second (symbol (Token "\\" ExpectingBackslash)) alphaNumParser_
        |> PA.map F0
```

This parses `\` followed by alphanumeric characters, which is slightly more permissive than standard TeX (which only allows letters).