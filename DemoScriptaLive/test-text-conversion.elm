module TestTextConversion exposing (main)

import Html exposing (..)
import Html.Attributes exposing (style)
import Render.Export.LaTeXToScripta as L2S

main =
    div [ style "padding" "20px", style "font-family" "monospace" ]
        [ h1 [] [ text "LaTeX \\text{} Conversion Test" ]
        , testCase "Test 1: Simple text in math" test1
        , testCase "Test 2: Text in align block" test2
        , testCase "Test 3: Complex math with text" test3
        ]

testCase title input =
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
            [ strong [] [ text "Scripta Output:" ]
            , pre [] [ text output ]
            ]
        ]

test1 =
    "$10 \\text{ degrees F}$"

test2 =
    """\\begin{align}
\\ket{0} & \\text{ undecayed}\\\\
\\ket{1} & \\text{ decayed}
\\end{align}"""

test3 =
    """The temperature is $T = 10 \\text{ K}$ and pressure is $P = 1 \\text{ atm}$."""