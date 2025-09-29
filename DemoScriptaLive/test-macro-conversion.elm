module TestMacroConversion exposing (main)

import Html exposing (..)
import Html.Attributes exposing (style)
import Render.Export.LaTeXToScripta as L2S

main =
    div [ style "padding" "20px", style "font-family" "monospace" ]
        [ h1 [] [ text "LaTeX Macro Conversion Test" ]
        , testCase "User-defined macros"
            """\\newcommand{\\ket}[1]{| #1 \\rangle}
\\newcommand{\\bra}[1]{\\langle #1 |}

\\begin{equation}
\\ket{0} \\ne \\ket{1}
\\end{equation}"""
            """| mathmacros
ket: | #1 rangle
bra: langle #1 |

| equation
ket(0) ne ket(1)"""
        ]

testCase title input expected =
    let
        output = L2S.translate input
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
        , div [ style "background" (if output == expected then "#e0f0e0" else "#ffe0e0"), style "padding" "10px" ]
            [ strong [] [ text "Actual Output:" ]
            , pre [] [ text output ]
            , if output == expected then
                span [ style "color" "green", style "font-weight" "bold" ] [ text " ✓ PASS" ]
              else
                span [ style "color" "red", style "font-weight" "bold" ] [ text " ✗ FAIL" ]
            ]
        ]