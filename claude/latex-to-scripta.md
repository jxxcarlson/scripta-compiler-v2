# Guidelines for Converting LaTeX to Scripta

## Environment Conversion

Environments like the one below (1a) should be converted to their Scripta equivalents (1b)


1a.

```latex
\begin{equation}
H_0\psi_0 + \epsilon H_0 \psi_1 + \epsilon V\psi_0
=
E_0\psi_0 + \epsilon E_0 \psi_1 + \epsilon E_1 \psi_0
\end{equation}
```

1b.

```scripta
|equation
H_0 psi_0 + epsilon H_0 psi_1 + epsilon V psi_0
=
E_0 psi_0 + epsilon E_0 psi_1 + epsilon E_1 psi_0
```

See if you an use the pattern you see here to to make other conversions.

## Exceptions

A construct like `\label{eq:1}` should be left untouched.

Also leave the macros `\left(` and `\right)` untouched as well 
as similar ones like `\left[` and `\right]`.

A macro with arguments like `\frac{a}{b}` should be converted to `frac(a, b)`.

