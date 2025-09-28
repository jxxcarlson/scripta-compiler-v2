module TestAll exposing (main)

import Html exposing (..)
import Html.Attributes exposing (style)
import Render.Export.LaTeXToScripta2 as L2S

main =
    div [ style "padding" "20px", style "font-family" "monospace" ]
        [ h1 [] [ text "LaTeX to Scripta Conversion Tests" ]
        , testCase "Test 1: Simple paragraph"
            "Hello world\n"
            "Hello world"
        , testCase "Test 2: Section with content"
            """\\section{Introduction}

This is some text.
"""
            """# Introduction

This is some text."""
        , testCase "Test 3: Nested sections"
            """\\section{Main}

\\subsection{Sub}

Content here
"""
            """# Main

## Sub

Content here"""
        , testCase "Test 4: Simple math"
            "$x^2 + y^2 = z^2$\n"
            "$x^2 + y^2 = z^2$"
        , testCase "Test 5: Compact items"
            "\\compactItem{Butter }\n\\compactItem{Salt }\n\\compactItem{Pepper}\n"
            "- Butter\n- Salt\n- Pepper"
        , testCase "Test 6: Itemize list"
            """\\begin{itemize}
\\item First
\\item Second
\\end{itemize}
"""
            """- First
- Second"""
        , testCase "Test 7: Enumerate list"
            """\\begin{enumerate}
\\item First
\\item Second
\\end{enumerate}
"""
            """. First
. Second"""
        , testCase "Test 8: Align environment"
            """\\begin{align}
x &= 1\\\\
y &= 2
\\end{align}
"""
            """| aligned
x &= 1\\\\
y &= 2"""
        , testCase "Test 9: href link"
            "\\href{https://example.com}{link text}\n"
            "[link link text https://example.com]"
        , testCase "Test 10: Image"
            "\\includegraphics{image.png}\n"
            "[image image.png]"
        , testCase "Test 11: Code block"
            """\\begin{lstlisting}
def hello():
    print("Hello")
\\end{lstlisting}
"""
            """| code
def hello():
    print("Hello")"""
        , testCase "Test 12: Theorem"
            """\\begin{theorem}[Pythagorean]
In a right triangle, $a^2 + b^2 = c^2$.
\\end{theorem}
"""
            """| theorem Pythagorean
In a right triangle, $a^2 + b^2 = c^2$."""
        , testCase "Test 13: Mixed content"
            """\\section{Math}

The equation $E = mc^2$ is famous.

\\begin{equation}
\\frac{d}{dx} \\sin(x) = \\cos(x)
\\end{equation}
"""
            """# Math

The equation $E = mc^2$ is famous.

| equation
frac(d, dx) sin(x) = cos(x)"""
        , testCase "Test 14: Nested lists"
            """\\begin{itemize}
\\item Outer
\\begin{itemize}
\\item Inner
\\end{itemize}
\\end{itemize}
"""
            """- Outer
  - Inner"""
        , testCase "Test 16: Equation with fraction"
            "\\begin{equation}\nM  = \\frac{R\\sigma^2}{ G}\n\\end{equation}\n"
            "| equation\nM  = frac(R sigma^2, G)"
        , testCase "Test 15: Complex document"
            """\\section{Introduction}

This is \\textbf{important}.

\\subsection{Details}

\\begin{itemize}
\\item Point 1
\\item Point 2
\\end{itemize}

See \\href{https://example.com}{this link} for more.
"""
            """# Introduction

This is [b important].

## Details

- Point 1
- Point 2

See [link this link https://example.com] for more."""
        ]

testCase : String -> String -> String -> Html msg
testCase title input expected =
    let
        output = L2S.translate input |> Debug.log ("Output for " ++ title)
        passed = output == expected
        -- Check if the difference is only whitespace
        normalizeWhitespace s =
            s |> String.words |> String.join " " |> String.trim
        whitespaceOnly =
            not passed && (normalizeWhitespace output == normalizeWhitespace expected)
        backgroundColor =
            if passed then
                "#e0f0e0"
            else if whitespaceOnly then
                "#f0d0f0"  -- Light magenta for whitespace differences
            else
                "#ffe0e0"
    in
    div [ style "border" "1px solid #ccc", style "padding" "10px", style "margin" "10px 0" ]
        [ h3 [] [ text title ]
        , div [ style "background" "#f0f0f0", style "padding" "10px" ]
            [ strong [] [ text "LaTeX Input:" ]
            , pre [] [ text input ]
            ]
        , div [ style "background" "#e0f0e0", style "padding" "10px" ]
            [ strong [] [ text "Expected:" ]
            , pre [] [ text expected ]
            ]
        , div [ style "background" backgroundColor, style "padding" "10px" ]
            [ strong [] [ text "Actual Output:" ]
            , pre [] [ text (if String.isEmpty output then "(empty string)" else output) ]
            , div []
                [ if passed then
                    span [ style "color" "green", style "font-weight" "bold" ] [ text " ✓ PASS" ]
                  else if whitespaceOnly then
                    span [ style "color" "purple", style "font-weight" "bold" ] [ text " ✗ FAIL: WHITE SPACE" ]
                  else
                    span [ style "color" "red", style "font-weight" "bold" ] [ text " ✗ FAIL" ]
                ]
            ]
        ]