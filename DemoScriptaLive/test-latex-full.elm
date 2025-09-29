module TestLatexFull exposing (main)

import Html exposing (..)
import Html.Attributes exposing (style)
import Render.Export.LaTeXToScripta as L2S

main =
    div [ style "padding" "20px", style "font-family" "monospace" ]
        [ h1 [] [ text "Full LaTeX to Scripta Conversion Test" ]
        , testCase
        ]

testCase =
    let
        input = """\\newcommand{\\ket}[1]{| #1 \\rangle}
\\newcommand{\\bra}[1]{\\langle #1 |}

\\section{Schroedinger's Cat} \\label{schroedingers-cat}

Suppose the radioactive atom can be in two states:

\\begin{align}
\\ket{0} & \\text{ undecayed}\\\\
\\ket{1} & \\text{ decayed}
\\end{align}

After setting up the coupling (atom decay triggers poison release), the joint system evolves into:

\\begin{equation}
\\ket{\\Psi} = \\tfrac{1}{{\\sqrt{2}}}( \\ket{0} \\otimes \\ket{\\text{alive}}  + \\ket{1} \\otimes \\ket{\\text{dead}})
\\end{equation}"""

        -- Then convert the full document
        fullConversion = L2S.translate input
    in
    div [ style "border" "1px solid #ccc", style "padding" "10px", style "margin" "10px 0" ]
        [ h3 [] [ text "LaTeX Source:" ]
        , pre [ style "background" "#f0f0f0", style "padding" "10px" ]
            [ text input ]

        , h3 [] [ text "Full Scripta Translation:" ]
        , pre [ style "background" "#e0e0f0", style "padding" "10px" ]
            [ text fullConversion ]
        ]