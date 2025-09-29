module TestFigure exposing (main)

import Browser
import Html exposing (Html, div, h1, h2, pre, text)
import Html.Attributes exposing (style)
import Render.Export.LaTeXToScripta as L2S


main : Program () () ()
main =
    Browser.sandbox
        { init = ()
        , update = \_ model -> model
        , view = view
        }


view : () -> Html ()
view _ =
    let
        input =
            """\\begin{figure}[h]
  \\centering
  \\includegraphics[width=0.5\\textwidth]{hummingbird.jpg}
  \\caption{A hummingbird drinking from a flower.}
  \\label{fig:hummingbird}
\\end{figure}
"""

        expectedOutput =
            """| image caption:A hummingbird drinking from a flower.
hummingbird.jpg"""

        actualOutput =
            L2S.translate input

        isCorrect =
            String.trim actualOutput == String.trim expectedOutput
    in
    div
        [ style "padding" "20px"
        , style "font-family" "monospace"
        ]
        [ h1 [] [ text "Test: \\\\begin{figure} environment" ]
        , h2 [] [ text "Input:" ]
        , pre
            [ style "background" "#f0f0f0"
            , style "padding" "10px"
            , style "white-space" "pre-wrap"
            ]
            [ text input ]
        , h2 [] [ text "Expected Output:" ]
        , pre
            [ style "background" "#e0ffe0"
            , style "padding" "10px"
            , style "white-space" "pre-wrap"
            ]
            [ text expectedOutput ]
        , h2 [] [ text "Actual Output:" ]
        , pre
            [ style "background" (if isCorrect then "#e0ffe0" else "#ffe0e0")
            , style "padding" "10px"
            , style "white-space" "pre-wrap"
            ]
            [ text actualOutput ]
        , h2
            [ style "color" (if isCorrect then "green" else "red") ]
            [ text (if isCorrect then "✓ Test Passed" else "✗ Test Failed") ]
        ]